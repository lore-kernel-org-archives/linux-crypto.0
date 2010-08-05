From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?=
	<ariveira@gmail.com>
Subject: [PATCH] Trivial. Fix typo in kconfig entry.
Date: Thu, 5 Aug 2010 11:21:42 +0200
Message-ID: <20100805112142.68d8926d@varda>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50423 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab0HEJVr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Aug 2010 05:21:47 -0400
Received: by wwj40 with SMTP id 40so7522583wwj.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Aug 2010 02:21:45 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


 This fixes a typo in file crypto/Kconfig.

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1cd497d..27484e4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -102,7 +102,7 @@ config CRYPTO_MANAGER2
 	select CRYPTO_PCOMP2
 
 config CRYPTO_MANAGER_TESTS
-	bool "Run algolithms' self-tests"
+	bool "Run algorithms' self-tests"
 	default y
 	depends on CRYPTO_MANAGER2
 	help
