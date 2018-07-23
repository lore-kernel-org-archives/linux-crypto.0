From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] crypto: qat: adf_aer: Replace GFP_ATOMIC with GFP_KERNEL in adf_dev_aer_schedule_reset()
Date: Mon, 23 Jul 2018 16:27:44 +0800
Message-ID: <20180723082744.25409-1-baijiaju1990@gmail.com>
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
To: giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

adf_dev_aer_schedule_reset() is never called in atomic context, as it
calls wait_for_completion_timeout().

adf_dev_aer_schedule_reset() calls kzalloc() with GFP_ATOMIC,
which is not necessary.
GFP_ATOMIC can be replaced with GFP_KERNEL.

This is found by a static analysis tool named DCNS written by myself.
I also manually check the kernel code before reporting it.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/crypto/qat/qat_common/adf_aer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index da8a2d3b5e9a..9225d060e18f 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -163,7 +163,7 @@ static int adf_dev_aer_schedule_reset(struct adf_accel_dev *accel_dev,
 		return 0;
 
 	set_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
-	reset_data = kzalloc(sizeof(*reset_data), GFP_ATOMIC);
+	reset_data = kzalloc(sizeof(*reset_data), GFP_KERNEL);
 	if (!reset_data)
 		return -ENOMEM;
 	reset_data->accel_dev = accel_dev;
-- 
2.17.0
