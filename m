From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 5/7] ARM: marvell/dt: add crypto node to armada-xp-gp board
Date: Mon,  4 May 2015 14:27:04 +0200
Message-ID: <1430742426-21202-6-git-send-email-boris.brezillon@free-electrons.com>
References: <1430742426-21202-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <boris.brezillon@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:57785 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752744AbbEDM11 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2015 08:27:27 -0400
In-Reply-To: <1430742426-21202-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/armada-xp-gp.dts | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-xp-gp.dts b/arch/arm/boot/dts/armada-xp-gp.dts
index 206aebb..586b60b 100644
--- a/arch/arm/boot/dts/armada-xp-gp.dts
+++ b/arch/arm/boot/dts/armada-xp-gp.dts
@@ -94,7 +94,9 @@
 	soc {
 		ranges = <MBUS_ID(0xf0, 0x01) 0 0 0xf1000000 0x100000
 			  MBUS_ID(0x01, 0x1d) 0 0 0xfff00000 0x100000
-			  MBUS_ID(0x01, 0x2f) 0 0 0xf0000000 0x1000000>;
+			  MBUS_ID(0x01, 0x2f) 0 0 0xf0000000 0x1000000
+			  MBUS_ID(0x09, 0x09) 0 0 0xf1100000 0x10000
+			  MBUS_ID(0x09, 0x05) 0 0 0xf1110000 0x10000>;
 
 		devbus-bootcs {
 			status = "okay";
-- 
1.9.1
