From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 1/2] crypto: sm4 - export encrypt/decrypt routines to
 other drivers
Date: Wed, 25 Apr 2018 15:47:56 +0300
Message-ID: <CAOtvUMdsncpGCpwibcnfPP2G+EMxDg630SdhvGTE+K2qiZkKLA@mail.gmail.com>
References: <20180425122046.12695-1-ard.biesheuvel@linaro.org>
 <20180425122046.12695-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org, Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180425122046.12695-2-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Apr 25, 2018 at 3:20 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> In preparation of adding support for the SIMD based arm64 implementation
> of arm64, which requires a fallback to non-SIMD code when invoked in
> certain contexts, expose the generic SM4 encrypt and decrypt routines
> to other drivers.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

> ---
>  crypto/sm4_generic.c | 10 ++++++----
>  include/crypto/sm4.h |  3 +++
>  2 files changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/crypto/sm4_generic.c b/crypto/sm4_generic.c
> index f537a2766c55..c18eebfd5edd 100644
> --- a/crypto/sm4_generic.c
> +++ b/crypto/sm4_generic.c
> @@ -190,21 +190,23 @@ static void sm4_do_crypt(const u32 *rk, u32 *out, const u32 *in)
>
>  /* encrypt a block of text */
>
> -static void sm4_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +void crypto_sm4_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>         const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
>
>         sm4_do_crypt(ctx->rkey_enc, (u32 *)out, (u32 *)in);
>  }
> +EXPORT_SYMBOL_GPL(crypto_sm4_encrypt);
>
>  /* decrypt a block of text */
>
> -static void sm4_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +void crypto_sm4_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>         const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
>
>         sm4_do_crypt(ctx->rkey_dec, (u32 *)out, (u32 *)in);
>  }
> +EXPORT_SYMBOL_GPL(crypto_sm4_decrypt);
>
>  static struct crypto_alg sm4_alg = {
>         .cra_name               =       "sm4",
> @@ -219,8 +221,8 @@ static struct crypto_alg sm4_alg = {
>                         .cia_min_keysize        =       SM4_KEY_SIZE,
>                         .cia_max_keysize        =       SM4_KEY_SIZE,
>                         .cia_setkey             =       crypto_sm4_set_key,
> -                       .cia_encrypt            =       sm4_encrypt,
> -                       .cia_decrypt            =       sm4_decrypt
> +                       .cia_encrypt            =       crypto_sm4_encrypt,
> +                       .cia_decrypt            =       crypto_sm4_decrypt
>                 }
>         }
>  };
> diff --git a/include/crypto/sm4.h b/include/crypto/sm4.h
> index b64e64d20b28..7afd730d16ff 100644
> --- a/include/crypto/sm4.h
> +++ b/include/crypto/sm4.h
> @@ -25,4 +25,7 @@ int crypto_sm4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>  int crypto_sm4_expand_key(struct crypto_sm4_ctx *ctx, const u8 *in_key,
>                           unsigned int key_len);
>
> +void crypto_sm4_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in);
> +void crypto_sm4_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in);
> +
>  #endif
> --
> 2.17.0
>



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
