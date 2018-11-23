Return-Path: <SRS0=Oq1A=OC=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53713 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503926AbeKWWqc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Nov 2018 17:46:32 -0500
Received: by mail-wm1-f65.google.com with SMTP id y1so8435052wmi.3
        for <linux-crypto@vger.kernel.org>; Fri, 23 Nov 2018 04:02:34 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 02/11] crypto: CRYPTO_STATS should depend on CRYPTO_USER
Date: Fri, 23 Nov 2018 12:02:12 +0000
Message-Id: <1542974541-23024-3-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1542974541-23024-1-git-send-email-clabbe@baylibre.com>
References: <1542974541-23024-1-git-send-email-clabbe@baylibre.com>
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
