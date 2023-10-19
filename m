Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2D6CDB465
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjJSFyP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSFyO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094FEB6
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B45C433C7
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694852;
        bh=WKL5XL42pxDMTfewB2BOVvTQQe1z44i5wMhuFiKiLIA=;
        h=From:To:Subject:Date:From;
        b=qnbkhtI7ZWST1sQUr1lc/2gsIGzbz6VHTArtRCTcSgNOFdifuhJK4DwTiet6jh512
         v5smibpKMUykwsZIxoiW6sI1OpnK3J6juOudNXC1hNvObLITSPx67mbLM8MbC+MksD
         lghnwxjn2k+wU7P3mfDtdQsJs8Lw5p4AMKbVcnCimpo8j9+ppz6XQJlcqdGoTiqV3W
         qoED2jvZSd0xkkGCuE5LBU1a67JKdO1LuUQ3ZPuZQEerIHcupXY+Ft3Zr5tWSSUR3g
         s2xapQ3xDAB+IELjRzj5ajLkoGCije9+xyWA3mTRtnmAZQQUBIJVlLhxHLLmkcOGUa
         gXfQ4hYNhBpyg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 00/17] crypto: stop supporting alignmask in shash
Date:   Wed, 18 Oct 2023 22:53:26 -0700
Message-ID: <20231019055343.588846-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The alignmask support in the shash algorithm type is virtually unused
and has no real point.  This patch series removes it in order to reduce
API overhead and complexity.

This series does not change anything for ahash.

Eric Biggers (17):
  crypto: sparc/crc32c - stop using the shash alignmask
  crypto: stm32 - remove unnecessary alignmask
  crypto: xilinx/zynqmp-sha - remove unnecessary alignmask
  crypto: mips/crc32 - remove redundant setting of alignmask to 0
  crypto: loongarch/crc32 - remove redundant setting of alignmask to 0
  crypto: cbcmac - remove unnecessary alignment logic
  crypto: cmac - remove unnecessary alignment logic
  crypto: hmac - remove unnecessary alignment logic
  crypto: vmac - don't set alignmask
  crypto: xcbc - remove unnecessary alignment logic
  crypto: shash - remove support for nonzero alignmask
  libceph: stop checking crypto_shash_alignmask
  crypto: drbg - stop checking crypto_shash_alignmask
  crypto: testmgr - stop checking crypto_shash_alignmask
  crypto: adiantum - stop using alignmask of shash_alg
  crypto: hctr2 - stop using alignmask of shash_alg
  crypto: shash - remove crypto_shash_alignmask

 arch/loongarch/crypto/crc32-loongarch.c |   2 -
 arch/mips/crypto/crc32-mips.c           |   2 -
 arch/sparc/crypto/crc32c_glue.c         |  45 +++++----
 crypto/adiantum.c                       |   3 +-
 crypto/ccm.c                            |  17 ++--
 crypto/cmac.c                           |  39 ++------
 crypto/drbg.c                           |   2 +-
 crypto/hctr2.c                          |   3 +-
 crypto/hmac.c                           |  56 ++++-------
 crypto/shash.c                          | 128 ++----------------------
 crypto/testmgr.c                        |   5 +-
 crypto/vmac.c                           |   1 -
 crypto/xcbc.c                           |  32 ++----
 drivers/crypto/stm32/stm32-crc32.c      |   2 -
 drivers/crypto/xilinx/zynqmp-sha.c      |   1 -
 include/crypto/hash.h                   |   6 --
 net/ceph/messenger_v2.c                 |   4 -
 17 files changed, 87 insertions(+), 261 deletions(-)


base-commit: 5b90073defd1a52aa8120403d79f6e0fc10c87ee
prerequisite-patch-id: 77bd65b07cfc27f172b1698e0c4d43d6aba7ad8f
prerequisite-patch-id: 3ccf94d7048db0fee9407b5b5fa48554e115b56b
prerequisite-patch-id: e447f81a392f2f3955206357d72032cf691c7e11
-- 
2.42.0

