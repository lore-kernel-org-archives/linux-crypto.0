From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH V3 0/3] Support new function in new CCPs
Date: Wed, 15 Mar 2017 13:20:34 -0500
Message-ID: <20170315182014.29335.93268.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <gary.hook@amd.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0045.outbound.protection.outlook.com ([104.47.38.45]:21920
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753419AbdCOSgy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Mar 2017 14:36:54 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series implements new function in a version 5 coprocessor.
New features are:
 - Support for SHA-2 384-bit and 512-bit hashing
 - Support for 3DES encryption
 - Support for AES GCM encryption

Changes from V2:
 - Correct a comment in the GCM support code.
 - Ensure the patches apply to the current repo

Changes from V1:
 - Ensure the patches build correctly

---

Gary R Hook (3):
      crypto: ccp - Add SHA-2 384- and 512-bit support
      crypto: ccp - Enable 3DES function on v5 CCPs
      crypto: ccp - Enable support for AES GCM on v5 CCPs


 drivers/crypto/ccp/Makefile                |    2 
 drivers/crypto/ccp/ccp-crypto-aes-galois.c |  252 ++++++++++++++
 drivers/crypto/ccp/ccp-crypto-des3.c       |  254 ++++++++++++++
 drivers/crypto/ccp/ccp-crypto-main.c       |   22 +
 drivers/crypto/ccp/ccp-crypto-sha.c        |   22 +
 drivers/crypto/ccp/ccp-crypto.h            |   44 ++
 drivers/crypto/ccp/ccp-dev-v3.c            |    1 
 drivers/crypto/ccp/ccp-dev-v5.c            |   54 +++
 drivers/crypto/ccp/ccp-dev.h               |   14 +
 drivers/crypto/ccp/ccp-ops.c               |  522 ++++++++++++++++++++++++++++
 include/linux/ccp.h                        |   68 ++++
 11 files changed, 1249 insertions(+), 6 deletions(-)
 create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-galois.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-des3.c
