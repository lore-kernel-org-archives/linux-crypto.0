Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4228C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 12:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93A5161058
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 12:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhI0MTy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Sep 2021 08:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234162AbhI0MTw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Sep 2021 08:19:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 634DE6103B;
        Mon, 27 Sep 2021 12:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632745095;
        bh=Q51NkLhfdP9cqBSlpTRPX/qx56tDI5PJVgL+PG3DiO8=;
        h=From:To:Cc:Subject:Date:From;
        b=FGWy3XGVbDh9POAkE0jOMILMxXxn2dHjEaB65vSUN2ibK4GKnnLvO+jDJSa5Y8W5b
         z+bNFnP4ihkhgUT96JUBije9Jwg7bhNTAsjBQc3tnbJfAHe67NCQzgdNmfwOPgm0Zj
         uD9uG5dZ+s6sfdZHbknAVtUYf7g+tSCbbxs9gGat9oIJuqMnxe4lz43GYDTm5sZc0S
         v+L5qFU/E23Zg3XoskoNZgSXDojlrSoRTWnW9S2uOhqoKe5gt2HCosD5bh51KlVDnd
         flG7waqG00wNJpTPlF1ZIip6TxilRlR7N03SwIQVsx9Kt0MlY0pcUlb651Z1C5X8aS
         jjTsIv0YG+ZXw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, YueHaibing <yuehaibing@huawei.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH] crypto: ccree - avoid out-of-range warnings from clang
Date:   Mon, 27 Sep 2021 14:18:03 +0200
Message-Id: <20210927121811.940899-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

clang points out inconsistencies in the FIELD_PREP() invocation in
this driver that result from the 'mask' being a 32-bit value:

drivers/crypto/ccree/cc_driver.c:117:18: error: result of comparison of constant 18446744073709551615 with expression of type 'u32' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
        cache_params |= FIELD_PREP(mask, val);
                        ^~~~~~~~~~~~~~~~~~~~~
include/linux/bitfield.h:94:3: note: expanded from macro 'FIELD_PREP'
                __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");    \
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/bitfield.h:52:28: note: expanded from macro '__BF_FIELD_CHECK'
                BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,         \
                ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This does not happen in other places that just pass a constant here.

Work around the warnings by widening the type of the temporary variable.

Fixes: 05c2a705917b ("crypto: ccree - rework cache parameters handling")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/ccree/cc_driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index e599ac6dc162..790fa9058a36 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -103,7 +103,8 @@ MODULE_DEVICE_TABLE(of, arm_ccree_dev_of_match);
 static void init_cc_cache_params(struct cc_drvdata *drvdata)
 {
 	struct device *dev = drvdata_to_dev(drvdata);
-	u32 cache_params, ace_const, val, mask;
+	u32 cache_params, ace_const, val;
+	u64 mask;
 
 	/* compute CC_AXIM_CACHE_PARAMS */
 	cache_params = cc_ioread(drvdata, CC_REG(AXIM_CACHE_PARAMS));
-- 
2.29.2

