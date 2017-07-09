From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH 1/2] staging: ccree: remove unnecessary cast on kmalloc
Date: Sun, 9 Jul 2017 00:43:37 -0500
Message-ID: <20170709054337.GA9031@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The assignment operator implicitly converts a void pointer to the type of the
pointer it is assigned to.

This issue was detected using Coccinelle and the following semantic patch:

@@
expression * e;
expression arg1, arg2;
type T;
@@

- e=(T*)
+ e=
kmalloc(arg1, arg2);

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index b35871e..18a8694 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -1725,8 +1725,7 @@ int ssi_buffer_mgr_init(struct ssi_drvdata *drvdata)
 	struct buff_mgr_handle *buff_mgr_handle;
 	struct device *dev = &drvdata->plat_dev->dev;
 
-	buff_mgr_handle = (struct buff_mgr_handle *)
-		kmalloc(sizeof(struct buff_mgr_handle), GFP_KERNEL);
+	buff_mgr_handle = kmalloc(sizeof(struct buff_mgr_handle), GFP_KERNEL);
 	if (!buff_mgr_handle)
 		return -ENOMEM;
 
-- 
2.5.0
