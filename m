From: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 18:14:58 +0200
Message-ID: <38b2ab8a0704170914h3a766236t47bc7e1c8de67662@mail.gmail.com>
References: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
	 <E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
	 <38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com>
	 <adairbv57s2.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: "Roland Dreier" <rdreier@cisco.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.224]:48354 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031128AbXDQQPB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Apr 2007 12:15:01 -0400
Received: by nz-out-0506.google.com with SMTP id s1so1524193nze
        for <linux-crypto@vger.kernel.org>; Tue, 17 Apr 2007 09:14:58 -0700 (PDT)
In-Reply-To: <adairbv57s2.fsf@cisco.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 4/17/07, Roland Dreier <rdreier@cisco.com> wrote:
>  > Again, my code is faster only because I skip the key loading in
>  > "cia_encrypt" method. Actually the gain is bigger in decryption mode
>  > than in encryption one because I also generate the decryption key for
>  > each block.
>
> I wonder if there's some way you can cache the last caller and reload
> the key lazily (only when it changes).

yes something that allows crypto drivers to detect if the key has
changed would be good.

> Of course without your code it's hard to say...
>

Alright you can find the main part of it below...

----------------------------

struct foo_aes_ctx {
	u8 key[AES_KEY_LENGTH];
};

/*
 *
 */
static inline void set_dir(int dir)
{
	u32 cr = aes_read(AES_CR);
	
	switch (dir) {
	case AES_DIR_ENCRYPT:
		cr |= CR_DIR;
		break;
	case AES_DIR_DECRYPT:
		cr &= ~CR_DIR;
		break;
	default:
		BUG();
	}
	aes_write(cr, AES_CR);
}

static inline void set_key(const char *key)
{
	u32 key0 = be32_to_cpup((const u32 *)(key + 12));
	u32 key1 = be32_to_cpup((const u32 *)(key + 8));
	u32 key2 = be32_to_cpup((const u32 *)(key + 4));
	u32 key3 = be32_to_cpup((const u32 *)(key));

	aes_write(key0, AES_KEY0);
	aes_write(key1, AES_KEY1);
	aes_write(key2, AES_KEY2);
	aes_write(key3, AES_KEY3);
}

/* should take only 11 cycles */
static int gen_dkey(void)
{
	int timeout = 100;

	aes_write(aes_read(AES_CR) | CR_DKEYGEN, AES_CR);

	while (aes_read(AES_CR) & CR_DKEYGEN) {
		if (--timeout == 0)
			return -EIO;
	}
	return 0;
}

static int crypt_block(int dir, u8 *dst, const u8 *src, const char *key)
{
	register u32 acc0 = be32_to_cpup((const u32 *)(src + 12));
	register u32 acc1 = be32_to_cpup((const u32 *)(src + 8));
	register u32 acc2 = be32_to_cpup((const u32 *)(src + 4));
	register u32 acc3 = be32_to_cpup((const u32 *)(src));
	unsigned long flags;

	spin_lock_irqsave(&foo_aes_lock, flags);

	set_key(key);
	set_dir(dir);

	if (dir == AES_DIR_DECRYPT)
		gen_dkey();

	aes_write(acc0, AES_ACC0);
	aes_write(acc1, AES_ACC1);
	aes_write(acc2, AES_ACC2);
	aes_write(acc3, AES_ACC3);

	{
		/* Again, should take only 11 cycles */
		int timeout = 100;

		while (aes_read(AES_CR) & 0x70) {
			if (--timeout == 0)
				return -EIO;
		}
	}

	/* order is important, guess why ? */
	*(u32 *)(dst + 12) = cpu_to_be32(aes_read(AES_ACC0));
	*(u32 *)(dst + 8)  = cpu_to_be32(aes_read(AES_ACC1));
	*(u32 *)(dst + 4)  = cpu_to_be32(aes_read(AES_ACC2));
	*(u32 *)(dst)      = cpu_to_be32(aes_read(AES_ACC3));

	spin_unlock_irqrestore(&foo_aes_lock, flags);

	return 0;
}

/*
 *
 */
static int foo_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int len)
{
	struct foo_aes_ctx *ctx = crypto_tfm_ctx(tfm);
	int rv;

	if (len == AES_KEY_LENGTH) {
		memcpy(ctx->key, key, AES_KEY_LENGTH);
		rv = 0;
	} else {
		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
		rv = -EINVAL;
	}
	return rv;
}

static void foo_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
{
	struct foo_aes_ctx *ctx = crypto_tfm_ctx(tfm);

	BUG_ON(!in);
	BUG_ON(!out);

	crypt_block(AES_DIR_DECRYPT, out, in, ctx->key);
}

static void foo_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
{
	struct foo_aes_ctx *ctx = crypto_tfm_ctx(tfm);

	BUG_ON(!in);
	BUG_ON(!out);

	crypt_block(AES_DIR_ENCRYPT, out, in, ctx->key);
}

static struct crypto_alg foo_alg = {
	.cra_name               = "aes",
	.cra_driver_name	= "aes-128-foo",
	.cra_priority           = 300,
	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
	.cra_blocksize		= AES_MIN_BLOCK_SIZE,
	.cra_ctxsize		= sizeof(struct foo_aes_ctx),
	.cra_module		= THIS_MODULE,
	.cra_list		= LIST_HEAD_INIT(foo_alg.cra_list),
	.cra_u			= {
		.cipher = {
			.cia_min_keysize	=  AES_KEY_LENGTH,
			.cia_max_keysize	=  AES_KEY_LENGTH,
			.cia_setkey		=  foo_setkey,
			.cia_encrypt		=  foo_encrypt,
			.cia_decrypt		=  foo_decrypt
		}
	}
};



-- 
Francis
