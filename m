Return-Path: <SRS0=q4N3=V5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864F7C19759
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 05:02:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A19620B7C
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 05:02:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dol+D83w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbfHAFCK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Aug 2019 01:02:10 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39057 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728442AbfHAFCJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Aug 2019 01:02:09 -0400
Received: by mail-wm1-f66.google.com with SMTP id u25so51523587wmc.4
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jul 2019 22:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lMqNv0u8vBtruasmPaSSkIba00POWJCMhQidPLWHY2M=;
        b=dol+D83wA19zSVl89V10SNxHVy3VlznKnl5Umucz1gmDWVF7T8xfFC2TsjaHKxbd5p
         MWqtlXDMw9eXmw49icqt8ZgKuwj6EkQkGCJZ2yeGvcEy9ofj0w0wSG3gk1nMsx14MEEo
         zAv965eqloPiIVBPO2FOXLVcKgZlOupIwdZJky3vmh+gPvQhmxK459/wGlQ2S0RUzW8N
         6U7n4UHPgVStZErjETjSp2udtUh+I7TLF5PveAGoONlFJzPlMKazI2ZHhWIMGWwgKzH3
         X5T7KrYIUyMOcO3cYiej1UpibwurUn/vZVF8VPIn60bQwSZ6+r1RUOHl+Kj3tG1HnOM+
         N4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lMqNv0u8vBtruasmPaSSkIba00POWJCMhQidPLWHY2M=;
        b=UAZGLyqSTjnZtrG7BtSmhSPdmmlLU8qC9QttclkmNCu3+QigJAmYyCMihQgRwcAkYs
         nXTfyrbf3NQkX2uhMUfrb8cubTgrzj8cJs/12YgoVxBivBMLJI9BfQThJnKDnMEgN6Rz
         ntDBwcGfXsNTj10Z4xAX4Ie3ui1Fu7meX/+F5B7mE2QDiJqtmqfNf5upoGFE9etSLoNz
         CQo0GKJE+62APe8Fb1v0QDsMhTk7TWbnf7M6LbxZ8h4uoeFk/0KJtsV/rJLMXR12mXxz
         VTz4Z0/WThZ/tje37WklzLeDI7BDiSUitbry85f7Qh/HrILoylV1UujZYEIufyeSCCXO
         cfdg==
X-Gm-Message-State: APjAAAX+TApHkBtUt2hMAde/0VMgPdrgtu4X+ENUdazIISoKuBUgeqHh
        pYBqj86JzJlYovaSoNbBX61HemTgOI7kRwYpiW+Hag==
X-Google-Smtp-Source: APXvYqzW9Hm/OljmGnTNE3pQDpI/o8Ig99QXpNTASPVxDa38zfbVgd64ARE5k51pWFYGwCPqbIFwrAG+M8Ie4C+Isp4=
X-Received: by 2002:a1c:b706:: with SMTP id h6mr110550423wmf.119.1564635726867;
 Wed, 31 Jul 2019 22:02:06 -0700 (PDT)
MIME-Version: 1.0
References: <13353.1564635114@turing-police>
In-Reply-To: <13353.1564635114@turing-police>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 1 Aug 2019 08:01:54 +0300
Message-ID: <CAKv+Gu8EF3R05hLWHh7mgbgkUyzBwELctdVvSFMq+6Crw6Tf4A@mail.gmail.com>
Subject: Re: [PATCH] linux-next 20190731 - aegis128-core.c fails to build
To:     =?UTF-8?Q?Valdis_Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+ Arnd)

On Thu, 1 Aug 2019 at 07:52, Valdis Kl=C4=93tnieks <valdis.kletnieks@vt.edu=
> wrote:
>
> The recent NEON SIMD patches break the build if CONFIG_CRYPTO_AEGIS128_SI=
MD isn't set:
>
>   MODPOST 558 modules
> ERROR: "crypto_aegis128_decrypt_chunk_simd" [crypto/aegis128.ko] undefine=
d!
> ERROR: "crypto_aegis128_update_simd" [crypto/aegis128.ko] undefined!
> ERROR: "crypto_aegis128_encrypt_chunk_simd" [crypto/aegis128.ko] undefine=
d!
> make[1]: *** [scripts/Makefile.modpost:105: modules-modpost] Error 1
> make: *** [Makefile:1299: modules] Error 2
>
> Add proper definitions and stubs to aegis.h so it builds both ways. This
> necessitated moving other stuff from aegis128-core.c to aegis.h so things=
 were
> defined in the proper order.
>
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Which compiler version are you using? All references to the
crypt_aegis128_xx_simd() routines should disappear if
CONFIG_CRYPTO_AEGIS128_SIMD is not set (in which case have_simd will
always be false and so the compiler should optimize away those calls).


> ---
> diff --git a/crypto/aegis.h b/crypto/aegis.h
> index 4d56a85aea49..50a7496ca4ae 100644
> --- a/crypto/aegis.h
> +++ b/crypto/aegis.h
> @@ -13,6 +13,11 @@
>  #include <linux/bitops.h>
>  #include <linux/types.h>
>
> +#define AEGIS128_NONCE_SIZE 16
> +#define AEGIS128_STATE_BLOCKS 5
> +#define AEGIS128_KEY_SIZE 16
> +#define AEGIS128_MIN_AUTH_SIZE 8
> +#define AEGIS128_MAX_AUTH_SIZE 16
>  #define AEGIS_BLOCK_SIZE 16
>
>  union aegis_block {
> @@ -21,6 +26,39 @@ union aegis_block {
>         u8 bytes[AEGIS_BLOCK_SIZE];
>  };
>
> +struct aegis_state {
> +       union aegis_block blocks[AEGIS128_STATE_BLOCKS];
> +};
> +
> +struct aegis_ctx {
> +       union aegis_block key;
> +};
> +
> +struct aegis128_ops {
> +       int (*skcipher_walk_init)(struct skcipher_walk *walk,
> +                                 struct aead_request *req, bool atomic);
> +
> +       void (*crypt_chunk)(struct aegis_state *state, u8 *dst,
> +                           const u8 *src, unsigned int size);
> +};
> +
> +
> +#ifdef CONFIG_CRYPTO_AEGIS128_SIMD
> +bool crypto_aegis128_have_simd(void);
> +void crypto_aegis128_update_simd(struct aegis_state *state, const void *=
msg);
> +void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *d=
st,
> +                                       const u8 *src, unsigned int size)=
;
> +void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *d=
st,
> +                                       const u8 *src, unsigned int size)=
;
> +#else
> +static inline bool crypto_aegis128_have_simd(void) { return false; }
> +static inline void crypto_aegis128_update_simd(struct aegis_state *state=
, const void *msg) { }
> +static inline void crypto_aegis128_encrypt_chunk_simd(struct aegis_state=
 *state, u8 *dst,
> +                                       const u8 *src, unsigned int size)=
 { }
> +static inline void crypto_aegis128_decrypt_chunk_simd(struct aegis_state=
 *state, u8 *dst,
> +                                       const u8 *src, unsigned int size)=
 { }
> +#endif
> +
>  #define AEGIS_BLOCK_ALIGN (__alignof__(union aegis_block))
>  #define AEGIS_ALIGNED(p) IS_ALIGNED((uintptr_t)p, AEGIS_BLOCK_ALIGN)
>
> diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
> index f815b4685156..8b738128a921 100644
> --- a/crypto/aegis128-core.c
> +++ b/crypto/aegis128-core.c
> @@ -20,37 +20,8 @@
>
>  #include "aegis.h"
>
> -#define AEGIS128_NONCE_SIZE 16
> -#define AEGIS128_STATE_BLOCKS 5
> -#define AEGIS128_KEY_SIZE 16
> -#define AEGIS128_MIN_AUTH_SIZE 8
> -#define AEGIS128_MAX_AUTH_SIZE 16
> -
> -struct aegis_state {
> -       union aegis_block blocks[AEGIS128_STATE_BLOCKS];
> -};
> -
> -struct aegis_ctx {
> -       union aegis_block key;
> -};
> -
> -struct aegis128_ops {
> -       int (*skcipher_walk_init)(struct skcipher_walk *walk,
> -                                 struct aead_request *req, bool atomic);
> -
> -       void (*crypt_chunk)(struct aegis_state *state, u8 *dst,
> -                           const u8 *src, unsigned int size);
> -};
> -
>  static bool have_simd;
>
> -bool crypto_aegis128_have_simd(void);
> -void crypto_aegis128_update_simd(struct aegis_state *state, const void *=
msg);
> -void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *d=
st,
> -                                       const u8 *src, unsigned int size)=
;
> -void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *d=
st,
> -                                       const u8 *src, unsigned int size)=
;
> -
>  static void crypto_aegis128_update(struct aegis_state *state)
>  {
>         union aegis_block tmp;
>
