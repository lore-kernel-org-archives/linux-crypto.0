Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51523 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387740AbeK3BsM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 20:48:12 -0500
Received: by mail-wm1-f65.google.com with SMTP id s14so2540061wmh.1
        for <linux-crypto@vger.kernel.org>; Thu, 29 Nov 2018 06:42:36 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 02/11] crypto: CRYPTO_STATS should depend on CRYPTO_USER
Date: Thu, 29 Nov 2018 14:42:17 +0000
Message-Id: <1543502546-23870-3-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1543502546-23870-1-git-send-email-clabbe@baylibre.com>
References: <1543502546-23870-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CRYPTO_STATS is using CRYPTO_USER stuff, so it should depends on it.
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b6376d5d973e..5994d0fa7a78 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1865,6 +1865,7 @@ config CRYPTO_USER_API_AEAD
 
 config CRYPTO_STATS
 	bool "Crypto usage statistics for User-space"
+	depends on CRYPTO_USER
 	help
 	  This option enables the gathering of crypto stats.
 	  This will collect:
-- 
2.18.1
