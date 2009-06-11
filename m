From: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Subject: [PATCH] arm/orion5x: init the crypto device
Date: Thu, 11 Jun 2009 22:27:20 +0200
Message-ID: <20090611202720.GB11486@Chamillionaire.breakpoint.cc>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc> <1244728999-8103-4-git-send-email-arm-kernel@ml.breakpoint.cc> <alpine.LFD.2.00.0906111518390.31536@xanadu.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Nicolas Pitre <nico@cam.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48120 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbZFKU1W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 16:27:22 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906111518390.31536@xanadu.home>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

init & register the crypto device.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/arm/mach-orion5x/common.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index eafcc49..745af50 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -700,6 +700,7 @@ void __init orion5x_init(void)
 	 * Register watchdog driver
 	 */
 	orion5x_wdt_init();
+	orion5x_crypto_init();
 }
 
 /*
-- 
1.6.0.6

