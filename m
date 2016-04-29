From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v4 0/3] crypto: caam - add support for RSA algorithm
Date: Fri, 29 Apr 2016 16:10:18 +0300
Message-ID: <1461935421-31363-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bbn0100.outbound.protection.outlook.com ([157.56.111.100]:23726
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753247AbcD2NKa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 09:10:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Depends on:
 http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg18724.html

v3 parch set can be found here:
 http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg18429.html

Changes to v3 patch set:
- "crypto: caam - add support for RSA algorithm"
     - update the driver to use the new ASN.1 parser.

Tudor Ambarus (3):
  crypto: scatterwak - Add scatterwalk_sg_copychunks
  crypto: scatterwalk - export scatterwalk_pagedone
  crypto: caam - add support for RSA algorithm

 crypto/scatterwalk.c           |  31 ++-
 drivers/crypto/caam/Kconfig    |  12 ++
 drivers/crypto/caam/Makefile   |   4 +
 drivers/crypto/caam/caampkc.c  | 470 +++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/caampkc.h  |  84 ++++++++
 drivers/crypto/caam/desc.h     |   2 +
 drivers/crypto/caam/pdb.h      |  16 +-
 drivers/crypto/caam/pkc_desc.c | 138 ++++++++++++
 include/crypto/scatterwalk.h   |   4 +
 9 files changed, 758 insertions(+), 3 deletions(-)
 create mode 100644 drivers/crypto/caam/caampkc.c
 create mode 100644 drivers/crypto/caam/caampkc.h
 create mode 100644 drivers/crypto/caam/pkc_desc.c

-- 
1.8.3.1
