From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v10 4/5] crypto: Add Allwinner Security System crypto
 accelerator
Date: Tue, 7 Jul 2015 21:49:36 +0800
Message-ID: <20150707134936.GA2958@gondor.apana.org.au>
References: <1436209848-16530-1-git-send-email-clabbe.montjoie@gmail.com>
 <1436209848-16530-5-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
	davem@davemloft.net, akpm@linux-foundation.org,
	gregkh@linuxfoundation.org, mchehab@osg.samsung.com, arnd@arndb.de,
	joe@perches.com, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-sunxi@googlegroups.com
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436209848-16530-5-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 06, 2015 at 09:10:47PM +0200, LABBE Corentin wrote:
>
> +int sun4i_hash_init(struct ahash_request *areq)
> +{
> +	const char *hash_type;
> +	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
> +	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
> +	struct sun4i_ss_alg_template *algt;
> +	struct sun4i_ss_ctx *ss;
> +
> +	memset(op, 0, sizeof(struct sun4i_req_ctx));
> +
> +	algt = container_of(alg, struct sun4i_ss_alg_template, alg.hash);
> +	ss = algt->ss;
> +	op->ss = algt->ss;
> +
> +	hash_type = crypto_tfm_alg_name(areq->base.tfm);
> +
> +	if (strcmp(hash_type, "sha1") == 0)
> +		op->mode = SS_OP_SHA1;
> +	else if (strcmp(hash_type, "md5") == 0)
> +		op->mode = SS_OP_MD5;

Please store these modes in algt and then you wouldn't need to do
the strcmp.

> +int sun4i_hash_import_md5(struct ahash_request *areq, const void *in)
> +{
> +	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
> +	const struct md5_state *ictx = in;
> +	int i;

You need to initialise op->ss here.  Ditto for SHA.

> +	/* get the partial hash only if something was written */
> +	if (op->mode == SS_OP_SHA1) {
> +		for (i = 0; i < 5; i++)
> +			op->hash[i] = readl(ss->base + SS_MD0 + i * 4);
> +	} else {
> +		for (i = 0; i < 4; i++)
> +			op->hash[i] = readl(ss->base + SS_MD0 + i * 4);
> +	}

You can avoid the op->mode check by storing the hash size in algt.

> +int sun4i_hash_finup(struct ahash_request *areq)
> +{
> +	int err;
> +
> +	err = sun4i_hash_update(areq);
> +	if (err != 0)
> +		return err;
> +
> +	return sun4i_hash_final(areq);

You can drop finup since the API provides a default finup that's
exactly the same as this.  You only need to provide finup if it
can optimise on this.

Ditto for digest.
 
Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
