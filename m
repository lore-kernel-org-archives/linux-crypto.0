From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v3 10/17] crypto: Add userspace report for ablkcipher type
 algorithms
Date: Wed, 21 Sep 2011 11:07:16 +0200
Message-ID: <20110921090716.GO1808@secunet.com>
References: <20110921085855.GE1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:35775 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1IUJHS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Sep 2011 05:07:18 -0400
Content-Disposition: inline
In-Reply-To: <20110921085855.GE1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/ablkcipher.c        |   25 +++++++++++++++++++++++++
 include/linux/cryptouser.h |    1 +
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index fdc67d3..3b0dc30 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -23,6 +23,8 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
 
 #include <crypto/scatterwalk.h>
 
@@ -381,6 +383,28 @@ static int crypto_init_ablkcipher_ops(struct crypto_tfm *tfm, u32 type,
 	return 0;
 }
 
+static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_blkcipher rblkcipher;
+
+	snprintf(rblkcipher.type, CRYPTO_MAX_ALG_NAME, "%s", "ablkcipher");
+	snprintf(rblkcipher.geniv, CRYPTO_MAX_ALG_NAME, "%s",
+		 alg->cra_ablkcipher.geniv ?: "<default>");
+
+	rblkcipher.blocksize = alg->cra_blocksize;
+	rblkcipher.min_keysize = alg->cra_ablkcipher.min_keysize;
+	rblkcipher.max_keysize = alg->cra_ablkcipher.max_keysize;
+	rblkcipher.ivsize = alg->cra_ablkcipher.ivsize;
+
+	NLA_PUT(skb, CRYPTOCFGA_REPORT_ABLKCIPHER,
+		sizeof(struct crypto_report_blkcipher), &rblkcipher);
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
@@ -403,6 +427,7 @@ const struct crypto_type crypto_ablkcipher_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_ablkcipher_show,
 #endif
+	.report = crypto_ablkcipher_report,
 };
 EXPORT_SYMBOL_GPL(crypto_ablkcipher_type);
 
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index 62ae124..0c359e5 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -40,6 +40,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_SHASH,	/* struct crypto_report_hash */
 	CRYPTOCFGA_REPORT_AHASH,	/* struct crypto_report_hash */
 	CRYPTOCFGA_REPORT_BLKCIPHER,	/* struct crypto_report_blkcipher */
+	CRYPTOCFGA_REPORT_ABLKCIPHER,	/* struct crypto_report_blkcipher */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
-- 
1.7.0.4
