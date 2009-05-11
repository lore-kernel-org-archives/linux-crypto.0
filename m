From: Harald Welte <HaraldWelte@viatech.com>
Subject: [PATCH] Support VIA Nano hardware RNG on X86_64 builds
Date: Mon, 11 May 2009 12:03:45 +0800
Message-ID: <20090511040345.GG4005@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:44825 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbZEKEKK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2009 00:10:10 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix Kconfig to build via-rng.ko on X86_64 builds, as the VIA Nano
CPU supports x86_64, too.

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
---
 drivers/char/hw_random/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 5fab647..9c00440 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -88,7 +88,7 @@ config HW_RANDOM_N2RNG
 
 config HW_RANDOM_VIA
 	tristate "VIA HW Random Number Generator support"
-	depends on HW_RANDOM && X86_32
+	depends on HW_RANDOM && X86
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
-- 
1.6.2.4

