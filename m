From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 1/2] dt-binding: rng: Add interrupt property for BCM2835
Date: Sat, 18 Nov 2017 14:04:12 +0100
Message-ID: <1511010253-5006-2-git-send-email-stefan.wahren@i2se.com>
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
Received: from mout.kundenserver.de ([212.227.126.130]:57201 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424310AbdKRNF3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Nov 2017 08:05:29 -0500
In-Reply-To: <1511010253-5006-1-git-send-email-stefan.wahren@i2se.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As Sylvain Garrigues pointed out the BCM2835 RNG block has an
interrupt. Also in preparation for Florian's upcoming patch series
add this property to the binding. While we are at it fix the
indenting of the example.

Link: https://github.com/raspberrypi/linux/issues/2195
CC: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 Documentation/devicetree/bindings/rng/brcm,bcm2835.txt | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt b/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
index 2654269..82ef4dd 100644
--- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
+++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
@@ -6,11 +6,16 @@ Required properties:
   "brcm,bcm5301x-rng"
 - reg : Specifies base physical address and size of the registers.
 
+Optional properties:
+
+- interrupts: specify the interrupt for the RNG block
+
 Example:
 
 rng {
-        compatible = "brcm,bcm2835-rng";
-        reg = <0x7e104000 0x10>;
+	compatible = "brcm,bcm2835-rng";
+	reg = <0x7e104000 0x10>;
+	interrupts = <2 29>;
 };
 
 rng@18033000 {
-- 
2.7.4
