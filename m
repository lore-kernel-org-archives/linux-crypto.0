Return-Path: <SRS0=jNyN=2V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48771C3F68F
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 03:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 162412071E
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 03:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577762485;
	bh=hT4ZxWyjIBHp/Lyzd3mBCy2ed7TIVIiPlYkuIgE9F5I=;
	h=From:To:Subject:Date:List-ID:From;
	b=dO1J/jziDOIKW5kxK76mPwm1eZ32vrTIX6gQRX4aukxieMUh/vUQAVJeLp0loTaZe
	 4eWbxJWgxExtY3E/n607Dl/q0zl/PRdvRaU65fDUE1u7BHT3VaoHcADm0EVF2z/LBn
	 wuDV89drUa0UAHdwFiVZ2o4RAZeynRi2SoCz38cQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbfLaDUz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Dec 2019 22:20:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbfLaDUy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Dec 2019 22:20:54 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CF5D2071E
        for <linux-crypto@vger.kernel.org>; Tue, 31 Dec 2019 03:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577762453;
        bh=hT4ZxWyjIBHp/Lyzd3mBCy2ed7TIVIiPlYkuIgE9F5I=;
        h=From:To:Subject:Date:From;
        b=XvKokCt12yKr8CB7Q9ZF/k30f3DGaaLmbrTrEDRXX2JDwO16ez82xbkePuPlwhwsM
         9vWZSWDa6q5coaTNMOyfCGoKl2Ipz0sY5cHP+RkOTxEej+XLojSTeX5b97ak22F20N
         Nv92hlJ4Gqm12NuoHwDwD34HYDYCOXG2oYsxIX9k=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 0/8] crypto: remove the CRYPTO_TFM_RES_* flags
Date:   Mon, 30 Dec 2019 21:19:30 -0600
Message-Id: <20191231031938.241705-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CRYPTO_TFM_RES_* flags are pointless since they are never checked
anywhere.  And it's not really possible for anyone to start using them
without a lot of work, since many drivers aren't setting them or are
setting them when they shouldn't.

Also, if we ever actually need to start distinguishing ->setkey() errors
better (which is somewhat unlikely, as it's been a long time with no one
caring), we'd probably be much better off just using different return
values, like -EINVAL if the key is invalid for the algorithm vs.
-EKEYREJECTED if the key was rejected by a policy like "no weak keys".
That would be much simpler, less error-prone, and easier to test.

So let's just remove these flags for now.  This gets rid of a lot of
pointless boilerplate code.

Patches 6 and 8 are a bit large since they touch so many drivers, though
the changes are straightforward and it would seem overkill to do this as
a series of 70 separate patches.  But let me know if it's needed.

Eric Biggers (8):
  crypto: chelsio - fix writing tfm flags to wrong place
  crypto: artpec6 - return correct error code for failed setkey()
  crypto: atmel-sha - fix error handling when setting hmac key
  crypto: remove unused tfm result flags
  crypto: remove CRYPTO_TFM_RES_BAD_BLOCK_LEN
  crypto: remove CRYPTO_TFM_RES_BAD_KEY_LEN
  crypto: remove CRYPTO_TFM_RES_WEAK_KEY
  crypto: remove propagation of CRYPTO_TFM_RES_* flags

 arch/arm/crypto/aes-ce-glue.c                 | 14 +-----
 arch/arm/crypto/crc32-ce-glue.c               |  4 +-
 arch/arm/crypto/ghash-ce-glue.c               | 11 +---
 arch/arm64/crypto/aes-ce-ccm-glue.c           |  8 +--
 arch/arm64/crypto/aes-ce-glue.c               |  8 +--
 arch/arm64/crypto/aes-glue.c                  | 31 ++----------
 arch/arm64/crypto/ghash-ce-glue.c             |  8 +--
 arch/mips/crypto/crc32-mips.c                 |  4 +-
 arch/powerpc/crypto/aes-spe-glue.c            | 18 ++-----
 arch/powerpc/crypto/crc32c-vpmsum_glue.c      |  4 +-
 arch/s390/crypto/aes_s390.c                   | 27 ++--------
 arch/s390/crypto/crc32-vx.c                   |  8 +--
 arch/s390/crypto/ghash_s390.c                 |  4 +-
 arch/s390/crypto/paes_s390.c                  | 25 +++-------
 arch/sparc/crypto/aes_glue.c                  |  2 -
 arch/sparc/crypto/camellia_glue.c             |  5 +-
 arch/sparc/crypto/crc32c_glue.c               |  4 +-
 arch/x86/crypto/aegis128-aesni-glue.c         |  4 +-
 arch/x86/crypto/aesni-intel_glue.c            | 10 ++--
 arch/x86/crypto/blake2s-glue.c                |  4 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c    |  3 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c     |  9 ++--
 arch/x86/crypto/camellia_glue.c               |  9 ++--
 arch/x86/crypto/cast6_avx_glue.c              |  6 +--
 arch/x86/crypto/crc32-pclmul_glue.c           |  4 +-
 arch/x86/crypto/crc32c-intel_glue.c           |  4 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c    | 11 +---
 arch/x86/crypto/twofish_avx_glue.c            |  6 +--
 arch/x86/include/asm/crypto/camellia.h        |  2 +-
 crypto/adiantum.c                             |  8 ---
 crypto/aegis128-core.c                        |  4 +-
 crypto/aes_generic.c                          | 18 +++----
 crypto/anubis.c                               |  2 -
 crypto/authenc.c                              | 12 +----
 crypto/authencesn.c                           | 12 +----
 crypto/blake2b_generic.c                      |  4 +-
 crypto/blake2s_generic.c                      |  4 +-
 crypto/camellia_generic.c                     |  5 +-
 crypto/cast6_generic.c                        | 10 ++--
 crypto/ccm.c                                  | 20 ++------
 crypto/chacha20poly1305.c                     |  7 +--
 crypto/cipher.c                               |  5 +-
 crypto/crc32_generic.c                        |  4 +-
 crypto/crc32c_generic.c                       |  4 +-
 crypto/cryptd.c                               | 13 +----
 crypto/ctr.c                                  |  7 +--
 crypto/cts.c                                  |  6 +--
 crypto/des_generic.c                          | 10 +---
 crypto/essiv.c                                | 26 ++--------
 crypto/gcm.c                                  | 19 +------
 crypto/ghash-generic.c                        |  4 +-
 crypto/lrw.c                                  |  2 -
 crypto/michael_mic.c                          |  4 +-
 crypto/simd.c                                 | 12 +----
 crypto/skcipher.c                             | 10 +---
 crypto/sm4_generic.c                          | 16 ++----
 crypto/twofish_common.c                       |  8 +--
 crypto/vmac.c                                 |  4 +-
 crypto/xts.c                                  |  8 +--
 crypto/xxhash_generic.c                       |  4 +-
 .../allwinner/sun4i-ss/sun4i-ss-cipher.c      |  1 -
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      |  1 -
 .../allwinner/sun8i-ss/sun8i-ss-cipher.c      |  2 -
 drivers/crypto/amcc/crypto4xx_alg.c           | 31 ++----------
 drivers/crypto/amlogic/amlogic-gxl-cipher.c   |  1 -
 drivers/crypto/atmel-aes.c                    | 14 ++----
 drivers/crypto/atmel-authenc.h                |  3 +-
 drivers/crypto/atmel-sha.c                    | 18 ++-----
 drivers/crypto/axis/artpec6_crypto.c          | 10 +---
 drivers/crypto/bcm/cipher.c                   | 17 +------
 drivers/crypto/caam/caamalg.c                 | 33 +++---------
 drivers/crypto/caam/caamalg_qi.c              | 44 ++++------------
 drivers/crypto/caam/caamalg_qi2.c             | 47 ++++-------------
 drivers/crypto/caam/caamhash.c                |  9 +---
 drivers/crypto/cavium/cpt/cptvf_algs.c        |  2 -
 drivers/crypto/cavium/nitrox/nitrox_aead.c    |  4 +-
 .../crypto/cavium/nitrox/nitrox_skcipher.c    | 12 ++---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c      |  1 -
 drivers/crypto/ccp/ccp-crypto-aes-galois.c    |  1 -
 drivers/crypto/ccp/ccp-crypto-aes.c           |  1 -
 drivers/crypto/ccp/ccp-crypto-sha.c           |  4 +-
 drivers/crypto/ccree/cc_aead.c                | 21 +++-----
 drivers/crypto/ccree/cc_cipher.c              |  4 --
 drivers/crypto/ccree/cc_hash.c                |  6 ---
 drivers/crypto/chelsio/chcr_algo.c            | 50 ++-----------------
 drivers/crypto/geode-aes.c                    | 24 ++-------
 .../crypto/inside-secure/safexcel_cipher.c    | 43 ++++------------
 drivers/crypto/inside-secure/safexcel_hash.c  | 22 ++------
 drivers/crypto/ixp4xx_crypto.c                | 31 ++----------
 drivers/crypto/marvell/cipher.c               |  4 +-
 drivers/crypto/mediatek/mtk-aes.c             |  4 --
 drivers/crypto/mxs-dcp.c                      | 12 +----
 drivers/crypto/n2_core.c                      |  1 -
 drivers/crypto/padlock-aes.c                  |  9 +---
 drivers/crypto/picoxcell_crypto.c             | 15 +-----
 drivers/crypto/qat/qat_common/qat_algs.c      |  6 +--
 drivers/crypto/qce/sha.c                      |  2 -
 .../crypto/rockchip/rk3288_crypto_skcipher.c  |  4 +-
 drivers/crypto/sahara.c                       |  9 +---
 drivers/crypto/stm32/stm32-crc32.c            |  4 +-
 drivers/crypto/talitos.c                      | 15 ++----
 drivers/crypto/ux500/cryp/cryp_core.c         |  2 -
 drivers/crypto/virtio/virtio_crypto_algs.c    |  8 +--
 include/crypto/cast6.h                        |  3 +-
 include/crypto/internal/des.h                 | 23 ++-------
 include/crypto/twofish.h                      |  2 +-
 include/crypto/xts.h                          | 19 ++-----
 include/linux/crypto.h                        |  7 ---
 108 files changed, 218 insertions(+), 917 deletions(-)

-- 
2.24.1

