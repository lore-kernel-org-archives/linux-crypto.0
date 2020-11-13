Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 727FFC388F7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 07:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5C3B2137B
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 07:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wp5uaX5o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgKMHKN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Nov 2020 02:10:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:39396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbgKMHKM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Nov 2020 02:10:12 -0500
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7AD12137B
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2020 07:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605251410;
        bh=GJJjV2cTO5mxVroQa+Swwp2erDLlLUMLmu6BLqaGvTk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Wp5uaX5oc6VjB3xmPzy86yZoYPvA4WG5Atf6tJ2+TG5/HSCsw2wVrX+5m+YjzKwlw
         T+z2KHHmb1zF1YfqGmqvS4RK1yoI7//DHLkx8fA0v5mbohAwfqLHRerO0pn9hdofoW
         ZmQc0JEJSlhhHNFZVa3hk9wu7RzHMeohX1tpNF4c=
Received: by mail-ot1-f48.google.com with SMTP id n11so8143466ota.2
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2020 23:10:09 -0800 (PST)
X-Gm-Message-State: AOAM530i7bN5mZeDTWALvjuj5ji/YBhgKnDJgtwis6t+SYMetqmw4fFj
        1t94fXPdSRer3d90r7xfrnU5MQ6KrDnLWG4qZoY=
X-Google-Smtp-Source: ABdhPJwwaSNDbR76/GjqyuYfWYOf+SQKOp6amj3lCe75jLEUltbCeRYGSMoGLo0zPmYg1BvpTtky04+IsBebhly7B0w=
X-Received: by 2002:a05:6830:214c:: with SMTP id r12mr582712otd.90.1605251408286;
 Thu, 12 Nov 2020 23:10:08 -0800 (PST)
MIME-Version: 1.0
References: <20201113052021.968901-1-ebiggers@kernel.org>
In-Reply-To: <20201113052021.968901-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 13 Nov 2020 08:09:55 +0100
X-Gmail-Original-Message-ID: <CAMj1kXECYJBPzDUGPA721Aoar4kjWUupz_RZ=Lhu_PNwnLkL_w@mail.gmail.com>
Message-ID: <CAMj1kXECYJBPzDUGPA721Aoar4kjWUupz_RZ=Lhu_PNwnLkL_w@mail.gmail.com>
Subject: Re: [PATCH] crypto: sha - split sha.h into sha1.h and sha2.h
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 13 Nov 2020 at 06:21, Eric Biggers <ebiggers@kernel.org> wrote:
>
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

Fine as is, IMHO.

Acked-by: Ard Biesheuvel <ardb@kernel.org>

>  arch/arm/crypto/sha1-ce-glue.c                |  2 +-
>  arch/arm/crypto/sha1.h                        |  2 +-
>  arch/arm/crypto/sha1_glue.c                   |  2 +-
>  arch/arm/crypto/sha1_neon_glue.c              |  2 +-
>  arch/arm/crypto/sha2-ce-glue.c                |  2 +-
>  arch/arm/crypto/sha256_glue.c                 |  2 +-
>  arch/arm/crypto/sha256_neon_glue.c            |  2 +-
>  arch/arm/crypto/sha512-glue.c                 |  2 +-
>  arch/arm/crypto/sha512-neon-glue.c            |  2 +-
>  arch/arm64/crypto/aes-glue.c                  |  2 +-
>  arch/arm64/crypto/sha1-ce-glue.c              |  2 +-
>  arch/arm64/crypto/sha2-ce-glue.c              |  2 +-
>  arch/arm64/crypto/sha256-glue.c               |  2 +-
>  arch/arm64/crypto/sha512-ce-glue.c            |  2 +-
>  arch/arm64/crypto/sha512-glue.c               |  2 +-
>  arch/mips/cavium-octeon/crypto/octeon-sha1.c  |  2 +-
>  .../mips/cavium-octeon/crypto/octeon-sha256.c |  2 +-
>  .../mips/cavium-octeon/crypto/octeon-sha512.c |  2 +-
>  arch/powerpc/crypto/sha1-spe-glue.c           |  2 +-
>  arch/powerpc/crypto/sha1.c                    |  2 +-
>  arch/powerpc/crypto/sha256-spe-glue.c         |  2 +-
>  arch/s390/crypto/sha.h                        |  3 +-
>  arch/s390/crypto/sha1_s390.c                  |  2 +-
>  arch/s390/crypto/sha256_s390.c                |  2 +-
>  arch/s390/crypto/sha3_256_s390.c              |  1 -
>  arch/s390/crypto/sha3_512_s390.c              |  1 -
>  arch/s390/crypto/sha512_s390.c                |  2 +-
>  arch/s390/purgatory/purgatory.c               |  2 +-
>  arch/sparc/crypto/sha1_glue.c                 |  2 +-
>  arch/sparc/crypto/sha256_glue.c               |  2 +-
>  arch/sparc/crypto/sha512_glue.c               |  2 +-
>  arch/x86/crypto/sha1_ssse3_glue.c             |  2 +-
>  arch/x86/crypto/sha256_ssse3_glue.c           |  2 +-
>  arch/x86/crypto/sha512_ssse3_glue.c           |  2 +-
>  arch/x86/purgatory/purgatory.c                |  2 +-
>  crypto/asymmetric_keys/asym_tpm.c             |  2 +-
>  crypto/sha1_generic.c                         |  2 +-
>  crypto/sha256_generic.c                       |  2 +-
>  crypto/sha512_generic.c                       |  2 +-
>  drivers/char/random.c                         |  2 +-
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  |  2 +-
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c |  3 +-
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  3 +-
>  .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c |  3 +-
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  |  3 +-
>  drivers/crypto/amcc/crypto4xx_alg.c           |  2 +-
>  drivers/crypto/amcc/crypto4xx_core.c          |  2 +-
>  drivers/crypto/atmel-authenc.h                |  3 +-
>  drivers/crypto/atmel-sha.c                    |  3 +-
>  drivers/crypto/axis/artpec6_crypto.c          |  3 +-
>  drivers/crypto/bcm/cipher.c                   |  3 +-
>  drivers/crypto/bcm/cipher.h                   |  3 +-
>  drivers/crypto/bcm/spu.h                      |  3 +-
>  drivers/crypto/caam/compat.h                  |  3 +-
>  drivers/crypto/cavium/nitrox/nitrox_aead.c    |  1 -
>  drivers/crypto/ccp/ccp-crypto-sha.c           |  3 +-
>  drivers/crypto/ccp/ccp-crypto.h               |  3 +-
>  drivers/crypto/ccree/cc_driver.h              |  3 +-
>  drivers/crypto/chelsio/chcr_algo.c            |  3 +-
>  drivers/crypto/hisilicon/sec2/sec_crypto.c    |  3 +-
>  drivers/crypto/img-hash.c                     |  3 +-
>  drivers/crypto/inside-secure/safexcel.h       |  3 +-
>  .../crypto/inside-secure/safexcel_cipher.c    |  3 +-
>  drivers/crypto/inside-secure/safexcel_hash.c  |  3 +-
>  drivers/crypto/ixp4xx_crypto.c                |  2 +-
>  drivers/crypto/marvell/cesa/hash.c            |  3 +-
>  .../crypto/marvell/octeontx/otx_cptvf_algs.c  |  3 +-
>  drivers/crypto/mediatek/mtk-sha.c             |  3 +-
>  drivers/crypto/mxs-dcp.c                      |  3 +-
>  drivers/crypto/n2_core.c                      |  3 +-
>  drivers/crypto/nx/nx-sha256.c                 |  2 +-
>  drivers/crypto/nx/nx-sha512.c                 |  2 +-
>  drivers/crypto/nx/nx.c                        |  2 +-
>  drivers/crypto/omap-sham.c                    |  3 +-
>  drivers/crypto/padlock-sha.c                  |  3 +-
>  drivers/crypto/picoxcell_crypto.c             |  3 +-
>  drivers/crypto/qat/qat_common/qat_algs.c      |  3 +-
>  drivers/crypto/qce/common.c                   |  3 +-
>  drivers/crypto/qce/core.c                     |  1 -
>  drivers/crypto/qce/sha.h                      |  3 +-
>  drivers/crypto/rockchip/rk3288_crypto.h       |  3 +-
>  drivers/crypto/s5p-sss.c                      |  3 +-
>  drivers/crypto/sa2ul.c                        |  3 +-
>  drivers/crypto/sa2ul.h                        |  3 +-
>  drivers/crypto/sahara.c                       |  3 +-
>  drivers/crypto/stm32/stm32-hash.c             |  3 +-
>  drivers/crypto/talitos.c                      |  3 +-
>  drivers/crypto/ux500/hash/hash_core.c         |  3 +-
>  drivers/firmware/efi/embedded-firmware.c      |  2 +-
>  .../inline_crypto/ch_ipsec/chcr_ipsec.c       |  3 +-
>  .../chelsio/inline_crypto/chtls/chtls.h       |  3 +-
>  drivers/nfc/s3fwrn5/firmware.c                |  2 +-
>  drivers/tee/tee_core.c                        |  2 +-
>  fs/crypto/fname.c                             |  2 +-
>  fs/crypto/hkdf.c                              |  2 +-
>  fs/ubifs/auth.c                               |  1 -
>  fs/verity/fsverity_private.h                  |  2 +-
>  include/crypto/hash_info.h                    |  3 +-
>  include/crypto/sha1.h                         | 46 +++++++++++++++++++
>  include/crypto/sha1_base.h                    |  2 +-
>  include/crypto/{sha.h => sha2.h}              | 41 ++---------------
>  include/crypto/sha256_base.h                  |  2 +-
>  include/crypto/sha512_base.h                  |  2 +-
>  include/linux/ccp.h                           |  3 +-
>  include/linux/filter.h                        |  2 +-
>  include/linux/purgatory.h                     |  2 +-
>  kernel/crash_core.c                           |  2 +-
>  kernel/kexec_core.c                           |  1 -
>  kernel/kexec_file.c                           |  2 +-
>  lib/crypto/sha256.c                           |  2 +-
>  lib/digsig.c                                  |  2 +-
>  lib/sha1.c                                    |  2 +-
>  net/ipv6/seg6_hmac.c                          |  1 -
>  net/mptcp/crypto.c                            |  2 +-
>  net/mptcp/options.c                           |  2 +-
>  net/mptcp/subflow.c                           |  2 +-
>  security/integrity/integrity.h                |  2 +-
>  security/keys/encrypted-keys/encrypted.c      |  2 +-
>  security/keys/trusted-keys/trusted_tpm1.c     |  2 +-
>  sound/soc/codecs/cros_ec_codec.c              |  2 +-
>  120 files changed, 205 insertions(+), 155 deletions(-)
>  create mode 100644 include/crypto/sha1.h
>  rename include/crypto/{sha.h => sha2.h} (77%)
>
> diff --git a/arch/arm/crypto/sha1-ce-glue.c b/arch/arm/crypto/sha1-ce-glue.c
> index e79b1fb4b4dca..de9100c67b377 100644
> --- a/arch/arm/crypto/sha1-ce-glue.c
> +++ b/arch/arm/crypto/sha1-ce-glue.c
> @@ -7,7 +7,7 @@
>
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/simd.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <crypto/sha1_base.h>
>  #include <linux/cpufeature.h>
>  #include <linux/crypto.h>
> diff --git a/arch/arm/crypto/sha1.h b/arch/arm/crypto/sha1.h
> index 758db3e9ff0a9..b1b7e21da2c3c 100644
> --- a/arch/arm/crypto/sha1.h
> +++ b/arch/arm/crypto/sha1.h
> @@ -3,7 +3,7 @@
>  #define ASM_ARM_CRYPTO_SHA1_H
>
>  #include <linux/crypto.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>
>  extern int sha1_update_arm(struct shash_desc *desc, const u8 *data,
>                            unsigned int len);
> diff --git a/arch/arm/crypto/sha1_glue.c b/arch/arm/crypto/sha1_glue.c
> index 4e954b3f7ecd5..6c2b849e459d4 100644
> --- a/arch/arm/crypto/sha1_glue.c
> +++ b/arch/arm/crypto/sha1_glue.c
> @@ -15,7 +15,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <crypto/sha1_base.h>
>  #include <asm/byteorder.h>
>
> diff --git a/arch/arm/crypto/sha1_neon_glue.c b/arch/arm/crypto/sha1_neon_glue.c
> index 0071e5e4411a2..cfe36ae0f3f59 100644
> --- a/arch/arm/crypto/sha1_neon_glue.c
> +++ b/arch/arm/crypto/sha1_neon_glue.c
> @@ -19,7 +19,7 @@
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <crypto/sha1_base.h>
>  #include <asm/neon.h>
>  #include <asm/simd.h>
> diff --git a/arch/arm/crypto/sha2-ce-glue.c b/arch/arm/crypto/sha2-ce-glue.c
> index 87f0b62386c6a..c62ce89dd3e0d 100644
> --- a/arch/arm/crypto/sha2-ce-glue.c
> +++ b/arch/arm/crypto/sha2-ce-glue.c
> @@ -7,7 +7,7 @@
>
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/simd.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha256_base.h>
>  #include <linux/cpufeature.h>
>  #include <linux/crypto.h>
> diff --git a/arch/arm/crypto/sha256_glue.c b/arch/arm/crypto/sha256_glue.c
> index b8a4f79020cf8..433ee4ddce6c8 100644
> --- a/arch/arm/crypto/sha256_glue.c
> +++ b/arch/arm/crypto/sha256_glue.c
> @@ -17,7 +17,7 @@
>  #include <linux/mm.h>
>  #include <linux/types.h>
>  #include <linux/string.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha256_base.h>
>  #include <asm/simd.h>
>  #include <asm/neon.h>
> diff --git a/arch/arm/crypto/sha256_neon_glue.c b/arch/arm/crypto/sha256_neon_glue.c
> index 79820b9e2541d..701706262ef34 100644
> --- a/arch/arm/crypto/sha256_neon_glue.c
> +++ b/arch/arm/crypto/sha256_neon_glue.c
> @@ -13,7 +13,7 @@
>  #include <crypto/internal/simd.h>
>  #include <linux/types.h>
>  #include <linux/string.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha256_base.h>
>  #include <asm/byteorder.h>
>  #include <asm/simd.h>
> diff --git a/arch/arm/crypto/sha512-glue.c b/arch/arm/crypto/sha512-glue.c
> index 8775aa42bbbe8..0635a65aa488b 100644
> --- a/arch/arm/crypto/sha512-glue.c
> +++ b/arch/arm/crypto/sha512-glue.c
> @@ -6,7 +6,7 @@
>   */
>
>  #include <crypto/internal/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha512_base.h>
>  #include <linux/crypto.h>
>  #include <linux/module.h>
> diff --git a/arch/arm/crypto/sha512-neon-glue.c b/arch/arm/crypto/sha512-neon-glue.c
> index 96cb944035409..c879ad32db51f 100644
> --- a/arch/arm/crypto/sha512-neon-glue.c
> +++ b/arch/arm/crypto/sha512-neon-glue.c
> @@ -7,7 +7,7 @@
>
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/simd.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha512_base.h>
>  #include <linux/crypto.h>
>  #include <linux/module.h>
> diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
> index 395bbf64b2abb..34b8a89197be3 100644
> --- a/arch/arm64/crypto/aes-glue.c
> +++ b/arch/arm64/crypto/aes-glue.c
> @@ -10,7 +10,7 @@
>  #include <asm/simd.h>
>  #include <crypto/aes.h>
>  #include <crypto/ctr.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/simd.h>
>  #include <crypto/internal/skcipher.h>
> diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
> index c63b99211db3d..c93121bcfdeba 100644
> --- a/arch/arm64/crypto/sha1-ce-glue.c
> +++ b/arch/arm64/crypto/sha1-ce-glue.c
> @@ -10,7 +10,7 @@
>  #include <asm/unaligned.h>
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/simd.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <crypto/sha1_base.h>
>  #include <linux/cpufeature.h>
>  #include <linux/crypto.h>
> diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
> index 5e956d7582a56..31ba3da5e61bd 100644
> --- a/arch/arm64/crypto/sha2-ce-glue.c
> +++ b/arch/arm64/crypto/sha2-ce-glue.c
> @@ -10,7 +10,7 @@
>  #include <asm/unaligned.h>
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/simd.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha256_base.h>
>  #include <linux/cpufeature.h>
>  #include <linux/crypto.h>
> diff --git a/arch/arm64/crypto/sha256-glue.c b/arch/arm64/crypto/sha256-glue.c
> index 77bc6e72abae9..9462f6088b3f4 100644
> --- a/arch/arm64/crypto/sha256-glue.c
> +++ b/arch/arm64/crypto/sha256-glue.c
> @@ -10,7 +10,7 @@
>  #include <asm/simd.h>
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/simd.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha256_base.h>
>  #include <linux/types.h>
>  #include <linux/string.h>
> diff --git a/arch/arm64/crypto/sha512-ce-glue.c b/arch/arm64/crypto/sha512-ce-glue.c
> index dc890a719f54c..faa83f6cf376c 100644
> --- a/arch/arm64/crypto/sha512-ce-glue.c
> +++ b/arch/arm64/crypto/sha512-ce-glue.c
> @@ -14,7 +14,7 @@
>  #include <asm/unaligned.h>
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/simd.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha512_base.h>
>  #include <linux/cpufeature.h>
>  #include <linux/crypto.h>
> diff --git a/arch/arm64/crypto/sha512-glue.c b/arch/arm64/crypto/sha512-glue.c
> index 370ccb29602fd..2acff1c7df5d7 100644
> --- a/arch/arm64/crypto/sha512-glue.c
> +++ b/arch/arm64/crypto/sha512-glue.c
> @@ -8,7 +8,7 @@
>  #include <crypto/internal/hash.h>
>  #include <linux/types.h>
>  #include <linux/string.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha512_base.h>
>  #include <asm/neon.h>
>
> diff --git a/arch/mips/cavium-octeon/crypto/octeon-sha1.c b/arch/mips/cavium-octeon/crypto/octeon-sha1.c
> index 75e79b47abfe8..30f1d75208a59 100644
> --- a/arch/mips/cavium-octeon/crypto/octeon-sha1.c
> +++ b/arch/mips/cavium-octeon/crypto/octeon-sha1.c
> @@ -14,7 +14,7 @@
>   */
>
>  #include <linux/mm.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
>  #include <linux/module.h>
> diff --git a/arch/mips/cavium-octeon/crypto/octeon-sha256.c b/arch/mips/cavium-octeon/crypto/octeon-sha256.c
> index a682ce76716ac..36cb92895d725 100644
> --- a/arch/mips/cavium-octeon/crypto/octeon-sha256.c
> +++ b/arch/mips/cavium-octeon/crypto/octeon-sha256.c
> @@ -15,7 +15,7 @@
>   */
>
>  #include <linux/mm.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
>  #include <linux/module.h>
> diff --git a/arch/mips/cavium-octeon/crypto/octeon-sha512.c b/arch/mips/cavium-octeon/crypto/octeon-sha512.c
> index 50722a0cfb531..359f039820d8d 100644
> --- a/arch/mips/cavium-octeon/crypto/octeon-sha512.c
> +++ b/arch/mips/cavium-octeon/crypto/octeon-sha512.c
> @@ -14,7 +14,7 @@
>   */
>
>  #include <linux/mm.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
>  #include <linux/module.h>
> diff --git a/arch/powerpc/crypto/sha1-spe-glue.c b/arch/powerpc/crypto/sha1-spe-glue.c
> index cb57be4ada61c..b1e577cbf00ca 100644
> --- a/arch/powerpc/crypto/sha1-spe-glue.c
> +++ b/arch/powerpc/crypto/sha1-spe-glue.c
> @@ -12,7 +12,7 @@
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <asm/byteorder.h>
>  #include <asm/switch_to.h>
>  #include <linux/hardirq.h>
> diff --git a/arch/powerpc/crypto/sha1.c b/arch/powerpc/crypto/sha1.c
> index b40dc50a6908a..7a55d790cdb1e 100644
> --- a/arch/powerpc/crypto/sha1.c
> +++ b/arch/powerpc/crypto/sha1.c
> @@ -17,7 +17,7 @@
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <asm/byteorder.h>
>
>  void powerpc_sha_transform(u32 *state, const u8 *src);
> diff --git a/arch/powerpc/crypto/sha256-spe-glue.c b/arch/powerpc/crypto/sha256-spe-glue.c
> index ceb0b6c980b3b..88530ae0791fd 100644
> --- a/arch/powerpc/crypto/sha256-spe-glue.c
> +++ b/arch/powerpc/crypto/sha256-spe-glue.c
> @@ -13,7 +13,7 @@
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <asm/byteorder.h>
>  #include <asm/switch_to.h>
>  #include <linux/hardirq.h>
> diff --git a/arch/s390/crypto/sha.h b/arch/s390/crypto/sha.h
> index ada2f98c27b73..65ea12fc87a1f 100644
> --- a/arch/s390/crypto/sha.h
> +++ b/arch/s390/crypto/sha.h
> @@ -11,7 +11,8 @@
>  #define _CRYPTO_ARCH_S390_SHA_H
>
>  #include <linux/crypto.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha3.h>
>
>  /* must be big enough for the largest SHA variant */
> diff --git a/arch/s390/crypto/sha1_s390.c b/arch/s390/crypto/sha1_s390.c
> index 698b1e6d3c14d..a3fabf310a38f 100644
> --- a/arch/s390/crypto/sha1_s390.c
> +++ b/arch/s390/crypto/sha1_s390.c
> @@ -22,7 +22,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/cpufeature.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <asm/cpacf.h>
>
>  #include "sha.h"
> diff --git a/arch/s390/crypto/sha256_s390.c b/arch/s390/crypto/sha256_s390.c
> index b52c87e449398..24983f1756769 100644
> --- a/arch/s390/crypto/sha256_s390.c
> +++ b/arch/s390/crypto/sha256_s390.c
> @@ -12,7 +12,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/cpufeature.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <asm/cpacf.h>
>
>  #include "sha.h"
> diff --git a/arch/s390/crypto/sha3_256_s390.c b/arch/s390/crypto/sha3_256_s390.c
> index 460cbbbaa44ad..30ac49b635bf2 100644
> --- a/arch/s390/crypto/sha3_256_s390.c
> +++ b/arch/s390/crypto/sha3_256_s390.c
> @@ -12,7 +12,6 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/cpufeature.h>
> -#include <crypto/sha.h>
>  #include <crypto/sha3.h>
>  #include <asm/cpacf.h>
>
> diff --git a/arch/s390/crypto/sha3_512_s390.c b/arch/s390/crypto/sha3_512_s390.c
> index 72cf460a53e53..e70d50f7620f7 100644
> --- a/arch/s390/crypto/sha3_512_s390.c
> +++ b/arch/s390/crypto/sha3_512_s390.c
> @@ -11,7 +11,6 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/cpufeature.h>
> -#include <crypto/sha.h>
>  #include <crypto/sha3.h>
>  #include <asm/cpacf.h>
>
> diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
> index ad29db085a188..29a6bd404c59b 100644
> --- a/arch/s390/crypto/sha512_s390.c
> +++ b/arch/s390/crypto/sha512_s390.c
> @@ -8,7 +8,7 @@
>   * Author(s): Jan Glauber (jang@de.ibm.com)
>   */
>  #include <crypto/internal/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <linux/errno.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> diff --git a/arch/s390/purgatory/purgatory.c b/arch/s390/purgatory/purgatory.c
> index 0a423bcf67469..030efda05dbe5 100644
> --- a/arch/s390/purgatory/purgatory.c
> +++ b/arch/s390/purgatory/purgatory.c
> @@ -9,7 +9,7 @@
>
>  #include <linux/kexec.h>
>  #include <linux/string.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <asm/purgatory.h>
>
>  int verify_sha256_digest(void)
> diff --git a/arch/sparc/crypto/sha1_glue.c b/arch/sparc/crypto/sha1_glue.c
> index dc017782be523..86a654cce5abc 100644
> --- a/arch/sparc/crypto/sha1_glue.c
> +++ b/arch/sparc/crypto/sha1_glue.c
> @@ -16,7 +16,7 @@
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>
>  #include <asm/pstate.h>
>  #include <asm/elf.h>
> diff --git a/arch/sparc/crypto/sha256_glue.c b/arch/sparc/crypto/sha256_glue.c
> index ca2547df96523..60ec524cf9ca8 100644
> --- a/arch/sparc/crypto/sha256_glue.c
> +++ b/arch/sparc/crypto/sha256_glue.c
> @@ -16,7 +16,7 @@
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>
>  #include <asm/pstate.h>
>  #include <asm/elf.h>
> diff --git a/arch/sparc/crypto/sha512_glue.c b/arch/sparc/crypto/sha512_glue.c
> index 3b2ca732ff7a5..273ce21918c17 100644
> --- a/arch/sparc/crypto/sha512_glue.c
> +++ b/arch/sparc/crypto/sha512_glue.c
> @@ -15,7 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>
>  #include <asm/pstate.h>
>  #include <asm/elf.h>
> diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
> index 18200135603fc..44340a1139e0b 100644
> --- a/arch/x86/crypto/sha1_ssse3_glue.c
> +++ b/arch/x86/crypto/sha1_ssse3_glue.c
> @@ -22,7 +22,7 @@
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <crypto/sha1_base.h>
>  #include <asm/simd.h>
>
> diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
> index dd06249229e16..3a5f6be7dbba4 100644
> --- a/arch/x86/crypto/sha256_ssse3_glue.c
> +++ b/arch/x86/crypto/sha256_ssse3_glue.c
> @@ -35,7 +35,7 @@
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha256_base.h>
>  #include <linux/string.h>
>  #include <asm/simd.h>
> diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
> index b0b05c93409e1..30e70f4fe2f7a 100644
> --- a/arch/x86/crypto/sha512_ssse3_glue.c
> +++ b/arch/x86/crypto/sha512_ssse3_glue.c
> @@ -34,7 +34,7 @@
>  #include <linux/mm.h>
>  #include <linux/string.h>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha512_base.h>
>  #include <asm/simd.h>
>
> diff --git a/arch/x86/purgatory/purgatory.c b/arch/x86/purgatory/purgatory.c
> index 7b37a412f829d..f03b64d9cb51b 100644
> --- a/arch/x86/purgatory/purgatory.c
> +++ b/arch/x86/purgatory/purgatory.c
> @@ -9,7 +9,7 @@
>   */
>
>  #include <linux/bug.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <asm/purgatory.h>
>
>  #include "../boot/string.h"
> diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
> index 378b18b9bc342..511932aa94a6f 100644
> --- a/crypto/asymmetric_keys/asym_tpm.c
> +++ b/crypto/asymmetric_keys/asym_tpm.c
> @@ -10,7 +10,7 @@
>  #include <linux/tpm_command.h>
>  #include <crypto/akcipher.h>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <asm/unaligned.h>
>  #include <keys/asymmetric-subtype.h>
>  #include <keys/trusted_tpm.h>
> diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
> index 1d43472fecbde..325b57fe28dc1 100644
> --- a/crypto/sha1_generic.c
> +++ b/crypto/sha1_generic.c
> @@ -16,7 +16,7 @@
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <crypto/sha1_base.h>
>  #include <asm/byteorder.h>
>
> diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
> index 88156e3e2a33e..3b377197236e2 100644
> --- a/crypto/sha256_generic.c
> +++ b/crypto/sha256_generic.c
> @@ -12,7 +12,7 @@
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha256_base.h>
>  #include <asm/byteorder.h>
>  #include <asm/unaligned.h>
> diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
> index e34d09dd9971e..c72d72ad828e1 100644
> --- a/crypto/sha512_generic.c
> +++ b/crypto/sha512_generic.c
> @@ -12,7 +12,7 @@
>  #include <linux/init.h>
>  #include <linux/crypto.h>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha512_base.h>
>  #include <linux/percpu.h>
>  #include <asm/byteorder.h>
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 2a41b21623ae4..5f3b8ac9d97b0 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -336,7 +336,7 @@
>  #include <linux/completion.h>
>  #include <linux/uuid.h>
>  #include <crypto/chacha.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>
>  #include <asm/processor.h>
>  #include <linux/uaccess.h>
> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
> index 163962f9e2845..5c291e4a6857b 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
> @@ -25,7 +25,7 @@
>  #include <linux/pm_runtime.h>
>  #include <crypto/md5.h>
>  #include <crypto/skcipher.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <crypto/hash.h>
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/skcipher.h>
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> index fa2f1b4fad7b4..4927a6c82d32d 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> @@ -13,7 +13,8 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/scatterlist.h>
>  #include <crypto/internal/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/md5.h>
>  #include "sun8i-ce.h"
>
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
> index 558027516aed1..cec781d5063c1 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
> @@ -16,7 +16,8 @@
>  #include <crypto/internal/hash.h>
>  #include <crypto/md5.h>
>  #include <crypto/rng.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>
>  /* CE Registers */
>  #define CE_TDQ 0x00
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
> index b6ab2054f217b..11cbcbc83a7b6 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
> @@ -13,7 +13,8 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/scatterlist.h>
>  #include <crypto/internal/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/md5.h>
>  #include "sun8i-ss.h"
>
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
> index 1a66457f4a205..28188685b9100 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
> @@ -15,7 +15,8 @@
>  #include <linux/crypto.h>
>  #include <crypto/internal/hash.h>
>  #include <crypto/md5.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>
>  #define SS_START       1
>
> diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
> index 7729a637fb02b..a3fa849b139ae 100644
> --- a/drivers/crypto/amcc/crypto4xx_alg.c
> +++ b/drivers/crypto/amcc/crypto4xx_alg.c
> @@ -20,7 +20,7 @@
>  #include <crypto/aead.h>
>  #include <crypto/aes.h>
>  #include <crypto/gcm.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <crypto/ctr.h>
>  #include <crypto/skcipher.h>
>  #include "crypto4xx_reg_def.h"
> diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
> index 981de43ea5e24..f2b42aeb478fc 100644
> --- a/drivers/crypto/amcc/crypto4xx_core.c
> +++ b/drivers/crypto/amcc/crypto4xx_core.c
> @@ -30,7 +30,7 @@
>  #include <crypto/aes.h>
>  #include <crypto/ctr.h>
>  #include <crypto/gcm.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <crypto/rng.h>
>  #include <crypto/scatterwalk.h>
>  #include <crypto/skcipher.h>
> diff --git a/drivers/crypto/atmel-authenc.h b/drivers/crypto/atmel-authenc.h
> index c6530a1c8c20a..45171e89a7d28 100644
> --- a/drivers/crypto/atmel-authenc.h
> +++ b/drivers/crypto/atmel-authenc.h
> @@ -16,7 +16,8 @@
>
>  #include <crypto/authenc.h>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include "atmel-sha-regs.h"
>
>  struct atmel_aes_dev;
> diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
> index 0eb6f54e3b662..352d80cb5ae95 100644
> --- a/drivers/crypto/atmel-sha.c
> +++ b/drivers/crypto/atmel-sha.c
> @@ -33,7 +33,8 @@
>  #include <linux/crypto.h>
>  #include <crypto/scatterwalk.h>
>  #include <crypto/algapi.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/hash.h>
>  #include <crypto/internal/hash.h>
>  #include "atmel-sha-regs.h"
> diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
> index 809c3033ca748..9ad188cffd0d7 100644
> --- a/drivers/crypto/axis/artpec6_crypto.c
> +++ b/drivers/crypto/axis/artpec6_crypto.c
> @@ -28,7 +28,8 @@
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/skcipher.h>
>  #include <crypto/scatterwalk.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/xts.h>
>
>  /* Max length of a line in all cache levels for Artpec SoCs. */
> diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
> index 50d169e61b41d..30390a7324b29 100644
> --- a/drivers/crypto/bcm/cipher.c
> +++ b/drivers/crypto/bcm/cipher.c
> @@ -26,11 +26,12 @@
>  #include <crypto/aes.h>
>  #include <crypto/internal/des.h>
>  #include <crypto/hmac.h>
> -#include <crypto/sha.h>
>  #include <crypto/md5.h>
>  #include <crypto/authenc.h>
>  #include <crypto/skcipher.h>
>  #include <crypto/hash.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha3.h>
>
>  #include "util.h"
> diff --git a/drivers/crypto/bcm/cipher.h b/drivers/crypto/bcm/cipher.h
> index 035c8389cb3dd..0ad5892b445d3 100644
> --- a/drivers/crypto/bcm/cipher.h
> +++ b/drivers/crypto/bcm/cipher.h
> @@ -16,7 +16,8 @@
>  #include <crypto/aead.h>
>  #include <crypto/arc4.h>
>  #include <crypto/gcm.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha3.h>
>
>  #include "spu.h"
> diff --git a/drivers/crypto/bcm/spu.h b/drivers/crypto/bcm/spu.h
> index dd132389bcaad..1c386a2d55068 100644
> --- a/drivers/crypto/bcm/spu.h
> +++ b/drivers/crypto/bcm/spu.h
> @@ -17,7 +17,8 @@
>
>  #include <linux/types.h>
>  #include <linux/scatterlist.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>
>  enum spu_cipher_alg {
>         CIPHER_ALG_NONE = 0x0,
> diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
> index c3c22a8de4c00..c4f79764172be 100644
> --- a/drivers/crypto/caam/compat.h
> +++ b/drivers/crypto/caam/compat.h
> @@ -34,7 +34,8 @@
>  #include <crypto/ctr.h>
>  #include <crypto/internal/des.h>
>  #include <crypto/gcm.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/md5.h>
>  #include <crypto/chacha.h>
>  #include <crypto/poly1305.h>
> diff --git a/drivers/crypto/cavium/nitrox/nitrox_aead.c b/drivers/crypto/cavium/nitrox/nitrox_aead.c
> index 1be2571363fe6..8a4967d35a0b4 100644
> --- a/drivers/crypto/cavium/nitrox/nitrox_aead.c
> +++ b/drivers/crypto/cavium/nitrox/nitrox_aead.c
> @@ -7,7 +7,6 @@
>  #include <crypto/aead.h>
>  #include <crypto/authenc.h>
>  #include <crypto/des.h>
> -#include <crypto/sha.h>
>  #include <crypto/internal/aead.h>
>  #include <crypto/scatterwalk.h>
>  #include <crypto/gcm.h>
> diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
> index 8fbfdb9e8cd3c..74fa5360e7226 100644
> --- a/drivers/crypto/ccp/ccp-crypto-sha.c
> +++ b/drivers/crypto/ccp/ccp-crypto-sha.c
> @@ -17,7 +17,8 @@
>  #include <crypto/hash.h>
>  #include <crypto/hmac.h>
>  #include <crypto/internal/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/scatterwalk.h>
>  #include <linux/string.h>
>
> diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
> index aed3d2192d013..e42450d071680 100644
> --- a/drivers/crypto/ccp/ccp-crypto.h
> +++ b/drivers/crypto/ccp/ccp-crypto.h
> @@ -19,7 +19,8 @@
>  #include <crypto/aead.h>
>  #include <crypto/ctr.h>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/akcipher.h>
>  #include <crypto/skcipher.h>
>  #include <crypto/internal/rsa.h>
> diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
> index af77b20203508..ed2b2f13a2566 100644
> --- a/drivers/crypto/ccree/cc_driver.h
> +++ b/drivers/crypto/ccree/cc_driver.h
> @@ -17,7 +17,8 @@
>  #include <crypto/algapi.h>
>  #include <crypto/internal/skcipher.h>
>  #include <crypto/aes.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/aead.h>
>  #include <crypto/authenc.h>
>  #include <crypto/hash.h>
> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
> index 13b908ea48738..f5a336634daa6 100644
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -53,7 +53,8 @@
>  #include <crypto/algapi.h>
>  #include <crypto/hash.h>
>  #include <crypto/gcm.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/authenc.h>
>  #include <crypto/ctr.h>
>  #include <crypto/gf128mul.h>
> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> index 87bc08afe567d..8f2c513dfd1f1 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> @@ -7,7 +7,8 @@
>  #include <crypto/des.h>
>  #include <crypto/hash.h>
>  #include <crypto/internal/aead.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/skcipher.h>
>  #include <crypto/xts.h>
>  #include <linux/crypto.h>
> diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
> index 91f555ccbb319..e813115d54326 100644
> --- a/drivers/crypto/img-hash.c
> +++ b/drivers/crypto/img-hash.c
> @@ -19,7 +19,8 @@
>
>  #include <crypto/internal/hash.h>
>  #include <crypto/md5.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>
>  #define CR_RESET                       0
>  #define CR_RESET_SET                   1
> diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
> index 9045f2d7f4c61..ce1e611a163e7 100644
> --- a/drivers/crypto/inside-secure/safexcel.h
> +++ b/drivers/crypto/inside-secure/safexcel.h
> @@ -11,7 +11,8 @@
>  #include <crypto/aead.h>
>  #include <crypto/algapi.h>
>  #include <crypto/internal/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha3.h>
>  #include <crypto/skcipher.h>
>  #include <linux/types.h>
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index 9bcfb79a030f1..d68ef16650d47 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -18,7 +18,8 @@
>  #include <crypto/gcm.h>
>  #include <crypto/ghash.h>
>  #include <crypto/poly1305.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sm3.h>
>  #include <crypto/sm4.h>
>  #include <crypto/xts.h>
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> index 56d5ccb5cc004..50fb6d90a2e0a 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -8,7 +8,8 @@
>  #include <crypto/aes.h>
>  #include <crypto/hmac.h>
>  #include <crypto/md5.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/sha3.h>
>  #include <crypto/skcipher.h>
>  #include <crypto/sm3.h>
> diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
> index 276012e7c482f..8b0f17fc09fb5 100644
> --- a/drivers/crypto/ixp4xx_crypto.c
> +++ b/drivers/crypto/ixp4xx_crypto.c
> @@ -20,7 +20,7 @@
>  #include <crypto/internal/des.h>
>  #include <crypto/aes.h>
>  #include <crypto/hmac.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <crypto/algapi.h>
>  #include <crypto/internal/aead.h>
>  #include <crypto/internal/skcipher.h>
> diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
> index add7ea011c987..8cf9fd518d86c 100644
> --- a/drivers/crypto/marvell/cesa/hash.c
> +++ b/drivers/crypto/marvell/cesa/hash.c
> @@ -11,7 +11,8 @@
>
>  #include <crypto/hmac.h>
>  #include <crypto/md5.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <linux/device.h>
>  #include <linux/dma-mapping.h>
>
> diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
> index 90bb31329d4ba..ccbef01888d42 100644
> --- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
> +++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
> @@ -13,7 +13,8 @@
>  #include <crypto/cryptd.h>
>  #include <crypto/des.h>
>  #include <crypto/internal/aead.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/xts.h>
>  #include <crypto/scatterwalk.h>
>  #include <linux/rtnetlink.h>
> diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
> index 3d5d7d68b03b2..f55aacdafbefd 100644
> --- a/drivers/crypto/mediatek/mtk-sha.c
> +++ b/drivers/crypto/mediatek/mtk-sha.c
> @@ -10,7 +10,8 @@
>   */
>
>  #include <crypto/hmac.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include "mtk-platform.h"
>
>  #define SHA_ALIGN_MSK          (sizeof(u32) - 1)
> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> index 909a7eb748e35..d6a7784d29888 100644
> --- a/drivers/crypto/mxs-dcp.c
> +++ b/drivers/crypto/mxs-dcp.c
> @@ -17,7 +17,8 @@
>  #include <linux/clk.h>
>
>  #include <crypto/aes.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/skcipher.h>
>  #include <crypto/scatterwalk.h>
> diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
> index 3642bf83d8094..3b0bf6fea491a 100644
> --- a/drivers/crypto/n2_core.c
> +++ b/drivers/crypto/n2_core.c
> @@ -15,7 +15,8 @@
>  #include <linux/interrupt.h>
>  #include <linux/crypto.h>
>  #include <crypto/md5.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/aes.h>
>  #include <crypto/internal/des.h>
>  #include <linux/mutex.h>
> diff --git a/drivers/crypto/nx/nx-sha256.c b/drivers/crypto/nx/nx-sha256.c
> index 02fb534531959..90d9a37a57f64 100644
> --- a/drivers/crypto/nx/nx-sha256.c
> +++ b/drivers/crypto/nx/nx-sha256.c
> @@ -8,7 +8,7 @@
>   */
>
>  #include <crypto/internal/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <linux/module.h>
>  #include <asm/vio.h>
>  #include <asm/byteorder.h>
> diff --git a/drivers/crypto/nx/nx-sha512.c b/drivers/crypto/nx/nx-sha512.c
> index 4c7a3e3eeebf3..eb8627a0f3176 100644
> --- a/drivers/crypto/nx/nx-sha512.c
> +++ b/drivers/crypto/nx/nx-sha512.c
> @@ -8,7 +8,7 @@
>   */
>
>  #include <crypto/internal/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <linux/module.h>
>  #include <asm/vio.h>
>
> diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
> index 40882d6d52c18..0d2dc5be7f192 100644
> --- a/drivers/crypto/nx/nx.c
> +++ b/drivers/crypto/nx/nx.c
> @@ -10,7 +10,7 @@
>  #include <crypto/internal/aead.h>
>  #include <crypto/internal/hash.h>
>  #include <crypto/aes.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/algapi.h>
>  #include <crypto/scatterwalk.h>
>  #include <linux/module.h>
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index a3b38d2c92e70..ae0d320d3c60d 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -35,7 +35,8 @@
>  #include <linux/crypto.h>
>  #include <crypto/scatterwalk.h>
>  #include <crypto/algapi.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/hash.h>
>  #include <crypto/hmac.h>
>  #include <crypto/internal/hash.h>
> diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
> index a697a4a3f2d0d..6865c7f1fc1a2 100644
> --- a/drivers/crypto/padlock-sha.c
> +++ b/drivers/crypto/padlock-sha.c
> @@ -9,7 +9,8 @@
>
>  #include <crypto/internal/hash.h>
>  #include <crypto/padlock.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
> index fb34bf92861d1..84f9c16d984cc 100644
> --- a/drivers/crypto/picoxcell_crypto.c
> +++ b/drivers/crypto/picoxcell_crypto.c
> @@ -8,7 +8,8 @@
>  #include <crypto/authenc.h>
>  #include <crypto/internal/des.h>
>  #include <crypto/md5.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/internal/skcipher.h>
>  #include <linux/clk.h>
>  #include <linux/crypto.h>
> diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
> index 0fab8bb8ca59b..b3a68d9864173 100644
> --- a/drivers/crypto/qat/qat_common/qat_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_algs.c
> @@ -6,7 +6,8 @@
>  #include <crypto/internal/aead.h>
>  #include <crypto/internal/skcipher.h>
>  #include <crypto/aes.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/hash.h>
>  #include <crypto/hmac.h>
>  #include <crypto/algapi.h>
> diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
> index 5006e74c40cd0..a73db2a5637f8 100644
> --- a/drivers/crypto/qce/common.c
> +++ b/drivers/crypto/qce/common.c
> @@ -7,7 +7,8 @@
>  #include <linux/interrupt.h>
>  #include <linux/types.h>
>  #include <crypto/scatterwalk.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>
>  #include "cipher.h"
>  #include "common.h"
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index ea616b7259aef..5e6717f9bbdaa 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -13,7 +13,6 @@
>  #include <linux/types.h>
>  #include <crypto/algapi.h>
>  #include <crypto/internal/hash.h>
> -#include <crypto/sha.h>
>
>  #include "core.h"
>  #include "cipher.h"
> diff --git a/drivers/crypto/qce/sha.h b/drivers/crypto/qce/sha.h
> index d63526e3804dd..a22695361f165 100644
> --- a/drivers/crypto/qce/sha.h
> +++ b/drivers/crypto/qce/sha.h
> @@ -7,7 +7,8 @@
>  #define _SHA_H_
>
>  #include <crypto/scatterwalk.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>
>  #include "common.h"
>  #include "core.h"
> diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
> index 3db595570c9c2..97278c2574ff9 100644
> --- a/drivers/crypto/rockchip/rk3288_crypto.h
> +++ b/drivers/crypto/rockchip/rk3288_crypto.h
> @@ -12,7 +12,8 @@
>  #include <crypto/internal/skcipher.h>
>
>  #include <crypto/md5.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>
>  #define _SBF(v, f)                     ((v) << (f))
>
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 88a6c853ffd73..682c8a450a57b 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -30,7 +30,8 @@
>
>  #include <crypto/hash.h>
>  #include <crypto/md5.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/internal/hash.h>
>
>  #define _SBF(s, v)                     ((v) << (s))
> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
> index c357010a159e3..f300b0a5958a5 100644
> --- a/drivers/crypto/sa2ul.c
> +++ b/drivers/crypto/sa2ul.c
> @@ -25,7 +25,8 @@
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/skcipher.h>
>  #include <crypto/scatterwalk.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>
>  #include "sa2ul.h"
>
> diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
> index bb40df3876e5d..f597ddecde34f 100644
> --- a/drivers/crypto/sa2ul.h
> +++ b/drivers/crypto/sa2ul.h
> @@ -13,7 +13,8 @@
>  #define _K3_SA2UL_
>
>  #include <crypto/aes.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>
>  #define SA_ENGINE_ENABLE_CONTROL       0x1000
>
> diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
> index d60679c798224..8b5be29cb4dcb 100644
> --- a/drivers/crypto/sahara.c
> +++ b/drivers/crypto/sahara.c
> @@ -15,7 +15,8 @@
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/skcipher.h>
>  #include <crypto/scatterwalk.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>
>  #include <linux/clk.h>
>  #include <linux/dma-mapping.h>
> diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
> index e3e25278a970c..7ac0573ef6630 100644
> --- a/drivers/crypto/stm32/stm32-hash.c
> +++ b/drivers/crypto/stm32/stm32-hash.c
> @@ -25,7 +25,8 @@
>  #include <crypto/hash.h>
>  #include <crypto/md5.h>
>  #include <crypto/scatterwalk.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/internal/hash.h>
>
>  #define HASH_CR                                0x00
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index a713a35dc5022..4fd85f31630ac 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -31,7 +31,8 @@
>  #include <crypto/algapi.h>
>  #include <crypto/aes.h>
>  #include <crypto/internal/des.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/md5.h>
>  #include <crypto/internal/aead.h>
>  #include <crypto/authenc.h>
> diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
> index 3d407eebb2bab..da284b0ea1b26 100644
> --- a/drivers/crypto/ux500/hash/hash_core.c
> +++ b/drivers/crypto/ux500/hash/hash_core.c
> @@ -31,7 +31,8 @@
>  #include <linux/bitops.h>
>
>  #include <crypto/internal/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/scatterwalk.h>
>  #include <crypto/algapi.h>
>
> diff --git a/drivers/firmware/efi/embedded-firmware.c b/drivers/firmware/efi/embedded-firmware.c
> index 21ae0c48232a1..f5be8e22305be 100644
> --- a/drivers/firmware/efi/embedded-firmware.c
> +++ b/drivers/firmware/efi/embedded-firmware.c
> @@ -12,7 +12,7 @@
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  #include <linux/vmalloc.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>
>  /* Exported for use by lib/test_firmware.c only */
>  LIST_HEAD(efi_embedded_fw_list);
> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
> index 072299b14b8d2..47d9268a7e3c9 100644
> --- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
> +++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
> @@ -51,7 +51,8 @@
>  #include <crypto/aes.h>
>  #include <crypto/algapi.h>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/authenc.h>
>  #include <crypto/internal/aead.h>
>  #include <crypto/null.h>
> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
> index 2d3dfdd2a7163..65617752c6309 100644
> --- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
> +++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
> @@ -9,7 +9,8 @@
>  #include <crypto/aes.h>
>  #include <crypto/algapi.h>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/authenc.h>
>  #include <crypto/ctr.h>
>  #include <crypto/gf128mul.h>
> diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
> index ec930ee2c847e..5d5ad83072111 100644
> --- a/drivers/nfc/s3fwrn5/firmware.c
> +++ b/drivers/nfc/s3fwrn5/firmware.c
> @@ -9,7 +9,7 @@
>  #include <linux/completion.h>
>  #include <linux/firmware.h>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>
>  #include "s3fwrn5.h"
>  #include "firmware.h"
> diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> index f53bf336c0a20..d70d4be91096b 100644
> --- a/drivers/tee/tee_core.c
> +++ b/drivers/tee/tee_core.c
> @@ -14,7 +14,7 @@
>  #include <linux/tee_drv.h>
>  #include <linux/uaccess.h>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include "tee_private.h"
>
>  #define TEE_NUM_DEVICES        32
> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
> index 1fbe6c24d7052..cf06ea3870ebc 100644
> --- a/fs/crypto/fname.c
> +++ b/fs/crypto/fname.c
> @@ -14,7 +14,7 @@
>  #include <linux/namei.h>
>  #include <linux/scatterlist.h>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/skcipher.h>
>  #include "fscrypt_private.h"
>
> diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
> index 0cba7928446d3..e0ec210555053 100644
> --- a/fs/crypto/hkdf.c
> +++ b/fs/crypto/hkdf.c
> @@ -10,7 +10,7 @@
>   */
>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>
>  #include "fscrypt_private.h"
>
> diff --git a/fs/ubifs/auth.c b/fs/ubifs/auth.c
> index b93b3cd10bfd3..0886d835f597b 100644
> --- a/fs/ubifs/auth.c
> +++ b/fs/ubifs/auth.c
> @@ -12,7 +12,6 @@
>  #include <linux/crypto.h>
>  #include <linux/verification.h>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
>  #include <crypto/algapi.h>
>  #include <keys/user-type.h>
>  #include <keys/asymmetric-type.h>
> diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
> index e96d99d5145e1..6a8f2e3cce6c4 100644
> --- a/fs/verity/fsverity_private.h
> +++ b/fs/verity/fsverity_private.h
> @@ -14,7 +14,7 @@
>
>  #define pr_fmt(fmt) "fs-verity: " fmt
>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <linux/fsverity.h>
>  #include <linux/mempool.h>
>
> diff --git a/include/crypto/hash_info.h b/include/crypto/hash_info.h
> index eb9d2e3689697..dd4f067850493 100644
> --- a/include/crypto/hash_info.h
> +++ b/include/crypto/hash_info.h
> @@ -8,7 +8,8 @@
>  #ifndef _CRYPTO_HASH_INFO_H
>  #define _CRYPTO_HASH_INFO_H
>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>  #include <crypto/md5.h>
>  #include <crypto/streebog.h>
>
> diff --git a/include/crypto/sha1.h b/include/crypto/sha1.h
> new file mode 100644
> index 0000000000000..044ecea60ac82
> --- /dev/null
> +++ b/include/crypto/sha1.h
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Common values for SHA-1 algorithms
> + */
> +
> +#ifndef _CRYPTO_SHA1_H
> +#define _CRYPTO_SHA1_H
> +
> +#include <linux/types.h>
> +
> +#define SHA1_DIGEST_SIZE        20
> +#define SHA1_BLOCK_SIZE         64
> +
> +#define SHA1_H0                0x67452301UL
> +#define SHA1_H1                0xefcdab89UL
> +#define SHA1_H2                0x98badcfeUL
> +#define SHA1_H3                0x10325476UL
> +#define SHA1_H4                0xc3d2e1f0UL
> +
> +extern const u8 sha1_zero_message_hash[SHA1_DIGEST_SIZE];
> +
> +struct sha1_state {
> +       u32 state[SHA1_DIGEST_SIZE / 4];
> +       u64 count;
> +       u8 buffer[SHA1_BLOCK_SIZE];
> +};
> +
> +struct shash_desc;
> +
> +extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
> +                             unsigned int len);
> +
> +extern int crypto_sha1_finup(struct shash_desc *desc, const u8 *data,
> +                            unsigned int len, u8 *hash);
> +
> +/*
> + * An implementation of SHA-1's compression function.  Don't use in new code!
> + * You shouldn't be using SHA-1, and even if you *have* to use SHA-1, this isn't
> + * the correct way to hash something with SHA-1 (use crypto_shash instead).
> + */
> +#define SHA1_DIGEST_WORDS      (SHA1_DIGEST_SIZE / 4)
> +#define SHA1_WORKSPACE_WORDS   16
> +void sha1_init(__u32 *buf);
> +void sha1_transform(__u32 *digest, const char *data, __u32 *W);
> +
> +#endif /* _CRYPTO_SHA1_H */
> diff --git a/include/crypto/sha1_base.h b/include/crypto/sha1_base.h
> index a5d6033efef7c..2e0e7c3827d10 100644
> --- a/include/crypto/sha1_base.h
> +++ b/include/crypto/sha1_base.h
> @@ -9,7 +9,7 @@
>  #define _CRYPTO_SHA1_BASE_H
>
>  #include <crypto/internal/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <linux/crypto.h>
>  #include <linux/module.h>
>  #include <linux/string.h>
> diff --git a/include/crypto/sha.h b/include/crypto/sha2.h
> similarity index 77%
> rename from include/crypto/sha.h
> rename to include/crypto/sha2.h
> index 4ff3da816630d..2838f529f31e2 100644
> --- a/include/crypto/sha.h
> +++ b/include/crypto/sha2.h
> @@ -1,16 +1,13 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  /*
> - * Common values for SHA algorithms
> + * Common values for SHA-2 algorithms
>   */
>
> -#ifndef _CRYPTO_SHA_H
> -#define _CRYPTO_SHA_H
> +#ifndef _CRYPTO_SHA2_H
> +#define _CRYPTO_SHA2_H
>
>  #include <linux/types.h>
>
> -#define SHA1_DIGEST_SIZE        20
> -#define SHA1_BLOCK_SIZE         64
> -
>  #define SHA224_DIGEST_SIZE     28
>  #define SHA224_BLOCK_SIZE      64
>
> @@ -23,12 +20,6 @@
>  #define SHA512_DIGEST_SIZE      64
>  #define SHA512_BLOCK_SIZE       128
>
> -#define SHA1_H0                0x67452301UL
> -#define SHA1_H1                0xefcdab89UL
> -#define SHA1_H2                0x98badcfeUL
> -#define SHA1_H3                0x10325476UL
> -#define SHA1_H4                0xc3d2e1f0UL
> -
>  #define SHA224_H0      0xc1059ed8UL
>  #define SHA224_H1      0x367cd507UL
>  #define SHA224_H2      0x3070dd17UL
> @@ -65,8 +56,6 @@
>  #define SHA512_H6      0x1f83d9abfb41bd6bULL
>  #define SHA512_H7      0x5be0cd19137e2179ULL
>
> -extern const u8 sha1_zero_message_hash[SHA1_DIGEST_SIZE];
> -
>  extern const u8 sha224_zero_message_hash[SHA224_DIGEST_SIZE];
>
>  extern const u8 sha256_zero_message_hash[SHA256_DIGEST_SIZE];
> @@ -75,12 +64,6 @@ extern const u8 sha384_zero_message_hash[SHA384_DIGEST_SIZE];
>
>  extern const u8 sha512_zero_message_hash[SHA512_DIGEST_SIZE];
>
> -struct sha1_state {
> -       u32 state[SHA1_DIGEST_SIZE / 4];
> -       u64 count;
> -       u8 buffer[SHA1_BLOCK_SIZE];
> -};
> -
>  struct sha256_state {
>         u32 state[SHA256_DIGEST_SIZE / 4];
>         u64 count;
> @@ -95,12 +78,6 @@ struct sha512_state {
>
>  struct shash_desc;
>
> -extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
> -                             unsigned int len);
> -
> -extern int crypto_sha1_finup(struct shash_desc *desc, const u8 *data,
> -                            unsigned int len, u8 *hash);
> -
>  extern int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
>                               unsigned int len);
>
> @@ -113,16 +90,6 @@ extern int crypto_sha512_update(struct shash_desc *desc, const u8 *data,
>  extern int crypto_sha512_finup(struct shash_desc *desc, const u8 *data,
>                                unsigned int len, u8 *hash);
>
> -/*
> - * An implementation of SHA-1's compression function.  Don't use in new code!
> - * You shouldn't be using SHA-1, and even if you *have* to use SHA-1, this isn't
> - * the correct way to hash something with SHA-1 (use crypto_shash instead).
> - */
> -#define SHA1_DIGEST_WORDS      (SHA1_DIGEST_SIZE / 4)
> -#define SHA1_WORKSPACE_WORDS   16
> -void sha1_init(__u32 *buf);
> -void sha1_transform(__u32 *digest, const char *data, __u32 *W);
> -
>  /*
>   * Stand-alone implementation of the SHA256 algorithm. It is designed to
>   * have as little dependencies as possible so it can be used in the
> @@ -164,4 +131,4 @@ static inline void sha224_init(struct sha256_state *sctx)
>  void sha224_update(struct sha256_state *sctx, const u8 *data, unsigned int len);
>  void sha224_final(struct sha256_state *sctx, u8 *out);
>
> -#endif
> +#endif /* _CRYPTO_SHA2_H */
> diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
> index 93f9fd21cc068..76173c6130583 100644
> --- a/include/crypto/sha256_base.h
> +++ b/include/crypto/sha256_base.h
> @@ -9,7 +9,7 @@
>  #define _CRYPTO_SHA256_BASE_H
>
>  #include <crypto/internal/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <linux/crypto.h>
>  #include <linux/module.h>
>  #include <linux/string.h>
> diff --git a/include/crypto/sha512_base.h b/include/crypto/sha512_base.h
> index 93ab73baa38e5..b370b3340b162 100644
> --- a/include/crypto/sha512_base.h
> +++ b/include/crypto/sha512_base.h
> @@ -9,7 +9,7 @@
>  #define _CRYPTO_SHA512_BASE_H
>
>  #include <crypto/internal/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <linux/crypto.h>
>  #include <linux/module.h>
>  #include <linux/string.h>
> diff --git a/include/linux/ccp.h b/include/linux/ccp.h
> index a5dfbaf2470d7..868924dec5a17 100644
> --- a/include/linux/ccp.h
> +++ b/include/linux/ccp.h
> @@ -15,7 +15,8 @@
>  #include <linux/workqueue.h>
>  #include <linux/list.h>
>  #include <crypto/aes.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
> +#include <crypto/sha2.h>
>
>  struct ccp_device;
>  struct ccp_cmd;
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 72d62cbc1578f..6c00140538b95 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -21,7 +21,7 @@
>  #include <linux/if_vlan.h>
>  #include <linux/vmalloc.h>
>  #include <linux/sockptr.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>
>  #include <net/sch_generic.h>
>
> diff --git a/include/linux/purgatory.h b/include/linux/purgatory.h
> index b950e961cfa89..d7dc1559427f0 100644
> --- a/include/linux/purgatory.h
> +++ b/include/linux/purgatory.h
> @@ -3,7 +3,7 @@
>  #define _LINUX_PURGATORY_H
>
>  #include <linux/types.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <uapi/linux/kexec.h>
>
>  struct kexec_sha_region {
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index 106e4500fd53d..4fcfe0b70c4e5 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -11,7 +11,7 @@
>  #include <asm/page.h>
>  #include <asm/sections.h>
>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>
>  /* vmcoreinfo stuff */
>  unsigned char *vmcoreinfo_data;
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index 8798a8183974e..4f8efc278aa75 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -42,7 +42,6 @@
>  #include <asm/sections.h>
>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
>  #include "kexec_internal.h"
>
>  DEFINE_MUTEX(kexec_mutex);
> diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
> index e21f6b9234f7a..b02086d704923 100644
> --- a/kernel/kexec_file.c
> +++ b/kernel/kexec_file.c
> @@ -20,7 +20,7 @@
>  #include <linux/fs.h>
>  #include <linux/ima.h>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <linux/elf.h>
>  #include <linux/elfcore.h>
>  #include <linux/kernel.h>
> diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> index cdef37c059729..72a4b0b1df28a 100644
> --- a/lib/crypto/sha256.c
> +++ b/lib/crypto/sha256.c
> @@ -15,7 +15,7 @@
>  #include <linux/export.h>
>  #include <linux/module.h>
>  #include <linux/string.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <asm/unaligned.h>
>
>  static const u32 SHA256_K[] = {
> diff --git a/lib/digsig.c b/lib/digsig.c
> index e0627c3e53b2e..04b5e55ed95f5 100644
> --- a/lib/digsig.c
> +++ b/lib/digsig.c
> @@ -20,7 +20,7 @@
>  #include <linux/key.h>
>  #include <linux/crypto.h>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <keys/user-type.h>
>  #include <linux/mpi.h>
>  #include <linux/digsig.h>
> diff --git a/lib/sha1.c b/lib/sha1.c
> index 49257a915bb60..9bd1935a14727 100644
> --- a/lib/sha1.c
> +++ b/lib/sha1.c
> @@ -9,7 +9,7 @@
>  #include <linux/kernel.h>
>  #include <linux/export.h>
>  #include <linux/bitops.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <asm/unaligned.h>
>
>  /*
> diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
> index 85dddfe3a2c6e..687d95dce0852 100644
> --- a/net/ipv6/seg6_hmac.c
> +++ b/net/ipv6/seg6_hmac.c
> @@ -35,7 +35,6 @@
>  #include <net/xfrm.h>
>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
>  #include <net/seg6.h>
>  #include <net/genetlink.h>
>  #include <net/seg6_hmac.h>
> diff --git a/net/mptcp/crypto.c b/net/mptcp/crypto.c
> index 05d398d3fde40..b472dc1498569 100644
> --- a/net/mptcp/crypto.c
> +++ b/net/mptcp/crypto.c
> @@ -21,7 +21,7 @@
>   */
>
>  #include <linux/kernel.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <asm/unaligned.h>
>
>  #include "protocol.h"
> diff --git a/net/mptcp/options.c b/net/mptcp/options.c
> index a044dd43411d9..90cd52df99a68 100644
> --- a/net/mptcp/options.c
> +++ b/net/mptcp/options.c
> @@ -7,7 +7,7 @@
>  #define pr_fmt(fmt) "MPTCP: " fmt
>
>  #include <linux/kernel.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <net/tcp.h>
>  #include <net/mptcp.h>
>  #include "protocol.h"
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index ac4a1fe3550bd..b229ae914d76d 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -10,7 +10,7 @@
>  #include <linux/module.h>
>  #include <linux/netdevice.h>
>  #include <crypto/algapi.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <net/sock.h>
>  #include <net/inet_common.h>
>  #include <net/inet_hashtables.h>
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index 413c803c52089..547425c20e117 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -14,7 +14,7 @@
>
>  #include <linux/types.h>
>  #include <linux/integrity.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <linux/key.h>
>  #include <linux/audit.h>
>
> diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
> index 192e531c146f5..87432b35d7713 100644
> --- a/security/keys/encrypted-keys/encrypted.c
> +++ b/security/keys/encrypted-keys/encrypted.c
> @@ -29,7 +29,7 @@
>  #include <crypto/aes.h>
>  #include <crypto/algapi.h>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <crypto/skcipher.h>
>
>  #include "encrypted.h"
> diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
> index b9fe02e5f84f0..74d82093cbaa9 100644
> --- a/security/keys/trusted-keys/trusted_tpm1.c
> +++ b/security/keys/trusted-keys/trusted_tpm1.c
> @@ -22,7 +22,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/crypto.h>
>  #include <crypto/hash.h>
> -#include <crypto/sha.h>
> +#include <crypto/sha1.h>
>  #include <linux/capability.h>
>  #include <linux/tpm.h>
>  #include <linux/tpm_command.h>
> diff --git a/sound/soc/codecs/cros_ec_codec.c b/sound/soc/codecs/cros_ec_codec.c
> index 28f039adfa138..58894bf475146 100644
> --- a/sound/soc/codecs/cros_ec_codec.c
> +++ b/sound/soc/codecs/cros_ec_codec.c
> @@ -8,7 +8,7 @@
>   * EC for audio function.
>   */
>
> -#include <crypto/sha.h>
> +#include <crypto/sha2.h>
>  #include <linux/acpi.h>
>  #include <linux/delay.h>
>  #include <linux/device.h>
> --
> 2.29.2
>
