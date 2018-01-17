From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: artpec6 - remove select on non-existing CRYPTO_SHA384
Date: Wed, 17 Jan 2018 19:50:56 +0100
Message-ID: <20180117185056.11562-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33130 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754415AbeAQSxC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jan 2018 13:53:02 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since CRYPTO_SHA384 does not exists, Kconfig should not select it.
Anyway, all SHA384 stuff is in CRYPTO_SHA512 which is already selected.

Fixes: a21eb94fc4d3i ("crypto: axis - add ARTPEC-6/7 crypto accelerator driver")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index f7f803e78701..e92b9304a8d5 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -725,7 +725,6 @@ config CRYPTO_DEV_ARTPEC6
 	select CRYPTO_HASH
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
-	select CRYPTO_SHA384
 	select CRYPTO_SHA512
 	help
 	  Enables the driver for the on-chip crypto accelerator
-- 
2.13.6
