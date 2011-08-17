From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v2 09/15] crypto: Add userspace report for givcipher type
 algorithms
Date: Wed, 17 Aug 2011 14:14:28 +0200
Message-ID: <20110817121428.GG16877@secunet.com>
References: <20110817120859.GX16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:46977 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab1HQMNb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2011 08:13:31 -0400
Content-Disposition: inline
In-Reply-To: <20110817120859.GX16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/ablkcipher.c        |   25 +++++++++++++++++++++++++
 include/linux/cryptouser.h |    1 +
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 60f5c01..45ed1c3 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -459,6 +459,30 @@ static int crypto_init_givcipher_ops(struct crypto_tfm *tfm, u32 type,
 	return 0;
 }
 
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
@@ -481,6 +505,7 @@ const struct crypto_type crypto_givcipher_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_givcipher_show,
 #endif
+	.report = crypto_givcipher_report,
 };
 EXPORT_SYMBOL_GPL(crypto_givcipher_type);
 
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index c0023cf..2e67da6 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -38,6 +38,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_AHASH,	/* struct crypto_report_ahash */
 	CRYPTOCFGA_REPORT_BLKCIPHER,	/* struct crypto_report_blkcipher */
 	CRYPTOCFGA_REPORT_ABLKCIPHER,	/* struct crypto_report_ablkcipher */
+	CRYPTOCFGA_REPORT_GIVCIPHER,	/* struct crypto_report_ablkcipher */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
-- 
1.7.0.4
