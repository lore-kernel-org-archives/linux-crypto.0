From: Tudor Ambarus <tudor.ambarus@gmail.com>
Subject: [v2 RFC PATCH 0/2] crypto: ecdh, ecc fixes
Date: Wed, 28 Jun 2017 16:55:22 +0300
Message-ID: <1498658124-29780-1-git-send-email-tudor.ambarus@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <nicolas.ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@gmail.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:41763 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751495AbdF1Nzd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 09:55:33 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The first patch fixes concurrency on ecdh context
and the second one let the caller decide whether
sleeping is possible or not.

Changes in v2:
 - remove a function that freed a pointer received as function
   argument
 - let the user decide if sleeping is permitted
 - kmalloc instead of kzalloc for the private key

 - add "crypto: ecc: use caller's GFP flags" patch

v1 can be found at:
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg26149.html

Tudor Ambarus (2):
  crypto: ecdh: fix concurrency on ecdh_ctx
  crypto: ecc: use caller's GFP flags

 crypto/ecc.c  | 22 +++++++-------
 crypto/ecc.h  |  8 ++---
 crypto/ecdh.c | 96 +++++++++++++++++++++++++++++++++++++++++------------------
 3 files changed, 82 insertions(+), 44 deletions(-)

-- 
2.7.4
