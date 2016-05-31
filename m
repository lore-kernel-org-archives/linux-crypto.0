From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v4 00/10] crypto: asynchronous compression api
Date: Tue, 31 May 2016 14:55:26 +0100
Message-ID: <1464702936-27627-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:2582 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbcEaNzr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 09:55:47 -0400
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

Finally we propose qdecomp, a simple decompression api for algorithms
which do not need work space for performing decompression operations.

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
Giovanni Cabiddu (10):
  crypto: shrink hash down to two types
  crypto: add asynchronous compression api
  crypto: add driver-side scomp interface
  crypto: add quick decompression api
  crypto: acomp - add support for lzo via scomp
  crypto: acomp - add support for lz4 via scomp
  crypto: acomp - add support for lz4hc via scomp
  crypto: acomp - add support for 842 via scomp
  crypto: acomp - add support for deflate via scomp
  crypto: acomp - update testmgr with support for acomp

 crypto/842.c                          |   82 ++++++++-
 crypto/Kconfig                        |   15 ++
 crypto/Makefile                       |    4 +
 crypto/acompress.c                    |  209 ++++++++++++++++++++
 crypto/crypto_user.c                  |   21 ++
 crypto/deflate.c                      |  111 ++++++++++-
 crypto/lz4.c                          |   91 ++++++++-
 crypto/lz4hc.c                        |   92 ++++++++-
 crypto/lzo.c                          |   97 ++++++++--
 crypto/qdecompress.c                  |   93 +++++++++
 crypto/scompress.c                    |  345 +++++++++++++++++++++++++++++++++
 crypto/testmgr.c                      |  158 ++++++++++++++--
 include/crypto/acompress.h            |  251 ++++++++++++++++++++++++
 include/crypto/internal/acompress.h   |   97 +++++++++
 include/crypto/internal/qdecompress.h |   22 ++
 include/crypto/internal/scompress.h   |  148 ++++++++++++++
 include/crypto/qdecompress.h          |  204 +++++++++++++++++++
 include/linux/crypto.h                |   17 ++-
 18 files changed, 1991 insertions(+), 66 deletions(-)
 create mode 100644 crypto/acompress.c
 create mode 100644 crypto/qdecompress.c
 create mode 100644 crypto/scompress.c
 create mode 100644 include/crypto/acompress.h
 create mode 100644 include/crypto/internal/acompress.h
 create mode 100644 include/crypto/internal/qdecompress.h
 create mode 100644 include/crypto/internal/scompress.h
 create mode 100644 include/crypto/qdecompress.h

-- 
1.7.4.1
