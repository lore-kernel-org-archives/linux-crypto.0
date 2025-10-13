Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AE422ACF3
	for <linux-crypto@vger.kernel.org>; Mon, 13 Oct 2025 13:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760363882; cv=none; b=NrGfsu6Ju4MRA3SQ/cnHYN7XInLnw7Ns1l5XanuCgoJj/FgFjeBUNf+SfI8kfXfTgeq746T4Wz+JPnuDfb9ZJwzHjig5hQJYlQMfL1al/GjXDjWv3CikJOqD6NcdA/JUAkDFM9+ZOU5SXMWW/V9Tb6uX6KOTvlFDxSt7jC7O8b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760363882; c=relaxed/simple;
	bh=waS865E6bqXcU1VE4aJwF36kRCl6/EgWQPDYxLLng+4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=R6pZLKLDCIN2REsUuqLFZE/U4WG3mIdApMza4WnxFYzh2cFDMaCqrvPnB6mojXfQUdd9n+KbsSbUz48/1g0PbtfHciPnlONXpvsl69wV+bZioXZpOztf6Ce+6tIqIegnbA3Ot4Mh39tTbV8DuK6zjt+jCazXk9Lzds1N6eK+zio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YjapUdia; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YjapUdia"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760363879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ug6vjiQB8LIOrKeXrNBaHRXjW10rowXCs/eREvHpayA=;
	b=YjapUdiaRqD19OMbkWrjg2F0V1b3L0YdzDAzF9x2ciE/uMEfpWbGrNU708CtFKtoWmlBRb
	uD2Fh/5QhzxbU+yYzSIhJ9VzZoaPXHj/np+K/WJbfTelopmNLs+GC7O2IdlNwqTAtMxtSr
	QQ/vaYjmubhdMLAI/XRv+QTa72LQfRU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-351-Yy3Aw7iDMi-RWkg-ZcAlqw-1; Mon,
 13 Oct 2025 09:57:55 -0400
X-MC-Unique: Yy3Aw7iDMi-RWkg-ZcAlqw-1
X-Mimecast-MFC-AGG-ID: Yy3Aw7iDMi-RWkg-ZcAlqw_1760363874
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D0EE1800581;
	Mon, 13 Oct 2025 13:57:54 +0000 (UTC)
Received: from [10.44.32.107] (unknown [10.44.32.107])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4AB830002CE;
	Mon, 13 Oct 2025 13:57:52 +0000 (UTC)
Date: Mon, 13 Oct 2025 15:57:49 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, linux-crypto@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-crypt: Use MD5 library instead of crypto_shash
In-Reply-To: <20251011181042.81455-1-ebiggers@kernel.org>
Message-ID: <c9bbfa17-a219-9c74-02a1-1e10a95f8f46@redhat.com>
References: <20251011181042.81455-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

OK.

I accepted the patch.

Mikulas



On Sat, 11 Oct 2025, Eric Biggers wrote:

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
>  	depends on (TRUSTED_KEYS || TRUSTED_KEYS=n)
>  	select CRC32
>  	select CRYPTO
>  	select CRYPTO_CBC
>  	select CRYPTO_ESSIV
> +	select CRYPTO_LIB_MD5 # needed by lmk IV mode
>  	help
>  	  This device-mapper target allows you to create a device that
>  	  transparently encrypts the data on it. You'll need to activate
>  	  the ciphers you're going to use in the cryptoapi configuration.
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
>  	int shift;
>  };
>  
>  #define LMK_SEED_SIZE 64 /* hash + 0 */
>  struct iv_lmk_private {
> -	struct crypto_shash *hash_tfm;
>  	u8 *seed;
>  };
>  
>  #define TCW_WHITENING_SIZE 16
>  struct iv_tcw_private {
> @@ -463,14 +463,10 @@ static int crypt_iv_null_gen(struct crypt_config *cc, u8 *iv,
>  
>  static void crypt_iv_lmk_dtr(struct crypt_config *cc)
>  {
>  	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
>  
> -	if (lmk->hash_tfm && !IS_ERR(lmk->hash_tfm))
> -		crypto_free_shash(lmk->hash_tfm);
> -	lmk->hash_tfm = NULL;
> -
>  	kfree_sensitive(lmk->seed);
>  	lmk->seed = NULL;
>  }
>  
>  static int crypt_iv_lmk_ctr(struct crypt_config *cc, struct dm_target *ti,
> @@ -481,26 +477,24 @@ static int crypt_iv_lmk_ctr(struct crypt_config *cc, struct dm_target *ti,
>  	if (cc->sector_size != (1 << SECTOR_SHIFT)) {
>  		ti->error = "Unsupported sector size for LMK";
>  		return -EINVAL;
>  	}
>  
> -	lmk->hash_tfm = crypto_alloc_shash("md5", 0,
> -					   CRYPTO_ALG_ALLOCATES_MEMORY);
> -	if (IS_ERR(lmk->hash_tfm)) {
> -		ti->error = "Error initializing LMK hash";
> -		return PTR_ERR(lmk->hash_tfm);
> +	if (fips_enabled) {
> +		ti->error = "LMK support is disabled due to FIPS";
> +		/* ... because it uses MD5. */
> +		return -EINVAL;
>  	}
>  
>  	/* No seed in LMK version 2 */
>  	if (cc->key_parts == cc->tfms_count) {
>  		lmk->seed = NULL;
>  		return 0;
>  	}
>  
>  	lmk->seed = kzalloc(LMK_SEED_SIZE, GFP_KERNEL);
>  	if (!lmk->seed) {
> -		crypt_iv_lmk_dtr(cc);
>  		ti->error = "Error kmallocing seed storage in LMK";
>  		return -ENOMEM;
>  	}
>  
>  	return 0;
> @@ -512,11 +506,11 @@ static int crypt_iv_lmk_init(struct crypt_config *cc)
>  	int subkey_size = cc->key_size / cc->key_parts;
>  
>  	/* LMK seed is on the position of LMK_KEYS + 1 key */
>  	if (lmk->seed)
>  		memcpy(lmk->seed, cc->key + (cc->tfms_count * subkey_size),
> -		       crypto_shash_digestsize(lmk->hash_tfm));
> +		       MD5_DIGEST_SIZE);
>  
>  	return 0;
>  }
>  
>  static int crypt_iv_lmk_wipe(struct crypt_config *cc)
> @@ -527,99 +521,71 @@ static int crypt_iv_lmk_wipe(struct crypt_config *cc)
>  		memset(lmk->seed, 0, LMK_SEED_SIZE);
>  
>  	return 0;
>  }
>  
> -static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
> -			    struct dm_crypt_request *dmreq,
> -			    u8 *data)
> +static void crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
> +			     struct dm_crypt_request *dmreq, u8 *data)
>  {
>  	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
> -	SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
> -	union {
> -		struct md5_state md5state;
> -		u8 state[CRYPTO_MD5_STATESIZE];
> -	} u;
> +	struct md5_ctx ctx;
>  	__le32 buf[4];
> -	int i, r;
>  
> -	desc->tfm = lmk->hash_tfm;
> -
> -	r = crypto_shash_init(desc);
> -	if (r)
> -		return r;
> +	md5_init(&ctx);
>  
> -	if (lmk->seed) {
> -		r = crypto_shash_update(desc, lmk->seed, LMK_SEED_SIZE);
> -		if (r)
> -			return r;
> -	}
> +	if (lmk->seed)
> +		md5_update(&ctx, lmk->seed, LMK_SEED_SIZE);
>  
>  	/* Sector is always 512B, block size 16, add data of blocks 1-31 */
> -	r = crypto_shash_update(desc, data + 16, 16 * 31);
> -	if (r)
> -		return r;
> +	md5_update(&ctx, data + 16, 16 * 31);
>  
>  	/* Sector is cropped to 56 bits here */
>  	buf[0] = cpu_to_le32(dmreq->iv_sector & 0xFFFFFFFF);
>  	buf[1] = cpu_to_le32((((u64)dmreq->iv_sector >> 32) & 0x00FFFFFF) | 0x80000000);
>  	buf[2] = cpu_to_le32(4024);
>  	buf[3] = 0;
> -	r = crypto_shash_update(desc, (u8 *)buf, sizeof(buf));
> -	if (r)
> -		return r;
> +	md5_update(&ctx, (u8 *)buf, sizeof(buf));
>  
>  	/* No MD5 padding here */
> -	r = crypto_shash_export(desc, &u.md5state);
> -	if (r)
> -		return r;
> -
> -	for (i = 0; i < MD5_HASH_WORDS; i++)
> -		__cpu_to_le32s(&u.md5state.hash[i]);
> -	memcpy(iv, &u.md5state.hash, cc->iv_size);
> -
> -	return 0;
> +	cpu_to_le32_array(ctx.state.h, ARRAY_SIZE(ctx.state.h));
> +	memcpy(iv, ctx.state.h, cc->iv_size);
>  }
>  
>  static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
>  			    struct dm_crypt_request *dmreq)
>  {
>  	struct scatterlist *sg;
>  	u8 *src;
> -	int r = 0;
>  
>  	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
>  		sg = crypt_get_sg_data(cc, dmreq->sg_in);
>  		src = kmap_local_page(sg_page(sg));
> -		r = crypt_iv_lmk_one(cc, iv, dmreq, src + sg->offset);
> +		crypt_iv_lmk_one(cc, iv, dmreq, src + sg->offset);
>  		kunmap_local(src);
>  	} else
>  		memset(iv, 0, cc->iv_size);
> -
> -	return r;
> +	return 0;
>  }
>  
>  static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
>  			     struct dm_crypt_request *dmreq)
>  {
>  	struct scatterlist *sg;
>  	u8 *dst;
> -	int r;
>  
>  	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
>  		return 0;
>  
>  	sg = crypt_get_sg_data(cc, dmreq->sg_out);
>  	dst = kmap_local_page(sg_page(sg));
> -	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + sg->offset);
> +	crypt_iv_lmk_one(cc, iv, dmreq, dst + sg->offset);
>  
>  	/* Tweak the first block of plaintext sector */
> -	if (!r)
> -		crypto_xor(dst + sg->offset, iv, cc->iv_size);
> +	crypto_xor(dst + sg->offset, iv, cc->iv_size);
>  
>  	kunmap_local(dst);
> -	return r;
> +	return 0;
>  }
>  
>  static void crypt_iv_tcw_dtr(struct crypt_config *cc)
>  {
>  	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
> 
> base-commit: 8bd9238e511d02831022ff0270865c54ccc482d6
> -- 
> 2.51.0
> 

