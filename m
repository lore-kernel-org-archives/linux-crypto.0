From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v3 0/3] crypto: rsa - generalize ASN.1 sequences
Date: Wed, 6 Apr 2016 16:37:03 +0300
Message-ID: <1459949826-11840-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <tadeusz.struk@intel.com>,
	<smueller@chronox.de>, <cristian.stoica@nxp.com>,
	<horia.geanta@nxp.com>, Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0089.outbound.protection.outlook.com ([157.56.110.89]:58563
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751230AbcDFNh1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Apr 2016 09:37:27 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

v2 patch set can be found here:
  http://www.mail-archive.com/linux-crypto%40vger.kernel.org/msg18269.html

Changes to v2 patch set:

- "crypto: add CONFIG_ symbol for rsa helper"
	- removed. The drivers will select the CRYPTO_RSA symbol instead.

Tudor Ambarus (3):
  crypto: rsa - generalize ASN.1 sequences
  crypto: rsa_helper - add raw integer parser actions
  crypto: rsa_helper - export symbols for asn1 structures

 crypto/rsa.c                  |  75 ++++-----
 crypto/rsa_helper.c           | 351 +++++++++++++++++++++++++++++++++++++-----
 include/crypto/internal/rsa.h |  59 ++++++-
 3 files changed, 407 insertions(+), 78 deletions(-)

-- 
1.8.3.1
