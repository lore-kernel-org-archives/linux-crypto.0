From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v9 PATCH] crypto: caam - add support for RSA algorithm
Date: Mon, 4 Jul 2016 17:09:02 +0800
Message-ID: <20160704090902.GA31885@gondor.apana.org.au>
References: <1467387085-12212-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <20160703074358.GA25820@gondor.apana.org.au>
 <AMSPR04MB5360073EB4B1C100F155FCFB8380@AMSPR04MB536.eurprd04.prod.outlook.com>
 <20160704083612.GA31386@gondor.apana.org.au>
 <AMSPR04MB53644E0E1B8E6C1412D6F11B8380@AMSPR04MB536.eurprd04.prod.outlook.com>
 <20160704084606.GA31460@gondor.apana.org.au>
 <AM4PR0401MB1876BEAE53531C7CE64128D7E7380@AM4PR0401MB1876.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>
To: Cristian Stoica <cristian.stoica@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54640 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbcGDJJH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 05:09:07 -0400
Content-Disposition: inline
In-Reply-To: <AM4PR0401MB1876BEAE53531C7CE64128D7E7380@AM4PR0401MB1876.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 04, 2016 at 09:06:19AM +0000, Cristian Stoica wrote:
> Hi Herbert,
> 
> I've tried the following builds and both fail:
> 
> make mrproper
> make defconfig
> make drivers/crypto/qat/qat_common/qat_asym_algs.o
> ....
> drivers/crypto/qat/qat_common/qat_asym_algs.c:55:32: fatal error: qat_rsapubkey-asn1.h: No such file or directory
>  #include "qat_rsapubkey-asn1.h"

qat is missing a dependency on ASN1 I believe.  But as we're phasing
out the ASN1 code in RSA drivers this will be fixed by converting
to the new RSA helper interface.

> make mrproper
> make defconfig
> make drivers/crypto/caam/caampkc.o
> ...
> drivers/crypto/caam/caampkc.c:17:28: fatal error: rsapubkey-asn1.h: No such file or directory
>  #include "rsapubkey-asn1.h"

caam isn't even using ASN1 but it's just including this old header
file which should be deleted.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
