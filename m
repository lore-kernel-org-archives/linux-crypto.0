From: Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadcom.com>
Subject: [PATCH 3/4] ARM: dts: nsp: Add rng device tree entry
Date: Mon, 23 May 2016 12:20:50 -0400
Message-ID: <1464020451-16520-4-git-send-email-yendapally.reddy@broadcom.com>
References: <1464020451-16520-1-git-send-email-yendapally.reddy@broadcom.com>
Cc: devicetree@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	bcm-kernel-feedback-list@broadcom.com,
	linux-crypto@vger.kernel.org,
	Yendapally Reddy Dhananjaya Reddy
	<yendapally.reddy@broadcom.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Lee Jones <lee@kernel.org>, Eric Anholt <eric@anholt.net>,
	Russell King <linux@arm.linux.org.uk>,
	Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Jon Mason <jonmason@broadcom.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Kieran Bingham <kieranbingham@gmail.com>,
	Pankaj Dev <pankaj.dev@st.com>,
	Richard Weinberger <richard@nod.at>, noltari@gmail.com,
	Joshua Henderson <joshua.henderson@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34641 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbcEWQVh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 May 2016 12:21:37 -0400
Received: by mail-pf0-f179.google.com with SMTP id y69so66212491pfb.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 May 2016 09:21:37 -0700 (PDT)
In-Reply-To: <1464020451-16520-1-git-send-email-yendapally.reddy@broadcom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for the random number generator to the Northstar Plus
SoC device tree.

Signed-off-by: Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadcom.com>
---
 arch/arm/boot/dts/bcm-nsp.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index def9e78..1ed829e 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -206,6 +206,11 @@
 			brcm,nand-has-wp;
 		};
 
+		rng: rng@33000 {
+			compatible = "brcm,bcm-nsp-rng";
+			reg = <0x33000 0x14>;
+		};
+
 		ccbtimer0: timer@34000 {
 			compatible = "arm,sp804";
 			reg = <0x34000 0x1000>;
-- 
2.1.0
