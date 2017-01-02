From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 2/3] crypto: picoxcell - Remove platform device ID table
Date: Mon,  2 Jan 2017 14:06:58 -0300
Message-ID: <1483376819-26726-3-git-send-email-javier@osg.samsung.com>
References: <1483376819-26726-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Javier Martinez Canillas <javier@osg.samsung.com>,
 linux-crypto@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1483376819-26726-1-git-send-email-javier@osg.samsung.com>
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

This driver is only used in the picoxcell platform and this is DT-only.

So only a OF device ID table is needed and there's no need to have a
platform device ID table. This patch removes the unneeded table.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/crypto/picoxcell_crypto.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 47576098831f..539effbbfc7a 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1803,12 +1803,6 @@ static int spacc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct platform_device_id spacc_id_table[] = {
-	{ "picochip,spacc-ipsec", },
-	{ "picochip,spacc-l2", },
-	{ }
-};
-
 static struct platform_driver spacc_driver = {
 	.probe		= spacc_probe,
 	.remove		= spacc_remove,
@@ -1819,7 +1813,6 @@ static struct platform_driver spacc_driver = {
 #endif /* CONFIG_PM */
 		.of_match_table	= of_match_ptr(spacc_of_id_table),
 	},
-	.id_table	= spacc_id_table,
 };
 
 module_platform_driver(spacc_driver);
-- 
2.7.4
