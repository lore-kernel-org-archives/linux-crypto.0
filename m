From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 10/16] crypto: Add userspace report for givcipher type
 algorithms
Date: Thu, 11 Aug 2011 13:32:21 +0200
Message-ID: <20110811113220.GN16877@secunet.com>
References: <20110811112603.GD16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:56351 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab1HKLbs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 07:31:48 -0400
Content-Disposition: inline
In-Reply-To: <20110811112603.GD16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/ablkcipher.c        |   29 +++++++++++++++++++++++++++++
 include/linux/cryptouser.h |    1 +
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index d9b6717..c19d14b 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -463,6 +463,32 @@ static int crypto_init_givcipher_ops(struct crypto_tfm *tfm, u32 type,
 	return 0;
 }
 
+static int crypto_givcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static int crypto_givcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_ablkcipher rablkcipher;
+
+	snprintf(rablkcipher.type, CRYPTO_MAX_ALG_NAME, "%s", "givcipher");
+	snprintf(rablkcipher.geniv, CRYPTO_MAX_ALG_NAME, "%s",
+		 alg->cra_ablkcipher.geniv ?: "<built-in>");
+	snprintf(rablkcipher.async, CRYPTO_MAX_ALG_NAME, "%s",
+		 alg->cra_flags & CRYPTO_ALG_ASYNC ? "yes" : "no");
+
+	rablkcipher.blocksize = alg->cra_blocksize;
+	rablkcipher.min_keysize = alg->cra_ablkcipher.min_keysize;
+	rablkcipher.max_keysize = alg->cra_ablkcipher.max_keysize;
+	rablkcipher.ivsize = alg->cra_ablkcipher.ivsize;
+
+	NLA_PUT(skb, CRYPTOCFGA_REPORT_GIVCIPHER,
+		sizeof(struct crypto_report_ablkcipher), &rablkcipher);
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static void crypto_givcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_givcipher_show(struct seq_file *m, struct crypto_alg *alg)
@@ -485,6 +511,9 @@ const struct crypto_type crypto_givcipher_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_givcipher_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
+	.report = crypto_givcipher_report,
+#endif
 };
 EXPORT_SYMBOL_GPL(crypto_givcipher_type);
 
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index 8440966..e2c76f7 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -39,6 +39,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_AHASH,	/* struct crypto_report_ahash */
 	CRYPTOCFGA_REPORT_BLKCIPHER,	/* struct crypto_report_blkcipher */
 	CRYPTOCFGA_REPORT_ABLKCIPHER,	/* struct crypto_report_ablkcipher */
+	CRYPTOCFGA_REPORT_GIVCIPHER,	/* struct crypto_report_ablkcipher */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
-- 
1.7.0.4
