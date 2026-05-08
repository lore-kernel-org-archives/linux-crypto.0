Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89823128CA
	for <linux-crypto@vger.kernel.org>; Fri,  8 May 2026 10:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778237873; cv=none; b=S/0MMIhtg1o6WaatDTrDnu2GsCtZkF9zYg1sKJt6DDtTP1BIZ3MmW2goevyFwWRWIh41YPJnZmLBmgUbAjZVc+cU9sI7jDVDd84oTRUOzaEImCb62NTG3g8oV3AbZSaaLm2WScemsWiNbwFfjPghwS8fMZTMjsbF03RHnl8oFKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778237873; c=relaxed/simple;
	bh=osTpXZEqTNoUgKMmpt6GTU6Dt44cvUtUMVwtcbgXOo0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dbiiyxi0M0HUu2VuYUpnO1bZbX8Gi99eZcB5gMf6M0ZLfy/rdCR5f0q7mG6hU9VHBqwoIFh3zjpVRhZt9Bx2ycIWRaohevdOIz6UWD7l3bXdnEN9IcEVpyVRQh28ZQc5hMZ79CBL7pKoHh+OQp5Q+28jEl5oTIolnbwqq6IhdE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: use designated initializers for report structs
Date: Fri,  8 May 2026 12:57:17 +0200
Message-ID: <20260508105717.472043-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9056; i=thorsten.blum@linux.dev; h=from:subject; bh=osTpXZEqTNoUgKMmpt6GTU6Dt44cvUtUMVwtcbgXOo0=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJl/D/YuNXIXZneVecwaeEfHxda+ODKVI/ZWiPiV/b+zt gof683qKGVhEONikBVTZHkw68cM39Kayk0mETth5rAygQxh4OIUgIn0cDD84Vj9dOGrzYuZJs28 1lbNeK7J5Wrext9tEy1lqrod/Xcef8rIcP2011lG7nMxRbPEXItD9wYvPSkvztx/NcHnf3nIJ6U T/AA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use designated initializers for the report structs instead of clearing
the struct with memset() and then copying fixed strings with strscpy()
at runtime.

This keeps the structs zero-initialized, lets the compiler diagnose
oversized string literals, and makes the code easier to read.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/acompress.c   |  8 +++-----
 crypto/aead.c        | 10 ++++------
 crypto/ahash.c       |  8 +++-----
 crypto/akcipher.c    |  8 +++-----
 crypto/crypto_user.c | 14 ++++++--------
 crypto/kpp.c         |  8 +++-----
 crypto/lskcipher.c   | 10 ++++------
 crypto/rng.c         |  8 +++-----
 crypto/scompress.c   |  8 +++-----
 crypto/shash.c       |  8 +++-----
 crypto/sig.c         |  6 +++---
 crypto/skcipher.c    | 10 ++++------
 12 files changed, 42 insertions(+), 64 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 6025c1acce49..032de704eb2c 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -51,11 +51,9 @@ static inline struct acomp_alg *crypto_acomp_alg(struct crypto_acomp *tfm)
 static int __maybe_unused crypto_acomp_report(
 	struct sk_buff *skb, struct crypto_alg *alg)
 {
-	struct crypto_report_acomp racomp;
-
-	memset(&racomp, 0, sizeof(racomp));
-
-	strscpy(racomp.type, "acomp", sizeof(racomp.type));
+	struct crypto_report_acomp racomp = {
+		.type = "acomp",
+	};
 
 	return nla_put(skb, CRYPTOCFGA_REPORT_ACOMP, sizeof(racomp), &racomp);
 }
diff --git a/crypto/aead.c b/crypto/aead.c
index e009937bf3a5..045b74c3779f 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -136,13 +136,11 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 static int __maybe_unused crypto_aead_report(
 	struct sk_buff *skb, struct crypto_alg *alg)
 {
-	struct crypto_report_aead raead;
 	struct aead_alg *aead = container_of(alg, struct aead_alg, base);
-
-	memset(&raead, 0, sizeof(raead));
-
-	strscpy(raead.type, "aead", sizeof(raead.type));
-	strscpy(raead.geniv, "<none>", sizeof(raead.geniv));
+	struct crypto_report_aead raead = {
+		.type = "aead",
+		.geniv = "<none>",
+	};
 
 	raead.blocksize = alg->cra_blocksize;
 	raead.maxauthsize = aead->maxauthsize;
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 7a730324c50e..dd56b0e45c0d 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -789,11 +789,9 @@ static void crypto_ahash_free_instance(struct crypto_instance *inst)
 static int __maybe_unused crypto_ahash_report(
 	struct sk_buff *skb, struct crypto_alg *alg)
 {
-	struct crypto_report_hash rhash;
-
-	memset(&rhash, 0, sizeof(rhash));
-
-	strscpy(rhash.type, "ahash", sizeof(rhash.type));
+	struct crypto_report_hash rhash = {
+		.type = "ahash",
+	};
 
 	rhash.blocksize = alg->cra_blocksize;
 	rhash.digestsize = __crypto_hash_alg_common(alg)->digestsize;
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index dfe87b3ce183..630bb19738be 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -36,11 +36,9 @@ struct crypto_akcipher_sync_data {
 static int __maybe_unused crypto_akcipher_report(
 	struct sk_buff *skb, struct crypto_alg *alg)
 {
-	struct crypto_report_akcipher rakcipher;
-
-	memset(&rakcipher, 0, sizeof(rakcipher));
-
-	strscpy(rakcipher.type, "akcipher", sizeof(rakcipher.type));
+	struct crypto_report_akcipher rakcipher = {
+		.type = "akcipher",
+	};
 
 	return nla_put(skb, CRYPTOCFGA_REPORT_AKCIPHER,
 		       sizeof(rakcipher), &rakcipher);
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 3187e0d276f9..e8b6ae75f31f 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -70,11 +70,9 @@ static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
 
 static int crypto_report_cipher(struct sk_buff *skb, struct crypto_alg *alg)
 {
-	struct crypto_report_cipher rcipher;
-
-	memset(&rcipher, 0, sizeof(rcipher));
-
-	strscpy(rcipher.type, "cipher", sizeof(rcipher.type));
+	struct crypto_report_cipher rcipher = {
+		.type = "cipher",
+	};
 
 	rcipher.blocksize = alg->cra_blocksize;
 	rcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
@@ -103,10 +101,10 @@ static int crypto_report_one(struct crypto_alg *alg,
 	if (nla_put_u32(skb, CRYPTOCFGA_PRIORITY_VAL, alg->cra_priority))
 		goto nla_put_failure;
 	if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
-		struct crypto_report_larval rl;
+		struct crypto_report_larval rl = {
+			.type = "larval",
+		};
 
-		memset(&rl, 0, sizeof(rl));
-		strscpy(rl.type, "larval", sizeof(rl.type));
 		if (nla_put(skb, CRYPTOCFGA_REPORT_LARVAL, sizeof(rl), &rl))
 			goto nla_put_failure;
 		goto out;
diff --git a/crypto/kpp.c b/crypto/kpp.c
index 7451d39a7ad8..522c352a03af 100644
--- a/crypto/kpp.c
+++ b/crypto/kpp.c
@@ -20,11 +20,9 @@
 static int __maybe_unused crypto_kpp_report(
 	struct sk_buff *skb, struct crypto_alg *alg)
 {
-	struct crypto_report_kpp rkpp;
-
-	memset(&rkpp, 0, sizeof(rkpp));
-
-	strscpy(rkpp.type, "kpp", sizeof(rkpp.type));
+	struct crypto_report_kpp rkpp = {
+		.type = "kpp",
+	};
 
 	return nla_put(skb, CRYPTOCFGA_REPORT_KPP, sizeof(rkpp), &rkpp);
 }
diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index bb166250b732..e4328df6e26c 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -264,12 +264,10 @@ static int __maybe_unused crypto_lskcipher_report(
 	struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct lskcipher_alg *skcipher = __crypto_lskcipher_alg(alg);
-	struct crypto_report_blkcipher rblkcipher;
-
-	memset(&rblkcipher, 0, sizeof(rblkcipher));
-
-	strscpy(rblkcipher.type, "lskcipher", sizeof(rblkcipher.type));
-	strscpy(rblkcipher.geniv, "<none>", sizeof(rblkcipher.geniv));
+	struct crypto_report_blkcipher rblkcipher = {
+		.type = "lskcipher",
+		.geniv = "<none>",
+	};
 
 	rblkcipher.blocksize = alg->cra_blocksize;
 	rblkcipher.min_keysize = skcipher->co.min_keysize;
diff --git a/crypto/rng.c b/crypto/rng.c
index 1d4b9177bad4..eec786c45bdd 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -65,11 +65,9 @@ static unsigned int seedsize(struct crypto_alg *alg)
 static int __maybe_unused crypto_rng_report(
 	struct sk_buff *skb, struct crypto_alg *alg)
 {
-	struct crypto_report_rng rrng;
-
-	memset(&rrng, 0, sizeof(rrng));
-
-	strscpy(rrng.type, "rng", sizeof(rrng.type));
+	struct crypto_report_rng rrng = {
+		.type = "rng",
+	};
 
 	rrng.seedsize = seedsize(alg);
 
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 253655ece83f..de54227203ce 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -48,11 +48,9 @@ static DECLARE_WORK(scomp_scratch_work, scomp_scratch_workfn);
 static int __maybe_unused crypto_scomp_report(
 	struct sk_buff *skb, struct crypto_alg *alg)
 {
-	struct crypto_report_comp rscomp;
-
-	memset(&rscomp, 0, sizeof(rscomp));
-
-	strscpy(rscomp.type, "scomp", sizeof(rscomp.type));
+	struct crypto_report_comp rscomp = {
+		.type = "scomp",
+	};
 
 	return nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
 		       sizeof(rscomp), &rscomp);
diff --git a/crypto/shash.c b/crypto/shash.c
index 2f07d0bd1f61..d31a65570f69 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -333,12 +333,10 @@ static void crypto_shash_free_instance(struct crypto_instance *inst)
 static int __maybe_unused crypto_shash_report(
 	struct sk_buff *skb, struct crypto_alg *alg)
 {
-	struct crypto_report_hash rhash;
 	struct shash_alg *salg = __crypto_shash_alg(alg);
-
-	memset(&rhash, 0, sizeof(rhash));
-
-	strscpy(rhash.type, "shash", sizeof(rhash.type));
+	struct crypto_report_hash rhash = {
+		.type = "shash",
+	};
 
 	rhash.blocksize = alg->cra_blocksize;
 	rhash.digestsize = salg->digestsize;
diff --git a/crypto/sig.c b/crypto/sig.c
index beba745b6405..7d2048da5c3a 100644
--- a/crypto/sig.c
+++ b/crypto/sig.c
@@ -53,9 +53,9 @@ static void __maybe_unused crypto_sig_show(struct seq_file *m,
 static int __maybe_unused crypto_sig_report(struct sk_buff *skb,
 					    struct crypto_alg *alg)
 {
-	struct crypto_report_sig rsig = {};
-
-	strscpy(rsig.type, "sig", sizeof(rsig.type));
+	struct crypto_report_sig rsig = {
+		.type = "sig",
+	};
 
 	return nla_put(skb, CRYPTOCFGA_REPORT_SIG, sizeof(rsig), &rsig);
 }
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 2b31d1d5d268..617e840432b1 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -591,12 +591,10 @@ static int __maybe_unused crypto_skcipher_report(
 	struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct skcipher_alg *skcipher = __crypto_skcipher_alg(alg);
-	struct crypto_report_blkcipher rblkcipher;
-
-	memset(&rblkcipher, 0, sizeof(rblkcipher));
-
-	strscpy(rblkcipher.type, "skcipher", sizeof(rblkcipher.type));
-	strscpy(rblkcipher.geniv, "<none>", sizeof(rblkcipher.geniv));
+	struct crypto_report_blkcipher rblkcipher = {
+		.type = "skcipher",
+		.geniv = "<none>",
+	};
 
 	rblkcipher.blocksize = alg->cra_blocksize;
 	rblkcipher.min_keysize = skcipher->min_keysize;
