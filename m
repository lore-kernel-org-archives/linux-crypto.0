Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319CBC4363A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 18:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA4DE2222C
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 18:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603736792;
	bh=gybTqJ0jxhz6SPBPfV2ny6/w0HsDcFeLANRpB3SrjT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=WG51Kjg/IgM2k7MsPxo3//WWzSvThN+5ZKpQsm6gR88FIq0NC6Jn6T1NuA5ftsqRc
	 i17BQwGonNf2e41TeezYICf3BzrnPFOObFxpq2pYpV7D0uudsrEEGn/Ub4bA6nMYeV
	 aK4tcUBMRdfMMrjnV/2jMaZ8BdtC2lyQhNCED3J4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1789709AbgJZS0c (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 14:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789657AbgJZS0b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 14:26:31 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80DAE20874;
        Mon, 26 Oct 2020 18:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603736790;
        bh=gybTqJ0jxhz6SPBPfV2ny6/w0HsDcFeLANRpB3SrjT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1803MW6Ms9+aCqQkPsbvfnbuiXZPpwcohNI+9CJZHMm7ySsAEDdNj22URn9yEW8+w
         skoPbxs8WnAHiNomj0SKd5p7oL17WFlEF3a0iZAZwiK5HQ5ZyWJn8Wz1kzjWsUa+Z0
         pflDe0VL8WWHOLnSfnYAEg931OZtGQqGqaU2AoOQ=
Date:   Mon, 26 Oct 2020 11:26:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/4] crypto: add eboiv as a crypto API template
Message-ID: <20201026182628.GI858@sol.localdomain>
References: <20201026130450.6947-1-gilad@benyossef.com>
 <20201026130450.6947-2-gilad@benyossef.com>
 <20201026182448.GH858@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026182448.GH858@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 26, 2020 at 11:24:50AM -0700, Eric Biggers wrote:
> > +static int eboiv_create(struct crypto_template *tmpl, struct rtattr **tb)
> > +{
> > +	struct crypto_attr_type *algt;
> > +	const char *inner_cipher_name;
> > +	struct skcipher_instance *skcipher_inst = NULL;
> > +	struct crypto_instance *inst;
> > +	struct crypto_alg *base, *block_base;
> > +	struct eboiv_instance_ctx *ictx;
> > +	struct skcipher_alg *skcipher_alg = NULL;
> > +	int ivsize;
> > +	u32 mask;
> > +	int err;
> > +
> > +	algt = crypto_get_attr_type(tb);
> > +	if (IS_ERR(algt))
> > +		return PTR_ERR(algt);
> 
> Need to check that the algorithm is being instantiated as skcipher.
> crypto_check_attr_type() should be used.
> 
> > +
> > +	inner_cipher_name = crypto_attr_alg_name(tb[1]);
> > +	if (IS_ERR(inner_cipher_name))
> > +		return PTR_ERR(inner_cipher_name);
> 
> The result of crypto_attr_alg_name() can be passed directly to
> crypto_grab_skcipher().
> 
> > +	mask = crypto_algt_inherited_mask(algt);
> > +
> > +	skcipher_inst = kzalloc(sizeof(*skcipher_inst) + sizeof(*ictx), GFP_KERNEL);
> > +	if (!skcipher_inst)
> > +		return -ENOMEM;
> > +
> > +	inst = skcipher_crypto_instance(skcipher_inst);
> > +	base = &skcipher_inst->alg.base;
> > +	ictx = crypto_instance_ctx(inst);
> > +
> > +	/* Symmetric cipher, e.g., "cbc(aes)" */
> > +	err = crypto_grab_skcipher(&ictx->skcipher_spawn, inst, inner_cipher_name, 0, mask);
> > +	if (err)
> > +		goto out_free_inst;
> > +
> > +	skcipher_alg = crypto_spawn_skcipher_alg(&ictx->skcipher_spawn);
> > +	block_base = &skcipher_alg->base;
> > +	ivsize = crypto_skcipher_alg_ivsize(skcipher_alg);
> > +
> > +	if (ivsize != block_base->cra_blocksize)
> > +		goto out_drop_skcipher;
> 
> Shouldn't it be verified that the underlying algorithm is actually cbc?
> 
> > +	skcipher_inst->alg.chunksize	= crypto_skcipher_alg_chunksize(skcipher_alg);
> > +	skcipher_inst->alg.walksize	= crypto_skcipher_alg_walksize(skcipher_alg);
> 
> Setting these isn't necessary.
> 
> > +
> > +	skcipher_inst->free		= eboiv_skcipher_free_instance;
> > +
> > +	err = skcipher_register_instance(tmpl, skcipher_inst);
> > +
> > +	if (err)
> > +		goto out_drop_skcipher;
> > +
> > +	return 0;
> > +
> > +out_drop_skcipher:
> > +	crypto_drop_skcipher(&ictx->skcipher_spawn);
> > +out_free_inst:
> > +	kfree(skcipher_inst);
> > +	return err;
> > +}
> 
> eboiv_skcipher_free_instance() can be called on the error path.

Here's the version of eboiv_create() I recommend (untested):

static int eboiv_create(struct crypto_template *tmpl, struct rtattr **tb)
{
	struct skcipher_instance *inst;
	struct eboiv_instance_ctx *ictx;
	struct skcipher_alg *alg;
	u32 mask;
	int err;

	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
	if (err)
		return err;

	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
	if (!inst)
		return -ENOMEM;
	ictx = skcipher_instance_ctx(inst);

	err = crypto_grab_skcipher(&ictx->skcipher_spawn,
				   skcipher_crypto_instance(inst),
				   crypto_attr_alg_name(tb[1]), 0, mask);
	if (err)
		goto err_free_inst;
	alg = crypto_spawn_skcipher_alg(&ictx->skcipher_spawn);

	err = -EINVAL;
	if (strncmp(alg->base.cra_name, "cbc(", 4) ||
	    crypto_skcipher_alg_ivsize(alg) != alg->base.cra_blocksize)
		goto err_free_inst;

	err = -ENAMETOOLONG;
	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME, "eboiv(%s)",
		     alg->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
		goto err_free_inst;

	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
		     "eboiv(%s)", alg->base.cra_driver_name) >=
	    CRYPTO_MAX_ALG_NAME)
		goto err_free_inst;

	inst->alg.base.cra_blocksize	= alg->base.cra_blocksize;
	inst->alg.base.cra_ctxsize	= sizeof(struct eboiv_tfm_ctx);
	inst->alg.base.cra_alignmask	= alg->base.cra_alignmask;
	inst->alg.base.cra_priority	= alg->base.cra_priority;

	inst->alg.setkey	= eboiv_skcipher_setkey;
	inst->alg.encrypt	= eboiv_skcipher_encrypt;
	inst->alg.decrypt	= eboiv_skcipher_decrypt;
	inst->alg.init		= eboiv_skcipher_init_tfm;
	inst->alg.exit		= eboiv_skcipher_exit_tfm;

	inst->alg.min_keysize	= crypto_skcipher_alg_min_keysize(alg);
	inst->alg.max_keysize	= crypto_skcipher_alg_max_keysize(alg);
	inst->alg.ivsize	= crypto_skcipher_alg_ivsize(alg);

	inst->free		= eboiv_skcipher_free_instance;

	err = skcipher_register_instance(tmpl, inst);
	if (err) {
err_free_inst:
		eboiv_skcipher_free_instance(inst);
	}
	return err;
}
