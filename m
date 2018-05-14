From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH v2 07/10] crypto: inside-secure - improve error reporting
Date: Mon, 14 May 2018 15:11:01 +0200
Message-ID: <20180514131104.25552-8-antoine.tenart@bootlin.com>
References: <20180514131104.25552-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180514131104.25552-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch improves the error reporting from the Inside Secure driver to
the upper layers and crypto consumers. All errors reported by the engine
aren't fatal, and some may be genuine.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c       | 21 +++++++++++++++++++
 drivers/crypto/inside-secure/safexcel.h       |  2 ++
 .../crypto/inside-secure/safexcel_cipher.c    |  8 ++-----
 drivers/crypto/inside-secure/safexcel_hash.c  |  7 ++-----
 4 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index d4a81be0d7d2..87e6d1a63886 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -537,6 +537,27 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 	       EIP197_HIA_CDR(priv, ring) + EIP197_HIA_xDR_PREP_COUNT);
 }
 
+inline int safexcel_rdesc_check_errors(struct safexcel_crypto_priv *priv,
+				       struct safexcel_result_desc *rdesc)
+{
+	if (likely(!rdesc->result_data.error_code))
+		return 0;
+
+	if (rdesc->result_data.error_code & 0x407f) {
+		/* Fatal error (bits 0-7, 14) */
+		dev_err(priv->dev,
+			"cipher: result: result descriptor error (%d)\n",
+			rdesc->result_data.error_code);
+		return -EIO;
+	} else if (rdesc->result_data.error_code == BIT(9)) {
+		/* Authentication failed */
+		return -EBADMSG;
+	}
+
+	/* All other non-fatal errors */
+	return -EINVAL;
+}
+
 void safexcel_complete(struct safexcel_crypto_priv *priv, int ring)
 {
 	struct safexcel_command_desc *cdesc;
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index eec75dfcdad7..dce02bf92dff 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -610,6 +610,8 @@ struct safexcel_inv_result {
 };
 
 void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring);
+int safexcel_rdesc_check_errors(struct safexcel_crypto_priv *priv,
+				struct safexcel_result_desc *rdesc);
 void safexcel_complete(struct safexcel_crypto_priv *priv, int ring);
 int safexcel_invalidate_cache(struct crypto_async_request *async,
 			      struct safexcel_crypto_priv *priv,
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 1f4787ea2725..2452fce64fb7 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -160,12 +160,8 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 			break;
 		}
 
-		if (rdesc->result_data.error_code) {
-			dev_err(priv->dev,
-				"cipher: result: result descriptor error (%d)\n",
-				rdesc->result_data.error_code);
-			*ret = -EIO;
-		}
+		if (likely(!*ret))
+			*ret = safexcel_rdesc_check_errors(priv, rdesc);
 
 		ndesc++;
 	} while (!rdesc->last_seg);
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 00d2cad0ff1c..6cbd879e8fb5 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -146,11 +146,8 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 		dev_err(priv->dev,
 			"hash: result: could not retrieve the result descriptor\n");
 		*ret = PTR_ERR(rdesc);
-	} else if (rdesc->result_data.error_code) {
-		dev_err(priv->dev,
-			"hash: result: result descriptor error (%d)\n",
-			rdesc->result_data.error_code);
-		*ret = -EINVAL;
+	} else {
+		*ret = safexcel_rdesc_check_errors(priv, rdesc);
 	}
 
 	safexcel_complete(priv, ring);
-- 
2.17.0
