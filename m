From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] staging: ccree: fix spelling mistake: "chanined" -> "chained"
Date: Sun,  4 Jun 2017 00:31:42 +0100
Message-ID: <20170603233142.18223-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37598 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbdFCXbo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Jun 2017 19:31:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in SSI_LOG_ERR message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 04515e70d2d3..379eecf85ba1 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -156,7 +156,7 @@ static unsigned int ssi_buffer_mgr_get_sgl_nents(
 	unsigned int nents = 0;
 	while (nbytes != 0) {
 		if (sg_is_chain(sg_list)) {
-			SSI_LOG_ERR("Unexpected chanined entry "
+			SSI_LOG_ERR("Unexpected chained entry "
 				   "in sg (entry =0x%X) \n", nents);
 			BUG();
 		}
-- 
2.11.0
