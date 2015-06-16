From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v5 03/14] crypto: mv_cesa: explicitly define kirkwood and dove compatible strings
Date: Tue, 16 Jun 2015 11:58:57 +0200
Message-ID: <1434448748-10828-4-git-send-email-boris.brezillon@free-electrons.com>
References: <1434448748-10828-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	"Imre Kaloz" <kaloz@openwrt.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:56502 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932270AbbFPJ72 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 05:59:28 -0400
In-Reply-To: <1434448748-10828-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We are about to add a new driver to support new features like using the
TDMA engine to offload the CPU.
Orion, Dove and Kirkwood platforms are already using the mv_cesa driver,
but Orion SoCs do not embed the TDMA engine, which means we will have to
differentiate them if we want to get TDMA support on Dove and Kirkwood.
In the other hand, the migration from the old driver to the new one is not
something all people are willing to do without first auditing the new
driver.
Hence we have to support the new compatible in the mv_cesa driver so that
new platforms with updated DTs can still attach their crypto engine device
to this driver.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 Documentation/devicetree/bindings/crypto/mv_cesa.txt | 5 ++++-
 drivers/crypto/mv_cesa.c                             | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/mv_cesa.txt b/Documentation/devicetree/bindings/crypto/mv_cesa.txt
index 13b8fc5..c0c35f0 100644
--- a/Documentation/devicetree/bindings/crypto/mv_cesa.txt
+++ b/Documentation/devicetree/bindings/crypto/mv_cesa.txt
@@ -1,7 +1,10 @@
 Marvell Cryptographic Engines And Security Accelerator
 
 Required properties:
-- compatible : should be "marvell,orion-crypto"
+- compatible: should be one of the following string
+	      "marvell,orion-crypto"
+	      "marvell,kirkwood-crypto"
+	      "marvell,dove-crypto"
 - reg: base physical address of the engine and length of memory mapped
        region. Can also contain an entry for the SRAM attached to the CESA,
        but this representation is deprecated and marvell,crypto-srams should
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index a4c8637..fcab963 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1034,7 +1034,7 @@ static int mv_cesa_get_sram(struct platform_device *pdev,
 			     &sram_size);
 
 	cp->sram_size = sram_size;
-	cp->sram_pool = of_get_named_gen_pool(&pdev->dev.of_node,
+	cp->sram_pool = of_get_named_gen_pool(pdev->dev.of_node,
 					      "marvell,crypto-srams", 0);
 	if (cp->sram_pool) {
 		cp->sram = gen_pool_dma_alloc(cp->sram_pool, sram_size,
@@ -1197,6 +1197,8 @@ static int mv_remove(struct platform_device *pdev)
 
 static const struct of_device_id mv_cesa_of_match_table[] = {
 	{ .compatible = "marvell,orion-crypto", },
+	{ .compatible = "marvell,kirkwood-crypto", },
+	{ .compatible = "marvell,dove-crypto", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, mv_cesa_of_match_table);
-- 
1.9.1
