Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED9713AD26;
	Wed, 24 Sep 2025 10:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758709243; cv=none; b=ZQr7AVuKrgdornZ4eTj4y8IqxgypgSi0/DJQxBNR45GMvvr9tVegRr4XK/hXYWteZUybEjsJY3WWzZayl/RqkFBRc37N+X0NqmB1Hj8a6Q6hM09nIMgUIBs1d1v2QsKoMqfoNIDebP6tq6I93oaAH9zbMfqztcxcMXRgq7EcOY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758709243; c=relaxed/simple;
	bh=LVV2NvvF+vioWPmu1UXdWU3H6i1G1l4VoKlgHI0kGsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mn7hQuGqeMrhbkymltfYhjFyMgReeMY4c5Y84Ro+OZ7neIcVKXMQM5xnvF0slbmP7FZWHYR6kM5E+CbsqoRCO0GHkjeAwXA3/vX9RvkHI7WlTprA/gqH0/Md7zfbRaoR2xznu6aGjU0XqhXSFw5stfr8pXWBcsFnffGXz4ltmso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BJ4YYyQ/; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BJ4YYyQ/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=K+k6uJ+sNIukMY3StZvmVXWRfasU4I8UQNtgnzOy4tA=; b=BJ4YYyQ/d0ieKrD/TjqtfNyHa6
	Y/WmwX6Lt+k9XN4H3HA5vTp9BV/tqTlRqA25dIBL6XYzd4MXG9zayLRrOKH/nUoXjrcNZ31qXm84q
	FcQGZ5RjoDTy4oWjUnLIe1I0ZjkPGGTvVeLpiC7DK5HDxwffUyBclkx6a+A++FE5m94gIDl1+2DOQ
	OO8vZS3WiPNFXAZ1DEZUJK7LYqyoG5Wl0UCNwENFz69opfhODGqTkQIh+ENIjD9acnsRWSYe6sXNn
	98ZTLjAjgSQYgtxB07aXIhFLx7YlVaNvcq1CMTG6vLyu+BNrx5ZfS9pWU+GCJ1qXrKwF2rRTmRKEe
	oV7379rw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v1Mbh-007vGB-2H;
	Wed, 24 Sep 2025 18:20:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 24 Sep 2025 18:20:17 +0800
Date: Wed, 24 Sep 2025 18:20:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>, linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com,
	linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
	agk@redhat.com, snitzer@kernel.org,
	Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] crypto: authenc - Correctly pass EINPROGRESS back up to the
 caller
Message-ID: <aNPF4bjo6FbvujIx@gondor.apana.org.au>
References: <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com>
 <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com>
 <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
 <8cb59ed5-1c9a-49de-beee-01eda52ad618@linux.ibm.com>
 <1af710ec-0f23-2522-d715-e683b9e557d8@redhat.com>
 <f799d7ab97470f2529b8dcb5566fd673@linux.ibm.com>
 <e26aedc6-7132-46c3-78f3-a3582b1c4f9a@redhat.com>
 <aNIYTm6neC3lC6dP@gondor.apana.org.au>
 <194f9d1e-b6b0-54c7-6eb8-37ac0c0c1f9d@redhat.com>
 <aNK6IMzUgslPVi3x@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNK6IMzUgslPVi3x@gondor.apana.org.au>

When authenc is invoked with MAY_BACKLOG, it needs to pass EINPROGRESS
notifications back up to the caller when the underlying algorithm
returns EBUSY synchronously.

However, if the EBUSY comes from the second part of an authenc call,
i.e., it is asynchronous, both the EBUSY and the subsequent EINPROGRESS
notification must not be passed to the caller.

Implement this by passing a mask to the function that starts the
second half of authenc and using it to determine whether EBUSY
and EINPROGRESS should be passed to the caller.

This was a deficiency in the original implementation of authenc
because it was not expected to be used with MAY_BACKLOG.

Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 180ce7e81030 ("crypto: authenc - Add EINPROGRESS check")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/authenc.c b/crypto/authenc.c
index a723769c8777..ac679ce2cb95 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -37,7 +37,7 @@ struct authenc_request_ctx {
 
 static void authenc_request_complete(struct aead_request *req, int err)
 {
-	if (err != -EINPROGRESS)
+	if (err != -EINPROGRESS && err != -EBUSY)
 		aead_request_complete(req, err);
 }
 
@@ -107,27 +107,42 @@ static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	return err;
 }
 
-static void authenc_geniv_ahash_done(void *data, int err)
+static void authenc_geniv_ahash_finish(struct aead_request *req)
 {
-	struct aead_request *req = data;
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct aead_instance *inst = aead_alg_instance(authenc);
 	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
 
-	if (err)
-		goto out;
-
 	scatterwalk_map_and_copy(ahreq->result, req->dst,
 				 req->assoclen + req->cryptlen,
 				 crypto_aead_authsize(authenc), 1);
+}
 
-out:
+static void authenc_geniv_ahash_done(void *data, int err)
+{
+	struct aead_request *req = data;
+
+	if (!err)
+		authenc_geniv_ahash_finish(req);
 	aead_request_complete(req, err);
 }
 
-static int crypto_authenc_genicv(struct aead_request *req, unsigned int flags)
+/*
+ * Used when the ahash request was invoked in the async callback context
+ * of the previous skcipher request.  Eat any EINPROGRESS notifications.
+ */
+static void authenc_geniv_ahash_done2(void *data, int err)
+{
+	struct aead_request *req = data;
+
+	if (!err)
+		authenc_geniv_ahash_finish(req);
+	authenc_request_complete(req, err);
+}
+
+static int crypto_authenc_genicv(struct aead_request *req, unsigned int mask)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct aead_instance *inst = aead_alg_instance(authenc);
@@ -136,6 +151,7 @@ static int crypto_authenc_genicv(struct aead_request *req, unsigned int flags)
 	struct crypto_ahash *auth = ctx->auth;
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
+	unsigned int flags = aead_request_flags(req) & ~mask;
 	u8 *hash = areq_ctx->tail;
 	int err;
 
@@ -143,7 +159,8 @@ static int crypto_authenc_genicv(struct aead_request *req, unsigned int flags)
 	ahash_request_set_crypt(ahreq, req->dst, hash,
 				req->assoclen + req->cryptlen);
 	ahash_request_set_callback(ahreq, flags,
-				   authenc_geniv_ahash_done, req);
+				   mask ? authenc_geniv_ahash_done2 :
+					  authenc_geniv_ahash_done, req);
 
 	err = crypto_ahash_digest(ahreq);
 	if (err)
@@ -159,12 +176,11 @@ static void crypto_authenc_encrypt_done(void *data, int err)
 {
 	struct aead_request *areq = data;
 
-	if (err)
-		goto out;
-
-	err = crypto_authenc_genicv(areq, 0);
-
-out:
+	if (err) {
+		aead_request_complete(areq, err);
+		return;
+	}
+	err = crypto_authenc_genicv(areq, CRYPTO_TFM_REQ_MAY_SLEEP);
 	authenc_request_complete(areq, err);
 }
 
@@ -199,11 +215,18 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 	if (err)
 		return err;
 
-	return crypto_authenc_genicv(req, aead_request_flags(req));
+	return crypto_authenc_genicv(req, 0);
+}
+
+static void authenc_decrypt_tail_done(void *data, int err)
+{
+	struct aead_request *req = data;
+
+	authenc_request_complete(req, err);
 }
 
 static int crypto_authenc_decrypt_tail(struct aead_request *req,
-				       unsigned int flags)
+				       unsigned int mask)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct aead_instance *inst = aead_alg_instance(authenc);
@@ -214,6 +237,7 @@ static int crypto_authenc_decrypt_tail(struct aead_request *req,
 	struct skcipher_request *skreq = (void *)(areq_ctx->tail +
 						  ictx->reqoff);
 	unsigned int authsize = crypto_aead_authsize(authenc);
+	unsigned int flags = aead_request_flags(req) & ~mask;
 	u8 *ihash = ahreq->result + authsize;
 	struct scatterlist *src, *dst;
 
@@ -230,7 +254,9 @@ static int crypto_authenc_decrypt_tail(struct aead_request *req,
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
 	skcipher_request_set_callback(skreq, flags,
-				      req->base.complete, req->base.data);
+				      mask ? authenc_decrypt_tail_done :
+					     req->base.complete,
+				      mask ? req : req->base.data);
 	skcipher_request_set_crypt(skreq, src, dst,
 				   req->cryptlen - authsize, req->iv);
 
@@ -241,12 +267,11 @@ static void authenc_verify_ahash_done(void *data, int err)
 {
 	struct aead_request *req = data;
 
-	if (err)
-		goto out;
-
-	err = crypto_authenc_decrypt_tail(req, 0);
-
-out:
+	if (err) {
+		aead_request_complete(req, err);
+		return;
+	}
+	err = crypto_authenc_decrypt_tail(req, CRYPTO_TFM_REQ_MAY_SLEEP);
 	authenc_request_complete(req, err);
 }
 
@@ -273,7 +298,7 @@ static int crypto_authenc_decrypt(struct aead_request *req)
 	if (err)
 		return err;
 
-	return crypto_authenc_decrypt_tail(req, aead_request_flags(req));
+	return crypto_authenc_decrypt_tail(req, 0);
 }
 
 static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
