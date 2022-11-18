Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1C9C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241436AbiKRJET (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241530AbiKRJEM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:04:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3F41143
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 01:04:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6F99B810DF
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 09:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31645C433D6;
        Fri, 18 Nov 2022 09:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668762247;
        bh=KRw+9QU2Y+5Ndy6X4gvLNK6thFtjiYVI50HPGDvhIC0=;
        h=From:To:Cc:Subject:Date:From;
        b=Em5RV/Y+F5ofQTN99D7pT/yt3tbdNQI4xxUUkHbSIVkiWgirgtaqGRE1iIzGP22f1
         zaP02BMDZZ4RUMZKUgsdqhXyRYnphu2j8pRWTyntakod3AAbupfdGm3JM8IfYgRZZv
         e7E6OcF+lsDugD5xNEiNzkONGZYEu6LD5mCkoD4TLcDlOvQKur8YO1INC36L5svOY/
         2I1R0muUY+L/FdiH4zB3ySfaGKGAJb9jqyc8AO8t+uOt9NoH8hP+HhIsqz9T/QqLu5
         q261W8CFtO4aLBy+3keknkgWY9ASr//Oe1D/fYD6r/85OroeI43FfS/THHdu33uXUE
         BXn3/FI12T6tw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 0/11] crypto: CFI fixes
Date:   Fri, 18 Nov 2022 01:02:09 -0800
Message-Id: <20221118090220.398819-1-ebiggers@kernel.org>
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

Eric Biggers (11):
  crypto: x86/aegis128 - fix crash with CFI enabled
  crypto: x86/aria - fix crash with CFI enabled
  crypto: x86/nhpoly1305 - eliminate unnecessary CFI wrappers
  crypto: x86/sha1 - fix possible crash with CFI enabled
  crypto: x86/sha256 - fix possible crash with CFI enabled
  crypto: x86/sha512 - fix possible crash with CFI enabled
  crypto: x86/sm3 - fix possible crash with CFI enabled
  crypto: arm64/nhpoly1305 - eliminate unnecessary CFI wrapper
  crypto: arm64/sm3 - fix possible crash with CFI enabled
  crypto: arm/nhpoly1305 - eliminate unnecessary CFI wrapper
  Revert "crypto: shash - avoid comparing pointers to exported functions
    under CFI"

 arch/arm/crypto/nh-neon-core.S           |  2 +-
 arch/arm/crypto/nhpoly1305-neon-glue.c   | 11 ++---------
 arch/arm64/crypto/nh-neon-core.S         |  5 +++--
 arch/arm64/crypto/nhpoly1305-neon-glue.c | 11 ++---------
 arch/arm64/crypto/sm3-neon-core.S        |  4 ++--
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
 crypto/shash.c                           | 18 +++---------------
 include/crypto/internal/hash.h           |  8 +++++++-
 23 files changed, 62 insertions(+), 81 deletions(-)


base-commit: 557ffd5a4726f8b6f0dd1d4b632ae02c1c063233
-- 
2.38.1

