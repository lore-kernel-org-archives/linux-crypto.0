From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH 0/3 v3] Key-agreement Protocol Primitives (KPP) API
Date: Tue,  3 May 2016 12:44:00 +0100
Message-ID: <1462275843-19926-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:51907 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269AbcECLo4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 07:44:56 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herb,

the following patchset introduces a new API for abstracting key-agreement
protocols such as DH and ECDH. It provides the primitives required for implementing
the protocol, thus the name KPP (Key-agreement Protocol Primitives).

Regards,
Salvatore

Changes from v1:
 * Change check in dh_check_params_length based on Stephan review

Changed from v2:
 * Add support for ECDH (curve P192 and P256). I reused the ecc module
   already present in net/bluetooth and extended it in order to select
   different curves at runtime. Code for P192 was taken from tinycrypt.

Salvatore Benedetto (3):
  crypto: Key-agreement Protocol Primitives API (KPP)
  crypto: kpp - Add DH software implementation
  crypto: kpp - Add ECDH software support

 crypto/Kconfig                  |   23 +
 crypto/Makefile                 |    6 +
 crypto/crypto_user.c            |   20 +
 crypto/dh.c                     |  224 +++++++++
 crypto/ecc.c                    | 1037 +++++++++++++++++++++++++++++++++++++++
 crypto/ecc.h                    |   74 +++
 crypto/ecc_curve_defs.h         |   57 +++
 crypto/ecdh.c                   |  171 +++++++
 crypto/kpp.c                    |  123 +++++
 crypto/testmgr.c                |  275 +++++++++++
 crypto/testmgr.h                |  281 +++++++++++
 include/crypto/dh.h             |   23 +
 include/crypto/ecdh.h           |   20 +
 include/crypto/internal/kpp.h   |   64 +++
 include/crypto/kpp.h            |  333 +++++++++++++
 include/linux/crypto.h          |    1 +
 include/uapi/linux/cryptouser.h |    5 +
 17 files changed, 2737 insertions(+)
 create mode 100644 crypto/dh.c
 create mode 100644 crypto/ecc.c
 create mode 100644 crypto/ecc.h
 create mode 100644 crypto/ecc_curve_defs.h
 create mode 100644 crypto/ecdh.c
 create mode 100644 crypto/kpp.c
 create mode 100644 include/crypto/dh.h
 create mode 100644 include/crypto/ecdh.h
 create mode 100644 include/crypto/internal/kpp.h
 create mode 100644 include/crypto/kpp.h

-- 
1.9.1
