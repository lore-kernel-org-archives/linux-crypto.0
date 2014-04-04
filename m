From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [crypto:master 60/60] arch/x86/crypto/ghash-clmulni-intel_glue.c:71:25:
 sparse: cast to restricted __be64
Date: Fri, 4 Apr 2014 15:03:55 +0200
Message-ID: <CAKv+Gu84=VWiS+4EBopjfte-ZrXkGg-1K1Gh6-iA+=bKR8vC8g@mail.gmail.com>
References: <533aa1ae.qq4Hi3RBnPzgncue%fengguang.wu@intel.com>
	<CAKv+Gu_unwqLWWn-VDegy=vF=rprC5qFhazo_sJFNm738MVgaQ@mail.gmail.com>
	<20140401124824.GA13642@gondor.apana.org.au>
	<20140404122537.GA9389@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	kbuild test robot <fengguang.wu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:45221 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbaDDND5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Apr 2014 09:03:57 -0400
Received: by mail-lb0-f181.google.com with SMTP id c11so2402842lbj.26
        for <linux-crypto@vger.kernel.org>; Fri, 04 Apr 2014 06:03:56 -0700 (PDT)
In-Reply-To: <20140404122537.GA9389@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4 April 2014 14:25, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Apr 01, 2014 at 08:48:24PM +0800, Herbert Xu wrote:
>> On Tue, Apr 01, 2014 at 02:37:20PM +0200, Ard Biesheuvel wrote:
>> > On 1 April 2014 13:23, kbuild test robot <fengguang.wu@intel.com> wrote:
>> > > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
>> > > head:   8ceee72808d1ae3fb191284afc2257a2be964725
>> > > commit: 8ceee72808d1ae3fb191284afc2257a2be964725 [60/60] crypto: ghash-clmulni-intel - use C implementation for setkey()
>> > > reproduce: make C=1 CF=-D__CHECK_ENDIAN__
>> > >
>> > >
>> > > sparse warnings: (new ones prefixed by >>)
>> > >
>> > >>> arch/x86/crypto/ghash-clmulni-intel_glue.c:71:25: sparse: cast to restricted __be64
>> > >>> arch/x86/crypto/ghash-clmulni-intel_glue.c:72:25: sparse: cast to restricted __be64
>> > >
>> >
>> > Sigh.
>> >
>> > The sparse warnings /without/ the be64 casts are even worse.
>> >
>> > The obvious fix is not to use a be128 for the key, as it is obviously
>> > an opaque type that just represents a byte array.
>> > So, Herbert, if you prefer, I can rework this patch to use be128
>> > instead of u128 inside struct ghash_ctx, but it will have some fallout
>> > throughout the file. Or instead, we cast to '__force __be64',
>> > basically just telling sparse to shut up ...
>>
>> I'll add the __force to shut it up.  Thanks!
>
> On closer inspection I think your suggestion to use u128 makes
> more sense.  So I have added the following patch to cryptodev.
>
> commit 91eef5ab1b378e10e6f87c28c9bb46614a1cc491
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Fri Apr 4 20:24:03 2014 +0800
>
>     crypto: ghash-clmulni-intel - Use u128 instead of be128 for internal key
>
>     The internal key isn't actually in big-endian format so let's switch
>     to u128 which also happens to allow us to remove a sparse warning.
>
>     Based on suggestion by Ard Biesheuvel.
>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
> index 185fad4..5d1e007 100644
> --- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
> +++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
> @@ -92,7 +92,7 @@ __clmul_gf128mul_ble:
>         ret
>  ENDPROC(__clmul_gf128mul_ble)
>
> -/* void clmul_ghash_mul(char *dst, const be128 *shash) */
> +/* void clmul_ghash_mul(char *dst, const u128 *shash) */
>  ENTRY(clmul_ghash_mul)
>         movups (%rdi), DATA
>         movups (%rsi), SHASH
> @@ -106,7 +106,7 @@ ENDPROC(clmul_ghash_mul)
>
>  /*
>   * void clmul_ghash_update(char *dst, const char *src, unsigned int srclen,
> - *                        const be128 *shash);
> + *                        const u128 *shash);
>   */
>  ENTRY(clmul_ghash_update)
>         cmp $16, %rdx
> diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
> index d785cf2..00eacd2 100644
> --- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
> +++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
> @@ -25,17 +25,17 @@
>  #define GHASH_BLOCK_SIZE       16
>  #define GHASH_DIGEST_SIZE      16
>
> -void clmul_ghash_mul(char *dst, const be128 *shash);
> +void clmul_ghash_mul(char *dst, const u128 *shash);
>
>  void clmul_ghash_update(char *dst, const char *src, unsigned int srclen,
> -                       const be128 *shash);
> +                       const u128 *shash);
>
>  struct ghash_async_ctx {
>         struct cryptd_ahash *cryptd_tfm;
>  };
>
>  struct ghash_ctx {
> -       be128 shash;
> +       u128 shash;
>  };
>
>  struct ghash_desc_ctx {
> @@ -68,11 +68,11 @@ static int ghash_setkey(struct crypto_shash *tfm,
>         a = be64_to_cpu(x->a);
>         b = be64_to_cpu(x->b);
>
> -       ctx->shash.a = (__be64)((b << 1) | (a >> 63));
> -       ctx->shash.b = (__be64)((a << 1) | (b >> 63));
> +       ctx->shash.a = (b << 1) | (a >> 63);
> +       ctx->shash.b = (a << 1) | (b >> 63);
>
>         if (a >> 63)
> -               ctx->shash.b ^= cpu_to_be64(0xc2);
> +               ctx->shash.b ^= ((u64)0xc2) << 48;
>

I think you mean '0xc2 << 56' here

Other than that:
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Regards,
Ard.
