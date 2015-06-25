From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni - fix failing setkey for rfc4106-gcm-aesni
Date: Thu, 25 Jun 2015 22:25:25 +0800
Message-ID: <20150625142525.GA10550@gondor.apana.org.au>
References: <20150624141421.30466.28034.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52379 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbbFYOZb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2015 10:25:31 -0400
Content-Disposition: inline
In-Reply-To: <20150624141421.30466.28034.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 24, 2015 at 07:14:21AM -0700, Tadeusz Struk wrote:
> rfc4106(gcm(aes)) uses cbc(aes) to generate hash key. cbc(aes) needs
> chainiv, but the chainiv gets initialized after aesni_intel when both
> are statically linked so the setkey fails.
> This patch forces aesni_intel to be initialized after chainiv.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Aha, this could indeed the explain the setkey error that Linus
saw.  Once the AEAD conversion is complete this would actually
become unnecessary because seqiv for blkcipher would disappear.

Linus, could you confirm that you have AESNI built into the kernel
and not as a module?

However, this is still brittle because you have the same ordering
issue with ctr.  IOW aesni may be registered before ctr.  In fact
you don't actually need ctr here.  You could just replace it with
plain aes plus a xor.

That should be more robust as you can then just use aesni for the
aes and you wouldn't depend on anything external to aesni.

Could you make a patch for that Tadeusz?

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
