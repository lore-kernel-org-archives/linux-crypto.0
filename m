From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] crypto: cavium: cpt: Replace mdelay with msleep in cpt_device_init
Date: Sun, 18 Mar 2018 22:50:38 +0800
Message-ID: <1521384638-23251-1-git-send-email-baijiaju1990@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
To: george.cherian@cavium.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

cpt_device_init() is never called in atomic context.

The call chain ending up at cpt_device_init() is:
[1] cpt_device_init() <- cpt_probe()
cpt_probe() is only set as ".probe" in pci_driver structure 
"cpt_pci_driver".

Despite never getting called from atomic context, cpt_device_init() calls
mdelay(100), i.e. busy wait for 100ms.
That is not necessary and can be replaced with msleep to 
avoid busy waiting.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/crypto/cavium/cpt/cptpf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 34a6d8b..06ad85a 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -436,7 +436,7 @@ static int cpt_device_init(struct cpt_device *cpt)
 
 	/* Reset the PF when probed first */
 	cpt_reset(cpt);
-	mdelay(100);
+	msleep(100);
 
 	/*Check BIST status*/
 	bist = (u64)cpt_check_bist_status(cpt);
-- 
1.9.1
