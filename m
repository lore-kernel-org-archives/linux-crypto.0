From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: [PATCH v4] crypto: gf128mul - define gf128mul_x_* in gf128mul.h
Date: Sat, 1 Apr 2017 17:19:15 +0200
Message-ID: <CAAUqJDtE+ozFGodYAk=+LxQ9_Ot7mhCH3Asq2aP2RKRFZzz9Uw@mail.gmail.com>
References: <20170401151755.11875-1-omosnacek@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Jeffrey Walton <noloader@gmail.com>,
        Milan Broz <gmazyland@gmail.com>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Eric Biggers <ebiggers@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36633 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdDAPTi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Apr 2017 11:19:38 -0400
Received: by mail-lf0-f65.google.com with SMTP id n78so9611659lfi.3
        for <linux-crypto@vger.kernel.org>; Sat, 01 Apr 2017 08:19:37 -0700 (PDT)
In-Reply-To: <20170401151755.11875-1-omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Oops, sorry, wrong prefix...

2017-04-01 17:17 GMT+02:00 Ondrej Mosnacek <omosnacek@gmail.com>:
> The gf128mul_x_ble function is currently defined in gf128mul.c, because
> it depends on the gf128mul_table_be multiplication table.
>
> However, since the function is very small and only uses two values from
> the table, it is better for it to be defined as inline function in
> gf128mul.h. That way, the function can be inlined by the compiler for
> better performance.
>
> For consistency, the other gf128mul_x_* functions are also moved to the
> header file. In addition, the code is rewritten to be constant-time.
>
> After this change, the speed of the generic 'xts(aes)' implementation
> increased from ~225 MiB/s to ~235 MiB/s (measured using 'cryptsetup
> benchmark -c aes-xts-plain64' on an Intel system with CRYPTO_AES_X86_64
> and CRYPTO_AES_NI_INTEL disabled).
>
> Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
> Cc: Eric Biggers <ebiggers@google.com>
> ---
> v3 -> v4: a faster version of gf128mul_x_lle
> v2 -> v3: constant-time implementation
> v1 -> v2: move all _x_ functions to the header, not just gf128mul_x_ble
>
>  crypto/gf128mul.c         | 33 +---------------------------
>  include/crypto/gf128mul.h | 55 +++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 54 insertions(+), 34 deletions(-)
>
> diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
> index 04facc0..dc01212 100644
> --- a/crypto/gf128mul.c
> +++ b/crypto/gf128mul.c
> @@ -130,43 +130,12 @@ static const u16 gf128mul_table_le[256] = gf128mul_dat(xda_le);
>  static const u16 gf128mul_table_be[256] = gf128mul_dat(xda_be);
>
>  /*
> - * The following functions multiply a field element by x or by x^8 in
> + * The following functions multiply a field element by x^8 in
>   * the polynomial field representation.  They use 64-bit word operations
>   * to gain speed but compensate for machine endianness and hence work
>   * correctly on both styles of machine.
>   */
>
> -static void gf128mul_x_lle(be128 *r, const be128 *x)
> -{
> -       u64 a = be64_to_cpu(x->a);
> -       u64 b = be64_to_cpu(x->b);
> -       u64 _tt = gf128mul_table_le[(b << 7) & 0xff];
> -
> -       r->b = cpu_to_be64((b >> 1) | (a << 63));
> -       r->a = cpu_to_be64((a >> 1) ^ (_tt << 48));
> -}
> -
> -static void gf128mul_x_bbe(be128 *r, const be128 *x)
> -{
> -       u64 a = be64_to_cpu(x->a);
> -       u64 b = be64_to_cpu(x->b);
> -       u64 _tt = gf128mul_table_be[a >> 63];
> -
> -       r->a = cpu_to_be64((a << 1) | (b >> 63));
> -       r->b = cpu_to_be64((b << 1) ^ _tt);
> -}
> -
> -void gf128mul_x_ble(be128 *r, const be128 *x)
> -{
> -       u64 a = le64_to_cpu(x->a);
> -       u64 b = le64_to_cpu(x->b);
> -       u64 _tt = gf128mul_table_be[b >> 63];
> -
> -       r->a = cpu_to_le64((a << 1) ^ _tt);
> -       r->b = cpu_to_le64((b << 1) | (a >> 63));
> -}
> -EXPORT_SYMBOL(gf128mul_x_ble);
> -
>  static void gf128mul_x8_lle(be128 *x)
>  {
>         u64 a = be64_to_cpu(x->a);
> diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
> index 0bc9b5f..35ced9d 100644
> --- a/include/crypto/gf128mul.h
> +++ b/include/crypto/gf128mul.h
> @@ -49,6 +49,7 @@
>  #ifndef _CRYPTO_GF128MUL_H
>  #define _CRYPTO_GF128MUL_H
>
> +#include <asm/byteorder.h>
>  #include <crypto/b128ops.h>
>  #include <linux/slab.h>
>
> @@ -163,8 +164,58 @@ void gf128mul_lle(be128 *a, const be128 *b);
>
>  void gf128mul_bbe(be128 *a, const be128 *b);
>
> -/* multiply by x in ble format, needed by XTS */
> -void gf128mul_x_ble(be128 *a, const be128 *b);
> +/*
> + * The following functions multiply a field element by x in
> + * the polynomial field representation.  They use 64-bit word operations
> + * to gain speed but compensate for machine endianness and hence work
> + * correctly on both styles of machine.
> + *
> + * They are defined here for performance.
> + */
> +
> +static inline u64 gf128mul_mask_from_bit(u64 x, int which)
> +{
> +       /* a constant-time version of 'x & ((u64)1 << which) ? (u64)-1 : 0' */
> +       return ((s64)(x << (63 - which)) >> 63);
> +}
> +
> +static inline void gf128mul_x_lle(be128 *r, const be128 *x)
> +{
> +       u64 a = be64_to_cpu(x->a);
> +       u64 b = be64_to_cpu(x->b);
> +
> +       /* equivalent to gf128mul_table_le[(b << 7) & 0xff] << 48
> +        * (see crypto/gf128mul.c): */
> +       u64 _tt = gf128mul_mask_from_bit(b, 0) & ((u64)0xe1 << 56);
> +
> +       r->b = cpu_to_be64((b >> 1) | (a << 63));
> +       r->a = cpu_to_be64((a >> 1) ^ _tt);
> +}
> +
> +static inline void gf128mul_x_bbe(be128 *r, const be128 *x)
> +{
> +       u64 a = be64_to_cpu(x->a);
> +       u64 b = be64_to_cpu(x->b);
> +
> +       /* equivalent to gf128mul_table_be[a >> 63] (see crypto/gf128mul.c): */
> +       u64 _tt = gf128mul_mask_from_bit(a, 63) & 0x87;
> +
> +       r->a = cpu_to_be64((a << 1) | (b >> 63));
> +       r->b = cpu_to_be64((b << 1) ^ _tt);
> +}
> +
> +/* needed by XTS */
> +static inline void gf128mul_x_ble(be128 *r, const be128 *x)
> +{
> +       u64 a = le64_to_cpu(x->a);
> +       u64 b = le64_to_cpu(x->b);
> +
> +       /* equivalent to gf128mul_table_be[b >> 63] (see crypto/gf128mul.c): */
> +       u64 _tt = gf128mul_mask_from_bit(b, 63) & 0x87;
> +
> +       r->a = cpu_to_le64((a << 1) ^ _tt);
> +       r->b = cpu_to_le64((b << 1) | (a >> 63));
> +}
>
>  /* 4k table optimization */
>
> --
> 2.9.3
>
