Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A240CC7EE24
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Jun 2023 17:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238134AbjFFRcH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Jun 2023 13:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238789AbjFFRcF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2023 13:32:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1357173A
        for <linux-crypto@vger.kernel.org>; Tue,  6 Jun 2023 10:31:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DC5E63064
        for <linux-crypto@vger.kernel.org>; Tue,  6 Jun 2023 17:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4950C433EF;
        Tue,  6 Jun 2023 17:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686072703;
        bh=SenzZA04SBARz5SHALjXD3CEiZyqx/fw/IV3A10m93E=;
        h=From:To:Cc:Subject:Date:From;
        b=Btjk/A69vb27cn+srMZzKj1btPxBIr7D8cf35y+drhfEHkZib6Yz0p7M6q/xp5j6T
         vGvAflj4UiHvo4wfOIjvM8Z7ZVC4C9jl19az5aF8TdWV1hcLhvEpbi40Moh0sfSCpJ
         5+lXUFTbUGyKLSAGbcdoCaxkwMoMaU9WJbHivPCH3jZcP9ZdU0YcYQ+3NVWep8N0v2
         Bg0dAuZG5i6G5aawOnO/2W8YjIyp9BOfPTb5KThUV5wmvp2RKPn7eTwOspSBLEdmCK
         fh2fqhqdcPcRTp7Oceyjqfa8mJTcAx8CPRulXf4frPSsnzNYu5gkVUxIT+wiscOQbg
         cXym77rrhe9Zw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 0/3] crypto - some SPDX cleanups for arch code
Date:   Tue,  6 Jun 2023 19:31:24 +0200
Message-Id: <20230606173127.4050254-1-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1830; i=ardb@kernel.org; h=from:subject; bh=SenzZA04SBARz5SHALjXD3CEiZyqx/fw/IV3A10m93E=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIaU+N0NBiGdaZd9OqdPBS2sFXULv7w/in7Ml8LVXaYoIy +9tHyM7SlkYxDgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwESYKhj+qUjF3rzt98jxzOaA 1imC4o/dhVqntf89xeQff9nTh+3oW0aGhzsWrPTTNak/ty3oxxf/lhWxFuYaQs3nRFeqfLvzi0e XGwA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some SPDX cleanups for the arch crypto code on ARM, arm64 and x86

Ard Biesheuvel (3):
  crypto: arm64 - add some missing SPDX headers
  crypto: arm - add some missing SPDX headers
  crypto: x86 - add some missing SPDX headers

 arch/arm/crypto/chacha-neon-core.S          | 10 +----
 arch/arm/crypto/crc32-ce-core.S             | 30 ++-----------
 arch/arm/crypto/crct10dif-ce-core.S         | 40 +----------------
 arch/arm64/crypto/chacha-neon-core.S        | 10 +----
 arch/arm64/crypto/chacha-neon-glue.c        | 10 +----
 arch/arm64/crypto/crct10dif-ce-core.S       | 40 +----------------
 arch/x86/crypto/aesni-intel_avx-x86_64.S    | 36 +--------------
 arch/x86/crypto/camellia-aesni-avx-asm_64.S |  7 +--
 arch/x86/crypto/crc32-pclmul_glue.c         | 24 +---------
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S   | 29 +-----------
 arch/x86/crypto/crct10dif-pcl-asm_64.S      | 36 +--------------
 arch/x86/crypto/crct10dif-pclmul_glue.c     | 16 +------
 arch/x86/crypto/sha1_avx2_x86_64_asm.S      | 46 +-------------------
 arch/x86/crypto/sha1_ni_asm.S               | 46 +-------------------
 arch/x86/crypto/sha256-avx-asm.S            | 28 +-----------
 arch/x86/crypto/sha256-avx2-asm.S           | 29 +-----------
 arch/x86/crypto/sha256-ssse3-asm.S          | 29 +-----------
 arch/x86/crypto/sha256_ni_asm.S             | 46 +-------------------
 arch/x86/crypto/sha256_ssse3_glue.c         | 15 +------
 arch/x86/crypto/sha512-avx-asm.S            | 29 +-----------
 arch/x86/crypto/sha512-avx2-asm.S           | 29 +-----------
 arch/x86/crypto/sha512-ssse3-asm.S          | 29 +-----------
 arch/x86/crypto/sha512_ssse3_glue.c         | 16 +------
 arch/x86/crypto/twofish_glue.c              | 16 +------
 24 files changed, 26 insertions(+), 620 deletions(-)

-- 
2.39.2

