From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v8 0/3] crypto: caam - add support for RSA algorithm
Date: Wed, 15 Jun 2016 17:52:41 +0300
Message-ID: <1466002364-16945-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <horia.geanta@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0072.outbound.protection.outlook.com ([207.46.100.72]:2849
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932700AbcFOPHz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 11:07:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changes in v8:
- store raw keys on stack
- use d_sz instead of n_sz for RSA private exponent
- add caam_read_raw_data function for reading RSA modulus raw byte stream
  as a positive integer. The function updates the n_sz byte length too.
  Needed because the decryption descriptor uses the RSA modulus length as
  decryption output length. The accelerator will try to write n_sz bytes
  to output SGT, resulting a SGT overfflow if RSA modulus contains leading
  zeros.
- add caam_rsa_check_key_length function. Maximum supported modulus size is
  4096 bits. Fallback mechanism to be added after removing
  the (same) key length constraint from software implementation.

Changes in v7:
- sync with ASN.1 parser

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

 crypto/scatterwalk.c              |  31 +-
 drivers/crypto/caam/Kconfig       |  12 +
 drivers/crypto/caam/Makefile      |   4 +
 drivers/crypto/caam/caampkc.c     | 693 ++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/caampkc.h     |  70 ++++
 drivers/crypto/caam/compat.h      |   3 +
 drivers/crypto/caam/desc.h        |   2 +
 drivers/crypto/caam/desc_constr.h |   7 +
 drivers/crypto/caam/pdb.h         |  51 ++-
 drivers/crypto/caam/pkc_desc.c    |  36 ++
 include/crypto/scatterwalk.h      |   4 +
 11 files changed, 910 insertions(+), 3 deletions(-)
 create mode 100644 drivers/crypto/caam/caampkc.c
 create mode 100644 drivers/crypto/caam/caampkc.h
 create mode 100644 drivers/crypto/caam/pkc_desc.c

-- 
1.8.3.1
