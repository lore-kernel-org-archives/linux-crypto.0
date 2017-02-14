From: George Cherian <george.cherian@cavium.com>
Subject: [PATCH] drivers: crypto: cpt: cpt_bind_vq_to_grp could return an error code
Date: Tue, 14 Feb 2017 09:23:17 +0000
Message-ID: <1487064197-1659-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        George Cherian <george.cherian@cavium.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        dan.carpenter@oracle.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0077.outbound.protection.outlook.com ([104.47.42.77]:64960
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752418AbdBNJX7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 04:23:59 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

cpt_bind_vq_to_grp() could return an error code. However, it currently
returns a u8. This produce the static checker warning.

drivers/crypto/cavium/cpt/cptpf_mbox.c:70 cpt_bind_vq_to_grp() warn: signedness bug returning '(-22)'

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: George Cherian <george.cherian@cavium.com>
---
 drivers/crypto/cavium/cpt/cptpf_mbox.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptpf_mbox.c b/drivers/crypto/cavium/cpt/cptpf_mbox.c
index 5818b41..20f2c6e 100644
--- a/drivers/crypto/cavium/cpt/cptpf_mbox.c
+++ b/drivers/crypto/cavium/cpt/cptpf_mbox.c
@@ -59,7 +59,7 @@ static void cpt_cfg_vq_priority(struct cpt_device *cpt, int vf, u32 pri)
 	cpt_write_csr64(cpt->reg_base, CPTX_PF_QX_CTL(0, vf), pf_qx_ctl.u);
 }
 
-static u8 cpt_bind_vq_to_grp(struct cpt_device *cpt, u8 q, u8 grp)
+static int cpt_bind_vq_to_grp(struct cpt_device *cpt, u8 q, u8 grp)
 {
 	struct microcode *mcode = cpt->mcode;
 	union cptx_pf_qx_ctl pf_qx_ctl;
@@ -90,7 +90,7 @@ static void cpt_handle_mbox_intr(struct cpt_device *cpt, int vf)
 {
 	struct cpt_vf_info *vfx = &cpt->vfinfo[vf];
 	struct cpt_mbox mbx = {};
-	u8 vftype;
+	int vftype;
 	struct device *dev = &cpt->pdev->dev;
 	/*
 	 * MBOX[0] contains msg
-- 
2.1.4
