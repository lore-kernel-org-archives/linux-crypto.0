From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 05/12] crypto: inside-secure - fix typo s/allways/always/ in a define
Date: Thu, 15 Mar 2018 16:38:44 +0100
Message-ID: <20180315153851.9958-6-antoine.tenart@bootlin.com>
References: <20180315153851.9958-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180315153851.9958-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Small cosmetic patch fixing one typo in the
EIP197_HIA_DSE_CFG_ALLWAYS_BUFFERABLE macro, it should be _ALWAYS_.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c | 2 +-
 drivers/crypto/inside-secure/safexcel.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 384b4ceb37f0..5fe85b9dad64 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -332,7 +332,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	val = EIP197_HIA_DSE_CFG_DIS_DEBUG;
 	val |= EIP197_HIA_DxE_CFG_MIN_DATA_SIZE(7) | EIP197_HIA_DxE_CFG_MAX_DATA_SIZE(8);
 	val |= EIP197_HIA_DxE_CFG_DATA_CACHE_CTRL(WR_CACHE_3BITS);
-	val |= EIP197_HIA_DSE_CFG_ALLWAYS_BUFFERABLE;
+	val |= EIP197_HIA_DSE_CFG_ALWAYS_BUFFERABLE;
 	/* FIXME: instability issues can occur for EIP97 but disabling it impact
 	 * performances.
 	 */
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index d8dff65fc311..2b7bed3cfb75 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -179,7 +179,7 @@
 #define EIP197_HIA_DxE_CFG_MIN_DATA_SIZE(n)	((n) << 0)
 #define EIP197_HIA_DxE_CFG_DATA_CACHE_CTRL(n)	(((n) & 0x7) << 4)
 #define EIP197_HIA_DxE_CFG_MAX_DATA_SIZE(n)	((n) << 8)
-#define EIP197_HIA_DSE_CFG_ALLWAYS_BUFFERABLE	GENMASK(15, 14)
+#define EIP197_HIA_DSE_CFG_ALWAYS_BUFFERABLE	GENMASK(15, 14)
 #define EIP197_HIA_DxE_CFG_MIN_CTRL_SIZE(n)	((n) << 16)
 #define EIP197_HIA_DxE_CFG_CTRL_CACHE_CTRL(n)	(((n) & 0x7) << 20)
 #define EIP197_HIA_DxE_CFG_MAX_CTRL_SIZE(n)	((n) << 24)
-- 
2.14.3
