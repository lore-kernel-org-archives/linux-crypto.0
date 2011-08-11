From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 09/16] crypto: Add userspace report for ablkcipher type
 algorithms
Date: Thu, 11 Aug 2011 13:31:40 +0200
Message-ID: <20110811113140.GM16877@secunet.com>
References: <20110811112603.GD16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:44184 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab1HKLbJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 07:31:09 -0400
Content-Disposition: inline
In-Reply-To: <20110811112603.GD16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/ablkcipher.c        |   31 +++++++++++++++++++++++++++++++
 include/linux/cryptouser.h |   11 +++++++++++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index fdc67d3..d9b6717 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -23,6 +23,8 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
 
 #include <crypto/scatterwalk.h>
 
@@ -381,6 +383,32 @@ static int crypto_init_ablkcipher_ops(struct crypto_tfm *tfm, u32 type,
 	return 0;
 }
 
+static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_ablkcipher rablkcipher;
+
+	snprintf(rablkcipher.type, CRYPTO_MAX_ALG_NAME, "%s", "ablkcipher");
+	snprintf(rablkcipher.geniv, CRYPTO_MAX_ALG_NAME, "%s",
+		 alg->cra_ablkcipher.geniv ?: "<default>");
+	snprintf(rablkcipher.async, CRYPTO_MAX_ALG_NAME, "%s",
+		 alg->cra_flags & CRYPTO_ALG_ASYNC ? "yes" : "no");
+
+	rablkcipher.blocksize = alg->cra_blocksize;
+	rablkcipher.min_keysize = alg->cra_ablkcipher.min_keysize;
+	rablkcipher.max_keysize = alg->cra_ablkcipher.max_keysize;
+	rablkcipher.ivsize = alg->cra_ablkcipher.ivsize;
+
+	NLA_PUT(skb, CRYPTOCFGA_REPORT_ABLKCIPHER,
+		sizeof(struct crypto_report_ablkcipher), &rablkcipher);
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static void crypto_ablkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_ablkcipher_show(struct seq_file *m, struct crypto_alg *alg)
@@ -403,6 +431,9 @@ const struct crypto_type crypto_ablkcipher_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_ablkcipher_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
+	.report = crypto_ablkcipher_report,
+#endif
 };
 EXPORT_SYMBOL_GPL(crypto_ablkcipher_type);
 
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index e2e6c4c..8440966 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -38,6 +38,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_SHASH,	/* struct crypto_report_shash */
 	CRYPTOCFGA_REPORT_AHASH,	/* struct crypto_report_ahash */
 	CRYPTOCFGA_REPORT_BLKCIPHER,	/* struct crypto_report_blkcipher */
+	CRYPTOCFGA_REPORT_ABLKCIPHER,	/* struct crypto_report_ablkcipher */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -87,3 +88,13 @@ struct crypto_report_blkcipher {
 	unsigned int max_keysize;
 	unsigned int ivsize;
 };
+
+struct crypto_report_ablkcipher {
+	char type[CRYPTO_MAX_NAME];
+	char async[CRYPTO_MAX_NAME];
+	char geniv[CRYPTO_MAX_NAME];
+	unsigned int blocksize;
+	unsigned int min_keysize;
+	unsigned int max_keysize;
+	unsigned int ivsize;
+};
-- 
1.7.0.4
