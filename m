From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] api: Set default CRYPTO_MINALIGN to unsigned long long
Date: Tue, 8 Jan 2008 17:17:57 +1100
Message-ID: <20080108061757.GA9321@gondor.apana.org.au>
References: <20080108060911.GA4305@gondor.apana.org.au> <20080107.221425.140140329.davem@davemloft.net> <20080108061548.GE2529@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4466 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752879AbYAHGSA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jan 2008 01:18:00 -0500
Content-Disposition: inline
In-Reply-To: <20080108061548.GE2529@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 08, 2008 at 05:15:48PM +1100, Herbert Xu wrote:
> 
> Good point.  I'll get rid of that too.

I've replaced that patch with this:

[CRYPTO] api: Set default CRYPTO_MINALIGN to unsigned long long

Thanks to David Miller for pointing out that the SLAB (or SLOB/SLUB)
cache uses the alignment of unsigned long long if the architecture
kmalloc/slab alignment macros are not defined.

This patch changes the CRYPTO_MINALIGN so that it uses the same default
value.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 0aba104..5e02d1b 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -90,13 +90,11 @@
 #define CRYPTO_MINALIGN ARCH_KMALLOC_MINALIGN
 #elif defined(ARCH_SLAB_MINALIGN)
 #define CRYPTO_MINALIGN ARCH_SLAB_MINALIGN
+#else
+#define CRYPTO_MINALIGN __alignof__(unsigned long long)
 #endif
 
-#ifdef CRYPTO_MINALIGN
 #define CRYPTO_MINALIGN_ATTR __attribute__ ((__aligned__(CRYPTO_MINALIGN)))
-#else
-#define CRYPTO_MINALIGN_ATTR
-#endif
 
 struct scatterlist;
 struct crypto_ablkcipher;

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
