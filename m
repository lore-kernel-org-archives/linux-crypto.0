From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 0/4] Enable full RSA support on CCPs
Date: Wed, 21 Jun 2017 17:47:36 -0500
Message-ID: <20170621224655.15132.20473.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0060.outbound.protection.outlook.com ([104.47.32.60]:43975
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751755AbdFUWrt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2017 18:47:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series enables RSA operations on version 5 devices,
adds a set-reqsize function (to provide uniformity with other cipher
APIs), implements akcipher enablement in the crypto layer, and 
makes a tweak for expanded v5 device capabilities.

---

Gary R Hook (4):
      crypto: ccp - Fix base RSA function for version 5 CCPs
      crypto: Add akcipher_set_reqsize() function
      crypto: ccp - Add support for RSA on the CCP
      crypto: ccp - Expand RSA support for a v5 ccp


 drivers/crypto/ccp/Makefile          |    1 
 drivers/crypto/ccp/ccp-crypto-main.c |   21 ++
 drivers/crypto/ccp/ccp-crypto-rsa.c  |  289 ++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-crypto.h      |   32 ++++
 drivers/crypto/ccp/ccp-debugfs.c     |    1 
 drivers/crypto/ccp/ccp-dev-v3.c      |    1 
 drivers/crypto/ccp/ccp-dev-v5.c      |   12 +
 drivers/crypto/ccp/ccp-dev.c         |    1 
 drivers/crypto/ccp/ccp-dev.h         |    2 
 drivers/crypto/ccp/ccp-ops.c         |   98 +++++++-----
 include/crypto/internal/akcipher.h   |    6 +
 include/linux/ccp.h                  |    1 
 12 files changed, 421 insertions(+), 44 deletions(-)
 create mode 100644 drivers/crypto/ccp/ccp-crypto-rsa.c
