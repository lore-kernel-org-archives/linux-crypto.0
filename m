From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v5 10/14] crypto: marvell/CESA: add support for all armada SoCs
Date: Tue, 16 Jun 2015 11:59:04 +0200
Message-ID: <1434448748-10828-11-git-send-email-boris.brezillon@free-electrons.com>
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
Received: from down.free-electrons.com ([37.187.137.238]:56605 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932447AbbFPJ7h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 05:59:37 -0400
In-Reply-To: <1434448748-10828-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add CESA IP description for all the missing armada SoCs (XP, 375 and 38x).

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 9c43cd7e..af590bf 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -195,8 +195,20 @@ static const struct mv_cesa_caps armada_370_caps = {
 	.has_tdma = true,
 };
 
+static const struct mv_cesa_caps armada_xp_caps = {
+	.nengines = 2,
+	.cipher_algs = armada_370_cipher_algs,
+	.ncipher_algs = ARRAY_SIZE(armada_370_cipher_algs),
+	.ahash_algs = armada_370_ahash_algs,
+	.nahash_algs = ARRAY_SIZE(armada_370_ahash_algs),
+	.has_tdma = true,
+};
+
 static const struct of_device_id mv_cesa_of_match_table[] = {
 	{ .compatible = "marvell,armada-370-crypto", .data = &armada_370_caps },
+	{ .compatible = "marvell,armada-xp-crypto", .data = &armada_xp_caps },
+	{ .compatible = "marvell,armada-375-crypto", .data = &armada_xp_caps },
+	{ .compatible = "marvell,armada-38x-crypto", .data = &armada_xp_caps },
 	{}
 };
 MODULE_DEVICE_TABLE(of, mv_cesa_of_match_table);
-- 
1.9.1
