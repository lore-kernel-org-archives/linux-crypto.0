Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99CD481A3
	for <linux-crypto@vger.kernel.org>; Sun, 23 Feb 2025 06:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740292079; cv=none; b=ke442bfdwnFr6pzhK9l8oUKoAVYmPoJBRXJx+Z1uT1a8eLe+nDKI71IlVG5vLMtN5TYBaIBMb3yyOtp2+vjMIRl2dGnyqvSMKl4YNoN1ZGzT9GPEte4rg7E/Kjg+9aImXHSgVIDT1uqeof6hBYKA50Y8L4k6zyds5Rld2iy0FwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740292079; c=relaxed/simple;
	bh=uXwwjfJXJPCbq4C1qAvm5abmpxwbDT/Nyl+d6gJRV0A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tVCOrcU4Hg5+SEk+7EJpT42EcAf4hAV77lF35XGxCtpA5k1BJAaEQ+4rcq6mXVAxxaJuGv80wyRPQkGzPHOFsnNQ85kpZCe97GuhT1hlXJIixAGob48APxVJQxbwmTta+e2/2OF5JAQ9BPpTwZO3tmB4of5H4aNVGhGTzxymoJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=N8lMbAOW; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="N8lMbAOW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nQQFgupXH7+Yevuq9lqCXlAaJVpJHmevAGJbPMftsgc=; b=N8lMbAOWdO0JYBddL58K1Gpw87
	s40ps4ccVaQnXSwTHfJPzZG0JxYplg03wds9IZRZW86doasCastJeHn18t+xGUVhJW0daOGREeZqr
	s8hdU9eVUOIihl2y2YKnjBqw6CnpACsjMg1KW1Nayc+SF+GmrUHtjDBqwCHFBKDo4ida8C598sU3B
	uQY58i60JWy+TyrORLhqE8HhYxY3U/bBANOzBVd7+Rc8ahyIhiABXyq/o8Z3NZpFQ90VgXu/kxa3H
	cpT3HibZGt/WkjHszoHWaXm04slUu3xfSK3BJ8oREJty3Rxbnzc0U7c/jU33RnvEZ/4jl9NNdljU7
	kW6z/0jw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tm5Sx-000yRU-27;
	Sun, 23 Feb 2025 14:27:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 23 Feb 2025 14:27:51 +0800
Date: Sun, 23 Feb 2025 14:27:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: skcipher - Use restrict rather than hand-rolling
 accesses
Message-ID: <Z7q_5wYdx6fOvsDK@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Rather than accessing 'alg' directly to avoid the aliasing issue
which leads to unnecessary reloads, use the __restrict keyword
to explicitly tell the compiler that there is no aliasing.

This generates equivalent if not superior code on x86 with gcc 12.

Note that in skcipher_walk_virt the alg assignment is moved after
might_sleep_if because that function is a compiler barrier and
forces a reload.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index cdf0f11c7eaa..561aa5cc4ffa 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -306,14 +306,16 @@ static int skcipher_walk_first(struct skcipher_walk *walk)
 	return skcipher_walk_next(walk);
 }
 
-int skcipher_walk_virt(struct skcipher_walk *walk,
-		       struct skcipher_request *req, bool atomic)
+int skcipher_walk_virt(struct skcipher_walk *__restrict walk,
+		       struct skcipher_request *__restrict req, bool atomic)
 {
-	const struct skcipher_alg *alg =
-		crypto_skcipher_alg(crypto_skcipher_reqtfm(req));
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct skcipher_alg *alg;
 
 	might_sleep_if(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 
+	alg = crypto_skcipher_alg(tfm);
+
 	walk->total = req->cryptlen;
 	walk->nbytes = 0;
 	walk->iv = req->iv;
@@ -329,14 +331,9 @@ int skcipher_walk_virt(struct skcipher_walk *walk,
 	scatterwalk_start(&walk->in, req->src);
 	scatterwalk_start(&walk->out, req->dst);
 
-	/*
-	 * Accessing 'alg' directly generates better code than using the
-	 * crypto_skcipher_blocksize() and similar helper functions here, as it
-	 * prevents the algorithm pointer from being repeatedly reloaded.
-	 */
-	walk->blocksize = alg->base.cra_blocksize;
-	walk->ivsize = alg->co.ivsize;
-	walk->alignmask = alg->base.cra_alignmask;
+	walk->blocksize = crypto_skcipher_blocksize(tfm);
+	walk->ivsize = crypto_skcipher_ivsize(tfm);
+	walk->alignmask = crypto_skcipher_alignmask(tfm);
 
 	if (alg->co.base.cra_type != &crypto_skcipher_type)
 		walk->stride = alg->co.chunksize;
@@ -347,10 +344,11 @@ int skcipher_walk_virt(struct skcipher_walk *walk,
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_virt);
 
-static int skcipher_walk_aead_common(struct skcipher_walk *walk,
-				     struct aead_request *req, bool atomic)
+static int skcipher_walk_aead_common(struct skcipher_walk *__restrict walk,
+				     struct aead_request *__restrict req,
+				     bool atomic)
 {
-	const struct aead_alg *alg = crypto_aead_alg(crypto_aead_reqtfm(req));
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 
 	walk->nbytes = 0;
 	walk->iv = req->iv;
@@ -372,21 +370,17 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 	scatterwalk_done(&walk->in, 0, walk->total);
 	scatterwalk_done(&walk->out, 0, walk->total);
 
-	/*
-	 * Accessing 'alg' directly generates better code than using the
-	 * crypto_aead_blocksize() and similar helper functions here, as it
-	 * prevents the algorithm pointer from being repeatedly reloaded.
-	 */
-	walk->blocksize = alg->base.cra_blocksize;
-	walk->stride = alg->chunksize;
-	walk->ivsize = alg->ivsize;
-	walk->alignmask = alg->base.cra_alignmask;
+	walk->blocksize = crypto_aead_blocksize(tfm);
+	walk->stride = crypto_aead_chunksize(tfm);
+	walk->ivsize = crypto_aead_ivsize(tfm);
+	walk->alignmask = crypto_aead_alignmask(tfm);
 
 	return skcipher_walk_first(walk);
 }
 
-int skcipher_walk_aead_encrypt(struct skcipher_walk *walk,
-			       struct aead_request *req, bool atomic)
+int skcipher_walk_aead_encrypt(struct skcipher_walk *__restrict walk,
+			       struct aead_request *__restrict req,
+			       bool atomic)
 {
 	walk->total = req->cryptlen;
 
@@ -394,8 +388,9 @@ int skcipher_walk_aead_encrypt(struct skcipher_walk *walk,
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_aead_encrypt);
 
-int skcipher_walk_aead_decrypt(struct skcipher_walk *walk,
-			       struct aead_request *req, bool atomic)
+int skcipher_walk_aead_decrypt(struct skcipher_walk *__restrict walk,
+			       struct aead_request *__restrict req,
+			       bool atomic)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 4f49621d3eb6..d6ae7a86fed2 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -197,13 +197,15 @@ int lskcipher_register_instance(struct crypto_template *tmpl,
 				struct lskcipher_instance *inst);
 
 int skcipher_walk_done(struct skcipher_walk *walk, int res);
-int skcipher_walk_virt(struct skcipher_walk *walk,
-		       struct skcipher_request *req,
+int skcipher_walk_virt(struct skcipher_walk *__restrict walk,
+		       struct skcipher_request *__restrict req,
 		       bool atomic);
-int skcipher_walk_aead_encrypt(struct skcipher_walk *walk,
-			       struct aead_request *req, bool atomic);
-int skcipher_walk_aead_decrypt(struct skcipher_walk *walk,
-			       struct aead_request *req, bool atomic);
+int skcipher_walk_aead_encrypt(struct skcipher_walk *__restrict walk,
+			       struct aead_request *__restrict req,
+			       bool atomic);
+int skcipher_walk_aead_decrypt(struct skcipher_walk *__restrict walk,
+			       struct aead_request *__restrict req,
+			       bool atomic);
 
 static inline void skcipher_walk_abort(struct skcipher_walk *walk)
 {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
