From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 06/16] crypto: AF_ALG - consolidate counting TX SG entries
Date: Mon, 31 Jul 2017 14:07:30 +0200
Message-ID: <1557932.FrTNfmMMP7@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60874 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752189AbdGaMLi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:38 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consoliate aead_count_tsgl, skcipher_count_tsgl ==> af_alg_count_tsgl

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 52 ++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/algif_aead.c     | 53 ++++---------------------------------------------
 crypto/algif_skcipher.c | 30 ++--------------------------
 include/crypto/if_alg.h |  1 +
 4 files changed, 59 insertions(+), 77 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 87138c4b5a0f..861167fc12f7 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -544,6 +544,58 @@ int af_alg_alloc_tsgl(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(af_alg_alloc_tsgl);
 
+/**
+ * aead_count_tsgl - Count number of TX SG entries
+ *
+ * The counting starts from the beginning of the SGL to @bytes. If
+ * an offset is provided, the counting of the SG entries starts at the offset.
+ *
+ * @sk socket of connection to user space
+ * @bytes Count the number of SG entries holding given number of bytes.
+ * @offset Start the counting of SG entries from the given offset.
+ * @return Number of TX SG entries found given the constraints
+ */
+unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
+	struct af_alg_tsgl *sgl, *tmp;
+	unsigned int i;
+	unsigned int sgl_count = 0;
+
+	if (!bytes)
+		return 0;
+
+	list_for_each_entry_safe(sgl, tmp, &ctx->tsgl_list, list) {
+		struct scatterlist *sg = sgl->sg;
+
+		for (i = 0; i < sgl->cur; i++) {
+			size_t bytes_count;
+
+			/* Skip offset */
+			if (offset >= sg[i].length) {
+				offset -= sg[i].length;
+				bytes -= sg[i].length;
+				continue;
+			}
+
+			bytes_count = sg[i].length - offset;
+
+			offset = 0;
+			sgl_count++;
+
+			/* If we have seen requested number of bytes, stop */
+			if (bytes_count >= bytes)
+				return sgl_count;
+
+			bytes -= bytes_count;
+		}
+	}
+
+	return sgl_count;
+}
+EXPORT_SYMBOL_GPL(af_alg_count_tsgl);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index a722df95e55c..78651b26aa77 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -65,58 +65,13 @@ static inline bool aead_sufficient_data(struct sock *sk)
 }
 
 /**
- * Count number of SG entries from the beginning of the SGL to @bytes. If
- * an offset is provided, the counting of the SG entries starts at the offset.
- */
-static unsigned int aead_count_tsgl(struct sock *sk, size_t bytes,
-				    size_t offset)
-{
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_tsgl *sgl, *tmp;
-	unsigned int i;
-	unsigned int sgl_count = 0;
-
-	if (!bytes)
-		return 0;
-
-	list_for_each_entry_safe(sgl, tmp, &ctx->tsgl_list, list) {
-		struct scatterlist *sg = sgl->sg;
-
-		for (i = 0; i < sgl->cur; i++) {
-			size_t bytes_count;
-
-			/* Skip offset */
-			if (offset >= sg[i].length) {
-				offset -= sg[i].length;
-				bytes -= sg[i].length;
-				continue;
-			}
-
-			bytes_count = sg[i].length - offset;
-
-			offset = 0;
-			sgl_count++;
-
-			/* If we have seen requested number of bytes, stop */
-			if (bytes_count >= bytes)
-				return sgl_count;
-
-			bytes -= bytes_count;
-		}
-	}
-
-	return sgl_count;
-}
-
-/**
  * Release the specified buffers from TX SGL pointed to by ctx->tsgl_list for
  * @used bytes.
  *
  * If @dst is non-null, reassign the pages to dst. The caller must release
  * the pages. If @dst_offset is given only reassign the pages to @dst starting
  * at the @dst_offset (byte). The caller must ensure that @dst is large
- * enough (e.g. by using aead_count_tsgl with the same offset).
+ * enough (e.g. by using af_alg_count_tsgl with the same offset).
  */
 static void aead_pull_tsgl(struct sock *sk, size_t used,
 			   struct scatterlist *dst, size_t dst_offset)
@@ -140,7 +95,7 @@ static void aead_pull_tsgl(struct sock *sk, size_t used,
 				continue;
 
 			/*
-			 * Assumption: caller created aead_count_tsgl(len)
+			 * Assumption: caller created af_alg_count_tsgl(len)
 			 * SG entries in dst.
 			 */
 			if (dst) {
@@ -724,8 +679,8 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 			goto free;
 
 		/* Create TX SGL for tag and chain it to RX SGL. */
-		areq->tsgl_entries = aead_count_tsgl(sk, processed,
-						     processed - as);
+		areq->tsgl_entries = af_alg_count_tsgl(sk, processed,
+						       processed - as);
 		if (!areq->tsgl_entries)
 			areq->tsgl_entries = 1;
 		areq->tsgl = sock_kmalloc(sk, sizeof(*areq->tsgl) *
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index d511f665a190..8e086d9f7b71 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -44,32 +44,6 @@ struct skcipher_tfm {
 	bool has_key;
 };
 
-static unsigned int skcipher_count_tsgl(struct sock *sk, size_t bytes)
-{
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_tsgl *sgl, *tmp;
-	unsigned int i;
-	unsigned int sgl_count = 0;
-
-	if (!bytes)
-		return 0;
-
-	list_for_each_entry_safe(sgl, tmp, &ctx->tsgl_list, list) {
-		struct scatterlist *sg = sgl->sg;
-
-		for (i = 0; i < sgl->cur; i++) {
-			sgl_count++;
-			if (sg[i].length >= bytes)
-				return sgl_count;
-
-			bytes -= sg[i].length;
-		}
-	}
-
-	return sgl_count;
-}
-
 static void skcipher_pull_tsgl(struct sock *sk, size_t used,
 			       struct scatterlist *dst)
 {
@@ -92,7 +66,7 @@ static void skcipher_pull_tsgl(struct sock *sk, size_t used,
 				continue;
 
 			/*
-			 * Assumption: caller created skcipher_count_tsgl(len)
+			 * Assumption: caller created af_alg_count_tsgl(len)
 			 * SG entries in dst.
 			 */
 			if (dst)
@@ -543,7 +517,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * Create a per request TX SGL for this request which tracks the
 	 * SG entries from the global TX SGL.
 	 */
-	areq->tsgl_entries = skcipher_count_tsgl(sk, len);
+	areq->tsgl_entries = af_alg_count_tsgl(sk, len, 0);
 	if (!areq->tsgl_entries)
 		areq->tsgl_entries = 1;
 	areq->tsgl = sock_kmalloc(sk, sizeof(*areq->tsgl) * areq->tsgl_entries,
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index cfebf65303c7..3029cf4f2890 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -241,5 +241,6 @@ static inline bool af_alg_readable(struct sock *sk)
 }
 
 int af_alg_alloc_tsgl(struct sock *sk);
+unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset);
 
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
