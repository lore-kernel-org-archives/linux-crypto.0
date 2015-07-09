From: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Re: [PATCH v10 4/5] crypto: Add Allwinner Security
 System crypto accelerator
Date: Thu, 9 Jul 2015 08:41:50 +0200
Message-ID: <20150709064150.GA4028@Red>
References: <1436209848-16530-1-git-send-email-clabbe.montjoie@gmail.com>
 <1436209848-16530-5-git-send-email-clabbe.montjoie@gmail.com>
 <20150707134936.GA2958@gondor.apana.org.au>
Reply-To: clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
	maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org,
	joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-sunxi+bncBD7YLCN32UNBBNVP7CWAKGQEX6K2G3I-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150707134936.GA2958-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 07, 2015 at 09:49:36PM +0800, Herbert Xu wrote:
> On Mon, Jul 06, 2015 at 09:10:47PM +0200, LABBE Corentin wrote:
> >
> > +int sun4i_hash_init(struct ahash_request *areq)
> > +{
> > +	const char *hash_type;
> > +	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
> > +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
> > +	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
> > +	struct sun4i_ss_alg_template *algt;
> > +	struct sun4i_ss_ctx *ss;
> > +
> > +	memset(op, 0, sizeof(struct sun4i_req_ctx));
> > +
> > +	algt = container_of(alg, struct sun4i_ss_alg_template, alg.hash);
> > +	ss = algt->ss;
> > +	op->ss = algt->ss;
> > +
> > +	hash_type = crypto_tfm_alg_name(areq->base.tfm);
> > +
> > +	if (strcmp(hash_type, "sha1") == 0)
> > +		op->mode = SS_OP_SHA1;
> > +	else if (strcmp(hash_type, "md5") == 0)
> > +		op->mode = SS_OP_MD5;
> 
> Please store these modes in algt and then you wouldn't need to do
> the strcmp.
> 

thanks, that's better

> > +int sun4i_hash_import_md5(struct ahash_request *areq, const void *in)
> > +{
> > +	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
> > +	const struct md5_state *ictx = in;
> > +	int i;
> 
> You need to initialise op->ss here.  Ditto for SHA.
> 

Ok

> > +	/* get the partial hash only if something was written */
> > +	if (op->mode == SS_OP_SHA1) {
> > +		for (i = 0; i < 5; i++)
> > +			op->hash[i] = readl(ss->base + SS_MD0 + i * 4);
> > +	} else {
> > +		for (i = 0; i < 4; i++)
> > +			op->hash[i] = readl(ss->base + SS_MD0 + i * 4);
> > +	}
> 
> You can avoid the op->mode check by storing the hash size in algt.
> 

It seems that I can use crypto_ahash_digestsize() that do the same thing.

> > +int sun4i_hash_finup(struct ahash_request *areq)
> > +{
> > +	int err;
> > +
> > +	err = sun4i_hash_update(areq);
> > +	if (err != 0)
> > +		return err;
> > +
> > +	return sun4i_hash_final(areq);
> 
> You can drop finup since the API provides a default finup that's
> exactly the same as this.  You only need to provide finup if it
> can optimise on this.
> 
> Ditto for digest.

If I remove digest(), loading the driver crash the kernel with:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 80000007 [#1] PREEMPT SMP ARM
CPU: 0 PID: 10120 Comm: cryptomgr_test Tainted: G            E   4.2.0-rc1+ #78
LR is at crypto_ahash_op+0x30/0x68

For using the default one does I need to do something particular ?

Thanks

LABBE Corentin
