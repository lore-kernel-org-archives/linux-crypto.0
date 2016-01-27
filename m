From: Rui Wang <rui.y.wang@intel.com>
Subject: [PATCH v2 2/4] crypto: mcryptd - Fix load failure
Date: Wed, 27 Jan 2016 17:08:36 +0800
Message-ID: <1453885718-24599-3-git-send-email-rui.y.wang@intel.com>
References: <1453885718-24599-1-git-send-email-rui.y.wang@intel.com>
Cc: tim.c.chen@linux.intel.com, rui.y.wang@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453885718-24599-1-git-send-email-rui.y.wang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

mcryptd_create_hash() fails by returning -EINVAL, causing any
driver using mcryptd to fail to load. It is because it needs
to set its statesize properly.

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
---
 crypto/mcryptd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
index f78d4fc..c4eb9da 100644
--- a/crypto/mcryptd.c
+++ b/crypto/mcryptd.c
@@ -522,6 +522,7 @@ static int mcryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	inst->alg.halg.base.cra_flags = type;
 
 	inst->alg.halg.digestsize = salg->digestsize;
+	inst->alg.halg.statesize = salg->statesize;
 	inst->alg.halg.base.cra_ctxsize = sizeof(struct mcryptd_hash_ctx);
 
 	inst->alg.halg.base.cra_init = mcryptd_hash_init_tfm;
-- 
1.8.3.1
