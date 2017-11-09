From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 04/10] staging: ccree: simplify buf mgr using local vars
Date: Thu,  9 Nov 2017 09:16:12 +0000
Message-ID: <1510218980-3549-5-git-send-email-gilad@benyossef.com>
References: <1510218980-3549-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510218980-3549-1-git-send-email-gilad@benyossef.com>
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

Make the code more readable by using a local variables
for commonly use expressions in the buffer manager part
of the driver.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 2d971f2..b3ca249 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -225,16 +225,18 @@ static int cc_generate_mlli(
 	mlli_p = (u32 *)mlli_params->mlli_virt_addr;
 	/* go over all SG's and link it to one MLLI table */
 	for (i = 0; i < sg_data->num_of_buffers; i++) {
+		union buffer_array_entry *entry = &sg_data->entry[i];
+		u32 tot_len = sg_data->total_data_len[i];
+		u32 offset = sg_data->offset[i];
+
 		if (sg_data->type[i] == DMA_SGL_TYPE)
-			rc = cc_render_sg_to_mlli(dev, sg_data->entry[i].sgl,
-						  sg_data->total_data_len[i],
-						  sg_data->offset[i],
-						  &total_nents, &mlli_p);
+			rc = cc_render_sg_to_mlli(dev, entry->sgl, tot_len,
+						  offset, &total_nents,
+						  &mlli_p);
 		else /*DMA_BUFF_TYPE*/
-			rc = cc_render_buff_to_mlli(dev,
-						    sg_data->entry[i].buffer_dma,
-						    sg_data->total_data_len[i],
-						    &total_nents, &mlli_p);
+			rc = cc_render_buff_to_mlli(dev, entry->buffer_dma,
+						    tot_len, &total_nents,
+						    &mlli_p);
 		if (rc != 0)
 			return rc;
 
-- 
2.7.4
