From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 0/3] Support new function in the newer CCP
Date: Wed, 15 Feb 2017 15:55:46 -0600
Message-ID: <20170215214954.26536.76736.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0064.outbound.protection.outlook.com ([104.47.36.64]:26240
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750806AbdBOVzy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 16:55:54 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series implements new function in a version 5
coprocessor. New features are:
 - Support for SHA-2 384-bit and 512-bit hashing
 - Support for AES GCM encryption
 - Support for 3DES encryption

---

Gary R Hook (3):
      crypto: ccp - Add SHA-2 384-/512-/bit support
      crypto: ccp - Add support for AES GCM on v5 CCPs
      crypto: ccp - Add 3DES function on v5 CCPs


 drivers/crypto/ccp/Makefile                |    3 
 drivers/crypto/ccp/ccp-crypto-aes-galois.c |  257 ++++++++++++++
 drivers/crypto/ccp/ccp-crypto-des3.c       |  254 ++++++++++++++
 drivers/crypto/ccp/ccp-crypto-main.c       |   30 ++
 drivers/crypto/ccp/ccp-crypto-sha.c        |   22 +
 drivers/crypto/ccp/ccp-crypto.h            |   44 ++
 drivers/crypto/ccp/ccp-dev-v3.c            |    1 
 drivers/crypto/ccp/ccp-dev-v5.c            |   54 +++
 drivers/crypto/ccp/ccp-dev.h               |   14 +
 drivers/crypto/ccp/ccp-ops.c               |  522 ++++++++++++++++++++++++++++
 include/linux/ccp.h                        |   68 ++++
 11 files changed, 1263 insertions(+), 6 deletions(-)
 create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-galois.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-des3.c
