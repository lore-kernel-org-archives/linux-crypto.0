From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v7 01/14] crypto: mv_cesa: document the clocks property
Date: Thu, 18 Jun 2015 15:46:17 +0200
Message-ID: <1434635190-27733-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1434635190-27733-1-git-send-email-boris.brezillon@free-electrons.com>
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
	"Imre Kaloz" <kaloz@openwrt.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:37416 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752262AbbFRNqw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 09:46:52 -0400
In-Reply-To: <1434635190-27733-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Dove platforms, the crypto engine requires a clock. Document this
clocks property in the mv_cesa bindings doc.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 Documentation/devicetree/bindings/crypto/mv_cesa.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/mv_cesa.txt b/Documentation/devicetree/bindings/crypto/mv_cesa.txt
index 47229b1..eaa2873 100644
--- a/Documentation/devicetree/bindings/crypto/mv_cesa.txt
+++ b/Documentation/devicetree/bindings/crypto/mv_cesa.txt
@@ -7,6 +7,8 @@ Required properties:
         length
 - reg-names : "regs" , "sram";
 - interrupts : interrupt number
+- clocks: reference to the crypto engines clocks. This property is only
+	  required for Dove platforms
 
 Examples:
 
-- 
1.9.1
