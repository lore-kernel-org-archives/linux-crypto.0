Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520E55258
	for <linux-crypto@vger.kernel.org>; Sun,  4 May 2025 13:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746365607; cv=none; b=oskc+M9nPsnmGQlzaMRRffhRPieUDgbRaD6IF8JW6kOhoKJZy2cmcKbiVH9fW4kqZPyuiaxNtYcOaVxYGyVTkJH2ZgSpKTFWtzOWGNuJsvb6zKLFejSACw+JYC5yV8YRbuFSWNnWyDDiS0LTKdPSUtAxIgdytMVOC/AUz0krjbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746365607; c=relaxed/simple;
	bh=ccv+1Yj7LTXxMDcM6ByxvODFThdCAta09oLeroNhiA8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=ub7aNe0Lrs/Zru4dYtEWXhbEJITZt+5c0A5V7rWq0bqnuCTBRsJ4ixd93EIUa34R/mguhuH2vdtIAm7A83MyARfTNuy9D6qCefM9PR3hq9Y8dR/5J+aYztY1uhzZGskQDUd2QkIUm4AEsxzJVrmrbiOAK929IfCuTnvaeMsCqF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BwJ1/nKg; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BwJ1/nKg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/3Tdo+OP2bu6FX/XrxAdXJ2+uIE3pk9zDESJ5TT3Ot8=; b=BwJ1/nKgv01WtVUGAI6r5uTGiw
	iilWdVHqo8uX5cnRJLThF3Cg9eeLshv3zoYH1OcZaoFC+uufAsCgNerVnXtIWKxH1LZUi06wF63gR
	BPfS+73LdG+9hVjU4/pM+GOfaAh5f8BqERZAirgIRcPMlCBhyVWlCWMhpHcAqNkx6r4wHdi5kKS4g
	bR2YEd+aLue5CT0PPD/ene5esw5OdRmT+kqDI1EnESwstN+2HONa8bZ1T3BkhUHlBQ2j7BNMrgGii
	PyVgmfOdYHCktdODbF7K08deTXVTlyfrt+HH+br8bI2jt8Mm+bjyBx94PGdQZgvcbA7NEmstaMWzJ
	xBK67GBA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBZT7-003Evh-0M;
	Sun, 04 May 2025 21:33:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 04 May 2025 21:33:21 +0800
Date: Sun, 04 May 2025 21:33:21 +0800
Message-Id: <d3eab0167af08451240923c21fa324c787917b7d.1746365585.git.herbert@gondor.apana.org.au>
In-Reply-To: <40527d5a34051a880c06fdcead0f566cc0e5a0ce.1746365585.git.herbert@gondor.apana.org.au>
References: <40527d5a34051a880c06fdcead0f566cc0e5a0ce.1746365585.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 4/6] crypto: ahash - Add core export and import
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add crypto_ahash_export_core and crypto_ahash_import_core.  For
now they only differ from the normal export/import functions when
going through shash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c        | 25 ++++++++++++++++++++++++-
 include/crypto/hash.h | 24 ++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 736e9fb5d0a4..344bf1b43e71 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -698,6 +698,16 @@ static int ahash_def_finup(struct ahash_request *req)
 	return ahash_def_finup_finish1(req, err);
 }
 
+int crypto_ahash_export_core(struct ahash_request *req, void *out)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	if (likely(tfm->using_shash))
+		return crypto_shash_export_core(ahash_request_ctx(req), out);
+	return crypto_ahash_alg(tfm)->export(req, out);
+}
+EXPORT_SYMBOL_GPL(crypto_ahash_export_core);
+
 int crypto_ahash_export(struct ahash_request *req, void *out)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -708,6 +718,19 @@ int crypto_ahash_export(struct ahash_request *req, void *out)
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_export);
 
+int crypto_ahash_import_core(struct ahash_request *req, const void *in)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	if (likely(tfm->using_shash))
+		return crypto_shash_import_core(prepare_shash_desc(req, tfm),
+						in);
+	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+	return crypto_ahash_alg(tfm)->import(req, in);
+}
+EXPORT_SYMBOL_GPL(crypto_ahash_import_core);
+
 int crypto_ahash_import(struct ahash_request *req, const void *in)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -716,7 +739,7 @@ int crypto_ahash_import(struct ahash_request *req, const void *in)
 		return crypto_shash_import(prepare_shash_desc(req, tfm), in);
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
-	return crypto_ahash_alg(tfm)->import(req, in);
+	return crypto_ahash_import_core(req, in);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_import);
 
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index e0321b5ec363..1760662ad70a 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -506,6 +506,18 @@ int crypto_ahash_digest(struct ahash_request *req);
  */
 int crypto_ahash_export(struct ahash_request *req, void *out);
 
+/**
+ * crypto_ahash_export_core() - extract core state for message digest
+ * @req: reference to the ahash_request handle whose state is exported
+ * @out: output buffer of sufficient size that can hold the hash state
+ *
+ * Export the hash state without the partial block buffer.
+ *
+ * Context: Softirq or process context.
+ * Return: 0 if the export creation was successful; < 0 if an error occurred
+ */
+int crypto_ahash_export_core(struct ahash_request *req, void *out);
+
 /**
  * crypto_ahash_import() - import message digest state
  * @req: reference to ahash_request handle the state is imported into
@@ -519,6 +531,18 @@ int crypto_ahash_export(struct ahash_request *req, void *out);
  */
 int crypto_ahash_import(struct ahash_request *req, const void *in);
 
+/**
+ * crypto_ahash_import_core() - import core state
+ * @req: reference to ahash_request handle the state is imported into
+ * @in: buffer holding the state
+ *
+ * Import the hash state without the partial block buffer.
+ *
+ * Context: Softirq or process context.
+ * Return: 0 if the import was successful; < 0 if an error occurred
+ */
+int crypto_ahash_import_core(struct ahash_request *req, const void *in);
+
 /**
  * crypto_ahash_init() - (re)initialize message digest handle
  * @req: ahash_request handle that already is initialized with all necessary
-- 
2.39.5

