Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFC242AA3;
	Thu, 14 Nov 2024 07:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731567939; cv=none; b=j03QSrAD0f/jzoBgPprWrVBsCz3nCnJxrRZN5eF2y+RkAnedNDayJfVANTVvQWl+64uN3pjYZtoMx6iGWmupwikmJpciRn//xhzPsX7h9F92zgb+IBhy9z2jokzEkV56KQot9LA1r9L8qinJ8C3ncHtJ4m6vCeAfKKpheCueemQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731567939; c=relaxed/simple;
	bh=ZrCeSBmaS1WGIeCnJ+l3hs2ZSD3pHhXyFeVqVRjlJgM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RxcAOD9KkP+AjuQd2PXweLstk9v+zlyCCNMGexQugDeb5wYlQqEVcJIKHahJ75aseojO5jxK/hG/9Fw2IQcrWkPX6H6Z1srfaHoGu1sH+ENvtfWUf96iPmX9G+wbmfNxC7CKrlXYenYU5k+dWrWv9camDn/kEjxMBAqNyHIL7wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from mail-ed1-f50.google.com (unknown [209.85.208.50])
	by APP-05 (Coremail) with SMTP id zQCowAD3_Hw3oTVnichrAg--.252S2;
	Thu, 14 Nov 2024 15:05:28 +0800 (CST)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5c9454f3bfaso340710a12.2;
        Wed, 13 Nov 2024 23:05:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVaClMpUzWeckG9A5famETwLzloI19usFh2fNzVRkFW1al+r9KFWqzZFh09wsXx9sirJZfDIlTszA5AgpUa@vger.kernel.org, AJvYcCVj0zeBpSwrxiuEvW/K2gD00I+qx/1K6tBh39zMruREwXVEQvIwcoHFQBcSfYX3j+npEliuTZGcKKVIyfQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9ntvZc/UbfuJhNerdDAjtdz3RqFIRfdTLgzJwV3qnGZW87iEn
	WewmQRggBEfZLDTE+J1IpIC1hPVhs2OMqOxCFKLickwq/TH52NGJNl2JdmEMuLgcOZOLzbDMvSu
	lXEytVacessBeSHYR9xZYuKoQjXU=
X-Google-Smtp-Source: AGHT+IFwPozQFCOODafSvUsMBgiiIWegzjsXs0qgVHGEk/lqLIyW2PeQERbppFlGIPxakonLbxUx10yCJ5bKFA0g5SI=
X-Received: by 2002:a05:6402:2105:b0:5cf:466f:d2c1 with SMTP id
 4fb4d7f45d1cf-5cf77e86416mr847420a12.6.1731567926593; Wed, 13 Nov 2024
 23:05:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241113104036.254491-1-zhihang.shao.iscas@gmail.com> <20241113104036.254491-3-zhihang.shao.iscas@gmail.com>
In-Reply-To: <20241113104036.254491-3-zhihang.shao.iscas@gmail.com>
Reply-To: zhangchunyan@iscas.ac.cn
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Date: Thu, 14 Nov 2024 15:04:49 +0800
X-Gmail-Original-Message-ID: <CAOsKWHCK-W72sx94WnVTeAm7mbG2XAgqD9LiLdRDNEfJQ-Ex=w@mail.gmail.com>
Message-ID: <CAOsKWHCK-W72sx94WnVTeAm7mbG2XAgqD9LiLdRDNEfJQ-Ex=w@mail.gmail.com>
Subject: Re: [PATCH 2/2] riscv: Optimize crct10dif with zbc extension
To: Zhihang Shao <zhihang.shao.iscas@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, palmer@dabbelt.com, 
	paul.walmsley@sifive.com, aou@eecs.berkeley.edu, akpm@linux-foundation.org, 
	linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-CM-TRANSID:zQCowAD3_Hw3oTVnichrAg--.252S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Gw13tw4DZFyDtF1fCFy7trb_yoW3Cr47pF
	Wqkrs7KFWUXa47WrWxXr9xXrn8Cw4I9F43Xry7Wa4UJFsrAr40qFZ2ka4vvw48JF4kZrZ2
	9rZ5CrZxCw4DJ37anT9S1TB71UUUUjUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPab7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
	C2z280aVCY1x0267AKxVWxJr0_GcWln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvE
	ncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x
	IIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_
	Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1lc2xSY4AK6IIF6r4xMxAIw28Icx
	kI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E
	5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtV
	W8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY
	1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI
	0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU
	vS4iDUUUU
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBgsBB2c1inVL7QAAsA

On Wed, 13 Nov 2024 at 19:06, Zhihang Shao <zhihang.shao.iscas@gmail.com> wrote:
>
> The current CRC-T10DIF algorithm is based on table-lookup optimization.
> Given the previous work on optimizing crc32 calculations with zbc
> extension, it is believed that this will be equally effective for
> accelerating crc-t10dif.
> Therefore, this patch offers a implementation of crc-t10dif using zbc
> extension. This can detect whether the current runtime environment
> supports zbc feature and, if so, uses it to accelerate crc-t10dif
> calculations.
>
> This patch is tested on QEMU VM with the kernel CRC-T10DIF selftests.
>
> Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>
> ---
>  arch/riscv/crypto/Kconfig               |  14 ++
>  arch/riscv/crypto/Makefile              |   4 +
>  arch/riscv/crypto/crct10dif-riscv-zbc.c | 182 ++++++++++++++++++++++++
>  lib/crct10diftest.c                     |   4 +-
>  4 files changed, 202 insertions(+), 2 deletions(-)
>  create mode 100644 arch/riscv/crypto/crct10dif-riscv-zbc.c
>
> diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
> index ad58dad9a580..69751ff5573e 100644
> --- a/arch/riscv/crypto/Kconfig
> +++ b/arch/riscv/crypto/Kconfig
> @@ -29,6 +29,20 @@ config CRYPTO_CHACHA_RISCV64
>           Architecture: riscv64 using:
>           - Zvkb vector crypto extension
>
> +config CRYPTO_CRCT10DIF_RISCV
> +       tristate "Checksum: CRCT10DIF"
> +       depends on TOOLCHAIN_HAS_ZBC
> +       depends on MMU
> +       depends on RISCV_ALTERNATIVE
> +       default y
> +       help
> +         CRCT10DIF checksum with Zbc extension optimized
> +        To accelerate CRCT10DIF checksum, choose Y here.

This line should be aligned with two characters.

> +
> +         Architecture: riscv using:
> +          - Zbc extension

Same here.

> +
> +

More than one redundant empty line should be removed.

>  config CRYPTO_GHASH_RISCV64
>         tristate "Hash functions: GHASH"
>         depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
> diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
> index 247c7bc7288c..6f849f4dc4cc 100644
> --- a/arch/riscv/crypto/Makefile
> +++ b/arch/riscv/crypto/Makefile
> @@ -7,6 +7,9 @@ aes-riscv64-y := aes-riscv64-glue.o aes-riscv64-zvkned.o \
>  obj-$(CONFIG_CRYPTO_CHACHA_RISCV64) += chacha-riscv64.o
>  chacha-riscv64-y := chacha-riscv64-glue.o chacha-riscv64-zvkb.o
>
> +obj-$(CONFIG_CRYPTO_CRCT10DIF_RISCV) += crct10dif-riscv.o
> +crct10dif-riscv-y := crct10dif-riscv-zbc.o
> +
>  obj-$(CONFIG_CRYPTO_GHASH_RISCV64) += ghash-riscv64.o
>  ghash-riscv64-y := ghash-riscv64-glue.o ghash-riscv64-zvkg.o
>
> @@ -21,3 +24,4 @@ sm3-riscv64-y := sm3-riscv64-glue.o sm3-riscv64-zvksh-zvkb.o
>
>  obj-$(CONFIG_CRYPTO_SM4_RISCV64) += sm4-riscv64.o
>  sm4-riscv64-y := sm4-riscv64-glue.o sm4-riscv64-zvksed-zvkb.o
> +
> diff --git a/arch/riscv/crypto/crct10dif-riscv-zbc.c b/arch/riscv/crypto/crct10dif-riscv-zbc.c
> new file mode 100644
> index 000000000000..01571b4286f1
> --- /dev/null
> +++ b/arch/riscv/crypto/crct10dif-riscv-zbc.c
> @@ -0,0 +1,182 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Accelerated CRC-T10DIF implementation with RISC-V Zbc extension.
> + *
> + * Copyright (C) 2024 Institute of Software, CAS.
> + */
> +
> +#include <asm/alternative-macros.h>
> +#include <asm/byteorder.h>
> +#include <asm/hwcap.h>
> +
> +#include <crypto/internal/hash.h>
> +
> +#include <linux/byteorder/generic.h>
> +#include <linux/crc-t10dif.h>
> +#include <linux/minmax.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +
> +static u16 crc_t10dif_generic_zbc(u16 crc, unsigned char const *p, size_t len);
> +
> +#define CRCT10DIF_POLY 0x8bb7
> +
> +#if __riscv_xlen == 64
> +#define STEP_ORDER 3
> +
> +#define CRCT10DIF_POLY_QT_BE 0xf65a57f81d33a48a
> +
> +static inline u64 crct10dif_prep(u16 crc, unsigned long const *ptr)
> +{
> +       return ((u64)crc << 48) ^ (__force u64)__cpu_to_be64(*ptr);
> +}
> +
> +#elif __riscv_xlen == 32
> +#define STEP_ORDER 2
> +#define CRCT10DIF_POLY_QT_BE 0xf65a57f8
> +
> +static inline u32 crct10dif_prep(u16 crc, unsigned long const *ptr)
> +{
> +       return ((u32)crc << 16) ^ (__force u32)__cpu_to_be32(*ptr);
> +}
> +
> +#else
> +#error "Unexpected __riscv_xlen"
> +#endif
> +
> +static inline u16 crct10dif_zbc(unsigned long s)
> +{
> +       u16 crc;
> +
> +       asm volatile   (".option push\n"
> +                       ".option arch,+zbc\n"
> +                       "clmulh %0, %1, %2\n"
> +                       "xor    %0, %0, %1\n"
> +                       "clmul  %0, %0, %3\n"
> +                       ".option pop\n"
> +                       : "=&r" (crc)
> +                       : "r"(s),
> +                         "r"(CRCT10DIF_POLY_QT_BE),
> +                         "r"(CRCT10DIF_POLY)
> +                       :);
> +
> +       return crc;
> +}
> +
> +#define STEP (1 << STEP_ORDER)
> +#define OFFSET_MASK (STEP - 1)
> +
> +static inline u16 crct10dif_unaligned(u16 crc, unsigned char const *p, size_t len)
> +{
> +       size_t bits = len * 8;
> +       unsigned long s = 0;
> +       u16 crc_low = 0;
> +
> +       for (int i = 0; i < len; i++)
> +               s = *p++ | (s << 8);
> +
> +       if (len < sizeof(u16)) {
> +               s ^= crc >> (16 - bits);
> +               crc_low = crc << bits;
> +       } else {
> +               s ^= (unsigned long)crc << (bits - 16);
> +       }
> +
> +       crc = crct10dif_zbc(s);
> +       crc ^= crc_low;
> +
> +       return crc;
> +}
> +
> +static u16 crc_t10dif_generic_zbc(u16 crc, unsigned char const *p, size_t len)
> +{
> +       size_t offset, head_len, tail_len;
> +       unsigned long const *p_ul;
> +       unsigned long s;
> +
> +       offset = (unsigned long)p & OFFSET_MASK;
> +       if (offset && len) {
> +               head_len = min(STEP - offset, len);
> +               crc = crct10dif_unaligned(crc, p, head_len);
> +               p += head_len;
> +               len -= head_len;
> +       }
> +
> +       tail_len = len & OFFSET_MASK;
> +       len = len >> STEP_ORDER;
> +       p_ul = (unsigned long const *)p;
> +
> +       for (int i = 0; i < len; i++) {
> +               s = crct10dif_prep(crc, p_ul);
> +               crc = crct10dif_zbc(s);
> +               p_ul++;
> +       }
> +
> +       p = (unsigned char const *)p_ul;
> +       if (tail_len)
> +               crc = crct10dif_unaligned(crc, p, tail_len);
> +
> +       return crc;
> +}
> +
> +static int crc_t10dif_init(struct shash_desc *desc)
> +{
> +       u16 *crc = shash_desc_ctx(desc);
> +
> +       *crc = 0;
> +
> +       return 0;
> +}
> +
> +static int crc_t10dif_final(struct shash_desc *desc, u8 *out)
> +{
> +       u16 *crc = shash_desc_ctx(desc);
> +
> +       *(u16 *)out = *crc;
> +
> +       return 0;
> +}
> +
> +static int crc_t10dif_update_zbc(struct shash_desc *desc, const u8 *data,
> +                               unsigned int length)
> +{
> +       u16 *crc = shash_desc_ctx(desc);
> +
> +       *crc = crc_t10dif_generic_zbc(*crc, data, length);
> +
> +       return 0;
> +}
> +
> +static struct shash_alg crc_t10dif_alg = {
> +       .digestsize             = CRC_T10DIF_DIGEST_SIZE,
> +       .init                   = crc_t10dif_init,
> +       .update                 = crc_t10dif_update_zbc,
> +       .final                  = crc_t10dif_final,
> +       .descsize               = CRC_T10DIF_DIGEST_SIZE,
> +
> +       .base.cra_name          = "crct10dif",
> +       .base.cra_driver_name   = "crct10dif-riscv-zbc",
> +       .base.cra_priority      = 150,
> +       .base.cra_blocksize     = CRC_T10DIF_BLOCK_SIZE,
> +       .base.cra_module        = THIS_MODULE,
> +};
> +
> +static int __init crc_t10dif_mod_init(void)
> +{
> +       if (riscv_isa_extension_available(NULL, ZBC))
> +               return crypto_register_shash(&crc_t10dif_alg);
> +
> +       return -ENODEV;
> +}
> +
> +static void __exit crc_t10dif_mod_exit(void)
> +{
> +       crypto_unregister_shash(&crc_t10dif_alg);
> +}
> +
> +module_init(crc_t10dif_mod_init);
> +module_exit(crc_t10dif_mod_exit);
> +
> +MODULE_DESCRIPTION("CRC-T10DIF using RISC-V ZBC Extension");
> +MODULE_ALIAS_CRYPTO("crct10dif");
> +MODULE_LICENSE("GPL");
> diff --git a/lib/crct10diftest.c b/lib/crct10diftest.c
> index 9541892eb12c..ac642191e6e8 100644
> --- a/lib/crct10diftest.c
> +++ b/lib/crct10diftest.c
> @@ -666,9 +666,9 @@ static int __init crct10dif_test_init(void)
>
>         local_irq_restore(flags);
>
> -       if (errors)
> +       if (errors)

This change should be removed from this patch.

>                 pr_warn("crct10dif: %d self tests failed\n", errors);
> -       else
> +       else

Same here.

>                 pr_info("crct10dif: self tests passed, processed %d bytes in %lld nsec\n",
>                 bytes, nsec);
>
> --
> 2.34.1
>
>

