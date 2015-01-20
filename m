From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Tue, 20 Jan 2015 14:17:04 +1100
Message-ID: <20150120031704.GB10475@gondor.apana.org.au>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2587101.YvN0IxRmOH@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jan 18, 2015 at 11:56:03PM +0100, Stephan Mueller wrote:
> The cipher registered as __driver-gcm-aes-aesni is never intended
> to be used directly by any caller. Instead it is a service mechanism to
> rfc4106-gcm-aesni.
> 
> The kernel crypto API unconditionally calls the registered setkey
> function. In case a caller erroneously uses __driver-gcm-aes-aesni a
> call to crypto_aead_setkey will cause a NULL pointer dereference without
> this patch.
> 
> CC: Tadeusz Struk <tadeusz.struk@intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Rather than adding a bogus setkey function, please fix this mess
properly by moving the top-level setkey function into the __driver
one where it should be.  Compare with how we handle it in the
ablk_helper which is pretty much the same thing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
