From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 06/10] crypto: inside-secure - fix the hash then encrypt/decrypt types
Date: Wed,  2 May 2018 11:57:21 +0200
Message-ID: <20180502095725.31935-7-antoine.tenart@bootlin.com>
References: <20180502095725.31935-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502095725.31935-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This commit fixes the CONTEXT_CONTROL_TYPE_HASH_ENCRYPT_OUT and
CONTEXT_CONTROL_TYPE_HASH_DECRYPT_OUT types by assigning the right
value, and by renaming CONTEXT_CONTROL_TYPE_HASH_DECRYPT_OUT to
CONTEXT_CONTROL_TYPE_HASH_DECRYPT_IN.

This is not submitted as a fix for older kernel versions as these two
defines weren't used back then.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index b470a849721f..ac2fae340299 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -286,8 +286,8 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_TYPE_CRYPTO_IN		0x5
 #define CONTEXT_CONTROL_TYPE_ENCRYPT_HASH_OUT	0x6
 #define CONTEXT_CONTROL_TYPE_DECRYPT_HASH_IN	0x7
-#define CONTEXT_CONTROL_TYPE_HASH_ENCRYPT_OUT	0x14
-#define CONTEXT_CONTROL_TYPE_HASH_DECRYPT_OUT	0x15
+#define CONTEXT_CONTROL_TYPE_HASH_ENCRYPT_OUT	0xe
+#define CONTEXT_CONTROL_TYPE_HASH_DECRYPT_IN	0xf
 #define CONTEXT_CONTROL_RESTART_HASH		BIT(4)
 #define CONTEXT_CONTROL_NO_FINISH_HASH		BIT(5)
 #define CONTEXT_CONTROL_SIZE(n)			((n) << 8)
-- 
2.17.0
