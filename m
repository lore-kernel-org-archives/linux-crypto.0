From: srishti sharma <srishtishar@gmail.com>
Subject: [PATCH 2/4] Staging: ccree: cc_crypto_ctx.h: Fixed trailing */ issue
 in a comment block
Date: Sun,  4 Jun 2017 05:02:39 +0530
Message-ID: <6b7fc631a83098730a03c30fc6bfc20b681c0d26.1496531673.git.srishtishar@gmail.com>
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

Fixed trailing */ style issue in a block comment.

Signed-off-by: srishti sharma <srishtishar@gmail.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index 6ee51b8..27a5914 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -218,8 +218,10 @@ struct drv_ctx_hash {
			CC_DIGEST_SIZE_MAX];
 };

-/* !!!! drv_ctx_hmac should have the same structure as drv_ctx_hash except
- * k0, k0_size fields */
+/*
+ * !!!! drv_ctx_hmac should have the same structure as drv_ctx_hash except
+ * k0, k0_size fields
+ */
 struct drv_ctx_hmac {
	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_HMAC */
	enum drv_hash_mode mode;
@@ -285,4 +287,3 @@ struct drv_ctx_aead {
 #define GET_CTX_FIELD_ADDR(ctx, type, member) (ctx + offsetof(type, member))

 #endif /* _CC_CRYPTO_CTX_H_ */
-
--
2.7.4
