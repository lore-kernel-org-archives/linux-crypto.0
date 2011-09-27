From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v4 07/17] crypto: Add userspace report for shash type
 algorithms
Date: Tue, 27 Sep 2011 07:26:10 +0200
Message-ID: <20110927052610.GI1808@secunet.com>
References: <20110927052050.GB1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:59821 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab1I0F0O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Sep 2011 01:26:14 -0400
Content-Disposition: inline
In-Reply-To: <20110927052050.GB1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/shash.c             |   21 +++++++++++++++++++++
 include/linux/cryptouser.h |    7 +++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 76f74b9..ea8a9c6 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -17,6 +17,8 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
 
 #include "internal.h"
 
@@ -522,6 +524,24 @@ static unsigned int crypto_shash_extsize(struct crypto_alg *alg)
 	return alg->cra_ctxsize;
 }
 
+static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_hash rhash;
+	struct shash_alg *salg = __crypto_shash_alg(alg);
+
+	snprintf(rhash.type, CRYPTO_MAX_ALG_NAME, "%s", "shash");
+	rhash.blocksize = alg->cra_blocksize;
+	rhash.digestsize = salg->digestsize;
+
+	NLA_PUT(skb, CRYPTOCFGA_REPORT_HASH,
+		sizeof(struct crypto_report_hash), &rhash);
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
@@ -541,6 +561,7 @@ static const struct crypto_type crypto_shash_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_shash_show,
 #endif
+	.report = crypto_shash_report,
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
 	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_SHASH,
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index 7a849b4..ee46882 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -37,6 +37,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_UNSPEC,
 	CRYPTOCFGA_PRIORITY_VAL,	/* __u32 */
 	CRYPTOCFGA_REPORT_LARVAL,	/* struct crypto_report_larval */
+	CRYPTOCFGA_REPORT_HASH,		/* struct crypto_report_hash */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -55,3 +56,9 @@ struct crypto_user_alg {
 struct crypto_report_larval {
 	char type[CRYPTO_MAX_NAME];
 };
+
+struct crypto_report_hash {
+	char type[CRYPTO_MAX_NAME];
+	unsigned int blocksize;
+	unsigned int digestsize;
+};
-- 
1.7.0.4
