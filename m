Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82EC3C7619A
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 11:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjDLLAu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjDLLAt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 07:00:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F206583
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:00:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4148632EC
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E2AC433D2;
        Wed, 12 Apr 2023 11:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681297247;
        bh=fjjSkL26Rl0SN2K1pYR6nlpj10ZyJ9lBNOZgWkj6f5E=;
        h=From:To:Cc:Subject:Date:From;
        b=YiALmVVV1YTt3sfo7qKsaXKDycIEkhe4ArBkk+S5esqPcDVh6TpaOfoZIjysVOmwP
         ky5KwAGpBEYJFcqle3Fge383TfjAGNqnSJy3zyCUPFs7zilT/ylX5KMY1oC9HJI9mo
         9M4fbRSk9LYxa/b9EJwfkwVUX3hXz4Qhvu3BRiV+EzQiKpalsVxnsa29Hr1HqVseJe
         UUe5hWg4yzuc7OB8UPjdwiS0pszCcWwtNdSxZCZPgfV0cfKe92AoGYz6H7kHBkfHxu
         vyiWTkhX8ipDwaCgRoJ6vnX0TM/6mpFLIYTeshRRAls9nr6bRsw+80mCYXpUGMkDPY
         3l8wiOHSAnebA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 00/13] crypto: x86 - avoid absolute references
Date:   Wed, 12 Apr 2023 13:00:22 +0200
Message-Id: <20230412110035.361447-1-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3094; i=ardb@kernel.org; h=from:subject; bh=fjjSkL26Rl0SN2K1pYR6nlpj10ZyJ9lBNOZgWkj6f5E=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWs31Gp3//N8yMfDGxtzyro1b2+Uaxz4NnebOftGlkNk bouNrUdpSwMYhwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCKcUxkZDqlZz7R14a5L2cWY njnPJXpOr3ZPzy755fc/uZlzCdwUY/hfM2eng8qamyJiabt7a86uWSswKct2pbJ37BFZyabf/En 8AA==
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is preparatory work for allowing the x86 kernel to be built as a
PIE executable, which relies mostly on RIP-relative symbol references
from code, as these don't need to be updated when a binary is loaded at
an address different from its link time address.

Most changes are quite straight-forward, i.e., just adding a (%rip)
suffix is enough in many cases. However, some are slightly trickier, and
need some minor reshuffling of the asm code to get rid of the absolute
references in the code.

Tested with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y on a x86 CPU that
implements AVX, AVX2 and AVX512.

Changes since v1:
- add missing tags from Thomas Garnier
- simplify AES-NI GCM tail handling and drop an entire permute vector
  table (patch #2)
- add a couple of patches to switch to local labels, which removes ~1000
  useless code symbols (e.g., _loop0, _loop1, _done etc etc) from
  kallsyms

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Kees Cook <keescook@chromium.org>

Ard Biesheuvel (13):
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
  crypto: x86/aesni - Use local .L symbols for code
  crypto: x86/crc32 - Use local .L symbols for code
  crypto: x86/sha - Use local .L symbols for code

 arch/x86/crypto/aegis128-aesni-asm.S         |   6 +-
 arch/x86/crypto/aesni-intel_asm.S            | 198 +++++++--------
 arch/x86/crypto/aesni-intel_avx-x86_64.S     | 254 +++++++++-----------
 arch/x86/crypto/aria-aesni-avx-asm_64.S      |  28 +--
 arch/x86/crypto/aria-aesni-avx2-asm_64.S     |  28 +--
 arch/x86/crypto/aria-gfni-avx512-asm_64.S    |  24 +-
 arch/x86/crypto/camellia-aesni-avx-asm_64.S  |  30 +--
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S |  30 +--
 arch/x86/crypto/camellia-x86_64-asm_64.S     |   6 +-
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S    |  38 +--
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S    |  32 +--
 arch/x86/crypto/crc32-pclmul_asm.S           |  16 +-
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S    |  70 +++---
 arch/x86/crypto/des3_ede-asm_64.S            |  96 +++++---
 arch/x86/crypto/ghash-clmulni-intel_asm.S    |   4 +-
 arch/x86/crypto/sha1_avx2_x86_64_asm.S       |  25 +-
 arch/x86/crypto/sha256-avx-asm.S             |  16 +-
 arch/x86/crypto/sha256-avx2-asm.S            |  54 +++--
 arch/x86/crypto/sha256-ssse3-asm.S           |  16 +-
 arch/x86/crypto/sha512-avx-asm.S             |   8 +-
 arch/x86/crypto/sha512-avx2-asm.S            |  16 +-
 arch/x86/crypto/sha512-ssse3-asm.S           |   8 +-
 22 files changed, 509 insertions(+), 494 deletions(-)

-- 
2.39.2

