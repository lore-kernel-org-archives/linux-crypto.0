Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF9BC77B73
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Apr 2023 21:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjDSV4c (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Apr 2023 17:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDSV4b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2023 17:56:31 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8797340FE
        for <linux-crypto@vger.kernel.org>; Wed, 19 Apr 2023 14:56:30 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-51efefe7814so253541a12.3
        for <linux-crypto@vger.kernel.org>; Wed, 19 Apr 2023 14:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681941390; x=1684533390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OLFmQtDzjn4fYBCM5a8di1qRrzs1inEcdVm3lZ+12QM=;
        b=Q0LakSBjf0+GBzOMLbAb3DpXco7mN4HHs+Qs/Nvg+jLZjcJ1Ie+a7eCijmH4a8EEbS
         33LOFnttp72BosihncMJLawycgMQDlKvNydTZiCFj83K0yz6dglI2Uk8Soum3R0B6cDL
         7kT2rgDuuy2BSkC721XmaGpdyGoniKYYFQdeipvyAeUW+DwbeNi0QdvuxXFIXA6hz82o
         Mt7lompywH7ief7lBe9GAKR27XOorkb+5Hy+igyRHThnYXros/YOxszVOWr9mPsuL9+d
         F2Hbq9EBe7DKdB01RQkTOyfNw68JW+Iaoe0HAhw9Mon/+ggI56OS0ryOXqmr4x8rNAHr
         QsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681941390; x=1684533390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OLFmQtDzjn4fYBCM5a8di1qRrzs1inEcdVm3lZ+12QM=;
        b=jWp7ra0laP8jORGYQIKpEIXRSAPubmQzvWeCfA/exZRese2RCPNwOrpNn4o/ObO3Xv
         5MO6OXvP7Iy/csqyGawA5Z6sdd2uRF46wqXCiRzQyoVhYlnFW43lqkw4Js5OVyqqC7iT
         pSOvP5hfTuZDivko7X7iX3AOfETdFAL1n/BIkjDYmjvl5OSSAUvIQshdEwe2RL9Dt9/1
         B+A0wzLIHb5XqNMRxxlKNEvkxU5dmQoeI6GcjIGc2xVqmVTljiRUbY2o5ei6vb1N3Rha
         C7gih9t32he/bX+0u6YdhqWh/2nqu89n8x0betc2iHQc8bnc/whWMaYWpttImeU6zHQJ
         BmUA==
X-Gm-Message-State: AAQBX9dCCrw0wA+4U/f2gYcJL5aYMdxzeOx+CaOsjLDyK2J0Vr+8CPry
        UUZ1GlleCoRW8Q5L8x+aZ7Nsl0yYLVP/OR0dcOS42jhKfHRgFdtmwAFexA==
X-Google-Smtp-Source: AKy350ZzIjgiQTad0i+K7AT2aLRAa2MzlG+eA4IP23ChGDk1CoGmo4OGkFCXhCcBg96+koUcNJCu5vVd0OB81LDKpxI=
X-Received: by 2002:a17:90a:4142:b0:247:19c5:aa3d with SMTP id
 m2-20020a17090a414200b0024719c5aa3dmr3916943pjg.36.1681941389816; Wed, 19 Apr
 2023 14:56:29 -0700 (PDT)
MIME-Version: 1.0
References: <202304081828.zjGcFUyE-lkp@intel.com> <ZD+0DJq1NHmMSSja@gondor.apana.org.au>
 <ZD+1BQd8Phqk3lzv@gondor.apana.org.au> <ZD+1phnERT6EkIUe@gondor.apana.org.au>
In-Reply-To: <ZD+1phnERT6EkIUe@gondor.apana.org.au>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 19 Apr 2023 14:56:17 -0700
Message-ID: <CAKwvOdmxK8jKK3aW7xViDyjA=NtmcvXsv=OPNRFC0FTrnVCS4A@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/sha512-neon - Fix clang function cast warnings
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel test robot <lkp@intel.com>,
        Robert Elliott <elliott@hpe.com>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 19, 2023 at 2:35=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> Instead of casting the function which upsets clang for some reason,
> change the assembly function siganture instead.

Same comments as sha1 and sha256.  Looks like more casts to remove:

arch/arm/crypto/sha512-glue.c
34:             (sha512_block_fn *)sha512_block_data_order);
40:             (sha512_block_fn *)sha512_block_data_order);
48:             (sha512_block_fn *)sha512_block_data_order);



>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304081828.zjGcFUyE-lkp@int=
el.com/
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/arch/arm/crypto/sha512-neon-glue.c b/arch/arm/crypto/sha512-=
neon-glue.c
> index c879ad32db51..c6e58fe475ac 100644
> --- a/arch/arm/crypto/sha512-neon-glue.c
> +++ b/arch/arm/crypto/sha512-neon-glue.c
> @@ -20,8 +20,8 @@
>  MODULE_ALIAS_CRYPTO("sha384-neon");
>  MODULE_ALIAS_CRYPTO("sha512-neon");
>
> -asmlinkage void sha512_block_data_order_neon(u64 *state, u8 const *src,
> -                                            int blocks);
> +asmlinkage void sha512_block_data_order_neon(struct sha512_state *state,
> +                                            const u8 *src, int blocks);
>
>  static int sha512_neon_update(struct shash_desc *desc, const u8 *data,
>                               unsigned int len)
> @@ -33,8 +33,7 @@ static int sha512_neon_update(struct shash_desc *desc, =
const u8 *data,
>                 return sha512_arm_update(desc, data, len);
>
>         kernel_neon_begin();
> -       sha512_base_do_update(desc, data, len,
> -               (sha512_block_fn *)sha512_block_data_order_neon);
> +       sha512_base_do_update(desc, data, len, sha512_block_data_order_ne=
on);
>         kernel_neon_end();
>
>         return 0;
> @@ -49,9 +48,8 @@ static int sha512_neon_finup(struct shash_desc *desc, c=
onst u8 *data,
>         kernel_neon_begin();
>         if (len)
>                 sha512_base_do_update(desc, data, len,
> -                       (sha512_block_fn *)sha512_block_data_order_neon);
> -       sha512_base_do_finalize(desc,
> -               (sha512_block_fn *)sha512_block_data_order_neon);
> +                                     sha512_block_data_order_neon);
> +       sha512_base_do_finalize(desc, sha512_block_data_order_neon);
>         kernel_neon_end();
>
>         return sha512_base_finish(desc, out);
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>


--=20
Thanks,
~Nick Desaulniers
