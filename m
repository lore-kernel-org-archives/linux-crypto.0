From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 0/4] Minor CCP driver improvements and clean-up
Date: Mon, 30 Jan 2017 08:28:16 -0600
Message-ID: <20170130142414.8459.71539.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0054.outbound.protection.outlook.com ([104.47.33.54]:19328
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753439AbdA3O2e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2017 09:28:34 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series implements:
 - Move verbose init messages to debug mode
 - Set the start-of-cmmand bit for all SHA operations
 - Update the queue pointers in the event of an error
 - Simplify buffer management and eliminate an unused option

---

Gary R Hook (4):
      crypto: ccp - Change mode for detailed CCP init messages
      crypto: ccp - Set the start-of-command bit
      crypto: ccp - Update the command queue on errors
      crypto: ccp - Simplify some buffer management routines


 drivers/crypto/ccp/ccp-dev-v5.c |   12 ++-
 drivers/crypto/ccp/ccp-ops.c    |  142 +++++++++++++++------------------------
 2 files changed, 63 insertions(+), 91 deletions(-)

--
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
