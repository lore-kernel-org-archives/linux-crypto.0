From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 6/7] arm64: marvell: dts: enable the crypto engine on the Armada 8040 DB
Date: Wed, 29 Mar 2017 14:44:31 +0200
Message-ID: <20170329124432.27457-7-antoine.tenart@free-electrons.com>
References: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36301 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932208AbdC2Mop (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Mar 2017 08:44:45 -0400
In-Reply-To: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enable the cryptographic engine available in the CP110 master on the
Armada 8040 DB. Do not enable the one in the CP110 salve for now, as we
do not support multiple cryptographic engines yet.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 arch/arm64/boot/dts/marvell/armada-8040-db.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-8040-db.dts b/arch/arm64/boot/dts/marvell/armada-8040-db.dts
index 80e685e4235d..f6d808bced51 100644
--- a/arch/arm64/boot/dts/marvell/armada-8040-db.dts
+++ b/arch/arm64/boot/dts/marvell/armada-8040-db.dts
@@ -140,6 +140,10 @@
 	phy-mode = "rgmii-id";
 };
 
+&cpm_crypto {
+	status = "okay";
+};
+
 /* CON5 on CP1 expansion */
 &cps_pcie2 {
 	status = "okay";
-- 
2.11.0
