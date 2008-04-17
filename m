From: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Date: Thu, 17 Apr 2008 09:52:03 +0800
Message-ID: <1208397123.4322.21.camel@caritas-dev.intel.com>
References: <1207723262.18313.37.camel@caritas-dev.intel.com>
	 <20080416073108.GA13494@Chamillionaire.breakpoint.cc>
	 <1208333949.4322.5.camel@caritas-dev.intel.com>
	 <20080416184016.GA21365@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	mingo@elte.hu, tglx@linutronix.de
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYDQBrr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Apr 2008 21:47:47 -0400
In-Reply-To: <20080416184016.GA21365@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2008-04-16 at 20:40 +0200, Sebastian Siewior wrote:
[...]
> >> >--- a/include/crypto/aes.h
> >> >+++ b/include/crypto/aes.h
> >> >@@ -19,6 +19,7 @@
> >> > 
> >> > struct crypto_aes_ctx {
> >> > 	u32 key_length;
> >> >+	u32 _pad1;
> >> 
> >> Why is this pad required? Do you want special alignment of the keys?
> >
> >Because the key is loaded in 64bit in this patch, I want to align the
> >key with 64bit address.
> 
> Than this won't work all the time. To make it bulletproof
> - set .cra_alignmask in the glue code properly
> - use the attribute aligned thing
> - retrieve your private struct via crypto_tfm_ctx_aligned()

As far as I know, the CRYPTO_MINALIGN is defined in
include/linux/crypto.h as __alignof__(unsigned long long), and the
__crt_ctx in crypto_tfm is aligned in CRYPTO_MINALIGN. So I think adding
a pad is sufficient for x86_64 implementation.

Best Regards,
Huang Ying

