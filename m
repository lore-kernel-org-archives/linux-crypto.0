From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v2 08/15] crypto: Add userspace report for ablkcipher type
 algorithms
Date: Wed, 17 Aug 2011 14:13:53 +0200
Message-ID: <20110817121353.GF16877@secunet.com>
References: <20110817120859.GX16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:46969 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab1HQMND (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2011 08:13:03 -0400
Content-Disposition: inline
In-Reply-To: <20110817120859.GX16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/ablkcipher.c        |   27 +++++++++++++++++++++++++++
 include/linux/cryptouser.h |   11 +++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index fdc67d3..60f5c01 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -23,6 +23,8 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
 
 #include <crypto/scatterwalk.h>
 
@@ -381,6 +383,30 @@ static int crypto_init_ablkcipher_ops(struct crypto_tfm *tfm, u32 type,
 	return 0;
 }
 
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
@@ -403,6 +429,7 @@ const struct crypto_type crypto_ablkcipher_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_ablkcipher_show,
 #endif
+	.report = crypto_ablkcipher_report,
 };
 EXPORT_SYMBOL_GPL(crypto_ablkcipher_type);
 
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index c59109f..c0023cf 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -37,6 +37,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_SHASH,	/* struct crypto_report_shash */
 	CRYPTOCFGA_REPORT_AHASH,	/* struct crypto_report_ahash */
 	CRYPTOCFGA_REPORT_BLKCIPHER,	/* struct crypto_report_blkcipher */
+	CRYPTOCFGA_REPORT_ABLKCIPHER,	/* struct crypto_report_ablkcipher */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -86,3 +87,13 @@ struct crypto_report_blkcipher {
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
