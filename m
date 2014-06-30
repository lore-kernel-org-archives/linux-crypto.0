From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] [v2] crypto: sha1/ARM: make use of common SHA-1 structures
Date: Mon, 30 Jun 2014 20:08:56 +0200
Message-ID: <CAKv+Gu_FEpmuH0_ZU8o60TB6MtE-6kr0_kakC8RU4956+U51JQ@mail.gmail.com>
References: <20140629143349.17245.50072.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:60499 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaF3SI6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Jun 2014 14:08:58 -0400
Received: by mail-la0-f50.google.com with SMTP id pv20so5048241lab.23
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jun 2014 11:08:56 -0700 (PDT)
In-Reply-To: <20140629143349.17245.50072.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 29 June 2014 16:33, Jussi Kivilinna <jussi.kivilinna@iki.fi> wrote:
> Common SHA-1 structures are defined in <crypto/sha.h> for code sharing.
>
> This patch changes SHA-1/ARM glue code to use these structures.
>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> ---

These two should go into Russell's patch system if nobody else has any
more comments.

http://www.arm.linux.org.uk/developer/patches/

-- 
Ard.


>  arch/arm/crypto/sha1_glue.c |   50 +++++++++++++++++++------------------------
>  1 file changed, 22 insertions(+), 28 deletions(-)
>
> diff --git a/arch/arm/crypto/sha1_glue.c b/arch/arm/crypto/sha1_glue.c
> index 76cd976..c494e57 100644
> --- a/arch/arm/crypto/sha1_glue.c
> +++ b/arch/arm/crypto/sha1_glue.c
> @@ -24,31 +24,25 @@
>  #include <crypto/sha.h>
>  #include <asm/byteorder.h>
>
> -struct SHA1_CTX {
> -       uint32_t h0,h1,h2,h3,h4;
> -       u64 count;
> -       u8 data[SHA1_BLOCK_SIZE];
> -};
>
> -asmlinkage void sha1_block_data_order(struct SHA1_CTX *digest,
> +asmlinkage void sha1_block_data_order(u32 *digest,
>                 const unsigned char *data, unsigned int rounds);
>
>
>  static int sha1_init(struct shash_desc *desc)
>  {
> -       struct SHA1_CTX *sctx = shash_desc_ctx(desc);
> -       memset(sctx, 0, sizeof(*sctx));
> -       sctx->h0 = SHA1_H0;
> -       sctx->h1 = SHA1_H1;
> -       sctx->h2 = SHA1_H2;
> -       sctx->h3 = SHA1_H3;
> -       sctx->h4 = SHA1_H4;
> +       struct sha1_state *sctx = shash_desc_ctx(desc);
> +
> +       *sctx = (struct sha1_state){
> +               .state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
> +       };
> +
>         return 0;
>  }
>
>
> -static int __sha1_update(struct SHA1_CTX *sctx, const u8 *data,
> -                              unsigned int len, unsigned int partial)
> +static int __sha1_update(struct sha1_state *sctx, const u8 *data,
> +                        unsigned int len, unsigned int partial)
>  {
>         unsigned int done = 0;
>
> @@ -56,17 +50,17 @@ static int __sha1_update(struct SHA1_CTX *sctx, const u8 *data,
>
>         if (partial) {
>                 done = SHA1_BLOCK_SIZE - partial;
> -               memcpy(sctx->data + partial, data, done);
> -               sha1_block_data_order(sctx, sctx->data, 1);
> +               memcpy(sctx->buffer + partial, data, done);
> +               sha1_block_data_order(sctx->state, sctx->buffer, 1);
>         }
>
>         if (len - done >= SHA1_BLOCK_SIZE) {
>                 const unsigned int rounds = (len - done) / SHA1_BLOCK_SIZE;
> -               sha1_block_data_order(sctx, data + done, rounds);
> +               sha1_block_data_order(sctx->state, data + done, rounds);
>                 done += rounds * SHA1_BLOCK_SIZE;
>         }
>
> -       memcpy(sctx->data, data + done, len - done);
> +       memcpy(sctx->buffer, data + done, len - done);
>         return 0;
>  }
>
> @@ -74,14 +68,14 @@ static int __sha1_update(struct SHA1_CTX *sctx, const u8 *data,
>  static int sha1_update(struct shash_desc *desc, const u8 *data,
>                              unsigned int len)
>  {
> -       struct SHA1_CTX *sctx = shash_desc_ctx(desc);
> +       struct sha1_state *sctx = shash_desc_ctx(desc);
>         unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
>         int res;
>
>         /* Handle the fast case right here */
>         if (partial + len < SHA1_BLOCK_SIZE) {
>                 sctx->count += len;
> -               memcpy(sctx->data + partial, data, len);
> +               memcpy(sctx->buffer + partial, data, len);
>                 return 0;
>         }
>         res = __sha1_update(sctx, data, len, partial);
> @@ -92,7 +86,7 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
>  /* Add padding and return the message digest. */
>  static int sha1_final(struct shash_desc *desc, u8 *out)
>  {
> -       struct SHA1_CTX *sctx = shash_desc_ctx(desc);
> +       struct sha1_state *sctx = shash_desc_ctx(desc);
>         unsigned int i, index, padlen;
>         __be32 *dst = (__be32 *)out;
>         __be64 bits;
> @@ -106,7 +100,7 @@ static int sha1_final(struct shash_desc *desc, u8 *out)
>         /* We need to fill a whole block for __sha1_update() */
>         if (padlen <= 56) {
>                 sctx->count += padlen;
> -               memcpy(sctx->data + index, padding, padlen);
> +               memcpy(sctx->buffer + index, padding, padlen);
>         } else {
>                 __sha1_update(sctx, padding, padlen, index);
>         }
> @@ -114,7 +108,7 @@ static int sha1_final(struct shash_desc *desc, u8 *out)
>
>         /* Store state in digest */
>         for (i = 0; i < 5; i++)
> -               dst[i] = cpu_to_be32(((u32 *)sctx)[i]);
> +               dst[i] = cpu_to_be32(sctx->state[i]);
>
>         /* Wipe context */
>         memset(sctx, 0, sizeof(*sctx));
> @@ -124,7 +118,7 @@ static int sha1_final(struct shash_desc *desc, u8 *out)
>
>  static int sha1_export(struct shash_desc *desc, void *out)
>  {
> -       struct SHA1_CTX *sctx = shash_desc_ctx(desc);
> +       struct sha1_state *sctx = shash_desc_ctx(desc);
>         memcpy(out, sctx, sizeof(*sctx));
>         return 0;
>  }
> @@ -132,7 +126,7 @@ static int sha1_export(struct shash_desc *desc, void *out)
>
>  static int sha1_import(struct shash_desc *desc, const void *in)
>  {
> -       struct SHA1_CTX *sctx = shash_desc_ctx(desc);
> +       struct sha1_state *sctx = shash_desc_ctx(desc);
>         memcpy(sctx, in, sizeof(*sctx));
>         return 0;
>  }
> @@ -145,8 +139,8 @@ static struct shash_alg alg = {
>         .final          =       sha1_final,
>         .export         =       sha1_export,
>         .import         =       sha1_import,
> -       .descsize       =       sizeof(struct SHA1_CTX),
> -       .statesize      =       sizeof(struct SHA1_CTX),
> +       .descsize       =       sizeof(struct sha1_state),
> +       .statesize      =       sizeof(struct sha1_state),
>         .base           =       {
>                 .cra_name       =       "sha1",
>                 .cra_driver_name=       "sha1-asm",
>
