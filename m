Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875F516C854
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 05:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744436223; cv=none; b=tJlC/BH7fLgvwFjIptBJCEHs0w1KGwptJvd8RAB9EesUJU3raTHX2QWY0JxVhAhQ1AsxnNRmKdtvYITmYB0J+NXtkMFqmpZZP3tbjxHYhwEoWxNqMEGdUkcYumOVIoSYQo4TTr8mFwWiqpKhJnXlqzbskSVbMrnGD+sKAqHjgAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744436223; c=relaxed/simple;
	bh=9GEBywnO8lwRoH5xS15IVLPWEK5GhIaSQ9y6hnAXdP4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=j/eeve1lHWXzzOqSoQIJuqonDHYdOKVvYSKrUzF16vr6gzN9P3dONdQKt0BZ6k/ruDKwDliWY+vlt5GOlvF6oUVpckAKtuy90q95O7PZKwBgh5zvFdHqGtTRzOAelFFjX/QDvsusdiRncVPGNPEGse/z/SiBg++dKM6RiqpEOl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DLnDN+Qg; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DLnDN+Qg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PZGKu8BWHd/SslU30IDQGRA7vI9yAD07fRpHz8ky+7Q=; b=DLnDN+QgiDfDbcWD0/v8BX7IBF
	NO2gpNkZOgTPlznJlqRXVyU1BGlPCE2W0ud1fT4DOfeZkJ4M3W3iuKHd3h2gAPoOpD4o4nYIs4zod
	gJ4ZQAac3Y2osDh3NG4u+EHVLQ6fbKv46bQ3T2sAft07f4erKm0qD4OBqYR2RtiqgPY8oLsauLYpk
	8YQ+YbPDn7thXUlkJPo9uq9EcuQhJIoEpqnlvK03/kH4WQSE+S5qRbuFLbe97QdzhwgtYGNdsBWSD
	cBgPegmJ/Z0C8f1tCs7SVNa88kAvQ4lCG5FSFafLgYXWT/3LfGDSrA1MLhW3m3lq+kKUr/57kmrz8
	ygL9BZlw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3TXz-00F2sg-2J;
	Sat, 12 Apr 2025 13:36:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 13:36:55 +0800
Date: Sat, 12 Apr 2025 13:36:55 +0800
Message-Id: <a23e434e735e1a75f5110b70c5750674d1f2dea4.1744436095.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744436095.git.herbert@gondor.apana.org.au>
References: <cover.1744436095.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 3/5] crypto: acomp - Remove request chaining
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Request chaining requires the user to do too much book keeping.
Remove it from acomp.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  | 117 ++++++++--------------------
 crypto/scompress.c                  |  18 +----
 include/crypto/acompress.h          |  14 ----
 include/crypto/internal/acompress.h |   5 --
 4 files changed, 35 insertions(+), 119 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 4763524732ba..9a7a3a1741a0 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -178,7 +178,6 @@ static void acomp_save_req(struct acomp_req *req, crypto_completion_t cplt)
 	state->data = req->base.data;
 	req->base.complete = cplt;
 	req->base.data = state;
-	state->req0 = req;
 }
 
 static void acomp_restore_req(struct acomp_req *req)
@@ -189,23 +188,20 @@ static void acomp_restore_req(struct acomp_req *req)
 	req->base.data = state->data;
 }
 
-static void acomp_reqchain_virt(struct acomp_req_chain *state, int err)
+static void acomp_reqchain_virt(struct acomp_req *req)
 {
-	struct acomp_req *req = state->cur;
+	struct acomp_req_chain *state = &req->chain;
 	unsigned int slen = req->slen;
 	unsigned int dlen = req->dlen;
 
-	req->base.err = err;
-	state = &req->chain;
-
 	if (state->flags & CRYPTO_ACOMP_REQ_SRC_VIRT)
 		acomp_request_set_src_dma(req, state->src, slen);
 	else if (state->flags & CRYPTO_ACOMP_REQ_SRC_FOLIO)
-		acomp_request_set_src_folio(req, state->sfolio, state->soff, slen);
+		acomp_request_set_src_folio(req, state->sfolio, req->soff, slen);
 	if (state->flags & CRYPTO_ACOMP_REQ_DST_VIRT)
 		acomp_request_set_dst_dma(req, state->dst, dlen);
 	else if (state->flags & CRYPTO_ACOMP_REQ_DST_FOLIO)
-		acomp_request_set_dst_folio(req, state->dfolio, state->doff, dlen);
+		acomp_request_set_dst_folio(req, state->dfolio, req->doff, dlen);
 }
 
 static void acomp_virt_to_sg(struct acomp_req *req)
@@ -230,7 +226,6 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 		size_t off = req->soff;
 
 		state->sfolio = folio;
-		state->soff = off;
 		sg_init_table(&state->ssg, 1);
 		sg_set_page(&state->ssg, folio_page(folio, off / PAGE_SIZE),
 			    slen, off % PAGE_SIZE);
@@ -250,7 +245,6 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 		size_t off = req->doff;
 
 		state->dfolio = folio;
-		state->doff = off;
 		sg_init_table(&state->dsg, 1);
 		sg_set_page(&state->dsg, folio_page(folio, off / PAGE_SIZE),
 			    dlen, off % PAGE_SIZE);
@@ -258,8 +252,7 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 	}
 }
 
-static int acomp_do_nondma(struct acomp_req_chain *state,
-			   struct acomp_req *req)
+static int acomp_do_nondma(struct acomp_req *req, bool comp)
 {
 	u32 keep = CRYPTO_ACOMP_REQ_SRC_VIRT |
 		   CRYPTO_ACOMP_REQ_SRC_NONDMA |
@@ -276,7 +269,7 @@ static int acomp_do_nondma(struct acomp_req_chain *state,
 	fbreq->slen = req->slen;
 	fbreq->dlen = req->dlen;
 
-	if (state->op == crypto_acomp_reqtfm(req)->compress)
+	if (comp)
 		err = crypto_acomp_compress(fbreq);
 	else
 		err = crypto_acomp_decompress(fbreq);
@@ -285,114 +278,70 @@ static int acomp_do_nondma(struct acomp_req_chain *state,
 	return err;
 }
 
-static int acomp_do_one_req(struct acomp_req_chain *state,
-			    struct acomp_req *req)
+static int acomp_do_one_req(struct acomp_req *req, bool comp)
 {
-	state->cur = req;
-
 	if (acomp_request_isnondma(req))
-		return acomp_do_nondma(state, req);
+		return acomp_do_nondma(req, comp);
 
 	acomp_virt_to_sg(req);
-	return state->op(req);
+	return comp ? crypto_acomp_reqtfm(req)->compress(req) :
+		      crypto_acomp_reqtfm(req)->decompress(req);
 }
 
-static int acomp_reqchain_finish(struct acomp_req *req0, int err, u32 mask)
+static int acomp_reqchain_finish(struct acomp_req *req, int err)
 {
-	struct acomp_req_chain *state = req0->base.data;
-	struct acomp_req *req = state->cur;
-	struct acomp_req *n;
-
-	acomp_reqchain_virt(state, err);
-
-	if (req != req0)
-		list_add_tail(&req->base.list, &req0->base.list);
-
-	list_for_each_entry_safe(req, n, &state->head, base.list) {
-		list_del_init(&req->base.list);
-
-		req->base.flags &= mask;
-		req->base.complete = acomp_reqchain_done;
-		req->base.data = state;
-
-		err = acomp_do_one_req(state, req);
-
-		if (err == -EINPROGRESS) {
-			if (!list_empty(&state->head))
-				err = -EBUSY;
-			goto out;
-		}
-
-		if (err == -EBUSY)
-			goto out;
-
-		acomp_reqchain_virt(state, err);
-		list_add_tail(&req->base.list, &req0->base.list);
-	}
-
-	acomp_restore_req(req0);
-
-out:
+	acomp_reqchain_virt(req);
+	acomp_restore_req(req);
 	return err;
 }
 
 static void acomp_reqchain_done(void *data, int err)
 {
-	struct acomp_req_chain *state = data;
-	crypto_completion_t compl = state->compl;
+	struct acomp_req *req = data;
+	crypto_completion_t compl;
 
-	data = state->data;
+	compl = req->chain.compl;
+	data = req->chain.data;
 
-	if (err == -EINPROGRESS) {
-		if (!list_empty(&state->head))
-			return;
+	if (err == -EINPROGRESS)
 		goto notify;
-	}
 
-	err = acomp_reqchain_finish(state->req0, err,
-				    CRYPTO_TFM_REQ_MAY_BACKLOG);
-	if (err == -EBUSY)
-		return;
+	err = acomp_reqchain_finish(req, err);
 
 notify:
 	compl(data, err);
 }
 
-static int acomp_do_req_chain(struct acomp_req *req,
-			      int (*op)(struct acomp_req *req))
+static int acomp_do_req_chain(struct acomp_req *req, bool comp)
 {
-	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-	struct acomp_req_chain *state;
 	int err;
 
-	if (crypto_acomp_req_chain(tfm) ||
-	    (!acomp_request_chained(req) && acomp_request_issg(req)))
-		return op(req);
-
 	acomp_save_req(req, acomp_reqchain_done);
-	state = req->base.data;
 
-	state->op = op;
-	state->src = NULL;
-	INIT_LIST_HEAD(&state->head);
-	list_splice_init(&req->base.list, &state->head);
-
-	err = acomp_do_one_req(state, req);
+	err = acomp_do_one_req(req, comp);
 	if (err == -EBUSY || err == -EINPROGRESS)
-		return -EBUSY;
+		return err;
 
-	return acomp_reqchain_finish(req, err, ~0);
+	return acomp_reqchain_finish(req, err);
 }
 
 int crypto_acomp_compress(struct acomp_req *req)
 {
-	return acomp_do_req_chain(req, crypto_acomp_reqtfm(req)->compress);
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+
+	if (crypto_acomp_req_chain(tfm) || acomp_request_issg(req))
+		crypto_acomp_reqtfm(req)->compress(req);
+	return acomp_do_req_chain(req, true);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_compress);
 
 int crypto_acomp_decompress(struct acomp_req *req)
 {
-	return acomp_do_req_chain(req, crypto_acomp_reqtfm(req)->decompress);
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+
+	if (crypto_acomp_req_chain(tfm) || acomp_request_issg(req))
+		crypto_acomp_reqtfm(req)->decompress(req);
+	return acomp_do_req_chain(req, false);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
 
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 19f1312d7dd7..e7520e001105 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -284,28 +284,14 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	return ret;
 }
 
-static int scomp_acomp_chain(struct acomp_req *req, int dir)
-{
-	struct acomp_req *r2;
-	int err;
-
-	err = scomp_acomp_comp_decomp(req, dir);
-	req->base.err = err;
-
-	list_for_each_entry(r2, &req->base.list, base.list)
-		r2->base.err = scomp_acomp_comp_decomp(r2, dir);
-
-	return err;
-}
-
 static int scomp_acomp_compress(struct acomp_req *req)
 {
-	return scomp_acomp_chain(req, 1);
+	return scomp_acomp_comp_decomp(req, 1);
 }
 
 static int scomp_acomp_decompress(struct acomp_req *req)
 {
-	return scomp_acomp_chain(req, 0);
+	return scomp_acomp_comp_decomp(req, 0);
 }
 
 static void crypto_exit_scomp_ops_async(struct crypto_tfm *tfm)
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index f0e01ff77d92..080e134df35c 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -52,10 +52,6 @@ struct acomp_req;
 struct folio;
 
 struct acomp_req_chain {
-	struct list_head head;
-	struct acomp_req *req0;
-	struct acomp_req *cur;
-	int (*op)(struct acomp_req *req);
 	crypto_completion_t compl;
 	void *data;
 	struct scatterlist ssg;
@@ -68,8 +64,6 @@ struct acomp_req_chain {
 		u8 *dst;
 		struct folio *dfolio;
 	};
-	size_t soff;
-	size_t doff;
 	u32 flags;
 };
 
@@ -343,8 +337,6 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 	req->base.data = data;
 	req->base.flags &= keep;
 	req->base.flags |= flgs & ~keep;
-
-	crypto_reqchain_init(&req->base);
 }
 
 /**
@@ -552,12 +544,6 @@ static inline void acomp_request_set_dst_folio(struct acomp_req *req,
 	req->base.flags |= CRYPTO_ACOMP_REQ_DST_FOLIO;
 }
 
-static inline void acomp_request_chain(struct acomp_req *req,
-				       struct acomp_req *head)
-{
-	crypto_request_chain(&req->base, &head->base);
-}
-
 /**
  * crypto_acomp_compress() -- Invoke asynchronous compress operation
  *
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index fbbff9a8a2d9..960cdd1f3a57 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -151,11 +151,6 @@ void crypto_unregister_acomp(struct acomp_alg *alg);
 int crypto_register_acomps(struct acomp_alg *algs, int count);
 void crypto_unregister_acomps(struct acomp_alg *algs, int count);
 
-static inline bool acomp_request_chained(struct acomp_req *req)
-{
-	return crypto_request_chained(&req->base);
-}
-
 static inline bool acomp_request_issg(struct acomp_req *req)
 {
 	return !(req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
-- 
2.39.5

