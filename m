From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v4 0/3] crypto: akcipher - Changes to asymmetric key API
Date: Thu, 01 Oct 2015 13:28:45 -0700
Message-ID: <20151001202845.7193.51602.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16760 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbbJAUav (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 16:30:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series updates the asymmetric key API.
The changes include
 - setkey function has been split into set_priv_key and set_pub_key.
 - akcipher requests takes sgl for src and dst instead of void *.
Users of the API i.e. two existing RSA implementation and
test mgr code have been updated accordingly.

First patch adds sg_len helper that returns the full length
of an sgl.
Second patch adds sgl helpers to mpi library.
Third patch implements the API changes in rsa-generic and rsa-qat

Changes in v4:
- add back src_len and dst_len
- add sgl helpers to mpi library
- change rsa-generic implementation to use the new mpi helpers

Changes in v3:
- changed type returned from sg_len from int to unsigned int

Changes in v2:
- dropped patches that checked value returned by crypto_unregister_alg
- flatten patches 4 and 6-8 from v1 into one patch.  
---

Tadeusz Struk (3):
      lib/scatterlist: Add sg_len helper
      lib/mpi: Add mpi sgl helpers
      crypto: akcipher - Changes to asymmetric key API


 crypto/Makefile                                   |    9 +
 crypto/rsa.c                                      |  112 ++++++----
 crypto/rsa_helper.c                               |   42 +++-
 crypto/rsakey.asn1                                |    5 
 crypto/rsaprivkey.asn1                            |   11 +
 crypto/rsapubkey.asn1                             |    4 
 crypto/testmgr.c                                  |   38 ++--
 crypto/testmgr.h                                  |   36 ++-
 drivers/crypto/qat/qat_common/Makefile            |   12 +
 drivers/crypto/qat/qat_common/qat_asym_algs.c     |  227 +++++++++++++++------
 drivers/crypto/qat/qat_common/qat_rsakey.asn1     |    5 
 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1 |   11 +
 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1  |    4 
 include/crypto/akcipher.h                         |   94 ++++++---
 include/crypto/internal/rsa.h                     |    7 -
 include/linux/mpi.h                               |    4 
 include/linux/scatterlist.h                       |    1 
 lib/mpi/mpicoder.c                                |  194 ++++++++++++++++++
 lib/scatterlist.c                                 |   20 ++
 19 files changed, 655 insertions(+), 181 deletions(-)
 delete mode 100644 crypto/rsakey.asn1
 create mode 100644 crypto/rsaprivkey.asn1
 create mode 100644 crypto/rsapubkey.asn1
 delete mode 100644 drivers/crypto/qat/qat_common/qat_rsakey.asn1
 create mode 100644 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
 create mode 100644 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1

--
