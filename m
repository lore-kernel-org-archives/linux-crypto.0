Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EA1224CE
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815801; cv=none; b=NoVWggAVdUCJT3WdaXZaVnt7023qdKRVsbbzz+AuIAXOdTfr634wwjHl0XKzb/Gxa/gtqrxA0WKHOdmEPT4Q7YnT2iPVdRPPjLfKC1RBiRPM4hBig1UC2cr7NWrah1FeLtbmHzdiMjZHv0FoUd2T52vWWVtQvifieg9YgZaG3xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815801; c=relaxed/simple;
	bh=vMWdTGqZggioMH8SFHE+n6lpgIKvNJqLTLAOj5/hGmU=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=nLyoKJLNNvZEQ3UhC0+BUl4RVWjLVw0loUhfPEwmQoriaycS6j6eEMAa1ZQNeSSjxHDJ2XH0pSLt96FyxqV7oBaprt7gtTKibuySv5LBzr/R8twj5XANGCP6Ohk0eZM5jAt7RqRKwb1Kr4x1Xv/kKdT5FvSWOxs33wbhlxHLE88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZou2-00D1q1-Fw; Tue, 13 Feb 2024 17:16:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:16:48 +0800
Message-Id: <d9b505744d7974a5c27eaa86e815f42cec82e6bd.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 5 Dec 2023 14:09:55 +0800
Subject: [PATCH 05/15] crypto: skcipher - Add twopass attribute
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Algorithms such as adiantum requires two passes over the input
and therefore cannot support incremental processing.  Add a new
attribute to identify them.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/lskcipher.c        |  2 ++
 crypto/skcipher.c         |  2 ++
 include/crypto/skcipher.h | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index 260666f34500..bc54cfc2734d 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -301,6 +301,8 @@ static void __maybe_unused crypto_lskcipher_show(
 	seq_printf(m, "chunksize    : %u\n", skcipher->co.chunksize);
 	seq_printf(m, "statesize    : %u\n", skcipher->co.statesize);
 	seq_printf(m, "tailsize     : %u\n", skcipher->co.tailsize);
+	seq_printf(m, "incremental  : %s\n", skcipher->co.twopass ?
+					     "no" : "yes");
 }
 
 static int __maybe_unused crypto_lskcipher_report(
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 600ec5735ce0..40e836be354e 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -837,6 +837,8 @@ static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "walksize     : %u\n", skcipher->walksize);
 	seq_printf(m, "statesize    : %u\n", skcipher->statesize);
 	seq_printf(m, "tailsize     : %u\n", skcipher->tailsize);
+	seq_printf(m, "incremental  : %s\n", skcipher->twopass ?
+					     "no" : "yes");
 }
 
 static int __maybe_unused crypto_skcipher_report(
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 6223d81fed76..3833a2ab1951 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -105,6 +105,7 @@ struct crypto_istat_cipher {
  * @statesize: Size of the internal state for the algorithm.
  * @tailsize: Minimum number of bytes to withhold until the end of operation.
  *	      Used by algorithms such as CTS to support chaining.
+ * @twopass: The algorithm needs two passes over the input, e.g., adiantum.
  * @stat: Statistics for cipher algorithm
  * @base: Definition of a generic crypto algorithm.
  */
@@ -115,6 +116,7 @@ struct crypto_istat_cipher {
 	unsigned int chunksize;		\
 	unsigned int statesize;		\
 	unsigned int tailsize;		\
+	bool twopass;			\
 					\
 	SKCIPHER_ALG_COMMON_STAT	\
 					\
@@ -576,6 +578,36 @@ static inline unsigned int crypto_lskcipher_tailsize(
 	return crypto_lskcipher_alg(tfm)->co.tailsize;
 }
 
+/**
+ * crypto_skcipher_isincremental() - check incremental ability
+ * @tfm: cipher handle
+ *
+ * Most skcipher algorithms can accept data in an incremental fashion.
+ * However, some such as adiantum cannot as they need to pass through
+ * the data twice.
+ *
+ * Return: true if algorithm can accept data incrementally.
+ */
+static inline bool crypto_skcipher_isincremental(struct crypto_skcipher *tfm)
+{
+	return !crypto_skcipher_alg_common(tfm)->twopass;
+}
+
+/**
+ * crypto_lskcipher_isincremental() - check incremental ability
+ * @tfm: cipher handle
+ *
+ * Most lskcipher algorithms can accept data in an incremental fashion.
+ * However, some such as adiantum cannot as they need to pass through
+ * the data twice.
+ *
+ * Return: true if algorithm can accept data incrementally.
+ */
+static inline bool crypto_lskcipher_isincremental(struct crypto_lskcipher *tfm)
+{
+	return !crypto_lskcipher_alg(tfm)->co.twopass;
+}
+
 static inline unsigned int crypto_sync_skcipher_blocksize(
 	struct crypto_sync_skcipher *tfm)
 {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

