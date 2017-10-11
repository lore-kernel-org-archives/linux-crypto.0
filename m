From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 1/3] crypto: marvell - Add a platform_device_id table
Date: Wed, 11 Oct 2017 15:16:17 +0200
Message-ID: <20171011131619.30196-2-boris.brezillon@free-electrons.com>
References: <20171011131619.30196-1-boris.brezillon@free-electrons.com>
Cc: Russell King <linux@armlinux.org.uk>,
        Arnaud Ebalard <arno@natisbad.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:60306 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757485AbdJKNQX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2017 09:16:23 -0400
In-Reply-To: <20171011131619.30196-1-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a platform_device_id table to allow using this driver on orion
platforms that have not been converted to DT.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 6e7a5c77a00a..c14674c6c11d 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -599,9 +599,15 @@ static int mv_cesa_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct platform_device_id mv_cesa_plat_id_table[] = {
+	{ .name = "mv_crypto" },
+};
+MODULE_DEVICE_TABLE(platform, mv_cesa_plat_id_table);
+
 static struct platform_driver marvell_cesa = {
 	.probe		= mv_cesa_probe,
 	.remove		= mv_cesa_remove,
+	.id_table	= mv_cesa_plat_id_table,
 	.driver		= {
 		.name	= "marvell-cesa",
 		.of_match_table = mv_cesa_of_match_table,
-- 
2.11.0
