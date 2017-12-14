From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 03/10] staging: ccree: add explicit module init/exit func
Date: Thu, 14 Dec 2017 14:02:40 +0000
Message-ID: <1513260170-26346-4-git-send-email-gilad@benyossef.com>
References: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We need to do a module global scope init/exit operation to support
the debugfs interface we are about to introduce in the next patch,
so wean the module of the boiler plate saving macro as it will no
longer be sufficient.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index ad02d92..5427c7f 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -517,7 +517,18 @@ static struct platform_driver cc7x_driver = {
 	.probe = cc7x_probe,
 	.remove = cc7x_remove,
 };
-module_platform_driver(cc7x_driver);
+
+static int __init ccree_init(void)
+{
+	return platform_driver_register(&cc7x_driver);
+}
+module_init(ccree_init);
+
+static void __exit ccree_exit(void)
+{
+	platform_driver_unregister(&cc7x_driver);
+}
+module_exit(ccree_exit);
 
 /* Module description */
 MODULE_DESCRIPTION("ARM TrustZone CryptoCell REE Driver");
-- 
2.7.4
