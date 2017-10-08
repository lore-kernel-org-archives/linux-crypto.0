From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] crypto: lrw - Check for incorrect cipher name
Date: Sun,  8 Oct 2017 11:39:50 +0200
Message-ID: <51442d29c0459a1ed80ee693709801473aecef5c.1507445539.git.christophe.jaillet@wanadoo.fr>
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

If the cipher name does not start with 'ecb(' we should bail out, as done
in the 'create()' function in 'crypto/xts.c'.

Fixes: 700cb3f5fe75 ("crypto: lrw - Convert to skcipher")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is 100% speculative.
It is based on comparison with the 'create()' function from 'crypto/xts.c'
Code looks the same, but this aditionnal test is in xts.c and not in
lrw.c.
The 2 should maybe be consistent?
---
 crypto/lrw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index eb681e9fe574..92df312b8c6e 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -614,7 +614,8 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 			err = -ENAMETOOLONG;
 			goto err_drop_spawn;
 		}
-	}
+	} else
+		goto err_drop_spawn;
 
 	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
-- 
2.11.0

