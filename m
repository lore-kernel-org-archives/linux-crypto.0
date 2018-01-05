From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v10 7/8] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Fri, 5 Jan 2018 08:01:13 +0000
Message-ID: <VI1PR0402MB334282217BC0AE1F8DA8BFC3981C0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <20180104191645.10006-1-logang@deltatee.com>
 <20180104191645.10006-8-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Logan Gunthorpe <logang@deltatee.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-ntb@googlegroups.com" <linux-ntb@googlegroups.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0049.outbound.protection.outlook.com ([104.47.1.49]:4128
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751235AbeAEIBU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jan 2018 03:01:20 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/4/2018 9:16 PM, Logan Gunthorpe wrote:=0A=
> Clean up the extra ifdefs which defined the wr_reg64 and rd_reg64=0A=
> functions in non-64bit cases in favour of the new common=0A=
> io-64-nonatomic-lo-hi header.=0A=
> =0A=
> To be consistent with CAAM engine HW spec: in case of 64-bit registers,=
=0A=
> irrespective of device endianness, the lower address should be read from=
=0A=
> / written to first, followed by the upper address. Indeed the I/O=0A=
> accessors in CAAM driver currently don't follow the spec, however this=0A=
> is a good opportunity to fix the code.=0A=
> =0A=
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>=0A=
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Dan Douglass <dan.douglass@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: "David S. Miller" <davem@davemloft.net>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
