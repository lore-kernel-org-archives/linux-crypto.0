From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 5/6] [CRYPTO] cryptd: Add software async crypto daemon
Date: Tue, 1 May 2007 18:23:29 +0400
Message-ID: <20070501142329.GA3490@2ka.mipt.ru>
References: <<20070416105105.GA10188@gondor.apana.org.au>> <E1HdOom-0002uK-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:45338 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423600AbXEAOY7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 May 2007 10:24:59 -0400
Content-Disposition: inline
In-Reply-To: <E1HdOom-0002uK-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 16, 2007 at 08:52:20PM +1000, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> [CRYPTO] cryptd: Add software async crypto daemon
> 
> This patch adds the cryptd module which is a template that takes a
> synchronous software crypto algorithm and converts it to an asynchronous
> one by executing it in a kernel thread.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Hi.

I have a question about alloc/free callback of the template structure
below.

> +static int cryptd_blkcipher_init_tfm(struct crypto_tfm *tfm)
> +{
> +	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
> +	struct cryptd_instance_ctx *ictx = crypto_instance_ctx(inst);
> +	struct crypto_spawn *spawn = &ictx->spawn;
> +	struct cryptd_blkcipher_ctx *ctx = crypto_tfm_ctx(tfm);
> +	struct crypto_blkcipher *cipher;
> +
> +	cipher = crypto_spawn_blkcipher(spawn);
> +	if (IS_ERR(cipher))
> +		return PTR_ERR(cipher);
> +
> +	ctx->child = cipher;
> +	tfm->crt_ablkcipher.reqsize =
> +		sizeof(struct cryptd_blkcipher_request_ctx);
> +	return 0;
> +}
> +
> +static void cryptd_blkcipher_exit_tfm(struct crypto_tfm *tfm)
> +{
> +	struct cryptd_blkcipher_ctx *ctx = crypto_tfm_ctx(tfm);
> +	struct cryptd_state *state = cryptd_get_state(tfm);
> +	int active;
> +
> +	mutex_lock(&state->mutex);
> +	active = ablkcipher_tfm_in_queue(__crypto_ablkcipher_cast(tfm));
> +	mutex_unlock(&state->mutex);
> +
> +	BUG_ON(active);
> +
> +	crypto_free_blkcipher(ctx->child);
> +}
> +
> +static struct crypto_instance *cryptd_alloc_instance(struct crypto_alg *alg,
> +						     struct cryptd_state *state)
> +{
> +	struct crypto_instance *inst;
> +	struct cryptd_instance_ctx *ctx;
> +	int err;
> +
> +	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
> +	if (IS_ERR(inst))
> +		goto out;
> +
> +	err = -ENAMETOOLONG;
> +	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
> +		     "cryptd(%s)", alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
> +		goto out_free_inst;
> +
> +	ctx = crypto_instance_ctx(inst);
> +	err = crypto_init_spawn(&ctx->spawn, alg, inst,
> +				CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
> +	if (err)
> +		goto out_free_inst;
> +
> +	ctx->state = state;
> +
> +	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
> +
> +	inst->alg.cra_priority = alg->cra_priority + 50;
> +	inst->alg.cra_blocksize = alg->cra_blocksize;
> +	inst->alg.cra_alignmask = alg->cra_alignmask;
> +
> +out:
> +	return inst;
> +
> +out_free_inst:
> +	kfree(inst);
> +	inst = ERR_PTR(err);
> +	goto out;
> +}
> +
> +static struct crypto_instance *cryptd_alloc_blkcipher(
> +	struct rtattr **tb, struct cryptd_state *state)
> +{
> +	struct crypto_instance *inst;
> +	struct crypto_alg *alg;
> +
> +	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_BLKCIPHER,
> +				  CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
> +	if (IS_ERR(alg))
> +		return ERR_PTR(PTR_ERR(alg));
> +
> +	inst = cryptd_alloc_instance(alg, state);
> +	if (IS_ERR(inst))
> +		goto out_put_alg;
> +
> +	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_ASYNC;
> +	inst->alg.cra_type = &crypto_ablkcipher_type;
> +
> +	inst->alg.cra_ablkcipher.ivsize = alg->cra_blkcipher.ivsize;
> +	inst->alg.cra_ablkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
> +	inst->alg.cra_ablkcipher.max_keysize = alg->cra_blkcipher.max_keysize;
> +
> +	inst->alg.cra_ctxsize = sizeof(struct cryptd_blkcipher_ctx);
> +
> +	inst->alg.cra_init = cryptd_blkcipher_init_tfm;
> +	inst->alg.cra_exit = cryptd_blkcipher_exit_tfm;
> +
> +	inst->alg.cra_ablkcipher.setkey = cryptd_blkcipher_setkey;
> +	inst->alg.cra_ablkcipher.encrypt = cryptd_blkcipher_encrypt_enqueue;
> +	inst->alg.cra_ablkcipher.decrypt = cryptd_blkcipher_decrypt_enqueue;
> +
> +	inst->alg.cra_ablkcipher.queue = &state->queue;
> +
> +out_put_alg:
> +	crypto_mod_put(alg);
> +	return inst;
> +}
> +
> +static struct cryptd_state state;
> +
> +static struct crypto_instance *cryptd_alloc(struct rtattr **tb)
> +{
> +	struct crypto_attr_type *algt;
> +
> +	algt = crypto_get_attr_type(tb);
> +	if (IS_ERR(algt))
> +		return ERR_PTR(PTR_ERR(algt));
> +
> +	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
> +	case CRYPTO_ALG_TYPE_BLKCIPHER:
> +		return cryptd_alloc_blkcipher(tb, &state);
> +	}
> +
> +	return ERR_PTR(-EINVAL);
> +}

As far as I understand, this callback is called each time new tfm is
going to be created? And it is called for each crypto_template
registered in the system, so it is task of the template to detect that
requested cypher tb[crypto_alg-1] is not supported by template.
Am I correct?
If so, could it be better to have set of flags for template which would
show which operations are supported?
For example HIFH adapter can not perform blowfish encryption, but it
will be requested to do so each time new tfm is being requested, if my
analysis correct...

Herbert, please clarify this issue.

-- 
	Evgeniy Polyakov
