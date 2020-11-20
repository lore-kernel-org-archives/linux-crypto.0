Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FC1C56201
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 06:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B4BF2223F
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 06:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgKTG5t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 01:57:49 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:34216 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbgKTG5t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 01:57:49 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kg0Mc-0007l5-DD; Fri, 20 Nov 2020 17:57:47 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2020 17:57:46 +1100
Date:   Fri, 20 Nov 2020 17:57:46 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Jason@zx2c4.com
Subject: Re: [PATCH] crypto: sha - split sha.h into sha1.h and sha2.h
Message-ID: <20201120065746.GA21665@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113052021.968901-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Currently <crypto/sha.h> contains declarations for both SHA-1 and SHA-2,
> and <crypto/sha3.h> contains declarations for SHA-3.
> 
> This organization is inconsistent, but more importantly SHA-1 is no
> longer considered to be cryptographically secure.  So to the extent
> possible, SHA-1 shouldn't be grouped together with any of the other SHA
> versions, and usage of it should be phased out.
> 
> Therefore, split <crypto/sha.h> into two headers <crypto/sha1.h> and
> <crypto/sha2.h>, and make everyone explicitly specify whether they want
> the declarations for SHA-1, SHA-2, or both.
> 
> This avoids making the SHA-1 declarations visible to files that don't
> want anything to do with SHA-1.  It also prepares for potentially moving
> sha1.h into a new insecure/ or dangerous/ directory.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> This is a follow-up from
> https://lkml.kernel.org/linux-crypto/20200503164539.GA938@sol.localdomain.
> 
> This could be split into multiple patches if sha.h were to be kept
> around temporarily.  However, the end state is the same, and the updates
> to #includes are pretty straightforward.  Let me know if multiple
> patches are preferred.
> 
> arch/arm/crypto/sha1-ce-glue.c                |  2 +-
> arch/arm/crypto/sha1.h                        |  2 +-
> arch/arm/crypto/sha1_glue.c                   |  2 +-
> arch/arm/crypto/sha1_neon_glue.c              |  2 +-
> arch/arm/crypto/sha2-ce-glue.c                |  2 +-
> arch/arm/crypto/sha256_glue.c                 |  2 +-
> arch/arm/crypto/sha256_neon_glue.c            |  2 +-
> arch/arm/crypto/sha512-glue.c                 |  2 +-
> arch/arm/crypto/sha512-neon-glue.c            |  2 +-
> arch/arm64/crypto/aes-glue.c                  |  2 +-
> arch/arm64/crypto/sha1-ce-glue.c              |  2 +-
> arch/arm64/crypto/sha2-ce-glue.c              |  2 +-
> arch/arm64/crypto/sha256-glue.c               |  2 +-
> arch/arm64/crypto/sha512-ce-glue.c            |  2 +-
> arch/arm64/crypto/sha512-glue.c               |  2 +-
> arch/mips/cavium-octeon/crypto/octeon-sha1.c  |  2 +-
> .../mips/cavium-octeon/crypto/octeon-sha256.c |  2 +-
> .../mips/cavium-octeon/crypto/octeon-sha512.c |  2 +-
> arch/powerpc/crypto/sha1-spe-glue.c           |  2 +-
> arch/powerpc/crypto/sha1.c                    |  2 +-
> arch/powerpc/crypto/sha256-spe-glue.c         |  2 +-
> arch/s390/crypto/sha.h                        |  3 +-
> arch/s390/crypto/sha1_s390.c                  |  2 +-
> arch/s390/crypto/sha256_s390.c                |  2 +-
> arch/s390/crypto/sha3_256_s390.c              |  1 -
> arch/s390/crypto/sha3_512_s390.c              |  1 -
> arch/s390/crypto/sha512_s390.c                |  2 +-
> arch/s390/purgatory/purgatory.c               |  2 +-
> arch/sparc/crypto/sha1_glue.c                 |  2 +-
> arch/sparc/crypto/sha256_glue.c               |  2 +-
> arch/sparc/crypto/sha512_glue.c               |  2 +-
> arch/x86/crypto/sha1_ssse3_glue.c             |  2 +-
> arch/x86/crypto/sha256_ssse3_glue.c           |  2 +-
> arch/x86/crypto/sha512_ssse3_glue.c           |  2 +-
> arch/x86/purgatory/purgatory.c                |  2 +-
> crypto/asymmetric_keys/asym_tpm.c             |  2 +-
> crypto/sha1_generic.c                         |  2 +-
> crypto/sha256_generic.c                       |  2 +-
> crypto/sha512_generic.c                       |  2 +-
> drivers/char/random.c                         |  2 +-
> drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  |  2 +-
> .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c |  3 +-
> drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  3 +-
> .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c |  3 +-
> drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  |  3 +-
> drivers/crypto/amcc/crypto4xx_alg.c           |  2 +-
> drivers/crypto/amcc/crypto4xx_core.c          |  2 +-
> drivers/crypto/atmel-authenc.h                |  3 +-
> drivers/crypto/atmel-sha.c                    |  3 +-
> drivers/crypto/axis/artpec6_crypto.c          |  3 +-
> drivers/crypto/bcm/cipher.c                   |  3 +-
> drivers/crypto/bcm/cipher.h                   |  3 +-
> drivers/crypto/bcm/spu.h                      |  3 +-
> drivers/crypto/caam/compat.h                  |  3 +-
> drivers/crypto/cavium/nitrox/nitrox_aead.c    |  1 -
> drivers/crypto/ccp/ccp-crypto-sha.c           |  3 +-
> drivers/crypto/ccp/ccp-crypto.h               |  3 +-
> drivers/crypto/ccree/cc_driver.h              |  3 +-
> drivers/crypto/chelsio/chcr_algo.c            |  3 +-
> drivers/crypto/hisilicon/sec2/sec_crypto.c    |  3 +-
> drivers/crypto/img-hash.c                     |  3 +-
> drivers/crypto/inside-secure/safexcel.h       |  3 +-
> .../crypto/inside-secure/safexcel_cipher.c    |  3 +-
> drivers/crypto/inside-secure/safexcel_hash.c  |  3 +-
> drivers/crypto/ixp4xx_crypto.c                |  2 +-
> drivers/crypto/marvell/cesa/hash.c            |  3 +-
> .../crypto/marvell/octeontx/otx_cptvf_algs.c  |  3 +-
> drivers/crypto/mediatek/mtk-sha.c             |  3 +-
> drivers/crypto/mxs-dcp.c                      |  3 +-
> drivers/crypto/n2_core.c                      |  3 +-
> drivers/crypto/nx/nx-sha256.c                 |  2 +-
> drivers/crypto/nx/nx-sha512.c                 |  2 +-
> drivers/crypto/nx/nx.c                        |  2 +-
> drivers/crypto/omap-sham.c                    |  3 +-
> drivers/crypto/padlock-sha.c                  |  3 +-
> drivers/crypto/picoxcell_crypto.c             |  3 +-
> drivers/crypto/qat/qat_common/qat_algs.c      |  3 +-
> drivers/crypto/qce/common.c                   |  3 +-
> drivers/crypto/qce/core.c                     |  1 -
> drivers/crypto/qce/sha.h                      |  3 +-
> drivers/crypto/rockchip/rk3288_crypto.h       |  3 +-
> drivers/crypto/s5p-sss.c                      |  3 +-
> drivers/crypto/sa2ul.c                        |  3 +-
> drivers/crypto/sa2ul.h                        |  3 +-
> drivers/crypto/sahara.c                       |  3 +-
> drivers/crypto/stm32/stm32-hash.c             |  3 +-
> drivers/crypto/talitos.c                      |  3 +-
> drivers/crypto/ux500/hash/hash_core.c         |  3 +-
> drivers/firmware/efi/embedded-firmware.c      |  2 +-
> .../inline_crypto/ch_ipsec/chcr_ipsec.c       |  3 +-
> .../chelsio/inline_crypto/chtls/chtls.h       |  3 +-
> drivers/nfc/s3fwrn5/firmware.c                |  2 +-
> drivers/tee/tee_core.c                        |  2 +-
> fs/crypto/fname.c                             |  2 +-
> fs/crypto/hkdf.c                              |  2 +-
> fs/ubifs/auth.c                               |  1 -
> fs/verity/fsverity_private.h                  |  2 +-
> include/crypto/hash_info.h                    |  3 +-
> include/crypto/sha1.h                         | 46 +++++++++++++++++++
> include/crypto/sha1_base.h                    |  2 +-
> include/crypto/{sha.h => sha2.h}              | 41 ++---------------
> include/crypto/sha256_base.h                  |  2 +-
> include/crypto/sha512_base.h                  |  2 +-
> include/linux/ccp.h                           |  3 +-
> include/linux/filter.h                        |  2 +-
> include/linux/purgatory.h                     |  2 +-
> kernel/crash_core.c                           |  2 +-
> kernel/kexec_core.c                           |  1 -
> kernel/kexec_file.c                           |  2 +-
> lib/crypto/sha256.c                           |  2 +-
> lib/digsig.c                                  |  2 +-
> lib/sha1.c                                    |  2 +-
> net/ipv6/seg6_hmac.c                          |  1 -
> net/mptcp/crypto.c                            |  2 +-
> net/mptcp/options.c                           |  2 +-
> net/mptcp/subflow.c                           |  2 +-
> security/integrity/integrity.h                |  2 +-
> security/keys/encrypted-keys/encrypted.c      |  2 +-
> security/keys/trusted-keys/trusted_tpm1.c     |  2 +-
> sound/soc/codecs/cros_ec_codec.c              |  2 +-
> 120 files changed, 205 insertions(+), 155 deletions(-)
> create mode 100644 include/crypto/sha1.h
> rename include/crypto/{sha.h => sha2.h} (77%)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
