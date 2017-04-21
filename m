From: George Cherian <george.cherian@cavium.com>
Subject: [PATCH 1/3] crypto: cavium: Downgrade the annoying misc interrupt print from dev_err to dev_dbg
Date: Fri, 21 Apr 2017 11:16:04 +0000
Message-ID: <1492773366-17899-2-git-send-email-george.cherian@cavium.com>
References: <1492773366-17899-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: george.cherian@cavium.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1492773366-17899-1-git-send-email-george.cherian@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mailbox interrupt is common and it is not an error interrupt.
So downgrade the print from dev_err to  dev_dbg.

Signed-off-by: George Cherian <george.cherian@cavium.com>
---
 drivers/crypto/cavium/cpt/cptvf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_main.c b/drivers/crypto/cavium/cpt/cptvf_main.c
index 6ffc740..5c796ed 100644
--- a/drivers/crypto/cavium/cpt/cptvf_main.c
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -525,7 +525,7 @@ static irqreturn_t cptvf_misc_intr_handler(int irq, void *cptvf_irq)
 	intr = cptvf_read_vf_misc_intr_status(cptvf);
 	/*Check for MISC interrupt types*/
 	if (likely(intr & CPT_VF_INTR_MBOX_MASK)) {
-		dev_err(&pdev->dev, "Mailbox interrupt 0x%llx on CPT VF %d\n",
+		dev_dbg(&pdev->dev, "Mailbox interrupt 0x%llx on CPT VF %d\n",
 			intr, cptvf->vfid);
 		cptvf_handle_mbox_intr(cptvf);
 		cptvf_clear_mbox_intr(cptvf);
-- 
2.1.4
