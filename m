From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH 0/2] Key-agreement Protocol Primitives (KPP) API
Date: Tue, 12 Apr 2016 11:39:14 +0100
Message-ID: <1460457556-3117-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9439 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815AbcDLKja (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Apr 2016 06:39:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herb,

the following patchset introduces a new API for abstracting
key-agreement protocols such as DH and ECDH. It provides the primitives
required for implementing the protocol, thus the name KPP (Key-agreement
Protocol Primitives).

Regards,
Salvatore

Salvatore Benedetto (2):
  crypto: Key-agreement Protocol Primitives API (KPP)
  crypto: kpp - Add DH software implementation

 crypto/Kconfig                  |  18 +++
 crypto/Makefile                 |   3 +
 crypto/crypto_user.c            |  20 +++
 crypto/dh.c                     | 233 ++++++++++++++++++++++++++++
 crypto/kpp.c                    | 123 +++++++++++++++
 crypto/testmgr.c                | 157 +++++++++++++++++++
 crypto/testmgr.h                | 208 +++++++++++++++++++++++++
 include/crypto/dh.h             |  23 +++
 include/crypto/internal/kpp.h   |  64 ++++++++
 include/crypto/kpp.h            | 333 ++++++++++++++++++++++++++++++++++++++++
 include/linux/crypto.h          |   1 +
 include/uapi/linux/cryptouser.h |   5 +
 12 files changed, 1188 insertions(+)
 create mode 100644 crypto/dh.c
 create mode 100644 crypto/kpp.c
 create mode 100644 include/crypto/dh.h
 create mode 100644 include/crypto/internal/kpp.h
 create mode 100644 include/crypto/kpp.h

-- 
1.9.1
