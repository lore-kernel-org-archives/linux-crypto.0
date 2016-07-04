From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v9 PATCH] crypto: caam - add support for RSA algorithm
Date: Mon, 4 Jul 2016 16:36:12 +0800
Message-ID: <20160704083612.GA31386@gondor.apana.org.au>
References: <1467387085-12212-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <20160703074358.GA25820@gondor.apana.org.au>
 <AMSPR04MB5360073EB4B1C100F155FCFB8380@AMSPR04MB536.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36367 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbcGDIgQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 04:36:16 -0400
Content-Disposition: inline
In-Reply-To: <AMSPR04MB5360073EB4B1C100F155FCFB8380@AMSPR04MB536.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 04, 2016 at 08:32:44AM +0000, Tudor-Dan Ambarus wrote:
> Hi Herbert,
> 
> > Sorry, but this doesn't build:
> > 
> >   CC [M]  drivers/crypto/caam/caampkc.o
> > ../drivers/crypto/caam/caampkc.c:17:28: fatal error: rsapubkey-asn1.h: No
> > such file or directory
> > compilation terminated.
> 
> I can't reproduce it. I tried on powerpc, arm and x86 (even if caam is not
> present for x86). I've successfully built caampkc as built-in or
> as a module for powerpc and arm.
> 
> I use git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
> on latest master branch (27710b8ea3defcbd7d340dbd0423d911b4eb7c4f)
> with my commit on top of it.

Perhaps you have a dirty tree that still has the asn header file
in the caam subdirectory?

I don't see how this can possibly work on a clean tree since you
got rid of all the ASN stuff from the caam driver.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
