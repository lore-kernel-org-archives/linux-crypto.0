Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 429E1C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFDB222BEF
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389043AbhAKQxc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:53:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387781AbhAKQxc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 11:53:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B9D92242A;
        Mon, 11 Jan 2021 16:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610383971;
        bh=5HRV2/TClvP4VhmXNhXks/gpsart+RcJPw4RtSy5/Og=;
        h=From:To:Cc:Subject:Date:From;
        b=c9b03jHXNSuAZSVXb05/KOK1rFoqk5DlfcfwwZNMu5TwuJPtg0NjjCkQ/ShdBqrBS
         CHIRhT2JYrt1rthfLqr5NbKKNEqTFqNTqbSmdZSNBE1GrtEm1ajmW3sd9vlndDNcLF
         7GS/IO0P1M8mSQOVoajtfZCbnVy9SILLEqRiE+tM44q0xbZcPbBZPsPzKSoishggYX
         G7/dMgX4eOwJ98ZnruxMDe7FgSYoSBiD5fxryKGlFWUBr7ErTQaUPVFPCBS6Gg3UKk
         PXJtzjeK9fDMCo68czPd4Td+mVZXDBLPF/IeVL6+qNUmGem5GTYPl+Cyp9fD/1H55D
         gnDsJcc5av2Bw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/7] crypto: switch to static calls for CRC-T10DIF
Date:   Mon, 11 Jan 2021 17:52:30 +0100
Message-Id: <20210111165237.18178-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CRC-T10DIF is a very poor match for the crypto API:
- every user in the kernel calls it via a library wrapper around the
  shash API, so all callers share a single instance of the transform
- each architecture provides at most a single optimized implementation,
  based on SIMD instructions for carryless multiplication

In other words, none of the flexibility it provides is put to good use,
and so it is better to get rid of this complexity, and expose the optimized
implementations via static calls instead. This removes a substantial chunk
of code, and also gets rid of any indirect calls on architectures that
obsess about those (x86)

If this approach is deemed suitable, there are other places where we might
consider adopting it: CRC32 and CRC32(C).

Patch #1 does some preparatory refactoring and removes the library wrapper
around the shash transform.

Patch #2 introduces the actual static calls, along with the registration
routines to update the crc-t10dif implementation at runtime.

Patch #3 updates the generic CRC-T10DIF shash driver so it distinguishes
between the optimized library code and the generic library code.

Patches #4 to #7 update the various arch implementations to switch over to
the new method.

Special request to Peter to take a look at patch #2, and in particular,
whether synchronize_rcu_tasks() is sufficient to ensure that a module
providing the target of a static call can be unloaded safely.
 
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>

Ard Biesheuvel (7):
  crypto: crc-t10dif - turn library wrapper for shash into generic
    library
  crypto: lib/crc-t10dif - add static call support for optimized
    versions
  crypto: generic/crc-t10dif - expose both arch and generic shashes
  crypto: x86/crc-t10dif - convert to static call library API
  crypto: arm/crc-t10dif - convert to static call library API
  crypto: arm64/crc-t10dif - convert to static call API
  crypto: powerpc/crc-t10dif - convert to static call API

 arch/arm/crypto/Kconfig                     |   2 +-
 arch/arm/crypto/crct10dif-ce-glue.c         |  58 ++------
 arch/arm64/crypto/Kconfig                   |   3 +-
 arch/arm64/crypto/crct10dif-ce-glue.c       |  85 ++---------
 arch/powerpc/crypto/crct10dif-vpmsum_glue.c |  51 +------
 arch/x86/crypto/crct10dif-pclmul_glue.c     |  90 ++----------
 crypto/Kconfig                              |   7 +-
 crypto/Makefile                             |   2 +-
 crypto/crct10dif_common.c                   |  82 -----------
 crypto/crct10dif_generic.c                  | 100 +++++++++----
 include/linux/crc-t10dif.h                  |  21 ++-
 lib/Kconfig                                 |   2 -
 lib/crc-t10dif.c                            | 152 +++++++++-----------
 13 files changed, 204 insertions(+), 451 deletions(-)
 delete mode 100644 crypto/crct10dif_common.c

-- 
2.17.1

