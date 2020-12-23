Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 892CDC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C32E22482
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgLWINe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:13:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727605AbgLWINe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 03:13:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C6742070B;
        Wed, 23 Dec 2020 08:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608711173;
        bh=tN99mdHWsY6e6cP6tzOV01sZWDK4WK/EqQsMqjncM3M=;
        h=From:To:Cc:Subject:Date:From;
        b=ptN99YZ7I9kS6I6H3+WvXnJDDWGQvEDnX/MhajnEoMTX8Tpwl30/gMTB5KncEX8NH
         FegmdJdyIogKtsKn14XrUXHR+760inq+tdLrPojcRD73vB6CTUSG4AToHBcCUWXtF9
         cZyamHQjCXCus1YQ2v4bk8nhGlC24dR0ULVplG/a3mAybOiiwOvB/xo2SzKJuNr1US
         i3J5tzCpsQfc+zOlhMYmWcY8B0btD7tzhYG1sUsBXgiA1hXNvnmJsM8PSft8k/VduT
         ejM5g+HI+Awk4ixqznDcFq3yusxSpmc3K1zvqaD/oh5qqSfyhawQeYxeG+zrocWrfO
         dZpy5+/GcAJoA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v3 00/14] crypto: arm32-optimized BLAKE2b and BLAKE2s
Date:   Wed, 23 Dec 2020 00:09:49 -0800
Message-Id: <20201223081003.373663-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset adds 32-bit ARM assembly language implementations of
BLAKE2b and BLAKE2s.

As a prerequisite to adding these without copy-and-pasting lots of code,
this patchset also reworks the existing BLAKE2b and BLAKE2s code to
provide helper functions that make implementing "shash" providers for
these algorithms much easier.  These changes also eliminate unnecessary
differences between the BLAKE2b and BLAKE2s code.

The new BLAKE2b implementation is NEON-accelerated, while the new
BLAKE2s implementation uses scalar instructions since NEON doesn't work
very well for it.  The BLAKE2b implementation is faster and is expected
to be useful as a replacement for SHA-1 in dm-verity, while the BLAKE2s
implementation would be useful for WireGuard which uses BLAKE2s.

Both new implementations are wired up to the shash API, while the new
BLAKE2s implementation is also wired up to the library API.

See the individual commits for full details, including benchmarks.

This patchset was tested on a Raspberry Pi 2 (which uses a Cortex-A7
processor) with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, plus other tests.

This patchset applies to mainline commit 614cb5894306.

Changed since v2:
   - Reworked the shash helpers again.  Now they are inline functions,
     and for BLAKE2s they now share more code with the library API.
   - Made the BLAKE2b code be more consistent with the BLAKE2s code.
   - Moved the BLAKE2s changes first in the patchset so that the BLAKE2b
     changes can be made just by syncing the code with BLAKE2s.
   - Added a few BLAKE2s cleanups (which get included in BLAKE2b too).
   - Improved some comments in the new asm files.

Changed since v1:
   - Added ARM scalar implementation of BLAKE2s.
   - Adjusted the BLAKE2b helper functions to be consistent with what I
     decided to do for BLAKE2s.
   - Fixed build error in blake2b-neon-core.S in some configurations.

Eric Biggers (14):
  crypto: blake2s - define shash_alg structs using macros
  crypto: x86/blake2s - define shash_alg structs using macros
  crypto: blake2s - remove unneeded includes
  crypto: blake2s - move update and final logic to internal/blake2s.h
  crypto: blake2s - share the "shash" API boilerplate code
  crypto: blake2s - optimize blake2s initialization
  crypto: blake2s - add comment for blake2s_state fields
  crypto: blake2s - adjust include guard naming
  crypto: blake2s - include <linux/bug.h> instead of <asm/bug.h>
  crypto: arm/blake2s - add ARM scalar optimized BLAKE2s
  wireguard: Kconfig: select CRYPTO_BLAKE2S_ARM
  crypto: blake2b - sync with blake2s implementation
  crypto: blake2b - update file comment
  crypto: arm/blake2b - add NEON-accelerated BLAKE2b

 arch/arm/crypto/Kconfig             |  19 ++
 arch/arm/crypto/Makefile            |   4 +
 arch/arm/crypto/blake2b-neon-core.S | 347 ++++++++++++++++++++++++++++
 arch/arm/crypto/blake2b-neon-glue.c | 105 +++++++++
 arch/arm/crypto/blake2s-core.S      | 285 +++++++++++++++++++++++
 arch/arm/crypto/blake2s-glue.c      |  78 +++++++
 arch/x86/crypto/blake2s-glue.c      | 150 +++---------
 crypto/blake2b_generic.c            | 249 +++++---------------
 crypto/blake2s_generic.c            | 158 +++----------
 drivers/net/Kconfig                 |   1 +
 include/crypto/blake2b.h            |  67 ++++++
 include/crypto/blake2s.h            |  63 ++---
 include/crypto/internal/blake2b.h   | 115 +++++++++
 include/crypto/internal/blake2s.h   | 109 ++++++++-
 lib/crypto/blake2s.c                |  48 +---
 15 files changed, 1278 insertions(+), 520 deletions(-)
 create mode 100644 arch/arm/crypto/blake2b-neon-core.S
 create mode 100644 arch/arm/crypto/blake2b-neon-glue.c
 create mode 100644 arch/arm/crypto/blake2s-core.S
 create mode 100644 arch/arm/crypto/blake2s-glue.c
 create mode 100644 include/crypto/blake2b.h
 create mode 100644 include/crypto/internal/blake2b.h


base-commit: 614cb5894306cfa2c7d9b6168182876ff5948735
-- 
2.29.2

