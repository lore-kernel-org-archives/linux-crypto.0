Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF17C32771
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 05:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F2592073A
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 05:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgAIFOO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 00:14:14 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:40390 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgAIFON (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 00:14:13 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ipQ96-0003HS-LU; Thu, 09 Jan 2020 13:14:12 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ipQ96-0003W0-FG; Thu, 09 Jan 2020 13:14:12 +0800
Date:   Thu, 9 Jan 2020 13:14:12 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/8] crypto: remove the CRYPTO_TFM_RES_* flags
Message-ID: <20200109051412.hnsjznqfss5aret4@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231031938.241705-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> The CRYPTO_TFM_RES_* flags are pointless since they are never checked
> anywhere.  And it's not really possible for anyone to start using them
> without a lot of work, since many drivers aren't setting them or are
> setting them when they shouldn't.
> 
> Also, if we ever actually need to start distinguishing ->setkey() errors
> better (which is somewhat unlikely, as it's been a long time with no one
> caring), we'd probably be much better off just using different return
> values, like -EINVAL if the key is invalid for the algorithm vs.
> -EKEYREJECTED if the key was rejected by a policy like "no weak keys".
> That would be much simpler, less error-prone, and easier to test.
> 
> So let's just remove these flags for now.  This gets rid of a lot of
> pointless boilerplate code.
> 
> Patches 6 and 8 are a bit large since they touch so many drivers, though
> the changes are straightforward and it would seem overkill to do this as
> a series of 70 separate patches.  But let me know if it's needed.
> 
> Eric Biggers (8):
>  crypto: chelsio - fix writing tfm flags to wrong place
>  crypto: artpec6 - return correct error code for failed setkey()
>  crypto: atmel-sha - fix error handling when setting hmac key
>  crypto: remove unused tfm result flags
>  crypto: remove CRYPTO_TFM_RES_BAD_BLOCK_LEN
>  crypto: remove CRYPTO_TFM_RES_BAD_KEY_LEN
>  crypto: remove CRYPTO_TFM_RES_WEAK_KEY
>  crypto: remove propagation of CRYPTO_TFM_RES_* flags
> 
> arch/arm/crypto/aes-ce-glue.c                 | 14 +-----
> arch/arm/crypto/crc32-ce-glue.c               |  4 +-
> arch/arm/crypto/ghash-ce-glue.c               | 11 +---
> arch/arm64/crypto/aes-ce-ccm-glue.c           |  8 +--
> arch/arm64/crypto/aes-ce-glue.c               |  8 +--
> arch/arm64/crypto/aes-glue.c                  | 31 ++----------
> arch/arm64/crypto/ghash-ce-glue.c             |  8 +--
> arch/mips/crypto/crc32-mips.c                 |  4 +-
> arch/powerpc/crypto/aes-spe-glue.c            | 18 ++-----
> arch/powerpc/crypto/crc32c-vpmsum_glue.c      |  4 +-
> arch/s390/crypto/aes_s390.c                   | 27 ++--------
> arch/s390/crypto/crc32-vx.c                   |  8 +--
> arch/s390/crypto/ghash_s390.c                 |  4 +-
> arch/s390/crypto/paes_s390.c                  | 25 +++-------
> arch/sparc/crypto/aes_glue.c                  |  2 -
> arch/sparc/crypto/camellia_glue.c             |  5 +-
> arch/sparc/crypto/crc32c_glue.c               |  4 +-
> arch/x86/crypto/aegis128-aesni-glue.c         |  4 +-
> arch/x86/crypto/aesni-intel_glue.c            | 10 ++--
> arch/x86/crypto/blake2s-glue.c                |  4 +-
> arch/x86/crypto/camellia_aesni_avx2_glue.c    |  3 +-
> arch/x86/crypto/camellia_aesni_avx_glue.c     |  9 ++--
> arch/x86/crypto/camellia_glue.c               |  9 ++--
> arch/x86/crypto/cast6_avx_glue.c              |  6 +--
> arch/x86/crypto/crc32-pclmul_glue.c           |  4 +-
> arch/x86/crypto/crc32c-intel_glue.c           |  4 +-
> arch/x86/crypto/ghash-clmulni-intel_glue.c    | 11 +---
> arch/x86/crypto/twofish_avx_glue.c            |  6 +--
> arch/x86/include/asm/crypto/camellia.h        |  2 +-
> crypto/adiantum.c                             |  8 ---
> crypto/aegis128-core.c                        |  4 +-
> crypto/aes_generic.c                          | 18 +++----
> crypto/anubis.c                               |  2 -
> crypto/authenc.c                              | 12 +----
> crypto/authencesn.c                           | 12 +----
> crypto/blake2b_generic.c                      |  4 +-
> crypto/blake2s_generic.c                      |  4 +-
> crypto/camellia_generic.c                     |  5 +-
> crypto/cast6_generic.c                        | 10 ++--
> crypto/ccm.c                                  | 20 ++------
> crypto/chacha20poly1305.c                     |  7 +--
> crypto/cipher.c                               |  5 +-
> crypto/crc32_generic.c                        |  4 +-
> crypto/crc32c_generic.c                       |  4 +-
> crypto/cryptd.c                               | 13 +----
> crypto/ctr.c                                  |  7 +--
> crypto/cts.c                                  |  6 +--
> crypto/des_generic.c                          | 10 +---
> crypto/essiv.c                                | 26 ++--------
> crypto/gcm.c                                  | 19 +------
> crypto/ghash-generic.c                        |  4 +-
> crypto/lrw.c                                  |  2 -
> crypto/michael_mic.c                          |  4 +-
> crypto/simd.c                                 | 12 +----
> crypto/skcipher.c                             | 10 +---
> crypto/sm4_generic.c                          | 16 ++----
> crypto/twofish_common.c                       |  8 +--
> crypto/vmac.c                                 |  4 +-
> crypto/xts.c                                  |  8 +--
> crypto/xxhash_generic.c                       |  4 +-
> .../allwinner/sun4i-ss/sun4i-ss-cipher.c      |  1 -
> .../allwinner/sun8i-ce/sun8i-ce-cipher.c      |  1 -
> .../allwinner/sun8i-ss/sun8i-ss-cipher.c      |  2 -
> drivers/crypto/amcc/crypto4xx_alg.c           | 31 ++----------
> drivers/crypto/amlogic/amlogic-gxl-cipher.c   |  1 -
> drivers/crypto/atmel-aes.c                    | 14 ++----
> drivers/crypto/atmel-authenc.h                |  3 +-
> drivers/crypto/atmel-sha.c                    | 18 ++-----
> drivers/crypto/axis/artpec6_crypto.c          | 10 +---
> drivers/crypto/bcm/cipher.c                   | 17 +------
> drivers/crypto/caam/caamalg.c                 | 33 +++---------
> drivers/crypto/caam/caamalg_qi.c              | 44 ++++------------
> drivers/crypto/caam/caamalg_qi2.c             | 47 ++++-------------
> drivers/crypto/caam/caamhash.c                |  9 +---
> drivers/crypto/cavium/cpt/cptvf_algs.c        |  2 -
> drivers/crypto/cavium/nitrox/nitrox_aead.c    |  4 +-
> .../crypto/cavium/nitrox/nitrox_skcipher.c    | 12 ++---
> drivers/crypto/ccp/ccp-crypto-aes-cmac.c      |  1 -
> drivers/crypto/ccp/ccp-crypto-aes-galois.c    |  1 -
> drivers/crypto/ccp/ccp-crypto-aes.c           |  1 -
> drivers/crypto/ccp/ccp-crypto-sha.c           |  4 +-
> drivers/crypto/ccree/cc_aead.c                | 21 +++-----
> drivers/crypto/ccree/cc_cipher.c              |  4 --
> drivers/crypto/ccree/cc_hash.c                |  6 ---
> drivers/crypto/chelsio/chcr_algo.c            | 50 ++-----------------
> drivers/crypto/geode-aes.c                    | 24 ++-------
> .../crypto/inside-secure/safexcel_cipher.c    | 43 ++++------------
> drivers/crypto/inside-secure/safexcel_hash.c  | 22 ++------
> drivers/crypto/ixp4xx_crypto.c                | 31 ++----------
> drivers/crypto/marvell/cipher.c               |  4 +-
> drivers/crypto/mediatek/mtk-aes.c             |  4 --
> drivers/crypto/mxs-dcp.c                      | 12 +----
> drivers/crypto/n2_core.c                      |  1 -
> drivers/crypto/padlock-aes.c                  |  9 +---
> drivers/crypto/picoxcell_crypto.c             | 15 +-----
> drivers/crypto/qat/qat_common/qat_algs.c      |  6 +--
> drivers/crypto/qce/sha.c                      |  2 -
> .../crypto/rockchip/rk3288_crypto_skcipher.c  |  4 +-
> drivers/crypto/sahara.c                       |  9 +---
> drivers/crypto/stm32/stm32-crc32.c            |  4 +-
> drivers/crypto/talitos.c                      | 15 ++----
> drivers/crypto/ux500/cryp/cryp_core.c         |  2 -
> drivers/crypto/virtio/virtio_crypto_algs.c    |  8 +--
> include/crypto/cast6.h                        |  3 +-
> include/crypto/internal/des.h                 | 23 ++-------
> include/crypto/twofish.h                      |  2 +-
> include/crypto/xts.h                          | 19 ++-----
> include/linux/crypto.h                        |  7 ---
> 108 files changed, 218 insertions(+), 917 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
