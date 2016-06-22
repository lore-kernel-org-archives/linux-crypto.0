From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 25/27] ARM: OMAP: DRA7xx: Make L4SEC clock domain SWSUP only
Date: Wed, 22 Jun 2016 16:23:58 +0300
Message-ID: <1466601840-18486-26-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41264 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbcFVN0E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:26:04 -0400
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Joel Fernandes <joelf@ti.com>

Using HWSUP for l4sec clock domain is causing warnings in HWMOD code for
DRA7. Based on some observations, once the clock domain goes into an IDLE
state (because of no activity etc), the IDLEST for the module goes to '0x2'
value which means Interface IDLE condition. So far so go, however once the
MODULEMODE is set to disabled for the particular IP, the IDLEST for the
module should go to '0x3', per the HW AUTO IDLE protocol. However this is
not observed and there is no reason per the protocl for the transition to
not happen. This could potentially be a bug in the HW AUTO state-machine.

Work around for this is to use SWSUP only for the particular clockdomain.
With this all the transitions of IDLEST happen correctly and warnings
don't occur.

Signed-off-by: Joel Fernandes <joelf@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 arch/arm/mach-omap2/clockdomains7xx_data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/clockdomains7xx_data.c b/arch/arm/mach-omap2/clockdomains7xx_data.c
index ef9ed36..6c67965 100644
--- a/arch/arm/mach-omap2/clockdomains7xx_data.c
+++ b/arch/arm/mach-omap2/clockdomains7xx_data.c
@@ -409,7 +409,7 @@ static struct clockdomain l4sec_7xx_clkdm = {
 	.dep_bit	  = DRA7XX_L4SEC_STATDEP_SHIFT,
 	.wkdep_srcs	  = l4sec_wkup_sleep_deps,
 	.sleepdep_srcs	  = l4sec_wkup_sleep_deps,
-	.flags		  = CLKDM_CAN_HWSUP_SWSUP,
+	.flags		  = CLKDM_CAN_SWSUP,
 };
 
 static struct clockdomain l3main1_7xx_clkdm = {
-- 
1.9.1
