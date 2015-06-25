From: Simon Guinot <simon.guinot-jKBdWWKqtFpg9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] crypto: mv_cesa - fix up for of_get_named_gen_pool() rename
Date: Thu, 25 Jun 2015 10:37:50 +0200
Message-ID: <1435221470-5382-1-git-send-email-simon.guinot@sequanux.org>
References: <CABxcv=m4juAMHaMYSB+8O8cEX+YZCJ0cArS2wN-YGpTBgWe-CA@mail.gmail.com>
Cc: Lior Amsalem <alior-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>, Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>,
	Nadav Haklai <nadavh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>,
	Tawfik Bayouk <tawfik-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Eran Ben-Avi <benavi-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
	linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	Imre Kaloz <kaloz@o
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABxcv=m4juAMHaMYSB+8O8cEX+YZCJ0cArS2wN-YGpTBgWe-CA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This patch fixes the following build error:

drivers/crypto/mv_cesa.c: In function 'mv_cesa_get_sram':
drivers/crypto/mv_cesa.c:1037: error: implicit declaration of function 'of_get_named_gen_pool'
drivers/crypto/mv_cesa.c:1038: warning: assignment makes pointer from integer without a cast
scripts/Makefile.build:258: recipe for target 'drivers/crypto/mv_cesa.o' failed

Signed-off-by: Simon Guinot <simon.guinot-jKBdWWKqtFpg9hUCZPvPmw@public.gmane.org>
---
 drivers/crypto/mv_cesa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 5bcd575fa96f..e6b658faef63 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1034,8 +1034,8 @@ static int mv_cesa_get_sram(struct platform_device *pdev,
 			     &sram_size);
 
 	cp->sram_size = sram_size;
-	cp->sram_pool = of_get_named_gen_pool(pdev->dev.of_node,
-					      "marvell,crypto-srams", 0);
+	cp->sram_pool = of_gen_pool_get(pdev->dev.of_node,
+					"marvell,crypto-srams", 0);
 	if (cp->sram_pool) {
 		cp->sram = gen_pool_dma_alloc(cp->sram_pool, sram_size,
 					      &cp->sram_dma);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
