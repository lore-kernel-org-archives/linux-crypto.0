From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v6 03/14] crypto: mv_cesa: explicitly define kirkwood and dove compatible strings
Date: Wed, 17 Jun 2015 09:45:31 +0200
Message-ID: <1434527142-3609-4-git-send-email-boris.brezillon@free-electrons.com>
References: <1434527142-3609-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
	Tawfik Bayouk <tawfik-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Lior Amsalem <alior-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Nadav Haklai <nadavh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Eran Ben-Avi <benavi-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
	"Imre Kaloz" <kaloz-p3rKhJxN3npAfugRpC6u6w@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434527142-3609-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

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

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
