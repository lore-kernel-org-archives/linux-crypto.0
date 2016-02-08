From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/2] crypto: asynchronous compression api
Date: Mon,  8 Feb 2016 16:10:01 +0000
Message-ID: <1454947803-30644-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:36346 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345AbcBHQKL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Feb 2016 11:10:11 -0500
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
 crypto/acompress.c                  |  134 ++++++++++++
 crypto/crypto_user.c                |   21 ++
 include/crypto/acompress.h          |  379 +++++++++++++++++++++++++++++++++++
 include/crypto/internal/acompress.h |   90 +++++++++
 include/linux/crypto.h              |    1 +
 7 files changed, 637 insertions(+), 0 deletions(-)
 create mode 100644 crypto/acompress.c
 create mode 100644 include/crypto/acompress.h
 create mode 100644 include/crypto/internal/acompress.h

-- 
1.7.4.1
