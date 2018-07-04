From: Horia Geanta <horia.geanta@nxp.com>
Subject: Re: [PATCH v18 6/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Wed, 4 Jul 2018 15:59:01 +0000
Message-ID: <VI1PR0402MB3485AB652FBD61CE27965D3798410@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20180622194752.11221-1-logang@deltatee.com>
 <20180622194752.11221-7-logang@deltatee.com>
 <CAOMZO5DpwPsidKQ9wfe8mNTgdOpkdHHgqHMa4yQBx9uRrfFmww@mail.gmail.com>
 <CAHp75VcCNsx2sHcYG2aNiw354exTvO=NUOS9P_BTmcM3siAepg@mail.gmail.com>
 <13ea3f97-4a33-3a24-1b7e-b819be73d867@deltatee.com>
 <CAOMZO5CfUfNZd0kG=VVnH4BjP+XMpGh3bPCUrTwi_4w6YEGX7g@mail.gmail.com>
 <CAHp75VcDudrwV4kRnVR+vtddFhxHsU672YqOJgPPchuLvPV3nA@mail.gmail.com>
 <CAOMZO5A4bsu9dXCPb4QeSbnnLi=pr1=WYWn8p2AfU3rEG=RWXg@mail.gmail.com>
 <6e5224b9-343f-990c-19bd-fe37c6fbdc9b@deltatee.com>
 <CAOMZO5CJ_iG=p_+xL=Q_Rv3F5vtGggsgatar4XVTL+UFVnHBTA@mail.gmail.com>
 <7ddda181-6337-32cc-7a0d-43fc6a7ba78b@deltatee.com>
 <CAHp75VcN=pUkFK6=_7yErMRGNS3WsgBhkWMSwP0Cw_ZmGR=RJg@mail.gmail.com>
 <991b2298-bb3f-dad3-c93b-b43ee5f372de@deltatee.com>
 <VI1PR0402MB3485F76DD56D221EB256B4F698410@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAOMZO5C7V4_SpXOcAz0KbGYScpos0HRD-aa-Zh_6M3p9EqLsLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Logan Gunthorpe <logang@deltatee.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-ntb@googlegroups.com" <linux-ntb@googlegroups.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/4/2018 6:06 PM, Fabio Estevam wrote:=0A=
> Hi Horia,=0A=
> =0A=
> On Wed, Jul 4, 2018 at 8:45 AM, Horia Geanta <horia.geanta@nxp.com> wrote=
:=0A=
> =0A=
>> I think there are two separate issues here:=0A=
>>=0A=
>> 1. Semantics of operations in io-64-nonatomic-lo-hi.h, io-64-nonatomic-h=
i-lo.h=0A=
>>=0A=
>> Logan, you mentioned the following (which unfortunately I somehow missed=
):=0A=
>> https://lore.kernel.org/lkml/c3f2e061-5ed1-5c74-b955-3d2bfb0da074@deltat=
ee.com=0A=
>> The lo_hi/hi_lo functions seem to always refer to the data being written=
=0A=
>> or read not to the address operated on.=0A=
>>=0A=
>> OTOH, initial commit that added asm-generic/io-64-nonatomic-lo-hi.h and=
=0A=
>> asm-generic/io-64-nonatomic-hi-lo.h mentions:=0A=
>> 797a796a13df6 ("asm-generic: architecture independent readq/writeq for 3=
2bit=0A=
>> environment")=0A=
>> - <asm-generic/io-64-nonatomic-lo-hi.h> provides non-atomic readq/ write=
q with=0A=
>> the order of lower address -> higher address=0A=
>> - <asm-generic/io-64-nonatomic-hi-lo.h> provides non-atomic readq/ write=
q with=0A=
>> reversed order=0A=
>>=0A=
>> I think we should keep the initial semantics when adding support for=0A=
>> io{read|write}64, i.e. "lo" and "hi" to refer to address and not to valu=
e.=0A=
>>=0A=
>> Actually this is the semantics intended for the CAAM patch, see the note=
 at the=0A=
>> end of the commit message that refers to addresses, not values:=0A=
>> To be consistent with CAAM engine HW spec: in case of 64-bit registers,=
=0A=
>> irrespective of device endianness, the lower address should be read from=
=0A=
>> / written to first, followed by the upper address.=0A=
>>=0A=
>>=0A=
>> 2. CAAM driver I/O accessors for i.MX case=0A=
>>=0A=
>> CAAM block in some i.MX parts has broken endianness for 64b registers.=
=0A=
>> For e.g. for i.MX6S/SL/D/Q even though CAAM is little endian, BARs for I=
/O rings=0A=
>> have to be programmed as:=0A=
>> I/O Ring BAR+0: unused=0A=
>> I/O Ring BAR+4: IOVA (32-bit little endian)=0A=
>> when the proper layout (for a 64b register) would have been to program I=
OVA at=0A=
>> BAR+0.=0A=
>>=0A=
>> This explains why I/O accessors in CAAM driver handle things differently=
 in case=0A=
>> caam_imx=3Dtrue.=0A=
>>=0A=
>> Since this quirk cannot be accommodated in generic fashion, code dealing=
 with=0A=
>> caam_imx has to stay.=0A=
> =0A=
> Should I sent a revert of patch 46e4bf08f6388 for the boot regression for=
 now?=0A=
> =0A=
> Then the two issues you pointed out could be fixed later.=0A=
> =0A=
I guess it would be better this way.=0A=
=0A=
Thanks,=0A=
Horia=0A=
