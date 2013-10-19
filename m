From: "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] crypto: n2_core: insert '!err' condition in else scope
Date: Sat, 19 Oct 2013 10:09:31 -0300
Message-ID: <1382188171-25595-1-git-send-email-geyslan@gmail.com>
Cc: "Geyslan G. Bem" <geyslan@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-kernel@vger.kernel.org (open list)
To: kernel-br@googlegroups.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch moves the '!err' condition into the above else scope,
what is more obvious and has the secondary goal of avoid false-positives
in statical analyze tools.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/crypto/n2_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index e1f0ab4..afc6983 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1511,9 +1511,9 @@ static int __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 		kfree(p);
 	} else {
 		pr_info("%s alg registered\n", base->cra_name);
+		if (p->hmac_type != AUTH_TYPE_RESERVED)
+			err = __n2_register_one_hmac(p);
 	}
-	if (!err && p->hmac_type != AUTH_TYPE_RESERVED)
-		err = __n2_register_one_hmac(p);
 	return err;
 }
 
-- 
1.8.4
