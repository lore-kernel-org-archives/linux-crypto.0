Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E528230EF8E
	for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 07:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760428616; cv=none; b=OSotz5aRV48LR8uXtjGtDHUVNahyBaDuzcULNr0TrA5rQUIaDOcecRazBpRbH8AXvMek/LI3snHrO0dtE6z87tjdC6BSKTfg4lJ9M1hD4ja8zsZ0nEaGUkGTwB5IMkJ7PV7x8j1setxPuGxSKZAFDLcZiJZyc4KAtcDsrcwHt6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760428616; c=relaxed/simple;
	bh=HqlST6K2De28+6l86LJo5BPQeNoDe1k9DAGZfoveF4w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rTuwv5PEEHdqoQpbmOJhJM6R1K3So431Be8XMvwSmWv/K+eAhLx5bqyw+cI0qE8NVnfK1WpO21nDlU3Yzd3Rn2gnr3ZQJ5JcrGjv9cIEIcITsfiLKDvie31N+Ldzt4KswOXf9+VFzB8KCIgSRcvlDy8VTVZ/xXgkWdaudxDtQc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSQr/gEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSQr/gEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76986C4CEE7
	for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 07:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760428615;
	bh=HqlST6K2De28+6l86LJo5BPQeNoDe1k9DAGZfoveF4w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GSQr/gEjSLEE8HrING1QOEHhOH9lHU3UO5BIesuRsBCbPZvRZ8CrKcQVvv9pAimI2
	 nlg8v2/+bDFq8wPnLSq3rEJMl9d5yXyGMgtbhdTwoRP+nWeS1mcHlTbkY35YzCBhkU
	 K+FORe1eXEeS0F+xBiHdEvZ8BHYY0zd7LVY1ifsPCoPMm2a51ipjodnSUeubkJatDT
	 flBG7Lp9bTtcvBwJytLxP3VQdvKXy3zjnIrcsOOxRkk3syG9hoFH71UY0r0CHVFs/y
	 OBYI4Twf0RT83u/RaAx59CFGCC+AndGUaXfDPPcARalB/h20oRBUyRyps3+m1mD+17
	 LCJ6h8wbhzk/g==
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-64990f4dba2so1554426eaf.1
        for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 00:56:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWMc7/7ait0e+QoSeKplaKVH5t2M0cg50e/JQoVd5qp9MW+iEg7rIBNYnmcGB90+1W0BNLcGv0Vp6x7Qpw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7vEdbjaY4B+GWkt6poUXYHWZWWF9LDOzeRtCscFShj+0EDgO0
	wnYDOhzwjml0s4zwGqLZxMPB8WvI/cYkECZr5RlwHzMiTz8Th5O8J2FkVnweCYdn0z5dncsk4RJ
	e+w7w2emu306jCZNkOeGZYrIPtLTsRL8=
X-Google-Smtp-Source: AGHT+IF7XbVsQ4RGuMoC5pI3a1fn4/FBEUKQy5vF6YknAaziROGF/og9vUmOmyPE5c4FCDw3ng1vnNzWT4gAVDBPBSs=
X-Received: by 2002:a05:6871:82a:b0:343:486f:3280 with SMTP id
 586e51a60fabf-3c11a14bb64mr10509658fac.18.1760428614763; Tue, 14 Oct 2025
 00:56:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251011181042.81455-1-ebiggers@kernel.org>
In-Reply-To: <20251011181042.81455-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 14 Oct 2025 09:56:41 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHigpu+V3qHyLO8+KrqH84LL1bUNjN4d9eO8v9pXbqOUQ@mail.gmail.com>
X-Gm-Features: AS18NWCteqVh0EC00vi9zR8Tz_iV1k3vUpKzxEZHpLyrD1V6UjP13a2YQSE5aUI
Message-ID: <CAMj1kXHigpu+V3qHyLO8+KrqH84LL1bUNjN4d9eO8v9pXbqOUQ@mail.gmail.com>
Subject: Re: [PATCH] dm-crypt: Use MD5 library instead of crypto_shash
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 11 Oct 2025 at 20:12, Eric Biggers <ebiggers@kernel.org> wrote:
>
> The lmk IV mode, which dm-crypt supports for Loop-AES compatibility,
> involves an MD5 computation.  Update its implementation to use the MD5
> library API instead of crypto_shash.  This has many benefits, such as:
>
> - Simpler code.  Notably, much of the error-handling code is no longer
>   needed, since the library functions can't fail.
>
> - Reduced stack usage.  crypt_iv_lmk_one() now allocates only 112 bytes
>   on the stack instead of 520 bytes.
>
> - The library functions are strongly typed, preventing bugs like
>   https://lore.kernel.org/r/f1625ddc-e82e-4b77-80c2-dc8e45b54848@gmail.com
>
> - Slightly improved performance, as the library provides direct access
>   to the MD5 code without unnecessary overhead such as indirect calls.
>
> To preserve the existing behavior of lmk support being disabled when the
> kernel is booted with "fips=1", make crypt_iv_lmk_ctr() check
> fips_enabled itself.  Previously it relied on crypto_alloc_shash("md5")
> failing.  (I don't know for sure that lmk *actually* needs to be
> disallowed in FIPS mode; this just preserves the existing behavior.)
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  drivers/md/Kconfig    |  1 +
>  drivers/md/dm-crypt.c | 76 ++++++++++++-------------------------------
>  2 files changed, 22 insertions(+), 55 deletions(-)
>
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 104aa53550905..dcd232a2ca244 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -297,10 +297,11 @@ config DM_CRYPT
>         depends on (TRUSTED_KEYS || TRUSTED_KEYS=n)
>         select CRC32
>         select CRYPTO
>         select CRYPTO_CBC
>         select CRYPTO_ESSIV
> +       select CRYPTO_LIB_MD5 # needed by lmk IV mode
>         help
>           This device-mapper target allows you to create a device that
>           transparently encrypts the data on it. You'll need to activate
>           the ciphers you're going to use in the cryptoapi configuration.
>
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 5ef43231fe77f..04a553529dc27 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -19,10 +19,11 @@
>  #include <linux/blk-integrity.h>
>  #include <linux/crc32.h>
>  #include <linux/mempool.h>
>  #include <linux/slab.h>
>  #include <linux/crypto.h>
> +#include <linux/fips.h>
>  #include <linux/workqueue.h>
>  #include <linux/kthread.h>
>  #include <linux/backing-dev.h>
>  #include <linux/atomic.h>
>  #include <linux/scatterlist.h>
> @@ -118,11 +119,10 @@ struct iv_benbi_private {
>         int shift;
>  };
>
>  #define LMK_SEED_SIZE 64 /* hash + 0 */
>  struct iv_lmk_private {
> -       struct crypto_shash *hash_tfm;
>         u8 *seed;
>  };
>
>  #define TCW_WHITENING_SIZE 16
>  struct iv_tcw_private {
> @@ -463,14 +463,10 @@ static int crypt_iv_null_gen(struct crypt_config *cc, u8 *iv,
>
>  static void crypt_iv_lmk_dtr(struct crypt_config *cc)
>  {
>         struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
>
> -       if (lmk->hash_tfm && !IS_ERR(lmk->hash_tfm))
> -               crypto_free_shash(lmk->hash_tfm);
> -       lmk->hash_tfm = NULL;
> -
>         kfree_sensitive(lmk->seed);
>         lmk->seed = NULL;
>  }
>
>  static int crypt_iv_lmk_ctr(struct crypt_config *cc, struct dm_target *ti,
> @@ -481,26 +477,24 @@ static int crypt_iv_lmk_ctr(struct crypt_config *cc, struct dm_target *ti,
>         if (cc->sector_size != (1 << SECTOR_SHIFT)) {
>                 ti->error = "Unsupported sector size for LMK";
>                 return -EINVAL;
>         }
>
> -       lmk->hash_tfm = crypto_alloc_shash("md5", 0,
> -                                          CRYPTO_ALG_ALLOCATES_MEMORY);
> -       if (IS_ERR(lmk->hash_tfm)) {
> -               ti->error = "Error initializing LMK hash";
> -               return PTR_ERR(lmk->hash_tfm);
> +       if (fips_enabled) {
> +               ti->error = "LMK support is disabled due to FIPS";
> +               /* ... because it uses MD5. */
> +               return -EINVAL;
>         }
>
>         /* No seed in LMK version 2 */
>         if (cc->key_parts == cc->tfms_count) {
>                 lmk->seed = NULL;
>                 return 0;
>         }
>
>         lmk->seed = kzalloc(LMK_SEED_SIZE, GFP_KERNEL);
>         if (!lmk->seed) {
> -               crypt_iv_lmk_dtr(cc);
>                 ti->error = "Error kmallocing seed storage in LMK";
>                 return -ENOMEM;
>         }
>
>         return 0;
> @@ -512,11 +506,11 @@ static int crypt_iv_lmk_init(struct crypt_config *cc)
>         int subkey_size = cc->key_size / cc->key_parts;
>
>         /* LMK seed is on the position of LMK_KEYS + 1 key */
>         if (lmk->seed)
>                 memcpy(lmk->seed, cc->key + (cc->tfms_count * subkey_size),
> -                      crypto_shash_digestsize(lmk->hash_tfm));
> +                      MD5_DIGEST_SIZE);
>
>         return 0;
>  }
>
>  static int crypt_iv_lmk_wipe(struct crypt_config *cc)
> @@ -527,99 +521,71 @@ static int crypt_iv_lmk_wipe(struct crypt_config *cc)
>                 memset(lmk->seed, 0, LMK_SEED_SIZE);
>
>         return 0;
>  }
>
> -static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
> -                           struct dm_crypt_request *dmreq,
> -                           u8 *data)
> +static void crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
> +                            struct dm_crypt_request *dmreq, u8 *data)
>  {
>         struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
> -       SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
> -       union {
> -               struct md5_state md5state;
> -               u8 state[CRYPTO_MD5_STATESIZE];
> -       } u;
> +       struct md5_ctx ctx;
>         __le32 buf[4];
> -       int i, r;
>
> -       desc->tfm = lmk->hash_tfm;
> -
> -       r = crypto_shash_init(desc);
> -       if (r)
> -               return r;
> +       md5_init(&ctx);
>
> -       if (lmk->seed) {
> -               r = crypto_shash_update(desc, lmk->seed, LMK_SEED_SIZE);
> -               if (r)
> -                       return r;
> -       }
> +       if (lmk->seed)
> +               md5_update(&ctx, lmk->seed, LMK_SEED_SIZE);
>
>         /* Sector is always 512B, block size 16, add data of blocks 1-31 */
> -       r = crypto_shash_update(desc, data + 16, 16 * 31);
> -       if (r)
> -               return r;
> +       md5_update(&ctx, data + 16, 16 * 31);
>
>         /* Sector is cropped to 56 bits here */
>         buf[0] = cpu_to_le32(dmreq->iv_sector & 0xFFFFFFFF);
>         buf[1] = cpu_to_le32((((u64)dmreq->iv_sector >> 32) & 0x00FFFFFF) | 0x80000000);
>         buf[2] = cpu_to_le32(4024);
>         buf[3] = 0;
> -       r = crypto_shash_update(desc, (u8 *)buf, sizeof(buf));
> -       if (r)
> -               return r;
> +       md5_update(&ctx, (u8 *)buf, sizeof(buf));
>
>         /* No MD5 padding here */
> -       r = crypto_shash_export(desc, &u.md5state);
> -       if (r)
> -               return r;
> -
> -       for (i = 0; i < MD5_HASH_WORDS; i++)
> -               __cpu_to_le32s(&u.md5state.hash[i]);
> -       memcpy(iv, &u.md5state.hash, cc->iv_size);
> -
> -       return 0;
> +       cpu_to_le32_array(ctx.state.h, ARRAY_SIZE(ctx.state.h));
> +       memcpy(iv, ctx.state.h, cc->iv_size);
>  }
>
>  static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
>                             struct dm_crypt_request *dmreq)
>  {
>         struct scatterlist *sg;
>         u8 *src;
> -       int r = 0;
>
>         if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
>                 sg = crypt_get_sg_data(cc, dmreq->sg_in);
>                 src = kmap_local_page(sg_page(sg));
> -               r = crypt_iv_lmk_one(cc, iv, dmreq, src + sg->offset);
> +               crypt_iv_lmk_one(cc, iv, dmreq, src + sg->offset);
>                 kunmap_local(src);
>         } else
>                 memset(iv, 0, cc->iv_size);
> -
> -       return r;
> +       return 0;
>  }
>
>  static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
>                              struct dm_crypt_request *dmreq)
>  {
>         struct scatterlist *sg;
>         u8 *dst;
> -       int r;
>
>         if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
>                 return 0;
>
>         sg = crypt_get_sg_data(cc, dmreq->sg_out);
>         dst = kmap_local_page(sg_page(sg));
> -       r = crypt_iv_lmk_one(cc, iv, dmreq, dst + sg->offset);
> +       crypt_iv_lmk_one(cc, iv, dmreq, dst + sg->offset);
>
>         /* Tweak the first block of plaintext sector */
> -       if (!r)
> -               crypto_xor(dst + sg->offset, iv, cc->iv_size);
> +       crypto_xor(dst + sg->offset, iv, cc->iv_size);
>
>         kunmap_local(dst);
> -       return r;
> +       return 0;
>  }
>
>  static void crypt_iv_tcw_dtr(struct crypt_config *cc)
>  {
>         struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
>
> base-commit: 8bd9238e511d02831022ff0270865c54ccc482d6
> --
> 2.51.0
>
>
