Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34979 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730471AbeKTGSu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 01:18:50 -0500
Received: by mail-wr1-f68.google.com with SMTP id 96so16475994wrb.2
        for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2018 11:53:40 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 03/11] crypto: CRYPTO_STATS should depend on CRYPTO_USER
Date: Mon, 19 Nov 2018 19:53:22 +0000
Message-Id: <1542657210-37739-4-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1542657210-37739-1-git-send-email-clabbe@baylibre.com>
References: <1542657210-37739-1-git-send-email-clabbe@baylibre.com>
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
