From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] crypto/ecc: Actually remove stack VLA usage
Date: Mon, 16 Apr 2018 09:04:56 -0700
Message-ID: <CAGXu5j+n6Gp_pBz6uvSNg3C=W=9TLaNonF-YS0SEz7oqbXef_g@mail.gmail.com>
References: <20180330165544.GA13206@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180330165544.GA13206@beast>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 30, 2018 at 9:55 AM, Kees Cook <keescook@chromium.org> wrote:
> On the quest to remove all VLAs from the kernel[1], this avoids VLAs
> by just using the maximum allocation size (4 bytes) for stack arrays.
> All the VLAs in ecc were either 3 or 4 bytes (or a multiple), so just
> make it 4 bytes all the time. Initialization routines are adjusted to
> check that ndigits does not end up larger than the arrays.
>
> This includes a removal of the earlier attempt at this fix from
> commit a963834b4742 ("crypto/ecc: Remove stack VLA usage")
>
> [1] https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Friendly ping. Please apply to fix a963834b4742 ("crypto/ecc: Remove
stack VLA usage").

Thanks!

-Kees

> ---
> v2:
> - Squash revert (herbert)
> ---
>  crypto/ecc.c  | 66 +++++++++++++++++++++++++----------------------------------
>  crypto/ecc.h  |  4 +++-
>  crypto/ecdh.c |  4 ++--
>  3 files changed, 33 insertions(+), 41 deletions(-)
>
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index 9c066b5ac12d..815541309a95 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -515,7 +515,7 @@ static void vli_mmod_fast_256(u64 *result, const u64 *product,
>  static bool vli_mmod_fast(u64 *result, u64 *product,
>                           const u64 *curve_prime, unsigned int ndigits)
>  {
> -       u64 tmp[2 * ndigits];
> +       u64 tmp[2 * ECC_MAX_DIGITS];
>
>         switch (ndigits) {
>         case 3:
> @@ -536,7 +536,7 @@ static bool vli_mmod_fast(u64 *result, u64 *product,
>  static void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
>                               const u64 *curve_prime, unsigned int ndigits)
>  {
> -       u64 product[2 * ndigits];
> +       u64 product[2 * ECC_MAX_DIGITS];
>
>         vli_mult(product, left, right, ndigits);
>         vli_mmod_fast(result, product, curve_prime, ndigits);
> @@ -546,7 +546,7 @@ static void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
>  static void vli_mod_square_fast(u64 *result, const u64 *left,
>                                 const u64 *curve_prime, unsigned int ndigits)
>  {
> -       u64 product[2 * ndigits];
> +       u64 product[2 * ECC_MAX_DIGITS];
>
>         vli_square(product, left, ndigits);
>         vli_mmod_fast(result, product, curve_prime, ndigits);
> @@ -560,8 +560,8 @@ static void vli_mod_square_fast(u64 *result, const u64 *left,
>  static void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
>                         unsigned int ndigits)
>  {
> -       u64 a[ndigits], b[ndigits];
> -       u64 u[ndigits], v[ndigits];
> +       u64 a[ECC_MAX_DIGITS], b[ECC_MAX_DIGITS];
> +       u64 u[ECC_MAX_DIGITS], v[ECC_MAX_DIGITS];
>         u64 carry;
>         int cmp_result;
>
> @@ -649,8 +649,8 @@ static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
>                                       u64 *curve_prime, unsigned int ndigits)
>  {
>         /* t1 = x, t2 = y, t3 = z */
> -       u64 t4[ndigits];
> -       u64 t5[ndigits];
> +       u64 t4[ECC_MAX_DIGITS];
> +       u64 t5[ECC_MAX_DIGITS];
>
>         if (vli_is_zero(z1, ndigits))
>                 return;
> @@ -711,7 +711,7 @@ static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
>  static void apply_z(u64 *x1, u64 *y1, u64 *z, u64 *curve_prime,
>                     unsigned int ndigits)
>  {
> -       u64 t1[ndigits];
> +       u64 t1[ECC_MAX_DIGITS];
>
>         vli_mod_square_fast(t1, z, curve_prime, ndigits);    /* z^2 */
>         vli_mod_mult_fast(x1, x1, t1, curve_prime, ndigits); /* x1 * z^2 */
> @@ -724,7 +724,7 @@ static void xycz_initial_double(u64 *x1, u64 *y1, u64 *x2, u64 *y2,
>                                 u64 *p_initial_z, u64 *curve_prime,
>                                 unsigned int ndigits)
>  {
> -       u64 z[ndigits];
> +       u64 z[ECC_MAX_DIGITS];
>
>         vli_set(x2, x1, ndigits);
>         vli_set(y2, y1, ndigits);
> @@ -750,7 +750,7 @@ static void xycz_add(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 *curve_prime,
>                      unsigned int ndigits)
>  {
>         /* t1 = X1, t2 = Y1, t3 = X2, t4 = Y2 */
> -       u64 t5[ndigits];
> +       u64 t5[ECC_MAX_DIGITS];
>
>         /* t5 = x2 - x1 */
>         vli_mod_sub(t5, x2, x1, curve_prime, ndigits);
> @@ -791,9 +791,9 @@ static void xycz_add_c(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 *curve_prime,
>                        unsigned int ndigits)
>  {
>         /* t1 = X1, t2 = Y1, t3 = X2, t4 = Y2 */
> -       u64 t5[ndigits];
> -       u64 t6[ndigits];
> -       u64 t7[ndigits];
> +       u64 t5[ECC_MAX_DIGITS];
> +       u64 t6[ECC_MAX_DIGITS];
> +       u64 t7[ECC_MAX_DIGITS];
>
>         /* t5 = x2 - x1 */
>         vli_mod_sub(t5, x2, x1, curve_prime, ndigits);
> @@ -846,9 +846,9 @@ static void ecc_point_mult(struct ecc_point *result,
>                            unsigned int ndigits)
>  {
>         /* R0 and R1 */
> -       u64 rx[2][ndigits];
> -       u64 ry[2][ndigits];
> -       u64 z[ndigits];
> +       u64 rx[2][ECC_MAX_DIGITS];
> +       u64 ry[2][ECC_MAX_DIGITS];
> +       u64 z[ECC_MAX_DIGITS];
>         int i, nb;
>         int num_bits = vli_num_bits(scalar, ndigits);
>
> @@ -943,13 +943,13 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
>  int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
>  {
>         const struct ecc_curve *curve = ecc_get_curve(curve_id);
> -       u64 priv[ndigits];
> +       u64 priv[ECC_MAX_DIGITS];
>         unsigned int nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
>         unsigned int nbits = vli_num_bits(curve->n, ndigits);
>         int err;
>
>         /* Check that N is included in Table 1 of FIPS 186-4, section 6.1.1 */
> -       if (nbits < 160)
> +       if (nbits < 160 || ndigits > ARRAY_SIZE(priv))
>                 return -EINVAL;
>
>         /*
> @@ -988,10 +988,10 @@ int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
>  {
>         int ret = 0;
>         struct ecc_point *pk;
> -       u64 priv[ndigits];
> +       u64 priv[ECC_MAX_DIGITS];
>         const struct ecc_curve *curve = ecc_get_curve(curve_id);
>
> -       if (!private_key || !curve) {
> +       if (!private_key || !curve || ndigits > ARRAY_SIZE(priv)) {
>                 ret = -EINVAL;
>                 goto out;
>         }
> @@ -1025,30 +1025,25 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
>  {
>         int ret = 0;
>         struct ecc_point *product, *pk;
> -       u64 *priv, *rand_z;
> +       u64 priv[ECC_MAX_DIGITS];
> +       u64 rand_z[ECC_MAX_DIGITS];
> +       unsigned int nbytes;
>         const struct ecc_curve *curve = ecc_get_curve(curve_id);
>
> -       if (!private_key || !public_key || !curve) {
> +       if (!private_key || !public_key || !curve ||
> +           ndigits > ARRAY_SIZE(priv) || ndigits > ARRAY_SIZE(rand_z)) {
>                 ret = -EINVAL;
>                 goto out;
>         }
>
> -       priv = kmalloc_array(ndigits, sizeof(*priv), GFP_KERNEL);
> -       if (!priv) {
> -               ret = -ENOMEM;
> -               goto out;
> -       }
> +       nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
>
> -       rand_z = kmalloc_array(ndigits, sizeof(*rand_z), GFP_KERNEL);
> -       if (!rand_z) {
> -               ret = -ENOMEM;
> -               goto kfree_out;
> -       }
> +       get_random_bytes(rand_z, nbytes);
>
>         pk = ecc_alloc_point(ndigits);
>         if (!pk) {
>                 ret = -ENOMEM;
> -               goto kfree_out;
> +               goto out;
>         }
>
>         product = ecc_alloc_point(ndigits);
> @@ -1057,8 +1052,6 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
>                 goto err_alloc_product;
>         }
>
> -       get_random_bytes(rand_z, ndigits << ECC_DIGITS_TO_BYTES_SHIFT);
> -
>         ecc_swap_digits(public_key, pk->x, ndigits);
>         ecc_swap_digits(&public_key[ndigits], pk->y, ndigits);
>         ecc_swap_digits(private_key, priv, ndigits);
> @@ -1073,9 +1066,6 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
>         ecc_free_point(product);
>  err_alloc_product:
>         ecc_free_point(pk);
> -kfree_out:
> -       kzfree(priv);
> -       kzfree(rand_z);
>  out:
>         return ret;
>  }
> diff --git a/crypto/ecc.h b/crypto/ecc.h
> index e4fd4492c765..f75a86baa3bd 100644
> --- a/crypto/ecc.h
> +++ b/crypto/ecc.h
> @@ -26,7 +26,9 @@
>  #ifndef _CRYPTO_ECC_H
>  #define _CRYPTO_ECC_H
>
> -#define ECC_MAX_DIGITS 4 /* 256 */
> +#define ECC_CURVE_NIST_P192_DIGITS  3
> +#define ECC_CURVE_NIST_P256_DIGITS  4
> +#define ECC_MAX_DIGITS              ECC_CURVE_NIST_P256_DIGITS
>
>  #define ECC_DIGITS_TO_BYTES_SHIFT 3
>
> diff --git a/crypto/ecdh.c b/crypto/ecdh.c
> index 3aca0933ec44..3f91ef13c8c6 100644
> --- a/crypto/ecdh.c
> +++ b/crypto/ecdh.c
> @@ -30,8 +30,8 @@ static inline struct ecdh_ctx *ecdh_get_ctx(struct crypto_kpp *tfm)
>  static unsigned int ecdh_supported_curve(unsigned int curve_id)
>  {
>         switch (curve_id) {
> -       case ECC_CURVE_NIST_P192: return 3;
> -       case ECC_CURVE_NIST_P256: return 4;
> +       case ECC_CURVE_NIST_P192: return ECC_CURVE_NIST_P192_DIGITS;
> +       case ECC_CURVE_NIST_P256: return ECC_CURVE_NIST_P256_DIGITS;
>         default: return 0;
>         }
>  }
> --
> 2.7.4
>
>
> --
> Kees Cook
> Pixel Security



-- 
Kees Cook
Pixel Security
