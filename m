From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Subject: drivers/crypto/mv_cesa.c: use resource_size()
Date: Mon, 23 Nov 2009 12:48:36 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901EE5BE5@mi8nycmail19.Mi8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: <sebastian@breakpoint.cc>
To: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753818AbZKWRsd@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use resource_size() for ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

---

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index b21ef63..b8770e9 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -495,7 +495,7 @@ static int mv_probe(struct platform_device *pdev)
 
 	spin_lock_init(&cp->lock);
 	crypto_init_queue(&cp->queue, 50);
-	cp->reg = ioremap(res->start, res->end - res->start + 1);
+	cp->reg = ioremap(res->start, resource_size(res));
 	if (!cp->reg) {
 		ret = -ENOMEM;
 		goto err;
@@ -506,7 +506,7 @@ static int mv_probe(struct platform_device *pdev)
 		ret = -ENXIO;
 		goto err_unmap_reg;
 	}
-	cp->sram_size = res->end - res->start + 1;
+	cp->sram_size = resource_size(res);
 	cp->max_req_size = cp->sram_size - SRAM_CFG_SPACE;
 	cp->sram = ioremap(res->start, cp->sram_size);
 	if (!cp->sram) { 
