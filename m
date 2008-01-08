From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [CRYPTO] api: Set default CRYPTO_MINALIGN to unsigned long long
Date: Tue, 8 Jan 2008 17:09:11 +1100
Message-ID: <20080108060911.GA4305@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4381 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754527AbYAHGJO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jan 2008 01:09:14 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

I've just added this patch to cryptodev-2.6.

[CRYPTO] api: Set default CRYPTO_MINALIGN to unsigned long long
    
Thanks to David Miller for pointing out that the SLAB (or SLOB/SLUB)
cache uses the alignment of unsigned long long if the architecture
kmalloc/slab alignment macros are not defined.
    
This patch changes the CRYPTO_MINALIGN so that it uses the same default
value.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 0aba104..6a20fc9 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -90,6 +90,8 @@
 #define CRYPTO_MINALIGN ARCH_KMALLOC_MINALIGN
 #elif defined(ARCH_SLAB_MINALIGN)
 #define CRYPTO_MINALIGN ARCH_SLAB_MINALIGN
+#else
+#define CRYPTO_MINALIGN __alignof__(unsigned long long)
 #endif
 
 #ifdef CRYPTO_MINALIGN

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
