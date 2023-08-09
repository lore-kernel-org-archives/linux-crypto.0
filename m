Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9CE6EB64DD
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Aug 2023 11:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbjHILQC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Aug 2023 07:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbjHILQC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Aug 2023 07:16:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E181B10F3;
        Wed,  9 Aug 2023 04:16:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D8526283A;
        Wed,  9 Aug 2023 11:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66084C433C7;
        Wed,  9 Aug 2023 11:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1691579760;
        bh=96sKNmtnIIK64djcwh9/3Dm4kxWk2IB64DUJ1ZVgN8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcnHYKgGL2rJmh849MfWLBdVcUihFAkjlY0x3q5OQnBZa1JcomKpuRnki694FaAV2
         E69NtBqiMO5ImoMRwHsTzmvL5yGA/ULsolZtlkDbTiRrq/IyF4qV/o8f4hmzwXJwJz
         +a+IBxKjmbDkNP3FnCEA1tIIZmssDYaMuW8Up1Ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/323] crypto: nx - fix build warnings when DEBUG_FS is not enabled
Date:   Wed,  9 Aug 2023 12:38:35 +0200
Message-ID: <20230809103701.669183900@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b04b076fb56560b39d695ac3744db457e12278fd ]

Fix build warnings when DEBUG_FS is not enabled by using an empty
do-while loop instead of a value:

In file included from ../drivers/crypto/nx/nx.c:27:
../drivers/crypto/nx/nx.c: In function 'nx_register_algs':
../drivers/crypto/nx/nx.h:173:33: warning: statement with no effect [-Wunused-value]
  173 | #define NX_DEBUGFS_INIT(drv)    (0)
../drivers/crypto/nx/nx.c:573:9: note: in expansion of macro 'NX_DEBUGFS_INIT'
  573 |         NX_DEBUGFS_INIT(&nx_driver);
../drivers/crypto/nx/nx.c: In function 'nx_remove':
../drivers/crypto/nx/nx.h:174:33: warning: statement with no effect [-Wunused-value]
  174 | #define NX_DEBUGFS_FINI(drv)    (0)
../drivers/crypto/nx/nx.c:793:17: note: in expansion of macro 'NX_DEBUGFS_FINI'
  793 |                 NX_DEBUGFS_FINI(&nx_driver);

Also, there is no need to build nx_debugfs.o when DEBUG_FS is not
enabled, so change the Makefile to accommodate that.

Fixes: ae0222b7289d ("powerpc/crypto: nx driver code supporting nx encryption")
Fixes: aef7b31c8833 ("powerpc/crypto: Build files for the nx device driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Breno Leitão <leitao@debian.org>
Cc: Nayna Jain <nayna@linux.ibm.com>
Cc: Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/nx/Makefile | 2 +-
 drivers/crypto/nx/nx.h     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/nx/Makefile b/drivers/crypto/nx/Makefile
index 015155da59c29..76139865d7fa1 100644
--- a/drivers/crypto/nx/Makefile
+++ b/drivers/crypto/nx/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CRYPTO_DEV_NX_ENCRYPT) += nx-crypto.o
 nx-crypto-objs := nx.o \
-		  nx_debugfs.o \
 		  nx-aes-cbc.o \
 		  nx-aes-ecb.o \
 		  nx-aes-gcm.o \
@@ -11,6 +10,7 @@ nx-crypto-objs := nx.o \
 		  nx-sha256.o \
 		  nx-sha512.o
 
+nx-crypto-$(CONFIG_DEBUG_FS) += nx_debugfs.o
 obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_PSERIES) += nx-compress-pseries.o nx-compress.o
 obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_POWERNV) += nx-compress-powernv.o nx-compress.o
 nx-compress-objs := nx-842.o
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index c3e54af18645c..ebad937a9545c 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -180,8 +180,8 @@ struct nx_sg *nx_walk_and_build(struct nx_sg *, unsigned int,
 int nx_debugfs_init(struct nx_crypto_driver *);
 void nx_debugfs_fini(struct nx_crypto_driver *);
 #else
-#define NX_DEBUGFS_INIT(drv)	(0)
-#define NX_DEBUGFS_FINI(drv)	(0)
+#define NX_DEBUGFS_INIT(drv)	do {} while (0)
+#define NX_DEBUGFS_FINI(drv)	do {} while (0)
 #endif
 
 #define NX_PAGE_NUM(x)		((u64)(x) & 0xfffffffffffff000ULL)
-- 
2.39.2



