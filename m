From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 10/16] crypto: marvell/CESA: add support for Orion SoCs
Date: Fri, 22 May 2015 15:33:56 +0200
Message-ID: <1432301642-11470-11-git-send-email-boris.brezillon@free-electrons.com>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:47363 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964812AbbEVNeY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 May 2015 09:34:24 -0400
In-Reply-To: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the Orion SoC description, and select this implementation by default
to support non-DT probing: Orion is the only platform where non-DT boards
are declaring the CESA block.

Control the allhwsupport module parameter to avoid probing the CESA IP when
the old CESA driver is enabled (unless it is explicitly requested to do
so).

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c | 42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index f763981..a7a7e0e 100644
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
