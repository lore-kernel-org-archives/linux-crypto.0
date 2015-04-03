From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] crypto: Fix a typo in Kconfig
Date: Sat,  4 Apr 2015 00:20:30 +0900
Message-ID: <1428074430-17268-1-git-send-email-standby24x7@gmail.com>
Cc: Masanari Iida <standby24x7@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34643 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbbDCPUQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Apr 2015 11:20:16 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fix a spelling typo in crypto/Kconfig.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8863993..8aaf298 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1188,7 +1188,7 @@ config CRYPTO_SERPENT_SSE2_X86_64
 	  Keys are allowed to be from 0 to 256 bits in length, in steps
 	  of 8 bits.
 
-	  This module provides Serpent cipher algorithm that processes eigth
+	  This module provides Serpent cipher algorithm that processes eight
 	  blocks parallel using SSE2 instruction set.
 
 	  See also:
-- 
2.4.0.rc0.43.gcf8a8c6
