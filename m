From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH v7 0/3] Key-agreement Protocol Primitives (KPP) API
Date: Tue, 31 May 2016 16:36:20 +0100
Message-ID: <1464708983-61664-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11585 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbcEaPgd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 11:36:33 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herb,

the following patchset introduces a new API for abstracting key-agreement
protocols such as DH and ECDH. It provides the primitives required for implementing
the protocol, thus the name KPP (Key-agreement Protocol Primitives).

Regards,
Salvatore

Changes from v6:
* Remove len parameter from crypto_kpp_set_params. Adjust rest of code
  accordingly
* Remove the while loop in ecdh_make_pub_key as the private key is fixed and
  iterating is pointless. EAGAIN is now to returned to make the user aware
  that he needs to regenerate/reset the private key

Changes from v5:
* Fix ecdh loading in fips mode.

Changes from v4:
* If fips_enabled is set allow only P256 (or higher) as Stephan suggested
* Pass ndigits as argument to ecdh_make_pub_key and ecdh_shared_secret
  so that VLA can be used like in the rest of the module

Changes from v3:
* Move curve ID definition to public header ecdh.h as users need to
  have access to those ids when selecting the curve

Changes from v2:
* Add support for ECDH (curve P192 and P256). I reused the ecc module
  already present in net/bluetooth and extended it in order to select
  different curves at runtime. Code for P192 was taken from tinycrypt.

Changes from v1:
* Change check in dh_check_params_length based on Stephan review


Salvatore Benedetto (3):
  crypto: Key-agreement Protocol Primitives API (KPP)
  crypto: kpp - Add DH software implementation
  crypto: kpp - Add ECDH software support

 crypto/Kconfig                  |   23 +
 crypto/Makefile                 |    6 +
 crypto/crypto_user.c            |   20 +
 crypto/dh.c                     |  223 +++++++++
 crypto/ecc.c                    | 1011 +++++++++++++++++++++++++++++++++++++++
 crypto/ecc.h                    |   70 +++
 crypto/ecc_curve_defs.h         |   57 +++
 crypto/ecdh.c                   |  170 +++++++
 crypto/kpp.c                    |  123 +++++
 crypto/testmgr.c                |  275 +++++++++++
 crypto/testmgr.h                |  286 +++++++++++
 include/crypto/dh.h             |   23 +
 include/crypto/ecdh.h           |   24 +
 include/crypto/internal/kpp.h   |   64 +++
 include/crypto/kpp.h            |  331 +++++++++++++
 include/linux/crypto.h          |    1 +
 include/uapi/linux/cryptouser.h |    5 +
 17 files changed, 2712 insertions(+)
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
2.7.4
