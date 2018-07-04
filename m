From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v18 6/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Wed, 4 Jul 2018 12:06:14 -0300
Message-ID: <CAOMZO5C7V4_SpXOcAz0KbGYScpos0HRD-aa-Zh_6M3p9EqLsLQ@mail.gmail.com>
References: <20180622194752.11221-1-logang@deltatee.com> <20180622194752.11221-7-logang@deltatee.com>
 <CAOMZO5DpwPsidKQ9wfe8mNTgdOpkdHHgqHMa4yQBx9uRrfFmww@mail.gmail.com>
 <CAHp75VcCNsx2sHcYG2aNiw354exTvO=NUOS9P_BTmcM3siAepg@mail.gmail.com>
 <13ea3f97-4a33-3a24-1b7e-b819be73d867@deltatee.com> <CAOMZO5CfUfNZd0kG=VVnH4BjP+XMpGh3bPCUrTwi_4w6YEGX7g@mail.gmail.com>
 <CAHp75VcDudrwV4kRnVR+vtddFhxHsU672YqOJgPPchuLvPV3nA@mail.gmail.com>
 <CAOMZO5A4bsu9dXCPb4QeSbnnLi=pr1=WYWn8p2AfU3rEG=RWXg@mail.gmail.com>
 <6e5224b9-343f-990c-19bd-fe37c6fbdc9b@deltatee.com> <CAOMZO5CJ_iG=p_+xL=Q_Rv3F5vtGggsgatar4XVTL+UFVnHBTA@mail.gmail.com>
 <7ddda181-6337-32cc-7a0d-43fc6a7ba78b@deltatee.com> <CAHp75VcN=pUkFK6=_7yErMRGNS3WsgBhkWMSwP0Cw_ZmGR=RJg@mail.gmail.com>
 <991b2298-bb3f-dad3-c93b-b43ee5f372de@deltatee.com> <VI1PR0402MB3485F76DD56D221EB256B4F698410@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
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
To: Horia Geanta <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <VI1PR0402MB3485F76DD56D221EB256B4F698410@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Horia,

On Wed, Jul 4, 2018 at 8:45 AM, Horia Geanta <horia.geanta@nxp.com> wrote:

> I think there are two separate issues here:
>
> 1. Semantics of operations in io-64-nonatomic-lo-hi.h, io-64-nonatomic-hi-lo.h
>
> Logan, you mentioned the following (which unfortunately I somehow missed):
> https://lore.kernel.org/lkml/c3f2e061-5ed1-5c74-b955-3d2bfb0da074@deltatee.com
> The lo_hi/hi_lo functions seem to always refer to the data being written
> or read not to the address operated on.
>
> OTOH, initial commit that added asm-generic/io-64-nonatomic-lo-hi.h and
> asm-generic/io-64-nonatomic-hi-lo.h mentions:
> 797a796a13df6 ("asm-generic: architecture independent readq/writeq for 32bit
> environment")
> - <asm-generic/io-64-nonatomic-lo-hi.h> provides non-atomic readq/ writeq with
> the order of lower address -> higher address
> - <asm-generic/io-64-nonatomic-hi-lo.h> provides non-atomic readq/ writeq with
> reversed order
>
> I think we should keep the initial semantics when adding support for
> io{read|write}64, i.e. "lo" and "hi" to refer to address and not to value.
>
> Actually this is the semantics intended for the CAAM patch, see the note at the
> end of the commit message that refers to addresses, not values:
> To be consistent with CAAM engine HW spec: in case of 64-bit registers,
> irrespective of device endianness, the lower address should be read from
> / written to first, followed by the upper address.
>
>
> 2. CAAM driver I/O accessors for i.MX case
>
> CAAM block in some i.MX parts has broken endianness for 64b registers.
> For e.g. for i.MX6S/SL/D/Q even though CAAM is little endian, BARs for I/O rings
> have to be programmed as:
> I/O Ring BAR+0: unused
> I/O Ring BAR+4: IOVA (32-bit little endian)
> when the proper layout (for a 64b register) would have been to program IOVA at
> BAR+0.
>
> This explains why I/O accessors in CAAM driver handle things differently in case
> caam_imx=true.
>
> Since this quirk cannot be accommodated in generic fashion, code dealing with
> caam_imx has to stay.

Should I sent a revert of patch 46e4bf08f6388 for the boot regression for now?

Then the two issues you pointed out could be fixed later.
