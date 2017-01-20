From: Nitin Kumbhar <nkumbhar@nvidia.com>
Subject: [PATCH 0/6] Add support for ECDSA algorithm
Date: Fri, 20 Jan 2017 17:05:55 +0530
Message-ID: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, Nitin Kumbhar <nkumbhar@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5438 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751299AbdATLg5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2017 06:36:57 -0500
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

Nitin Kumbhar (6):
  crypto: ecc: separate out ecc and ecdh
  crypto: ecc: add vli and ecc ops
  crypto: ecc: export vli and ecc ops
  crypto: ecdsa: add ECDSA SW implementation
  crypto: testmgr: add ECDSA tests
  crypto: tcrypt: add ECDSA test modes

 crypto/Kconfig            |   14 ++
 crypto/Makefile           |    8 +-
 crypto/ecc.c              |  415 ++++++++++++++++++++++++++++-------------
 crypto/ecc.h              |   98 ++++++----
 crypto/ecc_curve_defs.h   |   51 +----
 crypto/ecc_ecdh.h         |   54 ++++++
 crypto/ecdh.c             |    4 +-
 crypto/ecdh_helper.c      |   94 ++++++++++
 crypto/ecdsa.c            |  331 +++++++++++++++++++++++++++++++++
 crypto/ecdsa_helper.c     |  116 ++++++++++++
 crypto/tcrypt.c           |  250 ++++++++++++++++++++++++-
 crypto/tcrypt.h           |  122 ++++++++++++
 crypto/testmgr.c          |  452 ++++++++++++++++++++++++++++++++++++++++++++-
 crypto/testmgr.h          |  140 ++++++++++++++
 include/crypto/akcipher.h |    5 +-
 include/crypto/ecc.h      |   24 +++
 include/crypto/ecdh.h     |   10 +-
 include/crypto/ecdsa.h    |   29 +++
 18 files changed, 1984 insertions(+), 233 deletions(-)
 create mode 100644 crypto/ecc_ecdh.h
 create mode 100644 crypto/ecdsa.c
 create mode 100644 crypto/ecdsa_helper.c
 create mode 100644 include/crypto/ecc.h
 create mode 100644 include/crypto/ecdsa.h

-- 
1.7.6.3
