From: arm-kernel@ml.breakpoint.cc
Subject: [PATCH] arm/ts209: init crypto
Date: Thu, 11 Jun 2009 16:03:19 +0200
Message-ID: <1244728999-8103-4-git-send-email-arm-kernel@ml.breakpoint.cc>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org, nico@cam.org,
	herbert@gondor.apana.org.au,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: linux-arm-kernel@lists.arm.linux.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52133 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbZFKODT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 10:03:19 -0400
In-Reply-To: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

use the new driver for the crypto engine

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/arm/mach-orion5x/ts209-setup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-orion5x/ts209-setup.c b/arch/arm/mach-orion5x/ts209-setup.c
index 9d68905..fbea307 100644
--- a/arch/arm/mach-orion5x/ts209-setup.c
+++ b/arch/arm/mach-orion5x/ts209-setup.c
@@ -302,6 +302,7 @@ static void __init qnap_ts209_init(void)
 	orion5x_uart0_init();
 	orion5x_uart1_init();
 	orion5x_xor_init();
+	orion5x_crypto_init();
 
 	platform_device_register(&qnap_ts209_button_device);
 
-- 
1.6.0.6

