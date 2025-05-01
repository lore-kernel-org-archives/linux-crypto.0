Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE00224AFC
	for <linux-crypto@vger.kernel.org>; Thu,  1 May 2025 12:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746103059; cv=none; b=pMAVgZx5sI+hGv6C/ulTNMpvR7EB6S8miQqhf0f8OTE4XFWIAUrd5VV+JsXUaqrw9D1y94MO1SwDKbVdJ/39Jmo81/QaeHKiSOOMbtH0BmpVo7EoGSRb9gIUpIRMt6QVv0nL1EXz/ow+ulB1C9ERV7QYn8Fk8AxPNMTksHwyMfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746103059; c=relaxed/simple;
	bh=Y1ehkO6lLOWop9gpF6nPFqCpKc9qbplnyuRvwfFDUaY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=XLa2cRcxk77zX0s3tX71HF7e4Cug9dri+NT8ccQBAShi3cO0jN6/8jvPpXC6BB9zV4i0VnZi0dNmDYJoIBxhBUvfqz3gCZj5dwTV3g8YHM/+0k2XZKvqRitx/d64JmjM64pqcmiwBhG6cNl54kzY2x7xIwrDNa1E1X86Jz1Ntkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PFdS/EbC; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PFdS/EbC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Yp6BStKeFcoflRofEm2DavhhaNHO7afewA9e43DywK8=; b=PFdS/EbC0Z9pYp82tRDpsiE86X
	PyI9DWz2jGcZi/8Zaq48oW4DfHeWC6y1AD3qQ7j7UVBI2A2rgQ0uafcKzddCQZltx4ct9MIZxyaAa
	f2tVGVk14p+JMOHpUv7YhXVYV80eAPk5AyXncd+IUoXvCQ3MgAgCXtbcj1KzFUhng3REI/QmpMFGo
	PGIVKRzWnaO4oF5FYSjgeribqtZSw2FqRLVDxqH0mlqDCgZVUs0l5U1a/trHnCW3VpjEbsM8OwGKi
	C5oadmtelHqZeB1ViuNFlnz9w5ns89cAwBFf7eO6RVOEty8ovwMz58+1K1hDLQ9fRV1yeGeCwZOt8
	oxOpDLcw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uATAS-002bF4-2i;
	Thu, 01 May 2025 20:37:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 01 May 2025 20:37:32 +0800
Date: Thu, 01 May 2025 20:37:32 +0800
Message-Id: <4be83ed9da46eb4e8a309fa37e3050766ea2784c.1746102673.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746102673.git.herbert@gondor.apana.org.au>
References: <cover.1746102673.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/4] crypto: api - Rename CRYPTO_ALG_REQ_CHAIN to
 CRYPTO_ALG_REQ_VIRT
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As chaining has been removed, all that remains of REQ_CHAIN is
just virtual address support.  Rename it before the reintroduction
of batching creates confusion.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  | 4 ++--
 crypto/ahash.c                      | 6 +++---
 crypto/deflate.c                    | 2 +-
 crypto/scompress.c                  | 2 +-
 include/crypto/algapi.h             | 4 ++--
 include/crypto/internal/acompress.h | 4 ++--
 include/crypto/internal/hash.h      | 4 ++--
 include/linux/crypto.h              | 4 ++--
 8 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 6ecbfc49bfa8..be28cbfd22e3 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -287,7 +287,7 @@ int crypto_acomp_compress(struct acomp_req *req)
 
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
-	if (crypto_acomp_req_chain(tfm) || acomp_request_issg(req))
+	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
 		return crypto_acomp_reqtfm(req)->compress(req);
 	return acomp_do_req_chain(req, true);
 }
@@ -299,7 +299,7 @@ int crypto_acomp_decompress(struct acomp_req *req)
 
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
-	if (crypto_acomp_req_chain(tfm) || acomp_request_issg(req))
+	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
 		return crypto_acomp_reqtfm(req)->decompress(req);
 	return acomp_do_req_chain(req, false);
 }
diff --git a/crypto/ahash.c b/crypto/ahash.c
index cc9885d5cfd2..57c131a13067 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -407,7 +407,7 @@ static int ahash_do_req_chain(struct ahash_request *req,
 	u8 *page = NULL;
 	int err;
 
-	if (crypto_ahash_req_chain(tfm) ||
+	if (crypto_ahash_req_virt(tfm) ||
 	    !update || !ahash_request_isvirt(req))
 		return op(req);
 
@@ -550,7 +550,7 @@ int crypto_ahash_finup(struct ahash_request *req)
 	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
 		return -EAGAIN;
 	if (!crypto_ahash_alg(tfm)->finup ||
-	    (!crypto_ahash_req_chain(tfm) && ahash_request_isvirt(req)))
+	    (!crypto_ahash_req_virt(tfm) && ahash_request_isvirt(req)))
 		return ahash_def_finup(req);
 	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->finup);
 }
@@ -622,7 +622,7 @@ int crypto_ahash_digest(struct ahash_request *req)
 		return shash_ahash_digest(req, prepare_shash_desc(req, tfm));
 	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
 		return -EAGAIN;
-	if (!crypto_ahash_req_chain(tfm) && ahash_request_isvirt(req))
+	if (!crypto_ahash_req_virt(tfm) && ahash_request_isvirt(req))
 		return ahash_def_digest(req);
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 0d2b64d96d6e..5f9fe51636ef 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -228,7 +228,7 @@ static struct acomp_alg acomp = {
 	.init			= deflate_init,
 	.base.cra_name		= "deflate",
 	.base.cra_driver_name	= "deflate-generic",
-	.base.cra_flags		= CRYPTO_ALG_REQ_CHAIN,
+	.base.cra_flags		= CRYPTO_ALG_REQ_VIRT,
 	.base.cra_module	= THIS_MODULE,
 };
 
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 15148c58d648..c651e7f2197a 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -355,7 +355,7 @@ static void scomp_prepare_alg(struct scomp_alg *alg)
 
 	comp_prepare_alg(&alg->calg);
 
-	base->cra_flags |= CRYPTO_ALG_REQ_CHAIN;
+	base->cra_flags |= CRYPTO_ALG_REQ_VIRT;
 }
 
 int crypto_register_scomp(struct scomp_alg *alg)
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index f5f730969d72..423e57eca351 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -255,9 +255,9 @@ static inline u32 crypto_tfm_alg_type(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
 }
 
-static inline bool crypto_tfm_req_chain(struct crypto_tfm *tfm)
+static inline bool crypto_tfm_req_virt(struct crypto_tfm *tfm)
 {
-	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_CHAIN;
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_VIRT;
 }
 
 static inline u32 crypto_request_flags(struct crypto_async_request *req)
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index b72bb7a6a2b2..ffffd88bbbad 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -186,9 +186,9 @@ static inline bool acomp_request_isnondma(struct acomp_req *req)
 				  CRYPTO_ACOMP_REQ_DST_NONDMA);
 }
 
-static inline bool crypto_acomp_req_chain(struct crypto_acomp *tfm)
+static inline bool crypto_acomp_req_virt(struct crypto_acomp *tfm)
 {
-	return crypto_tfm_req_chain(&tfm->base);
+	return crypto_tfm_req_virt(&tfm->base);
 }
 
 void crypto_acomp_free_streams(struct crypto_acomp_streams *s);
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 33d45275f5bd..e911f32f46dc 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -267,9 +267,9 @@ static inline bool ahash_request_isvirt(struct ahash_request *req)
 	return req->base.flags & CRYPTO_AHASH_REQ_VIRT;
 }
 
-static inline bool crypto_ahash_req_chain(struct crypto_ahash *tfm)
+static inline bool crypto_ahash_req_virt(struct crypto_ahash *tfm)
 {
-	return crypto_tfm_req_chain(&tfm->base);
+	return crypto_tfm_req_virt(&tfm->base);
 }
 
 static inline struct crypto_ahash *crypto_ahash_fb(struct crypto_ahash *tfm)
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b8d875b11193..b50f1954d1bb 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -133,8 +133,8 @@
  */
 #define CRYPTO_ALG_FIPS_INTERNAL	0x00020000
 
-/* Set if the algorithm supports request chains and virtual addresses. */
-#define CRYPTO_ALG_REQ_CHAIN		0x00040000
+/* Set if the algorithm supports virtual addresses. */
+#define CRYPTO_ALG_REQ_VIRT		0x00040000
 
 /* The high bits 0xff000000 are reserved for type-specific flags. */
 
-- 
2.39.5

