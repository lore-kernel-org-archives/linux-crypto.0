From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v9 PATCH] crypto: caam - add support for RSA algorithm
Date: Mon, 4 Jul 2016 16:46:06 +0800
Message-ID: <20160704084606.GA31460@gondor.apana.org.au>
References: <1467387085-12212-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <20160703074358.GA25820@gondor.apana.org.au>
 <AMSPR04MB5360073EB4B1C100F155FCFB8380@AMSPR04MB536.eurprd04.prod.outlook.com>
 <20160704083612.GA31386@gondor.apana.org.au>
 <AMSPR04MB53644E0E1B8E6C1412D6F11B8380@AMSPR04MB536.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41273 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142AbcGDIqb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 04:46:31 -0400
Content-Disposition: inline
In-Reply-To: <AMSPR04MB53644E0E1B8E6C1412D6F11B8380@AMSPR04MB536.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 04, 2016 at 08:43:29AM +0000, Tudor-Dan Ambarus wrote:
>
> The tree looks good. I made 'make mrproper' and 'make clean' before
> building the image. I've double checked on other machine too.
> 
> Maybe we use different .configs. Can you please try to reproduce
> the bug and indicate the .config used?

Please look at your patch.  It's broken, you're including

+#include "rsapubkey-asn1.h"
+#include "rsaprivkey-asn1.h"

which no longer exist.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
