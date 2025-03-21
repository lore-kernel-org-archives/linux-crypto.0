Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EFE1EFF9A
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 08:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742546620; cv=none; b=tNbY6hOOd2kjQiPr2Dbrw41yWBkMqETpvhKUWrdHA2vU+7x489OYEj1zJMDDjTEJroBLrgGrG0wP+188C6aZAHb4koKWYAJ33sfgpzctblaNcj3Y5UuwTiPSKZpnm3T2vgvKep3GetN3wB2E9D2GWLbqJnoLfyHKs3tWL4LvIik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742546620; c=relaxed/simple;
	bh=rs1Et5T5uf8vgUN5PswoTpFqrjPvr6iJG8mCjQLyoao=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=Z5/3HL190PfcqEfwVejbLeqHPYb1lUlXP5wla6Iuthoe/NIBkmExaWCtkROSI8OSs4abeOaFQJt2S2gFpCmi0XCVvdAAwJDGYi04fUl5HJY9jL/toIDDIbwCNpRUD2jfwYuEuqWBHt58PqMPds5kkDPu5S8ktq+GH0QAci/d6Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=snFg9Yuo; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="snFg9Yuo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=UYefgwDir3W+0ZeY28DpkgEAml/Kpzx9qm5cIo22mCk=; b=snFg9YuomC0AJP3meSdkzpbjOm
	4ZioOyZMxe1G7YGQBcO94z4qLIw9TGp9R8Nq3vVbpnrITD5fFqO5Q57/bKWdKOeHXO2rldL5ubGNq
	0shKNBagq5OMOmOzbw07r8bNq2ysW8OawOm22sZ3wFk6Y6BQB5VZ0litAiPYlkx+6LUw2nK+/1gS9
	wLMu3Si65AzgBQ7NA1jrqGvGOpaRggZx4T1hMIWeQjq7tnG7+iDspT+ddH2dgojPwxfpRI+u9FWa3
	I7usO4atQZ7Xt8fzmMXGp9v5EtY4JJO2Nlpg4RPMdyBEAJYC//1A6O/LkU9Y4FzBWT0/C9vzQAJj5
	6sYBhZKw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvXyS-008xvU-10;
	Fri, 21 Mar 2025 16:43:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 16:43:28 +0800
Date: Fri, 21 Mar 2025 16:43:28 +0800
Message-Id: <9a84f666cc312786bb85def7d7f03b771a16d397.1742546178.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742546178.git.herbert@gondor.apana.org.au>
References: <cover.1742546178.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/4] crypto: hash - Fix synchronous ahash chaining fallback
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The synchronous ahash fallback code paths are broken because the
ahash_restore_req assumes there is always a state object.  Fix this
by removing the state from ahash_restore_req and localising it to
the asynchronous completion callback.

Also add a missing synchronous finish call in ahash_def_digest_finish.

Fixes: f2ffe5a9183d ("crypto: hash - Add request chaining API")
Fixes: 439963cdc3aa ("crypto: ahash - Add virtual address support")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c | 60 +++++++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 32 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 9c26175c21a8..f0068c72a9e1 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -57,8 +57,9 @@ struct ahash_save_req_state {
 
 static void ahash_reqchain_done(void *data, int err);
 static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt);
-static void ahash_restore_req(struct ahash_save_req_state *state);
+static void ahash_restore_req(struct ahash_request *req);
 static void ahash_def_finup_done1(void *data, int err);
+static int ahash_def_finup_finish1(struct ahash_request *req, int err);
 static int ahash_def_finup(struct ahash_request *req);
 
 static int hash_walk_next(struct crypto_hash_walk *walk)
@@ -357,14 +358,15 @@ static int ahash_reqchain_virt(struct ahash_save_req_state *state,
 	return err;
 }
 
-static int ahash_reqchain_finish(struct ahash_save_req_state *state,
+static int ahash_reqchain_finish(struct ahash_request *req0,
+				 struct ahash_save_req_state *state,
 				 int err, u32 mask)
 {
-	struct ahash_request *req0 = state->req0;
 	struct ahash_request *req = state->cur;
 	struct crypto_ahash *tfm;
 	struct ahash_request *n;
 	bool update;
+	u8 *page;
 
 	err = ahash_reqchain_virt(state, err, mask);
 	if (err == -EINPROGRESS || err == -EBUSY)
@@ -418,7 +420,12 @@ static int ahash_reqchain_finish(struct ahash_save_req_state *state,
 		list_add_tail(&req->base.list, &req0->base.list);
 	}
 
-	ahash_restore_req(state);
+	page = state->page;
+	if (page) {
+		memset(page, 0, PAGE_SIZE);
+		free_page((unsigned long)page);
+	}
+	ahash_restore_req(req0);
 
 out:
 	return err;
@@ -437,7 +444,8 @@ static void ahash_reqchain_done(void *data, int err)
 		goto notify;
 	}
 
-	err = ahash_reqchain_finish(state, err, CRYPTO_TFM_REQ_MAY_BACKLOG);
+	err = ahash_reqchain_finish(state->req0, state, err,
+				    CRYPTO_TFM_REQ_MAY_BACKLOG);
 	if (err == -EBUSY)
 		return;
 
@@ -513,13 +521,10 @@ static int ahash_do_req_chain(struct ahash_request *req,
 	if (err == -EBUSY || err == -EINPROGRESS)
 		return -EBUSY;
 
-	return ahash_reqchain_finish(state, err, ~0);
+	return ahash_reqchain_finish(req, state, err, ~0);
 
 out_free_page:
-	if (page) {
-		memset(page, 0, PAGE_SIZE);
-		free_page((unsigned long)page);
-	}
+	free_page((unsigned long)page);
 
 out_set_chain:
 	req->base.err = err;
@@ -578,18 +583,15 @@ static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
 	req->base.complete = cplt;
 	req->base.data = state;
 	state->req0 = req;
-	state->page = NULL;
 
 	return 0;
 }
 
-static void ahash_restore_req(struct ahash_save_req_state *state)
+static void ahash_restore_req(struct ahash_request *req)
 {
-	struct ahash_request *req = state->req0;
+	struct ahash_save_req_state *state;
 	struct crypto_ahash *tfm;
 
-	free_page((unsigned long)state->page);
-
 	tfm = crypto_ahash_reqtfm(req);
 	if (!ahash_is_async(tfm))
 		return;
@@ -680,9 +682,8 @@ int crypto_ahash_finup(struct ahash_request *req)
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_finup);
 
-static int ahash_def_digest_finish(struct ahash_save_req_state *state, int err)
+static int ahash_def_digest_finish(struct ahash_request *req, int err)
 {
-	struct ahash_request *req = state->req0;
 	struct crypto_ahash *tfm;
 
 	if (err)
@@ -696,8 +697,10 @@ static int ahash_def_digest_finish(struct ahash_save_req_state *state, int err)
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
+	return ahash_def_finup_finish1(req, err);
+
 out:
-	ahash_restore_req(state);
+	ahash_restore_req(req);
 	return err;
 }
 
@@ -714,7 +717,7 @@ static void ahash_def_digest_done(void *data, int err)
 
 	areq->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	err = ahash_def_digest_finish(state0, err);
+	err = ahash_def_digest_finish(areq, err);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return;
 
@@ -724,20 +727,17 @@ static void ahash_def_digest_done(void *data, int err)
 
 static int ahash_def_digest(struct ahash_request *req)
 {
-	struct ahash_save_req_state *state;
 	int err;
 
 	err = ahash_save_req(req, ahash_def_digest_done);
 	if (err)
 		return err;
 
-	state = req->base.data;
-
 	err = crypto_ahash_init(req);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
-	return ahash_def_digest_finish(state, err);
+	return ahash_def_digest_finish(req, err);
 }
 
 int crypto_ahash_digest(struct ahash_request *req)
@@ -779,13 +779,12 @@ static void ahash_def_finup_done2(void *data, int err)
 	if (err == -EINPROGRESS)
 		return;
 
-	ahash_restore_req(state);
+	ahash_restore_req(areq);
 	ahash_request_complete(areq, err);
 }
 
-static int ahash_def_finup_finish1(struct ahash_save_req_state *state, int err)
+static int ahash_def_finup_finish1(struct ahash_request *req, int err)
 {
-	struct ahash_request *req = state->req0;
 	struct crypto_ahash *tfm;
 
 	if (err)
@@ -800,7 +799,7 @@ static int ahash_def_finup_finish1(struct ahash_save_req_state *state, int err)
 		return err;
 
 out:
-	ahash_restore_req(state);
+	ahash_restore_req(req);
 	return err;
 }
 
@@ -817,7 +816,7 @@ static void ahash_def_finup_done1(void *data, int err)
 
 	areq->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	err = ahash_def_finup_finish1(state0, err);
+	err = ahash_def_finup_finish1(areq, err);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return;
 
@@ -827,20 +826,17 @@ static void ahash_def_finup_done1(void *data, int err)
 
 static int ahash_def_finup(struct ahash_request *req)
 {
-	struct ahash_save_req_state *state;
 	int err;
 
 	err = ahash_save_req(req, ahash_def_finup_done1);
 	if (err)
 		return err;
 
-	state = req->base.data;
-
 	err = crypto_ahash_update(req);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
-	return ahash_def_finup_finish1(state, err);
+	return ahash_def_finup_finish1(req, err);
 }
 
 int crypto_ahash_export(struct ahash_request *req, void *out)
-- 
2.39.5

