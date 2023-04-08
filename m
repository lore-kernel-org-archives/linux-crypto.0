Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C4EC7619A
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Apr 2023 15:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjDHP1k (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Apr 2023 11:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDHP1j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Apr 2023 11:27:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072E32728
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 08:27:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96A8760AAF
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 15:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C30C433EF;
        Sat,  8 Apr 2023 15:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680967658;
        bh=SK4bJcghYhzS7aiZ7Whg9J6EtWf5VeIz4iKAQnRpO+4=;
        h=From:To:Cc:Subject:Date:From;
        b=DqFLXXR0E86/u01AVXPSnjKStPIzyY1s9+BnqPXZ9DOkgXs1WV+PMDCuSoCdHYdvK
         cxyvHuaEdBvW/rQoiIbMG8FHd2DSa7MFRSdRsTpbPsYAYam1vgPu3nZnFbJpihPy0H
         figi4bPPw8WJ/0OLBr6G6tZ719PYyYtd/LXmCXXI0i7jHVNFlNDloNtBfUjuoHy7CP
         Rg6+MqCUBz9Rij6IoUasw/IQJ4IZZKrIEKEwn0v3cH4obInjNwGnQXa4jqN0o8HNnF
         So5oxB+juwXSyyTxnmldweIbGrWWMF5o4NC4CAQjmpMSYMmojDdZGG/xMTFt0tBOOr
         PlUSxR8FcBVCg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 00/10] crypto: x86 - avoid absolute references
Date:   Sat,  8 Apr 2023 17:27:12 +0200
Message-Id: <20230408152722.3975985-1-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2222; i=ardb@kernel.org; h=from:subject; bh=SK4bJcghYhzS7aiZ7Whg9J6EtWf5VeIz4iKAQnRpO+4=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWw/axVLK/gppqXso/3cm1b7d/eMXVLmXmbs1i/yqzDU ZVHT77qKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABM5JsLIsG5F9vP5Kd0dXxJN Vi9mYGCOPOIp5CO/SnPNAd4+haWGSxn+u8dwTH1jGOZp+GZeV7BWaxm/uhSf63sRk6TuX1Murkz gBAA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is preparatory work for allowing the kernel to be built as a PIE
executable, which relies mostly on RIP-relative symbol references from
code, which don't need to be updated when a binary is loaded at an
address different from its link time address.

Most changes are quite straight-forward, i.e., just adding a (%rip)
suffix is enough in many cases. However, some are slightly trickier, and
need some minor reshuffling of the asm code to get rid of the absolute
references in the code.

Tested with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y on a x86 CPU that
implements AVX, AVX2 and AVX512.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Kees Cook <keescook@chromium.org>

Ard Biesheuvel (10):
  crypto: x86/aegis128 - Use RIP-relative addressing
  crypto: x86/aesni - Use RIP-relative addressing
  crypto: x86/aria - Use RIP-relative addressing
  crypto: x86/camellia - Use RIP-relative addressing
  crypto: x86/cast5 - Use RIP-relative addressing
  crypto: x86/cast6 - Use RIP-relative addressing
  crypto: x86/crc32c - Use RIP-relative addressing
  crypto: x86/des3 - Use RIP-relative addressing
  crypto: x86/ghash - Use RIP-relative addressing
  crypto: x86/sha256 - Use RIP-relative addressing

 arch/x86/crypto/aegis128-aesni-asm.S         |  6 +-
 arch/x86/crypto/aesni-intel_asm.S            |  2 +-
 arch/x86/crypto/aesni-intel_avx-x86_64.S     |  6 +-
 arch/x86/crypto/aria-aesni-avx-asm_64.S      | 28 +++---
 arch/x86/crypto/aria-aesni-avx2-asm_64.S     | 28 +++---
 arch/x86/crypto/aria-gfni-avx512-asm_64.S    | 24 ++---
 arch/x86/crypto/camellia-aesni-avx-asm_64.S  | 30 +++---
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S | 30 +++---
 arch/x86/crypto/camellia-x86_64-asm_64.S     |  8 +-
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S    | 50 +++++-----
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S    | 44 +++++----
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S    |  3 +-
 arch/x86/crypto/des3_ede-asm_64.S            | 96 +++++++++++++-------
 arch/x86/crypto/ghash-clmulni-intel_asm.S    |  4 +-
 arch/x86/crypto/sha256-avx2-asm.S            | 18 ++--
 15 files changed, 213 insertions(+), 164 deletions(-)

-- 
2.39.2

