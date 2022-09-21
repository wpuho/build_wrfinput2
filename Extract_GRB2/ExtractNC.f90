!==========================================================
! This program EXTRACT data from the netcdf format file
! and convert it to netcdf/binary format.
!================================================
        program ExtractData

          use netcdf
        implicit none
!================================================
        integer,parameter :: nlons = 1440, nlats = 721
!        real, parameter :: dsst = -4.
!=======================
        integer,parameter :: opt = 2 ! 1 for nc, 2 for bin
        integer :: ncid, i, j
        integer :: x_dimid,y_dimid
        integer :: lat_varid, lon_varid, data_varid
        character(len = 50)          :: inp_file, out_file, tmp
        character(len = *),parameter :: lon_name     = "longitude"
        character(len = *),parameter :: lat_name     = "latitude"
        character(len = *),parameter :: target_inp   = "WTMP_surface"
!        character(len = *),parameter :: target_inp   = "TMP_surface"
        character(len = *),parameter :: target_out   = "SST"
        character(len = *),parameter :: units        = "K"
        character(len = *),parameter :: target_units = "Kelvin"

        real    :: var_INP(nlons,nlats), var_OUT(nlons,nlats)
        real    :: var_LANDSEA(nlons,nlats), var_ISST(nlons,nlats)
        real    :: sst_lon(nlons), sst_lat(nlats)

        integer :: start(2),dimids(2),count(2)
!=======================
        integer :: n
        
        character(len=32) :: header, idate
        integer :: ilen1,ilen2

        logical :: file_exists
!=======================
        real    :: sst_flag(nlons,nlats)
        real    :: mlon,mlat,nlon,nlat
        real    :: pmlon,pmlat,pnx,pny
        integer :: mx,my
        
!=======================
        integer, parameter ::  forward = 1
        real, dimension(:,:), allocatable :: shw_mask
        real, dimension(:), allocatable :: shw_lon, shw_lat
        real, parameter :: lonL = 108., lonR = 121., latB = 17., latT = 24.5
        !real, parameter :: lonL = 107., lonR = 117., latB = 17., latT = 23.

!        call Ho_readetopo(zt,terrain_lon,terrain_lat,lonL,lonR,latB,latT)
        call Ho_shwmask(shw_mask,shw_lon,shw_lat,lonL,lonR,latB,latT)


!=======================
        !inp_file = 'gfs.0p25.2017082112.f000.nc'

        !call check(nf90_open(&
!&'./invariant_SST.nc',nf90_nowrite,ncid))

        !start = (/1,1/)
        !count = (/nlons,nlats/)
        !call check(nf90_inq_varid(ncid,'LAND_surface',data_varid))
        !call check(nf90_get_var(ncid,data_varid,var_LANDSEA,start))

        !call check(nf90_close(ncid))

        n = 0
        
        call get_environment_variable('var', header)
        call get_environment_variable('DATE',idate)

        ilen1 = len_trim(header)
        ilen2 = len_trim(idate)
        
        inp_file = header(1:ilen1)//"_"//idate(1:ilen2)
        out_file = 'SST+-0_'//idate(1:ilen2)
        
        ilen1 = len_trim(inp_file)
        ilen2 = len_trim(out_file)
 
        print*,inp_file(1:ilen1) 
        INQUIRE(FILE=inp_file(1:ilen1)//'.nc', EXIST=file_exists)
        if (file_exists.eqv..TRUE.) then

            n = n + 1

!======== Get data from input file
            call check(nf90_open(inp_file(1:ilen1)//'.nc',nf90_nowrite,ncid))

            start = (/1,1/)
            count = (/nlons,nlats/)

            call check(nf90_inq_varid(ncid,target_inp,data_varid))
            call check(nf90_get_var(ncid,data_varid,var_INP,start))
            
            call check(nf90_inq_varid(ncid,'LAND_surface',data_varid))
            call check(nf90_get_var(ncid,data_varid,var_LANDSEA,start))
            
            call check(nf90_inq_varid(ncid,lon_name,data_varid))
            call check(nf90_get_var(ncid,data_varid,sst_lon,start))
            
            call check(nf90_inq_varid(ncid,lat_name,data_varid))
            call check(nf90_get_var(ncid,data_varid,sst_lat,start))

            call check(nf90_close(ncid))

            !var_OUT = var_INP

            !if (n.eq.1) then

            !  var_ISST = var_INP ! Initial SST

            !endif
            do i = 1,nlons
            do j = 1,nlats

!              if (var_LANDSEA(i,j).eq.1.) then
              if (var_INP(i,j) .eq. 9.999E20 ) then
        !       var_OUT(i,j) = var_INP(i,j) 
                var_OUT(i,j) = -999.9 !LANDMASK

              else

         !       var_OUT(i,j) = -1E30 !LANDMASK
                var_OUT(i,j) = var_INP(i,j)
              endif

            enddo
            enddo

!================================================
            !call Ho_ncregion
            if (forward.eq.1) then
            mlon = maxval(shw_lon) - minval(shw_lon)
            mlat = maxval(shw_lat) - minval(shw_lat)
            nlon = maxval(sst_lon) - minval(sst_lon)
            nlat = maxval(sst_lat) - minval(sst_lat)

            mx = size(shw_mask,1)
            my = size(shw_mask,2)

            do i = 1,mx
              do j = 1,my

                if (shw_mask(i,j).eq.1.) then
                  pmlon = float(i)*mlon/float(mx) + minval(shw_lon)
                  pmlat = float(j)*mlat/float(my) + minval(shw_lat)
                  pnx = (pmlon-minval(sst_lon))*float(nlons)/nlon
                  pny = (pmlat-minval(sst_lat))*float(nlats)/nlat

                  if (sst_flag(int(ceiling(pnx)),int(ceiling(pny))).eq.0.) then

                    if (var_OUT(int(ceiling(pnx)),int(ceiling(pny))).ne.-999.9) then
                      var_OUT(int(ceiling(pnx)),int(ceiling(pny))) = &
&var_OUT(int(ceiling(pnx)),int(ceiling(pny))) + (dsst)
                      sst_flag(int(ceiling(pnx)),int(ceiling(pny))) = 1
                    endif

                  endif

                endif

              enddo
            enddo

            sst_flag(:,:) = 0.
            endif

!======== Create output file 
            if (opt.eq.1) then ! for netcdf format
        print*,var_OUT(1196,430)
              call check(nf90_create(out_file(1:ilen2)//'.nc',nf90_clobber,ncid))

!======== Define dimension
              call check(nf90_def_dim(ncid,lon_name,nlons,x_dimid))
              call check(nf90_def_dim(ncid,lat_name,nlats,y_dimid))
              dimids = (/x_dimid, y_dimid/)

              call check(nf90_def_var(ncid,target_out,nf90_real,dimids,data_varid))

              call check(nf90_put_att(ncid,data_varid,units,target_units))
              call check(nf90_enddef(ncid))

!======== Put variable into ouptput file
              call check(nf90_put_var(ncid,data_varid,var_OUT,&
&start=start,count=count))

              call check(nf90_close(ncid))

!========
            elseif (opt.eq.2) then !for binary format
        print*,var_OUT(500,500)
              open(11,file=out_file(1:ilen2)//'.bin',form='unformatted',access='direct',&
&recl=4*nlons*nlats*2)
              
              write(11,rec=1) var_OUT, var_LANDSEA
!              write(11,rec=2) var_LANDSEA

              close(11)

            endif

!========
            print*,'END of ExtractNC.f90'

        else

            print*, 'ERROR: NO INPUT FILE'
            call exit(3)


        endif


!================================================
        contains

          include 'Ho_shwmask.f90'

          subroutine check(status)
          integer, intent(in) :: status

          if (status /= nf90_noerr) then

            print *, trim(nf90_strerror(status))
            stop "Stopped"

          end if

          end subroutine check
!================================================

        end program

!gfortran readnc.f90 -o readnc `nf-config --fflags --flibs`
