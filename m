From: srishti sharma <srishtishar@gmail.com>
Subject: [PATCH] Staging: ccree: cc_crypto_ctx.h: Fixed a comment coding style
 issue.
Date: Wed, 31 May 2017 17:36:08 +0530
Message-ID: <1496232368-3591-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: srishti sharma <srishtishar@gmail.com>,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
To: gregkh@linuxfoundation.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
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

Fixed a comment coding style issue that generated a warning stating block comments use * on subsequent lines.

Signed-off-by: srishti sharma <srishtishar@gmail.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index ac39d34..c5784bc 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -279,9 +279,9 @@ struct drv_ctx_aead {
/* Get the address of a @member within a given @ctx address
-   @ctx: The context address
-   @type: Type of context structure
-   @member: Associated context field */
+ * @ctx: The context address
+ * @type: Type of context structure
+ * @member: Associated context field */
 #define GET_CTX_FIELD_ADDR(ctx, type, member) (ctx + offsetof(type, member))
 #endif /* _CC_CRYPTO_CTX_H_ */
2.7.4
