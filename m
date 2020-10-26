Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF3EC4363A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 18:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BACF420874
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 18:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603736694;
	bh=pZtkwJFSCeODA5g8jJTbVzyl+tkAvkYZ0pQKwAfbKms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=To/xIKzUs1kpE7lZRzoOV7EohiV2rnd3a4lPygKchMrD2foLBRAuf28nwSlJaEu8J
	 miYpiUfBxf3kKH29hwoMFz9Wl60vTH9D91FZrXkWGoqFDKsJDxwRnlYqJAvQ6zGs5i
	 nBcE2HqL0/O5+FDdivwJMwtq/H1l8iPEUOmXtf24=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1784577AbgJZSYy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 14:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789629AbgJZSYu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 14:24:50 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16F6420874;
        Mon, 26 Oct 2020 18:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603736690;
        bh=pZtkwJFSCeODA5g8jJTbVzyl+tkAvkYZ0pQKwAfbKms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MXJnyZULJvfM5FCW2M1yQUmUn+KBASoMKqBil2lhJ3cYxLZshxXex5dWXA8WqdlRH
         VoJsTwJE5pJ51CsHjvHchy9/s9RLsmYwFm3mzjjgiP505mTUI8BbadbVicuPoi7MXL
         DZ5akyCRdHPOAz9q4sw5HbobRbU76zn2EDpoQ3bM=
Date:   Mon, 26 Oct 2020 11:24:48 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/4] crypto: add eboiv as a crypto API template
Message-ID: <20201026182448.GH858@sol.localdomain>
References: <20201026130450.6947-1-gilad@benyossef.com>
 <20201026130450.6947-2-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026130450.6947-2-gilad@benyossef.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 26, 2020 at 03:04:44PM +0200, Gilad Ben-Yossef wrote:
> diff --git a/crypto/eboiv.c b/crypto/eboiv.c
> new file mode 100644
> index 000000000000..467833e89139
> --- /dev/null
> +++ b/crypto/eboiv.c
> @@ -0,0 +1,295 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * EBOIV skcipher template for block encryption
> + *
> + * This template encapsulates the  Encrypted byte-offset IV generation algorithm
> + * used in Bitlocker in CBC mode by dm-crypt, which converts the initial vector
> + * for the skcipher used for block encryption, by encrypting it using the same
> + * skcipher key as encryption key. Usually, the input IV is a 64-bit sector
> + * offset (the byte offset of the start of the sector) in LE representation
> + * zero-padded to the size of the IV, but this * is not assumed by this driver.
> + *
> + * The typical use of this template is to instantiate the skcipher
> + * 'eboiv(cbc(aes))', which is the only instantiation used by
> + * dm-crypt for supporting BitLocker AES-CBC mode as specified in
> + * https://www.jedec.org/sites/default/files/docs/JESD223C.pdf
> + *
> + * Copyright (C) 2020 ARM Limited or its affiliates.
> + * Written by Gilad Ben-Yossef <gilad@benyossef.com>
> + *
> + * Heavily based on:
> + *
> + * ESSIV skcipher and aead template for block encryption
> + * Copyright (c) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
> + *
> + * and
> + *
> + * dm-crypt eboiv code
> + * by Milan Broz <gmazyland@gmail.com> and Ard Biesheuvel <ardb@kernel.org>
> + *
> + */
> +
> +#include <crypto/internal/skcipher.h>
> +#include <crypto/scatterwalk.h>
> +#include <linux/module.h>
> +
> +#include "internal.h"

internal.h shouldn't be included here.

> +
> +struct eboiv_instance_ctx {
> +	struct crypto_skcipher_spawn skcipher_spawn;
> +	char eboiv_cipher_name[CRYPTO_MAX_ALG_NAME];
> +};

The 'eboiv_cipher_name' field isn't used.

> +static void eboiv_skcipher_iv_done(struct crypto_async_request *areq, int err)
> +{
> +	struct eboiv_req_ctx *req_ctx = areq->data;
> +	struct skcipher_request *req = req_ctx->req;
> +	int ret;
> +
> +	if (!err) {
> +
> +		ret = eboiv_skcipher_do_crypt(req, req_ctx->enc);
> +
> +		if ((ret == -EINPROGRESS) || (ret == -EBUSY))
> +			return;
> +	}
> +
> +	skcipher_request_complete(req, err);
> +}

This looks wrong, because if eboiv_skcipher_do_crypt() fails,
skcipher_request_complete() will be called with err=0.

> +static int eboiv_create(struct crypto_template *tmpl, struct rtattr **tb)
> +{
> +	struct crypto_attr_type *algt;
> +	const char *inner_cipher_name;
> +	struct skcipher_instance *skcipher_inst = NULL;
> +	struct crypto_instance *inst;
> +	struct crypto_alg *base, *block_base;
> +	struct eboiv_instance_ctx *ictx;
> +	struct skcipher_alg *skcipher_alg = NULL;
> +	int ivsize;
> +	u32 mask;
> +	int err;
> +
> +	algt = crypto_get_attr_type(tb);
> +	if (IS_ERR(algt))
> +		return PTR_ERR(algt);

Need to check that the algorithm is being instantiated as skcipher.
crypto_check_attr_type() should be used.

> +
> +	inner_cipher_name = crypto_attr_alg_name(tb[1]);
> +	if (IS_ERR(inner_cipher_name))
> +		return PTR_ERR(inner_cipher_name);

The result of crypto_attr_alg_name() can be passed directly to
crypto_grab_skcipher().

> +	mask = crypto_algt_inherited_mask(algt);
> +
> +	skcipher_inst = kzalloc(sizeof(*skcipher_inst) + sizeof(*ictx), GFP_KERNEL);
> +	if (!skcipher_inst)
> +		return -ENOMEM;
> +
> +	inst = skcipher_crypto_instance(skcipher_inst);
> +	base = &skcipher_inst->alg.base;
> +	ictx = crypto_instance_ctx(inst);
> +
> +	/* Symmetric cipher, e.g., "cbc(aes)" */
> +	err = crypto_grab_skcipher(&ictx->skcipher_spawn, inst, inner_cipher_name, 0, mask);
> +	if (err)
> +		goto out_free_inst;
> +
> +	skcipher_alg = crypto_spawn_skcipher_alg(&ictx->skcipher_spawn);
> +	block_base = &skcipher_alg->base;
> +	ivsize = crypto_skcipher_alg_ivsize(skcipher_alg);
> +
> +	if (ivsize != block_base->cra_blocksize)
> +		goto out_drop_skcipher;

Shouldn't it be verified that the underlying algorithm is actually cbc?

> +	skcipher_inst->alg.chunksize	= crypto_skcipher_alg_chunksize(skcipher_alg);
> +	skcipher_inst->alg.walksize	= crypto_skcipher_alg_walksize(skcipher_alg);

Setting these isn't necessary.

> +
> +	skcipher_inst->free		= eboiv_skcipher_free_instance;
> +
> +	err = skcipher_register_instance(tmpl, skcipher_inst);
> +
> +	if (err)
> +		goto out_drop_skcipher;
> +
> +	return 0;
> +
> +out_drop_skcipher:
> +	crypto_drop_skcipher(&ictx->skcipher_spawn);
> +out_free_inst:
> +	kfree(skcipher_inst);
> +	return err;
> +}

eboiv_skcipher_free_instance() can be called on the error path.

> +/* eboiv(cipher_name) */
> +static struct crypto_template eboiv_tmpl = {
> +	.name	= "eboiv",
> +	.create	= eboiv_create,
> +	.module	= THIS_MODULE,
> +};

"cipher_name" => "cbc_cipher_name", since it wraps something like "cbc(aes)",
not "aes".

- Eric
