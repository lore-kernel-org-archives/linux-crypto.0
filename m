Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C621AC04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 18:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 955592147A
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 18:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558982386;
	bh=j20f6hN5CaHBqDvB+OYAY/+hcGbLLCgbzvBG03cWyQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=LBZ23zFQD5cOfYEZOj0egDmyTfgdkcmkLItclZG59CoUTMFDXXhu68WX9SRt5axfo
	 MTjAefbaJW7Cv94JrhhsVSD+sjhLNlBAg6IlcHTcs/cdLvhIFJVmiPh2KRMn7ezeiW
	 tEKjX4n2CkJFaPV8M5eTrN/7UQuv461k+mRDgUig=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfE0Sjp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 14:39:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbfE0Sjp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 14:39:45 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26D87208CA;
        Mon, 27 May 2019 18:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558982384;
        bh=j20f6hN5CaHBqDvB+OYAY/+hcGbLLCgbzvBG03cWyQ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1OZVpLFhYWiMKyh1GT2hF3T8sGi5rtnWuRgLDGKYTlFHi/tgulubjuPfE1bGgBJhe
         WQNGByIa5kRzZLFmwc6GJvfPFLe/OESaVjLFCb7pS4CrRdNGRSu9DyrOmZGrbKY8nO
         a5/JscAO6VFyN8HGGw6qzAKEKmm1AU/V54B1iN2A=
Date:   Mon, 27 May 2019 11:39:33 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, terrelln@fb.com, jthumshirn@suse.de
Subject: Re: [PATCH] crypto: xxhash - Implement xxhash support
Message-ID: <20190527183932.GA9394@sol.localdomain>
References: <20190527142810.31472-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527142810.31472-1-nborisov@suse.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Nikolay,

On Mon, May 27, 2019 at 05:28:10PM +0300, Nikolay Borisov wrote:
> xxhash is currently implemented as a self-contained module in /lib.
> This patch enables that module to be used as part of the generic kernel
> crypto framework. It adds a simple wrapper to the 64bit version. I've
> also added a couple of simplistic test vectors to ensure I haven't
> screwed up anything doing the plumbing.

What is this planned to be used for?

Please also run the crypto self-tests (i.e. boot a kernel with
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS unset) for all crypto API patches.
When that's done this code immediately crashes, see output below.

More comments below.

	[    0.305235] BUG: unable to handle page fault for address: ffff88817c1966fe
	[    0.306613] #PF: supervisor write access in kernel mode
	[    0.307653] #PF: error_code(0x0002) - not-present page
	[    0.308503] PGD 2a01067 P4D 2a01067 PUD 0 
	[    0.308503] Oops: 0002 [#1] SMP
	[    0.308503] CPU: 3 PID: 59 Comm: cryptomgr_test Not tainted 5.2.0-rc2-00001-g4fcf4df09e23d #3
	[    0.308503] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-20181126_142135-anatol 04/01/2014
	[    0.308503] RIP: 0010:__memcpy+0x12/0x20
	[    0.308503] Code: 8b 43 60 48 2b 43 50 88 43 4e 5b 5d c3 c3 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 48 89 f8 48 89 d1 48 c1 e9 4
	[    0.308503] RSP: 0018:ffffc900006b7ab0 EFLAGS: 00010202
	[    0.308503] RAX: ffff88817c1966fe RBX: ffff88807d1a67d8 RCX: 0000000000202024
	[    0.308503] RDX: 0000000000000002 RSI: ffff88807c996000 RDI: ffff88817c1966fe
	[    0.308503] RBP: ffffc900006b7ad8 R08: ffffffff81c81bf0 R09: 0000000000000000
	[    0.308503] R10: ffff88807c996000 R11: ffffffff81a33fb0 R12: 0000000000000007
	[    0.308503] R13: ffff88807c996000 R14: 0000000000000020 R15: ffffffff81a373c8
	[    0.308503] FS:  0000000000000000(0000) GS:ffff88807fd80000(0000) knlGS:0000000000000000
	[    0.308503] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	[    0.308503] CR2: ffff88817c1966fe CR3: 0000000001c0f000 CR4: 00000000003406e0
	[    0.308503] Call Trace:
	[    0.308503]  ? xxh64_update+0x51/0x1e0
	[    0.308503]  xxhash64_finup+0x18/0x30
	[    0.308503]  xxhash64_digest+0x9/0x10
	[    0.308503]  crypto_shash_digest+0x24/0x40
	[    0.308503]  shash_ahash_digest+0x9a/0xf0
	[    0.308503]  ? shash_ahash_digest+0xf0/0xf0
	[    0.308503]  shash_async_digest+0x19/0x20
	[    0.308503]  crypto_ahash_op+0x24/0x60
	[    0.308503]  crypto_ahash_digest+0x16/0x20
	[    0.308503]  do_ahash_op.constprop.12+0x10/0x40
	[    0.308503]  test_hash_vec_cfg+0x205/0x610
	[    0.308503]  ? _raw_spin_unlock+0x11/0x30
	[    0.308503]  ? sprintf+0x56/0x70
	[    0.308503]  __alg_test_hash.isra.8+0x115/0x1d0
	[    0.308503]  alg_test_hash+0x7b/0x100
	[    0.308503]  alg_test+0xb6/0x375
	[    0.308503]  ? __kthread_parkme+0x5c/0x90
	[    0.308503]  ? lockdep_hardirqs_on+0xf6/0x190
	[    0.308503]  ? _raw_spin_unlock_irqrestore+0x44/0x50
	[    0.308503]  ? trace_hardirqs_on+0x22/0xf0
	[    0.308503]  ? __kthread_parkme+0x2a/0x90
	[    0.308503]  cryptomgr_test+0x26/0x40
	[    0.308503]  kthread+0x124/0x140
	[    0.308503]  ? cryptomgr_probe+0xd0/0xd0
	[    0.308503]  ? __kthread_create_on_node+0x1c0/0x1c0
	[    0.308503]  ret_from_fork+0x24/0x30
	[    0.308503] CR2: ffff88817c1966fe
	[    0.308503] ---[ end trace 3ee93ad10b0b79d0 ]---

> diff --git a/crypto/xxhash_generic.c b/crypto/xxhash_generic.c
> new file mode 100644
> index 000000000000..aedaabe55d45
> --- /dev/null
> +++ b/crypto/xxhash_generic.c
> @@ -0,0 +1,112 @@
> +#include <crypto/internal/hash.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/xxhash.h>
> +
> +#define XXHASH_BLOCK_SIZE	1

This should be set to 32 bytes (the "stripe size" of xxhash64), to match the
size of the chunks in which the algorithm processes data.  I.e., if you pass 31
bytes to xxhash64 it just buffers them, without doing any real work yet.

A "block size" of 1 is only appropriate for algorithms like CRC whose simplest
mathematical description operates directly on bytes.

> +#define XXHASH64_DIGEST_SIZE	8
> +
> +struct xxhash64_crypto_ctx {
> +	u64 seed;
> +};

To make it clearer what kind of "context" this is, please name this
"xxhash64_tfm_ctx", not "xxhash64_crypto_ctx".

Similarly, name the variables "tctx" instead of "cctx".

> +
> +struct xxhash64_desc_ctx {
> +	struct xxh64_state xxhstate;
> +	u64 seed;
> +};
> +
> +static int xxhash64_init(struct shash_desc *desc)
> +{
> +	struct xxhash64_crypto_ctx *cctx = crypto_shash_ctx(desc->tfm);
> +	struct xxhash64_desc_ctx *dctx = shash_desc_ctx(desc);
> +
> +	dctx->seed = cctx->seed;
> +	xxh64_reset(&dctx->xxhstate, dctx->seed);
> +
> +	return 0;
> +}

What's the point of storing 'seed' in the desc_ctx, given that it's already
represented in the initialized 'xxhstate'?

> +
> +static int xxhash64_setkey(struct crypto_shash *tfm, const u8 *key,
> +			 unsigned int keylen)
> +{
> +	struct xxhash64_crypto_ctx *ctx = crypto_shash_ctx(tfm);
> +
> +	if (keylen != sizeof(ctx->seed)) {
> +		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		return -EINVAL;
> +	}
> +	ctx->seed = *(u64 *)key;
> +	return 0;
> +}

The crypto API takes the "key" as a byte array which might be unaligned.  Also,
the sequence of "key" bytes is conventionally interpreted the same way on all
architectures, e.g. it's not endian-dependent.  So, I suggest:

	ctx->seed = get_unaligned_le64(key);

Note that without this fix, your test vectors are wrong on big endian CPUs.

> +
> +static int xxhash64_update(struct shash_desc *desc, const u8 *data,
> +			 unsigned int length)
> +{
> +	struct xxhash64_desc_ctx *ctx = shash_desc_ctx(desc);
> +
> +	xxh64_update(&ctx->xxhstate, data, length);
> +
> +	return 0;
> +}
> +
> +static int xxhash64_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct xxhash64_desc_ctx *ctx = shash_desc_ctx(desc);
> +
> +	*(u64 *)out = xxh64_digest(&ctx->xxhstate);
> +
> +	return 0;
> +}

Similarly, the 'out' array might be misaligned.  And conventionally the same
bytes are output on all architectures.  So I suggest:

	put_unaligned_u64(xxh64_digest(&ctx->xxhstate), out);

> +
> +static int xxhash64_finup(struct shash_desc *desc, const u8 *data,
> +			unsigned int len, u8 *out)
> +{
> +	xxhash64_update(desc, data, len);
> +	xxhash64_final(desc, out);
> +
> +	return 0;
> +}
> +
> +static int xxhash64_digest(struct shash_desc *desc, const u8 *data,
> +			 unsigned int length, u8 *out)
> +{
> +	return xxhash64_finup(desc, data, length, out);
> +}
> +

It seems that xxhash64_digest() is forgetting to initialize the hash state.

> +static struct shash_alg alg = {
> +	.digestsize		=	XXHASH64_DIGEST_SIZE,
> +	.setkey			= xxhash64_setkey,

Please use consistent indentation.

> +	.init		=	xxhash64_init,
> +	.update		=	xxhash64_update,
> +	.final		=	xxhash64_final,
> +	.finup		=	xxhash64_finup,
> +	.digest		=	xxhash64_digest,
> +	.descsize		=	sizeof(struct xxhash64_desc_ctx),
> +	.base			=	{
> +		.cra_name		=	"xxhash64",
> +		.cra_driver_name	=	"xxhash64-generic",
> +		.cra_priority		=	100,
> +		.cra_flags		=	CRYPTO_ALG_OPTIONAL_KEY,
> +		.cra_blocksize		=	XXHASH_BLOCK_SIZE,
> +		.cra_ctxsize		=	sizeof(struct xxhash64_crypto_ctx),
> +		.cra_module		=	THIS_MODULE,
> +	}
> +};
> +
> +static int __init xxhash_mod_init(void)
> +{
> +	return crypto_register_shash(&alg);
> +}
> +
> +static void __exit xxhash_mod_fini(void)
> +{
> +	crypto_unregister_shash(&alg);
> +}
> +
> +module_init(xxhash_mod_init);
> +module_exit(xxhash_mod_fini);
> +
> +MODULE_AUTHOR("Nikolay Borisov <nborisov@suse.com>");
> +MODULE_DESCRIPTION("xxhash  calculations wrapper for lib/xxhash.c");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_CRYPTO("xxhash-generic");

The purpose of MODULE_ALIAS_CRYPTO() is to allow the module to be dynamically
loaded when someone requests the algorithm by name.  So, putting a string here
which doesn't match the algorithm name is wrong.  It should be:

	MODULE_ALIAS_CRYPTO("xxhash64");
	MODULE_ALIAS_CRYPTO("xxhash64-generic");

- Eric
