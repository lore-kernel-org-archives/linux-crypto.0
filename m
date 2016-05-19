From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v6 0/3] crypto: caam - add support for RSA algorithm
Date: Thu, 19 May 2016 15:15:15 +0300
Message-ID: <1463660118-19188-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <horia.geanta@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0089.outbound.protection.outlook.com ([65.55.169.89]:12000
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751399AbcESMPb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 May 2016 08:15:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Depends on:
[PATCH v2] crypto: rsa - return raw integers for the ASN.1 parser

Changes in v6:
- write descriptor PDB fields with inline append
- move Protocol Data Block (pdb) structures to pdb.h
- move setting of PDB fields in new functions
- unmap sec4_sg_dma on done callback
- remove redundant clean code on error path
- fix doc typos

Changes in v5:
- sync with ASN.1 parser

Changes in v4:
- sync with ASN.1 parser

Changes in v3:
- sync with ASN.1 parser

Changes in v2:
- fix memory leaks on error path
- rename struct akcipher_alg rsa to caam_rsa


Tudor Ambarus (3):
  crypto: scatterwak - Add scatterwalk_sg_copychunks
  crypto: scatterwalk - export scatterwalk_pagedone
  crypto: caam - add support for RSA algorithm

 crypto/scatterwalk.c              |  31 ++-
 drivers/crypto/caam/Kconfig       |  12 +
 drivers/crypto/caam/Makefile      |   4 +
 drivers/crypto/caam/caampkc.c     | 569 ++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/caampkc.h     |  56 ++++
 drivers/crypto/caam/desc.h        |   2 +
 drivers/crypto/caam/desc_constr.h |   7 +
 drivers/crypto/caam/pdb.h         |  51 +++-
 drivers/crypto/caam/pkc_desc.c    |  35 +++
 include/crypto/scatterwalk.h      |   4 +
 10 files changed, 768 insertions(+), 3 deletions(-)
 create mode 100644 drivers/crypto/caam/caampkc.c
 create mode 100644 drivers/crypto/caam/caampkc.h
 create mode 100644 drivers/crypto/caam/pkc_desc.c

-- 
1.8.3.1
