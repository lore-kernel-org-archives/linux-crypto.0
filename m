Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF14AC04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 19:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94A8920883
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 19:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfE0Tzj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 15:55:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:60910 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726657AbfE0Tzj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 15:55:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 95AC9AD27;
        Mon, 27 May 2019 19:55:37 +0000 (UTC)
Subject: Re: [PATCH] crypto: xxhash - Implement xxhash support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, terrelln@fb.com, jthumshirn@suse.de
References: <20190527142810.31472-1-nborisov@suse.com>
 <20190527183932.GA9394@sol.localdomain>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 mQINBFiKBz4BEADNHZmqwhuN6EAzXj9SpPpH/nSSP8YgfwoOqwrP+JR4pIqRK0AWWeWCSwmZ
 T7g+RbfPFlmQp+EwFWOtABXlKC54zgSf+uulGwx5JAUFVUIRBmnHOYi/lUiE0yhpnb1KCA7f
 u/W+DkwGerXqhhe9TvQoGwgCKNfzFPZoM+gZrm+kWv03QLUCr210n4cwaCPJ0Nr9Z3c582xc
 bCUVbsjt7BN0CFa2BByulrx5xD9sDAYIqfLCcZetAqsTRGxM7LD0kh5WlKzOeAXj5r8DOrU2
 GdZS33uKZI/kZJZVytSmZpswDsKhnGzRN1BANGP8sC+WD4eRXajOmNh2HL4P+meO1TlM3GLl
 EQd2shHFY0qjEo7wxKZI1RyZZ5AgJnSmehrPCyuIyVY210CbMaIKHUIsTqRgY5GaNME24w7h
 TyyVCy2qAM8fLJ4Vw5bycM/u5xfWm7gyTb9V1TkZ3o1MTrEsrcqFiRrBY94Rs0oQkZvunqia
 c+NprYSaOG1Cta14o94eMH271Kka/reEwSZkC7T+o9hZ4zi2CcLcY0DXj0qdId7vUKSJjEep
 c++s8ncFekh1MPhkOgNj8pk17OAESanmDwksmzh1j12lgA5lTFPrJeRNu6/isC2zyZhTwMWs
 k3LkcTa8ZXxh0RfWAqgx/ogKPk4ZxOXQEZetkEyTFghbRH2BIwARAQABtCNOaWtvbGF5IEJv
 cmlzb3YgPG5ib3Jpc292QHN1c2UuY29tPokCOAQTAQIAIgUCWIo48QIbAwYLCQgHAwIGFQgC
 CQoLBBYCAwECHgECF4AACgkQcb6CRuU/KFc0eg/9GLD3wTQz9iZHMFbjiqTCitD7B6dTLV1C
 ddZVlC8Hm/TophPts1bWZORAmYIihHHI1EIF19+bfIr46pvfTu0yFrJDLOADMDH+Ufzsfy2v
 HSqqWV/nOSWGXzh8bgg/ncLwrIdEwBQBN9SDS6aqsglagvwFD91UCg/TshLlRxD5BOnuzfzI
 Leyx2c6YmH7Oa1R4MX9Jo79SaKwdHt2yRN3SochVtxCyafDlZsE/efp21pMiaK1HoCOZTBp5
 VzrIP85GATh18pN7YR9CuPxxN0V6IzT7IlhS4Jgj0NXh6vi1DlmKspr+FOevu4RVXqqcNTSS
 E2rycB2v6cttH21UUdu/0FtMBKh+rv8+yD49FxMYnTi1jwVzr208vDdRU2v7Ij/TxYt/v4O8
 V+jNRKy5Fevca/1xroQBICXsNoFLr10X5IjmhAhqIH8Atpz/89ItS3+HWuE4BHB6RRLM0gy8
 T7rN6ja+KegOGikp/VTwBlszhvfLhyoyjXI44Tf3oLSFM+8+qG3B7MNBHOt60CQlMkq0fGXd
 mm4xENl/SSeHsiomdveeq7cNGpHi6i6ntZK33XJLwvyf00PD7tip/GUj0Dic/ZUsoPSTF/mG
 EpuQiUZs8X2xjK/AS/l3wa4Kz2tlcOKSKpIpna7V1+CMNkNzaCOlbv7QwprAerKYywPCoOSC
 7P25Ag0EWIoHPgEQAMiUqvRBZNvPvki34O/dcTodvLSyOmK/MMBDrzN8Cnk302XfnGlW/YAQ
 csMWISKKSpStc6tmD+2Y0z9WjyRqFr3EGfH1RXSv9Z1vmfPzU42jsdZn667UxrRcVQXUgoKg
 QYx055Q2FdUeaZSaivoIBD9WtJq/66UPXRRr4H/+Y5FaUZx+gWNGmBT6a0S/GQnHb9g3nonD
 jmDKGw+YO4P6aEMxyy3k9PstaoiyBXnzQASzdOi39BgWQuZfIQjN0aW+Dm8kOAfT5i/yk59h
 VV6v3NLHBjHVw9kHli3jwvsizIX9X2W8tb1SefaVxqvqO1132AO8V9CbE1DcVT8fzICvGi42
 FoV/k0QOGwq+LmLf0t04Q0csEl+h69ZcqeBSQcIMm/Ir+NorfCr6HjrB6lW7giBkQl6hhomn
 l1mtDP6MTdbyYzEiBFcwQD4terc7S/8ELRRybWQHQp7sxQM/Lnuhs77MgY/e6c5AVWnMKd/z
 MKm4ru7A8+8gdHeydrRQSWDaVbfy3Hup0Ia76J9FaolnjB8YLUOJPdhI2vbvNCQ2ipxw3Y3c
 KhVIpGYqwdvFIiz0Fej7wnJICIrpJs/+XLQHyqcmERn3s/iWwBpeogrx2Lf8AGezqnv9woq7
 OSoWlwXDJiUdaqPEB/HmGfqoRRN20jx+OOvuaBMPAPb+aKJyle8zABEBAAGJAh8EGAECAAkF
 AliKBz4CGwwACgkQcb6CRuU/KFdacg/+M3V3Ti9JYZEiIyVhqs+yHb6NMI1R0kkAmzsGQ1jU
 zSQUz9AVMR6T7v2fIETTT/f5Oout0+Hi9cY8uLpk8CWno9V9eR/B7Ifs2pAA8lh2nW43FFwp
 IDiSuDbH6oTLmiGCB206IvSuaQCp1fed8U6yuqGFcnf0ZpJm/sILG2ECdFK9RYnMIaeqlNQm
 iZicBY2lmlYFBEaMXHoy+K7nbOuizPWdUKoKHq+tmZ3iA+qL5s6Qlm4trH28/fPpFuOmgP8P
 K+7LpYLNSl1oQUr+WlqilPAuLcCo5Vdl7M7VFLMq4xxY/dY99aZx0ZJQYFx0w/6UkbDdFLzN
 upT7NIN68lZRucImffiWyN7CjH23X3Tni8bS9ubo7OON68NbPz1YIaYaHmnVQCjDyDXkQoKC
 R82Vf9mf5slj0Vlpf+/Wpsv/TH8X32ajva37oEQTkWNMsDxyw3aPSps6MaMafcN7k60y2Wk/
 TCiLsRHFfMHFY6/lq/c0ZdOsGjgpIK0G0z6et9YU6MaPuKwNY4kBdjPNBwHreucrQVUdqRRm
 RcxmGC6ohvpqVGfhT48ZPZKZEWM+tZky0mO7bhZYxMXyVjBn4EoNTsXy1et9Y1dU3HVJ8fod
 5UqrNrzIQFbdeM0/JqSLrtlTcXKJ7cYFa9ZM2AP7UIN9n1UWxq+OPY9YMOewVfYtL8M=
Message-ID: <815b55c9-1322-ac2f-5c25-cfa1e271aaf7@suse.com>
Date:   Mon, 27 May 2019 22:55:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190527183932.GA9394@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 27.05.19 г. 21:39 ч., Eric Biggers wrote:
> Hi Nikolay,
> 
> On Mon, May 27, 2019 at 05:28:10PM +0300, Nikolay Borisov wrote:
>> xxhash is currently implemented as a self-contained module in /lib.
>> This patch enables that module to be used as part of the generic kernel
>> crypto framework. It adds a simple wrapper to the 64bit version. I've
>> also added a couple of simplistic test vectors to ensure I haven't
>> screwed up anything doing the plumbing.
> 
> What is this planned to be used for?

Possibly as a replacement hash of crc32c in btrfs.

> 
> Please also run the crypto self-tests (i.e. boot a kernel with
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS unset) for all crypto API patches.
> When that's done this code immediately crashes, see output below.

Not for me, I tested the vectors I've added for correct results. I
wouldn't have sent the patch otherwise. Strange why I didn't observe
this crash, I wonder if it's due to an unaligned buffer or digest not
initialising the state.

> 
> More comments below.
> 
> 	[    0.305235] BUG: unable to handle page fault for address: ffff88817c1966fe
> 	[    0.306613] #PF: supervisor write access in kernel mode
> 	[    0.307653] #PF: error_code(0x0002) - not-present page
> 	[    0.308503] PGD 2a01067 P4D 2a01067 PUD 0 
> 	[    0.308503] Oops: 0002 [#1] SMP
> 	[    0.308503] CPU: 3 PID: 59 Comm: cryptomgr_test Not tainted 5.2.0-rc2-00001-g4fcf4df09e23d #3
> 	[    0.308503] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-20181126_142135-anatol 04/01/2014
> 	[    0.308503] RIP: 0010:__memcpy+0x12/0x20
> 	[    0.308503] Code: 8b 43 60 48 2b 43 50 88 43 4e 5b 5d c3 c3 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 48 89 f8 48 89 d1 48 c1 e9 4
> 	[    0.308503] RSP: 0018:ffffc900006b7ab0 EFLAGS: 00010202
> 	[    0.308503] RAX: ffff88817c1966fe RBX: ffff88807d1a67d8 RCX: 0000000000202024
> 	[    0.308503] RDX: 0000000000000002 RSI: ffff88807c996000 RDI: ffff88817c1966fe
> 	[    0.308503] RBP: ffffc900006b7ad8 R08: ffffffff81c81bf0 R09: 0000000000000000
> 	[    0.308503] R10: ffff88807c996000 R11: ffffffff81a33fb0 R12: 0000000000000007
> 	[    0.308503] R13: ffff88807c996000 R14: 0000000000000020 R15: ffffffff81a373c8
> 	[    0.308503] FS:  0000000000000000(0000) GS:ffff88807fd80000(0000) knlGS:0000000000000000
> 	[    0.308503] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 	[    0.308503] CR2: ffff88817c1966fe CR3: 0000000001c0f000 CR4: 00000000003406e0
> 	[    0.308503] Call Trace:
> 	[    0.308503]  ? xxh64_update+0x51/0x1e0
> 	[    0.308503]  xxhash64_finup+0x18/0x30
> 	[    0.308503]  xxhash64_digest+0x9/0x10
> 	[    0.308503]  crypto_shash_digest+0x24/0x40
> 	[    0.308503]  shash_ahash_digest+0x9a/0xf0
> 	[    0.308503]  ? shash_ahash_digest+0xf0/0xf0
> 	[    0.308503]  shash_async_digest+0x19/0x20
> 	[    0.308503]  crypto_ahash_op+0x24/0x60
> 	[    0.308503]  crypto_ahash_digest+0x16/0x20
> 	[    0.308503]  do_ahash_op.constprop.12+0x10/0x40
> 	[    0.308503]  test_hash_vec_cfg+0x205/0x610
> 	[    0.308503]  ? _raw_spin_unlock+0x11/0x30
> 	[    0.308503]  ? sprintf+0x56/0x70
> 	[    0.308503]  __alg_test_hash.isra.8+0x115/0x1d0
> 	[    0.308503]  alg_test_hash+0x7b/0x100
> 	[    0.308503]  alg_test+0xb6/0x375
> 	[    0.308503]  ? __kthread_parkme+0x5c/0x90
> 	[    0.308503]  ? lockdep_hardirqs_on+0xf6/0x190
> 	[    0.308503]  ? _raw_spin_unlock_irqrestore+0x44/0x50
> 	[    0.308503]  ? trace_hardirqs_on+0x22/0xf0
> 	[    0.308503]  ? __kthread_parkme+0x2a/0x90
> 	[    0.308503]  cryptomgr_test+0x26/0x40
> 	[    0.308503]  kthread+0x124/0x140
> 	[    0.308503]  ? cryptomgr_probe+0xd0/0xd0
> 	[    0.308503]  ? __kthread_create_on_node+0x1c0/0x1c0
> 	[    0.308503]  ret_from_fork+0x24/0x30
> 	[    0.308503] CR2: ffff88817c1966fe
> 	[    0.308503] ---[ end trace 3ee93ad10b0b79d0 ]---
> 
>> diff --git a/crypto/xxhash_generic.c b/crypto/xxhash_generic.c
>> new file mode 100644
>> index 000000000000..aedaabe55d45
>> --- /dev/null
>> +++ b/crypto/xxhash_generic.c
>> @@ -0,0 +1,112 @@
>> +#include <crypto/internal/hash.h>
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>> +#include <linux/xxhash.h>
>> +
>> +#define XXHASH_BLOCK_SIZE	1
> 
> This should be set to 32 bytes (the "stripe size" of xxhash64), to match the
> size of the chunks in which the algorithm processes data.  I.e., if you pass 31
> bytes to xxhash64 it just buffers them, without doing any real work yet.
> 
> A "block size" of 1 is only appropriate for algorithms like CRC whose simplest
> mathematical description operates directly on bytes.
> 
>> +#define XXHASH64_DIGEST_SIZE	8
>> +
>> +struct xxhash64_crypto_ctx {
>> +	u64 seed;
>> +};
> 
> To make it clearer what kind of "context" this is, please name this
> "xxhash64_tfm_ctx", not "xxhash64_crypto_ctx".
> 
> Similarly, name the variables "tctx" instead of "cctx".

ACK

> 
>> +
>> +struct xxhash64_desc_ctx {
>> +	struct xxh64_state xxhstate;
>> +	u64 seed;
>> +};
>> +
>> +static int xxhash64_init(struct shash_desc *desc)
>> +{
>> +	struct xxhash64_crypto_ctx *cctx = crypto_shash_ctx(desc->tfm);
>> +	struct xxhash64_desc_ctx *dctx = shash_desc_ctx(desc);
>> +
>> +	dctx->seed = cctx->seed;
>> +	xxh64_reset(&dctx->xxhstate, dctx->seed);
>> +
>> +	return 0;
>> +}
> 
> What's the point of storing 'seed' in the desc_ctx, given that it's already
> represented in the initialized 'xxhstate'?

Good point will remove seed in next iteration.

> 
>> +
>> +static int xxhash64_setkey(struct crypto_shash *tfm, const u8 *key,
>> +			 unsigned int keylen)
>> +{
>> +	struct xxhash64_crypto_ctx *ctx = crypto_shash_ctx(tfm);
>> +
>> +	if (keylen != sizeof(ctx->seed)) {
>> +		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
>> +		return -EINVAL;
>> +	}
>> +	ctx->seed = *(u64 *)key;
>> +	return 0;
>> +}
> 
> The crypto API takes the "key" as a byte array which might be unaligned.  Also,
> the sequence of "key" bytes is conventionally interpreted the same way on all
> architectures, e.g. it's not endian-dependent.  So, I suggest:
> 
> 	ctx->seed = get_unaligned_le64(key);

Can it actually be unaligned though, looking at
crypto_shash_setkey->shash_setkey_unaligned it seems that the generic
layer aligns the buffer and passes the aligned one to ->setkey.
> 
> Note that without this fix, your test vectors are wrong on big endian CPUs.
> 
>> +
>> +static int xxhash64_update(struct shash_desc *desc, const u8 *data,
>> +			 unsigned int length)
>> +{
>> +	struct xxhash64_desc_ctx *ctx = shash_desc_ctx(desc);
>> +
>> +	xxh64_update(&ctx->xxhstate, data, length);
>> +
>> +	return 0;
>> +}
>> +
>> +static int xxhash64_final(struct shash_desc *desc, u8 *out)
>> +{
>> +	struct xxhash64_desc_ctx *ctx = shash_desc_ctx(desc);
>> +
>> +	*(u64 *)out = xxh64_digest(&ctx->xxhstate);
>> +
>> +	return 0;
>> +}
> 
> Similarly, the 'out' array might be misaligned.  And conventionally the same
> bytes are output on all architectures.  So I suggest:
> 
> 	put_unaligned_u64(xxh64_digest(&ctx->xxhstate), out);

Fair enough, will fix it in next version.

> 
>> +
>> +static int xxhash64_finup(struct shash_desc *desc, const u8 *data,
>> +			unsigned int len, u8 *out)
>> +{
>> +	xxhash64_update(desc, data, len);
>> +	xxhash64_final(desc, out);
>> +
>> +	return 0;
>> +}
>> +
>> +static int xxhash64_digest(struct shash_desc *desc, const u8 *data,
>> +			 unsigned int length, u8 *out)
>> +{
>> +	return xxhash64_finup(desc, data, length, out);
>> +}
>> +
> 
> It seems that xxhash64_digest() is forgetting to initialize the hash state.
> 
>> +static struct shash_alg alg = {
>> +	.digestsize		=	XXHASH64_DIGEST_SIZE,
>> +	.setkey			= xxhash64_setkey,
> 
> Please use consistent indentation.

This was copy/pasted from crc32c struct but yeah, I admit it looks ugly,
will fix.

> 
>> +	.init		=	xxhash64_init,
>> +	.update		=	xxhash64_update,
>> +	.final		=	xxhash64_final,
>> +	.finup		=	xxhash64_finup,
>> +	.digest		=	xxhash64_digest,
>> +	.descsize		=	sizeof(struct xxhash64_desc_ctx),
>> +	.base			=	{
>> +		.cra_name		=	"xxhash64",
>> +		.cra_driver_name	=	"xxhash64-generic",
>> +		.cra_priority		=	100,
>> +		.cra_flags		=	CRYPTO_ALG_OPTIONAL_KEY,
>> +		.cra_blocksize		=	XXHASH_BLOCK_SIZE,
>> +		.cra_ctxsize		=	sizeof(struct xxhash64_crypto_ctx),
>> +		.cra_module		=	THIS_MODULE,
>> +	}
>> +};
>> +
>> +static int __init xxhash_mod_init(void)
>> +{
>> +	return crypto_register_shash(&alg);
>> +}
>> +
>> +static void __exit xxhash_mod_fini(void)
>> +{
>> +	crypto_unregister_shash(&alg);
>> +}
>> +
>> +module_init(xxhash_mod_init);
>> +module_exit(xxhash_mod_fini);
>> +
>> +MODULE_AUTHOR("Nikolay Borisov <nborisov@suse.com>");
>> +MODULE_DESCRIPTION("xxhash  calculations wrapper for lib/xxhash.c");
>> +MODULE_LICENSE("GPL");
>> +MODULE_ALIAS_CRYPTO("xxhash-generic");
> 
> The purpose of MODULE_ALIAS_CRYPTO() is to allow the module to be dynamically
> loaded when someone requests the algorithm by name.  So, putting a string here
> which doesn't match the algorithm name is wrong.  It should be:
> 
> 	MODULE_ALIAS_CRYPTO("xxhash64");
> 	MODULE_ALIAS_CRYPTO("xxhash64-generic");
> 
> - Eric
> 
