Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A481F9EAA;
	Sun,  2 Feb 2025 14:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738506462; cv=none; b=dPFyvibDc0OnO3qYC0d7SwdIGs9JUCnwOUaTYGY4vHMF9NHNA9xXtH/4c6sXUcazO170hJlSQBbnDUxJKRyvgTe7is1lJCGzfR6wqmV2h3Sz+F8xZalwvkuNnZbljNuMqUppbFGX/fPFhzEQ7dZJHtyDgznLI9+NeZD44xGDPfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738506462; c=relaxed/simple;
	bh=b68pz4gOl8YlOvdM1uTxMJG3AplbVLYXqJoL5W41jic=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WGxaFFr9u+6eyPgUkLk0pX++wdhiPiuBUIbQf2RhnE5NMxmhbvOda8LnByIPb1I2SNx+ljIzMq0LDJEN3ZAEUxGC4WMW0EqHxSELH4JMyWvMRh8OeBX9NEn0ovS3zSwBdvdxAac4pUIX3jSInRMcwJtrGeIFfaUWftNN8oiZ9go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zo6JEpD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zo6JEpD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C59C4CED1;
	Sun,  2 Feb 2025 14:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738506462;
	bh=b68pz4gOl8YlOvdM1uTxMJG3AplbVLYXqJoL5W41jic=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Zo6JEpD0sFPUIRJUsRODi1QdBFGhqw5lQZNgXYIGzNuEju0902ZTlO6nFnKQCog7x
	 IrfsDpr0huQyfrQIppnG/M1GdQJVsNyaaYzelipiArHZdcaph3nwzYvMjsobbZahTO
	 JsUTtY8xSN8rPHWYefYnGFeeqjf6WKizGbdEC5DF9F7qv+9GQjYxzi3b6PWAgZqhvd
	 7SpJyNwVz9iN6622P20H2/81S2Ykcy6BDO3WS5hjvB+KalpdzrSPQe07jbrSZJU3Js
	 tGk/nESp31lfXSZCYRHMvSNax+TQSh/BNXeqhJinXScPNod4mqnlAZzG5UjVJqcup/
	 FMehefVIqeI5g==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5401ab97206so3388349e87.3;
        Sun, 02 Feb 2025 06:27:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV3V17OvMywNBxMkCyQEsT/swoauBj27OZxi3UzJlNxPcsRXddHCEpDW1GQu0j5b3bc06LngXSpUvRMPA==@vger.kernel.org, AJvYcCVcooS8Yq6S7AEpiwGmSoDEXQRXY35KNRZ5EE5hiYeWhLHN33frC5IFZWaNQOmkoOyGeZNI9NVSNKANR0vp@vger.kernel.org
X-Gm-Message-State: AOJu0YwlHF7PqA23Bb6afYa4SKZ19iwITyqEJQNnwbWEt3Cxq3TLm1Rb
	tb9fQlO7hWxH4C+dPkn+G9zhs7sJbBsje/P9Uh32g6xNDvOXDm8sOUXIqsQlcRDUDXOAOtvA5/D
	N08z5+pTDZBkj+JWVkX2ymJnqdws=
X-Google-Smtp-Source: AGHT+IGjO9BT6eyDKkjHcOj+a7ATxahcOZCz4LEUD9rXpB8Rfxf0HbUwA/T09Ey6MbiK5M+d2aYOnZ1x3EljKTxWqFw=
X-Received: by 2002:ac2:4c30:0:b0:542:238d:d714 with SMTP id
 2adb3069b0e04-543e4c31223mr5417185e87.32.1738506460972; Sun, 02 Feb 2025
 06:27:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250130035130.180676-1-ebiggers@kernel.org> <20250130035130.180676-3-ebiggers@kernel.org>
In-Reply-To: <20250130035130.180676-3-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 2 Feb 2025 15:27:29 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGVRKZZ2ou0_3R09j59C+35pj9KadaeMrcn0WhuBbeE5g@mail.gmail.com>
X-Gm-Features: AWEUYZmHANfUdWvTu7dta6n_W-QGYL747qnE_qUdGhGrSjK9pzgoQ_NS5RwbdL0
Message-ID: <CAMj1kXGVRKZZ2ou0_3R09j59C+35pj9KadaeMrcn0WhuBbeE5g@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] crypto: crc64-rocksoft - remove from crypto API
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 30 Jan 2025 at 04:54, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Remove crc64-rocksoft from the crypto API.  It has no known user now
> that the lib is no longer built on top of it.  It was also added much
> more recently than the longstanding crc32 and crc32c.  Unlike crc32 and
> crc32c, crc64-rocksoft is also not mentioned in the dm-integrity
> documentation and there are no references to it in anywhere in the
> cryptsetup git repo, so it is unlikely to have any user there either.
>
> Also, this CRC variant is named incorrectly; it has nothing to do with
> Rocksoft and should be called crc64-nvme.  That is yet another reason to
> remove it from the crypto API; we would not want anyone to start
> depending on the current incorrect algorithm name of crc64-rocksoft.
>
> Note that this change temporarily makes this CRC variant not be covered
> by any tests, as previously it was relying on the crypto self-tests.
> This will be fixed by adding this CRC variant to crc_kunit.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/Kconfig                  | 11 ----
>  crypto/Makefile                 |  1 -
>  crypto/crc64_rocksoft_generic.c | 89 ---------------------------------
>  crypto/testmgr.c                |  7 ---
>  crypto/testmgr.h                | 12 -----
>  include/linux/crc64.h           |  2 -
>  6 files changed, 122 deletions(-)
>  delete mode 100644 crypto/crc64_rocksoft_generic.c
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 74ae5f52b784..9ffb59b1aac3 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1088,21 +1088,10 @@ config CRYPTO_CRCT10DIF
>         help
>           CRC16 CRC algorithm used for the T10 (SCSI) Data Integrity Field (DIF)
>
>           CRC algorithm used by the SCSI Block Commands standard.
>
> -config CRYPTO_CRC64_ROCKSOFT
> -       tristate "CRC64 based on Rocksoft Model algorithm"
> -       depends on CRC64
> -       select CRYPTO_HASH
> -       help
> -         CRC64 CRC algorithm based on the Rocksoft Model CRC Algorithm
> -
> -         Used by the NVMe implementation of T10 DIF (BLK_DEV_INTEGRITY)
> -
> -         See https://zlib.net/crc_v3.txt
> -
>  endmenu
>
>  menu "Compression"
>
>  config CRYPTO_DEFLATE
> diff --git a/crypto/Makefile b/crypto/Makefile
> index f67e853c4690..d3b79b8c9022 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -155,11 +155,10 @@ obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
>  obj-$(CONFIG_CRYPTO_CRC32) += crc32_generic.o
>  CFLAGS_crc32c_generic.o += -DARCH=$(ARCH)
>  CFLAGS_crc32_generic.o += -DARCH=$(ARCH)
>  obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif_generic.o
>  CFLAGS_crct10dif_generic.o += -DARCH=$(ARCH)
> -obj-$(CONFIG_CRYPTO_CRC64_ROCKSOFT) += crc64_rocksoft_generic.o
>  obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
>  obj-$(CONFIG_CRYPTO_LZO) += lzo.o lzo-rle.o
>  obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
>  obj-$(CONFIG_CRYPTO_LZ4HC) += lz4hc.o
>  obj-$(CONFIG_CRYPTO_XXHASH) += xxhash_generic.o
> diff --git a/crypto/crc64_rocksoft_generic.c b/crypto/crc64_rocksoft_generic.c
> deleted file mode 100644
> index ce0f3059b912..000000000000
> --- a/crypto/crc64_rocksoft_generic.c
> +++ /dev/null
> @@ -1,89 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0-only
> -
> -#include <linux/crc64.h>
> -#include <linux/module.h>
> -#include <crypto/internal/hash.h>
> -#include <linux/unaligned.h>
> -
> -static int chksum_init(struct shash_desc *desc)
> -{
> -       u64 *crc = shash_desc_ctx(desc);
> -
> -       *crc = 0;
> -
> -       return 0;
> -}
> -
> -static int chksum_update(struct shash_desc *desc, const u8 *data,
> -                        unsigned int length)
> -{
> -       u64 *crc = shash_desc_ctx(desc);
> -
> -       *crc = crc64_rocksoft_generic(*crc, data, length);
> -
> -       return 0;
> -}
> -
> -static int chksum_final(struct shash_desc *desc, u8 *out)
> -{
> -       u64 *crc = shash_desc_ctx(desc);
> -
> -       put_unaligned_le64(*crc, out);
> -       return 0;
> -}
> -
> -static int __chksum_finup(u64 crc, const u8 *data, unsigned int len, u8 *out)
> -{
> -       crc = crc64_rocksoft_generic(crc, data, len);
> -       put_unaligned_le64(crc, out);
> -       return 0;
> -}
> -
> -static int chksum_finup(struct shash_desc *desc, const u8 *data,
> -                       unsigned int len, u8 *out)
> -{
> -       u64 *crc = shash_desc_ctx(desc);
> -
> -       return __chksum_finup(*crc, data, len, out);
> -}
> -
> -static int chksum_digest(struct shash_desc *desc, const u8 *data,
> -                        unsigned int length, u8 *out)
> -{
> -       return __chksum_finup(0, data, length, out);
> -}
> -
> -static struct shash_alg alg = {
> -       .digestsize     =       sizeof(u64),
> -       .init           =       chksum_init,
> -       .update         =       chksum_update,
> -       .final          =       chksum_final,
> -       .finup          =       chksum_finup,
> -       .digest         =       chksum_digest,
> -       .descsize       =       sizeof(u64),
> -       .base           =       {
> -               .cra_name               =       CRC64_ROCKSOFT_STRING,
> -               .cra_driver_name        =       "crc64-rocksoft-generic",
> -               .cra_priority           =       200,
> -               .cra_blocksize          =       1,
> -               .cra_module             =       THIS_MODULE,
> -       }
> -};
> -
> -static int __init crc64_rocksoft_init(void)
> -{
> -       return crypto_register_shash(&alg);
> -}
> -
> -static void __exit crc64_rocksoft_exit(void)
> -{
> -       crypto_unregister_shash(&alg);
> -}
> -
> -module_init(crc64_rocksoft_init);
> -module_exit(crc64_rocksoft_exit);
> -
> -MODULE_LICENSE("GPL");
> -MODULE_DESCRIPTION("Rocksoft model CRC64 calculation.");
> -MODULE_ALIAS_CRYPTO("crc64-rocksoft");
> -MODULE_ALIAS_CRYPTO("crc64-rocksoft-generic");
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index e61490ba4095..0c1c3a6453b6 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -4757,17 +4757,10 @@ static const struct alg_test_desc alg_test_descs[] = {
>                 .test = alg_test_crc32c,
>                 .fips_allowed = 1,
>                 .suite = {
>                         .hash = __VECS(crc32c_tv_template)
>                 }
> -       }, {
> -               .alg = "crc64-rocksoft",
> -               .test = alg_test_hash,
> -               .fips_allowed = 1,
> -               .suite = {
> -                       .hash = __VECS(crc64_rocksoft_tv_template)
> -               }
>         }, {
>                 .alg = "crct10dif",
>                 .test = alg_test_hash,
>                 .fips_allowed = 1,
>                 .suite = {
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index d754ab997186..4ab05046b734 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -6018,22 +6018,10 @@ static const struct hash_testvec rmd160_tv_template[] = {
>  };
>
>  static const u8 zeroes[4096] = { [0 ... 4095] = 0 };
>  static const u8 ones[4096] = { [0 ... 4095] = 0xff };
>
> -static const struct hash_testvec crc64_rocksoft_tv_template[] = {
> -       {
> -               .plaintext      = zeroes,
> -               .psize          = 4096,
> -               .digest         = "\x4e\xb6\x22\xeb\x67\xd3\x82\x64",
> -       }, {
> -               .plaintext      = ones,
> -               .psize          = 4096,
> -               .digest         = "\xac\xa3\xec\x02\x73\xba\xdd\xc0",
> -       }
> -};
> -
>  static const struct hash_testvec crct10dif_tv_template[] = {
>         {
>                 .plaintext      = "abc",
>                 .psize          = 3,
>                 .digest         = (u8 *)(u16 []){ 0x443b },
> diff --git a/include/linux/crc64.h b/include/linux/crc64.h
> index 0a595b272166..7880aeab69d6 100644
> --- a/include/linux/crc64.h
> +++ b/include/linux/crc64.h
> @@ -5,12 +5,10 @@
>  #ifndef _LINUX_CRC64_H
>  #define _LINUX_CRC64_H
>
>  #include <linux/types.h>
>
> -#define CRC64_ROCKSOFT_STRING "crc64-rocksoft"
> -
>  u64 __pure crc64_be(u64 crc, const void *p, size_t len);
>  u64 __pure crc64_rocksoft_generic(u64 crc, const void *p, size_t len);
>
>  /**
>   * crc64_rocksoft_update - Calculate bitwise Rocksoft CRC64
> --
> 2.48.1
>
