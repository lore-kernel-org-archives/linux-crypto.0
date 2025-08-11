Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CAF82866;
	Mon, 11 Aug 2025 04:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754887464; cv=none; b=LP9a0SRSkGaYWpkw/L4EDna3m10FbN3pUPQMEyLU1S/R4DuWBm3BAFUVAn04ZgfYKurlVEdKPJS2lKdbp3zB5auZDRWqGYzY5+Cv1xX28hK3LF7mg9YZKPfKGSVmLGRRXUnDs5u8tpN1rgf9dLYgXxsvdVaIOlhgWhdkNVfjot0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754887464; c=relaxed/simple;
	bh=+ogcbn7WVMG/PvGlTt/wjuGzB5rBKNTwr6kc7CDcgVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQGHqcHw6C6pHDo4S4zM7nxZnzhAwQ2x1wUqgPnEgC4BSJFovoS/mesFlbhezOAiT0poVKhQHwU4mtisOjhvfGIXl41MsCYM35Nrq5H+AliuUVjUZnLDRCvfe+FzKkL9irvXE596BKnuGARYr21HztZN2pTIqDpyUnjOiPZSkJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TZ6w8zbi; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TZ6w8zbi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=b0fN4uf5VCDuNIofpn3efSpVjQSYV/g6PlfcXcjDpmI=; b=TZ6w8zbi5RzYY8Ry8U6jlZNATe
	4bUteLaVjA+bOMLT+JQ1Eh97xdLrG/JxlIzfNpr8wEPVpD5Qi/MiS3hpWx0Dq41L7Lb4pqhFJ5JX5
	9qUu/60K3VqBR28IwbOBx4UeKWORoc93x/58oo8Pg5HLB2PQ4ftrqG5IzRKCfgfxwN8ZcB0Tzguct
	DSO/oBLLu5fU2U86n1M/B+mKBVs7dWygYwaIYOE4IR7VEKjy5P0Fsp/8zULyrWG4lHAzHeudFoxH2
	kRz42fgLdNpPZk1kD2ZyZLRPz+v1fK8jlZgN08hmIBUgYv99hW9qpI+1UNbxPJH6TYL6//Txo4gb9
	koQWzYuw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ulK8h-00D9Tm-2j;
	Mon, 11 Aug 2025 12:44:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 11 Aug 2025 12:44:00 +0800
Date: Mon, 11 Aug 2025 12:44:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vegard Nossum <vegard.nossum@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: hash - Make HASH_MAX_DESCSIZE a bit more obvious
Message-ID: <aJl1EIoSHnZRIQNO@gondor.apana.org.au>
References: <aJWOH9GgXhoJsHp6@gondor.apana.org.au>
 <CAHk-=wgE=tX+Bv5y0nWwLKLjrmUTx4NrMs4Qx84Y78YpNqFGBA@mail.gmail.com>
 <72186af9-50c4-461a-bf61-f659935106cc@oracle.com>
 <CAHk-=wjn5AtuNixX36qDGWumG4LiSDuuqfbaGH2RZu2ThXzV-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjn5AtuNixX36qDGWumG4LiSDuuqfbaGH2RZu2ThXzV-A@mail.gmail.com>

On Sun, Aug 10, 2025 at 07:51:56AM +0300, Linus Torvalds wrote:
>
> Yeah, that should have been in the commit message somewhere.
> 
> And honestly, it should have been in the code too. Having very random
> constants in header files with no explanation for them is not great.

The patch below should make the constant a bit more obvious.
 
> The dynamic check may be the right thing to do regardless, but when
> fixing outright bugs, at least document what went wrong and why. Not
> just "360 was too small for X, so it is now 361".

The dynamic check has always been there (see commit b68a7ec1e9a3).

So this fix wasn't about a buffer overflow, rather it was to make
s390 sha3-224 work again as it got caught by the dynamic check.

Cheers,

---8<---
Move S390_SHA_CTX_SIZE into crypto/hash.h so that the derivation
of HASH_MAX_DESCSIZE is less cryptic.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/s390/crypto/sha.h b/arch/s390/crypto/sha.h
index cadb4b13622a..b9cd9572dd35 100644
--- a/arch/s390/crypto/sha.h
+++ b/arch/s390/crypto/sha.h
@@ -10,14 +10,15 @@
 #ifndef _CRYPTO_ARCH_S390_SHA_H
 #define _CRYPTO_ARCH_S390_SHA_H
 
+#include <crypto/hash.h>
 #include <crypto/sha2.h>
 #include <crypto/sha3.h>
+#include <linux/build_bug.h>
 #include <linux/types.h>
 
 /* must be big enough for the largest SHA variant */
 #define CPACF_MAX_PARMBLOCK_SIZE	SHA3_STATE_SIZE
 #define SHA_MAX_BLOCK_SIZE		SHA3_224_BLOCK_SIZE
-#define S390_SHA_CTX_SIZE		sizeof(struct s390_sha_ctx)
 
 struct s390_sha_ctx {
 	u64 count;		/* message length in bytes */
@@ -42,4 +43,9 @@ int s390_sha_update_blocks(struct shash_desc *desc, const u8 *data,
 int s390_sha_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
 		   u8 *out);
 
+static inline void __check_s390_sha_ctx_size(void)
+{
+	BUILD_BUG_ON(S390_SHA_CTX_SIZE != sizeof(struct s390_sha_ctx));
+}
+
 #endif
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index ed63b904837d..44d407cb0c90 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -177,14 +177,26 @@ struct shash_desc {
 
 #define HASH_MAX_DIGESTSIZE	 64
 
+/*
+ * The size of a core hash state and a partial block.  The final byte
+ * is the length of the partial block.
+ */
+#define HASH_STATE_AND_BLOCK(state, block) ((state) + (block) + 1)
+
+
 /* Worst case is sha3-224. */
-#define HASH_MAX_STATESIZE	 200 + 144 + 1
+#define HASH_MAX_STATESIZE	 HASH_STATE_AND_BLOCK(200, 144)
+
+/* This needs to match arch/s390/crypto/sha.h. */
+#define S390_SHA_CTX_SIZE	216
 
 /*
  * Worst case is hmac(sha3-224-s390).  Its context is a nested 'shash_desc'
  * containing a 'struct s390_sha_ctx'.
  */
-#define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 361)
+#define SHA3_224_S390_DESCSIZE	HASH_STATE_AND_BLOCK(S390_SHA_CTX_SIZE, 144)
+#define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + \
+				 SHA3_224_S390_DESCSIZE)
 #define MAX_SYNC_HASH_REQSIZE	(sizeof(struct ahash_request) + \
 				 HASH_MAX_DESCSIZE)
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
