From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH v2] crypto/mcryptd: Check mcryptd algorithm compatibility
Date: Mon,  5 Dec 2016 11:46:31 -0800
Message-ID: <6825659d1f6a96d4ab2327aa0dcf357f6252e915.1480967128.git.tim.c.chen@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, megha.dey@linux.intel.com,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Milan Broz <mbroz@redhat.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:21635 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751373AbcLETqT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Dec 2016 14:46:19 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Algorithms not compatible with mcryptd could be spawned by mcryptd
with a direct crypto_alloc_tfm invocation using a "mcryptd(alg)" name
construct.  This causes mcryptd to crash the kernel if an arbitrary
"alg" is incompatible and not intended to be used with mcryptd.  It is
an issue if AF_ALG tries to spawn mcryptd(alg) to expose it externally.
But such algorithms must be used internally and not be exposed.

We added a check to enforce that only internal algorithms are allowed
with mcryptd at the time mcryptd is spawning an algorithm.

Link: http://marc.info/?l=linux-crypto-vger&m=148063683310477&w=2
Cc: stable@vger.kernel.org
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/mcryptd.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
index 94ee44a..c207458 100644
--- a/crypto/mcryptd.c
+++ b/crypto/mcryptd.c
@@ -254,18 +254,22 @@ static void *mcryptd_alloc_instance(struct crypto_alg *alg, unsigned int head,
 	goto out;
 }
 
-static inline void mcryptd_check_internal(struct rtattr **tb, u32 *type,
+static inline bool mcryptd_check_internal(struct rtattr **tb, u32 *type,
 					  u32 *mask)
 {
 	struct crypto_attr_type *algt;
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
-		return;
-	if ((algt->type & CRYPTO_ALG_INTERNAL))
-		*type |= CRYPTO_ALG_INTERNAL;
-	if ((algt->mask & CRYPTO_ALG_INTERNAL))
-		*mask |= CRYPTO_ALG_INTERNAL;
+		return false;
+
+	*type |= algt->type & CRYPTO_ALG_INTERNAL;
+	*mask |= algt->mask & CRYPTO_ALG_INTERNAL;
+
+	if (*type & *mask & CRYPTO_ALG_INTERNAL)
+		return true;
+	else
+		return false;
 }
 
 static int mcryptd_hash_init_tfm(struct crypto_tfm *tfm)
@@ -492,7 +496,8 @@ static int mcryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	u32 mask = 0;
 	int err;
 
-	mcryptd_check_internal(tb, &type, &mask);
+	if (!mcryptd_check_internal(tb, &type, &mask))
+		return -EINVAL;
 
 	halg = ahash_attr_alg(tb[1], type, mask);
 	if (IS_ERR(halg))
-- 
2.5.5
