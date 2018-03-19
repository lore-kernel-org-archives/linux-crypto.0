From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH v2 7/9] crypto: inside-secure - the context ipad/opad should use the state sz
Date: Mon, 19 Mar 2018 09:21:19 +0100
Message-ID: <20180319082121.32103-8-antoine.tenart@bootlin.com>
References: <20180319082121.32103-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180319082121.32103-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patches uses the state size of the algorithms instead of their
digest size to copy the ipad and opad in the context. This doesn't fix
anything as the state and digest size are the same for many algorithms,
and for all the hmac currently supported by this driver. However
hmac(sha224) use the sha224 hash function which has a different digest
and state size. This commit prepares the addition of such algorithms.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index b9ec82f3dee1..845a5ebf25b4 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -120,11 +120,11 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 				ctx->base.ctxr->data[i] = cpu_to_le32(req->processed / blocksize);
 		}
 	} else if (req->digest == CONTEXT_CONTROL_DIGEST_HMAC) {
-		cdesc->control_data.control0 |= CONTEXT_CONTROL_SIZE(10);
+		cdesc->control_data.control0 |= CONTEXT_CONTROL_SIZE(2 * req->state_sz / sizeof(u32));
 
-		memcpy(ctx->base.ctxr->data, ctx->ipad, digestsize);
-		memcpy(ctx->base.ctxr->data + digestsize / sizeof(u32),
-		       ctx->opad, digestsize);
+		memcpy(ctx->base.ctxr->data, ctx->ipad, req->state_sz);
+		memcpy(ctx->base.ctxr->data + req->state_sz / sizeof(u32),
+		       ctx->opad, req->state_sz);
 	}
 }
 
-- 
2.14.3
