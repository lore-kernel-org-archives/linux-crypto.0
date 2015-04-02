From: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v6 4/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Thu, 02 Apr 2015 21:11:50 +0200
Message-ID: <551D9476.7090206@gmail.com>
References: <1426532482-28830-1-git-send-email-clabbe.montjoie@gmail.com>	<1426532482-28830-5-git-send-email-clabbe.montjoie@gmail.com> <20150326193115.5e30a9af@bbrezillon>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
 ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
 maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
 herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
 akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org,
 devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Return-path: <linux-sunxi+bncBD7YLCN32UNBB6VI62UAKGQEA2FQQHI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <20150326193115.5e30a9af@bbrezillon>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Le 26/03/2015 19:31, Boris Brezillon a =C3=A9crit :
> Hi Corentin,
>=20
> Here is a quick review, there surely are a lot of other things I didn't
> spot.
>=20
> On Mon, 16 Mar 2015 20:01:22 +0100
> LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
>> Add support for the Security System included in Allwinner SoC A20.
>> The Security System is a hardware cryptographic accelerator that support=
:
>> - MD5 and SHA1 hash algorithms
>> - AES block cipher in CBC mode with 128/196/256bits keys.
>> - DES and 3DES block cipher in CBC mode
>>
>> Signed-off-by: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>=20
> [...]
>=20
>> +static int sunxi_ss_cipher(struct ablkcipher_request *areq, u32 mode)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
>> +	struct sunxi_tfm_ctx *op =3D crypto_ablkcipher_ctx(tfm);
>> +	const char *cipher_type;
>> +	struct sunxi_ss_ctx *ss =3D op->ss;
>> +
>> +	if (areq->nbytes =3D=3D 0)
>> +		return 0;
>> +
>> +	if (areq->info =3D=3D NULL) {
>> +		dev_err(ss->dev, "ERROR: Empty IV\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (areq->src =3D=3D NULL || areq->dst =3D=3D NULL) {
>> +		dev_err(ss->dev, "ERROR: Some SGs are NULL\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	cipher_type =3D crypto_tfm_alg_name(crypto_ablkcipher_tfm(tfm));
>> +
>> +	if (strcmp("cbc(aes)", cipher_type) =3D=3D 0) {
>> +		mode |=3D SS_OP_AES | SS_CBC | SS_ENABLED | op->keymode;
>> +		return sunxi_ss_aes_poll(areq, mode);
>> +	}
>> +
>> +	if (strcmp("cbc(des)", cipher_type) =3D=3D 0) {
>> +		mode |=3D SS_OP_DES | SS_CBC | SS_ENABLED | op->keymode;
>> +		return sunxi_ss_des_poll(areq, mode);
>> +	}
>> +
>> +	if (strcmp("cbc(des3_ede)", cipher_type) =3D=3D 0) {
>> +		mode |=3D SS_OP_3DES | SS_CBC | SS_ENABLED | op->keymode;
>> +		return sunxi_ss_des_poll(areq, mode);
>> +	}
>=20
> Hm, I'm not sure doing these string comparisons in the crypto operation
> path is a good idea.
> Moreover, you're doing 3 string comparisons, even though only one can
> be valid at a time (using 'else if' would have been a bit better).
>=20
> Anyway, IMHO this function should be split into 3 functions, and
> referenced by your alg template definitions.
> Something like:
>=20
> int sunxi_ss_xxx_encrypt(struct ablkcipher_request *areq)
> {
> 	/* put your cipher specific intialization here */
>=20
> 	return sunxi_ss_xxx_poll(areq, SS_ENCRYPTION);
> }
>=20
> int sunxi_ss_xxx_decrypt(struct ablkcipher_request *areq)
> {
> 	/* put your cipher specific intialization here */
>=20
> 	return sunxi_ss_xxx_poll(areq, SS_DECRYPTION);
> }
>=20

You are right, I have added more block mode, and that was added too much st=
rcmp.
So splitting in simplier functions is good.

>=20
>> +
>> +int sunxi_ss_cipher_init(struct crypto_tfm *tfm)
>> +{
>> +	const char *name =3D crypto_tfm_alg_name(tfm);
>> +	struct sunxi_tfm_ctx *op =3D crypto_tfm_ctx(tfm);
>> +	struct crypto_alg *alg =3D tfm->__crt_alg;
>> +	struct sunxi_ss_alg_template *algt;
>> +	struct sunxi_ss_ctx *ss;
>> +
>> +	memset(op, 0, sizeof(struct sunxi_tfm_ctx));
>> +
>> +	algt =3D container_of(alg, struct sunxi_ss_alg_template, alg.crypto);
>> +	ss =3D algt->ss;
>> +	op->ss =3D algt->ss;
>> +
>> +	/* fallback is needed only for DES/3DES */
>> +	if (strcmp("cbc(des)", name) =3D=3D 0 ||
>> +			strcmp("cbc(des3_ede)", name) =3D=3D 0) {
>> +		op->fallback =3D crypto_alloc_ablkcipher(name, 0,
>> +				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
>> +		if (IS_ERR(op->fallback)) {
>> +			dev_err(ss->dev, "ERROR: allocating fallback algo %s\n",
>> +					name);
>> +			return PTR_ERR(op->fallback);
>> +		}
>> +	}
>=20
> Ditto: just create a specific init function for the des case:
>=20
> int sunxi_ss_cbc_des_init(struct crypto_tfm *tfm)
> {
> 	sunxi_ss_cipher_init(tfm);
>=20
> 	op->fallback =3D crypto_alloc_ablkcipher(name, 0,
> 				CRYPTO_ALG_ASYNC |
> 				CRYPTO_ALG_NEED_FALLBACK);
> 	if (IS_ERR(op->fallback)) {
> 		dev_err(ss->dev, "ERROR: allocating fallback algo %s\n",
> 			name);
> 		return PTR_ERR(op->fallback);
> 	}
>=20
> 	return 0;
> }
>=20

Ok

>=20
> [..]
>=20
>> +/*
>> + * Optimized function for the case where we have only one SG,
>> + * so we can use kmap_atomic
>> + */
>> +static int sunxi_ss_aes_poll_atomic(struct ablkcipher_request *areq)
>> +{
>> +	u32 spaces;
>> +	struct scatterlist *in_sg =3D areq->src;
>> +	struct scatterlist *out_sg =3D areq->dst;
>> +	void *src_addr;
>> +	void *dst_addr;
>> +	unsigned int ileft =3D areq->nbytes;
>> +	unsigned int oleft =3D areq->nbytes;
>> +	unsigned int todo;
>> +	u32 *src32;
>> +	u32 *dst32;
>> +	u32 rx_cnt =3D 32;
>> +	u32 tx_cnt =3D 0;
>> +	int i;
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
>> +	struct sunxi_tfm_ctx *op =3D crypto_ablkcipher_ctx(tfm);
>> +	struct sunxi_ss_ctx *ss =3D op->ss;
>> +
>> +	src_addr =3D kmap_atomic(sg_page(in_sg)) + in_sg->offset;
>> +	if (src_addr =3D=3D NULL) {
>> +		dev_err(ss->dev, "kmap_atomic error for src SG\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	dst_addr =3D kmap_atomic(sg_page(out_sg)) + out_sg->offset;
>> +	if (dst_addr =3D=3D NULL) {
>> +		dev_err(ss->dev, "kmap_atomic error for dst SG\n");
>> +		kunmap_atomic(src_addr);
>> +		return -EINVAL;
>> +	}
>> +
>> +	src32 =3D (u32 *)src_addr;
>> +	dst32 =3D (u32 *)dst_addr;
>> +	ileft =3D areq->nbytes / 4;
>> +	oleft =3D areq->nbytes / 4;
>> +	i =3D 0;
>> +	do {
>> +		if (ileft > 0 && rx_cnt > 0) {
>> +			todo =3D min(rx_cnt, ileft);
>> +			ileft -=3D todo;
>> +			writesl(ss->base + SS_RXFIFO, src32, todo);
>> +			src32 +=3D todo;
>> +		}
>> +		if (tx_cnt > 0) {
>> +			todo =3D min(tx_cnt, oleft);
>> +			oleft -=3D todo;
>> +			readsl(ss->base + SS_TXFIFO, dst32, todo);
>> +			dst32 +=3D todo;
>> +		}
>> +		spaces =3D readl(ss->base + SS_FCSR);
>> +		rx_cnt =3D SS_RXFIFO_SPACES(spaces);
>> +		tx_cnt =3D SS_TXFIFO_SPACES(spaces);
>> +	} while (oleft > 0);
>> +	kunmap_atomic(dst_addr);
>> +	kunmap_atomic(src_addr);
>> +	return 0;
>> +}
>> +
>> +int sunxi_ss_aes_poll(struct ablkcipher_request *areq, u32 mode)
>> +{
>> +	u32 spaces;
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
>> +	struct sunxi_tfm_ctx *op =3D crypto_ablkcipher_ctx(tfm);
>> +	struct sunxi_ss_ctx *ss =3D op->ss;
>> +	unsigned int ivsize =3D crypto_ablkcipher_ivsize(tfm);
>> +	/* when activating SS, the default FIFO space is 32 */
>> +	u32 rx_cnt =3D 32;
>> +	u32 tx_cnt =3D 0;
>> +	u32 v;
>> +	int i, err =3D 0;
>> +	struct scatterlist *in_sg =3D areq->src;
>> +	struct scatterlist *out_sg =3D areq->dst;
>> +	void *src_addr;
>> +	void *dst_addr;
>> +	unsigned int ileft =3D areq->nbytes;
>> +	unsigned int oleft =3D areq->nbytes;
>> +	unsigned int sgileft =3D areq->src->length;
>> +	unsigned int sgoleft =3D areq->dst->length;
>> +	unsigned int todo;
>> +	u32 *src32;
>> +	u32 *dst32;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&ss->slock, flags);
>> +
>> +	for (i =3D 0; i < op->keylen; i +=3D 4)
>> +		writel(*(op->key + i/4), ss->base + SS_KEY0 + i);
>> +
>> +	if (areq->info !=3D NULL) {
>> +		for (i =3D 0; i < 4 && i < ivsize / 4; i++) {
>> +			v =3D *(u32 *)(areq->info + i * 4);
>> +			writel(v, ss->base + SS_IV0 + i * 4);
>> +		}
>> +	}
>> +	writel(mode, ss->base + SS_CTL);
>> +
>> +	/* If we have only one SG, we can use kmap_atomic */
>> +	if (sg_next(in_sg) =3D=3D NULL && sg_next(out_sg) =3D=3D NULL) {
>> +		err =3D sunxi_ss_aes_poll_atomic(areq);
>> +		goto release_ss;
>> +	}
>> +
>> +	/*
>> +	 * If we have more than one SG, we cannot use kmap_atomic since
>> +	 * we hold the mapping too long
>> +	 */
>> +	src_addr =3D kmap(sg_page(in_sg)) + in_sg->offset;
>> +	if (src_addr =3D=3D NULL) {
>> +		dev_err(ss->dev, "KMAP error for src SG\n");
>> +		err =3D -EINVAL;
>> +		goto release_ss;
>> +	}
>> +	dst_addr =3D kmap(sg_page(out_sg)) + out_sg->offset;
>> +	if (dst_addr =3D=3D NULL) {
>> +		kunmap(sg_page(in_sg));
>> +		dev_err(ss->dev, "KMAP error for dst SG\n");
>> +		err =3D -EINVAL;
>> +		goto release_ss;
>> +	}
>> +	src32 =3D (u32 *)src_addr;
>> +	dst32 =3D (u32 *)dst_addr;
>> +	ileft =3D areq->nbytes / 4;
>> +	oleft =3D areq->nbytes / 4;
>> +	sgileft =3D in_sg->length / 4;
>> +	sgoleft =3D out_sg->length / 4;
>> +	do {
>> +		spaces =3D readl_relaxed(ss->base + SS_FCSR);
>> +		rx_cnt =3D SS_RXFIFO_SPACES(spaces);
>> +		tx_cnt =3D SS_TXFIFO_SPACES(spaces);
>> +		todo =3D min3(rx_cnt, ileft, sgileft);
>> +		if (todo > 0) {
>> +			ileft -=3D todo;
>> +			sgileft -=3D todo;
>> +			writesl(ss->base + SS_RXFIFO, src32, todo);
>> +			src32 +=3D todo;
>> +		}
>> +		if (in_sg !=3D NULL && sgileft =3D=3D 0 && ileft > 0) {
>> +			kunmap(sg_page(in_sg));
>> +			in_sg =3D sg_next(in_sg);
>> +			while (in_sg !=3D NULL && in_sg->length =3D=3D 0)
>> +				in_sg =3D sg_next(in_sg);
>> +			if (in_sg !=3D NULL && ileft > 0) {
>> +				src_addr =3D kmap(sg_page(in_sg)) + in_sg->offset;
>> +				if (src_addr =3D=3D NULL) {
>> +					dev_err(ss->dev, "ERROR: KMAP for src SG\n");
>> +					err =3D -EINVAL;
>> +					goto release_ss;
>> +				}
>> +				src32 =3D src_addr;
>> +				sgileft =3D in_sg->length / 4;
>> +			}
>> +		}
>> +		/* do not test oleft since when oleft =3D=3D 0 we have finished */
>> +		todo =3D min3(tx_cnt, oleft, sgoleft);
>> +		if (todo > 0) {
>> +			oleft -=3D todo;
>> +			sgoleft -=3D todo;
>> +			readsl(ss->base + SS_TXFIFO, dst32, todo);
>> +			dst32 +=3D todo;
>> +		}
>> +		if (out_sg !=3D NULL && sgoleft =3D=3D 0 && oleft >=3D 0) {
>> +			kunmap(sg_page(out_sg));
>> +			out_sg =3D sg_next(out_sg);
>> +			while (out_sg !=3D NULL && out_sg->length =3D=3D 0)
>> +				out_sg =3D sg_next(out_sg);
>> +			if (out_sg !=3D NULL && oleft > 0) {
>> +				dst_addr =3D kmap(sg_page(out_sg)) +
>> +					out_sg->offset;
>> +				if (dst_addr =3D=3D NULL) {
>> +					dev_err(ss->dev, "KMAP error\n");
>> +					err =3D -EINVAL;
>> +					goto release_ss;
>> +				}
>> +				dst32 =3D dst_addr;
>> +				sgoleft =3D out_sg->length / 4;
>> +			}
>> +		}
>> +	} while (oleft > 0);
>> +
>> +release_ss:
>> +	writel_relaxed(0, ss->base + SS_CTL);
>> +	spin_unlock_irqrestore(&ss->slock, flags);
>> +	return err;
>> +}
>=20
> Do you really need to have both an "optimized" and "non-optimized"
> function ?
>=20
> BTW, you should take a look at the sg_copy_buffer function [1], which
> is doing pretty much what you're doing here.
> If you don't want to directly use sg_copy_buffer, you should at least
> use the sg_miter_xxx function to iterate over you're sg list (it's
> taking care of calling kmap or kmap_atomic depending on the
> SG_MITER_ATOMIC flag).
>=20

I have dropped sg_copy_buffer that I used for DES/3DES some times ago for h=
andling SG with length not multiple of 4.
And using sg_miter is not usefull.
It could be usefull for DES/3DEs for non 4 bytes multiple SG, but I use a f=
allback for that case.

>> +
>> +/* Pure CPU driven way of doing DES/3DES with SS */
>> +int sunxi_ss_des_poll(struct ablkcipher_request *areq, u32 mode)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
>> +	struct sunxi_tfm_ctx *op =3D crypto_ablkcipher_ctx(tfm);
>> +	struct sunxi_ss_ctx *ss =3D op->ss;
>> +	int i, err =3D 0;
>> +	int no_chunk =3D 1;
>> +	struct scatterlist *in_sg =3D areq->src;
>> +	struct scatterlist *out_sg =3D areq->dst;
>> +	u8 kkey[256 / 8];
>> +
>> +	/*
>> +	 * if we have only SGs with size multiple of 4,
>> +	 * we can use the SS AES function
>> +	 */
>> +	while (in_sg !=3D NULL && no_chunk =3D=3D 1) {
>> +		if ((in_sg->length % 4) !=3D 0)
>> +			no_chunk =3D 0;
>> +		in_sg =3D sg_next(in_sg);
>> +	}
>> +	while (out_sg !=3D NULL && no_chunk =3D=3D 1) {
>> +		if ((out_sg->length % 4) !=3D 0)
>> +			no_chunk =3D 0;
>> +		out_sg =3D sg_next(out_sg);
>> +	}
>> +
>> +	if (no_chunk =3D=3D 1)
>> +		return sunxi_ss_aes_poll(areq, mode);
>> +
>=20
> Given your explanations, I'm not sure the names sunxi_ss_aes_poll and
> sunxi_ss_des_poll are appropriate.
>=20
> What about sunxi_ss_aligned_cipher_op_poll and sunxi_ss_cipher_op_poll.

The difference is not about aligned or not since according to my understand=
ing, the data will always be aligned following cra_alignmask.

Thanks for your review

>=20
> That's all I got for now.
> I haven't reviewed the hash part yet, but I guess some of my comments
> apply to this code too.
>=20
> Best Regards,
>=20
> Boris
>=20
>=20
> [1]http://lxr.free-electrons.com/source/lib/scatterlist.c#L621
>=20

--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
