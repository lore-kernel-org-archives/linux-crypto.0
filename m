From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 03/10] staging: ccree: simplify AEAD using local var
Date: Thu,  9 Nov 2017 09:16:11 +0000
Message-ID: <1510218980-3549-4-git-send-email-gilad@benyossef.com>
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

Make the code more readable by using a local variable
for commonly use expression in the AEAD part of the driver.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 0b5b230..a8e1371 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -251,13 +251,11 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 		}
 	} else { /*ENCRYPT*/
 		if (unlikely(areq_ctx->is_icv_fragmented)) {
+			u32 skip = areq->cryptlen + areq_ctx->dst_offset;
+
 			cc_copy_sg_portion(dev, areq_ctx->mac_buf,
-					   areq_ctx->dst_sgl,
-					   (areq->cryptlen +
-					    areq_ctx->dst_offset),
-					   (areq->cryptlen +
-					    areq_ctx->dst_offset +
-					    ctx->authsize),
+					   areq_ctx->dst_sgl, skip,
+					   (skip + ctx->authsize),
 					   SSI_SG_FROM_BUF);
 		}
 
-- 
2.7.4
