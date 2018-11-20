Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40028 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728375AbeKTXCR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 18:02:17 -0500
Received: by mail-wm1-f65.google.com with SMTP id q26so2031373wmf.5
        for <linux-crypto@vger.kernel.org>; Tue, 20 Nov 2018 04:33:22 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 02/10] crypto: CRYPTO_STATS should depend on CRYPTO_USER
Date: Tue, 20 Nov 2018 12:32:18 +0000
Message-Id: <1542717146-34917-3-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1542717146-34917-1-git-send-email-clabbe@baylibre.com>
References: <1542717146-34917-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CRYPTO_STATS is using CRYPTO_USER stuff, so it should depends on it.
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 62dbd1a99fa3..a2f1b4a86b92 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1829,6 +1829,7 @@ config CRYPTO_USER_API_AEAD
 
 config CRYPTO_STATS
 	bool "Crypto usage statistics for User-space"
+	depends on CRYPTO_USER
 	help
 	  This option enables the gathering of crypto stats.
 	  This will collect:
-- 
2.18.1
