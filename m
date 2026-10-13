Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DEC390CB7
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 10:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791886457; cv=none; b=ILxCgdiugZXtFNwtqWIEqfWUA1ldwMZ5FvP2G3VruWFVpmpoM049OXe4oTBYhUO6I++F5/DSgOFHxPikoQkwbCeWZ4kr5a8QlSjsS7SC6UTsMIgOyunRB9FQQ1AtTTOGURf4PeH93v5psXKnoDjDDX1GBFb2PLcZTIHb2BGl778=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791886457; c=relaxed/simple;
	bh=bvnWjWvcYjbqKTHy3U6rxaAwO/KqWhwFkRtEurvm7ME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CJpbWUJoXRx7A8daNVmm4/FvD1NvGIgSXWSl770ql+wTIKakHts5xv7nDURhavk+pCB8h+516WwmM2tRkgMRkPiGv9nwoN6ufz8avI+cUiTj8H850suQ2i1GdD2YhQcesZj7r5TOmYUYVshP7d/jaQl/GVsDz4p7/skGi7iIOIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6acba4bf65eso3595914a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 03:14:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791886452; x=1792491252;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A9UifpQToPnSQL5L15pyILWK8eaMNyuWp/jvD5hkneg=;
        b=rCx3WlvoxDjhZ0MkCweTpQZYRwhtMeMV7rMWYctHZZwlwNL82i4r0KGDWWB/mSUSiV
         nUlVZrdZ9XLdIR6XP+HxHbc+8gUaA9SOIH//rdvfwFB6GgKtuWokRGyWeQHItjQxD5/G
         ETLEes/9fp0+UNv7rOsqzbtpd3m5B7F6qdfmX2eLrar624YnyBNwEC9B75u5cLkpmFOJ
         JvIpUbiTnL+rJtbG9LRMm7y69KFDrEmFDtlqoPI3zusYjNnxyKtsMBksAM+sGnmLdZAF
         jiwoSwbdfpl4WEKjwzhhl91HBZph5FVVr4cADEt2zF3j0Xw3BdBLUHC0WNIyjbQ6yXVs
         S41A==
X-Gm-Message-State: AFq9FYLpH+QWb3aPsczEVeDKZnVl7FLWyo2NtXJPGk5UNR0aMjyPnF1M
	owB0Rz9UaZHJSzS0SnsvWB0JwITI78b4hAlI5KMp11gGEF93D6xEisa4rR4VqXfOaYQ=
X-Gm-Gg: AYBFou19SoGLM5eyIugGXhs8zn2ZzOwR9gPFjo9mrgQ04HUcEsZuq0IZqvI3Igbd83Y
	qErZtTRIDJM9bmouO5PuRDiZ9TkWufI2orhcSG5oYqBtPEpa0KvlvBt8ZE7ZABO9czx8Uj7QFDW
	1GHafdfs6xI4nvop8ufiqIYJJR6QgLROHjyatZ1t+15BA6fxLLw8XdqbA4aYvOK0RBgUDEQ8A+J
	QyaR83n0umqhpx/0b8yz1fLgKDtdALiswH9/GPUVstyRKsMM2h9lt8fXSfNMBrIpdk6gElUioLe
	znJfgfMqGK5lFPqZUpSQuuHpKea2Ok5h+jFRt72cp1zti9HPjJkWgHRxi1chC+5YLm5kkeZd+hp
	ozbrWh1hJFcefcDO9ySelU70IPttmok6bukWldwLLr6M9Y8MEqJeCc38S7yjS7P89pyXZ7GU32O
	LOBQis7l0q+nDpoe57ZbgL4lZkvRGDtuiBlnz4Ag7RATz09HgR9bDhT3R1uvQ7fn0LmRjfyC022
	ReOEOyIS0HdAfyGdKhqZlXw6woCow==
X-Received: by 2002:a05:6402:a0d3:b0:6b1:c49c:c0d with SMTP id 4fb4d7f45d1cf-6b1c49c109fmr3470196a12.27.1791886451294;
        Tue, 13 Oct 2026 03:14:11 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b1b173eb99sm2979208a12.6.2026.10.13.03.14.10
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 03:14:10 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c315a445752so423407866b.3
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 03:14:10 -0700 (PDT)
X-Received: by 2002:a17:907:3d89:b0:c2e:32a4:f516 with SMTP id
 a640c23a62f3a-c31a9fc0b65mr1192782066b.42.1791886450434; Tue, 13 Oct 2026
 03:14:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928042641.307683-1-pawliczekerwin@gmail.com>
In-Reply-To: <20260928042641.307683-1-pawliczekerwin@gmail.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Tue, 13 Oct 2026 11:13:58 +0100
X-Gmail-Original-Message-ID: <CAOs+rJWha5yvonRUG75Op5bckkUjeMqZP2cjTKNnv-HH594vyg@mail.gmail.com>
X-Gm-Features: AclHuK-fOMkCfT3bRAmWVHEoJ_PnQ_rDVYTDZOCE5Sw3jBmb988JK8uMjKF2_Ro
Message-ID: <CAOs+rJWha5yvonRUG75Op5bckkUjeMqZP2cjTKNnv-HH594vyg@mail.gmail.com>
Subject: Re: [PATCH] crypto: ecc - Use constant-time modular inversion in ecc_point_mult()
To: Erwin Pawliczek <pawliczekerwin@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Lukas Wunner <lukas@wunner.de>, Stefan Berger <stefanb@linux.ibm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Paul Louvel <paul.louvel@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 5:27=E2=80=AFAM Erwin Pawliczek
<pawliczekerwin@gmail.com> wrote:
>
> vli_mod_inv() is a binary extended Euclidean algorithm whose branches
> and iteration count depend on the input. ecc_point_mult() uses it to
> invert the projective Z coordinate, which depends on the secret scalar,
> so ECDH leaks information about the private key through its running
> time.

It seems crypto_ecdh_shared_secret() "blinds" the computation with the
random z, so the only "leaking" path is
crypto_kpp_generate_public_key()

> Reimplement it with the Bernstein-Yang divstep algorithm ("Fast
> constant-time gcd computation and modular inversion", 2019,

Given the above, wouldn't it be easier (and potentially faster) to
just "blind" crypto_kpp_generate_public_key() as well?

> https://eprint.iacr.org/2019/266), and keep the old code as
> vli_mod_inv_vartime(). Only ecc_point_mult() uses the constant-time
> vli_mod_inv(). Signature verification now uses vli_mod_inv_vartime()
> because its inputs are public: the s^-1 inversion in ecdsa.c, the
> inversion in ecrdsa.c, and ecc_point_mult_shamir() and ecc_point_add(),
> which only they call.
>
> Carries and borrows are computed with bitwise operations rather than
> add_carry()/sub_borrow() and vli_sub(), because on i386 gcc lowers
> 64-bit carry arithmetic to adcl; jc, which branches on secret carries.
> Masks derived from secret data go through OPTIMIZER_HIDE_VAR() so the
> compiler cannot turn a masked select back into a branch.
>
> Add KUnit tests for both functions: known answers, edge cases and
> pseudo-random inputs modulo p and n of the NIST P-192/256/384/521 and
> EC-RDSA GOST curves, plus a cross-check that vli_mod_inv() and
> vli_mod_inv_vartime() return identical results on the random inputs.
> The ecdh-nist-p192/p256/p384, ecdsa and ecrdsa self-tests pass.
>
> ECDH is slower, measured in a KVM guest on an i7-1165G7 (median over
> 4 boots of the best of 9 runs of 300 calls):
>
>   crypto_ecdh_shared_secret()   (one inversion mod p)
>     P-256:  386.9 us ->  440.9 us  (+13.9%)
>     P-384:  841.9 us ->  945.9 us  (+12.4%)

Given my comments above I don't think it is a good benchmark as it
benchmarks a path that is not "leaking" anyway. Can we re-measure the
leaking path and compare it to simple blinding?

> Verify paths are unchanged.
>
> The co-Z Montgomery ladder in ecc_point_mult() is still susceptible to
> timing attacks, as noted in commit c64ba13e2033 ("crypto: ecc -
> Unbreak the build on arm with CONFIG_KASAN_STACK=3Dy"), so this closes
> only the leak through the inversion. With arm allmodconfig and gcc
> 15.2, vli_mod_inv() grows from 696 to 864 bytes and no caller's frame

Is this the stack or the code size?

> changes: vli_mod_inv() is not inlined, so ecc_point_mult() stays at
> 1408 bytes.
>
> Signed-off-by: Erwin Pawliczek <pawliczekerwin@gmail.com>
> ---
>  crypto/Kconfig                |  13 +
>  crypto/Makefile               |   1 +
>  crypto/ecc.c                  | 243 +++++++++++++++-
>  crypto/ecc_kunit.c            | 649 ++++++++++++++++++++++++++++++++++++=
++++++
>  crypto/ecdsa.c                |   2 +-
>  crypto/ecrdsa.c               |   2 +-
>  include/crypto/internal/ecc.h |  20 +-
>  7 files changed, 923 insertions(+), 7 deletions(-)
>  create mode 100644 crypto/ecc_kunit.c
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 981d5dc422d4c89c743b5724aeacd6aa5120c009..f0f44a8f40acd504e643f3a01=
a6c277650b0cce2 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -307,6 +307,19 @@ config CRYPTO_DH_RFC7919_GROUPS
>  config CRYPTO_ECC
>         tristate
>
> +config CRYPTO_ECC_KUNIT_TEST
> +       tristate "KUnit tests for ECC modular inversion" if !KUNIT_ALL_TE=
STS
> +       depends on KUNIT && CRYPTO_ECC
> +       default KUNIT_ALL_TESTS
> +       help
> +         KUnit tests for vli_mod_inv() and vli_mod_inv_vartime(), the
> +         constant-time and variable-time modular inversions in crypto/ec=
c.c.
> +         Checks known answers, edge cases and pseudo-random inputs modul=
o the
> +         field primes and group orders of the NIST P-192/256/384/521 and
> +         EC-RDSA GOST curves, and that both functions agree.
> +
> +         If unsure, say N.
> +
>  config CRYPTO_ECDH
>         tristate "ECDH (Elliptic Curve Diffie-Hellman)"
>         select CRYPTO_ECC
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 8386d55a9755e7675e42adbbde8ca3dcd45ff369..89508c7fd477e0fd76ba24ec4=
da91e8ae2e8b861 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -172,6 +172,7 @@ obj-$(CONFIG_CRYPTO_USER_API_RNG) +=3D algif_rng.o
>  obj-$(CONFIG_CRYPTO_USER_API_AEAD) +=3D algif_aead.o
>  obj-$(CONFIG_CRYPTO_ZSTD) +=3D zstd.o
>  obj-$(CONFIG_CRYPTO_ECC) +=3D ecc.o
> +obj-$(CONFIG_CRYPTO_ECC_KUNIT_TEST) +=3D ecc_kunit.o
>  obj-$(CONFIG_CRYPTO_ESSIV) +=3D essiv.o
>
>  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D124949
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index 3250a464b8523aa86b525cded939f5d70b20b024..5789295a09691233ab08828a7=
bd385b43c9f435f 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -1057,9 +1057,12 @@ static void vli_mod_square_fast(u64 *result, const=
 u64 *left,
>  /* Computes result =3D (1 / p_input) % mod. All VLIs are the same size.
>   * See "From Euclid's GCD to Montgomery Multiplication to the Great Divi=
de"
>   * https://labs.oracle.com/techrep/2001/smli_tr-2001-95.pdf
> + *
> + * Not constant-time: the branches and the iteration count depend on inp=
ut.
> + * Only for public inputs, such as in signature verification.
>   */
> -void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
> -                       unsigned int ndigits)
> +void vli_mod_inv_vartime(u64 *result, const u64 *input, const u64 *mod,
> +                        unsigned int ndigits)
>  {
>         u64 a[ECC_MAX_DIGITS], b[ECC_MAX_DIGITS];
>         u64 u[ECC_MAX_DIGITS], v[ECC_MAX_DIGITS];
> @@ -1131,6 +1134,238 @@ void vli_mod_inv(u64 *result, const u64 *input, c=
onst u64 *mod,
>
>         vli_set(result, u, ndigits);
>  }
> +EXPORT_SYMBOL(vli_mod_inv_vartime);
> +
> +/* f and g are signed and need one extra word beyond ndigits. */
> +#define SAFEGCD_MAX_WORDS (ECC_MAX_DIGITS + 1)
> +
> +/*
> + * Carries and borrows are computed from the top bits with plain bitwise
> + * operations. Comparisons such as (sum < b), and the add_carry() and
> + * sub_borrow() helpers above, compile to conditional jumps on 32-bit
> + * targets, where a u64 is two registers, and would leak the carry: gcc
> + * lowers even __builtin_addcll() to addl; adcl; jc on i386.
> + *
> + * Every all-zeros/all-ones mask derived from secret data goes through
> + * OPTIMIZER_HIDE_VAR(): otherwise the compiler may notice that the mask
> + * has only two values and turn (x & mask) | (y & ~mask) back into a
> + * branch (gcc does this for i386).
> + */
> +
> +/* r =3D a + (b & mask), returns carry */
> +static u64 safegcd_add_masked(u64 *r, const u64 *a, const u64 *b, u64 ma=
sk,
> +                             unsigned int n)
> +{
> +       u64 carry =3D 0;
> +       unsigned int i;
> +
> +       for (i =3D 0; i < n; i++) {
> +               u64 x =3D a[i], y =3D b[i] & mask;
> +               u64 sum =3D x + y + carry;
> +
> +               carry =3D ((x & y) | ((x | y) & ~sum)) >> 63;
> +               r[i] =3D sum;
> +       }
> +
> +       return carry;
> +}
> +
> +/* r =3D a - b, returns borrow */
> +static u64 safegcd_sub(u64 *r, const u64 *a, const u64 *b, unsigned int =
n)
> +{
> +       u64 borrow =3D 0;
> +       unsigned int i;
> +
> +       for (i =3D 0; i < n; i++) {
> +               u64 x =3D a[i], y =3D b[i];
> +               u64 diff =3D x - y - borrow;
> +
> +               borrow =3D ((~x & y) | (~(x ^ y) & diff)) >> 63;
> +               r[i] =3D diff;
> +       }
> +
> +       return borrow;
> +}
> +
> +/* Swap a and b if mask is all ones, do nothing if mask is 0. */
> +static void safegcd_cswap(u64 *a, u64 *b, u64 mask, unsigned int n)
> +{
> +       unsigned int i;
> +
> +       for (i =3D 0; i < n; i++) {
> +               u64 t =3D (a[i] ^ b[i]) & mask;
> +
> +               a[i] ^=3D t;
> +               b[i] ^=3D t;
> +       }
> +}
> +
> +/* Two's complement negate a if mask is all ones. */
> +static void safegcd_cneg(u64 *a, u64 mask, unsigned int n)
> +{
> +       u64 carry =3D mask & 1;
> +       unsigned int i;
> +
> +       for (i =3D 0; i < n; i++) {
> +               u64 x =3D a[i] ^ mask;
> +               u64 t =3D x + carry;
> +
> +               carry =3D (x & ~t) >> 63;
> +               a[i] =3D t;
> +       }
> +}
> +
> +/* Arithmetic (sign-preserving) shift right by one. */
> +static void safegcd_sar1(u64 *a, unsigned int n)
> +{
> +       unsigned int i;
> +
> +       for (i =3D 0; i < n - 1; i++)
> +               a[i] =3D (a[i] >> 1) | (a[i + 1] << 63);
> +       a[n - 1] =3D (u64)((s64)a[n - 1] >> 1);
> +}
> +
> +/* r =3D t modulo mod, for t + carry * 2^(64 * ndigits) in [0, 2 * mod).=
 */
> +static void safegcd_mod_reduce(u64 *r, const u64 *t, u64 carry,
> +                              const u64 *mod, unsigned int ndigits)
> +{
> +       u64 s[ECC_MAX_DIGITS];
> +       u64 borrow =3D safegcd_sub(s, t, mod, ndigits);
> +       u64 mask =3D -(carry | (borrow ^ 1));
> +       unsigned int i;
> +
> +       OPTIMIZER_HIDE_VAR(mask);
> +       for (i =3D 0; i < ndigits; i++)
> +               r[i] =3D (s[i] & mask) | (t[i] & ~mask);
> +}
> +
> +/* a =3D (a + (b & mask)) modulo mod */
> +static void safegcd_mod_add_masked(u64 *a, const u64 *b, u64 mask,
> +                                  const u64 *mod, unsigned int ndigits)
> +{
> +       u64 t[ECC_MAX_DIGITS];
> +       u64 carry =3D safegcd_add_masked(t, a, b, mask, ndigits);
> +
> +       safegcd_mod_reduce(a, t, carry, mod, ndigits);
> +}
> +
> +/* a =3D -a modulo mod if mask is all ones. */
> +static void safegcd_mod_cneg(u64 *a, u64 mask, const u64 *mod,
> +                            unsigned int ndigits)
> +{
> +       u64 t[ECC_MAX_DIGITS];
> +       unsigned int i;
> +
> +       safegcd_sub(t, mod, a, ndigits);        /* in (0, mod] */
> +       for (i =3D 0; i < ndigits; i++)
> +               t[i] =3D (t[i] & mask) | (a[i] & ~mask);
> +       /* maps mod to 0 when a =3D=3D 0 */
> +       safegcd_mod_reduce(a, t, 0, mod, ndigits);
> +}
> +
> +/* a =3D a / 2 modulo mod */
> +static void safegcd_mod_half(u64 *a, const u64 *mod, unsigned int ndigit=
s)
> +{
> +       u64 odd =3D -(a[0] & 1);
> +       u64 carry;
> +       unsigned int i;
> +
> +       OPTIMIZER_HIDE_VAR(odd);
> +       carry =3D safegcd_add_masked(a, a, mod, odd, ndigits);
> +
> +       for (i =3D 0; i < ndigits - 1; i++)
> +               a[i] =3D (a[i] >> 1) | (a[i + 1] << 63);
> +       a[ndigits - 1] =3D (a[ndigits - 1] >> 1) | (carry << 63);
> +}
> +
> +/*
> + * Computes result =3D (1 / input) % mod in constant time, using Bernste=
in-Yang
> + * division steps (simple version: one divstep per iteration):
> + * https://gcd.cr.yp.to
> + *
> + * divstep(delta, f, g) =3D
> + *   (1 - delta, g, (g - f) / 2)          if delta > 0 and g odd;
> + *   (1 + delta, f, (g + (g mod 2)f) / 2) otherwise.
> + *
> + * Starting from (1, mod, input), Theorem 11.2 guarantees that after
> + * m =3D iterations(d) steps g =3D 0 and f =3D +-gcd(mod, input) =3D +-1=
.
> + *
> + * recip2 (Figure 11.1) tracks the transition matrix with denominators 2=
^(m-1)
> + * and divides by 2^(m-1) modulo mod at the end. Here the halving is ins=
tead
> + * done modulo mod at every step: vf, vg are kept in [0, mod) such that
> + * f =3D=3D vf * input and g =3D=3D vg * input (modulo mod). At the end =
f =3D +-1, so
> + * input^-1 =3D +-vf.
> + *
> + * Every iteration runs the same instructions: both divstep cases are me=
rged
> + * into masked operations, and the iteration count depends only on ndigi=
ts.
> + * mod must be odd. Returns 0 if input is 0.
> + */
> +void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
> +                unsigned int ndigits)
> +{
> +       u64 f[SAFEGCD_MAX_WORDS], g[SAFEGCD_MAX_WORDS];
> +       u64 vf[ECC_MAX_DIGITS], vg[ECC_MAX_DIGITS];
> +       const unsigned int nw =3D ndigits + 1;
> +       const unsigned int d =3D ndigits * 64;
> +       const unsigned int m =3D (49 * d + 57) / 17; /* iterations(d), d =
>=3D 46 */

If we do d =3D vli_num_bits(mod) we can do noticeably less iterations for P=
-521

> +       s64 delta =3D 1;
> +       unsigned int i;
> +       u64 neg;
> +
> +       /*
> +        * The divstep algorithm needs f =3D mod odd: g + (g mod 2) f mus=
t be
> +        * even, and the halvings modulo mod need 2 to be invertible. mod=
 is a
> +        * public curve parameter (p or n), so branching on it leaks noth=
ing.
> +        */
> +       if (WARN_ON_ONCE(!(mod[0] & 1))) {

Do we need the same check in the _vartime variant for symmetry?

> +               vli_clear(result, ndigits);
> +               return;
> +       }
> +
> +       vli_set(f, mod, ndigits);
> +       f[ndigits] =3D 0;
> +       vli_set(g, input, ndigits);
> +       g[ndigits] =3D 0;
> +       vli_clear(vf, ndigits);
> +       vli_clear(vg, ndigits);
> +       vg[0] =3D 1;
> +
> +       for (i =3D 0; i < m; i++) {
> +               /* all ones iff delta > 0 and g is odd */
> +               u64 swap =3D (u64)(-delta >> 63) & -(g[0] & 1);
> +               u64 g0;
> +
> +               OPTIMIZER_HIDE_VAR(swap);
> +
> +               /*
> +                * First case: (delta, f, g) <- (-delta, g, -f), after wh=
ich
> +                * both cases are the same step with g odd.
> +                */
> +               delta =3D (delta ^ (s64)swap) - (s64)swap;
> +               safegcd_cswap(f, g, swap, nw);
> +               safegcd_cneg(g, swap, nw);
> +               safegcd_cswap(vf, vg, swap, ndigits);
> +               safegcd_mod_cneg(vg, swap, mod, ndigits);
> +
> +               /* (delta, g) <- (1 + delta, (g + (g mod 2) f) / 2) */
> +               g0 =3D -(g[0] & 1);
> +               OPTIMIZER_HIDE_VAR(g0);
> +               safegcd_add_masked(g, g, f, g0, nw);
> +               safegcd_sar1(g, nw);
> +               safegcd_mod_add_masked(vg, vf, g0, mod, ndigits);
> +               safegcd_mod_half(vg, mod, ndigits);
> +               delta++;
> +       }
> +
> +       /*
> +        * input =3D=3D 0 is intentionally not special-cased: g starts at=
 0,
> +        * vf stays 0, and the fixed iteration count returns 0.
> +        */
> +       neg =3D -(f[nw - 1] >> 63);
> +       OPTIMIZER_HIDE_VAR(neg);
> +       safegcd_mod_cneg(vf, neg, mod, ndigits);
> +       vli_set(result, vf, ndigits);
> +}
>  EXPORT_SYMBOL(vli_mod_inv);
>
>  /* ------ Point operations ------ */
> @@ -1426,7 +1661,7 @@ static void ecc_point_add(const struct ecc_point *r=
esult,
>         vli_set(px, p->x, ndigits);
>         vli_set(py, p->y, ndigits);
>         xycz_add(px, py, result->x, result->y, curve);
> -       vli_mod_inv(z, z, curve->p, ndigits);
> +       vli_mod_inv_vartime(z, z, curve->p, ndigits);
>         apply_z(result->x, result->y, z, curve);
>  }
>
> @@ -1485,7 +1720,7 @@ void ecc_point_mult_shamir(const struct ecc_point *=
result,
>                         vli_mod_mult_fast(z, z, tz, curve);
>                 }
>         }
> -       vli_mod_inv(z, z, curve->p, ndigits);
> +       vli_mod_inv_vartime(z, z, curve->p, ndigits);
>         apply_z(rx, ry, z, curve);
>  }
>  EXPORT_SYMBOL(ecc_point_mult_shamir);
> diff --git a/crypto/ecc_kunit.c b/crypto/ecc_kunit.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..ddc6ca93df20b3e7ba2bfe891=
1ba5d120c33f3ed
> --- /dev/null
> +++ b/crypto/ecc_kunit.c
> @@ -0,0 +1,649 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * KUnit tests for vli_mod_inv() and vli_mod_inv_vartime() in crypto/ecc=
.c.
> + *
> + * Both inverses are checked against known answers computed independentl=
y
> + * (Python pow(x, -1, m)) and, on pseudo-random inputs, against the
> + * defining property: result < m and input * result =3D=3D 1 (mod m), us=
ing
> + * vli_mod_mult_slow(). On the same random inputs the two functions must
> + * also return identical results. Every curve the kernel inverts
> + * over is covered (NIST P-192/256/384/521 and the EC-RDSA GOST curves),
> + * each with both its field prime p and its group order n, since callers
> + * invert modulo both.
> + */
> +#include <kunit/test.h>
> +#include <linux/module.h>
> +#include <crypto/ecc_curve.h>
> +#include <crypto/ecdh.h>
> +#include <crypto/internal/ecc.h>
> +
> +#include "ecrdsa_defs.h"
> +
> +struct ecc_inv_modulus {
> +       const char *name;
> +       unsigned int curve_id;                  /* NIST: via ecc_get_curv=
e() */
> +       const struct ecc_curve *curve;          /* GOST: from ecrdsa_defs=
.h */
> +       bool use_n;
> +};
> +
> +static const struct ecc_inv_modulus ecc_inv_moduli[] =3D {
> +       { .name =3D "P-192 p", .curve_id =3D ECC_CURVE_NIST_P192, .use_n =
=3D false },
> +       { .name =3D "P-192 n", .curve_id =3D ECC_CURVE_NIST_P192, .use_n =
=3D true },
> +       { .name =3D "P-256 p", .curve_id =3D ECC_CURVE_NIST_P256, .use_n =
=3D false },
> +       { .name =3D "P-256 n", .curve_id =3D ECC_CURVE_NIST_P256, .use_n =
=3D true },
> +       { .name =3D "P-384 p", .curve_id =3D ECC_CURVE_NIST_P384, .use_n =
=3D false },
> +       { .name =3D "P-384 n", .curve_id =3D ECC_CURVE_NIST_P384, .use_n =
=3D true },
> +       { .name =3D "P-521 p", .curve_id =3D ECC_CURVE_NIST_P521, .use_n =
=3D false },
> +       { .name =3D "P-521 n", .curve_id =3D ECC_CURVE_NIST_P521, .use_n =
=3D true },
> +       { .name =3D "cp256a p", .curve =3D &gost_cp256a, .use_n =3D false=
 },
> +       { .name =3D "cp256a n", .curve =3D &gost_cp256a, .use_n =3D true =
},
> +       { .name =3D "cp256b p", .curve =3D &gost_cp256b, .use_n =3D false=
 },
> +       { .name =3D "cp256b n", .curve =3D &gost_cp256b, .use_n =3D true =
},
> +       { .name =3D "cp256c p", .curve =3D &gost_cp256c, .use_n =3D false=
 },
> +       { .name =3D "cp256c n", .curve =3D &gost_cp256c, .use_n =3D true =
},
> +       { .name =3D "tc512a p", .curve =3D &gost_tc512a, .use_n =3D false=
 },
> +       { .name =3D "tc512a n", .curve =3D &gost_tc512a, .use_n =3D true =
},
> +       { .name =3D "tc512b p", .curve =3D &gost_tc512b, .use_n =3D false=
 },
> +       { .name =3D "tc512b n", .curve =3D &gost_tc512b, .use_n =3D true =
},
> +};
> +
> +static void ecc_inv_modulus_desc(const struct ecc_inv_modulus *m, char *=
desc)
> +{
> +       strscpy(desc, m->name, KUNIT_PARAM_DESC_SIZE);
> +}
> +
> +KUNIT_ARRAY_PARAM(ecc_inv_modulus, ecc_inv_moduli, ecc_inv_modulus_desc)=
;
> +
> +struct ecc_inv_kat {
> +       struct ecc_inv_modulus mod;
> +       unsigned int ndigits;
> +       u64 input[ECC_MAX_DIGITS];
> +       u64 expected[ECC_MAX_DIGITS];
> +};
> +
> +/*
> + * Generated with Python: x =3D SHA-512 chain of "<curve>-<p|n>-<i>" mod=
 m,
> + * expected =3D pow(x, -1, m). Digits are little-endian, as in struct ec=
c_curve.
> + */
> +static const struct ecc_inv_kat ecc_inv_kats[] =3D {
> +       {
> +               .mod =3D { .name =3D "P-192 p", .curve_id =3D ECC_CURVE_N=
IST_P192, .use_n =3D false },
> +               .ndigits =3D 3,
> +               .input =3D {
> +                       0x41313653ac057a56ull, 0x142ad830dbd13605ull, 0x0=
7dd616c2ad122beull,
> +               },
> +               .expected =3D {
> +                       0x84bb5ade94eeb5b5ull, 0x46ef882aacf5d705ull, 0x0=
b000ae2c4bb67d6ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-192 p", .curve_id =3D ECC_CURVE_N=
IST_P192, .use_n =3D false },
> +               .ndigits =3D 3,
> +               .input =3D {
> +                       0x801f93867c016edcull, 0xdc98f8a5b189dab0ull, 0xf=
fd6dbecbdc4bbc9ull,
> +               },
> +               .expected =3D {
> +                       0xef3b383f106b7746ull, 0x85a8c58c171b5df6ull, 0x2=
d43b03097118689ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-192 n", .curve_id =3D ECC_CURVE_N=
IST_P192, .use_n =3D true },
> +               .ndigits =3D 3,
> +               .input =3D {
> +                       0xf75b1dbef5d78baeull, 0xf870edc7e8b09ff8ull, 0xd=
8e08a0e05d1a0e7ull,
> +               },
> +               .expected =3D {
> +                       0xefac57e6f41e6b20ull, 0x90b13c8947aa298cull, 0xb=
99981827d0a2869ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-192 n", .curve_id =3D ECC_CURVE_N=
IST_P192, .use_n =3D true },
> +               .ndigits =3D 3,
> +               .input =3D {
> +                       0xe04864a7f2b13e4aull, 0xb19e8eefd67f383dull, 0x0=
2392ce4c1b41af8ull,
> +               },
> +               .expected =3D {
> +                       0x4d5ab0715ac0b581ull, 0x19fbdf76ccb7672dull, 0xd=
e00822edb6c4aeeull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-256 p", .curve_id =3D ECC_CURVE_N=
IST_P256, .use_n =3D false },
> +               .ndigits =3D 4,
> +               .input =3D {
> +                       0x6523829b0916044eull, 0x2e193a0987e6bf6bull, 0x5=
1e4b9a3938c4315ull,
> +                       0x053a04db5842fd37ull,
> +               },
> +               .expected =3D {
> +                       0x9ea9af8228b3f038ull, 0x66d8326c69e2efe1ull, 0x5=
10d33574ebe713eull,
> +                       0xd8144a3619342c58ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-256 p", .curve_id =3D ECC_CURVE_N=
IST_P256, .use_n =3D false },
> +               .ndigits =3D 4,
> +               .input =3D {
> +                       0xb37a68cd765ed66bull, 0xe8478b255a12858full, 0xd=
663ea1ff33742ddull,
> +                       0x1eb3bb07b3ac4965ull,
> +               },
> +               .expected =3D {
> +                       0xe3d1e8b0199a81f4ull, 0xd9cca403117232f0ull, 0xa=
f08dad13e21db23ull,
> +                       0xb2bc323643233ad8ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-256 n", .curve_id =3D ECC_CURVE_N=
IST_P256, .use_n =3D true },
> +               .ndigits =3D 4,
> +               .input =3D {
> +                       0xb67b047433438c5dull, 0xf4d3083f61d00519ull, 0x1=
eae1feca40dbffdull,
> +                       0xc08a2a127a22dcceull,
> +               },
> +               .expected =3D {
> +                       0x1a0946355ba9e712ull, 0x0b9ec57ebaab9841ull, 0x7=
243b59b0b7a1415ull,
> +                       0xbcff341c41c4f8a2ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-256 n", .curve_id =3D ECC_CURVE_N=
IST_P256, .use_n =3D true },
> +               .ndigits =3D 4,
> +               .input =3D {
> +                       0x4ff817671e33c11dull, 0x70f52cf5b3c60a75ull, 0x2=
e183e2bd91aa794ull,
> +                       0x5a2df728a230d128ull,
> +               },
> +               .expected =3D {
> +                       0x6842c388fe2f459eull, 0xf55bd97184c14cb2ull, 0x4=
7887f23f851a1afull,
> +                       0x6ddc4e41cde65424ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-384 p", .curve_id =3D ECC_CURVE_N=
IST_P384, .use_n =3D false },
> +               .ndigits =3D 6,
> +               .input =3D {
> +                       0x554861bdb82c178aull, 0xa3638d45b5944a2dull, 0xb=
3bd1d4d3f2e7a70ull,
> +                       0xdc949a2d25b48b08ull, 0x19baf1456da730f6ull, 0x7=
9cf2a740d2f0adbull,
> +               },
> +               .expected =3D {
> +                       0x5a98128c62eb9d11ull, 0x18e88df918b0ba21ull, 0x2=
90c2fa3cfa1bed5ull,
> +                       0x2382832c078eb462ull, 0x234af0afe619e114ull, 0xa=
06a10817512fa6cull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-384 p", .curve_id =3D ECC_CURVE_N=
IST_P384, .use_n =3D false },
> +               .ndigits =3D 6,
> +               .input =3D {
> +                       0x9ead6afd53dfd523ull, 0x10ade5f72542cdf4ull, 0xa=
bd8ea28db92dadaull,
> +                       0xc2fe7fb39c0a7dcbull, 0xa42858e6f3307f17ull, 0x3=
ce3fcf71b8662f5ull,
> +               },
> +               .expected =3D {
> +                       0xfeb06845d2eb47d7ull, 0x28da3e2e76e99411ull, 0x7=
d3928538ea380beull,
> +                       0x5faab5ea6d9003b8ull, 0x44bbcdae98ef6a9cull, 0x5=
71db71a9d6b76eeull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-384 n", .curve_id =3D ECC_CURVE_N=
IST_P384, .use_n =3D true },
> +               .ndigits =3D 6,
> +               .input =3D {
> +                       0x2d87faf0ccdf628eull, 0x714f7dcce7709b5dull, 0xa=
2d9d8b6a9b0a488ull,
> +                       0xed17e4e3600ce413ull, 0xc5b3933f9bb3e175ull, 0xb=
ad9656902ab3e9cull,
> +               },
> +               .expected =3D {
> +                       0x282ff4779f1c28d9ull, 0x4dc1a142880fe0a1ull, 0x2=
3c24cfe518ffe6cull,
> +                       0x98c775f094739137ull, 0xb4d0d7b0d2d114c3ull, 0xb=
c370ff4dbf33e60ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-384 n", .curve_id =3D ECC_CURVE_N=
IST_P384, .use_n =3D true },
> +               .ndigits =3D 6,
> +               .input =3D {
> +                       0x094cf37530c6dd08ull, 0xaa016298335e9fcdull, 0x9=
22d00b8ea119a94ull,
> +                       0xe9d2e7151a1cecebull, 0xbde74e9f5df14560ull, 0x1=
9616e9dcb1a757full,
> +               },
> +               .expected =3D {
> +                       0x96e40db0d2da9a93ull, 0xfa98777c788840f2ull, 0x6=
26994b74b623dc6ull,
> +                       0x989991502aaba72full, 0xb9ba3491e12fc978ull, 0xc=
429548fd096bff6ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-521 p", .curve_id =3D ECC_CURVE_N=
IST_P521, .use_n =3D false },
> +               .ndigits =3D 9,
> +               .input =3D {
> +                       0xfb735cb0eef9ffe4ull, 0xe15953c16210b4efull, 0x8=
15eac8ebf15a34aull,
> +                       0xb031a75a2aac033cull, 0x5ec6c676f0ec03bbull, 0x9=
8e24304c243bb63ull,
> +                       0xefaf94401896a141ull, 0xa858d39f6733000cull, 0x0=
00000000000009eull,
> +               },
> +               .expected =3D {
> +                       0x532b10dc88cc2e4full, 0x7a7eba9110c6047aull, 0xa=
e4d8fdb3bec00d5ull,
> +                       0x51a899b79cff4936ull, 0x25b72282fb76e7abull, 0x1=
52ffb5fb46d1982ull,
> +                       0xdae635c5790a849full, 0x0d78804330949b11ull, 0x0=
0000000000000a3ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-521 p", .curve_id =3D ECC_CURVE_N=
IST_P521, .use_n =3D false },
> +               .ndigits =3D 9,
> +               .input =3D {
> +                       0x5167bd279efb7d36ull, 0x7849d064452443ccull, 0x8=
927be45e25f0c90ull,
> +                       0x02360631cecda1b2ull, 0x83badc286f1c0d4dull, 0x4=
2ad82c752a0e78aull,
> +                       0xdd91c23a7d9fcc71ull, 0x589a695382778fbbull, 0x0=
000000000000080ull,
> +               },
> +               .expected =3D {
> +                       0xeb18d4f1444562e4ull, 0xb0e29ff965b7c2deull, 0x6=
bccc776f101177aull,
> +                       0x200b46216fdf9fc6ull, 0x46cf5ef90af72440ull, 0x0=
87887ad1d884c24ull,
> +                       0x83887489b1475607ull, 0x2d26bdcf93b65023ull, 0x0=
0000000000001edull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-521 n", .curve_id =3D ECC_CURVE_N=
IST_P521, .use_n =3D true },
> +               .ndigits =3D 9,
> +               .input =3D {
> +                       0x5da4484030a6b090ull, 0x8ff0250e68bace1bull, 0xd=
39fccf7abb7df64ull,
> +                       0xded13ec201348ff4ull, 0x9db2769a87da6986ull, 0x1=
cc09104e46dc745ull,
> +                       0xd561958ad922de9dull, 0xcdb60d0a7352049cull, 0x0=
000000000000132ull,
> +               },
> +               .expected =3D {
> +                       0x36e436a0fa258cdbull, 0x1c0c1df0182e8bacull, 0xf=
656e689c42841a3ull,
> +                       0x7462a99debc322f8ull, 0x94b643e1497da6adull, 0xd=
e87ec7fa2ba4531ull,
> +                       0xec17c7b58f8c13e4ull, 0xca738a6827129987ull, 0x0=
0000000000000d4ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "P-521 n", .curve_id =3D ECC_CURVE_N=
IST_P521, .use_n =3D true },
> +               .ndigits =3D 9,
> +               .input =3D {
> +                       0xfbc0c0ff8d43c1c1ull, 0x4d2470321f931883ull, 0x4=
518344488fafd9cull,
> +                       0x29a0ab92cba1837bull, 0xc234b5931853da14ull, 0xa=
471f879bc985db8ull,
> +                       0x81f7b041d98575e6ull, 0xfcf39ec0f6bab6c0ull, 0x0=
00000000000019full,
> +               },
> +               .expected =3D {
> +                       0xea311def0d876707ull, 0x59e00ddc3f36c625ull, 0xc=
ae072b97e8cd382ull,
> +                       0xe1e4c5c146a800b0ull, 0x0e91326379cb3161ull, 0x7=
4a3f2a30648cedaull,
> +                       0x68c5005af6a36f37ull, 0x4b9499c3670ed436ull, 0x0=
000000000000040ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "cp256a p", .curve =3D &gost_cp256a,=
 .use_n =3D false },
> +               .ndigits =3D 4,
> +               .input =3D {
> +                       0xce16f84d0d63e22full, 0x6f8cbf8eae192a59ull, 0xa=
505cfaec6c1672dull,
> +                       0x322c8fd1a94154a6ull,
> +               },
> +               .expected =3D {
> +                       0x38178b63653d43bfull, 0xbc1b939b9e739f3full, 0x5=
5c236497fa605bfull,
> +                       0xe9f32f9e76727d99ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "cp256a n", .curve =3D &gost_cp256a,=
 .use_n =3D true },
> +               .ndigits =3D 4,
> +               .input =3D {
> +                       0xb759cfc60aa26e77ull, 0xbb801ed5d60e7487ull, 0x8=
820b139878976a2ull,
> +                       0x567b3983a6cf6d14ull,
> +               },
> +               .expected =3D {
> +                       0xbb5c0e2ae3d0e8c5ull, 0x1c3f15fe4e8df779ull, 0x9=
f9258178d30d15eull,
> +                       0x8ab0c3f798544f2aull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "cp256b p", .curve =3D &gost_cp256b,=
 .use_n =3D false },
> +               .ndigits =3D 4,
> +               .input =3D {
> +                       0x4e2599d52eba613bull, 0xc3d0bdc47cb41448ull, 0xc=
033051690d10415ull,
> +                       0x12436fddca16f1baull,
> +               },
> +               .expected =3D {
> +                       0xffb11f38070173f1ull, 0x861b0af46d26bc0bull, 0x3=
eb235d38f85fc06ull,
> +                       0x60151a884a64b20cull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "cp256b n", .curve =3D &gost_cp256b,=
 .use_n =3D true },
> +               .ndigits =3D 4,
> +               .input =3D {
> +                       0xe1adabe1e455c2d4ull, 0x019b5270ca17ba4aull, 0xb=
79252223323ef13ull,
> +                       0x31eabaa693675ee2ull,
> +               },
> +               .expected =3D {
> +                       0xddb432fcd0b7c0d5ull, 0xf32b97d65bbcb5acull, 0x0=
dec14de06a3d3d5ull,
> +                       0x136b3e1d8f17b062ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "cp256c p", .curve =3D &gost_cp256c,=
 .use_n =3D false },
> +               .ndigits =3D 4,
> +               .input =3D {
> +                       0x52731f91a04c0d1aull, 0x6bc2c9df3afa4640ull, 0x8=
578d8823a95f1e2ull,
> +                       0x2907b4002c9143ebull,
> +               },
> +               .expected =3D {
> +                       0xfd7e756e6bb4c542ull, 0x8688f3d1c9162e49ull, 0x3=
af990c585103c1aull,
> +                       0x946b992cb30b5077ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "cp256c n", .curve =3D &gost_cp256c,=
 .use_n =3D true },
> +               .ndigits =3D 4,
> +               .input =3D {
> +                       0x04eaefc38d0a374eull, 0x481863d4541e39c3ull, 0xd=
1ae2e53b606631eull,
> +                       0x26c4b32ff91608efull,
> +               },
> +               .expected =3D {
> +                       0x4809bcd5dc3e28a1ull, 0x6c8d12ba33e87eeaull, 0xc=
00f19f241f0bbbcull,
> +                       0x1419872f5f942363ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "tc512a p", .curve =3D &gost_tc512a,=
 .use_n =3D false },
> +               .ndigits =3D 8,
> +               .input =3D {
> +                       0x94a7a34e4ea393afull, 0xfd789a2892beb25bull, 0x0=
5411d0dcd641399ull,
> +                       0x79c05e32ce419729ull, 0x163eb6d6f1a05e9eull, 0x6=
816d9a6803c5c8cull,
> +                       0xcb8fb6c546f5e058ull, 0xb7a346fb1ef6f26dull,
> +               },
> +               .expected =3D {
> +                       0x8409998d9c8778c4ull, 0xf72a5eb92ffc2fb8ull, 0x5=
b7fc92002f0717eull,
> +                       0x90fde815d13929d3ull, 0xba9df271b0bc45daull, 0x8=
f79350c3d211faaull,
> +                       0x6821ea321fe52946ull, 0x6fdc937e1a5b664bull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "tc512a n", .curve =3D &gost_tc512a,=
 .use_n =3D true },
> +               .ndigits =3D 8,
> +               .input =3D {
> +                       0x590d69e0666574ccull, 0x5903bb1718fa22bcull, 0xa=
6b2a1f0f811f300ull,
> +                       0x4a2ae1e7a679b88dull, 0x95a0479a6072eaa7ull, 0xf=
8fa1df9a07bd49cull,
> +                       0x2682c185b082f2aaull, 0x92087713b8be218bull,
> +               },
> +               .expected =3D {
> +                       0xac1ca6f1a184d991ull, 0x3d45d71789e2594bull, 0x5=
6fcbb412e2d120aull,
> +                       0x8697b057dd9a1cacull, 0xefa889495de3f0fbull, 0x2=
3d460c98f5fa379ull,
> +                       0xf40f8636da09615bull, 0x267149ee428e9453ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "tc512b p", .curve =3D &gost_tc512b,=
 .use_n =3D false },
> +               .ndigits =3D 8,
> +               .input =3D {
> +                       0x37c146fc3154c930ull, 0x24dd35128dfb66feull, 0x7=
b848888b6033ef1ull,
> +                       0xa8946ca1631265f9ull, 0xef8cae5498c9aaebull, 0x2=
12b91ab415d30bcull,
> +                       0x9772e4c91dcc372full, 0x29ce6a4ec759b075ull,
> +               },
> +               .expected =3D {
> +                       0x05c000bf9c327561ull, 0x1693cc8097058928ull, 0xa=
77752791df33249ull,
> +                       0x66d38526e131c363ull, 0xcfd69f2df80c552aull, 0xf=
ebe86908032a1ccull,
> +                       0x7afe502f5428790dull, 0x089c6c76c856a7f5ull,
> +               },
> +       },
> +       {
> +               .mod =3D { .name =3D "tc512b n", .curve =3D &gost_tc512b,=
 .use_n =3D true },
> +               .ndigits =3D 8,
> +               .input =3D {
> +                       0x93159e666b5c2440ull, 0x7d960868dfad959dull, 0xb=
c50d2cb26e2f801ull,
> +                       0xfb30679a21a09ddfull, 0xe8af2a69a126f2d0ull, 0x9=
2f5ad20e71ac074ull,
> +                       0xfa0c47572bf1b86aull, 0x03cafc9d01211238ull,
> +               },
> +               .expected =3D {
> +                       0x94714516b8ae1b15ull, 0xd518efd90c9ffe18ull, 0xc=
7e6875e9a36458dull,
> +                       0x6597aaca768858f3ull, 0x5d7495310a466356ull, 0x3=
a482305545e6629ull,
> +                       0x83939c133bd6666aull, 0x1c8686b6d67f8071ull,
> +               },
> +       },
> +};
> +
> +/*
> + * Look up the curve and pick p or n. Returns NULL if a NIST curve is
> + * unavailable (P-192 in FIPS mode).
> + */
> +static const u64 *ecc_inv_mod(const struct ecc_inv_modulus *m,
> +                             unsigned int *ndigits)
> +{
> +       const struct ecc_curve *curve =3D m->curve ?: ecc_get_curve(m->cu=
rve_id);
> +
> +       if (!curve)
> +               return NULL;
> +
> +       *ndigits =3D curve->g.ndigits;
> +       return m->use_n ? curve->n : curve->p;
> +}
> +
> +static const u64 *ecc_inv_get_mod(struct kunit *test,
> +                                 const struct ecc_inv_modulus *m,
> +                                 unsigned int *ndigits)
> +{
> +       const u64 *mod =3D ecc_inv_mod(m, ndigits);
> +
> +       if (!mod)
> +               kunit_skip(test, "%s not available (FIPS mode?)", m->name=
);
> +
> +       return mod;
> +}
> +
> +typedef void (*ecc_inv_fn)(u64 *result, const u64 *input, const u64 *mod=
,
> +                          unsigned int ndigits);
> +
> +static void ecc_inv_run_kat(struct kunit *test, ecc_inv_fn inv)
> +{
> +       u64 result[ECC_MAX_DIGITS];
> +       unsigned int i;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(ecc_inv_kats); i++) {
> +               const struct ecc_inv_kat *kat =3D &ecc_inv_kats[i];
> +               unsigned int ndigits;
> +               const u64 *mod =3D ecc_inv_mod(&kat->mod, &ndigits);
> +
> +               if (!mod)
> +                       continue;
> +
> +               KUNIT_ASSERT_EQ(test, ndigits, kat->ndigits);
> +               inv(result, kat->input, mod, ndigits);
> +               KUNIT_EXPECT_MEMEQ_MSG(test, result, kat->expected,
> +                                      ndigits * sizeof(u64),
> +                                      "known-answer vector %u (%s)",
> +                                      i, kat->mod.name);
> +
> +               memcpy(result, kat->input, ndigits * sizeof(u64));
> +               inv(result, result, mod, ndigits);
> +               KUNIT_EXPECT_MEMEQ_MSG(test, result, kat->expected,
> +                                      ndigits * sizeof(u64),
> +                                      "in-place known-answer vector %u (=
%s)",
> +                                      i, kat->mod.name);
> +       }
> +}
> +
> +/* Edge cases: 0, 1, 2, m - 1 and m - 2 for every modulus. */
> +static void ecc_inv_run_edge(struct kunit *test, ecc_inv_fn inv)
> +{
> +       const struct ecc_inv_modulus *param =3D test->param_value;
> +       u64 x[ECC_MAX_DIGITS], result[ECC_MAX_DIGITS];
> +       u64 expected[ECC_MAX_DIGITS], prod[ECC_MAX_DIGITS];
> +       u64 one[ECC_MAX_DIGITS] =3D { 1 };
> +       unsigned int ndigits;
> +       const u64 *mod;
> +
> +       mod =3D ecc_inv_get_mod(test, param, &ndigits);
> +
> +       /* 0 has no inverse; the result is defined to be 0. */
> +       memset(x, 0, sizeof(x));
> +       memset(result, 0xff, sizeof(result));
> +       inv(result, x, mod, ndigits);
> +       KUNIT_EXPECT_TRUE_MSG(test, vli_is_zero(result, ndigits),
> +                             "inverse of 0 must be 0");
> +
> +       /* 1^-1 =3D 1 */
> +       x[0] =3D 1;
> +       inv(result, x, mod, ndigits);
> +       KUNIT_EXPECT_MEMEQ(test, result, one, ndigits * sizeof(u64));
> +
> +       /* 2^-1 =3D (m + 1) / 2: check via the defining property. */
> +       x[0] =3D 2;
> +       inv(result, x, mod, ndigits);
> +       vli_mod_mult_slow(prod, x, result, mod, ndigits);
> +       KUNIT_EXPECT_MEMEQ(test, prod, one, ndigits * sizeof(u64));
> +
> +       /* (m - 1)^-1 =3D m - 1, since (-1)^-1 =3D -1 */
> +       memcpy(x, mod, ndigits * sizeof(u64));
> +       x[0] -=3D 1;      /* m is odd, so no borrow */
> +       memcpy(expected, x, ndigits * sizeof(u64));
> +       inv(result, x, mod, ndigits);
> +       KUNIT_EXPECT_MEMEQ(test, result, expected, ndigits * sizeof(u64))=
;
> +
> +       /* m - 2 =3D -2 */
> +       x[0] -=3D 1;
> +       inv(result, x, mod, ndigits);
> +       vli_mod_mult_slow(prod, x, result, mod, ndigits);
> +       KUNIT_EXPECT_MEMEQ(test, prod, one, ndigits * sizeof(u64));
> +}
> +
> +#define ECC_INV_RANDOM_ITERS 200
> +
> +static u64 ecc_inv_xorshift(u64 *state)
> +{
> +       u64 x =3D *state;
> +
> +       x ^=3D x << 13;
> +       x ^=3D x >> 7;
> +       x ^=3D x << 17;
> +       *state =3D x;
> +       return x;
> +}
> +
> +static u64 ecc_inv_seed(const struct ecc_inv_modulus *param)
> +{
> +       return 0x243f6a8885a308d3ull ^ (u64)(param - ecc_inv_moduli);
> +}
> +
> +/* Pseudo-random input i in [1, m), from a fixed seed so failures reprod=
uce. */
> +static void ecc_inv_random_input(u64 *x, const u64 *mod, unsigned int nd=
igits,
> +                                unsigned int i, u64 *state)
> +{
> +       unsigned int j;
> +
> +       for (j =3D 0; j < ndigits; j++)
> +               x[j] =3D ecc_inv_xorshift(state);
> +       /* Every third input is small, to exercise short values. */
> +       if (i % 3 =3D=3D 0)
> +               memset(&x[1], 0, (ndigits - 1) * sizeof(u64));
> +       while (vli_cmp(x, mod, ndigits) >=3D 0)
> +               x[ndigits - 1] >>=3D 1;
> +       if (vli_is_zero(x, ndigits))
> +               x[0] =3D 1;
> +}
> +
> +/*
> + * The result must be reduced (< m) and satisfy x * result =3D=3D 1 (mod=
 m).
> + * The inverse modulo a prime is unique, so this pins down the answer.
> + */
> +static void ecc_inv_run_random(struct kunit *test, ecc_inv_fn inv)
> +{
> +       const struct ecc_inv_modulus *param =3D test->param_value;
> +       u64 x[ECC_MAX_DIGITS], result[ECC_MAX_DIGITS];
> +       u64 prod[ECC_MAX_DIGITS];
> +       u64 one[ECC_MAX_DIGITS] =3D { 1 };
> +       u64 state =3D ecc_inv_seed(param);
> +       unsigned int ndigits, i;
> +       const u64 *mod;
> +
> +       mod =3D ecc_inv_get_mod(test, param, &ndigits);
> +
> +       for (i =3D 0; i < ECC_INV_RANDOM_ITERS; i++) {
> +               ecc_inv_random_input(x, mod, ndigits, i, &state);
> +
> +               inv(result, x, mod, ndigits);
> +               KUNIT_ASSERT_LT_MSG(test, vli_cmp(result, mod, ndigits), =
0,
> +                                   "result not reduced, iteration %u", i=
);
> +
> +               vli_mod_mult_slow(prod, x, result, mod, ndigits);
> +               KUNIT_ASSERT_MEMEQ_MSG(test, prod, one, ndigits * sizeof(=
u64),
> +                                      "x * x^-1 !=3D 1, iteration %u", i=
);
> +       }
> +}
> +
> +static void ecc_inv_test_kat(struct kunit *test)
> +{
> +       ecc_inv_run_kat(test, vli_mod_inv);
> +}
> +
> +static void ecc_inv_test_edge(struct kunit *test)
> +{
> +       ecc_inv_run_edge(test, vli_mod_inv);
> +}
> +
> +static void ecc_inv_test_random(struct kunit *test)
> +{
> +       ecc_inv_run_random(test, vli_mod_inv);
> +}
> +
> +static void ecc_inv_vartime_test_kat(struct kunit *test)
> +{
> +       ecc_inv_run_kat(test, vli_mod_inv_vartime);
> +}
> +
> +static void ecc_inv_vartime_test_edge(struct kunit *test)
> +{
> +       ecc_inv_run_edge(test, vli_mod_inv_vartime);
> +}
> +
> +static void ecc_inv_vartime_test_random(struct kunit *test)
> +{
> +       ecc_inv_run_random(test, vli_mod_inv_vartime);
> +}
> +
> +/* On the random inputs, both functions must return identical results. *=
/
> +static void ecc_inv_test_cross(struct kunit *test)
> +{
> +       const struct ecc_inv_modulus *param =3D test->param_value;
> +       u64 x[ECC_MAX_DIGITS], ct[ECC_MAX_DIGITS], vt[ECC_MAX_DIGITS];
> +       u64 state =3D ecc_inv_seed(param);
> +       unsigned int ndigits, i;
> +       const u64 *mod;
> +
> +       mod =3D ecc_inv_get_mod(test, param, &ndigits);
> +
> +       for (i =3D 0; i < ECC_INV_RANDOM_ITERS; i++) {
> +               ecc_inv_random_input(x, mod, ndigits, i, &state);
> +
> +               vli_mod_inv(ct, x, mod, ndigits);
> +               vli_mod_inv_vartime(vt, x, mod, ndigits);
> +               KUNIT_ASSERT_MEMEQ_MSG(test, ct, vt, ndigits * sizeof(u64=
),
> +                                      "vli_mod_inv() !=3D vli_mod_inv_va=
rtime(), iteration %u",
> +                                      i);
> +       }
> +}
> +
> +/*
> + * An even modulus is rejected and the result is 0; the WARN is suppress=
ed
> + * so the log stays clean. Constant-time version only:
> + * vli_mod_inv_vartime() requires an odd modulus and does not check it.
> + */
> +static void ecc_inv_test_even_modulus(struct kunit *test)
> +{
> +       u64 mod[4] =3D { 0x10, 0, 0, 1 };
> +       u64 x[4] =3D { 3 };
> +       u64 result[4];
> +
> +       memset(result, 0xff, sizeof(result));
> +       kunit_warning_suppress(test) {
> +               vli_mod_inv(result, x, mod, 4);
> +       }
> +       KUNIT_EXPECT_TRUE(test, vli_is_zero(result, 4));
> +}
> +
> +static struct kunit_case ecc_inv_test_cases[] =3D {
> +       KUNIT_CASE(ecc_inv_test_kat),
> +       KUNIT_CASE_PARAM(ecc_inv_test_edge, ecc_inv_modulus_gen_params),
> +       KUNIT_CASE_PARAM(ecc_inv_test_random, ecc_inv_modulus_gen_params)=
,
> +       KUNIT_CASE(ecc_inv_test_even_modulus),
> +       KUNIT_CASE(ecc_inv_vartime_test_kat),
> +       KUNIT_CASE_PARAM(ecc_inv_vartime_test_edge, ecc_inv_modulus_gen_p=
arams),
> +       KUNIT_CASE_PARAM(ecc_inv_vartime_test_random, ecc_inv_modulus_gen=
_params),
> +       KUNIT_CASE_PARAM(ecc_inv_test_cross, ecc_inv_modulus_gen_params),
> +       {}
> +};
> +
> +static struct kunit_suite ecc_inv_test_suite =3D {
> +       .name =3D "ecc_mod_inv",
> +       .test_cases =3D ecc_inv_test_cases,
> +};
> +
> +kunit_test_suite(ecc_inv_test_suite);
> +
> +MODULE_DESCRIPTION("KUnit tests for ECC modular inversion");
> +MODULE_LICENSE("GPL");
> diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
> index ce8e4364842ff416b3ab8055f8bf6d31a262f549..1406160343e3e04c4f3796454=
4248df8dfc7271f 100644
> --- a/crypto/ecdsa.c
> +++ b/crypto/ecdsa.c
> @@ -41,7 +41,7 @@ static int _ecdsa_verify(struct ecc_ctx *ctx, const u64=
 *hash, const u64 *r, con
>                  hash[ndigits - 1], hash[ndigits - 2], hash[0]);
>
>         /* s1 =3D (s^-1) mod n */
> -       vli_mod_inv(s1, s, curve->n, ndigits);
> +       vli_mod_inv_vartime(s1, s, curve->n, ndigits);
>         /* u1 =3D (hash * s1) mod n */
>         vli_mod_mult_slow(u1, hash, s1, curve->n, ndigits);
>         /* u2 =3D (r * s1) mod n */
> diff --git a/crypto/ecrdsa.c b/crypto/ecrdsa.c
> index 93c9e7d76792af5e31361479a11ddeff5620a7b0..1f50ed8f736c75d5c8ada85c7=
300bc4bdffecf54 100644
> --- a/crypto/ecrdsa.c
> +++ b/crypto/ecrdsa.c
> @@ -119,7 +119,7 @@ static int ecrdsa_verify(struct crypto_sig *tfm,
>                 e[0] =3D 1;
>
>         /* Step 4: calculate v =3D e^{-1} \mod q */
> -       vli_mod_inv(v, e, ctx->curve->n, ndigits);
> +       vli_mod_inv_vartime(v, e, ctx->curve->n, ndigits);
>
>         /* Step 5: calculate z_1 =3D sv \mod q, z_2 =3D -rv \mod q */
>         vli_mod_mult_slow(z1, s, v, ctx->curve->n, ndigits);
> diff --git a/include/crypto/internal/ecc.h b/include/crypto/internal/ecc.=
h
> index d67fe13a543aa1bfbdba969fcf781085038bcbf5..aebaef21d0748fb7a0fc2765e=
b501d1c9995765c 100644
> --- a/include/crypto/internal/ecc.h
> +++ b/include/crypto/internal/ecc.h
> @@ -230,16 +230,34 @@ void vli_from_be64(u64 *dest, const void *src, unsi=
gned int ndigits);
>  void vli_from_le64(u64 *dest, const void *src, unsigned int ndigits);
>
>  /**
> - * vli_mod_inv() - Modular inversion
> + * vli_mod_inv() - Constant-time modular inversion
>   *
>   * @result:            where to write vli number
>   * @input:             vli value to operate on
>   * @mod:               modulus
>   * @ndigits:           length of all vlis
> + *
> + * @mod must be odd. Nonzero @input must be coprime to @mod, as is alway=
s
> + * true for nonzero inputs smaller than the prime moduli used here.
> + * A zero @input returns 0.
>   */
>  void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
>                  unsigned int ndigits);
>
> +/**
> + * vli_mod_inv_vartime() - Variable-time modular inversion
> + *
> + * @result:            where to write vli number
> + * @input:             vli value to operate on
> + * @mod:               modulus
> + * @ndigits:           length of all vlis
> + *
> + * Faster than vli_mod_inv(), but its running time depends on @input.
> + * Only use it when @input is public, e.g. in signature verification.
> + */
> +void vli_mod_inv_vartime(u64 *result, const u64 *input, const u64 *mod,
> +                        unsigned int ndigits);
> +
>  /**
>   * vli_mod_mult_slow() - Modular multiplication
>   *
>

Ignat
