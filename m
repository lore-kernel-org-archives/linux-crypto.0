From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH V2 0/2] Interrupt management fixes
Date: Thu, 13 Apr 2017 11:46:36 -0500
Message-ID: <20170413164352.11624.84058.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0040.outbound.protection.outlook.com ([104.47.40.40]:21184
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752689AbdDMQqx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Apr 2017 12:46:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Correct the driver to attend to only relevant interrupt
bits, and ensure that interrupts are managed properly
at module unload.

Changes from V1:
- Changed the #define to "SUPPORTED_INTERRUPTS"

---

Gary R Hook (2):
      crypto: ccp - Use only the relevant interrupt bits
      crypto: ccp - Disable interrupts early on unload


 drivers/crypto/ccp/ccp-dev-v5.c |   11 ++++++-----
 drivers/crypto/ccp/ccp-dev.h    |    5 ++---
 2 files changed, 8 insertions(+), 8 deletions(-)
