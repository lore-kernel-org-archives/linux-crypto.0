From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v6 4/4] crypto: Add Allwinner Security System crypto
 accelerator
Date: Thu, 26 Mar 2015 19:31:15 +0100
Message-ID: <20150326193115.5e30a9af@bbrezillon>
References: <1426532482-28830-1-git-send-email-clabbe.montjoie@gmail.com>
	<1426532482-28830-5-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	arnd@arndb.de, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-sunxi@googlegroups.com
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1426532482-28830-5-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Corentin,

Here is a quick review, there surely are a lot of other things I didn't
spot.

On Mon, 16 Mar 2015 20:01:22 +0100
LABBE Corentin <clabbe.montjoie@gmail.com> wrote:

> Add support for the Security System included in Allwinner SoC A20.
> The Security System is a hardware cryptographic accelerator that support:
> - MD5 and SHA1 hash algorithms
> - AES block cipher in CBC mode with 128/196/256bits keys.
> - DES and 3DES block cipher in CBC mode
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---

[...]

> +static int sunxi_ss_cipher(struct ablkcipher_request *areq, u32 mode)
> +{
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
> +	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
> +	const char *cipher_type;
> +	struct sunxi_ss_ctx *ss = op->ss;
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
> +	cipher_type = crypto_tfm_alg_name(crypto_ablkcipher_tfm(tfm));
> +
> +	if (strcmp("cbc(aes)", cipher_type) == 0) {
> +		mode |= SS_OP_AES | SS_CBC | SS_ENABLED | op->keymode;
> +		return sunxi_ss_aes_poll(areq, mode);
> +	}
> +
> +	if (strcmp("cbc(des)", cipher_type) == 0) {
> +		mode |= SS_OP_DES | SS_CBC | SS_ENABLED | op->keymode;
> +		return sunxi_ss_des_poll(areq, mode);
> +	}
> +
> +	if (strcmp("cbc(des3_ede)", cipher_type) == 0) {
> +		mode |= SS_OP_3DES | SS_CBC | SS_ENABLED | op->keymode;
> +		return sunxi_ss_des_poll(areq, mode);
> +	}

Hm, I'm not sure doing these string comparisons in the crypto operation
path is a good idea.
Moreover, you're doing 3 string comparisons, even though only one can
be valid at a time (using 'else if' would have been a bit better).

Anyway, IMHO this function should be split into 3 functions, and
referenced by your alg template definitions.
Something like:

int sunxi_ss_xxx_encrypt(struct ablkcipher_request *areq)
{
	/* put your cipher specific intialization here */

	return sunxi_ss_xxx_poll(areq, SS_ENCRYPTION);
}

int sunxi_ss_xxx_decrypt(struct ablkcipher_request *areq)
{
	/* put your cipher specific intialization here */

	return sunxi_ss_xxx_poll(areq, SS_DECRYPTION);
}


> +
> +int sunxi_ss_cipher_init(struct crypto_tfm *tfm)
> +{
> +	const char *name = crypto_tfm_alg_name(tfm);
> +	struct sunxi_tfm_ctx *op = crypto_tfm_ctx(tfm);
> +	struct crypto_alg *alg = tfm->__crt_alg;
> +	struct sunxi_ss_alg_template *algt;
> +	struct sunxi_ss_ctx *ss;
> +
> +	memset(op, 0, sizeof(struct sunxi_tfm_ctx));
> +
> +	algt = container_of(alg, struct sunxi_ss_alg_template, alg.crypto);
> +	ss = algt->ss;
> +	op->ss = algt->ss;
> +
> +	/* fallback is needed only for DES/3DES */
> +	if (strcmp("cbc(des)", name) == 0 ||
> +			strcmp("cbc(des3_ede)", name) == 0) {
> +		op->fallback = crypto_alloc_ablkcipher(name, 0,
> +				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
> +		if (IS_ERR(op->fallback)) {
> +			dev_err(ss->dev, "ERROR: allocating fallback algo %s\n",
> +					name);
> +			return PTR_ERR(op->fallback);
> +		}
> +	}

Ditto: just create a specific init function for the des case:

int sunxi_ss_cbc_des_init(struct crypto_tfm *tfm)
{
	sunxi_ss_cipher_init(tfm);

	op->fallback = crypto_alloc_ablkcipher(name, 0,
				CRYPTO_ALG_ASYNC |
				CRYPTO_ALG_NEED_FALLBACK);
	if (IS_ERR(op->fallback)) {
		dev_err(ss->dev, "ERROR: allocating fallback algo %s\n",
			name);
		return PTR_ERR(op->fallback);
	}

	return 0;
}


[..]

> +/*
> + * Optimized function for the case where we have only one SG,
> + * so we can use kmap_atomic
> + */
> +static int sunxi_ss_aes_poll_atomic(struct ablkcipher_request *areq)
> +{
> +	u32 spaces;
> +	struct scatterlist *in_sg = areq->src;
> +	struct scatterlist *out_sg = areq->dst;
> +	void *src_addr;
> +	void *dst_addr;
> +	unsigned int ileft = areq->nbytes;
> +	unsigned int oleft = areq->nbytes;
> +	unsigned int todo;
> +	u32 *src32;
> +	u32 *dst32;
> +	u32 rx_cnt = 32;
> +	u32 tx_cnt = 0;
> +	int i;
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
> +	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
> +	struct sunxi_ss_ctx *ss = op->ss;
> +
> +	src_addr = kmap_atomic(sg_page(in_sg)) + in_sg->offset;
> +	if (src_addr == NULL) {
> +		dev_err(ss->dev, "kmap_atomic error for src SG\n");
> +		return -EINVAL;
> +	}
> +
> +	dst_addr = kmap_atomic(sg_page(out_sg)) + out_sg->offset;
> +	if (dst_addr == NULL) {
> +		dev_err(ss->dev, "kmap_atomic error for dst SG\n");
> +		kunmap_atomic(src_addr);
> +		return -EINVAL;
> +	}
> +
> +	src32 = (u32 *)src_addr;
> +	dst32 = (u32 *)dst_addr;
> +	ileft = areq->nbytes / 4;
> +	oleft = areq->nbytes / 4;
> +	i = 0;
> +	do {
> +		if (ileft > 0 && rx_cnt > 0) {
> +			todo = min(rx_cnt, ileft);
> +			ileft -= todo;
> +			writesl(ss->base + SS_RXFIFO, src32, todo);
> +			src32 += todo;
> +		}
> +		if (tx_cnt > 0) {
> +			todo = min(tx_cnt, oleft);
> +			oleft -= todo;
> +			readsl(ss->base + SS_TXFIFO, dst32, todo);
> +			dst32 += todo;
> +		}
> +		spaces = readl(ss->base + SS_FCSR);
> +		rx_cnt = SS_RXFIFO_SPACES(spaces);
> +		tx_cnt = SS_TXFIFO_SPACES(spaces);
> +	} while (oleft > 0);
> +	kunmap_atomic(dst_addr);
> +	kunmap_atomic(src_addr);
> +	return 0;
> +}
> +
> +int sunxi_ss_aes_poll(struct ablkcipher_request *areq, u32 mode)
> +{
> +	u32 spaces;
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
> +	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
> +	struct sunxi_ss_ctx *ss = op->ss;
> +	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
> +	/* when activating SS, the default FIFO space is 32 */
> +	u32 rx_cnt = 32;
> +	u32 tx_cnt = 0;
> +	u32 v;
> +	int i, err = 0;
> +	struct scatterlist *in_sg = areq->src;
> +	struct scatterlist *out_sg = areq->dst;
> +	void *src_addr;
> +	void *dst_addr;
> +	unsigned int ileft = areq->nbytes;
> +	unsigned int oleft = areq->nbytes;
> +	unsigned int sgileft = areq->src->length;
> +	unsigned int sgoleft = areq->dst->length;
> +	unsigned int todo;
> +	u32 *src32;
> +	u32 *dst32;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ss->slock, flags);
> +
> +	for (i = 0; i < op->keylen; i += 4)
> +		writel(*(op->key + i/4), ss->base + SS_KEY0 + i);
> +
> +	if (areq->info != NULL) {
> +		for (i = 0; i < 4 && i < ivsize / 4; i++) {
> +			v = *(u32 *)(areq->info + i * 4);
> +			writel(v, ss->base + SS_IV0 + i * 4);
> +		}
> +	}
> +	writel(mode, ss->base + SS_CTL);
> +
> +	/* If we have only one SG, we can use kmap_atomic */
> +	if (sg_next(in_sg) == NULL && sg_next(out_sg) == NULL) {
> +		err = sunxi_ss_aes_poll_atomic(areq);
> +		goto release_ss;
> +	}
> +
> +	/*
> +	 * If we have more than one SG, we cannot use kmap_atomic since
> +	 * we hold the mapping too long
> +	 */
> +	src_addr = kmap(sg_page(in_sg)) + in_sg->offset;
> +	if (src_addr == NULL) {
> +		dev_err(ss->dev, "KMAP error for src SG\n");
> +		err = -EINVAL;
> +		goto release_ss;
> +	}
> +	dst_addr = kmap(sg_page(out_sg)) + out_sg->offset;
> +	if (dst_addr == NULL) {
> +		kunmap(sg_page(in_sg));
> +		dev_err(ss->dev, "KMAP error for dst SG\n");
> +		err = -EINVAL;
> +		goto release_ss;
> +	}
> +	src32 = (u32 *)src_addr;
> +	dst32 = (u32 *)dst_addr;
> +	ileft = areq->nbytes / 4;
> +	oleft = areq->nbytes / 4;
> +	sgileft = in_sg->length / 4;
> +	sgoleft = out_sg->length / 4;
> +	do {
> +		spaces = readl_relaxed(ss->base + SS_FCSR);
> +		rx_cnt = SS_RXFIFO_SPACES(spaces);
> +		tx_cnt = SS_TXFIFO_SPACES(spaces);
> +		todo = min3(rx_cnt, ileft, sgileft);
> +		if (todo > 0) {
> +			ileft -= todo;
> +			sgileft -= todo;
> +			writesl(ss->base + SS_RXFIFO, src32, todo);
> +			src32 += todo;
> +		}
> +		if (in_sg != NULL && sgileft == 0 && ileft > 0) {
> +			kunmap(sg_page(in_sg));
> +			in_sg = sg_next(in_sg);
> +			while (in_sg != NULL && in_sg->length == 0)
> +				in_sg = sg_next(in_sg);
> +			if (in_sg != NULL && ileft > 0) {
> +				src_addr = kmap(sg_page(in_sg)) + in_sg->offset;
> +				if (src_addr == NULL) {
> +					dev_err(ss->dev, "ERROR: KMAP for src SG\n");
> +					err = -EINVAL;
> +					goto release_ss;
> +				}
> +				src32 = src_addr;
> +				sgileft = in_sg->length / 4;
> +			}
> +		}
> +		/* do not test oleft since when oleft == 0 we have finished */
> +		todo = min3(tx_cnt, oleft, sgoleft);
> +		if (todo > 0) {
> +			oleft -= todo;
> +			sgoleft -= todo;
> +			readsl(ss->base + SS_TXFIFO, dst32, todo);
> +			dst32 += todo;
> +		}
> +		if (out_sg != NULL && sgoleft == 0 && oleft >= 0) {
> +			kunmap(sg_page(out_sg));
> +			out_sg = sg_next(out_sg);
> +			while (out_sg != NULL && out_sg->length == 0)
> +				out_sg = sg_next(out_sg);
> +			if (out_sg != NULL && oleft > 0) {
> +				dst_addr = kmap(sg_page(out_sg)) +
> +					out_sg->offset;
> +				if (dst_addr == NULL) {
> +					dev_err(ss->dev, "KMAP error\n");
> +					err = -EINVAL;
> +					goto release_ss;
> +				}
> +				dst32 = dst_addr;
> +				sgoleft = out_sg->length / 4;
> +			}
> +		}
> +	} while (oleft > 0);
> +
> +release_ss:
> +	writel_relaxed(0, ss->base + SS_CTL);
> +	spin_unlock_irqrestore(&ss->slock, flags);
> +	return err;
> +}

Do you really need to have both an "optimized" and "non-optimized"
function ?

BTW, you should take a look at the sg_copy_buffer function [1], which
is doing pretty much what you're doing here.
If you don't want to directly use sg_copy_buffer, you should at least
use the sg_miter_xxx function to iterate over you're sg list (it's
taking care of calling kmap or kmap_atomic depending on the
SG_MITER_ATOMIC flag).

> +
> +/* Pure CPU driven way of doing DES/3DES with SS */
> +int sunxi_ss_des_poll(struct ablkcipher_request *areq, u32 mode)
> +{
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
> +	struct sunxi_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
> +	struct sunxi_ss_ctx *ss = op->ss;
> +	int i, err = 0;
> +	int no_chunk = 1;
> +	struct scatterlist *in_sg = areq->src;
> +	struct scatterlist *out_sg = areq->dst;
> +	u8 kkey[256 / 8];
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
> +		return sunxi_ss_aes_poll(areq, mode);
> +

Given your explanations, I'm not sure the names sunxi_ss_aes_poll and
sunxi_ss_des_poll are appropriate.

What about sunxi_ss_aligned_cipher_op_poll and sunxi_ss_cipher_op_poll.

That's all I got for now.
I haven't reviewed the hash part yet, but I guess some of my comments
apply to this code too.

Best Regards,

Boris


[1]http://lxr.free-electrons.com/source/lib/scatterlist.c#L621

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
