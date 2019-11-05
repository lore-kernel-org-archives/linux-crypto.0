Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A61C17460
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 13:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A13CE21D7C
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 13:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572960520;
	bh=byQuJlwrjKJGf+4LH46ehsbCHdiTeCTF68Q9XlCJTKc=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=WS1QxYuen2+8XK1kJmY2DHNY3jVQSEdILMrS7gTxRpdzLJAP5211/GPHhnIigdtFv
	 qc6w/7zp1ZGFv1xY4jfGr7zDlB5WbFDC0KdlvDfq05bHQ+ZrHOouZJepN4E6iLx2A/
	 uLIe3Mw1XABSkDujqHuX9iWJpGoUnhajtjGBw9vA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389026AbfKEN2k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 08:28:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388963AbfKEN2j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 08:28:39 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB72521882;
        Tue,  5 Nov 2019 13:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572960518;
        bh=byQuJlwrjKJGf+4LH46ehsbCHdiTeCTF68Q9XlCJTKc=;
        h=From:To:Cc:Subject:Date:From;
        b=NBWN2L/vyRdRhOIKAYGDcwFzrHk8DMros9UG6P1fnc8Vu7Totf2EKlMzKieMV6uvp
         kEUCK3ij3Eoq5ufd1EkoQQ3FWRZo5JFoiRkALW5xmsyrgyU9+f2Nvpyw8lZTz0SAOL
         46dP57AOCnZmlAOoAKOgarFy2y1FS/UZZIqLKYUg=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 00/29] crypto: convert h/w accelerator drivers to skcipher API
Date:   Tue,  5 Nov 2019 14:27:57 +0100
Message-Id: <20191105132826.1838-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series converts all drivers for h/w accelerators that produce the
ablkcipher API to the skcipher API, so that we can finally retire the
long deprecated ablkcipher code.

Changes since v2:
- added a patch that removes the ablkcipher support code itself
- fix an issue in the talitos code
- add tero's ack to patch #5
- add stanimir's ack to patch #20

Changes since v1:
- remove some more [cosmetic] references to [a]blkcipher (#26-#27)
- add back missing IV for cbc(aes) in the omap driver, fixing a crash
- add Gary's ack to #4
- add Linus's ack to #6 and #15
- add Kamil's and Krzysztof's acks to #7
- fixed a bug in the Atmel patch (#8)
- add Horia's tested-by to #16
- add Dave's ack to #22

Patches #1, #2 are fixes for the virtio driver, which need to be applied
first so that they can be backported

Patches #3 and #4 have been tested on actual 'hardware' (given the virtual
nature of the virtio driver). Patch #7 was tested successfully in kernelci.
Patch #5 was tested by Tero. Patch #16 was tested by Horia.

All other patches have been build tested *only*, and should preferably be
tested on actual hardware before being merged. Note that patches can be
merged piecemeal (with the exception of #1 .. #3 which should be taken as a
set, and #28 which removes the ablkcipher support code) since there are no
dependencies between them. However, deferring this series indefinitely until
everyone has chimed in doesn't seem like a useful approach either, so I am
leaving it up to the maintainers to decide when we have reached critical
mass and the whole series can be taken.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Biggers <ebiggers@google.com>
Cc: linux-arm-kernel@lists.infradead.org

Ard Biesheuvel (29):
  crypto: virtio - implement missing support for output IVs
  crypto: virtio - deal with unsupported input sizes
  crypto: virtio - switch to skcipher API
  crypto: ccp - switch from ablkcipher to skcipher
  crypto: omap - switch to skcipher API
  crypto: ux500 - switch to skcipher API
  crypto: s5p - switch to skcipher API
  crypto: atmel-aes - switch to skcipher API
  crypto: atmel-tdes - switch to skcipher API
  crypto: bcm-spu - switch to skcipher API
  crypto: nitrox - remove cra_type reference to ablkcipher
  crypto: cavium/cpt - switch to skcipher API
  crypto: chelsio - switch to skcipher API
  crypto: hifn - switch to skcipher API
  crypto: ixp4xx - switch to skcipher API
  crypto: mxs - switch to skcipher API
  crypto: mediatek - switch to skcipher API
  crypto: sahara - switch to skcipher API
  crypto: picoxcell - switch to skcipher API
  crypto: qce - switch to skcipher API
  crypto: stm32 - switch to skcipher API
  crypto: niagara2 - switch to skcipher API
  crypto: rockchip - switch to skcipher API
  crypto: talitos - switch to skcipher API
  crypto: qat - switch to skcipher API
  crypto: marvell/cesa - rename blkcipher to skcipher
  crypto: nx - remove stale comment referring to the blkcipher walk API
  crypto: remove deprecated and unused ablkcipher support
  crypto: ccree - update a stale reference to ablkcipher

 Documentation/crypto/api-skcipher.rst              |  20 +-
 Documentation/crypto/architecture.rst              |   2 -
 Documentation/crypto/crypto_engine.rst             |   4 -
 crypto/Makefile                                    |   4 +-
 crypto/ablkcipher.c                                | 407 --------------
 crypto/algapi.c                                    |  26 -
 crypto/crypto_engine.c                             |  29 -
 crypto/skcipher.c                                  | 106 ----
 drivers/crypto/Kconfig                             |   2 +-
 drivers/crypto/atmel-aes.c                         | 509 +++++++++---------
 drivers/crypto/atmel-tdes.c                        | 433 ++++++++-------
 drivers/crypto/bcm/cipher.c                        | 373 +++++++------
 drivers/crypto/bcm/cipher.h                        |  10 +-
 drivers/crypto/bcm/spu2.c                          |   6 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c             | 292 +++++-----
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c     |   1 -
 drivers/crypto/ccp/ccp-crypto-aes-galois.c         |   7 +-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c            |  94 ++--
 drivers/crypto/ccp/ccp-crypto-aes.c                | 169 +++---
 drivers/crypto/ccp/ccp-crypto-des3.c               | 100 ++--
 drivers/crypto/ccp/ccp-crypto-main.c               |  14 +-
 drivers/crypto/ccp/ccp-crypto.h                    |  13 +-
 drivers/crypto/ccree/cc_cipher.c                   |   4 +-
 drivers/crypto/chelsio/chcr_algo.c                 | 334 ++++++------
 drivers/crypto/chelsio/chcr_algo.h                 |   2 +-
 drivers/crypto/chelsio/chcr_crypto.h               |  16 +-
 drivers/crypto/hifn_795x.c                         | 183 +++----
 drivers/crypto/ixp4xx_crypto.c                     | 228 ++++----
 drivers/crypto/marvell/cesa.h                      |   6 +-
 drivers/crypto/marvell/cipher.c                    |  14 +-
 drivers/crypto/mediatek/mtk-aes.c                  | 248 ++++-----
 drivers/crypto/mxs-dcp.c                           | 140 +++--
 drivers/crypto/n2_core.c                           | 194 ++++---
 drivers/crypto/nx/nx-aes-ccm.c                     |   5 -
 drivers/crypto/nx/nx-aes-gcm.c                     |   5 -
 drivers/crypto/omap-aes.c                          | 209 ++++----
 drivers/crypto/omap-aes.h                          |   4 +-
 drivers/crypto/omap-des.c                          | 232 ++++----
 drivers/crypto/picoxcell_crypto.c                  | 386 +++++++-------
 drivers/crypto/qat/qat_common/qat_algs.c           | 255 +++++----
 drivers/crypto/qat/qat_common/qat_crypto.h         |   4 +-
 drivers/crypto/qce/Makefile                        |   2 +-
 drivers/crypto/qce/cipher.h                        |   8 +-
 drivers/crypto/qce/common.c                        |  12 +-
 drivers/crypto/qce/common.h                        |   3 +-
 drivers/crypto/qce/core.c                          |   2 +-
 drivers/crypto/qce/{ablkcipher.c => skcipher.c}    | 172 +++---
 drivers/crypto/rockchip/Makefile                   |   2 +-
 drivers/crypto/rockchip/rk3288_crypto.c            |   8 +-
 drivers/crypto/rockchip/rk3288_crypto.h            |   3 +-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 556 --------------------
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c   | 538 +++++++++++++++++++
 drivers/crypto/s5p-sss.c                           | 187 ++++---
 drivers/crypto/sahara.c                            | 156 +++---
 drivers/crypto/stm32/stm32-cryp.c                  | 338 ++++++------
 drivers/crypto/talitos.c                           | 308 +++++------
 drivers/crypto/ux500/cryp/cryp_core.c              | 371 ++++++-------
 drivers/crypto/virtio/virtio_crypto_algs.c         | 192 +++----
 drivers/crypto/virtio/virtio_crypto_common.h       |   2 +-
 include/crypto/aead.h                              |   2 +-
 include/crypto/algapi.h                            |  75 ---
 include/crypto/engine.h                            |   4 -
 include/crypto/hash.h                              |   2 +-
 include/crypto/internal/des.h                      |  12 -
 include/crypto/internal/skcipher.h                 |  20 -
 include/crypto/skcipher.h                          |   6 -
 include/linux/crypto.h                             | 435 ---------------
 67 files changed, 3506 insertions(+), 5000 deletions(-)
 delete mode 100644 crypto/ablkcipher.c
 rename drivers/crypto/qce/{ablkcipher.c => skcipher.c} (61%)
 delete mode 100644 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
 create mode 100644 drivers/crypto/rockchip/rk3288_crypto_skcipher.c

-- 
2.20.1

