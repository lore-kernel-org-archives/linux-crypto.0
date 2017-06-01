From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 02/20] staging: ccree: replace bit shift with BIT macro
Date: Thu,  1 Jun 2017 14:02:52 +0300
Message-ID: <1496314993-30229-3-git-send-email-gilad@benyossef.com>
References: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

CC_CTX_SIZE was being defined using a hand rolled bit shift operation.
Replace with use of BIT macro.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index 9bfadb21..18c15fc 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -27,7 +27,7 @@
 #define CC_CTX_SIZE_LOG2 7
 #endif
 #endif
-#define CC_CTX_SIZE (1<<CC_CTX_SIZE_LOG2)
+#define CC_CTX_SIZE BIT(CC_CTX_SIZE_LOG2)
 #define CC_DRV_CTX_SIZE_WORDS (CC_CTX_SIZE >> 2)
 
 #define CC_DRV_DES_IV_SIZE 8
-- 
2.1.4
