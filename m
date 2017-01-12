From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [RFC PATCH 0/6] Add bulk skcipher requests to crypto API and dm-crypt
Date: Thu, 12 Jan 2017 13:59:52 +0100
Message-ID: <cover.1484215956.git.omosnacek@gmail.com>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36689 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750960AbdALNAp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 08:00:45 -0500
Received: by mail-wm0-f67.google.com with SMTP id r126so3507288wmr.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2017 05:00:45 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

the goal of this patchset is to allow those skcipher API users that need to
process batches of small messages (especially dm-crypt) to do so efficiently.

The first patch introduces a new request type (and corresponding encrypt/decrypt
functions) to the skcipher API. The new API can be used to submit multiple
messages at once, thus enabling the drivers to reduce overhead as opposed to
processing each message separately.

The skcipher drivers can provide support for the new request type by setting the
corresponding fields of their skcipher_alg structure. If 'native' support is not
provided by a driver (i.e. the fields are left NULL), the crypto API
transparently provides a generic fallback implementation, which simply processes
the bulk request as a set of standard requests on the same tfm.

The second patch extends skcipher_walk so it can be used for processing the new
bulk requests, while preserving equivalent functionality when used with standard
requests.

The third and fourth patches add native bulk request support to the cryptd and
SIMD helper wrappers, respectively.

The fifth patch adds bulk request support to the AES-NI skcipher drivers, in
order to provide an example for both implementing the bulk request processing
and the usage of the extended skcipher_walk in such implementation. Also, this
patch provides a slight optimization, since the kernel_fpu_* functions are
called just once per the whole bulk request. Note that both the standard and
bulk implementation mostly use the same code under the hood.

The last patch converts dm-crypt to use bulk requests and makes it submit
multiple sectors at once, whenever they are stored sequentially within a single
page.

With all the patches applied, I was able to measure a small speedup (~5-10%)
with AES-NI ciphers and dm-crypt device mapped over a ramdisk.

To-be-done:
    testing the bulk API in testmgr.c
    documentation update

Ondrej Mosnacek (6):
  crypto: skcipher - Add bulk request processing API
  crypto: skcipher - Add bulk request support to walk
  crypto: cryptd - Add skcipher bulk request support
  crypto: simd - Add bulk request support
  crypto: aesni-intel - Add bulk request support
  dm-crypt: Add bulk crypto processing support

 arch/x86/crypto/aesni-intel_glue.c        | 267 +++++++++++++++++++------
 arch/x86/crypto/glue_helper.c             |  23 +--
 arch/x86/include/asm/crypto/glue_helper.h |   2 +-
 crypto/Makefile                           |   1 +
 crypto/cryptd.c                           | 111 +++++++++++
 crypto/simd.c                             |  61 ++++++
 crypto/skcipher.c                         | 207 +++++++++++++++-----
 crypto/skcipher_bulk.c                    | 312 ++++++++++++++++++++++++++++++
 drivers/md/dm-crypt.c                     | 254 +++++++++++++++---------
 include/crypto/internal/skcipher.h        |  42 +++-
 include/crypto/skcipher.h                 | 299 +++++++++++++++++++++++++++-
 11 files changed, 1369 insertions(+), 210 deletions(-)
 create mode 100644 crypto/skcipher_bulk.c

-- 
2.9.3
