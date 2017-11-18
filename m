From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 2/2] ARM: bcm283x: Add missing interrupt for RNG block
Date: Sat, 18 Nov 2017 14:04:13 +0100
Message-ID: <1511010253-5006-3-git-send-email-stefan.wahren@i2se.com>
References: <1511010253-5006-1-git-send-email-stefan.wahren@i2se.com>
Cc: Scott Branden <sbranden@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org,
        Stefan Wahren <stefan.wahren@i2se.com>
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Anholt <eric@anholt.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:64486 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424311AbdKRNF3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Nov 2017 08:05:29 -0500
In-Reply-To: <1511010253-5006-1-git-send-email-stefan.wahren@i2se.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the missing interrupt property to the RNG block
of BCM283x.

Link: https://github.com/raspberrypi/linux/issues/2195
CC: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 arch/arm/boot/dts/bcm283x.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/bcm283x.dtsi b/arch/arm/boot/dts/bcm283x.dtsi
index 013431e..0c17a81 100644
--- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -135,6 +135,7 @@
 		rng@7e104000 {
 			compatible = "brcm,bcm2835-rng";
 			reg = <0x7e104000 0x10>;
+			interrupts = <2 29>;
 		};
 
 		mailbox: mailbox@7e00b880 {
-- 
2.7.4
