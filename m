From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [BUGFIX PATCH] staging: ccree: fix buffer copy
Date: Tue,  6 Jun 2017 11:00:45 +0300
Message-ID: <1496736045-29945-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:41814 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbdFFIBD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2017 04:01:03 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix a bug where the copying of scatterlist buffers incorrectly
ignored bytes to skip in a scatterlist and ended 1 byte short.

This fixes testmgr hmac and hash test failures currently obscured
by hash import/export not being supported.

Fixes: abefd6741d ("staging: ccree: introduce CryptoCell HW driver").

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---

Please roll this patch into 4.12-rc5 if possible.

 drivers/staging/ccree/ssi_buffer_mgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 038e2ff..6471d3d 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -216,7 +216,8 @@ void ssi_buffer_mgr_copy_scatterlist_portion(
 	uint32_t nents, lbytes;
 
 	nents = ssi_buffer_mgr_get_sgl_nents(sg, end, &lbytes, NULL);
-	sg_copy_buffer(sg, nents, (void *)dest, (end - to_skip), 0, (direct == SSI_SG_TO_BUF));
+	sg_copy_buffer(sg, nents, (void *)dest, (end - to_skip + 1), to_skip,
+		       (direct == SSI_SG_TO_BUF));
 }
 
 static inline int ssi_buffer_mgr_render_buff_to_mlli(
-- 
2.1.4
