From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v3 0/2] crypto: AF_ALG memory management fix
Date: Mon, 13 Feb 2017 11:04:50 +0100
Message-ID: <1652737.cgCBfDoNyd@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55880 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751693AbdBMKGH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Feb 2017 05:06:07 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Changes v3:
* in *_pull_tsgl: make sure ctx->processed cannot be less than zero
* perform fuzzing of all input parameters with bogus values

Changes v2:
* import fix from Harsh Jain <harsh@chelsio.com> to remove SG
  from list before freeing
* fix return code used for ki_complete to match AIO behavior
  with sync behavior
* rename variable list -> tsgl_list
* update the algif_aead patch to include a dynamic TX SGL
  allocation similar to what algif_skcipher does. This allows
  concurrent continuous read/write operations to the extent
  you requested. Although I have not implemented "pairs of
  TX/RX SGLs" as I think that is even more overhead, the
  implementation conceptually defines such pairs. The recvmsg
  call defines how much from the input data is processed.
  The caller can have arbitrary number of sendmsg calls
  where the data is added to the TX SGL before an recvmsg
  asks the kernel to process a given amount (or all) of the
  TX SGL.

With the changes, you will see a lot of code duplication now
as I deliberately tried to use the same struct and variable names,
the same function names and even the same oder of functions.
If you agree to this patch, I volunteer to provide a followup
patch that will extract the code duplication into common
functions.

Please find attached memory management updates to

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
  crypto: skcipher AF_ALG - overhaul memory management
  crypto: aead AF_ALG - overhaul memory management

 crypto/algif_aead.c     | 673 +++++++++++++++++++++++++-----------------------
 crypto/algif_skcipher.c | 477 ++++++++++++++--------------------
 2 files changed, 554 insertions(+), 596 deletions(-)

-- 
2.9.3
