From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 5/7] arm64: marvell: dts: enable the crypto engine on the Armada 7040 DB
Date: Wed, 29 Mar 2017 14:44:30 +0200
Message-ID: <20170329124432.27457-6-antoine.tenart@free-electrons.com>
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
Received: from mail.free-electrons.com ([62.4.15.54]:36291 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932205AbdC2Moo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Mar 2017 08:44:44 -0400
In-Reply-To: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enable the cryptographic engine available in the CP110 master on the
Armada 7040 DB.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 arch/arm64/boot/dts/marvell/armada-7040-db.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-7040-db.dts b/arch/arm64/boot/dts/marvell/armada-7040-db.dts
index bb0e1e8e7138..7e9a8a4e89a4 100644
--- a/arch/arm64/boot/dts/marvell/armada-7040-db.dts
+++ b/arch/arm64/boot/dts/marvell/armada-7040-db.dts
@@ -171,3 +171,7 @@
 	phy = <&phy1>;
 	phy-mode = "rgmii-id";
 };
+
+&cpm_crypto {
+	status = "okay";
+};
-- 
2.11.0
