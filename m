From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 00/10] crypto: caam - shared descriptor generation refactoring
Date: Tue, 22 Nov 2016 15:44:02 +0200
Message-ID: <1479822252-23833-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0085.outbound.protection.outlook.com ([104.47.32.85]:8975
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933048AbcKVN7W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2016 08:59:22 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In preparation for the caam/qi (Queue Interface) driver, the generation
of the shared descriptors is abstracted and exported.
This way the existing caam/jr (Job Ring) and caam/qi drivers will have
a common base of descriptors.

Thanks,
Horia

Horia Geantă (10):
  crypto: caam - move append_key_aead() into init_sh_desc_key_aead()
  crypto: caam - group algorithm related params
  crypto: caam - remove superfluous alg_op algorithm param
  crypto: caam - improve key inlining
  crypto: caam - rewrite some generic inline append cmds
  crypto: caam - remove unneded dependencies on CRYPTO_DEV_FSL_CAAM
  crypto: caam - refactor encryption descriptors generation
  crypto: caam - consolidate split key length computation
  crypto: caam - refactor ahash shared descriptor generation
  MAINTAINERS: add maintainers for caam crypto driver

 MAINTAINERS                        |    8 +
 drivers/crypto/caam/Kconfig        |   11 +-
 drivers/crypto/caam/Makefile       |    1 +
 drivers/crypto/caam/caamalg.c      | 1421 +++++-------------------------------
 drivers/crypto/caam/caamalg_desc.c | 1302 +++++++++++++++++++++++++++++++++
 drivers/crypto/caam/caamalg_desc.h |   97 +++
 drivers/crypto/caam/caamhash.c     |  184 ++---
 drivers/crypto/caam/desc_constr.h  |   58 ++
 drivers/crypto/caam/key_gen.c      |   62 +-
 drivers/crypto/caam/key_gen.h      |    6 +-
 10 files changed, 1767 insertions(+), 1383 deletions(-)
 create mode 100644 drivers/crypto/caam/caamalg_desc.c
 create mode 100644 drivers/crypto/caam/caamalg_desc.h

-- 
2.4.4
