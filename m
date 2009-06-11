From: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Subject: Re: [PATCH] arm/orion5x: add sram support for crypto
Date: Thu, 11 Jun 2009 22:15:30 +0200
Message-ID: <20090611201530.GA11486@Chamillionaire.breakpoint.cc>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc> <1244728999-8103-2-git-send-email-arm-kernel@ml.breakpoint.cc> <alpine.LFD.2.00.0906111513420.31536@xanadu.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Nicolas Pitre <nico@cam.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44835 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309AbZFKUPb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 16:15:31 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906111513420.31536@xanadu.home>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Nicolas Pitre | 2009-06-11 15:17:09 [-0400]:

>This one is already merged in the Orion and ARM tree, with a minor fix 
>and device renamed to be more generic.  The equivalent registration for 
>Kirkwood is merged as well already.

Adding a revision history is good thing... I could not find the ARM tree
but I've rebased this patch against the orion tree [0].
Since the driver got renamed, I'm going to send a delta if nothing else
comes up.

[0]  git://git.marvell.com/orion for-rmk

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] arm/orion5x: increment window counter after adding sram mapping

Without incrementing the counter the next window setup will overwrite
the SRAM mapping.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/arm/mach-orion5x/addr-map.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-orion5x/addr-map.c b/arch/arm/mach-orion5x/addr-map.c
index 6f3f77d..d78731e 100644
--- a/arch/arm/mach-orion5x/addr-map.c
+++ b/arch/arm/mach-orion5x/addr-map.c
@@ -200,6 +200,6 @@ void __init orion5x_setup_pcie_wa_win(u32 base, u32 size)
 
 int __init orion5x_setup_sram_win(void)
 {
-	return setup_cpu_win(win_alloc_count, ORION5X_SRAM_PHYS_BASE,
+	return setup_cpu_win(win_alloc_count++, ORION5X_SRAM_PHYS_BASE,
 			ORION5X_SRAM_SIZE, TARGET_SRAM, ATTR_SRAM, -1);
 }
-- 
1.6.0.6

