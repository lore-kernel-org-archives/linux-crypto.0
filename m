From: Rui Wang <rui.y.wang@intel.com>
Subject: [PATCH 2/2] crypto: cryptd - Assign statesize properly
Date: Sun, 29 Nov 2015 22:45:34 +0800
Message-ID: <1448808334-8424-3-git-send-email-rui.y.wang@intel.com>
References: <1448808334-8424-1-git-send-email-rui.y.wang@intel.com>
Cc: ying.huang@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, rui.y.wang@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448808334-8424-1-git-send-email-rui.y.wang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

cryptd_create_hash() fails by returning -EINVAL.  It is because after
8996eafdc ("crypto: ahash - ensure statesize is non-zero") all ahash
drivers must have a non-zero statesize.

This patch fixes the problem by properly assigning the statesize.

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
---
 crypto/cryptd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index c81861b..8b40db8 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -637,6 +637,7 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	inst->alg.halg.base.cra_flags = type;
 
 	inst->alg.halg.digestsize = salg->digestsize;
+	inst->alg.halg.statesize = salg->statesize;
 	inst->alg.halg.base.cra_ctxsize = sizeof(struct cryptd_hash_ctx);
 
 	inst->alg.halg.base.cra_init = cryptd_hash_init_tfm;
-- 
1.8.5.2
