From: Harald Welte <HaraldWelte@viatech.com>
Subject: [PATCH] Support VIA Nano hardware RNG
Date: Mon, 11 May 2009 12:03:41 +0800
Message-ID: <20090511040341.GF4005@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:44827 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbZEKEKK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2009 00:10:10 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Support VIA Nano hardware RNG

The VIA Nano CPU supports the same XSTORE instruction based RNG,
but it lacks the MSR present in earlier CPUs.

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>

diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index 4e9573c..794aacb 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -132,6 +132,19 @@ static int via_rng_init(struct hwrng *rng)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	u32 lo, hi, old_lo;
 
+	/* VIA Nano CPUs don't have the MSR_VIA_RNG anymore.  The RNG
+	 * is always enabled if CPUID rng_en is set.  There is no
+	 * RNG configuration like it used to be the case in this
+	 * register */
+	if ((c->x86 == 6) && (c->x86_model >= 0x0f)) {
+		if (!cpu_has_xstore_enabled) {
+			printk(KERN_ERR PFX "can't enable hardware RNG "
+				"if XSTORE is not enabled\n");
+			return -ENODEV;
+		}
+		return 0;
+	}
+
 	/* Control the RNG via MSR.  Tread lightly and pay very close
 	 * close attention to values written, as the reserved fields
 	 * are documented to be "undefined and unpredictable"; but it
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Open Source Liaison
