From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v2 0/2] crypto: akcipher - Changes to asymmetric key API
Date: Mon, 21 Sep 2015 16:44:09 -0700
Message-ID: <20150921234408.23782.52608.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:4994 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770AbbIUXqB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 19:46:01 -0400
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
Second patch implements the API changes 

Changes in v2:
- dropped patches that checked value returned by crypto_unregister_alg
- flatten patches 4 and 6-8 from v1 into one patch.  

---

Tadeusz Struk (2):
      lib/scatterlist: Add sg_len helper
      crypto: akcipher - Changes to asymmetric key API


 crypto/Makefile                                   |    9 +
 crypto/rsa.c                                      |  188 ++++++++++++++----
 crypto/rsa_helper.c                               |   42 +++-
 crypto/rsakey.asn1                                |    5 
 crypto/rsaprivkey.asn1                            |   11 +
 crypto/rsapubkey.asn1                             |    4 
 crypto/testmgr.c                                  |   40 ++--
 crypto/testmgr.h                                  |   36 +++
 drivers/crypto/qat/qat_common/Makefile            |   12 +
 drivers/crypto/qat/qat_common/qat_asym_algs.c     |  225 +++++++++++++++------
 drivers/crypto/qat/qat_common/qat_rsakey.asn1     |    5 
 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1 |   11 +
 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1  |    4 
 include/crypto/akcipher.h                         |   99 ++++++---
 include/crypto/internal/rsa.h                     |    7 -
 include/linux/scatterlist.h                       |    1 
 lib/scatterlist.c                                 |   18 ++
 17 files changed, 538 insertions(+), 179 deletions(-)
 delete mode 100644 crypto/rsakey.asn1
 create mode 100644 crypto/rsaprivkey.asn1
 create mode 100644 crypto/rsapubkey.asn1
 delete mode 100644 drivers/crypto/qat/qat_common/qat_rsakey.asn1
 create mode 100644 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
 create mode 100644 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1

--
