Return-Path: <SRS0=SeGX=IG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18759C433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 09:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5736651F1
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 09:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhCHJh5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Mar 2021 04:37:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229671AbhCHJhr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Mar 2021 04:37:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54756651DE;
        Mon,  8 Mar 2021 09:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615196267;
        bh=1wHBwyIuDfL2yqNrbWMWe8Hk65x6usXJSpXQMxbCLu8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b3UlCqrh62gp8/Ed3LvGNMofdzpnUw9Uv6N33lgz/UjWuUgB+HA33awBEIUo4/OHj
         v97s6SPeP13wIwh3MJHRs6Aav+zN6YffM8/gTrfgjk7ogzXOv+yhhoIEBMCKRYKbG/
         Np2qXNRRWe0XZ/TwIYh6LNZDC25pK+U4g6BGSfcqxYcrlFP+LdMxF904PLUO8qW1cz
         x34sh74MqnIH7f4eEKxIJBLgQreQAkrISnz9IORhCcVPmaF36N1om6H+TloOrxvF1t
         EE1RHJfeY1CkG7ZtLt63H2N7TO8sH9mBB29C/46cXGz1eUTJvMqsuOsfOkcP0ZbJyf
         fS586nkIqTdGw==
Received: by mail-oi1-f173.google.com with SMTP id v192so2752105oia.5;
        Mon, 08 Mar 2021 01:37:47 -0800 (PST)
X-Gm-Message-State: AOAM531l4R+S4lzMi9CJvc10BAJUTUziQmBzHEZjcVuBQ9bbkWNTRtCR
        8OhQDJT6AaRw302CaY3Mwpz2t/Sygse7pwiBKjg=
X-Google-Smtp-Source: ABdhPJzyEI02NLl9npoUaZhoVMPLCRyBpDqs6EFppsnk4m18f+wYCTuoOUf6+gVkrLFpQLdka9VZ9YeLmGTeieuiUDA=
X-Received: by 2002:aca:538c:: with SMTP id h134mr16365025oib.174.1615196266632;
 Mon, 08 Mar 2021 01:37:46 -0800 (PST)
MIME-Version: 1.0
References: <202102280353.5krQC7aq-lkp@intel.com> <20210308054132.GA14854@gondor.apana.org.au>
In-Reply-To: <20210308054132.GA14854@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 8 Mar 2021 10:37:35 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHhCnxzkUYvF51cbaYJZz+6vAH5WVBqr__Oa_85bUFrNg@mail.gmail.com>
Message-ID: <CAMj1kXHhCnxzkUYvF51cbaYJZz+6vAH5WVBqr__Oa_85bUFrNg@mail.gmail.com>
Subject: Re: [PATCH] crypto: aegis128 - Move simd prototypes into aegis.h
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel test robot <lkp@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        kbuild-all@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 8 Mar 2021 at 06:42, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sun, Feb 28, 2021 at 03:14:55AM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   5695e51619745d4fe3ec2506a2f0cd982c5e27a4
> > commit: a4397635afea5d127548d64e0055ed471ef2d5be crypto: aegis128 - provide a SIMD implementation based on NEON intrinsics
> > date:   1 year, 6 months ago
> > config: arm64-randconfig-r035-20210226 (attached as .config)
> > compiler: aarch64-linux-gcc (GCC) 9.3.0
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a4397635afea5d127548d64e0055ed471ef2d5be
> >         git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> >         git fetch --no-tags linus master
> >         git checkout a4397635afea5d127548d64e0055ed471ef2d5be
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=arm64
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> crypto/aegis128-neon.c:17:6: warning: no previous prototype for 'crypto_aegis128_have_simd' [-Wmissing-prototypes]
> >       17 | bool crypto_aegis128_have_simd(void)
> >          |      ^~~~~~~~~~~~~~~~~~~~~~~~~
>
> ---8<---
> This patch fixes missing prototype warnings in crypto/aegis128-neon.c.
>
> Fixes: a4397635afea ("crypto: aegis128 - provide a SIMD...")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

>
> diff --git a/crypto/aegis.h b/crypto/aegis.h
> index 6920ebe77679..6ef9c174c973 100644
> --- a/crypto/aegis.h
> +++ b/crypto/aegis.h
> @@ -21,9 +21,28 @@ union aegis_block {
>         u8 bytes[AEGIS_BLOCK_SIZE];
>  };
>
> +struct aegis_state;
> +
> +extern int aegis128_have_aes_insn;
> +
>  #define AEGIS_BLOCK_ALIGN (__alignof__(union aegis_block))
>  #define AEGIS_ALIGNED(p) IS_ALIGNED((uintptr_t)p, AEGIS_BLOCK_ALIGN)
>
> +bool crypto_aegis128_have_simd(void);
> +void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg);
> +void crypto_aegis128_init_simd(struct aegis_state *state,
> +                              const union aegis_block *key,
> +                              const u8 *iv);
> +void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
> +                                       const u8 *src, unsigned int size);
> +void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
> +                                       const u8 *src, unsigned int size);
> +int crypto_aegis128_final_simd(struct aegis_state *state,
> +                              union aegis_block *tag_xor,
> +                              unsigned int assoclen,
> +                              unsigned int cryptlen,
> +                              unsigned int authsize);
> +
>  static __always_inline void crypto_aegis_block_xor(union aegis_block *dst,
>                                                    const union aegis_block *src)
>  {
> diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
> index 89dc1c559689..c4f1bfa1d04f 100644
> --- a/crypto/aegis128-core.c
> +++ b/crypto/aegis128-core.c
> @@ -58,21 +58,6 @@ static bool aegis128_do_simd(void)
>         return false;
>  }
>
> -bool crypto_aegis128_have_simd(void);
> -void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg);
> -void crypto_aegis128_init_simd(struct aegis_state *state,
> -                              const union aegis_block *key,
> -                              const u8 *iv);
> -void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
> -                                       const u8 *src, unsigned int size);
> -void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
> -                                       const u8 *src, unsigned int size);
> -int crypto_aegis128_final_simd(struct aegis_state *state,
> -                              union aegis_block *tag_xor,
> -                              unsigned int assoclen,
> -                              unsigned int cryptlen,
> -                              unsigned int authsize);
> -
>  static void crypto_aegis128_update(struct aegis_state *state)
>  {
>         union aegis_block tmp;
> diff --git a/crypto/aegis128-neon.c b/crypto/aegis128-neon.c
> index 94d591a002a4..a7856915ec85 100644
> --- a/crypto/aegis128-neon.c
> +++ b/crypto/aegis128-neon.c
> @@ -30,7 +30,7 @@ bool crypto_aegis128_have_simd(void)
>         return IS_ENABLED(CONFIG_ARM64);
>  }
>
> -void crypto_aegis128_init_simd(union aegis_block *state,
> +void crypto_aegis128_init_simd(struct aegis_state *state,
>                                const union aegis_block *key,
>                                const u8 *iv)
>  {
> @@ -39,14 +39,14 @@ void crypto_aegis128_init_simd(union aegis_block *state,
>         kernel_neon_end();
>  }
>
> -void crypto_aegis128_update_simd(union aegis_block *state, const void *msg)
> +void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg)
>  {
>         kernel_neon_begin();
>         crypto_aegis128_update_neon(state, msg);
>         kernel_neon_end();
>  }
>
> -void crypto_aegis128_encrypt_chunk_simd(union aegis_block *state, u8 *dst,
> +void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
>                                         const u8 *src, unsigned int size)
>  {
>         kernel_neon_begin();
> @@ -54,7 +54,7 @@ void crypto_aegis128_encrypt_chunk_simd(union aegis_block *state, u8 *dst,
>         kernel_neon_end();
>  }
>
> -void crypto_aegis128_decrypt_chunk_simd(union aegis_block *state, u8 *dst,
> +void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
>                                         const u8 *src, unsigned int size)
>  {
>         kernel_neon_begin();
> @@ -62,7 +62,7 @@ void crypto_aegis128_decrypt_chunk_simd(union aegis_block *state, u8 *dst,
>         kernel_neon_end();
>  }
>
> -int crypto_aegis128_final_simd(union aegis_block *state,
> +int crypto_aegis128_final_simd(struct aegis_state *state,
>                                union aegis_block *tag_xor,
>                                unsigned int assoclen,
>                                unsigned int cryptlen,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
