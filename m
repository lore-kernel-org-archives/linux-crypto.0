From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v2 0/4] Update support for XTS-AES on AMD CCPs
Date: Fri, 21 Jul 2017 14:04:35 -0500
Message-ID: <150066355075.49973.1565434199212056832.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0074.outbound.protection.outlook.com ([104.47.42.74]:63776
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751504AbdGUTEl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 15:04:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series adds support for XS-AES on version 5 CCPs,
both 128- and 256-bit, and enhances/clarifies/simplifies some
crypto layer code.

Changes since v1:
 - rework the validation of the unit-size; move to a separate patch
 - expand the key buffer to accommodate 256-bit keys
 - use xts_check_key() in the crypto layer

---

Gary R Hook (4):
      crypto: ccp - Add a call to xts_check_key()
      crypto: ccp - Enable XTS-AES-128 support on all CCPs
      crypto: ccp - Rework the unit-size check for XTS-AES
      crypto: ccp - Add XTS-AES-256 support for CCP version 5


 drivers/crypto/ccp/ccp-crypto-aes-xts.c |   98 +++++++++++++++++--------------
 drivers/crypto/ccp/ccp-crypto.h         |    2 -
 drivers/crypto/ccp/ccp-dev-v5.c         |    2 +
 drivers/crypto/ccp/ccp-dev.h            |    2 +
 drivers/crypto/ccp/ccp-ops.c            |   55 +++++++++++++++--
 5 files changed, 106 insertions(+), 53 deletions(-)
