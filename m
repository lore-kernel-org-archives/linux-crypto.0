From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 08/16] crypto: Add userspace report for blkcipher type
 algorithms
Date: Thu, 11 Aug 2011 13:31:04 +0200
Message-ID: <20110811113104.GL16877@secunet.com>
References: <20110811112603.GD16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:44178 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab1HKLac (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 07:30:32 -0400
Content-Disposition: inline
In-Reply-To: <20110811112603.GD16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/blkcipher.c         |   29 +++++++++++++++++++++++++++++
 include/linux/cryptouser.h |   10 ++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 7a72192..b85a67d 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -24,6 +24,8 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
 
 #include "internal.h"
 
@@ -492,6 +494,30 @@ static int crypto_init_blkcipher_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 		return crypto_init_blkcipher_ops_async(tfm);
 }
 
+static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_blkcipher rblkcipher;
+
+	snprintf(rblkcipher.type, CRYPTO_MAX_ALG_NAME, "%s", "blkcipher");
+	snprintf(rblkcipher.geniv, CRYPTO_MAX_ALG_NAME, "%s",
+		 alg->cra_blkcipher.geniv ?: "<default>");
+
+	rblkcipher.blocksize = alg->cra_blocksize;
+	rblkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
+	rblkcipher.max_keysize = alg->cra_blkcipher.max_keysize;
+	rblkcipher.ivsize = alg->cra_blkcipher.ivsize;
+
+	NLA_PUT(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
+		sizeof(struct crypto_report_blkcipher), &rblkcipher);
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
@@ -511,6 +537,9 @@ const struct crypto_type crypto_blkcipher_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_blkcipher_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
+	.report = crypto_blkcipher_report,
+#endif
 };
 EXPORT_SYMBOL_GPL(crypto_blkcipher_type);
 
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index 94ffb7b..e2e6c4c 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -37,6 +37,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_LARVAL,	/* struct crypto_report_larval */
 	CRYPTOCFGA_REPORT_SHASH,	/* struct crypto_report_shash */
 	CRYPTOCFGA_REPORT_AHASH,	/* struct crypto_report_ahash */
+	CRYPTOCFGA_REPORT_BLKCIPHER,	/* struct crypto_report_blkcipher */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -77,3 +78,12 @@ struct crypto_report_ahash {
 	unsigned int blocksize;
 	unsigned int digestsize;
 };
+
+struct crypto_report_blkcipher {
+	char type[CRYPTO_MAX_NAME];
+	char geniv[CRYPTO_MAX_NAME];
+	unsigned int blocksize;
+	unsigned int min_keysize;
+	unsigned int max_keysize;
+	unsigned int ivsize;
+};
-- 
1.7.0.4
