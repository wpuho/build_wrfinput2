        subroutine Ho_readetopo(zt,lon,lat,lonL,lonR,latB,latT)

                use netcdf
        implicit none
!================================================        
        integer :: i,j
        integer :: n,m
        integer,parameter :: nlons = 10800, nlats = 5400
        real    :: terrain_360(nlons,nlats),lon_360(nlons)
!========== For user define
        integer, parameter :: output = 1  ! 1 for GrADS, 2 for gmt
!        real, parameter    :: lonL = 100., lonR = 130. !   0-360
!        real, parameter    :: latB =  10., latT =  30. ! -90-90
        real :: lonL, lonR !   0-360
        real :: latB, latT ! -90-90
        real, dimension(:,:), allocatable  :: zt
        real, dimension(:), allocatable  :: lon, lat

        integer            :: ilonL,ilonR,ilatB,ilatT
        integer            :: lLON,lLAT
        integer            :: indexLON, indexLAT
        real               :: absLON(nlons), absLAT(nlats)
!==========
        integer :: ncid
        integer :: lat_varid, lon_varid, data_varid
        character(len = 50)          :: file_name
        character(len = *),parameter :: data_lon = "x"
        character(len = *),parameter :: data_lat = "y"
        character(len = *),parameter ::  data_zt = "z"

        real    :: latitude(nlats), longitude(nlons)
        real    :: terrain(nlons,nlats)

        integer :: start(2)
!================================================
        file_name = 'ETOPO2v2c_f4.nc'

        call check(nf90_open(file_name,nf90_nowrite,ncid))

        call check(nf90_inq_varid(ncid,data_lat,lat_varid))
        call check(nf90_inq_varid(ncid,data_lon,lon_varid))

        call check(nf90_get_var(ncid,lat_varid,latitude))
        call check(nf90_get_var(ncid,lon_varid,longitude))

        start = (/1,1/)

        call check(nf90_inq_varid(ncid,data_zt,data_varid))
        call check(nf90_get_var(ncid,data_varid,terrain,start))
!================================================
        ! For lonL
        absLON = abs(longitude-lonL)
        indexLON = minloc(absLON, DIM = 1, mask = absLON.ge.0.)

        if (indexLON.ne.1) then

          !ilonL = indexLON - 1
          ilonL = indexLON

        else

          ilonL = indexLON

        endif

        ! For lonR
        absLON = abs(longitude-lonR)
        indexLON = minloc(absLON, DIM = 1, mask = absLON.ge.0.)

        if (indexLON.ne.10800) then

          !ilonR = indexLON + 1
          ilonR = indexLON

        else

          ilonR = indexLON

        endif

        ! For latB
        absLAT = abs(latitude-latB)
        indexLAT = minloc(absLAT, DIM = 1, mask = absLAT.ge.0.)

        if (indexLAT.ne.1) then

          !ilatB = indexLAT - 1
        ilatB = indexLAT

        else

          ilatB = indexLAT

        endif

        ! For latT
        absLAT = abs(latitude-latT)
        indexLAT = minloc(absLAT, DIM = 1, mask = absLAT.ge.0.)

        if (indexLAT.ne.5400) then

          !ilatT = indexLAT + 1
          ilatT = indexLAT

        else

          ilatT = indexLAT

        endif
!================================================
        lLON = ilonR - ilonL + 1
        lLAT = ilatT - ilatB + 1

        allocate(zt(lLON,lLAT))
        allocate(lon(lLON))
        allocate(lat(lLAT))

        n = 0
        do i = ilonL,ilonR
          n = n + 1
          lon(n) = longitude(i)
        enddo
        
        m = 0
        do j = ilatB,ilatT
          m = m + 1
          lat(m) = latitude(j)
        enddo

        n = 0

        do i = ilonL,ilonR
          n = n + 1
          m = 0

        do j = ilatB,ilatT
          m = m + 1

          zt(n,m) = terrain(i,j)

        enddo
        enddo

        return
        end subroutine Ho_readetopo
