From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 0/8] random: cleanup of code after removal of nonblocking pool
Date: Tue, 27 Dec 2016 23:38:42 +0100
Message-ID: <3254875.f5A5oHPdxF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55170 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933084AbcL0Wnr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 17:43:47 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ted,

with the removal of the nonblocking_pool, several code paths are now unused
which were only applicable to the nonblocking pool. This patch set removes
these unused code paths.

Also, a code path in the add_interrupt_randomness function that is never used
is removed.

In addition, the FIPS 140-2 continuous self tests are required to process
the output data of the RNG given to a caller. A patch is added to cover this
requirement.

Ciao
Stephan

Stephan Mueller (8):
  random: remove stale maybe_reseed_primary_crng
  random: remove stale urandom_init_wait
  random: trigger random_ready callback upon crng_init == 1
  random: remove unused branch in hot code path
  random: remove variable limit
  random: fix comment for unused random_min_urandom_seed
  random: remove noop function call to xfer_secondary_pool
  random: move FIPS continuous test to output functions

 drivers/char/random.c | 118 +++++++++++++++++++++++---------------------------
 1 file changed, 53 insertions(+), 65 deletions(-)

-- 
2.9.3
