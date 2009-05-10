From: Harald Welte <HaraldWelte@viatech.com>
Subject: [PATCH] The VIA Hardware RNG driver is for the CPU, not Chipset
Date: Sun, 10 May 2009 14:28:44 +0800
Message-ID: <20090510062844.GD12152@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:60561 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZEJHIn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 May 2009 03:08:43 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a cosmetic change, fixing the MODULE_DESCRIPTION() of via-rng.c

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
---
 drivers/char/hw_random/via-rng.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index eea0814..824f003 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -213,5 +213,5 @@ static void __exit mod_exit(void)
 module_init(mod_init);
 module_exit(mod_exit);
 
-MODULE_DESCRIPTION("H/W RNG driver for VIA chipsets");
+MODULE_DESCRIPTION("H/W RNG driver for VIA CPU with PadLock");
 MODULE_LICENSE("GPL");
-- 
1.5.6.5

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Open Source Liaison
