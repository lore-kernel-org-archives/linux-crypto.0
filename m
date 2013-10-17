From: Siddharth Goel <siddharth98391@gmail.com>
Subject: [PATCH] [CRYPTO] kconfig: Corrected a typo
Date: Thu, 17 Oct 2013 23:39:11 +0800
Message-ID: <1382024351-23743-1-git-send-email-siddharth98391@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	trivial@kernel.org, Siddharth Goel <siddharth98391@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:56360 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab3JQPjZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Oct 2013 11:39:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Corrected a typo in option description in Kconfig

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=60848

Signed-off-by: Siddharth Goel <siddharth98391@gmail.com>
---
 crypto/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 69ce573..84698cf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1084,7 +1084,7 @@ config CRYPTO_SERPENT
 
 	  Keys are allowed to be from 0 to 256 bits in length, in steps
 	  of 8 bits.  Also includes the 'Tnepres' algorithm, a reversed
-	  variant of Serpent for compatibility with old kerneli.org code.
+	  variant of Serpent for compatibility with old kernel.org code.
 
 	  See also:
 	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
-- 
1.7.0.4
