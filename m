From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v4 10/17] crypto: Add userspace report for ablkcipher type
 algorithms
Date: Tue, 27 Sep 2011 07:42:32 +0200
Message-ID: <20110927054232.GM1808@secunet.com>
References: <20110927052050.GB1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:46256 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1I0Fmh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Sep 2011 01:42:37 -0400
Content-Disposition: inline
In-Reply-To: <20110927052050.GB1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/ablkcipher.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index fdc67d3..5ea49ad 100644
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
+	NLA_PUT(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
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
 
-- 
1.7.0.4
