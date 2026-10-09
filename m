Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EA24E3231
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 11:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791546747; cv=none; b=Qz7pJzGeJh3MNqNetfJ7dcmS1UWj3jKbWq/J0YnROvCEs9uS1q4ZOhFBvkkQadJabg86TDKxPjDqYlx+kDoUyVmJNe6+ibEtrdlvn63d+t0feRnNxCKntIPHl3dGu+O7JHES9wR60q91ISIMDelFdlngeHm0rLvRVpV9iQ4ruus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791546747; c=relaxed/simple;
	bh=pwMFnc2rPtSFC29Bitewbej3vYZc9k4yEXAZScfORVI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bk+wAavYROOTGd8JX3z6SzY5oZhbEAp7BdUQAKvDKNtGKO9yL2TFqDqCsaG4k3UU4q3vx+AYh4F5it0uwt4ADA1vvLsqihbQyndB3R+0LNUWVGG27Oktebk0VDtemOLLcPIh4eS452mTd8Si44QaOh1cBfc9ax0IMBLyM+UZvHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=WtRzmqGo; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="WtRzmqGo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=2xF+AMG5R4TEYJNdXoc5o970pr2NMWNcgO+q6pcTccs=; b=WtRzm
	qGoetnR06kQC/R77XalTyZ8zdFyNj31+NL6gAUC+HNhl/5tWf6eKQZaTLyjwfAYIZKQpt10bVgNMu
	Q3bq6icVGlYxEebqosiYjrIWWamr8nWV8a6EMcTXKROA8I0UBp7xgbL8io7bESyFcUi2OWtqaMXLk
	R7oKmTnYxo7T4jB9DK2Rt8/hWBC7OuSyz15axH+Bz1UHbbioH2pIkErsx93yUB6+CqOMxXRonKiSf
	ZMMbJEppCXIUncdfVM4jjSYDJFe4KrohnzLm5iUENUuh5Vw5cyy8tqus6Xlew8UQjGwBdaj7zn57b
	4PjMWyNe7Vlm4tGZNnuX6ZbWWj4pQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xF98z-00000002CpB-0E7D;
	Fri, 09 Oct 2026 19:52:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Oct 2026 22:52:09 +1100
Date: Fri, 9 Oct 2026 22:52:09 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: hash - Preserve withheld block in export_core
Message-ID: <asjVaVGfI3JhoQja@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Some algorithms (cmac and xcbc) withhold one block for finalisation.
This breaks crypto_ahash_export_core (only called when there is no
partial block data) because the exported hash state is missing the
withheld block.

Fix this by performing a hash update of the partial block if it is
present before doing the export.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index d86c78f8d550..706440ebe4eb 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -634,6 +634,43 @@ int crypto_ahash_export_core(struct ahash_request *req, void *out)
 
 	if (likely(tfm->using_shash))
 		return crypto_shash_export_core(ahash_request_ctx(req), out);
+
+	if (crypto_ahash_block_only(tfm)) {
+		unsigned int reqsize = crypto_ahash_reqsize(tfm);
+		unsigned int bs = crypto_ahash_blocksize(tfm);
+		u8 *buf = ahash_request_ctx(req);
+		unsigned int partial;
+		int err;
+
+		buf += reqsize - 1;
+		partial = *buf;
+		*buf = 0;
+
+		if (!partial)
+			;
+		else if (partial != bs)
+			return -EINVAL;
+		else {
+			struct crypto_ahash *fb = crypto_ahash_fb(tfm);
+			u8 state[HASH_MAX_STATESIZE];
+
+			err = crypto_ahash_export(req, state);
+
+			ahash_request_set_tfm(req, fb);
+			err = err ?: crypto_ahash_import(req, state);
+
+			sg_init_one(req->sg_head, buf - bs, bs);
+			req->src = req->sg_head;
+			req->nbytes = bs;
+
+			err = err ?: crypto_ahash_update(req) ?:
+			      crypto_ahash_export_core(req, out);
+
+			ahash_request_set_tfm(req, tfm);
+			return err ?: crypto_ahash_import(req, state);
+		}
+	}
+
 	return crypto_ahash_alg(tfm)->export_core(req, out);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_export_core);
diff --git a/crypto/shash.c b/crypto/shash.c
index d4a6c3b6fa37..d9e9377cbd6a 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -225,6 +225,31 @@ static int __crypto_shash_export(struct shash_desc *desc, void *out,
 
 int crypto_shash_export_core(struct shash_desc *desc, void *out)
 {
+	struct crypto_shash *tfm = desc->tfm;
+
+	if (crypto_shash_block_only(tfm)) {
+		unsigned int descsize = crypto_shash_descsize(tfm);
+		unsigned int bs = crypto_shash_blocksize(tfm);
+		u8 *buf = shash_desc_ctx(desc);
+		unsigned int partial;
+		int err;
+
+		partial = buf[descsize - 1];
+		buf[descsize - 1] = 0;
+
+		if (!partial)
+			;
+		else if (partial != bs)
+			return -EINVAL;
+		else {
+			err = crypto_shash_alg(tfm)->update(
+				desc, buf + descsize - bs - 1, bs);
+
+			if (err)
+				return err;
+		}
+	}
+
 	return __crypto_shash_export(desc, out,
 				     crypto_shash_alg(desc->tfm)->export_core);
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
