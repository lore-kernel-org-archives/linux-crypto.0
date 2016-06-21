From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH v10 0/3] Key-agreement Protocol Primitives (KPP) API
Date: Tue, 21 Jun 2016 21:45:28 +0100
Message-ID: <1466541931-2875-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:45827 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbcFUUvb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 16:51:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herb,

the following patchset introduces a new API for abstracting key-agreement
protocols such as DH and ECDH. It provides the primitives required for implementing
the protocol, thus the name KPP (Key-agreement Protocol Primitives).

Regards,
Salvatore

Changes from v9:
* Fix encoding/decoding of buffer packed with kpp_secret.

Changes from v8:
* set_secret accept a buffer packed and prefixed with a tiny header of
  2 fields: type and len. Each kpp type define its own type and provide
  helper for user (encoder) and drivers (decoder)

Changed from v7:
* API change: merge set_param and set_key to set_key. Params and private
  key are now provided together. Params have always to be provided.
* Merge generate_public_key and compute_shared_secret into compute_val.
  API stay as it is
* Add ecc_is_key_valid to validate private key when set. Now that params
  and key are set together we can validate the key right away. Before the
  check was deferred to generate_public_key.

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
 crypto/Makefile                 |    9 +
 crypto/crypto_user.c            |   20 +
 crypto/dh.c                     |  189 ++++++++
 crypto/dh_helper.c              |   95 ++++
 crypto/ecc.c                    | 1018 +++++++++++++++++++++++++++++++++++++++
 crypto/ecc.h                    |   83 ++++
 crypto/ecc_curve_defs.h         |   57 +++
 crypto/ecdh.c                   |  151 ++++++
 crypto/ecdh_helper.c            |   86 ++++
 crypto/kpp.c                    |  123 +++++
 crypto/testmgr.c                |  354 ++++++++++++++
 crypto/testmgr.h                |  286 +++++++++++
 include/crypto/dh.h             |   29 ++
 include/crypto/ecdh.h           |   30 ++
 include/crypto/internal/kpp.h   |   64 +++
 include/crypto/kpp.h            |  330 +++++++++++++
 include/linux/crypto.h          |    1 +
 include/uapi/linux/cryptouser.h |    5 +
 19 files changed, 2953 insertions(+)
 create mode 100644 crypto/dh.c
 create mode 100644 crypto/dh_helper.c
 create mode 100644 crypto/ecc.c
 create mode 100644 crypto/ecc.h
 create mode 100644 crypto/ecc_curve_defs.h
 create mode 100644 crypto/ecdh.c
 create mode 100644 crypto/ecdh_helper.c
 create mode 100644 crypto/kpp.c
 create mode 100644 include/crypto/dh.h
 create mode 100644 include/crypto/ecdh.h
 create mode 100644 include/crypto/internal/kpp.h
 create mode 100644 include/crypto/kpp.h

-- 
2.7.4
