From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v3 09/17] crypto: Add userspace report for blkcipher type
 algorithms
Date: Wed, 21 Sep 2011 11:06:28 +0200
Message-ID: <20110921090628.GN1808@secunet.com>
References: <20110921085855.GE1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:35759 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1IUJGe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Sep 2011 05:06:34 -0400
Content-Disposition: inline
In-Reply-To: <20110921085855.GE1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/blkcipher.c         |   25 +++++++++++++++++++++++++
 include/linux/cryptouser.h |   10 ++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 7a72192..2572d26 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -24,6 +24,8 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
 
 #include "internal.h"
 
@@ -492,6 +494,28 @@ static int crypto_init_blkcipher_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 		return crypto_init_blkcipher_ops_async(tfm);
 }
 
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
@@ -511,6 +535,7 @@ const struct crypto_type crypto_blkcipher_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_blkcipher_show,
 #endif
+	.report = crypto_blkcipher_report,
 };
 EXPORT_SYMBOL_GPL(crypto_blkcipher_type);
 
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index aedee33..62ae124 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -39,6 +39,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_LARVAL,	/* struct crypto_report_larval */
 	CRYPTOCFGA_REPORT_SHASH,	/* struct crypto_report_hash */
 	CRYPTOCFGA_REPORT_AHASH,	/* struct crypto_report_hash */
+	CRYPTOCFGA_REPORT_BLKCIPHER,	/* struct crypto_report_blkcipher */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -64,3 +65,12 @@ struct crypto_report_hash {
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
