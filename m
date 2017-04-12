From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 0/2] Interrupt management fixes
Date: Wed, 12 Apr 2017 17:54:25 -0500
Message-ID: <20170412225324.17707.75176.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0042.outbound.protection.outlook.com ([104.47.40.42]:4440
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754893AbdDLWyl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2017 18:54:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series implements...
Correct the driver to attend only to interrupt bits that
are relevant, and ensure that interrupts are managed
properly at module unload.

---

Gary R Hook (2):
      crypto: ccp - Use only the relevant interrupt bits
      crypto: ccp - Disable interrupts early on unload


 drivers/crypto/ccp/ccp-dev-v5.c |    4 ++--
 drivers/crypto/ccp/ccp-dev.h    |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)
