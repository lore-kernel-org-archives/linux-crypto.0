From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 01/10] crypto: inside-secure - use the error handler for invalidation requests
Date: Tue, 29 May 2018 14:13:43 +0200
Message-ID: <20180529121352.19490-2-antoine.tenart@bootlin.com>
References: <20180529121352.19490-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529121352.19490-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch reworks the way invalidation request handlers handle the
result descriptor errors, to use the common error handling function.
This improves the drivers in terms of readability and maintainability.

Suggested-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 7 ++-----
 drivers/crypto/inside-secure/safexcel_hash.c   | 7 ++-----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 6bb60fda2043..5bc0afc8e63a 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -491,11 +491,8 @@ static int safexcel_handle_inv_result(struct safexcel_crypto_priv *priv,
 			break;
 		}
 
-		if (rdesc->result_data.error_code) {
-			dev_err(priv->dev, "cipher: invalidate: result descriptor error (%d)\n",
-				rdesc->result_data.error_code);
-			*ret = -EIO;
-		}
+		if (likely(!*ret))
+			*ret = safexcel_rdesc_check_errors(priv, rdesc);
 
 		ndesc++;
 	} while (!rdesc->last_seg);
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index d138d6b8fec5..8eef95f82e11 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -369,11 +369,8 @@ static int safexcel_handle_inv_result(struct safexcel_crypto_priv *priv,
 		dev_err(priv->dev,
 			"hash: invalidate: could not retrieve the result descriptor\n");
 		*ret = PTR_ERR(rdesc);
-	} else if (rdesc->result_data.error_code) {
-		dev_err(priv->dev,
-			"hash: invalidate: result descriptor error (%d)\n",
-			rdesc->result_data.error_code);
-		*ret = -EINVAL;
+	} else {
+		*ret = safexcel_rdesc_check_errors(priv, rdesc);
 	}
 
 	safexcel_complete(priv, ring);
-- 
2.17.0
