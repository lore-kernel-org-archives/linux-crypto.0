From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] crypto: dh - fix memory leak
Date: Tue, 10 Jul 2018 09:22:52 -0500
Message-ID: <20180710142252.GA19600@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In case memory resources for *base* were allocated, release them
before return.

Addresses-Coverity-ID: 1471702 ("Resource leak")
Fixes: e3fe0ae12962 ("crypto: dh - add public key verification test")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 crypto/dh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index 8f79269..09a44de 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -174,7 +174,7 @@ static int dh_compute_value(struct kpp_request *req)
 		}
 		ret = dh_is_pubkey_valid(ctx, base);
 		if (ret)
-			goto err_free_val;
+			goto err_free_base;
 	} else {
 		base = ctx->g;
 	}
-- 
2.7.4
