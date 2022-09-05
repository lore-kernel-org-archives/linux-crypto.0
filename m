Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B8FC6FA82
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Sep 2022 02:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbiIEC4e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 4 Sep 2022 22:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234382AbiIEC4d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Sep 2022 22:56:33 -0400
Received: from twspam01.aspeedtech.com (twspam01.aspeedtech.com [211.20.114.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04CB183AE
        for <linux-crypto@vger.kernel.org>; Sun,  4 Sep 2022 19:56:25 -0700 (PDT)
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 2852YhcH045911;
        Mon, 5 Sep 2022 10:34:43 +0800 (GMT-8)
        (envelope-from neal_liu@aspeedtech.com)
Received: from localhost.localdomain (192.168.10.10) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Sep
 2022 10:54:37 +0800
From:   Neal Liu <neal_liu@aspeedtech.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
CC:     <linux-aspeed@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <BMC-SW@aspeedtech.com>,
        kernel test robot <lkp@intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH v2] crypto: aspeed: fix build module error
Date:   Mon, 5 Sep 2022 10:54:33 +0800
Message-ID: <20220905025433.1610696-1-neal_liu@aspeedtech.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.10.10]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 2852YhcH045911
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If CONFIG_MODULES=y and CONFIG_CRYPTO_DEV_ASPEED=m,
build modpost would be failed.

Error messages:
  ERROR: modpost: "aspeed_register_hace_hash_algs"
  [drivers/crypto/aspeed/aspeed_crypto.ko] undefined!
  ERROR: modpost: "aspeed_unregister_hace_hash_algs"
  [drivers/crypto/aspeed/aspeed_crypto.ko] undefined!

Change build sequence to fix this.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
Tested-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
v2: Remove redundant obj- lines.

 drivers/crypto/aspeed/Makefile | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/aspeed/Makefile b/drivers/crypto/aspeed/Makefile
index 421e2ca9c53e..3be78cec0ecb 100644
--- a/drivers/crypto/aspeed/Makefile
+++ b/drivers/crypto/aspeed/Makefile
@@ -1,9 +1,6 @@
+hace-hash-$(CONFIG_CRYPTO_DEV_ASPEED_HACE_HASH) := aspeed-hace.o aspeed-hace-hash.o
+hace-crypto-$(CONFIG_CRYPTO_DEV_ASPEED_HACE_CRYPTO) := aspeed-hace.o aspeed-hace-crypto.o
+
 obj-$(CONFIG_CRYPTO_DEV_ASPEED) += aspeed_crypto.o
-aspeed_crypto-objs := aspeed-hace.o	\
-		      $(hace-hash-y)	\
+aspeed_crypto-objs := $(hace-hash-y)	\
 		      $(hace-crypto-y)
-
-obj-$(CONFIG_CRYPTO_DEV_ASPEED_HACE_HASH) += aspeed-hace-hash.o
-hace-hash-$(CONFIG_CRYPTO_DEV_ASPEED_HACE_HASH) := aspeed-hace-hash.o
-obj-$(CONFIG_CRYPTO_DEV_ASPEED_HACE_CRYPTO) += aspeed-hace-crypto.o
-hace-crypto-$(CONFIG_CRYPTO_DEV_ASPEED_HACE_CRYPTO) := aspeed-hace-crypto.o
-- 
2.25.1

