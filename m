Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A1C295531
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 05:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747288479; cv=none; b=Io9StVkxb+EEy3hpDR2x2d5Z5A6otxrOjkpGUZ/vvVTGQkDYlDocOGRY1uNV3500uGceEOF2jAAsisrX7FvZZyrq0U2u6IknZhwlVv/OXWXx8zbeg+l1OhBRcfiiCk4g1KsiLpYdXVaptm9zRgk32EvCnY1EUBqZVNc85jMxxnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747288479; c=relaxed/simple;
	bh=HNUFdAheGCAS5fh5V6LRxONnz1VzpzJy+sd/x/eWalo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=L2tGoBxMrM2eOy+nEIvqdaV6bX04dJzqKHea1JKN2Yj0Psa60fiCEZbbx1e/qmPv0m6IgLDYYLfhtejQ5BbTrgig4QH70CtDwL384OlSNH58ecCUMQmIVNVq/MTYEXUbeILWm55ZPDSBv5UEsr8ZnOoHabSskFZFIPHsUYO83Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Oowx13I/; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Oowx13I/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SYMgHCMmudGW2BcUDR/0zlfomZn+xuLsKwhbmNfikB8=; b=Oowx13I/QNikawHwIqj6P8U9Sl
	JWtxoKW7adkTNHB9JkD84+kJJUBAuKadaY1kU5K85ZBwo/QJqufr/uzHKI6UkUIbH3oIx17o5C7xk
	Ni1yObmPPrcHfCVETZSHv8iixz1iqBc7AyNxQe3GfRogmHgNblWtWRdn0NvYL3WuhlD5Eml3ON5na
	sBWtiA0Ke0Rs3CZVY57M3nXNXB58CnwYrr90+m+1gD3AjKudqaUv5t/llHJzL/ZNOIsT8hP/Ddui9
	fj98tWpHCFAKVn4oE0hJsz6FxRkgZpFT9dYXYHMgAPjj/ezlHlBYRh3DWawkTKa6eqLXu7UOURmwD
	lN4rUPTQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFRY9-006EbF-0R;
	Thu, 15 May 2025 13:54:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 13:54:33 +0800
Date: Thu, 15 May 2025 13:54:33 +0800
Message-Id: <e0da718aa34f3e0df4401d5fa79c906506b741c2.1747288315.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747288315.git.herbert@gondor.apana.org.au>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 01/11] crypto: hash - Move core export and import into
 internel/hash.h
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The core export and import functions are targeted at implementors
so move them into internal/hash.h.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/hash.h          | 48 ----------------------------------
 include/crypto/internal/hash.h | 48 ++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 1760662ad70a..9fc9daaaaab4 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -506,18 +506,6 @@ int crypto_ahash_digest(struct ahash_request *req);
  */
 int crypto_ahash_export(struct ahash_request *req, void *out);
 
-/**
- * crypto_ahash_export_core() - extract core state for message digest
- * @req: reference to the ahash_request handle whose state is exported
- * @out: output buffer of sufficient size that can hold the hash state
- *
- * Export the hash state without the partial block buffer.
- *
- * Context: Softirq or process context.
- * Return: 0 if the export creation was successful; < 0 if an error occurred
- */
-int crypto_ahash_export_core(struct ahash_request *req, void *out);
-
 /**
  * crypto_ahash_import() - import message digest state
  * @req: reference to ahash_request handle the state is imported into
@@ -531,18 +519,6 @@ int crypto_ahash_export_core(struct ahash_request *req, void *out);
  */
 int crypto_ahash_import(struct ahash_request *req, const void *in);
 
-/**
- * crypto_ahash_import_core() - import core state
- * @req: reference to ahash_request handle the state is imported into
- * @in: buffer holding the state
- *
- * Import the hash state without the partial block buffer.
- *
- * Context: Softirq or process context.
- * Return: 0 if the import was successful; < 0 if an error occurred
- */
-int crypto_ahash_import_core(struct ahash_request *req, const void *in);
-
 /**
  * crypto_ahash_init() - (re)initialize message digest handle
  * @req: ahash_request handle that already is initialized with all necessary
@@ -933,18 +909,6 @@ int crypto_hash_digest(struct crypto_ahash *tfm, const u8 *data,
  */
 int crypto_shash_export(struct shash_desc *desc, void *out);
 
-/**
- * crypto_shash_export_core() - extract core state for message digest
- * @desc: reference to the operational state handle whose state is exported
- * @out: output buffer of sufficient size that can hold the hash state
- *
- * Export the hash state without the partial block buffer.
- *
- * Context: Softirq or process context.
- * Return: 0 if the export creation was successful; < 0 if an error occurred
- */
-int crypto_shash_export_core(struct shash_desc *desc, void *out);
-
 /**
  * crypto_shash_import() - import operational state
  * @desc: reference to the operational state handle the state imported into
@@ -959,18 +923,6 @@ int crypto_shash_export_core(struct shash_desc *desc, void *out);
  */
 int crypto_shash_import(struct shash_desc *desc, const void *in);
 
-/**
- * crypto_shash_import_core() - import core state
- * @desc: reference to the operational state handle the state imported into
- * @in: buffer holding the state
- *
- * Import the hash state without the partial block buffer.
- *
- * Context: Softirq or process context.
- * Return: 0 if the import was successful; < 0 if an error occurred
- */
-int crypto_shash_import_core(struct shash_desc *desc, const void *in);
-
 /**
  * crypto_shash_init() - (re)initialize message digest
  * @desc: operational state handle that is already filled
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index f2bbdb74e11a..ef5ea75ac5c8 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -305,5 +305,53 @@ static inline unsigned int crypto_shash_coresize(struct crypto_shash *tfm)
 #define HASH_REQUEST_ZERO(name) \
 	memzero_explicit(__##name##_req, sizeof(__##name##_req))
 
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
+/**
+ * crypto_shash_export_core() - extract core state for message digest
+ * @desc: reference to the operational state handle whose state is exported
+ * @out: output buffer of sufficient size that can hold the hash state
+ *
+ * Export the hash state without the partial block buffer.
+ *
+ * Context: Softirq or process context.
+ * Return: 0 if the export creation was successful; < 0 if an error occurred
+ */
+int crypto_shash_export_core(struct shash_desc *desc, void *out);
+
+/**
+ * crypto_shash_import_core() - import core state
+ * @desc: reference to the operational state handle the state imported into
+ * @in: buffer holding the state
+ *
+ * Import the hash state without the partial block buffer.
+ *
+ * Context: Softirq or process context.
+ * Return: 0 if the import was successful; < 0 if an error occurred
+ */
+int crypto_shash_import_core(struct shash_desc *desc, const void *in);
+
 #endif	/* _CRYPTO_INTERNAL_HASH_H */
 
-- 
2.39.5

