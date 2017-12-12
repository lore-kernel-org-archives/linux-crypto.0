From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 2/2] crypto: seqiv - Remove unused alg/spawn variable
Date: Tue, 12 Dec 2017 19:30:14 +0000
Message-ID: <1513107014-11975-2-git-send-email-clabbe@baylibre.com>
References: <1513107014-11975-1-git-send-email-clabbe@baylibre.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513107014-11975-1-git-send-email-clabbe@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch remove two unused variable and some dead "code" using it.

Fixes: 92932d03c2b3 ("crypto: seqiv - Remove AEAD compatibility code")

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/seqiv.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 570b7d1aa0ca..39dbf2f7e5f5 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -144,8 +144,6 @@ static int seqiv_aead_decrypt(struct aead_request *req)
 static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct aead_instance *inst;
-	struct crypto_aead_spawn *spawn;
-	struct aead_alg *alg;
 	int err;
 
 	inst = aead_geniv_alloc(tmpl, tb, 0, 0);
@@ -153,9 +151,6 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
 
-	spawn = aead_instance_ctx(inst);
-	alg = crypto_spawn_aead_alg(spawn);
-
 	err = -EINVAL;
 	if (inst->alg.ivsize != sizeof(u64))
 		goto free_inst;
-- 
2.13.6
