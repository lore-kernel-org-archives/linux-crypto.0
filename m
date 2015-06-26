From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] crypto-qat: Deletion of unnecessary checks before two function
 calls
Date: Fri, 26 Jun 2015 20:45:28 +0200
Message-ID: <558D9DC8.2000603@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tadeusz Struk <tadeusz.struk@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 26 Jun 2015 20:30:11 +0200

The functions kfree() and release_firmware() test whether their argument
is NULL and then return immediately.
Thus the test around the calls is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/qat/qat_common/adf_accel_engine.c | 5 +----
 drivers/crypto/qat/qat_common/adf_transport.c    | 2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_engine.c b/drivers/crypto/qat/qat_common/adf_accel_engine.c
index 7f8b66c..fdda8e7 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/qat/qat_common/adf_accel_engine.c
@@ -88,10 +88,7 @@ void adf_ae_fw_release(struct adf_accel_dev *accel_dev)
 
 	qat_uclo_del_uof_obj(loader_data->fw_loader);
 	qat_hal_deinit(loader_data->fw_loader);
-
-	if (loader_data->uof_fw)
-		release_firmware(loader_data->uof_fw);
-
+	release_firmware(loader_data->uof_fw);
 	loader_data->uof_fw = NULL;
 	loader_data->fw_loader = NULL;
 }
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index ccec3274..db2926b 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -449,7 +449,7 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 err:
 	for (i = 0; i < ADF_ETR_MAX_RINGS_PER_BANK; i++) {
 		ring = &bank->rings[i];
-		if (hw_data->tx_rings_mask & (1 << i) && ring->inflights)
+		if (hw_data->tx_rings_mask & (1 << i))
 			kfree(ring->inflights);
 	}
 	return -ENOMEM;
-- 
2.4.4

