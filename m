Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0514FC54EE9
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Sep 2022 06:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiISGhh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Sep 2022 02:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiISGhg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2022 02:37:36 -0400
Received: from twspam01.aspeedtech.com (twspam01.aspeedtech.com [211.20.114.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6CE11A34
        for <linux-crypto@vger.kernel.org>; Sun, 18 Sep 2022 23:37:26 -0700 (PDT)
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 28J6GVap079123;
        Mon, 19 Sep 2022 14:16:32 +0800 (GMT-8)
        (envelope-from neal_liu@aspeedtech.com)
Received: from localhost.localdomain (192.168.10.10) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 19 Sep
 2022 14:37:13 +0800
From:   Neal Liu <neal_liu@aspeedtech.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Randy Dunlap <rdunlap@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        <linux-aspeed@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: [PATCH] crypto: aspeed: fix build error when only CRYPTO_DEV_ASPEED is enabled
Date:   Mon, 19 Sep 2022 14:37:05 +0800
Message-ID: <20220919063705.358225-1-neal_liu@aspeedtech.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.10.10]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 28J6GVap079123
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix build error within the following configs setting:
- CONFIG_CRYPTO_DEV_ASPEED=y
- CONFIG_CRYPTO_DEV_ASPEED_HACE_HASH is not set
- CONFIG_CRYPTO_DEV_ASPEED_HACE_CRYPTO is not set

Error messages:
make[4]: *** No rule to make target 'drivers/crypto/aspeed/aspeed_crypto.o'
, needed by 'drivers/crypto/aspeed/built-in.a'.
make[4]: Target '__build' not remade because of errors.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
---
 drivers/crypto/aspeed/Kconfig  | 3 +--
 drivers/crypto/aspeed/Makefile | 7 ++++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/aspeed/Kconfig b/drivers/crypto/aspeed/Kconfig
index ae3eb0eb57f6..ae2710ae8d8f 100644
--- a/drivers/crypto/aspeed/Kconfig
+++ b/drivers/crypto/aspeed/Kconfig
@@ -1,6 +1,7 @@
 config CRYPTO_DEV_ASPEED
 	tristate "Support for Aspeed cryptographic engine driver"
 	depends on ARCH_ASPEED || COMPILE_TEST
+	select CRYPTO_ENGINE
 	help
 	  Hash and Crypto Engine (HACE) is designed to accelerate the
 	  throughput of hash data digest, encryption and decryption.
@@ -20,7 +21,6 @@ config CRYPTO_DEV_ASPEED_DEBUG
 config CRYPTO_DEV_ASPEED_HACE_HASH
 	bool "Enable Aspeed Hash & Crypto Engine (HACE) hash"
 	depends on CRYPTO_DEV_ASPEED
-	select CRYPTO_ENGINE
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
@@ -34,7 +34,6 @@ config CRYPTO_DEV_ASPEED_HACE_HASH
 config CRYPTO_DEV_ASPEED_HACE_CRYPTO
 	bool "Enable Aspeed Hash & Crypto Engine (HACE) crypto"
 	depends on CRYPTO_DEV_ASPEED
-	select CRYPTO_ENGINE
 	select CRYPTO_AES
 	select CRYPTO_DES
 	select CRYPTO_ECB
diff --git a/drivers/crypto/aspeed/Makefile b/drivers/crypto/aspeed/Makefile
index 3be78cec0ecb..a0ed40ddaad1 100644
--- a/drivers/crypto/aspeed/Makefile
+++ b/drivers/crypto/aspeed/Makefile
@@ -1,6 +1,7 @@
-hace-hash-$(CONFIG_CRYPTO_DEV_ASPEED_HACE_HASH) := aspeed-hace.o aspeed-hace-hash.o
-hace-crypto-$(CONFIG_CRYPTO_DEV_ASPEED_HACE_CRYPTO) := aspeed-hace.o aspeed-hace-crypto.o
+hace-hash-$(CONFIG_CRYPTO_DEV_ASPEED_HACE_HASH) := aspeed-hace-hash.o
+hace-crypto-$(CONFIG_CRYPTO_DEV_ASPEED_HACE_CRYPTO) := aspeed-hace-crypto.o
 
 obj-$(CONFIG_CRYPTO_DEV_ASPEED) += aspeed_crypto.o
-aspeed_crypto-objs := $(hace-hash-y)	\
+aspeed_crypto-objs := aspeed-hace.o	\
+		      $(hace-hash-y)	\
 		      $(hace-crypto-y)
-- 
2.25.1

