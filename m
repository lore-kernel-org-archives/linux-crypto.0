From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v5 0/3] crypto: caam - add support for RSA algorithm
Date: Thu, 12 May 2016 18:06:15 +0300
Message-ID: <1463065578-14017-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0092.outbound.protection.outlook.com ([157.56.110.92]:54448
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752648AbcELPG0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 May 2016 11:06:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Depends on:
[PATCH v2] crypto: rsa - return raw integers for the ASN.1 parser

Changes from v4:
- sync with ASN.1 parser

Changes from v3:
- sync with ASN.1 parser

Changes from v2:
- sync with ASN.1 parser

Changes from initial patch:
- fix memory leaks on error path
- rename struct akcipher_alg rsa to caam_rsa

Tudor Ambarus (3):
  crypto: scatterwak - Add scatterwalk_sg_copychunks
  crypto: scatterwalk - export scatterwalk_pagedone
  crypto: caam - add support for RSA algorithm

 crypto/scatterwalk.c           |  31 ++-
 drivers/crypto/caam/Kconfig    |  12 ++
 drivers/crypto/caam/Makefile   |   4 +
 drivers/crypto/caam/caampkc.c  | 466 +++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/caampkc.h  |  94 +++++++++
 drivers/crypto/caam/desc.h     |   2 +
 drivers/crypto/caam/pdb.h      |  16 +-
 drivers/crypto/caam/pkc_desc.c | 138 ++++++++++++
 include/crypto/scatterwalk.h   |   4 +
 9 files changed, 764 insertions(+), 3 deletions(-)
 create mode 100644 drivers/crypto/caam/caampkc.c
 create mode 100644 drivers/crypto/caam/caampkc.h
 create mode 100644 drivers/crypto/caam/pkc_desc.c

-- 
1.8.3.1
