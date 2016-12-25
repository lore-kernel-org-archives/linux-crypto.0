From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 0/2] crypto: AF_ALG memory management fix
Date: Sun, 25 Dec 2016 18:13:49 +0100
Message-ID: <1486189.x0AQ4O6r2j@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54984 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751516AbcLYRQa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Dec 2016 12:16:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

please find attached memory management updates to

- simplify the code: the old AIO memory management is very
  complex and seemingly very fragile -- the update now
  eliminates all reported bugs in the skcipher and AEAD
  interfaces which allowed the kernel to be crashed by
  an unprivileged user

- streamline the code: there is one code path for AIO and sync
  operation; the code between algif_skcipher and algif_aead
  is very similar (if that patch set is accepted, I volunteer
  to reduce code duplication by moving service operations
  into af_alg.c and to further unify the TX SGL handling)

- unify the AIO and sync operation which only differ in the
  kernel crypto API callback and whether to wait for the
  crypto operation or not

- fix all reported bugs regarding the handling of multiple
  IOCBs.

The following testing was performed:

- stress testing to verify that no memleaks exist

- testing using Tadeusz Struck AIO test tool (see
  https://github.com/tstruk/afalg_async_test) -- the AEAD test
  is not applicable any more due to the changed user space
  interface; the skcipher test works once the user space
  interface change is honored in the test code

- using the libkcapi test suite, all tests including the
  originally failing ones (AIO with multiple IOCBs) work now --
  the current libkcapi code artificially limits the AEAD
  operation to one IOCB. After altering the libkcapi code
  to allow multiple IOCBs, the testing works flawless.

Stephan Mueller (2):
  crypto: aead AF_ALG - overhaul memory management
  crypto: skcipher AF_ALG - overhaul memory management

 crypto/algif_aead.c     | 439 ++++++++++++++++++++
+---------------------------
 crypto/algif_skcipher.c | 438 +++++++++++++++++++----------------------------
 2 files changed, 369 insertions(+), 508 deletions(-)

-- 
2.9.3
