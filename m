From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v8 0/8] crypto: asynchronous compression api
Date: Thu, 22 Sep 2016 23:44:13 +0100
Message-ID: <1474584261-25776-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8646 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758193AbcIVWog (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 18:44:36 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following patch set introduces acomp, a generic asynchronous
(de)compression api with support for SG lists.
We propose a new crypto type called crypto_acomp_type, a new struct acomp_alg
and struct crypto_acomp, together with number of helper functions to register
acomp type algorithms and allocate tfm instances.
This interface will allow the following operations:

    int (*compress)(struct acomp_req *req);
    int (*decompress)(struct acomp_req *req);

Together with acomp we propose a new driver-side interface, scomp, which
handles compression implementations which use linear buffers. We converted all
compression algorithms available in LKCF to use this interface so that those
algorithms will be accessible through the acomp api.

Changes in v8:
    - centralized per-cpu scratch buffers handling in scomp layer
    - changed scomp internal API to use linear buffer (as in v6)

Changes in v7:
    - removed linearization of SG lists and per-request vmalloc allocations in
      scomp layer
    - modified scomp internal API to use SG lists
    - introduced per-cpu cache of 128K scratch buffers allocated using vmalloc
      in legacy scomp algorithms

Changes in v6:
    - changed acomp_request_alloc prototype by removing gfp parameter.
      acomp_request_alloc will always use GFP_KERNEL

Changes in v5:
    - removed qdecompress api, no longer needed
    - removed produced and consumed counters in acomp_req
    - added crypto_has_acomp function

Changes in v4:
    - added qdecompress api, a front-end for decompression algorithms which
      do not need additional vmalloc work space

Changes in v3:
    - added driver-side scomp interface
    - provided support for lzo, lz4, lz4hc, 842, deflate compression algorithms
      via the acomp api (through scomp)
    - extended testmgr to support acomp
    - removed extended acomp api for supporting deflate algorithm parameters
      (will be enhanced and re-proposed in future)
Note that (2) to (7) are a rework of Joonsoo Kim's scomp patches.

Changes in v2:
    - added compression and decompression request sizes in acomp_alg
      in order to enable noctx support
    - extended api with helpers to allocate compression and
      decompression requests

Changes from initial submit:
    - added consumed and produced fields to acomp_req
    - extended api to support configuration of deflate compressors

---
Giovanni Cabiddu (8):
  crypto: add asynchronous compression api
  crypto: add driver-side scomp interface
  crypto: acomp - add support for lzo via scomp
  crypto: acomp - add support for lz4 via scomp
  crypto: acomp - add support for lz4hc via scomp
  crypto: acomp - add support for 842 via scomp
  crypto: acomp - add support for deflate via scomp
  crypto: acomp - update testmgr with support for acomp

 crypto/842.c                        |  81 +++++++++-
 crypto/Kconfig                      |  15 ++
 crypto/Makefile                     |   3 +
 crypto/acompress.c                  | 163 ++++++++++++++++++++
 crypto/crypto_user.c                |  19 +++
 crypto/deflate.c                    | 111 ++++++++++++--
 crypto/lz4.c                        |  91 +++++++++--
 crypto/lz4hc.c                      |  92 ++++++++++--
 crypto/lzo.c                        |  97 ++++++++++--
 crypto/scompress.c                  | 292 ++++++++++++++++++++++++++++++++++++
 crypto/testmgr.c                    | 158 +++++++++++++++++--
 include/crypto/acompress.h          | 253 +++++++++++++++++++++++++++++++
 include/crypto/internal/acompress.h |  81 ++++++++++
 include/crypto/internal/scompress.h | 136 +++++++++++++++++
 include/linux/crypto.h              |   3 +
 15 files changed, 1535 insertions(+), 60 deletions(-)
 create mode 100644 crypto/acompress.c
 create mode 100644 crypto/scompress.c
 create mode 100644 include/crypto/acompress.h
 create mode 100644 include/crypto/internal/acompress.h
 create mode 100644 include/crypto/internal/scompress.h

--
2.4.11
