From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 14/26] staging: ccree: handle end of sg list gracefully
Date: Mon,  1 Jan 2018 12:06:41 +0000
Message-ID: <1514808421-21993-15-git-send-email-gilad@benyossef.com>
References: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

If we are asked for number of entries of an offset bigger than the
sg list we should not crash.

Cc: stable@vger.kernel.org
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 33b9709..cb3e235 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -94,7 +94,7 @@ static unsigned int cc_get_sgl_nents(struct device *dev,
 {
 	unsigned int nents = 0;
 
-	while (nbytes) {
+	while (nbytes && sg_list) {
 		if (sg_list->length) {
 			nents++;
 			/* get the number of bytes in the last entry */
-- 
2.7.4
