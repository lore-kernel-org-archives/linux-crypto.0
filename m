From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 01/28] crypto: omap-aes: Fix registration of algorithms
Date: Wed, 1 Jun 2016 11:56:02 +0300
Message-ID: <1464771389-10640-2-git-send-email-t-kristo@ti.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: lokeshvutla@ti.com, Tero Kristo <t-kristo@ti.com>,
 linux-arm-kernel@lists.infradead.org
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
 <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <tony@atomide.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
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

From: Lokesh Vutla <lokeshvutla@ti.com>

Algorithms can be registered only once. So skip registration of
algorithms if already registered (i.e. in case we have two AES cores
in the system.)

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-aes.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index ce174d3..4a0e6a5 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1185,17 +1185,19 @@ static int omap_aes_probe(struct platform_device *pdev)
 	spin_unlock(&list_lock);
 
 	for (i = 0; i < dd->pdata->algs_info_size; i++) {
-		for (j = 0; j < dd->pdata->algs_info[i].size; j++) {
-			algp = &dd->pdata->algs_info[i].algs_list[j];
+		if (!dd->pdata->algs_info[i].registered) {
+			for (j = 0; j < dd->pdata->algs_info[i].size; j++) {
+				algp = &dd->pdata->algs_info[i].algs_list[j];
 
-			pr_debug("reg alg: %s\n", algp->cra_name);
-			INIT_LIST_HEAD(&algp->cra_list);
+				pr_debug("reg alg: %s\n", algp->cra_name);
+				INIT_LIST_HEAD(&algp->cra_list);
 
-			err = crypto_register_alg(algp);
-			if (err)
-				goto err_algs;
+				err = crypto_register_alg(algp);
+				if (err)
+					goto err_algs;
 
-			dd->pdata->algs_info[i].registered++;
+				dd->pdata->algs_info[i].registered++;
+			}
 		}
 	}
 
-- 
1.9.1
