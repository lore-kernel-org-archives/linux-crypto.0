Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AF510E5
	for <linux-crypto@vger.kernel.org>; Sun,  9 Mar 2025 07:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741504752; cv=none; b=QebtpnLfO2mwER5IIg1DJmF+Yt8vyv0TECO9klTSIpyGJyuoJ4o0iWr301LPwR1hDoNmAynfskRVylc76F1z3jn3O4m1Lqgf8SmlLANNEOSNR6C5ioM94x6L0gkG0p2Ps4oDfDFB4kGSBBeyt+1ySEOA12KLF6ountrp/a4fKEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741504752; c=relaxed/simple;
	bh=Htai4vb1/4qrL/lW+bBE9mET//+CWzRebx133OMAyZs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kJSPXpH9xijtKrR2PUr0TJv6pQ2klbtJ6SQvEeJCVADLkO/0G+hYYD8tv7QzDAISeNBtDt/0JDrVzdp8JIoRuTZjmA2odlPpTTBHFt7xgGHGZciVVNBJV4P+hqN/DdzR3V0X3Rg5W6KI7N7UcCSKcYFzE4vJH8chsltZK7FKv0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IZPHLC0O; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IZPHLC0O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kiAeAMk4p5xFk2GstCg+MmOJUvj0srrchhGsh+Ctl74=; b=IZPHLC0Oy+f9ez17eltqkQ385U
	VkJ+USUdUn65inx1e3MON0kOka5L36qXi3e/0x00tuJsJb9DhpUK9+W1FeMWYCNrFvlHKMr/q5LUC
	J51GV1ZTIwHBbtLwTama6vxAmXT73B6rCM3yxyGfwn/jW5in6DRw5KWINakIZ5PAkf0uCB/lVMcpT
	pgkJ/72ObrbMKmo3rqo5IUQlpulHLq/Zvc4Pv60ybyenX82lfgx20BS+xjnfBIKYEhLlTg4zT3USn
	PacP2XXWBIA87EVRICVgqx+/L6nRxdwdBzDJjgveqBHaqbCpiVE4kNfXprDrpoZ0w2tdAKXl/DTk0
	Iq8aLV4Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1trAwD-0051ZA-1P;
	Sun, 09 Mar 2025 15:19:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Mar 2025 15:19:05 +0800
Date: Sun, 9 Mar 2025 15:19:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: acomp - Add ACOMP_REQUEST_ALLOC
Message-ID: <Z81A6buvWoAWTVzH@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Add ACOMP_REQUEST_ALLOC which is a wrapper around acomp_request_alloc
that falls back to a synchronous stack reqeust if the allocation
fails.

The request should be freed with acomp_request_free.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c         | 38 +++++++++++++++++++++++----
 include/crypto/acompress.h | 53 +++++++++++++++++++++++++++++++++++---
 include/linux/crypto.h     |  1 +
 3 files changed, 84 insertions(+), 8 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 194a4b36f97f..9da033ded193 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -60,28 +60,56 @@ static void crypto_acomp_exit_tfm(struct crypto_tfm *tfm)
 	struct crypto_acomp *acomp = __crypto_acomp_tfm(tfm);
 	struct acomp_alg *alg = crypto_acomp_alg(acomp);
 
-	alg->exit(acomp);
+	if (alg->exit)
+		alg->exit(acomp);
+
+	if (acomp_is_async(acomp))
+		crypto_free_acomp(acomp->fb);
 }
 
 static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_acomp *acomp = __crypto_acomp_tfm(tfm);
 	struct acomp_alg *alg = crypto_acomp_alg(acomp);
+	struct crypto_acomp *fb = NULL;
+	int err;
+
+	acomp->fb = acomp;
 
 	if (tfm->__crt_alg->cra_type != &crypto_acomp_type)
 		return crypto_init_scomp_ops_async(tfm);
 
+	if (acomp_is_async(acomp)) {
+		fb = crypto_alloc_acomp(crypto_acomp_alg_name(acomp), 0,
+					CRYPTO_ALG_ASYNC);
+		if (IS_ERR(fb))
+			return PTR_ERR(fb);
+
+		err = -EINVAL;
+		if (crypto_acomp_reqsize(fb) > MAX_SYNC_COMP_REQSIZE)
+			goto out_free_fb;
+
+		acomp->fb = fb;
+	}
+
 	acomp->compress = alg->compress;
 	acomp->decompress = alg->decompress;
 	acomp->reqsize = alg->reqsize;
 
-	if (alg->exit)
-		acomp->base.exit = crypto_acomp_exit_tfm;
+	acomp->base.exit = crypto_acomp_exit_tfm;
 
-	if (alg->init)
-		return alg->init(acomp);
+	if (!alg->init)
+		return 0;
+
+	err = alg->init(acomp);
+	if (err)
+		goto out_free_fb;
 
 	return 0;
+
+out_free_fb:
+	crypto_free_acomp(fb);
+	return err;
 }
 
 static unsigned int crypto_acomp_extsize(struct crypto_alg *alg)
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 53c9e632862b..3d131537b1de 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -10,6 +10,7 @@
 #define _CRYPTO_ACOMP_H
 
 #include <linux/atomic.h>
+#include <linux/args.h>
 #include <linux/compiler_types.h>
 #include <linux/container_of.h>
 #include <linux/crypto.h>
@@ -32,6 +33,14 @@
 
 #define CRYPTO_ACOMP_DST_MAX		131072
 
+#define	MAX_SYNC_COMP_REQSIZE		0
+
+#define ACOMP_REQUEST_ALLOC(name, tfm, gfp) \
+        char __##name##_req[sizeof(struct acomp_req) + \
+                            MAX_SYNC_COMP_REQSIZE] CRYPTO_MINALIGN_ATTR; \
+        struct acomp_req *name = acomp_request_on_stack_init( \
+                __##name##_req, (tfm), (gfp))
+
 struct acomp_req;
 
 struct acomp_req_chain {
@@ -83,12 +92,14 @@ struct acomp_req {
  * @compress:		Function performs a compress operation
  * @decompress:		Function performs a de-compress operation
  * @reqsize:		Context size for (de)compression requests
+ * @fb:			Synchronous fallback tfm
  * @base:		Common crypto API algorithm data structure
  */
 struct crypto_acomp {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
 	unsigned int reqsize;
+	struct crypto_acomp *fb;
 	struct crypto_tfm base;
 };
 
@@ -210,22 +221,39 @@ static inline int crypto_has_acomp(const char *alg_name, u32 type, u32 mask)
 	return crypto_has_alg(alg_name, type, mask);
 }
 
+static inline const char *crypto_acomp_alg_name(struct crypto_acomp *tfm)
+{
+	return crypto_tfm_alg_name(crypto_acomp_tfm(tfm));
+}
+
+static inline const char *crypto_acomp_driver_name(struct crypto_acomp *tfm)
+{
+	return crypto_tfm_alg_driver_name(crypto_acomp_tfm(tfm));
+}
+
 /**
  * acomp_request_alloc() -- allocates asynchronous (de)compression request
  *
  * @tfm:	ACOMPRESS tfm handle allocated with crypto_alloc_acomp()
+ * @gfp:	gfp to pass to kzalloc
  *
  * Return:	allocated handle in case of success or NULL in case of an error
  */
-static inline struct acomp_req *acomp_request_alloc_noprof(struct crypto_acomp *tfm)
+static inline struct acomp_req *acomp_request_alloc_noprof_1(
+	struct crypto_acomp *tfm, gfp_t gfp)
 {
 	struct acomp_req *req;
 
-	req = kzalloc_noprof(sizeof(*req) + crypto_acomp_reqsize(tfm), GFP_KERNEL);
+	req = kzalloc_noprof(sizeof(*req) + crypto_acomp_reqsize(tfm), gfp);
 	if (likely(req))
 		acomp_request_set_tfm(req, tfm);
 	return req;
 }
+#define acomp_request_alloc_noprof(tfm, ...) \
+	CONCATENATE(acomp_request_alloc_noprof_, COUNT_ARGS(__VA_ARGS__))( \
+		tfm, ##__VA_ARGS__)
+#define acomp_request_alloc_noprof_0(tfm) \
+	acomp_request_alloc_noprof_1(tfm, GFP_KERNEL)
 #define acomp_request_alloc(...)	alloc_hooks(acomp_request_alloc_noprof(__VA_ARGS__))
 
 /**
@@ -237,6 +265,8 @@ static inline struct acomp_req *acomp_request_alloc_noprof(struct crypto_acomp *
  */
 static inline void acomp_request_free(struct acomp_req *req)
 {
+	if ((req->base.flags & CRYPTO_TFM_REQ_ON_STACK))
+		return;
 	kfree_sensitive(req);
 }
 
@@ -257,7 +287,8 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 					      void *data)
 {
 	u32 keep = CRYPTO_ACOMP_REQ_SRC_VIRT | CRYPTO_ACOMP_REQ_SRC_NONDMA |
-		   CRYPTO_ACOMP_REQ_DST_VIRT | CRYPTO_ACOMP_REQ_DST_NONDMA;
+		   CRYPTO_ACOMP_REQ_DST_VIRT | CRYPTO_ACOMP_REQ_DST_NONDMA |
+		   CRYPTO_TFM_REQ_ON_STACK;
 
 	req->base.complete = cmpl;
 	req->base.data = data;
@@ -446,4 +477,20 @@ int crypto_acomp_compress(struct acomp_req *req);
  */
 int crypto_acomp_decompress(struct acomp_req *req);
 
+static inline struct acomp_req *acomp_request_on_stack_init(
+	char *buf, struct crypto_acomp *tfm, gfp_t gfp)
+{
+	struct acomp_req *req;
+
+	req = acomp_request_alloc(tfm, gfp);
+	if (req)
+		return req;
+
+	req = (void *)buf;
+	acomp_request_set_tfm(req, tfm->fb);
+	req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
+
+	return req;
+}
+
 #endif
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 61ac11226638..ea3b95bdbde3 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -138,6 +138,7 @@
 #define CRYPTO_TFM_REQ_FORBID_WEAK_KEYS	0x00000100
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
 #define CRYPTO_TFM_REQ_MAY_BACKLOG	0x00000400
+#define CRYPTO_TFM_REQ_ON_STACK		0x00000800
 
 /*
  * Miscellaneous stuff.
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
