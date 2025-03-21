Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8451EE7DC
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 08:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742546619; cv=none; b=J0wcM59BGHA28CKjOtWqmSPLeEnsU8KvMryFu0zKMmHYnxaYbX1aXNaAebq696E06C6bncy/v1o7aqZ88yZri88xQEr4Zy3Nu/izWraPHvqi5ENqLJADkEkDxTOl0l8IY1dQS6D/3u1BNjUVTxSkceHIVO3V1RMwwlYEi2MMDJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742546619; c=relaxed/simple;
	bh=Gw89vhxpe1AShIrHzziBFYRL9dnep/XQVhvfaJeHm9k=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=bbpsPrGdwDSnXk5qWDCxi6G1Pdb3nEQ7+IkP88c2dHJ8JC5Qkzb5SlcHoveqa3gN2hvLt2pb1pNHgL0yCaUgFeJ4Ry0BKIv4T/WeNMzvSeQlnkcEd5cQRHOC99URgapsfw2mju9LwYkh3rOHY+wu7t3KgMoqszeA3eq9yN7XNas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=WmjvMr3e; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="WmjvMr3e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=7+XykjnEjbD0w6sUxhynHJKbZQk10C/HYG0LZBctW8w=; b=WmjvMr3e/OJnx1AhLdk6M16Hfn
	mgLkf+pPpLyA0fs2+T5dG1miiGFrSJdd/oLd6Vw2/ZoDkgc2L7l48wPyvu0v1KcLe0gwMcjkXEiwG
	SJzMD7RH0mDnSToSxdnD0pMi+sx61n1ycbQgDtGL4+sXWVKT6sknGrLr28buPVknSgKr5ue5PEZLY
	XAn7NTx/rYfQxgWLQ3KY3U0pfyYSp8Y9pUMzO+iwNVBUa80xvrypj8uDqkbSWSFTweyCIusB8iJPF
	O+KT5pBcEHzU5u/3i5KAgWzIuEdUrTsTDyGhXVqmrFeHRruPKQ/f2vs6ReOhuWe6v75WifUM13S4e
	RbCDmACA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvXyW-008xvv-2w;
	Fri, 21 Mar 2025 16:43:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 16:43:32 +0800
Date: Fri, 21 Mar 2025 16:43:32 +0800
Message-Id: <3ff519208820bb2068b9a02b42dddf607b7d4cfa.1742546178.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742546178.git.herbert@gondor.apana.org.au>
References: <cover.1742546178.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/4] crypto: acomp - Fix synchronous acomp chaining fallback
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The synchronous acomp fallback code path is broken because the
completion code path assumes that the state object is always set
but this is only done for asynchronous algorithms.

First of all remove the assumption on the completion code path
by passing in req0 instead of the state.  However, also remove
the conditional setting of the state since it's always in the
request object anyway.

Fixes: b67a02600372 ("crypto: acomp - Add request chaining and virtual addresses")
Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 45444e99a9db..beeae34990d3 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -141,12 +141,8 @@ static bool acomp_request_has_nondma(struct acomp_req *req)
 
 static void acomp_save_req(struct acomp_req *req, crypto_completion_t cplt)
 {
-	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 	struct acomp_req_chain *state = &req->chain;
 
-	if (!acomp_is_async(tfm))
-		return;
-
 	state->compl = req->base.complete;
 	state->data = req->base.data;
 	req->base.complete = cplt;
@@ -154,14 +150,9 @@ static void acomp_save_req(struct acomp_req *req, crypto_completion_t cplt)
 	state->req0 = req;
 }
 
-static void acomp_restore_req(struct acomp_req_chain *state)
+static void acomp_restore_req(struct acomp_req *req)
 {
-	struct acomp_req *req = state->req0;
-	struct crypto_acomp *tfm;
-
-	tfm = crypto_acomp_reqtfm(req);
-	if (!acomp_is_async(tfm))
-		return;
+	struct acomp_req_chain *state = req->base.data;
 
 	req->base.complete = state->compl;
 	req->base.data = state->data;
@@ -207,10 +198,9 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 	}
 }
 
-static int acomp_reqchain_finish(struct acomp_req_chain *state,
-				 int err, u32 mask)
+static int acomp_reqchain_finish(struct acomp_req *req0, int err, u32 mask)
 {
-	struct acomp_req *req0 = state->req0;
+	struct acomp_req_chain *state = req0->base.data;
 	struct acomp_req *req = state->cur;
 	struct acomp_req *n;
 
@@ -243,7 +233,7 @@ static int acomp_reqchain_finish(struct acomp_req_chain *state,
 		list_add_tail(&req->base.list, &req0->base.list);
 	}
 
-	acomp_restore_req(state);
+	acomp_restore_req(req0);
 
 out:
 	return err;
@@ -262,7 +252,8 @@ static void acomp_reqchain_done(void *data, int err)
 		goto notify;
 	}
 
-	err = acomp_reqchain_finish(state, err, CRYPTO_TFM_REQ_MAY_BACKLOG);
+	err = acomp_reqchain_finish(state->req0, err,
+				    CRYPTO_TFM_REQ_MAY_BACKLOG);
 	if (err == -EBUSY)
 		return;
 
@@ -274,7 +265,7 @@ static int acomp_do_req_chain(struct acomp_req *req,
 			      int (*op)(struct acomp_req *req))
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-	struct acomp_req_chain *state = &req->chain;
+	struct acomp_req_chain *state;
 	int err;
 
 	if (crypto_acomp_req_chain(tfm) ||
@@ -289,10 +280,8 @@ static int acomp_do_req_chain(struct acomp_req *req,
 	if (acomp_request_has_nondma(req))
 		return -EINVAL;
 
-	if (acomp_is_async(tfm)) {
-		acomp_save_req(req, acomp_reqchain_done);
-		state = req->base.data;
-	}
+	acomp_save_req(req, acomp_reqchain_done);
+	state = req->base.data;
 
 	state->op = op;
 	state->cur = req;
@@ -305,7 +294,7 @@ static int acomp_do_req_chain(struct acomp_req *req,
 	if (err == -EBUSY || err == -EINPROGRESS)
 		return -EBUSY;
 
-	return acomp_reqchain_finish(state, err, ~0);
+	return acomp_reqchain_finish(req, err, ~0);
 }
 
 int crypto_acomp_compress(struct acomp_req *req)
-- 
2.39.5

