From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] crypto: lrw - Fix an error handling path in 'create()'
Date: Sun,  8 Oct 2017 11:39:49 +0200
Message-ID: <53e4cc621176b8aeeb58e493b133be853c66ef49.1507445539.git.christophe.jaillet@wanadoo.fr>
References: <cover.1507445539.git.christophe.jaillet@wanadoo.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <cover.1507445539.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <cover.1507445539.git.christophe.jaillet@wanadoo.fr>
References: <cover.1507445539.git.christophe.jaillet@wanadoo.fr>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

All error handling paths 'goto err_drop_spawn' except this one.
In order to avoid some resources leak, we should do it as well here.

Fixes: 700cb3f5fe75 ("crypto: lrw - Convert to skcipher")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 crypto/lrw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index a8bfae4451bf..eb681e9fe574 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -610,8 +610,10 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 		ecb_name[len - 1] = 0;
 
 		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-			     "lrw(%s)", ecb_name) >= CRYPTO_MAX_ALG_NAME)
-			return -ENAMETOOLONG;
+			     "lrw(%s)", ecb_name) >= CRYPTO_MAX_ALG_NAME) {
+			err = -ENAMETOOLONG;
+			goto err_drop_spawn;
+		}
 	}
 
 	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
-- 
2.11.0

