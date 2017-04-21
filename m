From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 0/2] Change CCP ISR handler model
Date: Fri, 21 Apr 2017 10:49:56 -0500
Message-ID: <20170421151225.11643.91749.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0065.outbound.protection.outlook.com ([104.47.42.65]:4869
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1161788AbdDUPwk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 11:52:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

he CCP has the ability to perform several operations
simultaneously, but only one interrupt. The current design
exposes a window when using MSI/MSI-X interrupts wherein
state can change but no interrupt is generated; this can
lead to a hang in the engine.  Switch to a tasklet backend
which allows serializing state changes, handles processing
of the interrupts, and avoids the loss of task completion
status.

---

Gary R Hook (2):
      crypto: ccp - Change ISR handler method for a v3 CCP
      crypto: ccp - Change ISR handler method for a v5 CCP


 drivers/crypto/ccp/ccp-dev-v3.c |  120 +++++++++++++++++++++++----------------
 drivers/crypto/ccp/ccp-dev-v5.c |  111 ++++++++++++++++++++++--------------
 drivers/crypto/ccp/ccp-dev.h    |    3 +
 drivers/crypto/ccp/ccp-pci.c    |    2 +
 4 files changed, 142 insertions(+), 94 deletions(-)
