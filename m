From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 07/16] crypto: Add userspace report for ahash type
 algorithms
Date: Thu, 11 Aug 2011 13:30:31 +0200
Message-ID: <20110811113030.GK16877@secunet.com>
References: <20110811112603.GD16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:44157 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab1HKL36 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 07:29:58 -0400
Content-Disposition: inline
In-Reply-To: <20110811112603.GD16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/ahash.c             |   27 +++++++++++++++++++++++++++
 include/linux/cryptouser.h |    8 ++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index f669822..5dce6a0 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -21,6 +21,8 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
 
 #include "internal.h"
 
@@ -397,6 +399,28 @@ static unsigned int crypto_ahash_extsize(struct crypto_alg *alg)
 	return sizeof(struct crypto_shash *);
 }
 
+static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_ahash rahash;
+
+	snprintf(rahash.type, CRYPTO_MAX_ALG_NAME, "%s", "ahash");
+	snprintf(rahash.async, CRYPTO_MAX_ALG_NAME, "%s",
+		 alg->cra_flags & CRYPTO_ALG_ASYNC ? "yes" : "no");
+
+	rahash.blocksize = alg->cra_blocksize;
+	rahash.digestsize = __crypto_hash_alg_common(alg)->digestsize;
+
+	NLA_PUT(skb, CRYPTOCFGA_REPORT_AHASH,
+		sizeof(struct crypto_report_ahash), &rahash);
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
@@ -415,6 +439,9 @@ const struct crypto_type crypto_ahash_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_ahash_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
+	.report = crypto_ahash_report,
+#endif
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
 	.maskset = CRYPTO_ALG_TYPE_AHASH_MASK,
 	.type = CRYPTO_ALG_TYPE_AHASH,
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index 8f2b4a1..94ffb7b 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -36,6 +36,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_PRIORITY_VAL,	/* __u32 */
 	CRYPTOCFGA_REPORT_LARVAL,	/* struct crypto_report_larval */
 	CRYPTOCFGA_REPORT_SHASH,	/* struct crypto_report_shash */
+	CRYPTOCFGA_REPORT_AHASH,	/* struct crypto_report_ahash */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -69,3 +70,10 @@ struct crypto_report_shash {
 	unsigned int blocksize;
 	unsigned int digestsize;
 };
+
+struct crypto_report_ahash {
+	char type[CRYPTO_MAX_NAME];
+	char async[CRYPTO_MAX_NAME];
+	unsigned int blocksize;
+	unsigned int digestsize;
+};
-- 
1.7.0.4
