From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 0/8] crypto: asynchronous compression api
Date: Wed, 24 Feb 2016 17:51:42 +0000
Message-ID: <1456336310-3737-1-git-send-email-giovanni.cabiddu@intel.com>
References: <20160216195717.GA4207@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:64170 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbcBXRwZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Feb 2016 12:52:25 -0500
In-Reply-To: <20160216195717.GA4207@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following patch set introduces acomp, a generic asynchronous
(de)compression api.
What is proposed is a new crypto type called crypto_acomp_type,
plus a new struct acomp_alg and struct crypto_acomp, together
with number of helper functions to register acomp type algorithms
and allocate tfm instances. This is to make it similar to how the
existing crypto API works for the ablkcipher, ahash, and aead types.
This interface will allow the following operations:

    int (*compress)(struct acomp_req *req);
    int (*decompress)(struct acomp_req *req);

The main benefit that this API gives is to allow for
asynchronous (de)compression operations, mainly supported by
compression accelerators.

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

 crypto/842.c                        |   84 ++++++++++-
 crypto/Kconfig                      |   15 ++
 crypto/Makefile                     |    3 +
 crypto/acompress.c                  |  189 +++++++++++++++++++++++
 crypto/crypto_user.c                |   21 +++
 crypto/deflate.c                    |  112 ++++++++++++--
 crypto/lz4.c                        |   93 ++++++++++--
 crypto/lz4hc.c                      |   94 ++++++++++--
 crypto/lzo.c                        |  100 ++++++++++--
 crypto/scompress.c                  |  262 +++++++++++++++++++++++++++++++
 crypto/testmgr.c                    |  159 ++++++++++++++++++--
 include/crypto/acompress.h          |  291 +++++++++++++++++++++++++++++++++++
 include/crypto/internal/acompress.h |  108 +++++++++++++
 include/crypto/internal/scompress.h |  138 +++++++++++++++++
 include/linux/crypto.h              |    8 +
 15 files changed, 1616 insertions(+), 61 deletions(-)
 create mode 100644 crypto/acompress.c
 create mode 100644 crypto/scompress.c
 create mode 100644 include/crypto/acompress.h
 create mode 100644 include/crypto/internal/acompress.h
 create mode 100644 include/crypto/internal/scompress.h

-- 
1.7.4.1
