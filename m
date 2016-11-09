From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 00/14] crypto: caam - fixes, clean-up
Date: Wed, 9 Nov 2016 10:46:10 +0200
Message-ID: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0086.outbound.protection.outlook.com ([104.47.33.86]:64122
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751745AbcKIJD3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2016 04:03:29 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a batch of fixes and clean-up for caam driver.

Only the fix for the givencrypt shared descriptors is high-impact
and thus sent to -stable.

Thanks,
Horia

Alex Porosanu (1):
  crypto: caam - fix AEAD givenc descriptors

Horia Geantă (13):
  crypto: caam - completely remove error propagation handling
  crypto: caam - desc.h fixes
  crypto: caam - fix sparse warnings
  crypto: caam - fix smatch warnings
  crypto: caam - remove unused may_sleep in dbg_dump_sg()
  crypto: caam - remove unused command from aead givencrypt
  crypto: caam - trivial code clean-up
  crypto: caam - remove unreachable code in report_ccb_status()
  crypto: caam - fix DMA API mapping leak in ablkcipher code
  Revert "crypto: caam - get rid of tasklet"
  crypto: caam - move sec4_sg_entry to sg_sw_sec4.h
  crypto: caam - constify pointer to descriptor buffer
  crypto: caam - merge identical ahash_final/finup shared desc

 drivers/crypto/caam/caamalg.c     | 92 +++++++++++++++++++++++++--------------
 drivers/crypto/caam/caamhash.c    | 43 +++---------------
 drivers/crypto/caam/caampkc.c     |  4 +-
 drivers/crypto/caam/caamrng.c     | 10 ++---
 drivers/crypto/caam/ctrl.c        | 40 ++++++++---------
 drivers/crypto/caam/desc.h        | 22 ++++------
 drivers/crypto/caam/desc_constr.h | 72 +++++++++++++++---------------
 drivers/crypto/caam/error.c       |  5 +--
 drivers/crypto/caam/intern.h      |  1 +
 drivers/crypto/caam/jr.c          | 27 +++++++-----
 drivers/crypto/caam/sg_sw_sec4.h  |  6 ++-
 11 files changed, 158 insertions(+), 164 deletions(-)

-- 
2.4.4
