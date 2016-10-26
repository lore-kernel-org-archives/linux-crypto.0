From: Horia Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: caam: fix type mismatch warning
Date: Wed, 26 Oct 2016 06:23:17 +0000
Message-ID: <DB4PR04MB0847F9AE9886577DA3AD8EBF98AB0@DB4PR04MB0847.eurprd04.prod.outlook.com>
References: <20161025212923.2452320-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "David S. Miller" <davem@davemloft.net>,
        Cata Vasile <cata.vasile@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0054.outbound.protection.outlook.com ([104.47.2.54]:34448
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751129AbcJZGiw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2016 02:38:52 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/26/2016 12:29 AM, Arnd Bergmann wrote:=0A=
> Building the caam driver on arm64 produces a harmless warning:=0A=
> =0A=
> drivers/crypto/caam/caamalg.c:140:139: warning: comparison of distinct po=
inter types lacks a cast=0A=
> =0A=
> We can use min_t to tell the compiler which type we want it to use=0A=
> here.=0A=
> =0A=
> Fixes: 5ecf8ef9103c ("crypto: caam - fix sg dump")=0A=
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
