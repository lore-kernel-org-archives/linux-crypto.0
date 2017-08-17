From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 4/6] crypto: jz4780-rng: Add RNG node to jz4780.dtsi
Date: Thu, 17 Aug 2017 23:55:18 +0530
Message-ID: <20170817182520.20102-5-prasannatsmkumar@gmail.com>
References: <20170817182520.20102-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, ralf@linux-mips.org, mturquette@baylibre.com,
        sboyd@codeaurora.org, davem@davemloft.net, paul@crapouillou.net,
        linux-crypto@vger.kernel.org, linux-mips@linux-mips.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35644 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbdHQS00 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Aug 2017 14:26:26 -0400
Received: by mail-pg0-f66.google.com with SMTP id t80so4945793pgb.2
        for <linux-crypto@vger.kernel.org>; Thu, 17 Aug 2017 11:26:26 -0700 (PDT)
In-Reply-To: <20170817182520.20102-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds RNG node to jz4780.dtsi.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 arch/mips/boot/dts/ingenic/jz4780.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/boot/dts/ingenic/jz4780.dtsi b/arch/mips/boot/dts/ingenic/jz4780.dtsi
index 1301694..865b9bf 100644
--- a/arch/mips/boot/dts/ingenic/jz4780.dtsi
+++ b/arch/mips/boot/dts/ingenic/jz4780.dtsi
@@ -46,6 +46,10 @@
 
 			#clock-cells = <1>;
 		};
+
+		rng: rng@d8 {
+			compatible = "ingenic,jz480-rng";
+		};
 	};
 
 	pinctrl: pin-controller@10010000 {
-- 
2.10.0
