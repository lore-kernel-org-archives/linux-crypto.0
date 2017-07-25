From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v3 0/3] Update support for XTS-AES on AMD CCPs
Date: Tue, 25 Jul 2017 14:21:12 -0500
Message-ID: <150100997531.39154.470521200404215266.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0053.outbound.protection.outlook.com ([104.47.37.53]:47040
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751841AbdGYTVU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2017 15:21:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series adds support for XS-AES on version 5 CCPs, both
128- and 256-bit, and enhances/clarifies/simplifies some crypto layer
code.

Changes since v2:
 - Move a CCP v5 fix out of this patch series and submit independently
 - In the unit-size check patch:
    - Edit comments
    - Remove unnecessary variable
    - Delay a change (that belongs in the CCP v5 patch)

Changes since v1:
 - rework the validation of the unit-size; move to a separate patch
 - expand the key buffer to accommodate 256-bit keys
 - use xts_check_key() in the crypto layer


---

Gary R Hook (3):
      crypto: ccp - Add a call to xts_check_key()
      crypto: ccp - Rework the unit-size check for XTS-AES
      crypto: ccp - Add XTS-AES-256 support for CCP version 5


 drivers/crypto/ccp/ccp-crypto-aes-xts.c |   92 +++++++++++++++++--------------
 drivers/crypto/ccp/ccp-crypto.h         |    2 -
 drivers/crypto/ccp/ccp-ops.c            |    2 +
 3 files changed, 53 insertions(+), 43 deletions(-)
