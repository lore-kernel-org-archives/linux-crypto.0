Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6907482
	for <linux-crypto@vger.kernel.org>; Sun,  9 Mar 2025 02:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741488200; cv=none; b=Unz2Qzqb2OJy8XBgMrOHOTNDlw6IVgz5o+B8NN05u1Df/DK7rDvttqz4FNJ6V90+NKZJrPPTevy+EmS2qar/eqRUxh9f/MiS5JDZLEPemu014zcrdGg5lXgrbn5DCuovf+7fmAfKvaECfHYfAVYP4X/YG4WpyfFF1+jK7hkPSUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741488200; c=relaxed/simple;
	bh=JqT3luKWkHDtKFuAPg5vbVht2HgXC3ny+6tJyRfcRjw=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=I3JFjT+RLa4GdXaMtnHG6na+P6ifcAsFsDKNIjlxPDhOWeYAYa6GKdlqn9JOqsKDaQLAHqkNHoPcNR+waoFBGxsVf/PW5oSycutXrNW6TpDfPEpYrCFuVDolYbtGhcTH2RRcA5HMa9Yv+G7449IVRLCoGztm9+8NGRAWcjxS0YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DQ7P9bVW; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DQ7P9bVW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1jO9xadjqBiVEi8B/sfCDao+tK2caka5a7BaYtwhA+w=; b=DQ7P9bVWQL/3PMFd6enfEstzu+
	hpu3I5O/vNp64BAoDCvSZgjbVoADsY57LVOyUJ1XoNwreSDt6OpqtXfSaD6kRPd+7ZcBabQtPEQ2O
	Na0oxDoEn47BeaOa/zvR+UpE9LUXK8V4IdwEOpaB8moMfHnbbpsEid2AlH+NSXEYCADiVVWNBw8EB
	qgyC25CVvsKqmmDq/omrTua+aETMWuy0+QWmsBogGDYFD9ZKsKiR9ytKogoywUwUe5oC/UEPYzlgs
	/rKpL5gSglT+nonluOZtYg85SGGp8z7VVX5cpf9Tzsz3dK6TkIgyXSU1vjcSddOXCEf4fkjShclXq
	Xw22YJkw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tr6dE-004zHK-1L;
	Sun, 09 Mar 2025 10:43:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Mar 2025 10:43:12 +0800
Date: Sun, 09 Mar 2025 10:43:12 +0800
Message-Id: <e9541bcd5960c6113ca60bfc9d6bbe9413e89eb3.1741488107.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741488107.git.herbert@gondor.apana.org.au>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 1/8] crypto: api - Add cra_type->destroy hook
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, Sergey Senozhatsky <senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add a cra_type->destroy hook so that resources can be freed after
the last user of a registered algorithm is gone.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/api.c      | 10 ++++++++++
 crypto/internal.h |  6 ++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index c2c4eb14ef95..91957bb52f3f 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -707,5 +707,15 @@ void crypto_req_done(void *data, int err)
 }
 EXPORT_SYMBOL_GPL(crypto_req_done);
 
+void crypto_destroy_alg(struct crypto_alg *alg)
+{
+	if (alg->cra_type && alg->cra_type->destroy)
+		alg->cra_type->destroy(alg);
+
+	if (alg->cra_destroy)
+		alg->cra_destroy(alg);
+}
+EXPORT_SYMBOL_GPL(crypto_destroy_alg);
+
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
diff --git a/crypto/internal.h b/crypto/internal.h
index 08d43b40e7db..11567ea24fc3 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -40,6 +40,7 @@ struct crypto_type {
 	void (*show)(struct seq_file *m, struct crypto_alg *alg);
 	int (*report)(struct sk_buff *skb, struct crypto_alg *alg);
 	void (*free)(struct crypto_instance *inst);
+	void (*destroy)(struct crypto_alg *alg);
 
 	unsigned int type;
 	unsigned int maskclear;
@@ -127,6 +128,7 @@ void *crypto_create_tfm_node(struct crypto_alg *alg,
 			const struct crypto_type *frontend, int node);
 void *crypto_clone_tfm(const struct crypto_type *frontend,
 		       struct crypto_tfm *otfm);
+void crypto_destroy_alg(struct crypto_alg *alg);
 
 static inline void *crypto_create_tfm(struct crypto_alg *alg,
 			const struct crypto_type *frontend)
@@ -163,8 +165,8 @@ static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
 
 static inline void crypto_alg_put(struct crypto_alg *alg)
 {
-	if (refcount_dec_and_test(&alg->cra_refcnt) && alg->cra_destroy)
-		alg->cra_destroy(alg);
+	if (refcount_dec_and_test(&alg->cra_refcnt))
+		crypto_destroy_alg(alg);
 }
 
 static inline int crypto_tmpl_get(struct crypto_template *tmpl)
-- 
2.39.5

