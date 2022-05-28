Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA8CBC433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 28 May 2022 01:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbiE1BTy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 May 2022 21:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355355AbiE1BTx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 May 2022 21:19:53 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDF31271A1;
        Fri, 27 May 2022 18:19:52 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4L93k73fGfzDqWl;
        Sat, 28 May 2022 09:19:43 +0800 (CST)
Received: from huawei.com (10.175.127.227) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 28 May
 2022 09:19:47 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <Jason@zx2c4.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <zhengbin13@huawei.com>, <gaochao49@huawei.com>
Subject: [PATCH -next] crypto: curve25519 - Fix build error when CRYPTO_MANAGER_DISABLE_TESTS!=y && CRYPTO=m
Date:   Sat, 28 May 2022 09:33:18 +0800
Message-ID: <20220528013318.1621047-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If CRYPTO_MANAGER_DISABLE_TESTS!=y, CRYPTO=m, bulding fails:

lib/crypto/curve25519-selftest.o: In function `curve25519_selftest':
curve25519-selftest.c:(.init.text+0x60): undefined reference to `__crypto_memneq'
curve25519-selftest.c:(.init.text+0xec): undefined reference to `__crypto_memneq'
curve25519-selftest.c:(.init.text+0x114): undefined reference to `__crypto_memneq'
curve25519-selftest.c:(.init.text+0x154): undefined reference to `__crypto_memneq'

Add depends for CRYPTO_LIB_CURVE25519 to fix this.

Fixes: aa127963f1ca ("crypto: lib/curve25519 - re-add selftests")
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 lib/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 9856e291f414..f233bed9f214 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -70,6 +70,7 @@ config CRYPTO_LIB_CURVE25519_GENERIC
 config CRYPTO_LIB_CURVE25519
 	tristate "Curve25519 scalar multiplication library"
 	depends on CRYPTO_ARCH_HAVE_LIB_CURVE25519 || !CRYPTO_ARCH_HAVE_LIB_CURVE25519
+	depends on (CRYPTO && CRYPTO_MANAGER_DISABLE_TESTS!=y) || (CRYPTO_MANAGER_DISABLE_TESTS=y)
 	select CRYPTO_LIB_CURVE25519_GENERIC if CRYPTO_ARCH_HAVE_LIB_CURVE25519=n
 	help
 	  Enable the Curve25519 library interface. This interface may be
--
2.31.1

