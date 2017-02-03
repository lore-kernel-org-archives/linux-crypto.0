From: Nitin Kumbhar <nkumbhar@nvidia.com>
Subject: [PATCH v2 0/6] Add support for ECDSA algorithm
Date: Fri, 3 Feb 2017 16:42:49 +0530
Message-ID: <1486120375-13070-1-git-send-email-nkumbhar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, Nitin Kumbhar <nkumbhar@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14386 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752200AbdBCLND (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2017 06:13:03 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

This patch series adds support for Elliptic Curve Digital Signature
Algorithm (ECDSA). To reuse existing ECC functionality, which is
added as part of ECDH, it separates out ECC and ECDH so that
only ECC functionality is available for ECDSA even when ECDH is in
a disabled state.

Patch #1 restructures ECC and ECDH code such that ECC is not
dependent on ECDH config.

Patches #2 & #3 add vli and ecc functions which are required
for other Elliptic curve algorithms like ECDSA and ECIES.

Patch #4 adds support for ECDSA. This has been validated for P192
and P256 elliptic curves.

Patches #5 and #6 add ECDSA tests to validate ECDSA functionality
and measure ECDSA performance.

Changes in v2:
* Added ecc_is_pub_key_valid() for public key validation
* Use crypto_rng_get_bytes() to get random bytes
* Add documentation in ecdsa.h for ECDSA keys and related APIs
* Reorg ECDSA sign and verity tests to reuse code

Nitin Kumbhar (6):
  crypto: ecc: separate out ecc and ecdh
  crypto: ecc: add vli and ecc ops
  crypto: ecc: export vli and ecc ops
  crypto: ecdsa: add ECDSA SW implementation
  crypto: testmgr: add ECDSA tests
  crypto: tcrypt: add ECDSA test modes

 crypto/Kconfig            |   14 ++
 crypto/Makefile           |    8 +-
 crypto/ecc.c              |  421 +++++++++++++++++++++++++++++++-------------
 crypto/ecc.h              |  101 +++++++-----
 crypto/ecc_curve_defs.h   |   51 +-----
 crypto/ecc_ecdh.h         |   54 ++++++
 crypto/ecdh.c             |    4 +-
 crypto/ecdh_helper.c      |   94 ++++++++++
 crypto/ecdsa.c            |  362 ++++++++++++++++++++++++++++++++++++++
 crypto/ecdsa_helper.c     |  116 +++++++++++++
 crypto/tcrypt.c           |  250 ++++++++++++++++++++++++++-
 crypto/tcrypt.h           |  122 +++++++++++++
 crypto/testmgr.c          |  330 +++++++++++++++++++++++++++++++++++-
 crypto/testmgr.h          |  140 +++++++++++++++
 include/crypto/akcipher.h |    5 +-
 include/crypto/ecc.h      |   24 +++
 include/crypto/ecdh.h     |   10 +-
 include/crypto/ecdsa.h    |   81 +++++++++
 18 files changed, 1962 insertions(+), 225 deletions(-)
 create mode 100644 crypto/ecc_ecdh.h
 create mode 100644 crypto/ecdsa.c
 create mode 100644 crypto/ecdsa_helper.c
 create mode 100644 include/crypto/ecc.h
 create mode 100644 include/crypto/ecdsa.h

-- 
1.7.6.3
