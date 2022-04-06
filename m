Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5748DC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 17:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbiDFREP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238266AbiDFREC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Apr 2022 13:04:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880AB48782B
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 07:27:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE91B617A5
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 14:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA072C385A1;
        Wed,  6 Apr 2022 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255244;
        bh=PCK62i20Ft+uGq0DJl+cExsuzto56UOLksJaM9cdlOo=;
        h=From:To:Cc:Subject:Date:From;
        b=CpGmHvuyyNmlP6jElFeeXqqQQy0dK77HBLnS+EQ+1942+s9Acn0KgReUE5N8/mMBg
         he2M7TnX2j+jhgBkLXPZdvqfWTaE0VRYTWNsehgi5hDcPJFnUVERZED5EjEJG0oPQ/
         JsG9zoNfmSeDVuMrRfLNLyrZCzFGfDqiKKMku4SzXtqWj6wxh+S9oPbsti1WQiB7Te
         Eo4ubJlCr0mxvHTMdpHLnQtokHsrFDaUkJIvg2Lt3/bpLv0RGY4yIXkWVmK8dnQs4K
         bZ5f/7jOmnR1p4Zj+d1t7H1hwdyW05h8n2PpZH/mNwHFqMfLOzPQffr9KqSJz+FF1B
         JBWtyW3G0gsnA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, keescook@chromium.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Saravana Kannan <saravanak@google.com>
Subject: [PATCH 0/8] crypto: avoid DMA padding for request structures
Date:   Wed,  6 Apr 2022 16:27:07 +0200
Message-Id: <20220406142715.2270256-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7104; h=from:subject; bh=PCK62i20Ft+uGq0DJl+cExsuzto56UOLksJaM9cdlOo=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBiTaM1frsNpHTqcIMT+TKAEcGM0XwuDJg6aMvxitMY VNmZ1byJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYk2jNQAKCRDDTyI5ktmPJLVDDA CCB8WwlRPMWdO0qZJbip7+Gjb3hTKafI9J0W6sbvp71Vl3mTpJKDYwjdaBopbgtGC8PuadrcP5qMB0 7u02dgwIlfFVDsY3ABLVXEGh6XrlZsOCDAsfHYgubUN54ZgkKiF8/V2XX6SXRcNKb7wSaUBRrTTciv kyNuyLhKy8bpZYeTTMLT6VzoBMR9JHHRA6SVWQhvqrKuivyVjAwjiJp/Y8ntB8kkZC4ydFgErpC3fV QDvsRgwxipguay+fzt2CWSlRKFbB0wWAOBnf58+OAZfuvFVY/RxriDMfbMVUdVktY7W+UVmVPbgzPC px3AogWdaMepZSh1dKGEDkQJZuExeZ3pYn50yKha1WyDMg+2nqF5OcutdMEQHi/ukymC2/t/MetPLH QjL2h/PxCEF9RiE0SK/cbFcyqTxK9KQLfPqrWlUkGmEhVopC0n3/vPdwU5y8ilCQJWNw0GBun8mauZ WFMkrurvwx8alpjjNfOtFODSZlKF13BdH8X4BBT2cFH78=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series is related to Catalin's work [0] on reducing the memory
overhead of supporting non-coherent DMA, which requires memory buffers
to be rounded up to avoid corruption by the cache invalidation that is
needed for inbound DMA.

In the crypto subsystem, every skcipher, aead or ahash request requires
a request struct to be allocated, and these are usually backed by
kmalloc(). Such request buffers are sized dynamically, based on the
requirements of the implementation of the algorithm, and the surplus is
made available to the driver via an opaque context pointer.

Since some drivers may perform inbound non-coherent DMA into that
buffer, it must not share any cachelines with adjacent allocations, and
this is why the context pointer is rounded up to ARCH_KMALLOC_MINALIGN,
which takes the minimum DMA alignment into account on architectures
where this is needed.

This means that, even when using crypto drivers that don't do DMA to
begin with (which includes synchronous skciphers, aeads and ahashes
based on CPU instructions), or that do only coherent DMA are forced to
perform this padding and alignment, which may affect the memory
footprint substantially: on arm64, the compile time minimum DMA
alignment is 128 bytes.

So instead, require drivers to set a new flag
CRYPTO_ALG_NEED_DMA_ALIGNMENT if it performs DMA into the context
buffers, and only take DMA alignment into account if the flag is set.

Initially, we set this flag for all asynchronous accelerator drivers in
drivers/crypto, which simply preserves the status quo for these systems
once the subsequent patches get rid of this overhead. Future patches
could be applied to drivers that don't actually need it, or only need it
when running in non-coherent mode.

Note that the new approach proposed here still uses the compile time
value for DMA alignment, but this can be updated to use the runtime
values (which is usually lower and therefore less wasteful) after
Catalin's changes land.

[0] https://lore.kernel.org/linux-arm-kernel/20220405135758.774016-1-catalin.marinas@arm.com/

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>,
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Saravana Kannan <saravanak@google.com>

Ard Biesheuvel (8):
  crypto: add flag for algos that need DMA aligned context buffers
  crypto: safexcel - take request size after setting TFM
  crypto: drivers - set CRYPTO_ALG_NEED_DMA_ALIGNMENT where needed
  crypto: drivers - avoid setting skcipher TFM reqsize directly
  crypto: skcipher - avoid rounding up request size to DMA alignment
  crypto: aead - avoid DMA alignment for request structures unless
    needed
  crypto: ahash - avoid DMA alignment for request structures unless
    needed
  crypto: safexcel - reduce alignment of stack buffer

 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c |  6 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c   | 20 +++----
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c |  6 +-
 drivers/crypto/amcc/crypto4xx_core.c                |  8 +++
 drivers/crypto/amlogic/amlogic-gxl-cipher.c         |  5 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c           |  2 +
 drivers/crypto/atmel-aes.c                          |  2 +-
 drivers/crypto/atmel-sha.c                          |  2 +-
 drivers/crypto/atmel-tdes.c                         |  2 +-
 drivers/crypto/axis/artpec6_crypto.c                |  8 +++
 drivers/crypto/bcm/cipher.c                         | 23 +++++++-
 drivers/crypto/caam/caamalg.c                       |  4 +-
 drivers/crypto/caam/caamalg_qi.c                    |  2 +
 drivers/crypto/caam/caamalg_qi2.c                   |  4 +-
 drivers/crypto/caam/caamhash.c                      |  3 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c              |  6 ++
 drivers/crypto/cavium/nitrox/nitrox_aead.c          |  6 +-
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c      | 24 +++++---
 drivers/crypto/ccree/cc_aead.c                      |  3 +
 drivers/crypto/ccree/cc_cipher.c                    |  3 +
 drivers/crypto/ccree/cc_hash.c                      |  6 ++
 drivers/crypto/chelsio/chcr_algo.c                  |  5 +-
 drivers/crypto/gemini/sl3516-ce-cipher.c            |  5 +-
 drivers/crypto/gemini/sl3516-ce-core.c              |  1 +
 drivers/crypto/hifn_795x.c                          |  4 +-
 drivers/crypto/hisilicon/sec/sec_algs.c             |  8 +++
 drivers/crypto/hisilicon/sec2/sec_crypto.c          |  2 +
 drivers/crypto/inside-secure/safexcel.h             | 17 +++---
 drivers/crypto/inside-secure/safexcel_cipher.c      | 55 ++++++++++++++++--
 drivers/crypto/inside-secure/safexcel_hash.c        | 26 +++++++++
 drivers/crypto/ixp4xx_crypto.c                      |  2 +
 drivers/crypto/keembay/keembay-ocs-aes-core.c       | 12 ++++
 drivers/crypto/keembay/keembay-ocs-hcu-core.c       | 30 ++++++----
 drivers/crypto/marvell/cesa/cipher.c                |  6 ++
 drivers/crypto/marvell/cesa/hash.c                  |  6 ++
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c    | 60 +++++++++++++++-----
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c  | 52 ++++++++++++-----
 drivers/crypto/mxs-dcp.c                            |  8 ++-
 drivers/crypto/n2_core.c                            |  1 +
 drivers/crypto/omap-aes.c                           |  5 ++
 drivers/crypto/omap-des.c                           |  4 ++
 drivers/crypto/omap-sham.c                          | 12 ++++
 drivers/crypto/qce/aead.c                           |  1 +
 drivers/crypto/qce/sha.c                            |  3 +-
 drivers/crypto/qce/skcipher.c                       |  1 +
 drivers/crypto/rockchip/rk3288_crypto_ahash.c       |  3 +
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c    | 18 ++++--
 drivers/crypto/s5p-sss.c                            |  6 ++
 drivers/crypto/sa2ul.c                              |  9 +++
 drivers/crypto/sahara.c                             | 14 +++--
 drivers/crypto/stm32/stm32-cryp.c                   | 27 ++++++---
 drivers/crypto/stm32/stm32-hash.c                   |  8 +++
 drivers/crypto/talitos.c                            | 40 +++++++++++++
 drivers/crypto/ux500/cryp/cryp_core.c               | 21 ++++---
 drivers/crypto/ux500/hash/hash_core.c               | 12 ++--
 drivers/crypto/xilinx/zynqmp-aes-gcm.c              |  1 +
 include/crypto/aead.h                               |  2 +-
 include/crypto/hash.h                               |  5 +-
 include/crypto/internal/aead.h                      | 13 ++++-
 include/crypto/internal/hash.h                      | 10 +++-
 include/crypto/internal/skcipher.h                  | 13 ++++-
 include/crypto/skcipher.h                           |  8 +--
 include/linux/crypto.h                              | 21 +++++++
 63 files changed, 568 insertions(+), 134 deletions(-)

-- 
2.30.2

