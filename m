From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 7/7] crypto: aes - allow generic AES to be replaced by fixed time AES
Date: Tue, 20 Jun 2017 11:29:00 +0200
Message-ID: <1497950940-24243-8-git-send-email-ard.biesheuvel@linaro.org>
References: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36983 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752049AbdFTJ3N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 05:29:13 -0400
Received: by mail-wm0-f50.google.com with SMTP id d73so14418313wma.0
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2017 02:29:12 -0700 (PDT)
In-Reply-To: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On systems where a small memory footprint is important, the generic
AES code with its 16 KB of lookup tables and fully unrolled encrypt
and decrypt routines may be an unnecessary burden, especially given
that modern SoCs often have dedicated instructions for AES. And even
if they don't, a time invariant implementation may be preferred over
a fast one that may be susceptible to cache timing attacks.

So allow the declared dependency of other subsystems on AES to be
fulfilled by either the generic table based AES or by the much smaller
generic time invariant implementation.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 87d9e03dcb74..dd0bc0d84789 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -899,7 +899,8 @@ config CRYPTO_AES_CORE
 
 config CRYPTO_AES
 	tristate
-	select CRYPTO_AES_GENERIC
+	select CRYPTO_AES_GENERIC if (CRYPTO_AES=y && CRYPTO_AES_TI != y) || \
+				     (CRYPTO_AES=m && !CRYPTO_AES_TI)
 
 config CRYPTO_AES_GENERIC
 	tristate "Generic table based AES cipher"
-- 
2.7.4
