From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] arm/arm64/crypto: assure that ECB modes don't require an IV
Date: Fri, 12 Feb 2016 18:00:01 +0100
Message-ID: <CAKv+Gu8_Z5=0dTeBsVgx_BT0c+_O5PNUCyKFjuDf9x470bxHOA@mail.gmail.com>
References: <1455292072-5236-1-git-send-email-jeremy.linton@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Jeremy Linton <jeremy.linton@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35262 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbcBLRAB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Feb 2016 12:00:01 -0500
Received: by mail-ig0-f169.google.com with SMTP id hb3so13581980igb.0
        for <linux-crypto@vger.kernel.org>; Fri, 12 Feb 2016 09:00:01 -0800 (PST)
In-Reply-To: <1455292072-5236-1-git-send-email-jeremy.linton@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12 February 2016 at 16:47, Jeremy Linton <jeremy.linton@arm.com> wrote:
> ECB modes don't use an initialization vector. The kernel
> /proc/crypto interface doesn't reflect this properly.
>
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>

Thanks for spotting that!

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm/crypto/aes-ce-glue.c | 4 ++--
>  arch/arm64/crypto/aes-glue.c  | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
> index b445a5d..89a3a3e 100644
> --- a/arch/arm/crypto/aes-ce-glue.c
> +++ b/arch/arm/crypto/aes-ce-glue.c
> @@ -364,7 +364,7 @@ static struct crypto_alg aes_algs[] = { {
>         .cra_blkcipher = {
>                 .min_keysize    = AES_MIN_KEY_SIZE,
>                 .max_keysize    = AES_MAX_KEY_SIZE,
> -               .ivsize         = AES_BLOCK_SIZE,
> +               .ivsize         = 0,
>                 .setkey         = ce_aes_setkey,
>                 .encrypt        = ecb_encrypt,
>                 .decrypt        = ecb_decrypt,
> @@ -441,7 +441,7 @@ static struct crypto_alg aes_algs[] = { {
>         .cra_ablkcipher = {
>                 .min_keysize    = AES_MIN_KEY_SIZE,
>                 .max_keysize    = AES_MAX_KEY_SIZE,
> -               .ivsize         = AES_BLOCK_SIZE,
> +               .ivsize         = 0,
>                 .setkey         = ablk_set_key,
>                 .encrypt        = ablk_encrypt,
>                 .decrypt        = ablk_decrypt,
> diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
> index 05d9e16..7a3d22a 100644
> --- a/arch/arm64/crypto/aes-glue.c
> +++ b/arch/arm64/crypto/aes-glue.c
> @@ -294,7 +294,7 @@ static struct crypto_alg aes_algs[] = { {
>         .cra_blkcipher = {
>                 .min_keysize    = AES_MIN_KEY_SIZE,
>                 .max_keysize    = AES_MAX_KEY_SIZE,
> -               .ivsize         = AES_BLOCK_SIZE,
> +               .ivsize         = 0,
>                 .setkey         = aes_setkey,
>                 .encrypt        = ecb_encrypt,
>                 .decrypt        = ecb_decrypt,
> @@ -371,7 +371,7 @@ static struct crypto_alg aes_algs[] = { {
>         .cra_ablkcipher = {
>                 .min_keysize    = AES_MIN_KEY_SIZE,
>                 .max_keysize    = AES_MAX_KEY_SIZE,
> -               .ivsize         = AES_BLOCK_SIZE,
> +               .ivsize         = 0,
>                 .setkey         = ablk_set_key,
>                 .encrypt        = ablk_encrypt,
>                 .decrypt        = ablk_decrypt,
> --
> 2.4.3
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
