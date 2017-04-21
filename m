From: George Cherian <george.cherian@cavium.com>
Subject: [PATCH 0/3] Add more algorithms and some misc cleanups
Date: Fri, 21 Apr 2017 11:16:03 +0000
Message-ID: <1492773366-17899-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: george.cherian@cavium.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0070.outbound.protection.outlook.com ([104.47.41.70]:63120
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751215AbdDUFrX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 01:47:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series adds more algorithem support for CPT.
Add support for
	-ecb(aes) 
	-cfb(aes) 
	-ecb(des3_ede)

Some cleanups too.

George Cherian (3):
  crypto: cavium: Downgrade the annoying misc interrupt print from
    dev_err to dev_dbg
  crypto: cavium: Remove the individual encrypt/decrypt function for
    each algorithm
  crypto: cavium: Add more algorithms

 drivers/crypto/cavium/cpt/cptvf_algs.c | 196 ++++++++++++++++++++++-----------
 drivers/crypto/cavium/cpt/cptvf_algs.h |   7 ++
 drivers/crypto/cavium/cpt/cptvf_main.c |   2 +-
 3 files changed, 141 insertions(+), 64 deletions(-)

-- 
2.1.4
