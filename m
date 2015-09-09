From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 0/8] crypto: Updates to akcipher API
Date: Wed, 09 Sep 2015 09:14:54 -0700
Message-ID: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64559 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbbIIQQ7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:16:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series introduce updates to the akcipher API.
setkey function has been split into set_pub_key and
set_priv_key.
Input and output buffers are now sgl instread of void *
It also includes some minor updates like status check
from crypto_unregister_akcipher which was not checked
before.

---

Tadeusz Struk (8):
      crypto: akcipher - return status from crypto_unregister_alg
      crypto: rsa - check status returned from crypto_unregister_akcipher
      crypto: qat - check status returned from crypto_unregister_akcipher
      crypto: akcipher - Changes to asymmetric key API
      lib/scatterlist: Add sg_len helper
      crypto: rsa - update accoring to akcipher API changes
      crypto: qat - update accoring to akcipher API changes
      crypto: testmgr - update test mgr


 crypto/Makefile                                   |    9 +
 crypto/akcipher.c                                 |    4 
 crypto/rsa.c                                      |  191 ++++++++++++++---
 crypto/rsa_helper.c                               |   42 +++-
 crypto/rsakey.asn1                                |    5 
 crypto/rsaprivkey.asn1                            |   11 +
 crypto/rsapubkey.asn1                             |    4 
 crypto/testmgr.c                                  |   40 ++--
 crypto/testmgr.h                                  |   36 ++-
 drivers/crypto/qat/qat_common/Makefile            |   12 +
 drivers/crypto/qat/qat_common/adf_common_drv.h    |    2 
 drivers/crypto/qat/qat_common/adf_init.c          |    6 -
 drivers/crypto/qat/qat_common/qat_asym_algs.c     |  232 +++++++++++++++------
 drivers/crypto/qat/qat_common/qat_rsakey.asn1     |    5 
 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1 |   11 +
 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1  |    4 
 include/crypto/akcipher.h                         |   99 ++++++---
 include/crypto/internal/akcipher.h                |    4 
 include/crypto/internal/rsa.h                     |    7 -
 include/linux/scatterlist.h                       |    1 
 lib/scatterlist.c                                 |   17 ++
 21 files changed, 552 insertions(+), 190 deletions(-)
 delete mode 100644 crypto/rsakey.asn1
 create mode 100644 crypto/rsaprivkey.asn1
 create mode 100644 crypto/rsapubkey.asn1
 delete mode 100644 drivers/crypto/qat/qat_common/qat_rsakey.asn1
 create mode 100644 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
 create mode 100644 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1

--
Signature
