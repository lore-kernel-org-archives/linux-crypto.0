From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v2 0/4] crypto: rsa - generalize ASN.1 sequences
Date: Wed, 23 Mar 2016 17:04:15 +0200
Message-ID: <1458745459-1096-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
	<horia.geanta@nxp.com>, Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>, <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0078.outbound.protection.outlook.com ([157.56.111.78]:31796
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753072AbcCWPEa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Mar 2016 11:04:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Initial patch set can be found here:
	http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg18185.html

Changes to initial patch set:

- ("crypto: rsa - generalize ASN.1 sequences")
	- allow to provide handlers for the second representation
          of the private key (p, q, dq, dq, qinv)
	- remove unnecessary arguments on get_<X> functions
	- use a single static const struct rsa_ans1_action instance
	  for all tfms.

- ("crypto: rsa_helper - add raw integer parser actions")
	- add raw_rsa_free_key and raw_rsa_free_coherent_key functions
	- export raw_rsa_get_<X> symbols


Tudor Ambarus (4):
  crypto: rsa - generalize ASN.1 sequences
  crypto: rsa_helper - add raw integer parser actions
  crypto: add CONFIG_ symbol for rsa helper
  crypto: rsa_helper - export symbols for asn1 structures

 crypto/Kconfig                |   8 +-
 crypto/Makefile               |   6 +-
 crypto/rsa.c                  |  75 ++++-----
 crypto/rsa_helper.c           | 351 +++++++++++++++++++++++++++++++++++++-----
 include/crypto/internal/rsa.h |  59 ++++++-
 5 files changed, 416 insertions(+), 83 deletions(-)

-- 
1.8.3.1
