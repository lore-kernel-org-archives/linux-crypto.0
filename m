From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH V2 0/3] Series short description
Date: Thu, 2 Mar 2017 15:26:30 -0600
Message-ID: <20170302212331.30959.44149.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <gary.hook@amd.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0063.outbound.protection.outlook.com ([104.47.41.63]:21343
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751805AbdCBXC0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Mar 2017 18:02:26 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series:
- Move verbose init messages to debug mode
- Update the queue pointers in the event of an error
- Simplify buffer management and eliminate an unused option

---

Gary R Hook (3):
      crypto: ccp - Add SHA-2 384- and 512-bit support
      crypto: ccp - Enable support for AES GCM on v5 CCPs
      crypto: ccp - Enable 3DES function on v5 CCPs


 drivers/crypto/ccp/Makefile                |    2 
 drivers/crypto/ccp/ccp-crypto-aes-galois.c |  257 ++++++++++++++
 drivers/crypto/ccp/ccp-crypto-des3.c       |  254 ++++++++++++++
 drivers/crypto/ccp/ccp-crypto-main.c       |   22 +
 drivers/crypto/ccp/ccp-crypto-sha.c        |   22 +
 drivers/crypto/ccp/ccp-crypto.h            |   44 ++
 drivers/crypto/ccp/ccp-dev-v3.c            |    1 
 drivers/crypto/ccp/ccp-dev-v5.c            |   56 +++
 drivers/crypto/ccp/ccp-dev.h               |   15 +
 drivers/crypto/ccp/ccp-ops.c               |  522 ++++++++++++++++++++++++++++
 include/linux/ccp.h                        |   68 ++++
 11 files changed, 1257 insertions(+), 6 deletions(-)
 create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-galois.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-des3.c
