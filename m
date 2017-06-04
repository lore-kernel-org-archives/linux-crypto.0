From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 01/18] staging: ccree: replace bit shift with BIT macro
Date: Sun,  4 Jun 2017 11:02:22 +0300
Message-ID: <1496563362-7954-2-git-send-email-gilad@benyossef.com>
References: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

CC_CTX_SIZE was being defined using a hand rolled bit shift operation.
Replace with use of BIT macro.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index 1fc68de..20f3f9f 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -27,7 +27,7 @@
 #define CC_CTX_SIZE_LOG2 7
 #endif
 #endif
-#define CC_CTX_SIZE (1 << CC_CTX_SIZE_LOG2)
+#define CC_CTX_SIZE BIT(CC_CTX_SIZE_LOG2)
 #define CC_DRV_CTX_SIZE_WORDS (CC_CTX_SIZE >> 2)
 
 #define CC_DRV_DES_IV_SIZE 8
-- 
2.1.4
