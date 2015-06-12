From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [RESEND PATCH v4 12/14] crypto: marvell/CESA: add support for Orion SoCs
Date: Fri, 12 Jun 2015 09:16:04 +0200
Message-ID: <1434093366-14681-13-git-send-email-boris.brezillon@free-electrons.com>
References: <1434093366-14681-1-git-send-email-boris.brezillon@free-electrons.com>
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
In-Reply-To: <1434093366-14681-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Add the Orion SoC description, and select this implementation by default
to support non-DT probing: Orion is the only platform where non-DT boards
are declaring the CESA block.

Control the allhwsupport module parameter to avoid probing the CESA IP when
the old CESA driver is enabled (unless it is explicitly requested to do
so).

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/crypto/marvell/cesa.c | 42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index c7e25a0..bd54973 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -168,6 +168,22 @@ static void mv_cesa_remove_algs(struct mv_cesa_dev *cesa)
 		crypto_unregister_alg(cesa->caps->cipher_algs[i]);
 }
 
+static struct crypto_alg *orion_cipher_algs[] = {
+	&mv_cesa_ecb_des_alg,
+	&mv_cesa_cbc_des_alg,
+	&mv_cesa_ecb_des3_ede_alg,
+	&mv_cesa_cbc_des3_ede_alg,
+	&mv_cesa_ecb_aes_alg,
+	&mv_cesa_cbc_aes_alg,
+};
+
+static struct ahash_alg *orion_ahash_algs[] = {
+	&mv_md5_alg,
+	&mv_sha1_alg,
+	&mv_ahmac_md5_alg,
+	&mv_ahmac_sha1_alg,
+};
+
 static struct crypto_alg *armada_370_cipher_algs[] = {
 	&mv_cesa_ecb_des_alg,
 	&mv_cesa_cbc_des_alg,
@@ -186,6 +202,15 @@ static struct ahash_alg *armada_370_ahash_algs[] = {
 	&mv_ahmac_sha256_alg,
 };
 
+static const struct mv_cesa_caps orion_caps = {
+	.nengines = 1,
+	.cipher_algs = orion_cipher_algs,
+	.ncipher_algs = ARRAY_SIZE(orion_cipher_algs),
+	.ahash_algs = orion_ahash_algs,
+	.nahash_algs = ARRAY_SIZE(orion_ahash_algs),
+	.has_tdma = false,
+};
+
 static const struct mv_cesa_caps armada_370_caps = {
 	.nengines = 1,
 	.cipher_algs = armada_370_cipher_algs,
@@ -205,6 +230,7 @@ static const struct mv_cesa_caps armada_xp_caps = {
 };
 
 static const struct of_device_id mv_cesa_of_match_table[] = {
+	{ .compatible = "marvell,orion-crypto", .data = &orion_caps },
 	{ .compatible = "marvell,armada-370-crypto", .data = &armada_370_caps },
 	{ .compatible = "marvell,armada-xp-crypto", .data = &armada_xp_caps },
 	{ .compatible = "marvell,armada-375-crypto", .data = &armada_xp_caps },
@@ -330,7 +356,7 @@ static void mv_cesa_put_sram(struct platform_device *pdev, int idx)
 
 static int mv_cesa_probe(struct platform_device *pdev)
 {
-	const struct mv_cesa_caps *caps = NULL;
+	const struct mv_cesa_caps *caps = &orion_caps;
 	const struct mbus_dram_target_info *dram;
 	const struct of_device_id *match;
 	struct device *dev = &pdev->dev;
@@ -345,14 +371,16 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		return -EEXIST;
 	}
 
-	if (!dev->of_node)
-		return -ENOTSUPP;
+	if (dev->of_node) {
+		match = of_match_node(mv_cesa_of_match_table, dev->of_node);
+		if (!match || !match->data)
+			return -ENOTSUPP;
 
-	match = of_match_node(mv_cesa_of_match_table, dev->of_node);
-	if (!match || !match->data)
-		return -ENOTSUPP;
+		caps = match->data;
+	}
 
-	caps = match->data;
+	if (caps == &orion_caps && !allhwsupport)
+		return -ENOTSUPP;
 
 	cesa = devm_kzalloc(dev, sizeof(*cesa), GFP_KERNEL);
 	if (!cesa)
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
