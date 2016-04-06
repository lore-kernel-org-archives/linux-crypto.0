From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v3 0/3] crypto: caam - add support for RSA algorithm
Date: Wed, 6 Apr 2016 16:37:53 +0300
Message-ID: <1459949876-11989-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
	<cristian.stoica@nxp.com>, <horia.geanta@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0075.outbound.protection.outlook.com ([65.55.169.75]:14403
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751576AbcDFNiH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Apr 2016 09:38:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Depends on [PATCH v3 0/3] crypto: rsa - generalize ASN.1 sequences

v2 patch set can be found here:
  http://www.mail-archive.com/linux-crypto%40vger.kernel.org/msg18273.html

Changes to v2 patch set:

- "crypto: caam - add support for RSA algorithm"
	- update Kconfig so that it selects CRYPTO_RSA

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
