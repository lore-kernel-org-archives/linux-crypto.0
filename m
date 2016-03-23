From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v2 0/3] crypto: caam - add support for RSA algorithm
Date: Wed, 23 Mar 2016 17:05:36 +0200
Message-ID: <1458745539-1252-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tadeusz.struk@intel.com>, <linux-crypto@vger.kernel.org>,
	<smueller@chronox.de>, <horia.geanta@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0062.outbound.protection.outlook.com ([157.56.110.62]:6090
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753030AbcCWPFr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Mar 2016 11:05:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Depends on [PATCH v2 0/4] crypto: rsa - generalize ASN.1 sequences

Initial patch set can be found here:
        http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg18185.html

Changes to initial patch set:

- ("crypto: caam - add support for RSA algorithm")
	- use raw_rsa_free_key helper function
	- fix memory leaks on error path
	- rename rsa akcipher_alg struct to caam_rsa


Tudor Ambarus (3):
  crypto: scatterwak - Add scatterwalk_sg_copychunks
  crypto: scatterwalk - export scatterwalk_pagedone
  crypto: caam - add support for RSA algorithm

 crypto/scatterwalk.c           |  31 ++-
 drivers/crypto/caam/Kconfig    |  12 +
 drivers/crypto/caam/Makefile   |   4 +
 drivers/crypto/caam/caampkc.c  | 509 +++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/caampkc.h  |  84 +++++++
 drivers/crypto/caam/desc.h     |   2 +
 drivers/crypto/caam/pdb.h      |  16 +-
 drivers/crypto/caam/pkc_desc.c | 138 +++++++++++
 include/crypto/scatterwalk.h   |   4 +
 9 files changed, 797 insertions(+), 3 deletions(-)
 create mode 100644 drivers/crypto/caam/caampkc.c
 create mode 100644 drivers/crypto/caam/caampkc.h
 create mode 100644 drivers/crypto/caam/pkc_desc.c

-- 
1.8.3.1
