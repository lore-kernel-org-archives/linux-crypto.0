From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] crypto: ccree - avoid implicit enum conversion
Date: Wed, 10 Oct 2018 16:49:06 -0700
Message-ID: <CAKwvOdk+JmBP4TBAG+DfhehofM0sO0vWRXbAbEifYy+T+u_SVQ@mail.gmail.com>
References: <20181010214006.21304-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: gilad@benyossef.com, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Nathan Chancellor <natechancellor@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181010214006.21304-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 10, 2018 at 2:44 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns when one enumerated type is implicitly converted to another
> and this happens in several locations in this driver, ultimately related
> to the set_cipher_{mode,config0} functions. set_cipher_mode expects a mode
> of type drv_cipher_mode and set_cipher_config0 expects a mode of type
> drv_crypto_direction.
>
> drivers/crypto/ccree/cc_ivgen.c:58:35: warning: implicit conversion from
> enumeration type 'enum cc_desc_direction' to different enumeration type
> 'enum drv_crypto_direction' [-Wenum-conversion]
>         set_cipher_config0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
>
> drivers/crypto/ccree/cc_hash.c:99:28: warning: implicit conversion from
> enumeration type 'enum cc_hash_conf_pad' to different enumeration type
> 'enum drv_crypto_direction' [-Wenum-conversion]
>                 set_cipher_config0(desc, HASH_DIGEST_RESULT_LITTLE_ENDIAN);

$ grep -r set_cipher_config0 -n

shows a healthy mix of DESC_DIRECTION_ENCRYPT_ENCRYPT,
HASH_DIGEST_RESULT_LITTLE_ENDIAN, and DRV_CRYPTO_DIRECTION_ENCRYPT
(all enumeration values of different enums).

>
> drivers/crypto/ccree/cc_aead.c:1643:30: warning: implicit conversion
> from enumeration type 'enum drv_hash_hw_mode' to different enumeration
> type 'enum drv_cipher_mode' [-Wenum-conversion]
>         set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);

Looks like a lot fewer call sites using DRV_HASH_HW_GHASH; same value
as DRV_CIPHER_OFB (different enum), but can a block cipher mode and a
hash be valid values for pdesc->word[4]?

>
> Since this fundamentally isn't a problem because these values just
> represent simple integers for a shift operation, make it clear to Clang
> that this is okay by making the mode parameter in both functions an int.

This also looks like the simplest fix to me, assuming the values of
all of these enums are valid for whatever pdesc->word[4] is.  Can the
maintainers explain what is CC7x-DESC what the comment makes reference
to?

>
> Link: https://github.com/ClangBuiltLinux/linux/issues/46
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>
> Alternatively:
>
> 1. The uses of DESC_DIRECTION_ENCRYPT_ENCRYPT could be replaced with
>    DRV_CRYPTO_DIRECTION_ENCRYPT since they are the same value.
>
> 2. An enum of value 2 could be added to drv_crypto_direction which is
>    what HASH_DIGEST_RESULT_LITTLE_ENDIAN is equal to (not sure what that
>    should be named).
>
> 3. DRV_HASH_HW_GHASH could be removed and replaced with DRV_CIPHER_OFB
>    since they are the same value.
>
> This patch seems to make the most sense to me given that the enums are
> just functioning as integers but I'm willing to fix this however the
> maintainers want.
>
>  drivers/crypto/ccree/cc_hw_queue_defs.h | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/crypto/ccree/cc_hw_queue_defs.h b/drivers/crypto/ccree/cc_hw_queue_defs.h
> index a091ae57f902..45985b955d2c 100644
> --- a/drivers/crypto/ccree/cc_hw_queue_defs.h
> +++ b/drivers/crypto/ccree/cc_hw_queue_defs.h
> @@ -449,8 +449,7 @@ static inline void set_flow_mode(struct cc_hw_desc *pdesc,
>   * @pdesc: pointer HW descriptor struct
>   * @mode:  Any one of the modes defined in [CC7x-DESC]
>   */
> -static inline void set_cipher_mode(struct cc_hw_desc *pdesc,
> -                                  enum drv_cipher_mode mode)
> +static inline void set_cipher_mode(struct cc_hw_desc *pdesc, int mode)
>  {
>         pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_MODE, mode);
>  }
> @@ -461,8 +460,7 @@ static inline void set_cipher_mode(struct cc_hw_desc *pdesc,
>   * @pdesc: pointer HW descriptor struct
>   * @mode: Any one of the modes defined in [CC7x-DESC]
>   */
> -static inline void set_cipher_config0(struct cc_hw_desc *pdesc,
> -                                     enum drv_crypto_direction mode)
> +static inline void set_cipher_config0(struct cc_hw_desc *pdesc, int mode)
>  {
>         pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_CONF0, mode);
>  }
> --
> 2.19.1
>


-- 
Thanks,
~Nick Desaulniers
