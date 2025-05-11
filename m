Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4582F2E
	for <linux-crypto@vger.kernel.org>; Sun, 11 May 2025 09:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746954579; cv=none; b=TVZ7nbLqsAnQDPzIDaip5vqKUyZdqEo8g+MiAWC5I84U5B3CPSAWi79B4LwpPDgf+PIa/MvTRuM3DlhtbVxeWqmWY3GsUZhEiJ2bP517hd5f9gqocyIuWHqqYltrc/3weW+H0G6USvRDnMp+beHgFTY4ptgIFpX1Ef2BYkC3b3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746954579; c=relaxed/simple;
	bh=HNUFdAheGCAS5fh5V6LRxONnz1VzpzJy+sd/x/eWalo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=nJLDmDFJqKsuAyb27lFpeALf2AAeekUIH1FOT3HEPOlR5A0QeRzDZFDrLYdiVlQII13XDts4CkwPERL5xzD48/vW5KD+sL8KF4wZfC8HrcE+tq09IY/M2jc4n8B9T/eRinxRJnQiP2m8iO5cf+ndClkc2vYixH6xwi/7w2+lT54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gp16Bjeh; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gp16Bjeh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SYMgHCMmudGW2BcUDR/0zlfomZn+xuLsKwhbmNfikB8=; b=gp16Bjeh8xVcDaq68xODT3UOso
	iyrXW7OWeCs4hYidfpk6pcKo+d96omdcGTTHlIsYyz+mDY5MxcfJNib5CHRO1/HvK/VSR7jnUJw56
	Ouw48tlqP0XocN3bbx+YCgsSEdCNDjAM9o4RZDUGCmYZWpzEC8u+xuaZavSVk0xlxowR1N9xykKF7
	0qp3Fof4QgZzdrCLMrMwlR0uBpLbdsW3JCdoQIxpX3cTdYF0I26p2MndsPzVfQUeAbmnkr9/XxpUO
	tme3KBHA3n+iAhyUZbkLULsPXDBrRjaMEMGhMf0n+9uUaE0JNcYNp5pDtkuG5JUjXdtVoagxifLdF
	yMUUeVRw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uE2gd-005CP0-1n;
	Sun, 11 May 2025 17:09:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 11 May 2025 17:09:31 +0800
Date: Sun, 11 May 2025 17:09:31 +0800
Message-Id: <0f935c34a7b7e1d172a4f87e32b7a314821e2ade.1746954402.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746954402.git.herbert@gondor.apana.org.au>
References: <cover.1746954402.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 1/6] crypto: hash - Move core export and import into
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

