From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v2 0/3] Minor CCP improvements and clean-up
Date: Thu, 9 Feb 2017 15:49:38 -0600
Message-ID: <20170209214704.11781.28640.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0083.outbound.protection.outlook.com ([104.47.41.83]:20960
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753875AbdBIWYb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2017 17:24:31 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series implements...
 - Move verbose init messages to debug mode
 - Update the queue pointers in the event of an error
 - Simply buffer management and eliminate an unused option


---

Gary R Hook (3):
      crypto: ccp - Change mode for detailed CCP init messages
      crypto: ccp - Update the command queue on errors
      crypto: ccp - Simplify some buffer management routines


 drivers/crypto/ccp/ccp-dev-v5.c |   12 ++-
 drivers/crypto/ccp/ccp-ops.c    |  142 +++++++++++++++------------------------
 2 files changed, 63 insertions(+), 91 deletions(-)
