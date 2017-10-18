From: sunil.m@techveda.org
Subject: [PATCH v2] staging: ccree: fix boolreturn.cocci warning
Date: Wed, 18 Oct 2017 07:42:53 +0530
Message-ID: <1508292773-15853-1-git-send-email-sunil.m@techveda.org>
References: <20171016211906.GN16106@eros>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 karthik@techveda.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Suniel Mahesh <sunil.m@techveda.org>
To: gilad@benyossef.com,
	gregkh@linuxfoundation.org,
	me@tobin.cc
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20171016211906.GN16106@eros>
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

From: Suniel Mahesh <sunil.m@techveda.org>

Return "false" instead of 0.

This fixes the following coccinelle warning:
WARNING: return of 0/1 in function 'ssi_is_hw_key' with return type bool.

Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
---
Changes for v2:
- Changed the commit log to give a more accurate description
  of the changeset as suggested by Toby C.Harding.
---
Note:
- Patch was built(ARCH=arm) on latest linux-next.
- No build issues reported, however it was not
  tested on real hardware.
- Please discard this changeset, if this is not
  helping the code look better.
---
 drivers/staging/ccree/ssi_cipher.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
index c9a83df..f499962 100644
--- a/drivers/staging/ccree/ssi_cipher.h
+++ b/drivers/staging/ccree/ssi_cipher.h
@@ -75,7 +75,7 @@ struct arm_hw_key_info {
 
 static inline bool ssi_is_hw_key(struct crypto_tfm *tfm)
 {
-	return 0;
+	return false;
 }
 
 #endif /* CRYPTO_TFM_REQ_HW_KEY */
-- 
1.9.1
