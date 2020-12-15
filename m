Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DC3C3526C
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78B3E22D05
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgLPABd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:01:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbgLOXya (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Dec 2020 18:54:30 -0500
From:   Eric Biggers <ebiggers@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH 0/5] crypto: add NEON-optimized BLAKE2b
Date:   Tue, 15 Dec 2020 15:47:03 -0800
Message-Id: <20201215234708.105527-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset adds a NEON implementation of BLAKE2b for 32-bit ARM.
Patches 1-4 prepare for it by making some updates to the generic
implementation, while patch 5 adds the actual NEON implementation.

On Cortex-A7 (which these days is the most common ARM processor that
doesn't have the ARMv8 Crypto Extensions), this is over twice as fast as
SHA-256, and slightly faster than SHA-1.  It is also almost three times
as fast as the generic implementation of BLAKE2b:

	Algorithm            Cycles per byte (on 4096-byte messages)
	===================  =======================================
	blake2b-256-neon     14.1
	sha1-neon            16.4
	sha1-asm             20.8
	blake2s-256-generic  26.1
	sha256-neon	     28.9
	sha256-asm	     32.1
	blake2b-256-generic  39.9

This implementation isn't directly based on any other implementation,
but it borrows some ideas from previous NEON code I've written as well
as from chacha-neon-core.S.  At least on Cortex-A7, it is faster than
the other NEON implementations of BLAKE2b I'm aware of (the
implementation in the BLAKE2 official repository using intrinsics, and
Andrew Moon's implementation which can be found in SUPERCOP).

NEON-optimized BLAKE2b is useful because there is interest in using
BLAKE2b-256 for dm-verity on low-end Android devices (specifically,
devices that lack the ARMv8 Crypto Extensions) to replace SHA-1.  On
these devices, the performance cost of upgrading to SHA-256 may be
unacceptable, whereas BLAKE2b-256 would actually improve performance.

Although BLAKE2b is intended for 64-bit platforms (unlike BLAKE2s which
is intended for 32-bit platforms), on 32-bit ARM processors with NEON,
BLAKE2b is actually faster than BLAKE2s.  This is because NEON supports
64-bit operations, and because BLAKE2s's block size is too small for
NEON to be helpful for it.  The best I've been able to do with BLAKE2s
on Cortex-A7 is 19.0 cpb with an optimized scalar implementation.

(I didn't try BLAKE2sp and BLAKE3, which in theory would be faster, but
they're more complex as they require running multiple hashes at once.
Note that BLAKE2b already uses all the NEON bandwidth on the Cortex-A7,
so I expect that any speedup from BLAKE2sp or BLAKE3 would come only
from the smaller number of rounds, not from the extra parallelism.)

This patchset was tested on a Raspberry Pi 2, including with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.

Eric Biggers (5):
  crypto: blake2b - rename constants for consistency with blake2s
  crypto: blake2b - define shash_alg structs using macros
  crypto: blake2b - export helpers for optimized implementations
  crypto: blake2b - update file comment
  crypto: arm/blake2b - add NEON-optimized BLAKE2b implementation

 arch/arm/crypto/Kconfig             |  10 +
 arch/arm/crypto/Makefile            |   2 +
 arch/arm/crypto/blake2b-neon-core.S | 357 ++++++++++++++++++++++++++++
 arch/arm/crypto/blake2b-neon-glue.c | 105 ++++++++
 crypto/blake2b_generic.c            | 205 +++++++---------
 include/crypto/blake2b.h            |  54 +++++
 6 files changed, 619 insertions(+), 114 deletions(-)
 create mode 100644 arch/arm/crypto/blake2b-neon-core.S
 create mode 100644 arch/arm/crypto/blake2b-neon-glue.c
 create mode 100644 include/crypto/blake2b.h


base-commit: 3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9
-- 
2.29.2

