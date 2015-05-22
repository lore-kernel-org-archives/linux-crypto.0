From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 11/16] crypto: marvell/CESA: add support for Kirkwood SoCs
Date: Fri, 22 May 2015 15:33:57 +0200
Message-ID: <1432301642-11470-12-git-send-email-boris.brezillon@free-electrons.com>
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
Received: from down.free-electrons.com ([37.187.137.238]:47381 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964813AbbEVNeZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 May 2015 09:34:25 -0400
In-Reply-To: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Arnaud Ebalard <arno@natisbad.org>

Add the Kirkwood SoC description, and control the allhwsupport module
parameter to avoid probing the CESA IP when the old CESA driver is enabled
(unless it is explicitly requested to do so).

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index a7a7e0e..16f9364 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -211,6 +211,15 @@ static const struct mv_cesa_caps orion_caps = {
 	.has_tdma = false,
 };
 
+static const struct mv_cesa_caps kirkwood_caps = {
+	.nengines = 1,
+	.cipher_algs = orion_cipher_algs,
+	.ncipher_algs = ARRAY_SIZE(orion_cipher_algs),
+	.ahash_algs = orion_ahash_algs,
+	.nahash_algs = ARRAY_SIZE(orion_ahash_algs),
+	.has_tdma = true,
+};
+
 static const struct mv_cesa_caps armada_370_caps = {
 	.nengines = 1,
 	.cipher_algs = armada_370_cipher_algs,
@@ -231,6 +240,7 @@ static const struct mv_cesa_caps armada_xp_caps = {
 
 static const struct of_device_id mv_cesa_of_match_table[] = {
 	{ .compatible = "marvell,orion-crypto", .data = &orion_caps },
+	{ .compatible = "marvell,kirkwood-crypto", .data = &kirkwood_caps },
 	{ .compatible = "marvell,armada-370-crypto", .data = &armada_370_caps },
 	{ .compatible = "marvell,armada-xp-crypto", .data = &armada_xp_caps },
 	{ .compatible = "marvell,armada-375-crypto", .data = &armada_xp_caps },
@@ -379,7 +389,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		caps = match->data;
 	}
 
-	if (caps == &orion_caps && !allhwsupport)
+	if ((caps == &orion_caps || caps == &kirkwood_caps) && !allhwsupport)
 		return -ENOTSUPP;
 
 	cesa = devm_kzalloc(dev, sizeof(*cesa), GFP_KERNEL);
-- 
1.9.1
