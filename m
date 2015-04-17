From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 0/4] crypto: drbg - revamp locking
Date: Fri, 17 Apr 2015 14:53:26 +0200
Message-ID: <1551177.C0RmlOO9iU@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34161 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbbDQM44 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 08:56:56 -0400
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

Stephan Mueller (4):
  cryoto: drbg - clear all temporary memory
  crypto: drbg - do not create shadow copy
  crypto: drbg - replace spinlock with mutex
  crypto: drbg - leave cipher handles operational

 crypto/drbg.c         | 154 +++++++++-----------------------------------------
 include/crypto/drbg.h |   4 +-
 2 files changed, 30 insertions(+), 128 deletions(-)

-- 
2.1.0
