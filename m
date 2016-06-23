From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 1/3] Documentation: devicetree: bindings: Add BCM5301x binding
Date: Wed, 22 Jun 2016 17:27:01 -0700
Message-ID: <1466641623-3491-2-git-send-email-f.fainelli@gmail.com>
References: <1466641623-3491-1-git-send-email-f.fainelli@gmail.com>
Cc: yendapally.reddy@broadcom.com, herbert@gondor.apana.org.au,
	eric@anholt.net, bcm-kernel-feedback-list@broadcom.com,
	devicetre@vger.kernel.org, hauke@hauke-m.de, zajec5@gmail.com,
	mpm@selenic.com, linux-arm-kernel@lists.infradead.org,
	Florian Fainelli <f.fainelli@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36380 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbcFWA1N (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 20:27:13 -0400
In-Reply-To: <1466641623-3491-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Document the binding used by the Broadcom BCM5301x (Northstar) SoC
random number generator.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/rng/brcm,bcm2835.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt b/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
index aa304d412058..26542690b578 100644
--- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
+++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
@@ -2,7 +2,8 @@ BCM2835 Random number generator
 
 Required properties:
 
-- compatible : should be "brcm,bcm2835-rng"  or "brcm,bcm-nsp-rng"
+- compatible : should be "brcm,bcm2835-rng"  or "brcm,bcm-nsp-rng" or
+  "brcm,bcm5301x-rng"
 - reg : Specifies base physical address and size of the registers.
 
 Example:
-- 
2.7.4
