From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v9 4/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Sun, 17 May 2015 10:45:08 +0200
Message-ID: <20150517104508.468b032f@bbrezillon>
References: <1431608341-10936-1-git-send-email-clabbe.montjoie@gmail.com>
	<1431608341-10936-5-git-send-email-clabbe.montjoie@gmail.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
 ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
 maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
 herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
 akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org,
 mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org,
 devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBF5K4GVAKGQELUONYQA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1431608341-10936-5-git-send-email-clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Hi Corentin,

I started to review this new version, and I still think there's
something wrong with the way your processing crypto requests.
>From my POV this is not asynchronous at all (see my comments inline),
but maybe Herbert can confirm that.
I haven't reviewed the hash part yet, but I guess it has the same
problem.

Best Regards,

Boris

On Thu, 14 May 2015 14:59:01 +0200
LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Add support for the Security System included in Allwinner SoC A20.
> The Security System is a hardware cryptographic accelerator that support:
> - MD5 and SHA1 hash algorithms
> - AES block cipher in CBC/ECB mode with 128/196/256bits keys.
> - DES and 3DES block cipher in CBC/ECB mode
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---

[...]

> +
> +int sun4i_ss_aes_poll(struct ablkcipher_request *areq, u32 mode)
> +{
> +	u32 spaces;
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
> +	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
> +	struct sun4i_ss_ctx *ss = op->ss;
> +	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
> +	/* when activating SS, the default FIFO space is 32 */
> +	u32 rx_cnt = 32;
> +	u32 tx_cnt = 0;
> +	u32 v;
> +	int i, sgnum, err = 0;
> +	unsigned int ileft = areq->nbytes;
> +	unsigned int oleft = areq->nbytes;
> +	unsigned int todo, miter_flag;
> +	unsigned long flags;
> +	struct sg_mapping_iter mi, mo;
> +	unsigned int oi, oo; /* offset for in and out */
> +
> +	if (areq->nbytes == 0)
> +		return 0;
> +
> +	if (areq->info == NULL) {
> +		dev_err(ss->dev, "ERROR: Empty IV\n");
> +		return -EINVAL;
> +	}
> +
> +	if (areq->src == NULL || areq->dst == NULL) {
> +		dev_err(ss->dev, "ERROR: Some SGs are NULL\n");
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_irqsave(&ss->slock, flags);

Do you really need to take this lock so early ?
BTW, what is this lock protecting ?

IMHO, taking a spinlock and disabling irqs for the whole time you're
executing a crypto request is not a good idea (it will prevent all
other irqs from running, and potentially introduce latencies in other
parts of the kernel).

What you can do though is declare the following fields in your crypto
engine struct (sun4i_ss_ctx):
- a crypto request queue (struct crypto_queue [1])
- a crypto_async_request variable storing the request being processed
- a lock protecting the queue and the current request variable

This way you'll only have to take the lock when queuing or dequeuing a
request.

Another comment, your implementation does not seem to be asynchronous at
all: you're blocking the caller until its crypto request is complete.


> +
> +	for (i = 0; i < op->keylen; i += 4)
> +		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
> +
> +	if (areq->info != NULL) {
> +		for (i = 0; i < 4 && i < ivsize / 4; i++) {
> +			v = *(u32 *)(areq->info + i * 4);
> +			writel(v, ss->base + SS_IV0 + i * 4);
> +		}
> +	}
> +	writel(mode, ss->base + SS_CTL);
> +
> +	sgnum = sg_nents(areq->src);
> +	if (sgnum == 1)
> +		miter_flag = SG_MITER_FROM_SG | SG_MITER_ATOMIC;
> +	else
> +		miter_flag = SG_MITER_FROM_SG;


Why is the ATOMIC flag depending on the number of sg elements.
IMO it should only depends on the context you're currently in, and in
your specific case, you're always in atomic context since you've taken
a spinlock (and disabled irqs) a few lines above.

Note that with the approach I previously proposed, you can even get rid
of this ATMIC flag (or always set it depending on the context you're in
when dequeuing the crypto requests).


> +	sg_miter_start(&mi, areq->src, sgnum, miter_flag);
> +	sgnum = sg_nents(areq->dst);
> +	if (sgnum == 1)
> +		miter_flag = SG_MITER_TO_SG | SG_MITER_ATOMIC;
> +	else
> +		miter_flag = SG_MITER_TO_SG;

Ditto

> +	sg_miter_start(&mo, areq->dst, sgnum, miter_flag);
> +	sg_miter_next(&mi);
> +	sg_miter_next(&mo);
> +	if (mi.addr == NULL || mo.addr == NULL) {
> +		err = -EINVAL;
> +		goto release_ss;
> +	}
> +
> +	ileft = areq->nbytes / 4;
> +	oleft = areq->nbytes / 4;
> +	oi = 0;
> +	oo = 0;
> +	do {
> +		todo = min3(rx_cnt, ileft, (mi.length - oi) / 4);
> +		if (todo > 0) {
> +			ileft -= todo;
> +			writesl(ss->base + SS_RXFIFO, mi.addr + oi, todo);

Is there anything guaranteeing that your pointer is aligned on a 4 byte
boundary ? If that's not the case, I guess you should copy it in a
temporary variable before using writesl.

> +			oi += todo * 4;
> +		}
> +		if (oi == mi.length) {
> +			sg_miter_next(&mi);
> +			oi = 0;
> +		}
> +
> +		ispaces = readl_relaxed(ss->base + SS_FCSR);

Is there a good reason for using the _relaxed version of readl/writel
(the same comment applies a few lines below) ?

> +		rx_cnt = SS_RXFIFO_SPACES(spaces);
> +		tx_cnt = SS_TXFIFO_SPACES(spaces);
> +
> +		todo = min3(tx_cnt, oleft, (mo.length - oo) / 4);
> +		if (todo > 0) {
> +			oleft -= todo;
> +			readsl(ss->base + SS_TXFIFO, mo.addr + oo, todo);
> +			oo += todo * 4;
> +		}
> +		if (oo == mo.length) {
> +			sg_miter_next(&mo);
> +			oo = 0;
> +		}
> +	} while (mo.length > 0);
> +
> +release_ss:
> +	sg_miter_stop(&mi);
> +	sg_miter_stop(&mo);
> +	writel_relaxed(0, ss->base + SS_CTL);

Ditto.

> +	spin_unlock_irqrestore(&ss->slock, flags);
> +	return err;
> +}
> +
> +/* Pure CPU driven way of doing DES/3DES with SS */
> +int sun4i_ss_des_poll(struct ablkcipher_request *areq, u32 mode)
> +{
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
> +	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
> +	struct sun4i_ss_ctx *ss = op->ss;
> +	int i, err = 0;
> +	int no_chunk = 1;
> +	struct scatterlist *in_sg = areq->src;
> +	struct scatterlist *out_sg = areq->dst;
> +	u8 kkey[256 / 8];
> +
> +	if (areq->nbytes == 0)
> +		return 0;
> +
> +	if (areq->info == NULL) {
> +		dev_err(ss->dev, "ERROR: Empty IV\n");
> +		return -EINVAL;
> +	}
> +
> +	if (areq->src == NULL || areq->dst == NULL) {
> +		dev_err(ss->dev, "ERROR: Some SGs are NULL\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * if we have only SGs with size multiple of 4,
> +	 * we can use the SS AES function
> +	 */
> +	while (in_sg != NULL && no_chunk == 1) {
> +		if ((in_sg->length % 4) != 0)
> +			no_chunk = 0;
> +		in_sg = sg_next(in_sg);
> +	}
> +	while (out_sg != NULL && no_chunk == 1) {
> +		if ((out_sg->length % 4) != 0)
> +			no_chunk = 0;
> +		out_sg = sg_next(out_sg);
> +	}
> +
> +	if (no_chunk == 1)
> +		return sun4i_ss_aes_poll(areq, mode);
> +
> +	/*
> +	 * if some SG are not multiple of 4bytes use a fallback
> +	 * it is much easy and clean
> +	 */

Hm, is this really the best solution. I mean, you can easily pack
values from non aligned sg buffers so that you have only a 4 byte
aligned buffers.
Moreover, by doing this you'll end up with a single
sun4i_ss_ablkcipher_poll function.

BTW, I wonder if there's anything preventing an AES crypto request to be
forged the same way DES/3DES requests are (sg entries not aligned on 4
bytes boundary).

> +	ablkcipher_request_set_tfm(areq, op->fallback);
> +	for (i = 0; i < op->keylen; i++)
> +		*(u32 *)(kkey + i * 4) = op->key[i];
> +
> +	err = crypto_ablkcipher_setkey(op->fallback, kkey, op->keylen);
> +	if (err != 0) {
> +		dev_err(ss->dev, "Cannot set key on fallback\n");
> +		return -EINVAL;
> +	}
> +
> +	if ((mode & SS_DECRYPTION) == SS_DECRYPTION)
> +		err = crypto_ablkcipher_decrypt(areq);
> +	else
> +		err = crypto_ablkcipher_encrypt(areq);
> +	ablkcipher_request_set_tfm(areq, tfm);
> +	return err;
> +}

[1]http://lxr.free-electrons.com/source/include/crypto/algapi.h#L68

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
