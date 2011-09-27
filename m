From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v4 08/17] crypto: Add userspace report for ahash type
 algorithms
Date: Tue, 27 Sep 2011 07:41:07 +0200
Message-ID: <20110927054107.GK1808@secunet.com>
References: <20110927052050.GB1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:46246 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab1I0FlK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Sep 2011 01:41:10 -0400
Content-Disposition: inline
In-Reply-To: <20110927052050.GB1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/ahash.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index f669822..a3e6ef9 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -21,6 +21,8 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
 
 #include "internal.h"
 
@@ -397,6 +399,24 @@ static unsigned int crypto_ahash_extsize(struct crypto_alg *alg)
 	return sizeof(struct crypto_shash *);
 }
 
+static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_hash rhash;
+
+	snprintf(rhash.type, CRYPTO_MAX_ALG_NAME, "%s", "ahash");
+
+	rhash.blocksize = alg->cra_blocksize;
+	rhash.digestsize = __crypto_hash_alg_common(alg)->digestsize;
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
 static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
@@ -415,6 +435,7 @@ const struct crypto_type crypto_ahash_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_ahash_show,
 #endif
+	.report = crypto_ahash_report,
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
 	.maskset = CRYPTO_ALG_TYPE_AHASH_MASK,
 	.type = CRYPTO_ALG_TYPE_AHASH,
-- 
1.7.0.4
