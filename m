From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [v9 PATCH] crypto: caam - add support for RSA algorithm
Date: Mon, 4 Jul 2016 08:43:29 +0000
Message-ID: <AMSPR04MB53644E0E1B8E6C1412D6F11B8380@AMSPR04MB536.eurprd04.prod.outlook.com>
References: <1467387085-12212-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <20160703074358.GA25820@gondor.apana.org.au>
 <AMSPR04MB5360073EB4B1C100F155FCFB8380@AMSPR04MB536.eurprd04.prod.outlook.com>
 <20160704083612.GA31386@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Horia Ioan Geanta Neag" <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0066.outbound.protection.outlook.com ([104.47.2.66]:40658
	"EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753025AbcGDNSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 09:18:16 -0400
In-Reply-To: <20160704083612.GA31386@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 
> Perhaps you have a dirty tree that still has the asn header file
> in the caam subdirectory?
> 
> I don't see how this can possibly work on a clean tree since you
> got rid of all the ASN stuff from the caam driver.

The tree looks good. I made 'make mrproper' and 'make clean' before
building the image. I've double checked on other machine too.

Maybe we use different .configs. Can you please try to reproduce
the bug and indicate the .config used?

Thanks,
ta
