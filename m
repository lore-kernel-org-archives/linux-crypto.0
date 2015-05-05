From: Steve Capper <steve.capper@linaro.org>
Subject: Re: [PATCH 1/2] crypto: arm64/crc32: bring in line with generic CRC32
Date: Tue, 5 May 2015 11:08:34 +0100
Message-ID: <CAPvkgC3O9vSoA_TQAZ9_1JfqPHRmKN0JEoyj4rV97+RJutoDFA@mail.gmail.com>
References: <1430730017-3712-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	Yazen Ghannam <yazen.ghannam@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33627 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbbEEKIg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 May 2015 06:08:36 -0400
Received: by oica37 with SMTP id a37so138977529oic.0
        for <linux-crypto@vger.kernel.org>; Tue, 05 May 2015 03:08:35 -0700 (PDT)
In-Reply-To: <1430730017-3712-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4 May 2015 at 10:00, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> The arm64 CRC32 (not CRC32c) implementation was not quite doing
> the same thing as the generic one. Fix that.

Thanks Ard,
I agree the bitwise inverse at the end is applicable to Castagnoli,
but not to the vanilla CRC-32 in the kernel.

>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Steve Capper <steve.capper@linaro.org>

Cheers,
--
Steve

> ---
>  arch/arm64/crypto/crc32-arm64.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/crypto/crc32-arm64.c b/arch/arm64/crypto/crc32-arm64.c
> index 9499199924ae..6a37c3c6b11d 100644
> --- a/arch/arm64/crypto/crc32-arm64.c
> +++ b/arch/arm64/crypto/crc32-arm64.c
> @@ -147,13 +147,21 @@ static int chksum_final(struct shash_desc *desc, u8 *out)
>  {
>         struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
>
> +       put_unaligned_le32(ctx->crc, out);
> +       return 0;
> +}
> +
> +static int chksumc_final(struct shash_desc *desc, u8 *out)
> +{
> +       struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
> +
>         put_unaligned_le32(~ctx->crc, out);
>         return 0;
>  }
>
>  static int __chksum_finup(u32 crc, const u8 *data, unsigned int len, u8 *out)
>  {
> -       put_unaligned_le32(~crc32_arm64_le_hw(crc, data, len), out);
> +       put_unaligned_le32(crc32_arm64_le_hw(crc, data, len), out);
>         return 0;
>  }
>
> @@ -199,6 +207,14 @@ static int crc32_cra_init(struct crypto_tfm *tfm)
>  {
>         struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
>
> +       mctx->key = 0;
> +       return 0;
> +}
> +
> +static int crc32c_cra_init(struct crypto_tfm *tfm)
> +{
> +       struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
> +
>         mctx->key = ~0;
>         return 0;
>  }
> @@ -229,7 +245,7 @@ static struct shash_alg crc32c_alg = {
>         .setkey                 =       chksum_setkey,
>         .init                   =       chksum_init,
>         .update                 =       chksumc_update,
> -       .final                  =       chksum_final,
> +       .final                  =       chksumc_final,
>         .finup                  =       chksumc_finup,
>         .digest                 =       chksumc_digest,
>         .descsize               =       sizeof(struct chksum_desc_ctx),
> @@ -241,7 +257,7 @@ static struct shash_alg crc32c_alg = {
>                 .cra_alignmask          =       0,
>                 .cra_ctxsize            =       sizeof(struct chksum_ctx),
>                 .cra_module             =       THIS_MODULE,
> -               .cra_init               =       crc32_cra_init,
> +               .cra_init               =       crc32c_cra_init,
>         }
>  };
>
> --
> 1.9.1
>
