From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 8/10] crypto: aesni - Convert top-level rfc4106 algorithm
 to new interface
Date: Mon, 1 Jun 2015 15:41:16 +0800
Message-ID: <20150601074116.GA11528@gondor.apana.org.au>
References: <20150528140311.GA8423@gondor.apana.org.au>
 <E1YxyTb-0002L9-6g@gondolin.me.apana.org.au>
 <3237777.1pZ3XZ1aYV@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47526 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbbFAHl1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 03:41:27 -0400
Content-Disposition: inline
In-Reply-To: <3237777.1pZ3XZ1aYV@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 29, 2015 at 11:39:03PM +0200, Stephan Mueller wrote:
>
> Not sure what goes wrong, but when using algif_aead with the new code, I get:

This is a bug in the way it's using scatterwalk.  It needs to
advance the walk object by the number of bytes it has processed.
Previously it didn't crash because it didn't set out to 1 which
you should do if you're writing to the buffer.

I'll resend the patch with the bug fixed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
