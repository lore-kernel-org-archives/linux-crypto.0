Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828542192E9;
	Thu, 17 Apr 2025 06:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744873081; cv=none; b=tASo3/1DwyS7kI1aSMj5OdWBoGAaN99aOCND+y8il2/STs4ZJrwLElotMSP73q2lbLL2Z2eev/s6bAgRAD1FMlEo3q4AUZLp48tLJwm/sYmtDTulQZ2vN3X3ulo5jA8kLKHFLaWlcDG4FAqeElduXJTT5ZSTlAsE5yorPyTSQcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744873081; c=relaxed/simple;
	bh=Y77DbjMf4HhRAwtuMs5vtnyHBk2K0UG8o6akck7uCvw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GdcTmIJqseidVHOXfs9DFqbOwz35hkTdE+PI7h9W2K0LgseytnkAPG6ZwpS4AJsSVwFQLbac1gONhay3gval76r1IFiylsrl4/TkT0NUHNqOWCvWYSx+Epq4x7nVybWpHRdvn7w4In4IoyVvGd2/Llw6AJm/+E826HyrZSOA/l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UHEQBCaS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UHEQBCaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7DAC4CEEC;
	Thu, 17 Apr 2025 06:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744873081;
	bh=Y77DbjMf4HhRAwtuMs5vtnyHBk2K0UG8o6akck7uCvw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UHEQBCaScrHwRyz2hRmIVymZFG2vh2vT8491PcB0mjQ7Lbf30B2CpgYcX1IeEAcpm
	 9SPUaRUoXUhUpgbXkdwTFTw5uDv0ow7mWkz6BBAdi1yhzhx0MS7Fkl0oH9DO9PMHRr
	 qBLm6C/wqKUNJFv7jEOCFmqZgfumcF0omoU83Mm2yr4NcaBImH4UhIjx7MSvtGpKon
	 tI371u8BdFqd568aPXEf1zOXVmUx3/v1E7HrGKdrcQZjXP9gB1hR9yd4wwXWl26HQj
	 R+ofggUtCn2EAyWgVyFO/Dd9wNeadfFeR4vSsqfCX+PzoXHHsbMoPh9LX87/f11kjx
	 BkowLC22V0EEQ==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-54ac9b3ddf6so433294e87.1;
        Wed, 16 Apr 2025 23:58:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU4u6puySpg9Gxdj4QDKqH9PkJLxsCR+NXm7jvAi32NHHRO6PQcQBAhr/2U/wy7A9wKVYiZhjhAojK3DU0A@vger.kernel.org, AJvYcCUdEBQR5q9r6J36VCQ2NF8s9wTXnLga4/SyX6iytZZRKe24TaCNdJCT9JHJ06mMTHJaoK56zwYgor9ihRA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNC9/B/2lQYYRWQ6Ly1NOsJJiSYrSZwx+y20nRwpmwjI16e07c
	f68aezUIv06ZQ/canbJyGwmxf/24Y8QfphUqm5GKaCFgoxkRb0o9DpikdREe1YOyKcquXKA5M+q
	CKJKFJqesls4YFhvx7vOHRevD51U=
X-Google-Smtp-Source: AGHT+IGTpSThJonKU53oEUWgAvFeHeFSijzfHDJVJCsY7X2ZKG5DJ4PStt0cdP4O4uYf0eoBfgBU2ST5Z8JYj0PiqRs=
X-Received: by 2002:a05:6512:3193:b0:54b:1055:f4c0 with SMTP id
 2adb3069b0e04-54d64a7a651mr1644039e87.4.1744873079215; Wed, 16 Apr 2025
 23:57:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417064940.68469-1-dqfext@gmail.com>
In-Reply-To: <20250417064940.68469-1-dqfext@gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 17 Apr 2025 08:57:48 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFPAVXOtPoETKvHB49kjZUPYrsAqsJwdL7p5Cu4xk75Rg@mail.gmail.com>
X-Gm-Features: ATxdqUEg0LItEF6qVzBftj0GU5jJjV7J9Ddre-kVdnKWA7XZvtmAkQD3vjmJQB0
Message-ID: <CAMj1kXFPAVXOtPoETKvHB49kjZUPYrsAqsJwdL7p5Cu4xk75Rg@mail.gmail.com>
Subject: Re: [RFC PATCH] crypto: riscv: scalar accelerated GHASH
To: Qingfang Deng <dqfext@gmail.com>, Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, linux-crypto@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>, 
	Heiko Stuebner <heiko.stuebner@vrull.eu>, Qingfang Deng <qingfang.deng@siflower.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

(cc Eric)

On Thu, 17 Apr 2025 at 08:49, Qingfang Deng <dqfext@gmail.com> wrote:
>
> From: Qingfang Deng <qingfang.deng@siflower.com.cn>
>
> Add a scalar implementation of GHASH for RISC-V using the Zbc (carry-less
> multiplication) and Zbb (bit-manipulation) extensions. This implementatio=
n
> is adapted from OpenSSL but rewritten in plain C for clarity.
>
> Unlike the OpenSSL one that rely on bit-reflection of the data, this
> version uses a pre-computed (reflected and multiplied) key, inspired by
> the approach used in Intel's CLMUL driver, to avoid reflections during
> runtime.
>
> Signed-off-by: Qingfang Deng <qingfang.deng@siflower.com.cn>

What is the use case for this? AIUI, the scalar AES instructions were
never implemented by anyone, so how do you expect this to be used in
practice?


> ---
>  arch/riscv/crypto/Kconfig               |  16 +-
>  arch/riscv/crypto/Makefile              |   2 +
>  arch/riscv/crypto/ghash-riscv64-clmul.c | 270 ++++++++++++++++++++++++
>  3 files changed, 287 insertions(+), 1 deletion(-)
>  create mode 100644 arch/riscv/crypto/ghash-riscv64-clmul.c
>
> diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
> index 6392e1e11bc9..03b74d4116cb 100644
> --- a/arch/riscv/crypto/Kconfig
> +++ b/arch/riscv/crypto/Kconfig
> @@ -26,7 +26,7 @@ config CRYPTO_CHACHA_RISCV64
>         default CRYPTO_LIB_CHACHA_INTERNAL
>
>  config CRYPTO_GHASH_RISCV64
> -       tristate "Hash functions: GHASH"
> +       tristate "Hash functions: GHASH (vector accelarated)"
>         depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
>         select CRYPTO_GCM
>         help
> @@ -35,6 +35,20 @@ config CRYPTO_GHASH_RISCV64
>           Architecture: riscv64 using:
>           - Zvkg vector crypto extension
>
> +config CRYPTO_GHASH_RISCV64_CLMUL
> +       tristate "Hash functions: GHASH (CLMUL scalar accelerated)"
> +       depends on 64BIT && TOOLCHAIN_HAS_ZBB && TOOLCHAIN_HAS_ZBC
> +       select CRYPTO_GCM
> +       help
> +         GCM GHASH function (NIST SP 800-38D)
> +
> +         Architecture: riscv64 using:
> +         - Zbb Bitmanipulation extension
> +         - Zbc Carry-less multiplication
> +           OR
> +         - Zbkb Bit-manipulation for Cryptography
> +         - Zbkc Carry-less multiplication for Cryptography
> +
>  config CRYPTO_SHA256_RISCV64
>         tristate "Hash functions: SHA-224 and SHA-256"
>         depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
> diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
> index 247c7bc7288c..b5dc497d398c 100644
> --- a/arch/riscv/crypto/Makefile
> +++ b/arch/riscv/crypto/Makefile
> @@ -10,6 +10,8 @@ chacha-riscv64-y :=3D chacha-riscv64-glue.o chacha-risc=
v64-zvkb.o
>  obj-$(CONFIG_CRYPTO_GHASH_RISCV64) +=3D ghash-riscv64.o
>  ghash-riscv64-y :=3D ghash-riscv64-glue.o ghash-riscv64-zvkg.o
>
> +obj-$(CONFIG_CRYPTO_GHASH_RISCV64_CLMUL) +=3D ghash-riscv64-clmul.o
> +
>  obj-$(CONFIG_CRYPTO_SHA256_RISCV64) +=3D sha256-riscv64.o
>  sha256-riscv64-y :=3D sha256-riscv64-glue.o sha256-riscv64-zvknha_or_zvk=
nhb-zvkb.o
>
> diff --git a/arch/riscv/crypto/ghash-riscv64-clmul.c b/arch/riscv/crypto/=
ghash-riscv64-clmul.c
> new file mode 100644
> index 000000000000..4777aa8e94cb
> --- /dev/null
> +++ b/arch/riscv/crypto/ghash-riscv64-clmul.c
> @@ -0,0 +1,270 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * GHASH using the RISC-V Zbc/Zbkc (CLMUL) extension
> + *
> + * Copyright (C) 2023 VRULL GmbH
> + * Author: Christoph M=C3=BCllner <christoph.muellner@vrull.eu>
> + *
> + * Copyright (C) 2025 Siflower Communications Ltd
> + * Author: Qingfang Deng <qingfang.deng@siflower.com.cn>
> + */
> +
> +#include <linux/crypto.h>
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <crypto/ghash.h>
> +#include <crypto/internal/hash.h>
> +
> +#define GHASH_MOD_POLY 0xc200000000000000
> +
> +struct riscv64_clmul_ghash_ctx {
> +       __uint128_t key;
> +};
> +
> +struct riscv64_clmul_ghash_desc_ctx {
> +       __uint128_t shash;
> +       u8 buffer[GHASH_DIGEST_SIZE];
> +       int bytes;
> +};
> +
> +static __always_inline u64 riscv_zbb_swab64(u64 val)
> +{
> +       asm (".option push\n"
> +            ".option arch,+zbb\n"
> +            "rev8 %0, %1\n"
> +            ".option pop\n"
> +            : "=3Dr" (val) : "r" (val));
> +       return val;
> +}
> +
> +static __always_inline __uint128_t get_unaligned_be128(const u8 *p)
> +{
> +       __uint128_t val;
> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS

CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS means that get_unaligned_xxx()
helpers are cheap. Casting a void* to an aligned type is still UB as
per the C standard.

So better to drop the #ifdef entirely, and just use the
get_unaligned_be64() helpers for both cases.

(same below)

Also, do you need to test for int128 support? Or is that guaranteed
for all compilers that are supported by the RISC-V port?


> +       val =3D *(__uint128_t *)p;
> +       val =3D riscv_zbb_swab64(val >> 64) | (__uint128_t)riscv_zbb_swab=
64(val) << 64;
> +#else
> +       val =3D (__uint128_t)p[0] << 120;
> +       val |=3D (__uint128_t)p[1] << 112;
> +       val |=3D (__uint128_t)p[2] << 104;
> +       val |=3D (__uint128_t)p[3] << 96;
> +       val |=3D (__uint128_t)p[4] << 88;
> +       val |=3D (__uint128_t)p[5] << 80;
> +       val |=3D (__uint128_t)p[6] << 72;
> +       val |=3D (__uint128_t)p[7] << 64;
> +       val |=3D (__uint128_t)p[8] << 56;
> +       val |=3D (__uint128_t)p[9] << 48;
> +       val |=3D (__uint128_t)p[10] << 40;
> +       val |=3D (__uint128_t)p[11] << 32;
> +       val |=3D (__uint128_t)p[12] << 24;
> +       val |=3D (__uint128_t)p[13] << 16;
> +       val |=3D (__uint128_t)p[14] << 8;
> +       val |=3D (__uint128_t)p[15];
> +#endif
> +       return val;
> +}
> +
> +static __always_inline void put_unaligned_be128(__uint128_t val, u8 *p)
> +{
> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> +       *(__uint128_t *)p =3D riscv_zbb_swab64(val >> 64) | (__uint128_t)=
riscv_zbb_swab64(val) << 64;
> +#else
> +       p[0] =3D val >> 120;
> +       p[1] =3D val >> 112;
> +       p[2] =3D val >> 104;
> +       p[3] =3D val >> 96;
> +       p[4] =3D val >> 88;
> +       p[5] =3D val >> 80;
> +       p[6] =3D val >> 72;
> +       p[7] =3D val >> 64;
> +       p[8] =3D val >> 56;
> +       p[9] =3D val >> 48;
> +       p[10] =3D val >> 40;
> +       p[11] =3D val >> 32;
> +       p[12] =3D val >> 24;
> +       p[13] =3D val >> 16;
> +       p[14] =3D val >> 8;
> +       p[15] =3D val;
> +#endif
> +}
> +
> +static __always_inline __attribute_const__
> +__uint128_t clmul128(u64 a, u64 b)
> +{
> +       u64 hi, lo;
> +
> +       asm(".option push\n"
> +           ".option arch,+zbc\n"
> +           "clmul      %0, %2, %3\n"
> +           "clmulh     %1, %2, %3\n"
> +           ".option pop\n"
> +           : "=3D&r" (lo), "=3D&r" (hi) : "r" (a), "r" (b));
> +       return (__uint128_t)hi << 64 | lo;
> +}
> +
> +static int riscv64_clmul_ghash_init(struct shash_desc *desc)
> +{
> +       struct riscv64_clmul_ghash_desc_ctx *dctx =3D shash_desc_ctx(desc=
);
> +
> +       dctx->bytes =3D 0;
> +       dctx->shash =3D 0;
> +       return 0;
> +}
> +
> +/* Compute GMULT (Xi*H mod f) using the Zbc (clmul) extensions.
> + * Using the no-Karatsuba approach and clmul for the final reduction.
> + * This results in an implementation with minimized number of instructio=
ns.
> + * HW with clmul latencies higher than 2 cycles might observe a performa=
nce
> + * improvement with Karatsuba. HW with clmul latencies higher than 6 cyc=
les
> + * might observe a performance improvement with additionally converting =
the
> + * reduction to shift&xor. For a full discussion of this estimates see
> + * https://github.com/riscv/riscv-crypto/blob/master/doc/supp/gcm-mode-c=
mul.adoc
> + */
> +static void gcm_ghash_rv64i_zbc(__uint128_t *Xi, __uint128_t k, const u8=
 *inp, size_t len)
> +{
> +       u64 k_hi =3D k >> 64, k_lo =3D k, p_hi, p_lo;
> +       __uint128_t hash =3D *Xi, p;
> +
> +       do {
> +               __uint128_t t0, t1, t2, t3, lo, mid, hi;
> +
> +               /* Load the input data, byte-reverse them, and XOR them w=
ith Xi */
> +               p =3D get_unaligned_be128(inp);
> +
> +               inp +=3D GHASH_BLOCK_SIZE;
> +               len -=3D GHASH_BLOCK_SIZE;
> +
> +               p ^=3D hash;
> +               p_hi =3D p >> 64;
> +               p_lo =3D p;
> +
> +               /* Multiplication (without Karatsuba) */
> +               t0 =3D clmul128(p_lo, k_lo);
> +               t1 =3D clmul128(p_lo, k_hi);
> +               t2 =3D clmul128(p_hi, k_lo);
> +               t3 =3D clmul128(p_hi, k_hi);
> +               mid =3D t1 ^ t2;
> +               lo =3D t0 ^ (mid << 64);
> +               hi =3D t3 ^ (mid >> 64);
> +
> +               /* Reduction with clmul */
> +               mid =3D clmul128(lo, GHASH_MOD_POLY);
> +               lo ^=3D mid << 64;
> +               hi ^=3D lo ^ (mid >> 64);
> +               hi ^=3D clmul128(lo >> 64, GHASH_MOD_POLY);
> +               hash =3D hi;
> +       } while (len);
> +
> +       *Xi =3D hash;
> +}
> +
> +static int riscv64_clmul_ghash_setkey(struct crypto_shash *tfm, const u8=
 *key, unsigned int keylen)
> +{
> +       struct riscv64_clmul_ghash_ctx *ctx =3D crypto_shash_ctx(tfm);
> +       __uint128_t k;
> +
> +       if (keylen !=3D GHASH_BLOCK_SIZE)
> +               return -EINVAL;
> +
> +       k =3D get_unaligned_be128(key);
> +       k =3D (k << 1 | k >> 127) ^ (k >> 127 ? (__uint128_t)GHASH_MOD_PO=
LY << 64 : 0);
> +       ctx->key =3D k;
> +
> +       return 0;
> +}
> +
> +static int riscv64_clmul_ghash_update(struct shash_desc *desc, const u8 =
*src, unsigned int srclen)
> +{
> +       struct riscv64_clmul_ghash_ctx *ctx =3D crypto_shash_ctx(desc->tf=
m);
> +       struct riscv64_clmul_ghash_desc_ctx *dctx =3D shash_desc_ctx(desc=
);
> +       unsigned int len;
> +
> +       if (dctx->bytes) {
> +               if (dctx->bytes + srclen < GHASH_DIGEST_SIZE) {
> +                       memcpy(dctx->buffer + dctx->bytes, src, srclen);
> +                       dctx->bytes +=3D srclen;
> +                       return 0;
> +               }
> +               memcpy(dctx->buffer + dctx->bytes, src, GHASH_DIGEST_SIZE=
 - dctx->bytes);
> +
> +               gcm_ghash_rv64i_zbc(&dctx->shash, ctx->key, dctx->buffer,=
 GHASH_DIGEST_SIZE);
> +
> +               src +=3D GHASH_DIGEST_SIZE - dctx->bytes;
> +               srclen -=3D GHASH_DIGEST_SIZE - dctx->bytes;
> +               dctx->bytes =3D 0;
> +       }
> +
> +       len =3D round_down(srclen, GHASH_BLOCK_SIZE);
> +       if (len) {
> +               gcm_ghash_rv64i_zbc(&dctx->shash, ctx->key, src, len);
> +               src +=3D len;
> +               srclen -=3D len;
> +       }
> +
> +       if (srclen) {
> +               memcpy(dctx->buffer, src, srclen);
> +               dctx->bytes =3D srclen;
> +       }
> +       return 0;
> +}
> +
> +static int riscv64_clmul_ghash_final(struct shash_desc *desc, u8 out[GHA=
SH_DIGEST_SIZE])
> +{
> +       struct riscv64_clmul_ghash_ctx *ctx =3D crypto_shash_ctx(desc->tf=
m);
> +       struct riscv64_clmul_ghash_desc_ctx *dctx =3D shash_desc_ctx(desc=
);
> +       int i;
> +
> +       if (dctx->bytes) {
> +               for (i =3D dctx->bytes; i < GHASH_DIGEST_SIZE; i++)
> +                       dctx->buffer[i] =3D 0;
> +               gcm_ghash_rv64i_zbc(&dctx->shash, ctx->key, dctx->buffer,=
 GHASH_DIGEST_SIZE);
> +               dctx->bytes =3D 0;
> +       }
> +       put_unaligned_be128(dctx->shash, out);
> +       return 0;
> +}
> +
> +struct shash_alg riscv64_clmul_ghash_alg =3D {
> +       .init =3D riscv64_clmul_ghash_init,
> +       .update =3D riscv64_clmul_ghash_update,
> +       .final =3D riscv64_clmul_ghash_final,
> +       .setkey =3D riscv64_clmul_ghash_setkey,
> +       .descsize =3D sizeof(struct riscv64_clmul_ghash_desc_ctx),
> +       .digestsize =3D GHASH_DIGEST_SIZE,
> +       .base =3D {
> +                .cra_blocksize =3D GHASH_BLOCK_SIZE,
> +                .cra_ctxsize =3D sizeof(struct riscv64_clmul_ghash_ctx),
> +                .cra_priority =3D 250,
> +                .cra_name =3D "ghash",
> +                .cra_driver_name =3D "ghash-riscv64-clmul",
> +                .cra_module =3D THIS_MODULE,
> +       },
> +};
> +
> +static int __init riscv64_clmul_ghash_mod_init(void)
> +{
> +       bool has_clmul, has_rev8;
> +
> +       has_clmul =3D riscv_isa_extension_available(NULL, ZBC) ||
> +                   riscv_isa_extension_available(NULL, ZBKC);
> +       has_rev8 =3D riscv_isa_extension_available(NULL, ZBB) ||
> +                  riscv_isa_extension_available(NULL, ZBKB);
> +       if (has_clmul && has_rev8)
> +               return crypto_register_shash(&riscv64_clmul_ghash_alg);
> +
> +       return -ENODEV;
> +}
> +
> +static void __exit riscv64_clmul_ghash_mod_fini(void)
> +{
> +       crypto_unregister_shash(&riscv64_clmul_ghash_alg);
> +}
> +
> +module_init(riscv64_clmul_ghash_mod_init);
> +module_exit(riscv64_clmul_ghash_mod_fini);
> +
> +MODULE_DESCRIPTION("GHASH (RISC-V CLMUL accelerated)");
> +MODULE_AUTHOR("Qingfang Deng <dqfext@gmail.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_CRYPTO("ghash");
> --
> 2.43.0
>
>
