#!/bin/bash
cd ../..
#wget -m -k -K -E -l 7 -t 6 -w 5 https://ncs.naturalsciences.be/
cd ncs.naturalsciences.be

for i in `find  lithostratigraphy/ -type d` ; do
    pushd $i

    cat index.html.orig | grep '</*li' | sed -e 's;class=".* menu-item-[0-9]* \(level.\);class="\1;' | sed -e 's;<span class="accordeonck_outer ">;;' | sed -e 's;class="accordeonck";;' | sed -e 's;<span class="accordeonck_outer toggler toggler_1"><span class="toggler_icon"></span>;;' | sed -e 's;<span class="accordeonck_outer toggler toggler_0"><span class="toggler_icon"></span>;;' | sed -e 's;</span>;;' |  awk '/class="level1"/,0'  | sed -e 's;<div\(.*class="level1".*</a>\)</li>;<li \1;' | sed -e 's;<span class="accordeonck_outer toggler toggler_2"><span class="toggler_icon">;;g' | sed -e 's;</span>;;g'> li.html
    echo  '</li>' >> li.html
    java -jar /home/gehau/.m2/repository/net/sf/saxon/Saxon-HE/10.3/Saxon-HE-10.3.jar -xsl:'/home/gehau/git/bodem_en_ondergrond/codelijst-lithostratigraphy/src/main/xsl/site_to_rdf.xsl' -s:'li.html' > li.rdf
    riot -output=rdf/xml li.rdf > /tmp/li-description.rdf

    echo  '<xml>' > tabel.xml
    awk '/The full formal description is available here */ {print;while($0!~ /<\/table>/){getline;print;}}' index.html.orig | sed -e 's;The full formal description is available here: \(<a.*</a>\).*;\1;' | sed -e 's:<\([0-9]\):less than \1:g' >> tabel.xml
    echo  '</xml>' >> tabel.xml

    java -jar /home/gehau/.m2/repository/net/sf/saxon/Saxon-HE/10.3/Saxon-HE-10.3.jar -xsl:'/home/gehau/git/bodem_en_ondergrond/codelijst-lithostratigraphy/src/main/xsl/tabel_to_rdf.xsl' -s:'tabel.xml'  > tabel.rdf

    riot -output=turtle li.rdf tabel.rdf > concepten.ttl

    popd
done
cat $(find | grep ttl$ ) | grep PREFIX > /tmp/lithostratigraphy.ttl
riot $(find | grep ttl$ ) | sort -u >> /tmp/lithostratigraphy.ttl
riot --formatted=turtle /tmp/lithostratigraphy.ttl > /home/gehau/git/bodem_en_ondergrond/codelijst-lithostratigraphy/src/main/resources/be/vlaanderen/bodemenondergrond/data/id/conceptscheme/lithostratigraphy/lithostratigraphy.ttl
