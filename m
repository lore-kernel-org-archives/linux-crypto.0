From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH V3 0/2] Interrupt management fixes
Date: Thu, 20 Apr 2017 15:24:00 -0500
Message-ID: <20170420202030.4843.76826.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0042.outbound.protection.outlook.com ([104.47.32.42]:25696
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1032441AbdDTUYH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 16:24:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Correct the driver to attend to only relevant interrupt
bits, and ensure that interrupts are managed properly
at module unload.

Changes from V2:
- Apply patches to relevant stable branches

Changes from V1:
- Changed the #define to "SUPPORTED_INTERRUPTS"

---

Gary R Hook (2):
      crypto: ccp - Use only the relevant interrupt bits
      crypto: ccp - Disable interrupts early on unload


 drivers/crypto/ccp/ccp-dev-v5.c |   11 ++++++-----
 drivers/crypto/ccp/ccp-dev.h    |    5 ++---
 2 files changed, 8 insertions(+), 8 deletions(-)
