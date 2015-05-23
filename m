From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v9 4/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Sat, 23 May 2015 16:35:36 +0200
Message-ID: <20150523163536.2d64ef8d@bbrezillon>
References: <1431608341-10936-1-git-send-email-clabbe.montjoie@gmail.com>
	<1431608341-10936-5-git-send-email-clabbe.montjoie@gmail.com>
	<20150517104508.468b032f@bbrezillon>
	<55607CB7.8020505@gmail.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org,
 mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
 maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
 davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org,
 mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org,
 devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBPNAQKVQKGQEW5WXHRA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <55607CB7.8020505-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Hi Corentin,

On Sat, 23 May 2015 15:12:23 +0200
Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Le 17/05/2015 10:45, Boris Brezillon a =C3=A9crit :
> > Hi Corentin,
> >=20
> > I started to review this new version, and I still think there's
> > something wrong with the way your processing crypto requests.
> > From my POV this is not asynchronous at all (see my comments inline),
> > but maybe Herbert can confirm that.
> > I haven't reviewed the hash part yet, but I guess it has the same
> > problem.
>=20
> For resuming your conversation with Herbert, I have removed all CRYPTO_AL=
G_ASYNC flags.

Okay. I really think you can easily deal with asynchronous request (I
had a look at the datasheet), but I'll let maintainers decide whether
this is important or not.


> >=20
> >> +
> >> +int sun4i_ss_aes_poll(struct ablkcipher_request *areq, u32 mode)
> >> +{
> >> +	u32 spaces;
> >> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
> >> +	struct sun4i_tfm_ctx *op =3D crypto_ablkcipher_ctx(tfm);
> >> +	struct sun4i_ss_ctx *ss =3D op->ss;
> >> +	unsigned int ivsize =3D crypto_ablkcipher_ivsize(tfm);
> >> +	/* when activating SS, the default FIFO space is 32 */
> >> +	u32 rx_cnt =3D 32;
> >> +	u32 tx_cnt =3D 0;
> >> +	u32 v;
> >> +	int i, sgnum, err =3D 0;
> >> +	unsigned int ileft =3D areq->nbytes;
> >> +	unsigned int oleft =3D areq->nbytes;
> >> +	unsigned int todo, miter_flag;
> >> +	unsigned long flags;
> >> +	struct sg_mapping_iter mi, mo;
> >> +	unsigned int oi, oo; /* offset for in and out */
> >> +
> >> +	if (areq->nbytes =3D=3D 0)
> >> +		return 0;
> >> +
> >> +	if (areq->info =3D=3D NULL) {
> >> +		dev_err(ss->dev, "ERROR: Empty IV\n");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	if (areq->src =3D=3D NULL || areq->dst =3D=3D NULL) {
> >> +		dev_err(ss->dev, "ERROR: Some SGs are NULL\n");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	spin_lock_irqsave(&ss->slock, flags);
> >=20
> > Do you really need to take this lock so early ?
> > BTW, what is this lock protecting ?
>=20
> As I have written in the header, the spinlock protect the usage of the de=
vice.
> In this case, I need to lock just before writing the key in the device.

I'm not denying the fact that you need some locking, just how this
locking is done: you're preventing the all system from receiving
interrupts for the all time your doing your crypto request.

Here is a suggestion (if you still want to keep the synchronous model,
which IMHO is not a good idea, but hey, that's not my call to make).

1/ wait for the device to be ready (using a waitqueue)
2/ take the lock
3/ check if the engine is busy (already handling another crypto
   request).
4.1/ If the engine is not busy, mark the engine as busy, release the
     lock and proceed with the crytpo request handling.
4.2/ If the engine is busy, release the lock and go back to 1/=20


>=20
> >=20
> > IMHO, taking a spinlock and disabling irqs for the whole time you're
> > executing a crypto request is not a good idea (it will prevent all
> > other irqs from running, and potentially introduce latencies in other
> > parts of the kernel).
>=20
> Since crypto operation could be called by software interrupt, I need to d=
isable them.
> (Confirmed by http://www.makelinux.net/ldd3/chp-5-sect-5 5.5.3)

Hm, you're not even using the interrupts provided by the IP to detect
when the engine is ready to accept new data chunks (which is another
aspect that should be addressed IMO), so I don't get why you need to
disable HW interrupts.
If you just want to disable SW interrupts, you can use spin_lock_bh()
instead of spin_lock_irqsave().

>=20
> >=20
> > What you can do though is declare the following fields in your crypto
> > engine struct (sun4i_ss_ctx):
> > - a crypto request queue (struct crypto_queue [1])
> > - a crypto_async_request variable storing the request being processed
> > - a lock protecting the queue and the current request variable
> >=20
> > This way you'll only have to take the lock when queuing or dequeuing a
> > request.
> >=20
> > Another comment, your implementation does not seem to be asynchronous a=
t
> > all: you're blocking the caller until its crypto request is complete.
> >=20
> >=20
> >> +
> >> +	for (i =3D 0; i < op->keylen; i +=3D 4)
> >> +		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
> >> +
> >> +	if (areq->info !=3D NULL) {
> >> +		for (i =3D 0; i < 4 && i < ivsize / 4; i++) {
> >> +			v =3D *(u32 *)(areq->info + i * 4);
> >> +			writel(v, ss->base + SS_IV0 + i * 4);
> >> +		}
> >> +	}
> >> +	writel(mode, ss->base + SS_CTL);
> >> +
> >> +	sgnum =3D sg_nents(areq->src);
> >> +	if (sgnum =3D=3D 1)
> >> +		miter_flag =3D SG_MITER_FROM_SG | SG_MITER_ATOMIC;
> >> +	else
> >> +		miter_flag =3D SG_MITER_FROM_SG;
> >=20
> >=20
> > Why is the ATOMIC flag depending on the number of sg elements.
> > IMO it should only depends on the context you're currently in, and in
> > your specific case, you're always in atomic context since you've taken
> > a spinlock (and disabled irqs) a few lines above.
> >=20
> > Note that with the approach I previously proposed, you can even get rid
> > of this ATMIC flag (or always set it depending on the context you're in
> > when dequeuing the crypto requests).
> >=20
>=20
> For sg_miter, the ATOMIC flag control the usage of kmap vs kmap_atomic.
> Since kmap_atomic must not be held too long, I use them only for short cr=
ypto operation.
> But I need to rebench for be sure that using kmap_atomic give faster resu=
lt.
> If I keep that, I will add a comment explaining that.

Maybe you can call kmap_atomic when you're in standard context (even if
I'm not sure this is relevant), but you definitely can't call kmap when
you're in atomic context (see the might_sleep() line here [1]). And
since you've taken a spinlock (and disabled all the interrupts) a few
lines above, you're in atomic context here.

> >=20
> >> +	sg_miter_start(&mo, areq->dst, sgnum, miter_flag);
> >> +	sg_miter_next(&mi);
> >> +	sg_miter_next(&mo);
> >> +	if (mi.addr =3D=3D NULL || mo.addr =3D=3D NULL) {
> >> +		err =3D -EINVAL;
> >> +		goto release_ss;
> >> +	}
> >> +
> >> +	ileft =3D areq->nbytes / 4;
> >> +	oleft =3D areq->nbytes / 4;
> >> +	oi =3D 0;
> >> +	oo =3D 0;
> >> +	do {
> >> +		todo =3D min3(rx_cnt, ileft, (mi.length - oi) / 4);
> >> +		if (todo > 0) {
> >> +			ileft -=3D todo;
> >> +			writesl(ss->base + SS_RXFIFO, mi.addr + oi, todo);
> >=20
> > Is there anything guaranteeing that your pointer is aligned on a 4 byte
> > boundary ? If that's not the case, I guess you should copy it in a
> > temporary variable before using writesl.
>=20
> The cra_alignmask is my guarantee.

Right.

>=20
> >=20
> >> +			oi +=3D todo * 4;
> >> +		}
> >> +		if (oi =3D=3D mi.length) {
> >> +			sg_miter_next(&mi);
> >> +			oi =3D 0;
> >> +		}
> >> +
> >> +		ispaces =3D readl_relaxed(ss->base + SS_FCSR);
> >=20
> > Is there a good reason for using the _relaxed version of readl/writel
> > (the same comment applies a few lines below) ?
>=20
> No, it is clearly a remaining of the times where all my read/write was wi=
th _relaxed.


Okay, then maybe you should reconsider using readl/writel, unless you
really know why you're using relaxed versions.

> >=20
> >> +	spin_unlock_irqrestore(&ss->slock, flags);
> >> +	return err;
> >> +}
> >> +
> >> +/* Pure CPU driven way of doing DES/3DES with SS */
> >> +int sun4i_ss_des_poll(struct ablkcipher_request *areq, u32 mode)
> >> +{
> >> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
> >> +	struct sun4i_tfm_ctx *op =3D crypto_ablkcipher_ctx(tfm);
> >> +	struct sun4i_ss_ctx *ss =3D op->ss;
> >> +	int i, err =3D 0;
> >> +	int no_chunk =3D 1;
> >> +	struct scatterlist *in_sg =3D areq->src;
> >> +	struct scatterlist *out_sg =3D areq->dst;
> >> +	u8 kkey[256 / 8];
> >> +
> >> +	if (areq->nbytes =3D=3D 0)
> >> +		return 0;
> >> +
> >> +	if (areq->info =3D=3D NULL) {
> >> +		dev_err(ss->dev, "ERROR: Empty IV\n");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	if (areq->src =3D=3D NULL || areq->dst =3D=3D NULL) {
> >> +		dev_err(ss->dev, "ERROR: Some SGs are NULL\n");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	/*
> >> +	 * if we have only SGs with size multiple of 4,
> >> +	 * we can use the SS AES function
> >> +	 */
> >> +	while (in_sg !=3D NULL && no_chunk =3D=3D 1) {
> >> +		if ((in_sg->length % 4) !=3D 0)
> >> +			no_chunk =3D 0;
> >> +		in_sg =3D sg_next(in_sg);
> >> +	}
> >> +	while (out_sg !=3D NULL && no_chunk =3D=3D 1) {
> >> +		if ((out_sg->length % 4) !=3D 0)
> >> +			no_chunk =3D 0;
> >> +		out_sg =3D sg_next(out_sg);
> >> +	}
> >> +
> >> +	if (no_chunk =3D=3D 1)
> >> +		return sun4i_ss_aes_poll(areq, mode);
> >> +
> >> +	/*
> >> +	 * if some SG are not multiple of 4bytes use a fallback
> >> +	 * it is much easy and clean
> >> +	 */
> >=20
> > Hm, is this really the best solution. I mean, you can easily pack
> > values from non aligned sg buffers so that you have only a 4 byte
> > aligned buffers.
> > Moreover, by doing this you'll end up with a single
> > sun4i_ss_ablkcipher_poll function.
> >=20
> > BTW, I wonder if there's anything preventing an AES crypto request to b=
e
> > forged the same way DES/3DES requests are (sg entries not aligned on 4
> > bytes boundary).
>=20
> There are two different problem: chunking and alignment.
> The correct alignment is handled by the crypto API with the alignmask, so=
 the driver do not need to care about it.

Yes...

> The chunking is the fact that I can have a SG with a size that is non mul=
tiple of 4.

and I was takling about this specific aspect here.

> For DES/3DES I handle this problem by using a fallback since DES/3DES was=
 not my priority. (but yes I will handle it in the future)
> For AES I have assumed that it cannot happen since no test in tcrypt chec=
k for it.

If that's something you're willing to address in a future version, then
I'm fine with that.

> Since all SG I get was always a multiple of 16 (AES BLOCK SIZE) it was a =
sort of confirmation.
>=20
> Herbert ? does am I right or a chunking test is missing for cbc(aes) in t=
estmgr.h

Okay, just sharing my vision of this thing (I'll let Herbert comment on
this aspect): I'd say that theoretically nothing prevents one from
splitting its sg list in chunks smaller than the block size, so I'd
say you should use the same trick for AES.=20



[1]http://lxr.free-electrons.com/source/arch/arm/mm/highmem.c#L37

--=20
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
