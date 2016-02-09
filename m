From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 0/2] crypto: asynchronous compression api
Date: Tue,  9 Feb 2016 17:31:07 +0000
Message-ID: <1455039069-17475-1-git-send-email-giovanni.cabiddu@intel.com>
References: <20160209105355.GA10652@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2940 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177AbcBIRba (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2016 12:31:30 -0500
In-Reply-To: <20160209105355.GA10652@gondor.apana.org.au>
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
asynchronous implementations that can use compression hardware to
offload the computation.

Changes in v2:
    - added compression and decompression request sizes in acomp_alg
      in order to enable noctx support
    - extended api with helpers to allocate compression and
      decompression requests with different context sizes

Changes from initial submit:
    - added consumed and produced fields to acomp_req
    - extended api to support configuration of deflate compressors

---
Giovanni Cabiddu (2):
  crypto: add asynchronous compression api
  crypto: extended acomp api for supporting deflate algorithm
    parameters

 crypto/Kconfig                      |   10 +
 crypto/Makefile                     |    2 +
 crypto/acompress.c                  |  134 +++++++++++
 crypto/crypto_user.c                |   21 ++
 include/crypto/acompress.h          |  438 +++++++++++++++++++++++++++++++++++
 include/crypto/internal/acompress.h |   90 +++++++
 include/linux/crypto.h              |    1 +
 7 files changed, 696 insertions(+), 0 deletions(-)
 create mode 100644 crypto/acompress.c
 create mode 100644 include/crypto/acompress.h
 create mode 100644 include/crypto/internal/acompress.h

-- 
1.7.4.1
