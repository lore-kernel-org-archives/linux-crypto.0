Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C7BC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 06:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiA0Gfq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 01:35:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53498 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiA0Gfq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 01:35:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53A67B82159
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 06:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D86C340E4;
        Thu, 27 Jan 2022 06:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643265344;
        bh=TndIVlZCQzs4rK12xm23gVMrjaxMHjx7IqXWW7ULvuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZG0UHcRC96al6rYipz/CRKlZMIXqbPqA6XvQXVdyHpgHzV/2OpPrJkmX0P0D8cYhO
         fk3GEbA9i+gXRHc/wzY26S0F2DQyG/lI7N7BvdmfjaRcijTeCPWlfuUljffbvZyZQw
         VBD/1PRBwRF9CG5HSFOllIN2jejEnT+zNyOjpLRX8r15k3mEKHCS9Ni519fM54w1Z6
         B+yuA+OZEtxgx10AOpvA/KEzxFKcgU84qHJD2E6WqTStd9PQQ9DsGDnLpStODoPBgm
         9m8n8nsEC5RhldEO64K9c9DftIIjzeRZtobp7BOqvugNA51VPcpApFyWflScjjrwYs
         P4QVDytZZ8ByQ==
Date:   Wed, 26 Jan 2022 22:35:42 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH 3/7] crypto: hctr2 - Add HCTR2 support
Message-ID: <YfI9PrAGYc0v9fGg@sol.localdomain>
References: <20220125014422.80552-1-nhuck@google.com>
 <20220125014422.80552-4-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125014422.80552-4-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 24, 2022 at 07:44:18PM -0600, Nathan Huckleberry wrote:
> +static int hctr2_hash_tweak(struct skcipher_request *req, u8 *iv)
> +{

The iv parameter is unnecessary here, since it can be gotten from req->iv.

> +static int hctr2_crypt(struct skcipher_request *req, bool enc)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	const struct hctr2_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
> +	struct hctr2_request_ctx *rctx = skcipher_request_ctx(req);
> +	u8 digest[POLYVAL_DIGEST_SIZE];
> +	int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
> +	int err;
> +
> +	// Requests must be at least one block
> +	if (req->cryptlen < BLOCKCIPHER_BLOCK_SIZE)
> +		return -EINVAL;
> +
> +	scatterwalk_map_and_copy(rctx->first_block, req->src,
> +				 0, BLOCKCIPHER_BLOCK_SIZE, 0);
> +	rctx->bulk_part_src = scatterwalk_ffwd(rctx->sg_src, req->src, BLOCKCIPHER_BLOCK_SIZE);
> +	rctx->bulk_part_dst = scatterwalk_ffwd(rctx->sg_dst, req->dst, BLOCKCIPHER_BLOCK_SIZE);
> +
> +	err = hctr2_hash_tweak(req, req->iv);
> +	if (err)
> +		return err;
> +	err = hctr2_hash_message(req, rctx->bulk_part_src, digest);
> +	if (err)
> +		return err;
> +	crypto_xor(digest, rctx->first_block, BLOCKCIPHER_BLOCK_SIZE);
> +
> +	if (enc)
> +		crypto_cipher_encrypt_one(tctx->blockcipher, rctx->first_block, digest);
> +	else
> +		crypto_cipher_decrypt_one(tctx->blockcipher, rctx->first_block, digest);
> +
> +	crypto_xor(digest, rctx->first_block, BLOCKCIPHER_BLOCK_SIZE);
> +	crypto_xor(digest, tctx->L, BLOCKCIPHER_BLOCK_SIZE);
> +
> +	skcipher_request_set_tfm(&rctx->u.streamcipher_req, tctx->streamcipher);
> +	skcipher_request_set_crypt(&rctx->u.streamcipher_req, rctx->bulk_part_src,
> +				   rctx->bulk_part_dst, bulk_len, digest);
> +	skcipher_request_set_callback(&rctx->u.streamcipher_req,
> +				      req->base.flags,
> +				      hctr2_streamcipher_done, req);
> +	return crypto_skcipher_encrypt(&rctx->u.streamcipher_req) ?:
> +		hctr2_finish(req);
> +}

The IV passed to skcipher_request_set_crypt() above needs to be part of the
request context, not part of the stack frame of this function, in case the xctr
implementation is asynchronous which would cause the stack frame to go out of
scope.  The x86 implementation operates asynchronously when called in a context
where SIMD instructions are unavailable.

Perhaps rctx->first_block can be reused, as it's already in the request context?

Make sure to test your changes with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled,
as that is able to detect this bug (at least when CONFIG_KASAN is also enabled,
which I also highly recommend) since it tests calling the crypto algorithms in a
context where SIMD instructions cannot be used.  Here's the bug report I got:

	BUG: KASAN: stack-out-of-bounds in __crypto_xor+0x29e/0x480 crypto/algapi.c:1005
	Read of size 8 at addr ffffc900006775f8 by task kworker/2:1/41
	CPU: 2 PID: 41 Comm: kworker/2:1 Not tainted 5.17.0-rc1-00071-gb35cef9ae599 #8
	Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.15.0-1 04/01/2014
	Workqueue: cryptd cryptd_queue_worker
	Call Trace:
	 <TASK>
	 show_stack+0x3d/0x3f arch/x86/kernel/dumpstack.c:318
	 __dump_stack lib/dump_stack.c:88 [inline]
	 dump_stack_lvl+0x49/0x5e lib/dump_stack.c:106
	 print_address_description.constprop.0+0x24/0x150 mm/kasan/report.c:255
	 __kasan_report.cold+0x7d/0x11a mm/kasan/report.c:442
	 kasan_report+0x3c/0x50 mm/kasan/report.c:459
	 __asan_report_load8_noabort+0x14/0x20 mm/kasan/report_generic.c:309
	 __crypto_xor+0x29e/0x480 crypto/algapi.c:1005
	 crypto_xor_cpy include/crypto/algapi.h:182 [inline]
	 xctr_crypt+0x1f1/0x2f0 arch/x86/crypto/aesni-intel_glue.c:585
	 crypto_skcipher_encrypt+0xe2/0x150 crypto/skcipher.c:630
	 cryptd_skcipher_encrypt+0x1c2/0x320 crypto/cryptd.c:274
	 cryptd_queue_worker+0xe4/0x160 crypto/cryptd.c:181
	 process_one_work+0x822/0x14e0 kernel/workqueue.c:2307
	 worker_thread+0x590/0xf60 kernel/workqueue.c:2454
	 kthread+0x257/0x2f0 kernel/kthread.c:377
	 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
	 </TASK>
	Memory state around the buggy address:
	 ffffc90000677480: 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1 00
	 ffffc90000677500: 00 00 00 00 00 00 00 00 00 00 f3 f3 f3 f3 f3 00
	>ffffc90000677580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f1
									^
	 ffffc90000677600: f1 f1 f1 00 00 00 f3 f3 f3 f3 f3 00 00 00 00 00
	 ffffc90000677680: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	==================================================================
	alg: skcipher: hctr2(aes-aesni,xctr-aes-aesni,polyval-pclmulqdqni) encryption test failed (wrong result) on test vector 2, cfg="random: use_digest nosimd src_divs=[100.0%@+3830] iv_offset=45"
	------------[ cut here ]------------
	alg: self-tests for hctr2(aes-aesni,xctr-aes-aesni,polyval-pclmulqdqni) (hctr2(aes)) failed (rc=-22)
	WARNING: CPU: 2 PID: 519 at crypto/testmgr.c:5690 alg_test+0x2d9/0x830 crypto/testmgr.c:5690


> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index a3a24aa07492..fa8f33210358 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -4994,6 +4994,12 @@ static const struct alg_test_desc alg_test_descs[] = {
>  		.suite = {
>  			.hash = __VECS(ghash_tv_template)
>  		}
> +	}, {
> +		.alg = "hctr2(aes)",
> +		.test = alg_test_skcipher,

The .generic_driver field should be filled in here to allow the comparison tests
to run, since the default strategy of forming the generic driver name isn't
valid here; it would result in hctr2(aes-generic), which doesn't work.

- Eric
