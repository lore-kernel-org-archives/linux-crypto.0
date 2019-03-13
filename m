Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27981C10F0B
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEE9921874
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552454137;
	bh=BqPvHNXBcRhNcwcIcSrdUJEo7We8vHaELp4KXksgxsc=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=AMfFuHog3TwBLo/j/SjyUoWXSNWyne6RG0ISl4liG+QrutmcEvrPVNGc+8F5m1KG4
	 c4wHMUsgZ/DbDwjk0AEPqGZUdI0P7Np28iqPcVHmMP1ecMnJItWAkpM6guXYntmFsn
	 cdSpPhvUa054aoRWV/gjjniS3t19b83yGR0Q2q1E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfCMFPg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 01:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfCMFPf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 01:15:35 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2D4B205C9;
        Wed, 13 Mar 2019 05:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552454134;
        bh=BqPvHNXBcRhNcwcIcSrdUJEo7We8vHaELp4KXksgxsc=;
        h=From:To:Cc:Subject:Date:From;
        b=s2Yx8MYxZcp/bHGeZ7cVjpG6HlfSNsUFit276r/V40G/QJVw2MSpsbECchDDLUnaV
         pBQ7Sy7BrSdRKNcwcssMqQojQIcRnVtDg1PJIm7MhYOvzmaCcuFafTRagSUnX8gBBJ
         AG7z5TxwcJiQi2TUxGqIywG+4/6OQbX4yPuI4ExU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: [PATCH 0/8] crypto: test the !may_use_simd() fallback code
Date:   Tue, 12 Mar 2019 22:12:44 -0700
Message-Id: <20190313051252.2917-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

All crypto API algorithms are supposed to support the case where they
are called in a context where SIMD instructions are unusable, e.g. IRQ
context on some architectures.  However, this isn't tested for by the
self-tests, causing bugs to go undetected.

This patch series therefore updates the self-tests to test the no-SIMD
code.  It works by converting all may_use_simd() checks to a new macro
crypto_simd_usable(), which also returns false when the self-tests have
disabled SIMD in crypto algorithms on the current CPU for test purposes.

For now, all no-SIMD testing is limited to the extra crypto self-tests,
because it might be a bit too invasive for the regular self-tests.
But this could be changed later.

This already found bugs in the arm64 implementations of AES-GCM and
ChaCha.  These are fixed by the first two patches.  Following this, the
tests pass on x86, arm, and arm64.

This patch series is based on top of my other pending patch series
"crypto: add SIMD helpers for AEADs".  It can also be found in git at:

    URL:     https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
    Branch:  crypto-nosimd-tests

Eric Biggers (8):
  crypto: chacha-generic - fix use as arm64 no-NEON fallback
  crypto: arm64/gcm-aes-ce - fix no-NEON fallback code
  crypto: simd,testmgr - introduce crypto_simd_usable()
  crypto: x86 - convert to use crypto_simd_usable()
  crypto: arm - convert to use crypto_simd_usable()
  crypto: arm64 - convert to use crypto_simd_usable()
  crypto: simd - convert to use crypto_simd_usable()
  crypto: testmgr - test the !may_use_simd() fallback code

 arch/arm/crypto/chacha-neon-glue.c         |   5 +-
 arch/arm/crypto/crc32-ce-glue.c            |   5 +-
 arch/arm/crypto/crct10dif-ce-glue.c        |   3 +-
 arch/arm/crypto/ghash-ce-glue.c            |   7 +-
 arch/arm/crypto/nhpoly1305-neon-glue.c     |   3 +-
 arch/arm/crypto/sha1-ce-glue.c             |   5 +-
 arch/arm/crypto/sha1_neon_glue.c           |   5 +-
 arch/arm/crypto/sha2-ce-glue.c             |   5 +-
 arch/arm/crypto/sha256_neon_glue.c         |   5 +-
 arch/arm/crypto/sha512-neon-glue.c         |   5 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c        |   7 +-
 arch/arm64/crypto/aes-ce-glue.c            |   5 +-
 arch/arm64/crypto/aes-glue.c               |   4 +-
 arch/arm64/crypto/aes-neonbs-glue.c        |   2 +-
 arch/arm64/crypto/chacha-neon-glue.c       |   5 +-
 arch/arm64/crypto/crct10dif-ce-glue.c      |   5 +-
 arch/arm64/crypto/ghash-ce-glue.c          |  17 ++-
 arch/arm64/crypto/nhpoly1305-neon-glue.c   |   3 +-
 arch/arm64/crypto/sha1-ce-glue.c           |   7 +-
 arch/arm64/crypto/sha2-ce-glue.c           |   7 +-
 arch/arm64/crypto/sha256-glue.c            |   5 +-
 arch/arm64/crypto/sha3-ce-glue.c           |   5 +-
 arch/arm64/crypto/sha512-ce-glue.c         |   7 +-
 arch/arm64/crypto/sm3-ce-glue.c            |   7 +-
 arch/arm64/crypto/sm4-ce-glue.c            |   5 +-
 arch/x86/crypto/aesni-intel_glue.c         |   8 +-
 arch/x86/crypto/chacha_glue.c              |   6 +-
 arch/x86/crypto/crc32-pclmul_glue.c        |   5 +-
 arch/x86/crypto/crc32c-intel_glue.c        |   7 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c    |   7 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c |   9 +-
 arch/x86/crypto/nhpoly1305-avx2-glue.c     |   5 +-
 arch/x86/crypto/nhpoly1305-sse2-glue.c     |   5 +-
 arch/x86/crypto/poly1305_glue.c            |   4 +-
 arch/x86/crypto/sha1_ssse3_glue.c          |   7 +-
 arch/x86/crypto/sha256_ssse3_glue.c        |   7 +-
 arch/x86/crypto/sha512_ssse3_glue.c        |  10 +-
 crypto/chacha_generic.c                    |   2 +-
 crypto/simd.c                              |   8 +-
 crypto/testmgr.c                           | 142 +++++++++++++++++----
 include/crypto/internal/simd.h             |  24 ++++
 41 files changed, 272 insertions(+), 123 deletions(-)

-- 
2.21.0

