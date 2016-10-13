From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 0/6] Enable hashing and ciphers for v5 CCP
Date: Thu, 13 Oct 2016 09:52:38 -0500
Message-ID: <20161013144542.19759.6924.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0056.outbound.protection.outlook.com ([104.47.41.56]:10432
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752765AbcJMPJD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 11:09:03 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series implements new function for a version 5
CCP: Support for SHA-2, wiring of RSA using the updated
framework, AES GCM mode, and Triple-DES in ECB mode.

---

Gary R Hook (6):
      crypto: ccp - Add SHA-2 support
      crypto: ccp - Remove unneeded sign-extension support
      crypto: ccp - Add support for RSA on the CCP
      crypto: ccp - Add RSA support for a v5 ccp
      crypto: ccp - Enable support for AES GCM on v5 CCPs
      crypto: ccp - Enable 3DES function on v5 CCPs


 drivers/crypto/ccp/Makefile                |    3 
 drivers/crypto/ccp/ccp-crypto-aes-galois.c |  252 +++++++++
 drivers/crypto/ccp/ccp-crypto-des3.c       |  254 +++++++++
 drivers/crypto/ccp/ccp-crypto-main.c       |   37 +
 drivers/crypto/ccp/ccp-crypto-rsa.c        |  258 +++++++++
 drivers/crypto/ccp/ccp-crypto-sha.c        |   22 +
 drivers/crypto/ccp/ccp-crypto.h            |   69 ++-
 drivers/crypto/ccp/ccp-dev-v3.c            |   39 +
 drivers/crypto/ccp/ccp-dev-v5.c            |   67 ++
 drivers/crypto/ccp/ccp-dev.h               |   21 +
 drivers/crypto/ccp/ccp-ops.c               |  772 ++++++++++++++++++++++++----
 drivers/crypto/ccp/ccp-pci.c               |    2 
 include/linux/ccp.h                        |  103 ++++
 13 files changed, 1768 insertions(+), 131 deletions(-)
 create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-galois.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-des3.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-rsa.c

--
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
