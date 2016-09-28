From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v2 0/2] Minor CCP driver changes
Date: Wed, 28 Sep 2016 11:53:31 -0500
Message-ID: <20160928165204.23263.77515.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0087.outbound.protection.outlook.com ([104.47.34.87]:43546
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932856AbcI1RIu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 13:08:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

V2: point a goto statement at the correct label

The following series is for miscellaneous small changes.

---

Gary R Hook (2):
      crypto: ccp - clean up data structure
      crypto: ccp - Make syslog errors human-readable



 drivers/crypto/ccp/ccp-dev-v3.c |    5 +++-
 drivers/crypto/ccp/ccp-dev-v5.c |   12 +++++++--
 drivers/crypto/ccp/ccp-dev.c    |   53 +++++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-dev.h    |    8 ++++--
 drivers/crypto/ccp/ccp-pci.c    |    4 +--
 5 files changed, 73 insertions(+), 9 deletions(-)

--
