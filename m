From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/10] crypto: Convert pcrypt/cryptd/aesni to new AEAD
 interface
Date: Thu, 28 May 2015 22:03:11 +0800
Message-ID: <20150528140311.GA8423@gondor.apana.org.au>
References: <20150528133700.GA7822@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44400 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbbE1ODS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 10:03:18 -0400
Content-Disposition: inline
In-Reply-To: <20150528133700.GA7822@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This series of patches adds some finishing touches to the new
AEAD interface and then converts pcrypt, cryptd and aesni_intel
to it.

Sorry for the resend but I screwed up the mailing list address.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
