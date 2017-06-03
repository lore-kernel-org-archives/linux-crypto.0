From: srishti sharma <srishtishar@gmail.com>
Subject: [PATCH 1/4] Staging: ccree: cc_crypto_ctx.h: Added * on subsequent
 lines of a comment block.
Date: Sun,  4 Jun 2017 05:02:08 +0530
Message-ID: <e1974f1fece258f422e8f90ca820170a2b982933.1496531673.git.srishtishar@gmail.com>
References: <cover.1496531673.git.srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, srishti sharma <srishtishar@gmail.com>,
 linux-crypto@vger.kernel.org
To: gregkh@linuxfoundation.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <cover.1496531673.git.srishtishar@gmail.com>
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

Added * on subsequent lines of a comment block.

Signed-off-by: srishti sharma <srishtishar@gmail.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index ac39d34..6ee51b8 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -219,7 +219,7 @@ struct drv_ctx_hash {
 };

 /* !!!! drv_ctx_hmac should have the same structure as drv_ctx_hash except
-   k0, k0_size fields */
+ * k0, k0_size fields */
 struct drv_ctx_hmac {
	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_HMAC */
	enum drv_hash_mode mode;
--
2.7.4
