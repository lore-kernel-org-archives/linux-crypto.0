Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C5CC43217
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 19:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbiKRTqa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 14:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235446AbiKRTq2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 14:46:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DC88CFF9
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 11:46:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8515862762
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 19:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4AAC433C1;
        Fri, 18 Nov 2022 19:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668800783;
        bh=pRruGOUsFyZsKb+BNIESqnaa7mp7RB+efAYZD68W7hA=;
        h=From:To:Cc:Subject:Date:From;
        b=X1SQLTidNZJv2ERVwOZ8JKwakO4kxNgRU71p2Fe2+P3djxyakCkM/Wi4HaXbXoHER
         sxveURIIPxqJ0E+Eujq9mnedZ05QweQuUwdH0H2CUfi/Xry9yu+ycXq7xv5yLe+8af
         7Yga+eDdR/P8Hjq7wkEKRn23XPgK/+EZuDFDeIHsDexPXTEfwugR2qTZLaQrMYeXPo
         jfXUwuACTlzY2WgubcjUpgYjVXMKgXgpHz+mhl9em4S0I44np3QvwP0Msvh2UG3TkN
         v/azqurLBkhMD3LTugIf42yuaxOFHztwu9BugZBTmhovZ7W9OmzY4IkjY+bAlyMszA
         gL2pCJIoeisuw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH v2 00/12] crypto: CFI fixes
Date:   Fri, 18 Nov 2022 11:44:09 -0800
Message-Id: <20221118194421.160414-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series fixes some crashes when CONFIG_CFI_CLANG (Control Flow
Integrity) is enabled, with the new CFI implementation that was merged
in 6.1 and is supported on x86.  Some of them were unconditional
crashes, while others depended on whether the compiler optimized out the
indirect calls or not.  This series also simplifies some code that was
intended to work around limitations of the old CFI implementation and is
unnecessary for the new CFI implementation.

Changed in v2:
  - Added patch "crypto: x86/sm4 - fix crash with CFI enabled"
  - Restored accidentally-deleted include of <asm/assembler.h>
  - Tweaked some commit messages and added Reviewed-by and Acked-by tags

Eric Biggers (12):
  crypto: x86/aegis128 - fix possible crash with CFI enabled
  crypto: x86/aria - fix crash with CFI enabled
  crypto: x86/nhpoly1305 - eliminate unnecessary CFI wrappers
  crypto: x86/sha1 - fix possible crash with CFI enabled
  crypto: x86/sha256 - fix possible crash with CFI enabled
  crypto: x86/sha512 - fix possible crash with CFI enabled
  crypto: x86/sm3 - fix possible crash with CFI enabled
  crypto: x86/sm4 - fix crash with CFI enabled
  crypto: arm64/nhpoly1305 - eliminate unnecessary CFI wrapper
  crypto: arm64/sm3 - fix possible crash with CFI enabled
  crypto: arm/nhpoly1305 - eliminate unnecessary CFI wrapper
  Revert "crypto: shash - avoid comparing pointers to exported functions
    under CFI"

 arch/arm/crypto/nh-neon-core.S           |  2 +-
 arch/arm/crypto/nhpoly1305-neon-glue.c   | 11 ++---------
 arch/arm64/crypto/nh-neon-core.S         |  5 +++--
 arch/arm64/crypto/nhpoly1305-neon-glue.c | 11 ++---------
 arch/arm64/crypto/sm3-neon-core.S        |  3 ++-
 arch/x86/crypto/aegis128-aesni-asm.S     |  9 +++++----
 arch/x86/crypto/aria-aesni-avx-asm_64.S  | 13 +++++++------
 arch/x86/crypto/nh-avx2-x86_64.S         |  5 +++--
 arch/x86/crypto/nh-sse2-x86_64.S         |  5 +++--
 arch/x86/crypto/nhpoly1305-avx2-glue.c   | 11 ++---------
 arch/x86/crypto/nhpoly1305-sse2-glue.c   | 11 ++---------
 arch/x86/crypto/sha1_ni_asm.S            |  3 ++-
 arch/x86/crypto/sha1_ssse3_asm.S         |  3 ++-
 arch/x86/crypto/sha256-avx-asm.S         |  3 ++-
 arch/x86/crypto/sha256-avx2-asm.S        |  3 ++-
 arch/x86/crypto/sha256-ssse3-asm.S       |  3 ++-
 arch/x86/crypto/sha256_ni_asm.S          |  3 ++-
 arch/x86/crypto/sha512-avx-asm.S         |  3 ++-
 arch/x86/crypto/sha512-avx2-asm.S        |  3 ++-
 arch/x86/crypto/sha512-ssse3-asm.S       |  3 ++-
 arch/x86/crypto/sm3-avx-asm_64.S         |  3 ++-
 arch/x86/crypto/sm4-aesni-avx-asm_64.S   |  7 ++++---
 arch/x86/crypto/sm4-aesni-avx2-asm_64.S  |  7 ++++---
 crypto/shash.c                           | 18 +++---------------
 include/crypto/internal/hash.h           |  8 +++++++-
 25 files changed, 70 insertions(+), 86 deletions(-)


base-commit: 75df46b598b5b46b0857ee7d2410deaf215e23d1
-- 
2.38.1

