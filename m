Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EA432D0E2
	for <linux-crypto@vger.kernel.org>; Mon, 22 Dec 2025 10:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766400315; cv=none; b=WFr1wBzsNbhOmNO/ldNZAYr7pJnJtjVZhsj+o9DJPJTI+HbE3XdxCcfsREnxYUilwZILckwGjS9q4D6woSMYwdC7bPoSkfEH5BQ9Kswkcw6DfsAo5AHELkc3k7plqmjCDMNBM1qdXgkDr+2kEBGC5speQN6fy8R/Jbk2nVRqzQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766400315; c=relaxed/simple;
	bh=EcEp6slUSjT1wp31kXYtT+57gC5ajQ5IJ2hZHtNkfXY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jn2wYxhQlqjDT1h6PJPnZzkzKjyah6BPiCOa60HuwSp3OnxsdYb3T79VbKKBMftceqR+YX4qHUL4dpRkAItzv0oZl3s2N5++sW53agGqj8Hkzq9spaVVkxrbp9bgKTB+lxwhHgAto00UUXkusZuvAscfdg0U4q2vG2VmKr4nu9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jJCwWTaO; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jJCwWTaO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766400310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aIywFLL1y3f/yJcgjB7UBK26VXtrZ8Ijc4u4Sn0lBD0=;
	b=jJCwWTaOgL92UJAeeQgt429Oadtdf8HTif2lwZrDGcNstyuAHvKyykBhnJtCDcsvK6xoGH
	eXlS8RGexr/PAWs7/HWmQRUNh3Ak0Arw9ACJhpcPXKJztXY31geuog6CUKXSE0l0f7NZGX
	dfTTkXd4fiT5sPQXO3blC8a+bT73YUQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Neil Horman <nhorman@tuxdriver.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto - remove unnecessary forward declarations
Date: Mon, 22 Dec 2025 11:44:55 +0100
Message-ID: <20251222104457.635513-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add the __maybe_unused attribute to the function definitions and remove
the now-unnecessary forward declarations.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/acompress.c | 6 ++----
 crypto/aead.c      | 5 ++---
 crypto/ahash.c     | 5 ++---
 crypto/akcipher.c  | 6 ++----
 crypto/kpp.c       | 6 ++----
 crypto/rng.c       | 5 ++---
 crypto/shash.c     | 5 ++---
 crypto/skcipher.c  | 5 ++---
 8 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index be28cbfd22e3..9320a3947263 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -60,10 +60,8 @@ static int __maybe_unused crypto_acomp_report(
 	return nla_put(skb, CRYPTOCFGA_REPORT_ACOMP, sizeof(racomp), &racomp);
 }
 
-static void crypto_acomp_show(struct seq_file *m, struct crypto_alg *alg)
-	__maybe_unused;
-
-static void crypto_acomp_show(struct seq_file *m, struct crypto_alg *alg)
+static void __maybe_unused crypto_acomp_show(struct seq_file *m,
+					     struct crypto_alg *alg)
 {
 	seq_puts(m, "type         : acomp\n");
 }
diff --git a/crypto/aead.c b/crypto/aead.c
index 08d44c5e5c33..e009937bf3a5 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -151,9 +151,8 @@ static int __maybe_unused crypto_aead_report(
 	return nla_put(skb, CRYPTOCFGA_REPORT_AEAD, sizeof(raead), &raead);
 }
 
-static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
-	__maybe_unused;
-static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
+static void __maybe_unused crypto_aead_show(struct seq_file *m,
+					    struct crypto_alg *alg)
 {
 	struct aead_alg *aead = container_of(alg, struct aead_alg, base);
 
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 66492ae75fcf..1abfbb7ab486 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -801,9 +801,8 @@ static int __maybe_unused crypto_ahash_report(
 	return nla_put(skb, CRYPTOCFGA_REPORT_HASH, sizeof(rhash), &rhash);
 }
 
-static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
-	__maybe_unused;
-static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
+static void __maybe_unused crypto_ahash_show(struct seq_file *m,
+					     struct crypto_alg *alg)
 {
 	seq_printf(m, "type         : ahash\n");
 	seq_printf(m, "async        : %s\n",
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index a36f50c83827..dfe87b3ce183 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -46,10 +46,8 @@ static int __maybe_unused crypto_akcipher_report(
 		       sizeof(rakcipher), &rakcipher);
 }
 
-static void crypto_akcipher_show(struct seq_file *m, struct crypto_alg *alg)
-	__maybe_unused;
-
-static void crypto_akcipher_show(struct seq_file *m, struct crypto_alg *alg)
+static void __maybe_unused crypto_akcipher_show(struct seq_file *m,
+						struct crypto_alg *alg)
 {
 	seq_puts(m, "type         : akcipher\n");
 }
diff --git a/crypto/kpp.c b/crypto/kpp.c
index 2e0cefe7a25f..7451d39a7ad8 100644
--- a/crypto/kpp.c
+++ b/crypto/kpp.c
@@ -29,10 +29,8 @@ static int __maybe_unused crypto_kpp_report(
 	return nla_put(skb, CRYPTOCFGA_REPORT_KPP, sizeof(rkpp), &rkpp);
 }
 
-static void crypto_kpp_show(struct seq_file *m, struct crypto_alg *alg)
-	__maybe_unused;
-
-static void crypto_kpp_show(struct seq_file *m, struct crypto_alg *alg)
+static void __maybe_unused crypto_kpp_show(struct seq_file *m,
+					   struct crypto_alg *alg)
 {
 	seq_puts(m, "type         : kpp\n");
 }
diff --git a/crypto/rng.c b/crypto/rng.c
index ee1768c5a400..5982dcea1010 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -77,9 +77,8 @@ static int __maybe_unused crypto_rng_report(
 	return nla_put(skb, CRYPTOCFGA_REPORT_RNG, sizeof(rrng), &rrng);
 }
 
-static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
-	__maybe_unused;
-static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
+static void __maybe_unused crypto_rng_show(struct seq_file *m,
+					   struct crypto_alg *alg)
 {
 	seq_printf(m, "type         : rng\n");
 	seq_printf(m, "seedsize     : %u\n", seedsize(alg));
diff --git a/crypto/shash.c b/crypto/shash.c
index 4721f5f134f4..0dab800c48ee 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -346,9 +346,8 @@ static int __maybe_unused crypto_shash_report(
 	return nla_put(skb, CRYPTOCFGA_REPORT_HASH, sizeof(rhash), &rhash);
 }
 
-static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
-	__maybe_unused;
-static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
+static void __maybe_unused crypto_shash_show(struct seq_file *m,
+					     struct crypto_alg *alg)
 {
 	struct shash_alg *salg = __crypto_shash_alg(alg);
 
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 14a820cb06c7..d62c6a360413 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -570,9 +570,8 @@ static void crypto_skcipher_free_instance(struct crypto_instance *inst)
 	skcipher->free(skcipher);
 }
 
-static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
-	__maybe_unused;
-static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
+static void __maybe_unused crypto_skcipher_show(struct seq_file *m,
+						struct crypto_alg *alg)
 {
 	struct skcipher_alg *skcipher = __crypto_skcipher_alg(alg);
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

