#! /bin/bash

function tcinfo {
    local tc_case=$1
    local tc_exist=1

# -------
    if [ $tc_case == "bwp142003" ]; then 
        # Dujuan 2003
        TC_name=bwp142003
        date_start=2003090106
        date_end=2003090300
	real_sst=-1.2
	ndre_sst=-1.6
        local tc_exist=0
    fi
    if [ $tc_case == "bwp172005" ]; then 
        # Damrey 2005
        TC_name=bwp172005
        date_start=2005092406
        date_end=2005092612
	real_sst=-3.6
	ndre_sst=-5.9
        local tc_exist=0
    fi
    if [ $tc_case == "bwp022006" ]; then 
        # Chanchu 2006
        TC_name=bwp022006
        date_start=2006051606
        date_end=2006051800
	real_sst=-0.5
	ndre_sst=-1.2
        local tc_exist=0
    fi
    if [ $tc_case == "bwp072006" ]; then 
        # Prapiroon 2006
        TC_name=bwp072006
        date_start=2006080200
        date_end=2006080400
	real_sst=-2.1
	ndre_sst=-4.8
        local tc_exist=0
    fi
    if [ $tc_case == "bwp022008" ]; then 
        # Neoguri 2008
        TC_name=bwp022008
        date_start=2008041712
        date_end=2008041918
	real_sst=-0.4
	ndre_sst=-2.6
        local tc_exist=0
    fi
    if [ $tc_case == "bwp182008" ]; then 
        # Hagupit  2008
        TC_name=bwp182008
        date_start=2008092212
        date_end=2008092406
	real_sst=-1.3
	ndre_sst=-4.3
        local tc_exist=0
    fi
    if [ $tc_case == "bwp032009" ]; then 
        # Linfa 2009
        TC_name=bwp032009
        date_start=2009062000
        date_end=2009062118
	real_sst=-0.6
	ndre_sst=-2.6
        local tc_exist=0
    fi
    if [ $tc_case == "bwp152010" ]; then 
        # Megi 2010
        TC_name=bwp152010
        date_start=2010102118
        date_end=2010102318
	real_sst=-0.003
	ndre_sst=-0.8
        local tc_exist=0
    fi
    if [ $tc_case == "bwp112013" ]; then 
        # Utor 2013
        TC_name=bwp112013
        date_start=2013081218
        date_end=2013081418
	real_sst=-2.6
	ndre_sst=-3.5
        local tc_exist=0
    fi
    if [ $tc_case == "bwp102015" ]; then 
        # Linfa 2015
        TC_name=bwp102015
        date_start=2015070718
        date_end=2015070912
	real_sst=-0.6
	ndre_sst=-2.8
        local tc_exist=0
    fi
    if [ $tc_case == "bwp062016" ]; then 
        # Nida 2016
        TC_name=bwp062016
        date_start=2016073112
        date_end=2016080206
	real_sst=-0.6
	ndre_sst=-3.3
        local tc_exist=0
    fi
    if [ $tc_case == "bwp252016" ]; then 
        # Haima 2016
        TC_name=bwp252016
        date_start=2016102000
        date_end=2016102112
	real_sst=-0.7
	ndre_sst=-0.8
        local tc_exist=0
    fi
    if [ $tc_case == "bwp242017" ]; then 
        # Khanun 2017
        TC_name=bwp242017
        date_start=2017101406
        date_end=2017101606
	real_sst=-0.3
	ndre_sst=-1.3
        local tc_exist=0
    fi
# -------
    if [ $tc_case == "bwp092003" ]; then 
        # Imbudo 2003
        TC_name=bwp092003
        date_start=2003072300
        date_end=2003072412
	real_sst=-1.1
	ndre_sst=-4.0
        local tc_exist=0
    fi
    if [ $tc_case == "bwp122003" ]; then 
        # Krovanh 2003
        TC_name=bwp122003
        date_start=2003082312
        date_end=2003082506
	real_sst=-0.5
	ndre_sst=-5.3
        local tc_exist=0
    fi
    if [ $tc_case == "bwp072009" ]; then 
        # Molave 2009
        TC_name=bwp072009
        date_start=2009071712
        date_end=2009071900
	real_sst=-1.3
	ndre_sst=-3.1
        local tc_exist=0
    fi
    if [ $tc_case == "bwp202011" ]; then 
        # Nesat 2011
        TC_name=bwp202011
        date_start=2011092800
        date_end=2011093000
	real_sst=-0.4
	ndre_sst=-3.3
        local tc_exist=0
    fi
    if [ $tc_case == "bwp092012" ]; then 
        # Vicente 2012
        TC_name=bwp092012
        date_start=2012072206
        date_end=2012072406
	real_sst=-0.7
	ndre_sst=-6.0
        local tc_exist=0
    fi
    if [ $tc_case == "bwp142012" ]; then 
        # Kai-Tak 2012
        TC_name=bwp142012
        date_start=2012081518
        date_end=2012081712
	real_sst=-1.8
	ndre_sst=-2.6
        local tc_exist=0
    fi
    if [ $tc_case == "bwp242016" ]; then 
        # Sarika 2016
        TC_name=bwp242016
        date_start=2016101700
        date_end=2016101900
	real_sst=-2.3
	ndre_sst=-2.6
        local tc_exist=0
    fi
    if [ $tc_case == "bwp262018" ]; then 
        # Mangkhut 2018
        TC_name=bwp262018
        date_start=2018091506
        date_end=2018091700
	real_sst=-1.1
	ndre_sst=-2.3
        local tc_exist=0
    fi
# -------
    if [ $tc_case == "bwp102005" ]; then 
        # Sanvu 2005
        TC_name=bwp102005
        date_start=2005081200
        date_end=2005081312
	real_sst=-0.6
	ndre_sst=-2.6
        local tc_exist=0
    fi
    if [ $tc_case == "bwp162009" ]; then 
        # Koppu 2009
        TC_name=bwp162009
        date_start=2009091312
        date_end=2009091506
	real_sst=-0.6
	ndre_sst=-3.0
        local tc_exist=0
    fi
    if [ $tc_case == "bwp042010" ]; then 
        # Chanthu 2010
        TC_name=bwp042010
        date_start=2010072012
        date_end=2010072218
	real_sst=-1.9
	ndre_sst=-4.0
        local tc_exist=0
    fi
    if [ $tc_case == "bwp062013" ]; then 
        # Rumbia 2013
        TC_name=bwp062013
        date_start=2013063012
        date_end=2013070206
	real_sst=-2.5
	ndre_sst=-2.5
        local tc_exist=0
    fi
    if [ $tc_case == "bwp172013" ]; then 
        # Usagi 2013
        TC_name=bwp172013
        date_start=2013092106
        date_end=2013092300
	real_sst=-0.8
	ndre_sst=-1.9
        local tc_exist=0
    fi
    if [ $tc_case == "bwp092014" ]; then 
        # Rammasun 2014
        TC_name=bwp092014
        date_start=2014071700
        date_end=2014071900
	real_sst=-1.5
	ndre_sst=-6.2
        local tc_exist=0
    fi
    if [ $tc_case == "bwp152014" ]; then 
        # Kalmaegi 2014
        TC_name=bwp152014
        date_start=2014091418
        date_end=2014091612
	real_sst=-2.5
	ndre_sst=-3.0
        local tc_exist=0
    fi
    if [ $tc_case == "bwp222015" ]; then 
        # Mujigae 2015
        TC_name=bwp222015
        date_start=2015100218
        date_end=2015100418
	real_sst=-0.0
	ndre_sst=-1.5
        local tc_exist=0
    fi
    if [ $tc_case == "bwp152017" ]; then 
        #Hato 2017
        TC_name=bwp152017
        date_start=2017082200
        date_end=2017082318
	real_sst=-0.5
	ndre_sst=-1.2
        local tc_exist=0
    fi
# -------
    if [ $tc_exist -eq 1 ]; then
        echo "Error: No such TC case"
        exit 1
    fi

}
