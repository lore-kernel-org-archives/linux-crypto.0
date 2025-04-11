Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0B827BF6C
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 07:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744355667; cv=none; b=koZ7De8wUs2VVOyDF9S20TsN1VcwwthWrbFmWXhptvGGoWjbiP1bRzedF/M46JWb/ZM3yGBazLZvYK5nF1WSaPZdukvsM5XvBKv1ywb4STfRKwA3DyEnMftsJocdt/B1hVskfB0NRxYq/EIaFYjg30B08VScxVR+4JMoalQ5Ork=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744355667; c=relaxed/simple;
	bh=7yPFJBGVbo7jT3NInKelP4qJ0Rsa8BenCw3Mdjx4lJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KRXDJpNKabaN8jzw9zFEVx7RvhUu0pfv7Seo0sRfhLGSJ77X18EzQHzEvDa4N184vgLqPx1nXvysx/5CMhvWUx/NWgr4TNnJlDnd+NFPLhNm7qp1CI3hPgar/xZOf/vtOJriGw0mQSgWdXwNlXjtS45dVf0Q9pcJYsg7BLc44Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=V/2b6Xm5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="V/2b6Xm5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=A+LWTC6rxGdP2CqxCgA7I5dC7aG8EyaScNUoOmv3JZw=; b=V/2b6Xm5i08T/+YlQMszKmQsEd
	AyXClLKsuCEgUtTWjfJnoZJm2QDWSorG1ZtKkT0XM7FCrjCEe9c35AFoXSDYTLAe8+YtlGf9//v22
	X3zyvJ7DFVUD2+NlnTQ6seHWn27NdmianzYGS7rl2EoW4Yh6f13hMFjpS5jKhLp+6tNNZrlhlw2vW
	nXXvzY8Del9/D+R7mN8m/jgGM2eCw+Qeku2498OKYVestIjd4ltpyVKLB1z3Uxw3vPzazEsPdh5et
	8J6Rneabge7WLOAv+CF7GjI7X2eTfBYQx4h7q6N00EbkLi7fKZsmvBCEoz+hFz71l6YQy4P3ZbSDl
	8yaV4oKg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u38ag-00ElTP-1Y;
	Fri, 11 Apr 2025 15:14:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Apr 2025 15:14:18 +0800
Date: Fri, 11 Apr 2025 15:14:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Manorit Chawdhry <m-chawdhry@ti.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>, Udit Kumar <u-kumar1@ti.com>,
	Pratham T <t-pratham@ti.com>
Subject: [PATCH] crypto: ahash - Disable request chaining
Message-ID: <Z_jBSnzQ-B-IVghn@gondor.apana.org.au>
References: <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
 <20250411053426.5vmvji5nthajphzo@uda0497581-HP>
 <Z_iqg1oxdPecgzlK@gondor.apana.org.au>
 <20250411054458.enlz5be2julr6zlx@uda0497581-HP>
 <Z_isukjVYANljETv@gondor.apana.org.au>
 <20250411061417.nxi56rto53fl5cnx@uda0497581-HP>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250411061417.nxi56rto53fl5cnx@uda0497581-HP>

On Fri, Apr 11, 2025 at 11:44:17AM +0530, Manorit Chawdhry wrote:
> 
> Maybe it's not the chaining but the way chaining was implemented that
> requires us to start using these correct API helpers otherwise we crash
> so I think we would require the following patch.

You're right.  This needs to be disabled more thoroughly for 6.15.
Please try this patch:

---8<---
Disable hash request chaining in case a driver that copies an
ahash_request object by hand accidentally triggers chaining.

Reported-by: Manorit Chawdhry <m-chawdhry@ti.com>
Fixes: f2ffe5a9183d ("crypto: hash - Add request chaining API")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 9f57b925b116..2d9eec2b2b1c 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -315,16 +315,7 @@ EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
 
 static bool ahash_request_hasvirt(struct ahash_request *req)
 {
-	struct ahash_request *r2;
-
-	if (ahash_request_isvirt(req))
-		return true;
-
-	list_for_each_entry(r2, &req->base.list, base.list)
-		if (ahash_request_isvirt(r2))
-			return true;
-
-	return false;
+	return ahash_request_isvirt(req);
 }
 
 static int ahash_reqchain_virt(struct ahash_save_req_state *state,
@@ -472,7 +463,6 @@ static int ahash_do_req_chain(struct ahash_request *req,
 	bool update = op == crypto_ahash_alg(tfm)->update;
 	struct ahash_save_req_state *state;
 	struct ahash_save_req_state state0;
-	struct ahash_request *r2;
 	u8 *page = NULL;
 	int err;
 
@@ -509,7 +499,6 @@ static int ahash_do_req_chain(struct ahash_request *req,
 	state->offset = 0;
 	state->nbytes = 0;
 	INIT_LIST_HEAD(&state->head);
-	list_splice_init(&req->base.list, &state->head);
 
 	if (page)
 		sg_init_one(&state->sg, page, PAGE_SIZE);
@@ -540,9 +529,6 @@ static int ahash_do_req_chain(struct ahash_request *req,
 
 out_set_chain:
 	req->base.err = err;
-	list_for_each_entry(r2, &req->base.list, base.list)
-		r2->base.err = err;
-
 	return err;
 }
 
@@ -551,19 +537,10 @@ int crypto_ahash_init(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
 	if (likely(tfm->using_shash)) {
-		struct ahash_request *r2;
 		int err;
 
 		err = crypto_shash_init(prepare_shash_desc(req, tfm));
 		req->base.err = err;
-
-		list_for_each_entry(r2, &req->base.list, base.list) {
-			struct shash_desc *desc;
-
-			desc = prepare_shash_desc(r2, tfm);
-			r2->base.err = crypto_shash_init(desc);
-		}
-
 		return err;
 	}
 
@@ -620,19 +597,10 @@ int crypto_ahash_update(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
 	if (likely(tfm->using_shash)) {
-		struct ahash_request *r2;
 		int err;
 
 		err = shash_ahash_update(req, ahash_request_ctx(req));
 		req->base.err = err;
-
-		list_for_each_entry(r2, &req->base.list, base.list) {
-			struct shash_desc *desc;
-
-			desc = ahash_request_ctx(r2);
-			r2->base.err = shash_ahash_update(r2, desc);
-		}
-
 		return err;
 	}
 
@@ -645,19 +613,10 @@ int crypto_ahash_final(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
 	if (likely(tfm->using_shash)) {
-		struct ahash_request *r2;
 		int err;
 
 		err = crypto_shash_final(ahash_request_ctx(req), req->result);
 		req->base.err = err;
-
-		list_for_each_entry(r2, &req->base.list, base.list) {
-			struct shash_desc *desc;
-
-			desc = ahash_request_ctx(r2);
-			r2->base.err = crypto_shash_final(desc, r2->result);
-		}
-
 		return err;
 	}
 
@@ -670,19 +629,10 @@ int crypto_ahash_finup(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
 	if (likely(tfm->using_shash)) {
-		struct ahash_request *r2;
 		int err;
 
 		err = shash_ahash_finup(req, ahash_request_ctx(req));
 		req->base.err = err;
-
-		list_for_each_entry(r2, &req->base.list, base.list) {
-			struct shash_desc *desc;
-
-			desc = ahash_request_ctx(r2);
-			r2->base.err = shash_ahash_finup(r2, desc);
-		}
-
 		return err;
 	}
 
@@ -757,19 +707,10 @@ int crypto_ahash_digest(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
 	if (likely(tfm->using_shash)) {
-		struct ahash_request *r2;
 		int err;
 
 		err = shash_ahash_digest(req, prepare_shash_desc(req, tfm));
 		req->base.err = err;
-
-		list_for_each_entry(r2, &req->base.list, base.list) {
-			struct shash_desc *desc;
-
-			desc = prepare_shash_desc(r2, tfm);
-			r2->base.err = shash_ahash_digest(r2, desc);
-		}
-
 		return err;
 	}
 
@@ -1133,20 +1074,5 @@ int ahash_register_instance(struct crypto_template *tmpl,
 }
 EXPORT_SYMBOL_GPL(ahash_register_instance);
 
-void ahash_request_free(struct ahash_request *req)
-{
-	struct ahash_request *tmp;
-	struct ahash_request *r2;
-
-	if (unlikely(!req))
-		return;
-
-	list_for_each_entry_safe(r2, tmp, &req->base.list, base.list)
-		kfree_sensitive(r2);
-
-	kfree_sensitive(req);
-}
-EXPORT_SYMBOL_GPL(ahash_request_free);
-
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 2aa83ee0ec98..a67988316d06 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -10,6 +10,7 @@
 
 #include <linux/atomic.h>
 #include <linux/crypto.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 
 /* Set this bit for virtual address instead of SG list. */
@@ -581,7 +582,10 @@ static inline struct ahash_request *ahash_request_alloc_noprof(
  * ahash_request_free() - zeroize and free the request data structure
  * @req: request data structure cipher handle to be freed
  */
-void ahash_request_free(struct ahash_request *req);
+static inline void ahash_request_free(struct ahash_request *req)
+{
+	kfree_sensitive(req);
+}
 
 static inline struct ahash_request *ahash_request_cast(
 	struct crypto_async_request *req)
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 485e22cf517e..052ac7924af3 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -249,7 +249,7 @@ static inline struct crypto_shash *__crypto_shash_cast(struct crypto_tfm *tfm)
 
 static inline bool ahash_request_chained(struct ahash_request *req)
 {
-	return crypto_request_chained(&req->base);
+	return false;
 }
 
 static inline bool ahash_request_isvirt(struct ahash_request *req)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
