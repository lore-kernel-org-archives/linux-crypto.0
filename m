From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0130/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:42:56 +0800
Message-ID: <20160802104256.22416-1-baolex.ni@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: peter@korsgaard.com, linux-kernel@vger.kernel.org, baolex.ni@intel.com,
 linux-crypto@vger.kernel.org, chuansheng.liu@intel.com, lee.jones@linaro.org,
 linux-arm-kernel@lists.infradead.org
To: jamie@jamieiles.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 hpa@zytor.com, x86@kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/crypto/picoxcell_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 3b1c7ec..e535d10 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1224,7 +1224,7 @@ static ssize_t spacc_stat_irq_thresh_store(struct device *dev,
 
 	return len;
 }
-static DEVICE_ATTR(stat_irq_thresh, 0644, spacc_stat_irq_thresh_show,
+static DEVICE_ATTR(stat_irq_thresh, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH, spacc_stat_irq_thresh_show,
 		   spacc_stat_irq_thresh_store);
 
 static struct spacc_alg ipsec_engine_algs[] = {
-- 
2.9.2
