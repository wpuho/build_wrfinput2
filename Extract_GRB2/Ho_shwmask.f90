        subroutine Ho_shwmask(shw_mask,lon,lat,lonL,lonR,latB,latT)

                use netcdf
        implicit none
!================================================        
        integer :: i,j
        integer :: n,m
!        integer,parameter :: nlons = 754, nlats = 322
!        integer,parameter :: nlons = 481, nlats = 277
        integer,parameter :: nlons = 301, nlats = 241
!========== For user define
        integer, parameter :: output = 1  ! 1 for GrADS, 2 for gmt
!        real, parameter    :: lonL = 100., lonR = 130. !   0-360
!        real, parameter    :: latB =  10., latT =  30. ! -90-90
        real :: lonL, lonR !   0-360
        real :: latB, latT ! -90-90
        real, dimension(:,:), allocatable  :: shw_mask
        real, dimension(:), allocatable  :: lon, lat

        integer            :: ilonL,ilonR,ilatB,ilatT
        integer            :: lLON,lLAT
        integer            :: indexLON, indexLAT
        real               :: absLON(nlons), absLAT(nlats)
!==========
        integer :: ncid
        integer :: lat_varid, lon_varid, data_varid
        character(len = 50)          :: file_name
        character(len = *),parameter :: data_lon = "lon"
        character(len = *),parameter :: data_lat = "lat"
        character(len = *),parameter :: data_shw = "shw_mask"

        real    :: latitude(nlons,nlats), longitude(nlons,nlats)
        real    :: shw(nlons,nlats)

        integer :: start(2)
!================================================
        file_name = 'shw_region.nc'

        call check(nf90_open(file_name,nf90_nowrite,ncid))

        call check(nf90_inq_varid(ncid,data_lat,lat_varid))
        call check(nf90_inq_varid(ncid,data_lon,lon_varid))

        call check(nf90_get_var(ncid,lat_varid,latitude))
        call check(nf90_get_var(ncid,lon_varid,longitude))

        start = (/1,1/)

        call check(nf90_inq_varid(ncid,data_shw,data_varid))
        call check(nf90_get_var(ncid,data_varid,shw,start))
!================================================
        ! For lonL
        absLON = abs(longitude(:,1)-lonL)
        indexLON = minloc(absLON, DIM = 1, mask = absLON.ge.0.)

        if (indexLON.ne.1) then

          !ilonL = indexLON - 1
          ilonL = indexLON

        else

          ilonL = indexLON

        endif

        ! For lonR
        absLON = abs(longitude(:,1)-lonR)
        indexLON = minloc(absLON, DIM = 1, mask = absLON.ge.0.)

        if (indexLON.ne.nlons) then

          !ilonR = indexLON + 1
          ilonR = indexLON

        else

          ilonR = indexLON

        endif

        ! For latB
        absLAT = abs(latitude(1,:)-latB)
        indexLAT = minloc(absLAT, DIM = 1, mask = absLAT.ge.0.)

        if (indexLAT.ne.1) then

          !ilatB = indexLAT - 1
        ilatB = indexLAT

        else

          ilatB = indexLAT

        endif

        ! For latT
        absLAT = abs(latitude(1,:)-latT)
        indexLAT = minloc(absLAT, DIM = 1, mask = absLAT.ge.0.)

        if (indexLAT.ne.nlats) then

          !ilatT = indexLAT + 1
          ilatT = indexLAT

        else

          ilatT = indexLAT

        endif
!================================================
        lLON = ilonR - ilonL + 1
        lLAT = ilatT - ilatB + 1

        allocate(shw_mask(lLON,lLAT))
        allocate(lon(lLON))
        allocate(lat(lLAT))

        n = 0
        do i = ilonL,ilonR
          n = n + 1
          lon(n) = longitude(i,1)
        enddo
        
        m = 0
        do j = ilatB,ilatT
          m = m + 1
          lat(m) = latitude(1,j)
        enddo

        n = 0

        do i = ilonL,ilonR
          n = n + 1
          m = 0

        do j = ilatB,ilatT
          m = m + 1

          shw_mask(n,m) = shw(i,j)

        enddo
        enddo

        return
        end subroutine Ho_shwmask
