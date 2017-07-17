From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 0/4] Enable RSA Support on the CCP
Date: Mon, 17 Jul 2017 15:16:02 -0500
Message-ID: <150032218639.102878.17376499349231172712.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0043.outbound.protection.outlook.com ([104.47.32.43]:29364
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751318AbdGQUQI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 16:16:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series accomplishes the following:

 - Fix RSA support in the base CCP driver
 - Add the akcipher_set_reqsize() function
 - Enable RSA support in the crypto layer
 - Allow for a larger RSA modulus in a version 5 CCP

---

Gary R Hook (4):
      crypto: ccp - Fix base RSA function for version 5 CCPs
      crypto: Add akcipher_set_reqsize() function
      crypto: ccp - Add support for RSA on the CCP
      csrypto: ccp - Expand RSA support for a v5 ccp


 drivers/crypto/ccp/Makefile          |    1 
 drivers/crypto/ccp/ccp-crypto-main.c |   19 ++
 drivers/crypto/ccp/ccp-crypto-rsa.c  |  299 ++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-crypto.h      |   32 ++++
 drivers/crypto/ccp/ccp-dev-v3.c      |    1 
 drivers/crypto/ccp/ccp-dev-v5.c      |   12 +
 drivers/crypto/ccp/ccp-dev.h         |    1 
 drivers/crypto/ccp/ccp-ops.c         |   81 ++++++---
 drivers/crypto/ccp/sp-dev.h          |    1 
 9 files changed, 412 insertions(+), 35 deletions(-)
 create mode 100644 drivers/crypto/ccp/ccp-crypto-rsa.c
