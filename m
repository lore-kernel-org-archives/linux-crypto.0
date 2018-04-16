From: Maninder Singh <maninder1.s@samsung.com>
Subject: Re: [PATCH 0/1] cover-letter/lz4: Implement lz4 with dynamic offset
 length.
Date: Mon, 16 Apr 2018 15:51:38 +0530
Message-ID: <20180416102138epcms5p429e04b68b94dcf80cd84f7008467ed68@epcms5p4>
References: <20180329102613epcms5p6ffaa80d12115ded8f3c9ef01dd009744@epcms5p6>
        <20180329102046epcms5p8ecc9532b03bab4f47cbdbb2507171b86@epcms5p8>
        <20180323134319epcms5p62e6021aa33c941c46ecdb8b5364b614c@epcms5p6>
        <1663C9A3-7DAC-4A11-894C-C99E07BEDAD2@fb.com>
        <1521607242-3968-1-git-send-email-maninder1.s@samsung.com>
        <20180321082628.GB2746@jagdpanzerIV>
        <CGME20180321044137epcas5p221e7ee4a0b7464eaa00dad8320f0251d@epcms5p4>
Reply-To: maninder1.s@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        Kees Cook <keescook@chromium.org>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "ccross@android.com" <ccross@android.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        PANKAJ MISHRA <pankaj.m@samsung.com>,
        AMIT SAHRAWAT <a.sahrawat@samsung.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Maninder Singh <maninder1.s@samsung.com>,
        Vaneet Narang <v.narang@samsung.com>,
        Nick Terrell <terrelln@fb.com>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Yann Collet <cyan@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180329102613epcms5p6ffaa80d12115ded8f3c9ef01dd009744@epcms5p6>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


=C2=A0Hello=20Nick/=20Yann,=0D=0A=0D=0AAny=20inputs=20regarding=20LZ4=20dyn=
=20results=20&=20lz4=20dyn=20approach.=0D=0A=0D=0A>Hello=20Nick/Sergey,=0D=
=0A>=20=0D=0A>Any=20suggestion=20or=20comments,=20so=20that=20we=20can=20ch=
ange=20code=20and=20resend=20the=20patch?=0D=0A>=20=0D=0A>>=20Hi=20Nick=20/=
=20Sergey,=0D=0A>>=20=0D=0A>>=20=0D=0A>>=20We=20have=20compared=20LZ4=20Dyn=
=20with=20Original=20LZ4=20using=20some=20samples=20of=20realtime=20applica=
tion=20data(4Kb)=0D=0A>>=20compressed/decompressed=20by=20ZRAM.=20For=20com=
parison=20we=20have=20used=20lzbench=20(https://github.com/inikep/lzbench)=
=0D=0A>>=20we=20have=20implemented=20dedicated=20LZ4=20Dyn=20API=20&=20kept=
=20last=20literal=20length=20as=206=20to=20avoid=20overhead=20=0D=0A>>=20of=
=20checks.=20It=20seems=20in=20average=20case=20there=20is=20a=20saving=20o=
f=203=7E4%=20in=20compression=20ratio=20with=20almost=20same=20compression=
=0D=0A>>=20speed=20and=20minor=20loss=20in=20decompression=20speed=20(=7E50=
MB/s)=20when=20compared=20with=20LZ4.=0D=0A>>=20=0D=0A>>=20Comparison=20of=
=20Lz4=20Dyn=20with=20LZO1x=20is=20also=20done=20as=20LZO1x=20is=20default=
=20compressor=20of=20ZRAM.=0D=0A>>=20=0D=0A>>=20Original=20LZ4:=0D=0A>>=20s=
h-3.2=23=20./lzbench=20=20-r=20=20-elz4=20=20data/=0D=0A>>=20lzbench=201.7.=
3=20(32-bit=20Linux)=20=20=20Assembled=20by=20P.Skibinski=0D=0A>>=20Compres=
sor=20name=20=20=20=20=20=20=20=20=20Compress.=20Decompress.=20Compr.=20siz=
e=20=20Ratio=20Filename=0D=0A>>=20memcpy=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=202205=20MB/s=20=202217=20MB/s=20=20=20=20=20=20=20=
=204096=20100.00=20data//data_1=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20216=20MB/s=20=20=20761=20MB/s=20=20=20=20=20=
=20=20=202433=20=2059.40=20data//data_1=0D=0A>>=20lz4=201.8.0=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20269=20MB/s=20=20=20877=20MB/s=20=20=
=20=20=20=20=20=201873=20=2045.73=20data//data_2=0D=0A>>=20lz4=201.8.0=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20238=20MB/s=20=20=20575=20MB=
/s=20=20=20=20=20=20=20=202060=20=2050.29=20data//data_3=0D=0A>>=20lz4=201.=
8.0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20321=20MB/s=20=201015=
=20MB/s=20=20=20=20=20=20=20=201464=20=2035.74=20data//data_4=0D=0A>>=20lz4=
=201.8.0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20464=20MB/s=20=20=
1090=20MB/s=20=20=20=20=20=20=20=20=20713=20=2017.41=20data//data_5=0D=0A>>=
=20lz4=201.8.0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20296=20MB/s=
=20=20=20956=20MB/s=20=20=20=20=20=20=20=201597=20=2038.99=20data//data_6=
=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=2033=
8=20MB/s=20=20=20994=20MB/s=20=20=20=20=20=20=20=202238=20=2054.64=20data//=
data_7=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20705=20MB/s=20=201172=20MB/s=20=20=20=20=20=20=20=20=20193=20=20=204.7=
1=20data//data_8=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20404=20MB/s=20=201150=20MB/s=20=20=20=20=20=20=20=201097=20=
=2026.78=20data//data_9=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20216=20MB/s=20=20=20921=20MB/s=20=20=20=20=20=20=20=203=
183=20=2077.71=20data//data_10=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20456=20MB/s=20=201101=20MB/s=20=20=20=20=20=20=
=20=201011=20=2024.68=20data//data_11=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20867=20MB/s=20=201202=20MB/s=20=20=20=20=
=20=20=20=20=20=2037=20=20=200.90=20data//data_12=0D=0A>>=20=0D=0A>>=20=0D=
=0A>>=20LZ4=20Dynamic=20Offet:=20=20=0D=0A>>=20sh-3.2=23=20./lzbench=20=20-=
r=20=20-elz4_dyn=20=20data/=0D=0A>>=20lzbench=201.7.3=20(32-bit=20Linux)=20=
=20=20Assembled=20by=20P.Skibinski=0D=0A>>=20Compressor=20name=20=20=20=20=
=20=20=20=20=20Compress.=20Decompress.=20Compr.=20size=20=20Ratio=20Filenam=
e=0D=0A>>=20memcpy=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
2203=20MB/s=20=202218=20MB/s=20=20=20=20=20=20=20=204096=20100.00=20data//d=
ata_1=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20218=20MB/s=20=20=20693=20MB/s=20=20=20=20=20=20=20=202228=20=2054.39=20d=
ata//data_1=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20273=20MB/s=20=20=20851=20MB/s=20=20=20=20=20=20=20=201739=20=2042.=
46=20data//data_2=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20230=20MB/s=20=20=20526=20MB/s=20=20=20=20=20=20=20=201800=20=
=2043.95=20data//data_3=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20321=20MB/s=20=20=20952=20MB/s=20=20=20=20=20=20=20=201=
357=20=2033.13=20data//data_4=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20470=20MB/s=20=201075=20MB/s=20=20=20=20=20=20=20=
=20=20664=20=2016.21=20data//data_5=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20303=20MB/s=20=20=20964=20MB/s=20=20=20=20=
=20=20=20=201455=20=2035.52=20data//data_6=0D=0A>>=20lz4=201.8.0=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20345=20MB/s=20=20=20951=20MB/s=20=
=20=20=20=20=20=20=202126=20=2051.90=20data//data_7=0D=0A>>=20lz4=201.8.0=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20744=20MB/s=20=201163=20M=
B/s=20=20=20=20=20=20=20=20=20177=20=20=204.32=20data//data_8=0D=0A>>=20lz4=
=201.8.0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20409=20MB/s=20=20=
1257=20MB/s=20=20=20=20=20=20=20=201033=20=2025.22=20data//data_9=0D=0A>>=
=20lz4=201.8.0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20220=20MB/s=
=20=20=20857=20MB/s=20=20=20=20=20=20=20=203049=20=2074.44=20data//data_10=
=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=2046=
4=20MB/s=20=201105=20MB/s=20=20=20=20=20=20=20=20=20934=20=2022.80=20data//=
data_11=0D=0A>>=20lz4=201.8.0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20874=20MB/s=20=201194=20MB/s=20=20=20=20=20=20=20=20=20=2036=20=20=200=
.88=20data//data_12=0D=0A>>=20=0D=0A>>=20=0D=0A>>=20LZ4=20Dynamic=20Offset=
=20with=2032K=20data:=0D=0A>>=20sh-3.2=23=20./lzbench=20-elz4_dyn=20data/da=
ta32k=0D=0A>>=20lzbench=201.7.3=20(32-bit=20Linux)=20=20=20Assembled=20by=
=20P.Skibinski=0D=0A>>=20Compressor=20name=20=20=20=20=20=20=20=20=20Compre=
ss.=20Decompress.=20Compr.=20size=20=20Ratio=20Filename=0D=0A>>=20memcpy=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=205285=20MB/s=20=205283=
=20MB/s=20=20=20=20=20=20=2032768=20100.00=20data/data32k=0D=0A>>=20lz4=201=
.8.0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20274=20MB/s=20=20=209=
95=20MB/s=20=20=20=20=20=20=2013435=20=2041.00=20data/data32k=0D=0A>>=20don=
e...=20(cIters=3D1=20dIters=3D1=20cTime=3D1.0=20dTime=3D2.0=20chunkSize=3D1=
706MB=20cSpeed=3D0MB)=0D=0A>>=20=0D=0A>>=20Original=20LZ4=20with=2032K=20da=
ta:=0D=0A>>=20sh-3.2=23=20./lzbench_orig=20-elz4=20data/data32k=0D=0A>>=20l=
zbench=201.7.3=20(32-bit=20Linux)=20=20=20Assembled=20by=20P.Skibinski=0D=
=0A>>=20Compressor=20name=20=20=20=20=20=20=20=20=20Compress.=20Decompress.=
=20Compr.=20size=20=20Ratio=20Filename=0D=0A>>=20memcpy=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=204918=20MB/s=20=205108=20MB/s=20=20=
=20=20=20=20=2032768=20100.00=20data/data32k=0D=0A>>=20lz4=201.8.0=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20276=20MB/s=20=201045=20MB/s=20=20=
=20=20=20=20=2014492=20=2044.23=20data/data32k=0D=0A>>=20=0D=0A>>=20LZO1x=
=20with=2032K=20data=20(Default=20Compressor=20for=20ZRAM):=20=0D=0A>>=20sh=
-3.2=23=20./lzbench=20-elzo1x,1=20data/data32k=0D=0A>>=20lzbench=201.7.3=20=
(32-bit=20Linux)=20=20=20Assembled=20by=20P.Skibinski=0D=0A>>=20Compressor=
=20name=20=20=20=20=20=20=20=20=20Compress.=20Decompress.=20Compr.=20size=
=20=20Ratio=20Filename=0D=0A>>=20memcpy=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=205273=20MB/s=20=205320=20MB/s=20=20=20=20=20=20=2032768=
=20100.00=20data/data32k=0D=0A>>=20lzo1x=202.09=20-1=20=20=20=20=20=20=20=
=20=20=20=20=20=20283=20MB/s=20=20=20465=20MB/s=20=20=20=20=20=20=2014292=
=20=2043.62=20data/data32k=0D=0A=0D=0A=0D=0AThanks,=0D=0AManinder=20Singh=
=0D=0A=C2=A0
