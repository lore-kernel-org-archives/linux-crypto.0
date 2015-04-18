From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 0/3] crypto: drbg - revamp locking
Date: Sat, 18 Apr 2015 19:35:11 +0200
Message-ID: <1702481.h2hMdNkdaF@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34200 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153AbbDRRiq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Apr 2015 13:38:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

the current implementation of the DRBG generates a shadow copy of its
DRBG state for each incoming request. The idea is that only a short
term lock is needed to spawn the shadow copy. The drawback is that
if multiple parallel requests come in, the generated DRBG shadow
states only differ by a high-resolution timer that was mixed in during
the shadow state generation.

This patch now removes this shadow state and introduces a mutex
to serialize all requests to one DRBG instance.

The patch was fully CAVS tested and demonstrates that the DRBG still
complies with the standard.

Changes v2:
* fix return code check of drbg_generate in drbg_generate_long
* move mutex_init to drbg_kcapi_init to ensure the mutex is initialized
  only during the instantiation of a DRBG and during a reset
* merge the patch for replacing the spinlock with a mutex and the removal
  of the shadow copy generation as both patches cannot stand alone and would
  therefore break bisection
* drop patch that fixes the memory release (Herbert: you mentioned the patch
  is applied but it is not yet in the repo -- this patch is vital as otherwise
  AES192 now breaks without the shadow copy operation)

Changes v3:
* patch for fixing the return code handling in drbg_generate_long did not
  cover all code paths -- now the issue should be truly fixed

Stephan Mueller (3):
  crypto: drbg - fix drbg_generate return val check
  crypto: drbg - replace spinlock with mutex
  crypto: drbg - leave cipher handles operational

 crypto/drbg.c         | 166 +++++++++++---------------------------------------
 include/crypto/drbg.h |   4 +-
 2 files changed, 36 insertions(+), 134 deletions(-)

-- 
2.1.0
