#!/bin/bash
#
# edited by Semigod
#
# 2020/08/16

dataPath="../mapsData"
dataFile="${dataPath}/${1:-maps.data}"
dataTempFile="${dataPath}/${dataFile}.tmp"
dataCsvFile="${dataPath}/${dataFile}.csv"

if [ ! -f ${dataFile} ]; then
  echo -e "<!> ${dataFile} 不存在 <!>\n"
  exit
fi

#cat ${dataFile} | sed 's/\t//g' | grep "^全家"

## normalize
#cat ${dataFile} | sed 's/\t//g' | grep "^全家" | sed 's/^/店舖名稱：\ /'
sed -e 's/\ \t//' -e 's/：/:/' -e 's/^\(全家.*$\)/店舖名稱:\1/' -e 's/^店舖號/店舖編號/' -e 's/臺/台/g' ${dataFile} > ${dataTempFile}

## index
index () {
  key=${1}
  cat ${dataTempFile} | grep ${key} | cut -d: -f2 | sed -e 's/\ //' -e 's/,/;/g'
}

storeName=($(index "店舖名稱"))
storeNum=($(index "店舖編號"))
storeServiceNum=($(index "服務編號"))
storeAddress=($(index "地址"))
storeTelephone=($(index "電話"))
storeCount=${#storeName[@]}

echo -e "店舖名稱,店舖編號,服務編號,地址,電話" > ${dataCsvFile}

for ((i=0;i<${storeCount};i++)); do
    echo -e "${storeName[$i]},${storeNum[$i]},${storeServiceNum[$i]},${storeAddress[$i]},${storeTelephone[$i]}" >> ${dataCsvFile}
done

echo -e "\n目前轉換店家數 ${storeCount} 家\n"

rm -f ${dataTempFile}
