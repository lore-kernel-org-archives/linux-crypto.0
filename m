Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2882F2367DC;
	Sat, 12 Apr 2025 05:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744435020; cv=none; b=XOl5XmN+86sNQKfRxjz8ARa1BMnQiS08MYejyYeBMZFU0Yd8qgwsCuhrwwy0MUeiCu4Gz4mCd0SJ+8AUqDzdGuQFWZlzchwPhqESbMjOd49a/6bf9SGkyyltmsfBuTzksz0fLCo9gioolKN9mig5dXOAWniO6Cuxq/p5FxsS5Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744435020; c=relaxed/simple;
	bh=9dpEZzEgXH+HzKlb6IgDyiCxBE7y5i4CpEE+zsCt+5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XBGcZDM++I+3uHa6cAkJtwKfW8Sg2qE5BPnk5MNUBnVFgkINp5d1Kk++B16CUmp/lNFDWDzyG5iIWMFL+UhCFcdPL7WoNNiFWgMA7TlaTUQwN9zgowkJwgDEMvie/hGM5XZXV+CjLZ7C8VRyf2MsZh8a1aFvQVVfdkjlk15GZ68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Vol2qJXL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Vol2qJXL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+XrbTBSjc+qDmni/xUAFp1chmC0E1MEZh2B8l5vX10I=; b=Vol2qJXLHx9NGbOAFlG2tjw5to
	TRrXTjEWxGEQGv5Ezu1bdqFdMi3YMQHDbDUU+fgbHEguySrNTJBBwRibEqsPO5xvosnCYoWvg9wBt
	jB4zr8R2MM0baVMWA3M2vmaw5ndnXpGFCVi3MCpYiXsqpSpQOfz0B3zTJGRPwOV6GpDcvLrGlxV1G
	3+v+EIWr4ZZVmr3jomUo0WDQf09daawFgl26/D/iWa7TJ1PGUnYqCjeg7Ee31uYczZPqoxbUudPut
	4V57VnuYyV1j8DZrgACHxem/gqPpZSnEys9W21MOUgp/P3mjeS32mLXLssg8l9e+Y12TDaPdxg/j6
	+ieZ0rSQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3TER-00F2kj-2J;
	Sat, 12 Apr 2025 13:16:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 13:16:43 +0800
Date: Sat, 12 Apr 2025 13:16:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sean Anderson <sean.anderson@linux.dev>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>
Subject: [PATCH] crypto: api - Add support for duplicating algorithms before
 registration
Message-ID: <Z_n3O_IZhbgQE02q@gondor.apana.org.au>
References: <17f9af67-de10-4b96-99ef-3c5cd78124c0@linux.dev>
 <Z_SxYFdyBJTYe_7G@gondor.apana.org.au>
 <e3dd2f83-8451-47b0-a774-a697b861ceb3@linux.dev>
 <Z_XiPLmSVs8PGTZD@gondor.apana.org.au>
 <Z_XpfyPaoZ6Y8u6z@gondor.apana.org.au>
 <cf7e20a2-dc30-4940-9abe-bbf5ea1ac413@linux.dev>
 <Z_hyG816TRNGoSaP@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_hyG816TRNGoSaP@gondor.apana.org.au>

On Fri, Apr 11, 2025 at 09:36:27AM +0800, Herbert Xu wrote:
> 
> The patch goes on top of cryptodev.  But it won't do anything
> without a corresponding patch to caam that moves the algorithm
> data structures into dynamically allocated memory, and adds a
> cra_destroy hook to free that memory.

Here's a patch on top that allows drivers to do this easily.
Unfortunately it still won't help caam because it embeds the
algorithm in a bigger structure, so the duplication needs to
be done by hand.

---8<---
If the bit CRYPTO_ALG_DUP_FIRST is set, an algorithm will be
duplicated by kmemdup before registration.  This is inteded for
hardware-based algorithms that may be unplugged at will.

Do not use this if the algorithm data structure is embedded in a
bigger data structure.  Perform the duplication in the driver
instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c     |  1 +
 crypto/aead.c          |  1 +
 crypto/ahash.c         |  1 +
 crypto/akcipher.c      |  1 +
 crypto/algapi.c        | 41 ++++++++++++++++++++++++++++-------------
 crypto/api.c           |  9 +++++++++
 crypto/internal.h      |  5 ++++-
 crypto/kpp.c           |  1 +
 crypto/lskcipher.c     |  1 +
 crypto/rng.c           |  1 +
 crypto/scompress.c     |  1 +
 crypto/shash.c         |  1 +
 crypto/sig.c           |  1 +
 crypto/skcipher.c      |  1 +
 include/linux/crypto.h |  9 +++++++++
 15 files changed, 61 insertions(+), 14 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 5d0b8b8b84f6..4763524732ba 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -152,6 +152,7 @@ static const struct crypto_type crypto_acomp_type = {
 	.maskset = CRYPTO_ALG_TYPE_ACOMPRESS_MASK,
 	.type = CRYPTO_ALG_TYPE_ACOMPRESS,
 	.tfmsize = offsetof(struct crypto_acomp, base),
+	.algsize = offsetof(struct acomp_alg, base),
 };
 
 struct crypto_acomp *crypto_alloc_acomp(const char *alg_name, u32 type,
diff --git a/crypto/aead.c b/crypto/aead.c
index 12f5b42171af..5d14b775036e 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -186,6 +186,7 @@ static const struct crypto_type crypto_aead_type = {
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_AEAD,
 	.tfmsize = offsetof(struct crypto_aead, base),
+	.algsize = offsetof(struct aead_alg, base),
 };
 
 int crypto_grab_aead(struct crypto_aead_spawn *spawn,
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 2d9eec2b2b1c..7ed88f8bedeb 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -897,6 +897,7 @@ static const struct crypto_type crypto_ahash_type = {
 	.maskset = CRYPTO_ALG_TYPE_AHASH_MASK,
 	.type = CRYPTO_ALG_TYPE_AHASH,
 	.tfmsize = offsetof(struct crypto_ahash, base),
+	.algsize = offsetof(struct ahash_alg, halg.base),
 };
 
 int crypto_grab_ahash(struct crypto_ahash_spawn *spawn,
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 72c82d9aa077..a36f50c83827 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -97,6 +97,7 @@ static const struct crypto_type crypto_akcipher_type = {
 	.maskset = CRYPTO_ALG_TYPE_AHASH_MASK,
 	.type = CRYPTO_ALG_TYPE_AKCIPHER,
 	.tfmsize = offsetof(struct crypto_akcipher, base),
+	.algsize = offsetof(struct akcipher_alg, base),
 };
 
 int crypto_grab_akcipher(struct crypto_akcipher_spawn *spawn,
diff --git a/crypto/algapi.c b/crypto/algapi.c
index f368c0dc0d6d..532d3efc3c7d 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -66,13 +66,7 @@ static int crypto_check_alg(struct crypto_alg *alg)
 
 static void crypto_free_instance(struct crypto_instance *inst)
 {
-	struct crypto_alg *alg = &inst->alg;
-	const struct crypto_type *type;
-
-	type = alg->cra_type;
-	if (type->destroy)
-		type->destroy(alg);
-	type->free(inst);
+	inst->alg.cra_type->free(inst);
 }
 
 static void crypto_destroy_instance_workfn(struct work_struct *w)
@@ -424,6 +418,15 @@ void crypto_remove_final(struct list_head *list)
 }
 EXPORT_SYMBOL_GPL(crypto_remove_final);
 
+static void crypto_free_alg(struct crypto_alg *alg)
+{
+	unsigned int algsize = alg->cra_type->algsize;
+	u8 *p = (u8 *)alg - algsize;
+
+	crypto_destroy_alg(alg);
+	kfree(p);
+}
+
 int crypto_register_alg(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval;
@@ -436,6 +439,19 @@ int crypto_register_alg(struct crypto_alg *alg)
 	if (err)
 		return err;
 
+	if (alg->cra_flags & CRYPTO_ALG_DUP_FIRST &&
+	    !WARN_ON_ONCE(alg->cra_destroy)) {
+		unsigned int algsize = alg->cra_type->algsize;
+		u8 *p = (u8 *)alg - algsize;
+
+		p = kmemdup(p, algsize + sizeof(*alg), GFP_KERNEL);
+		if (!p)
+			return -ENOMEM;
+
+		alg = (void *)(p + algsize);
+		alg->cra_destroy = crypto_free_alg;
+	}
+
 	down_write(&crypto_alg_sem);
 	larval = __crypto_register_alg(alg, &algs_to_put);
 	if (!IS_ERR_OR_NULL(larval)) {
@@ -444,8 +460,10 @@ int crypto_register_alg(struct crypto_alg *alg)
 	}
 	up_write(&crypto_alg_sem);
 
-	if (IS_ERR(larval))
+	if (IS_ERR(larval)) {
+		crypto_alg_put(alg);
 		return PTR_ERR(larval);
+	}
 
 	if (test_started)
 		crypto_schedule_test(larval);
@@ -481,12 +499,9 @@ void crypto_unregister_alg(struct crypto_alg *alg)
 	if (WARN(ret, "Algorithm %s is not registered", alg->cra_driver_name))
 		return;
 
-	if (alg->cra_destroy)
-		crypto_alg_put(alg);
-	else if (!WARN_ON(refcount_read(&alg->cra_refcnt) != 1) &&
-		 alg->cra_type && alg->cra_type->destroy)
-		alg->cra_type->destroy(alg);
+	WARN_ON(!alg->cra_destroy && refcount_read(&alg->cra_refcnt) != 1);
 
+	list_add(&alg->cra_list, &list);
 	crypto_remove_final(&list);
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_alg);
diff --git a/crypto/api.c b/crypto/api.c
index 2880aa04bb99..e427cc5662b5 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -703,5 +703,14 @@ void crypto_req_done(void *data, int err)
 }
 EXPORT_SYMBOL_GPL(crypto_req_done);
 
+void crypto_destroy_alg(struct crypto_alg *alg)
+{
+	if (alg->cra_type && alg->cra_type->destroy)
+		alg->cra_type->destroy(alg);
+	if (alg->cra_destroy)
+		alg->cra_destroy(alg);
+}
+EXPORT_SYMBOL_GPL(crypto_destroy_alg);
+
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
diff --git a/crypto/internal.h b/crypto/internal.h
index 2edefb546ad4..2ed79bf208ca 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -46,6 +46,7 @@ struct crypto_type {
 	unsigned int maskclear;
 	unsigned int maskset;
 	unsigned int tfmsize;
+	unsigned int algsize;
 };
 
 enum {
@@ -162,10 +163,12 @@ static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
 	return alg;
 }
 
+void crypto_destroy_alg(struct crypto_alg *alg);
+
 static inline void crypto_alg_put(struct crypto_alg *alg)
 {
 	if (refcount_dec_and_test(&alg->cra_refcnt))
-		alg->cra_destroy(alg);
+		crypto_destroy_alg(alg);
 }
 
 static inline int crypto_tmpl_get(struct crypto_template *tmpl)
diff --git a/crypto/kpp.c b/crypto/kpp.c
index ecc63a1a948d..2e0cefe7a25f 100644
--- a/crypto/kpp.c
+++ b/crypto/kpp.c
@@ -80,6 +80,7 @@ static const struct crypto_type crypto_kpp_type = {
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_KPP,
 	.tfmsize = offsetof(struct crypto_kpp, base),
+	.algsize = offsetof(struct kpp_alg, base),
 };
 
 struct crypto_kpp *crypto_alloc_kpp(const char *alg_name, u32 type, u32 mask)
diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index cdb4897c63e6..c2e2c38b5aa8 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -294,6 +294,7 @@ static const struct crypto_type crypto_lskcipher_type = {
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_LSKCIPHER,
 	.tfmsize = offsetof(struct crypto_lskcipher, base),
+	.algsize = offsetof(struct lskcipher_alg, co.base),
 };
 
 static void crypto_lskcipher_exit_tfm_sg(struct crypto_tfm *tfm)
diff --git a/crypto/rng.c b/crypto/rng.c
index 9d8804e46422..b8ae6ebc091d 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -98,6 +98,7 @@ static const struct crypto_type crypto_rng_type = {
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_RNG,
 	.tfmsize = offsetof(struct crypto_rng, base),
+	.algsize = offsetof(struct rng_alg, base),
 };
 
 struct crypto_rng *crypto_alloc_rng(const char *alg_name, u32 type, u32 mask)
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 4a2b3933aa95..19f1312d7dd7 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -367,6 +367,7 @@ static const struct crypto_type crypto_scomp_type = {
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_SCOMPRESS,
 	.tfmsize = offsetof(struct crypto_scomp, base),
+	.algsize = offsetof(struct scomp_alg, base),
 };
 
 static void scomp_prepare_alg(struct scomp_alg *alg)
diff --git a/crypto/shash.c b/crypto/shash.c
index 301ab42bf849..a2a7d6609172 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -227,6 +227,7 @@ const struct crypto_type crypto_shash_type = {
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_SHASH,
 	.tfmsize = offsetof(struct crypto_shash, base),
+	.algsize = offsetof(struct shash_alg, base),
 };
 
 int crypto_grab_shash(struct crypto_shash_spawn *spawn,
diff --git a/crypto/sig.c b/crypto/sig.c
index dfc7cae90802..f2df943b96e1 100644
--- a/crypto/sig.c
+++ b/crypto/sig.c
@@ -74,6 +74,7 @@ static const struct crypto_type crypto_sig_type = {
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_SIG,
 	.tfmsize = offsetof(struct crypto_sig, base),
+	.algsize = offsetof(struct sig_alg, base),
 };
 
 struct crypto_sig *crypto_alloc_sig(const char *alg_name, u32 type, u32 mask)
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 132075a905d9..319215cfded5 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -620,6 +620,7 @@ static const struct crypto_type crypto_skcipher_type = {
 	.maskset = CRYPTO_ALG_TYPE_SKCIPHER_MASK,
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.tfmsize = offsetof(struct crypto_skcipher, base),
+	.algsize = offsetof(struct skcipher_alg, base),
 };
 
 int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 1e3809d28abd..f87f124ddc18 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -50,6 +50,15 @@
  */
 #define CRYPTO_ALG_NEED_FALLBACK	0x00000100
 
+/*
+ * Set if the algorithm data structure should be duplicated into
+ * kmalloc memory before registration.  This is useful for hardware
+ * that can be disconnected at will.  Do not use this if the data
+ * structure is embedded into a bigger one.  Duplicate the overall
+ * data structure in the driver in that case.
+ */
+#define CRYPTO_ALG_DUP_FIRST		0x00000200
+
 /*
  * Set if the algorithm has passed automated run-time testing.  Note that
  * if there is no run-time testing for a given algorithm it is considered
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
