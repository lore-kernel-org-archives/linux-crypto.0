Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3313F6FC3
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 12:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746448366; cv=none; b=F/SDOXUJr1RgY4YsUbjFbHeaz5wAeqtlfu3hVtt5N0uJr2jfLtyW3msgBxVXveQDrGW+CpWfD721/VjACHWubYWfwuNjYSzJAH3RehNhZyPdNRqPYMz2yKLwkQFPHFOE1+J79/3mhjpy/Wd4sFPSdWA1nSjJlL8WekmHnm+c32g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746448366; c=relaxed/simple;
	bh=HNUFdAheGCAS5fh5V6LRxONnz1VzpzJy+sd/x/eWalo=;
	h=Date:Message-Id:From:Subject:To; b=Ka5S1XbnP0YFsZk3SGUr4NOC5wXH+U16eRamYNZh84G7teYfjFX1jnXwUadRMaHOeTKJHQ0RglEmi2bf7kBpQKM1ACXsl0lV6lm59o0lX1WCiwjUCdeRMuRNh3GNyhG3n8UMvJpxN/r9lpJK2/51vT64UJjLDnxzrZVRmdRHg7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NfC+FOPr; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NfC+FOPr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SYMgHCMmudGW2BcUDR/0zlfomZn+xuLsKwhbmNfikB8=; b=NfC+FOPryxx4QD7VJOez3Haxij
	HWG4sv2JUfxnt68oEbyw98L9MxIoextsYEpg1/NpeV9IxHNwdd+fNHpZ4bsa/wM5gJ+6ZpU+nB/1h
	RNr7u2FM0bBovq9LE79LEqXYGM6Fdrn/MhTIpB7Cbqf+dsJxOrd57fjnAG8kLhVVQt6MrACixowxZ
	JoLghCE2YjfvId9yOl2j6zBxHNA+4m/TJGr37urn0RNr5UB7mfbXdZB/ivcvm2l+qTviUvlXNcGoW
	8hggLIPfAzf9KML/LipI2odE5hZLuS8AsdAZAi02M9FzRd1OZ3vWl9bRRi9LLHURYMPrN1PnYahCD
	vT50e3Pg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBuzw-003YNO-0V;
	Mon, 05 May 2025 20:32:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 May 2025 20:32:40 +0800
Date: Mon, 05 May 2025 20:32:40 +0800
Message-Id: <1bdf0bc9343ad20885076a17c5c720acfd4a2547.1746448291.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/6] crypto: hash - Move core export and import into
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

