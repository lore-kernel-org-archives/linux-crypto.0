Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C2FC77B73
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Apr 2023 21:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjDSVyB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Apr 2023 17:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjDSVyA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2023 17:54:00 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AC95593
        for <linux-crypto@vger.kernel.org>; Wed, 19 Apr 2023 14:53:58 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so240992a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 19 Apr 2023 14:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681941238; x=1684533238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j8iHanY7fwyxMAC+40k2hC5PB13EWng94w0vOBJ90SQ=;
        b=qHXH/QEPdhfNUubovbW2N/tO1b/Cf9V9pOr4tjVtzyoUiD2aJpz58/QOC6orq7L4RS
         KwtQmYBSyAEUEYT/K+noG9KXEodKAYZColxmjFNmASfWWPvr0wwQypJzfTPHlavOuXrR
         e7W20zZl7AZSzBcHLMhaHJcpeEXBVJy/1G4aUlcRkCp9Am0NWRWTpritQjIQeYbsFIdo
         /Y4XLIOIjK0OvPn152AwXWNd7b8doRZWKLgNIcp8ysckM6ry6QdkklWHv7w17qtVwFcG
         GHzJPYuxFai5e6xvaVXT5fO1SMlFJL+a0hQbT64r8ei3PKsZqWpSX3qKaGaZOrmEXMJ2
         gcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681941238; x=1684533238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j8iHanY7fwyxMAC+40k2hC5PB13EWng94w0vOBJ90SQ=;
        b=SqI7849Q+L0oMUshbMRPG4Gf2Ocef+rnppuVz3jYUkPDJ1Zscwnq5wKryqAOI49pyB
         zdFKyQNn7Ie+9hWV/6EkiaL/lIhrbdCyrdGBoZRKQgWatEGlUNVBNShxb8iEvYCiBONR
         DIGyUZkKNEIOI4YKR0Lm5iXJpl59W2tpH2ko1WUYrNy5VYfqix+ZREHkTha4ga3vtqbd
         M2JJBBcQfAmn3IAfQ619sT4yvLJHifSYpEuvkW5fKAnWyjtI3tB/LXfQLzc7XzHHG6js
         9FsE/JjLfboBngJKwNfbkyZfdCUXKwP13VV1l88LS+8nHsC77v36YLxAtAHnVU0pxlVD
         LYHg==
X-Gm-Message-State: AAQBX9dALNx20gdoWHQU7/QoE7JOC131Lt1AXIfH1Ubon+UMO1jUzo5X
        f7PMCg7AbkXByv92ED4O+twjpJPos692Qz0AcZoeHw==
X-Google-Smtp-Source: AKy350au7CHiEJh3jH0BOBk7n3u4G+wlWReJVqLi7dJNUMc2sVuxMTkPvY3TekaRVMIqFKa4nmdijy5uBsrs/pUwlaw=
X-Received: by 2002:a17:90a:4307:b0:247:96e0:2ebf with SMTP id
 q7-20020a17090a430700b0024796e02ebfmr4202460pjg.1.1681941237996; Wed, 19 Apr
 2023 14:53:57 -0700 (PDT)
MIME-Version: 1.0
References: <202304081828.zjGcFUyE-lkp@intel.com> <ZD+0DJq1NHmMSSja@gondor.apana.org.au>
 <ZD+1BQd8Phqk3lzv@gondor.apana.org.au>
In-Reply-To: <ZD+1BQd8Phqk3lzv@gondor.apana.org.au>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 19 Apr 2023 14:53:45 -0700
Message-ID: <CAKwvOdmi26QmGKsoZGauj+qBBaqvH7v6ryohQDmwLA_Mht5doA@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/sha256-neon - Fix clang function cast warnings
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

On Wed, Apr 19, 2023 at 2:32=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> Instead of casting the function which upsets clang for some reason,
> change the assembly function siganture instead.

Thanks for the patch, same comments as the sha1 patch:
https://lore.kernel.org/oe-kbuild-all/CAKwvOdm2VyCzfmG6707osmtyniV-oL-ism08=
kER49D7p_7x+Rg@mail.gmail.com/
though sha256_block_data_order_neon is defined in
arch/arm/crypto/sha256-armv4.pl and does not have any comments about
the function signature.
Also, I see a few more casts to sha256_block_fn:

arch/arm/crypto/sha256_glue.c
37:                             (sha256_block_fn *)sha256_block_data_order)=
;
44:                             (sha256_block_fn *)sha256_block_data_order)=
;
52:                           (sha256_block_fn *)sha256_block_data_order);

arch/arm/crypto/sha2-ce-glue.c
41:                           (sha256_block_fn *)sha2_ce_transform);
56:                                   (sha256_block_fn *)sha2_ce_transform)=
;
57:     sha256_base_do_finalize(desc, (sha256_block_fn *)sha2_ce_transform)=
;

Can those be cleaned up, too? (Either in this patch or a follow up?)

>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304081828.zjGcFUyE-lkp@int=
el.com/
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/arch/arm/crypto/sha256_neon_glue.c b/arch/arm/crypto/sha256_=
neon_glue.c
> index 701706262ef3..ccdcfff71910 100644
> --- a/arch/arm/crypto/sha256_neon_glue.c
> +++ b/arch/arm/crypto/sha256_neon_glue.c
> @@ -21,8 +21,8 @@
>
>  #include "sha256_glue.h"
>
> -asmlinkage void sha256_block_data_order_neon(u32 *digest, const void *da=
ta,
> -                                            unsigned int num_blks);
> +asmlinkage void sha256_block_data_order_neon(struct sha256_state *digest=
,
> +                                            const u8 *data, int num_blks=
);
>
>  static int crypto_sha256_neon_update(struct shash_desc *desc, const u8 *=
data,
>                                      unsigned int len)
> @@ -34,8 +34,7 @@ static int crypto_sha256_neon_update(struct shash_desc =
*desc, const u8 *data,
>                 return crypto_sha256_arm_update(desc, data, len);
>
>         kernel_neon_begin();
> -       sha256_base_do_update(desc, data, len,
> -                       (sha256_block_fn *)sha256_block_data_order_neon);
> +       sha256_base_do_update(desc, data, len, sha256_block_data_order_ne=
on);
>         kernel_neon_end();
>
>         return 0;
> @@ -50,9 +49,8 @@ static int crypto_sha256_neon_finup(struct shash_desc *=
desc, const u8 *data,
>         kernel_neon_begin();
>         if (len)
>                 sha256_base_do_update(desc, data, len,
> -                       (sha256_block_fn *)sha256_block_data_order_neon);
> -       sha256_base_do_finalize(desc,
> -                       (sha256_block_fn *)sha256_block_data_order_neon);
> +                                     sha256_block_data_order_neon);
> +       sha256_base_do_finalize(desc, sha256_block_data_order_neon);
>         kernel_neon_end();
>
>         return sha256_base_finish(desc, out);
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>


--=20
Thanks,
~Nick Desaulniers
