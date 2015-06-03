From: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v9 4/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Wed, 03 Jun 2015 21:06:05 +0200
Message-ID: <556F501D.8030202@gmail.com>
References: <1431608341-10936-1-git-send-email-clabbe.montjoie@gmail.com>	<1431608341-10936-5-git-send-email-clabbe.montjoie@gmail.com>	<20150517104508.468b032f@bbrezillon>	<55607CB7.8020505@gmail.com> <20150523163536.2d64ef8d@bbrezillon>
Reply-To: clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org,
 mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org,
 galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org,
 linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
 gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org,
 tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Return-path: <linux-sunxi+bncBD7YLCN32UNBBIVAXWVQKGQEJWAZGDI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <20150523163536.2d64ef8d@bbrezillon>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Le 23/05/2015 16:35, Boris Brezillon a =C3=A9crit :
> Hi Corentin,
>=20
> On Sat, 23 May 2015 15:12:23 +0200
> Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
>> Le 17/05/2015 10:45, Boris Brezillon a =C3=A9crit :
>>> Hi Corentin,
>>>
>>> I started to review this new version, and I still think there's
>>> something wrong with the way your processing crypto requests.
>>> From my POV this is not asynchronous at all (see my comments inline),
>>> but maybe Herbert can confirm that.
>>> I haven't reviewed the hash part yet, but I guess it has the same
>>> problem.
>>
>> For resuming your conversation with Herbert, I have removed all CRYPTO_A=
LG_ASYNC flags.
>=20
> Okay. I really think you can easily deal with asynchronous request (I
> had a look at the datasheet), but I'll let maintainers decide whether
> this is important or not.
>=20
>=20
>>>> +
>>>> +	if (areq->src =3D=3D NULL || areq->dst =3D=3D NULL) {
>>>> +		dev_err(ss->dev, "ERROR: Some SGs are NULL\n");
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	spin_lock_irqsave(&ss->slock, flags);
>>>
>>> Do you really need to take this lock so early ?
>>> BTW, what is this lock protecting ?
>>
>> As I have written in the header, the spinlock protect the usage of the d=
evice.
>> In this case, I need to lock just before writing the key in the device.
>=20
> I'm not denying the fact that you need some locking, just how this
> locking is done: you're preventing the all system from receiving
> interrupts for the all time your doing your crypto request.
>=20
> Here is a suggestion (if you still want to keep the synchronous model,
> which IMHO is not a good idea, but hey, that's not my call to make).
>=20
> 1/ wait for the device to be ready (using a waitqueue)
> 2/ take the lock
> 3/ check if the engine is busy (already handling another crypto
>    request).
> 4.1/ If the engine is not busy, mark the engine as busy, release the
>      lock and proceed with the crytpo request handling.
> 4.2/ If the engine is busy, release the lock and go back to 1/=20
>=20
>=20

I have done a version with a crypto_queue and a kthread.
This works perfectly but.. the performance are really really bad.
Never more than 20k request/s when both generic and synchronous SS can go b=
eyond 80k.
With this asynchronous driver, the Security System become useful only with =
request larger than 2048 bytes
I have patched my driver to create stats on request size, this show that re=
al usage is less than that. (512bytes for cryptoluks for example)

Furthermore, my current patch for using the PRNG cannot be used with the kt=
hread since it use the hwrng interface.
But perhaps by using also a crypto_rng alg it could be done.

So I think that if I want to make the SS driver useful, I cannot set it asy=
nchronous.
Perhaps when the DMA engine will be available, this will change.

I have attached the patch that make my driver asynchronous for comments on =
possible improvement.

>>
>>>
>>> IMHO, taking a spinlock and disabling irqs for the whole time you're
>>> executing a crypto request is not a good idea (it will prevent all
>>> other irqs from running, and potentially introduce latencies in other
>>> parts of the kernel).
>>
>> Since crypto operation could be called by software interrupt, I need to =
disable them.
>> (Confirmed by http://www.makelinux.net/ldd3/chp-5-sect-5 5.5.3)
>=20
> Hm, you're not even using the interrupts provided by the IP to detect
> when the engine is ready to accept new data chunks (which is another
> aspect that should be addressed IMO), so I don't get why you need to
> disable HW interrupts.
> If you just want to disable SW interrupts, you can use spin_lock_bh()
> instead of spin_lock_irqsave().
>=20

Thanks I use spin_lock_bh now.

>>
>>>
>>> What you can do though is declare the following fields in your crypto
>>> engine struct (sun4i_ss_ctx):
>>> - a crypto request queue (struct crypto_queue [1])
>>> - a crypto_async_request variable storing the request being processed
>>> - a lock protecting the queue and the current request variable
>>>
>>> This way you'll only have to take the lock when queuing or dequeuing a
>>> request.
>>>
>>> Another comment, your implementation does not seem to be asynchronous a=
t
>>> all: you're blocking the caller until its crypto request is complete.
>>>
>>>
>>>> +
>>>> +	for (i =3D 0; i < op->keylen; i +=3D 4)
>>>> +		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
>>>> +
>>>> +	if (areq->info !=3D NULL) {
>>>> +		for (i =3D 0; i < 4 && i < ivsize / 4; i++) {
>>>> +			v =3D *(u32 *)(areq->info + i * 4);
>>>> +			writel(v, ss->base + SS_IV0 + i * 4);
>>>> +		}
>>>> +	}
>>>> +	writel(mode, ss->base + SS_CTL);
>>>> +
>>>> +	sgnum =3D sg_nents(areq->src);
>>>> +	if (sgnum =3D=3D 1)
>>>> +		miter_flag =3D SG_MITER_FROM_SG | SG_MITER_ATOMIC;
>>>> +	else
>>>> +		miter_flag =3D SG_MITER_FROM_SG;
>>>
>>>
>>> Why is the ATOMIC flag depending on the number of sg elements.
>>> IMO it should only depends on the context you're currently in, and in
>>> your specific case, you're always in atomic context since you've taken
>>> a spinlock (and disabled irqs) a few lines above.
>>>
>>> Note that with the approach I previously proposed, you can even get rid
>>> of this ATMIC flag (or always set it depending on the context you're in
>>> when dequeuing the crypto requests).
>>>
>>
>> For sg_miter, the ATOMIC flag control the usage of kmap vs kmap_atomic.
>> Since kmap_atomic must not be held too long, I use them only for short c=
rypto operation.
>> But I need to rebench for be sure that using kmap_atomic give faster res=
ult.
>> If I keep that, I will add a comment explaining that.
>=20
> Maybe you can call kmap_atomic when you're in standard context (even if
> I'm not sure this is relevant), but you definitely can't call kmap when
> you're in atomic context (see the might_sleep() line here [1]). And
> since you've taken a spinlock (and disabled all the interrupts) a few
> lines above, you're in atomic context here.
>=20

Thanks, now I use atomic function everywhere it need to.

>>>
>>>> +	sg_miter_start(&mo, areq->dst, sgnum, miter_flag);
>>>> +	sg_miter_next(&mi);
>>>> +	sg_miter_next(&mo);
>>>> +	if (mi.addr =3D=3D NULL || mo.addr =3D=3D NULL) {
>>>> +		err =3D -EINVAL;
>>>> +		goto release_ss;
>>>> +	}
>>>> +
>>>> +	ileft =3D areq->nbytes / 4;
>>>> +	oleft =3D areq->nbytes / 4;
>>>> +	oi =3D 0;
>>>> +	oo =3D 0;
>>>> +	do {
>>>> +		todo =3D min3(rx_cnt, ileft, (mi.length - oi) / 4);
>>>> +		if (todo > 0) {
>>>> +			ileft -=3D todo;
>>>> +			writesl(ss->base + SS_RXFIFO, mi.addr + oi, todo);
>>>
>>> Is there anything guaranteeing that your pointer is aligned on a 4 byte
>>> boundary ? If that's not the case, I guess you should copy it in a
>>> temporary variable before using writesl.
>>
>> The cra_alignmask is my guarantee.
>=20
> Right.
>=20
>>
>>>
>>>> +			oi +=3D todo * 4;
>>>> +		}
>>>> +		if (oi =3D=3D mi.length) {
>>>> +			sg_miter_next(&mi);
>>>> +			oi =3D 0;
>>>> +		}
>>>> +
>>>> +		ispaces =3D readl_relaxed(ss->base + SS_FCSR);
>>>
>>> Is there a good reason for using the _relaxed version of readl/writel
>>> (the same comment applies a few lines below) ?
>>
>> No, it is clearly a remaining of the times where all my read/write was w=
ith _relaxed.
>=20
>=20
> Okay, then maybe you should reconsider using readl/writel, unless you
> really know why you're using relaxed versions.
>=20

Yes I fixed it by not using _relaxed.

>>>
>>>> +	spin_unlock_irqrestore(&ss->slock, flags);
>>>> +	return err;
>>>> +}
>>>> +
>>>> +/* Pure CPU driven way of doing DES/3DES with SS */
>>>> +int sun4i_ss_des_poll(struct ablkcipher_request *areq, u32 mode)
>>>> +{
>>>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
>>>> +	struct sun4i_tfm_ctx *op =3D crypto_ablkcipher_ctx(tfm);
>>>> +	struct sun4i_ss_ctx *ss =3D op->ss;
>>>> +	int i, err =3D 0;
>>>> +	int no_chunk =3D 1;
>>>> +	struct scatterlist *in_sg =3D areq->src;
>>>> +	struct scatterlist *out_sg =3D areq->dst;
>>>> +	u8 kkey[256 / 8];
>>>> +
>>>> +	if (areq->nbytes =3D=3D 0)
>>>> +		return 0;
>>>> +
>>>> +	if (areq->info =3D=3D NULL) {
>>>> +		dev_err(ss->dev, "ERROR: Empty IV\n");
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	if (areq->src =3D=3D NULL || areq->dst =3D=3D NULL) {
>>>> +		dev_err(ss->dev, "ERROR: Some SGs are NULL\n");
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	/*
>>>> +	 * if we have only SGs with size multiple of 4,
>>>> +	 * we can use the SS AES function
>>>> +	 */
>>>> +	while (in_sg !=3D NULL && no_chunk =3D=3D 1) {
>>>> +		if ((in_sg->length % 4) !=3D 0)
>>>> +			no_chunk =3D 0;
>>>> +		in_sg =3D sg_next(in_sg);
>>>> +	}
>>>> +	while (out_sg !=3D NULL && no_chunk =3D=3D 1) {
>>>> +		if ((out_sg->length % 4) !=3D 0)
>>>> +			no_chunk =3D 0;
>>>> +		out_sg =3D sg_next(out_sg);
>>>> +	}
>>>> +
>>>> +	if (no_chunk =3D=3D 1)
>>>> +		return sun4i_ss_aes_poll(areq, mode);
>>>> +
>>>> +	/*
>>>> +	 * if some SG are not multiple of 4bytes use a fallback
>>>> +	 * it is much easy and clean
>>>> +	 */
>>>
>>> Hm, is this really the best solution. I mean, you can easily pack
>>> values from non aligned sg buffers so that you have only a 4 byte
>>> aligned buffers.
>>> Moreover, by doing this you'll end up with a single
>>> sun4i_ss_ablkcipher_poll function.
>>>
>>> BTW, I wonder if there's anything preventing an AES crypto request to b=
e
>>> forged the same way DES/3DES requests are (sg entries not aligned on 4
>>> bytes boundary).
>>
>> There are two different problem: chunking and alignment.
>> The correct alignment is handled by the crypto API with the alignmask, s=
o the driver do not need to care about it.
>=20
> Yes...
>=20
>> The chunking is the fact that I can have a SG with a size that is non mu=
ltiple of 4.
>=20
> and I was takling about this specific aspect here.
>=20
>> For DES/3DES I handle this problem by using a fallback since DES/3DES wa=
s not my priority. (but yes I will handle it in the future)
>> For AES I have assumed that it cannot happen since no test in tcrypt che=
ck for it.
>=20
> If that's something you're willing to address in a future version, then
> I'm fine with that.
>=20
>> Since all SG I get was always a multiple of 16 (AES BLOCK SIZE) it was a=
 sort of confirmation.
>>
>> Herbert ? does am I right or a chunking test is missing for cbc(aes) in =
testmgr.h
>=20
> Okay, just sharing my vision of this thing (I'll let Herbert comment on
> this aspect): I'd say that theoretically nothing prevents one from
> splitting its sg list in chunks smaller than the block size, so I'd
> say you should use the same trick for AES.=20
>=20

I have rework the cipher functions and now they handle all possibility.
With that DES/3DES is now fully supported without fallback.

Thanks for your time and review

LABBE Corentin

--

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sun=
xi-ss/sun4i-ss-cipher.c
index 01634aa..8f59458 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -49,7 +49,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *=
areq)
 		return -EINVAL;
 	}

-	spin_lock_bh(&ss->slock);
+	/*spin_lock_bh(&ss->slock);*/

 	for (i =3D 0; i < op->keylen; i +=3D 4)
 		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
@@ -110,12 +110,12 @@ release_ss:
 	sg_miter_stop(&mi);
 	sg_miter_stop(&mo);
 	writel(0, ss->base + SS_CTL);
-	spin_unlock_bh(&ss->slock);
+	/*spin_unlock_bh(&ss->slock);*/
 	return err;
 }

 /* Generic function that support SG with size not multiple of 4 */
-static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
+int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 {
 	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
 	struct sun4i_tfm_ctx *op =3D crypto_ablkcipher_ctx(tfm);
@@ -174,7 +174,7 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_reque=
st *areq)
 	if (no_chunk =3D=3D 1)
 		return sun4i_ss_opti_poll(areq);

-	spin_lock_bh(&ss->slock);
+	/*spin_lock_bh(&ss->slock);*/

 	for (i =3D 0; i < op->keylen; i +=3D 4)
 		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
@@ -295,7 +295,7 @@ release_ss:
 	sg_miter_stop(&mi);
 	sg_miter_stop(&mo);
 	writel(0, ss->base + SS_CTL);
-	spin_unlock_bh(&ss->slock);
+	/*spin_unlock_bh(&ss->slock);*/

 	return err;
 }
@@ -309,6 +309,7 @@ int sun4i_ss_cbc_aes_encrypt(struct ablkcipher_request =
*areq)

 	rctx->mode =3D SS_OP_AES | SS_CBC | SS_ENABLED | SS_ENCRYPTION |
 		op->keymode;
+	return sun4i_ss_enqueue(&areq->base);
 	return sun4i_ss_cipher_poll(areq);
 }

@@ -320,6 +321,7 @@ int sun4i_ss_cbc_aes_decrypt(struct ablkcipher_request =
*areq)

 	rctx->mode =3D SS_OP_AES | SS_CBC | SS_ENABLED | SS_DECRYPTION |
 		op->keymode;
+	return sun4i_ss_enqueue(&areq->base);
 	return sun4i_ss_cipher_poll(areq);
 }

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi=
-ss/sun4i-ss-core.c
index f3a410a..4b8dcef 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
@@ -22,10 +22,79 @@
 #include <linux/scatterlist.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/kthread.h>

 #include "sun4i-ss.h"

-static struct sun4i_ss_alg_template driver_algs[] =3D {
+int sun4i_ss_enqueue(struct crypto_async_request *areq)
+{
+	struct ablkcipher_request *abreq =3D ablkcipher_request_cast(areq);
+	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(abreq);
+	struct sun4i_tfm_ctx *op =3D crypto_ablkcipher_ctx(tfm);
+	int ret;
+
+	spin_lock_bh(&op->ss->slock);
+	ret =3D crypto_enqueue_request(&op->ss->queue, areq);
+	spin_unlock_bh(&op->ss->slock);
+	if (ret !=3D -EINPROGRESS)
+		return ret;
+
+	wake_up_process(op->ss->thread);
+
+	return -EINPROGRESS;
+}
+
+static int sun4i_ss_thread(void *data) {
+	struct crypto_async_request *backlog;
+        struct crypto_async_request *arq;
+	struct sun4i_ss_ctx *ss =3D data;
+	u32 rtype;
+	struct ablkcipher_request *areq;
+
+	int ret;
+
+	do {
+                __set_current_state(TASK_INTERRUPTIBLE);
+		spin_lock_bh(&ss->slock);
+		backlog =3D crypto_get_backlog(&ss->queue);
+		arq =3D crypto_dequeue_request(&ss->queue);
+		spin_unlock_bh(&ss->slock);
+
+		if (backlog)
+			backlog->complete(backlog, -EINPROGRESS);
+
+		if (arq) {
+			rtype =3D crypto_tfm_alg_type(arq->tfm);
+			switch (rtype) {
+			/*
+			case CRYPTO_ALG_TYPE_AHASH:
+				struct ahash_request *areq =3D ahash_request_cast(arq);
+				ret =3D -1;
+				arq->complete(arq, ret);
+				break;
+			*/
+			case CRYPTO_ALG_TYPE_ABLKCIPHER:
+				areq =3D ablkcipher_request_cast(arq);
+				ret =3D sun4i_ss_cipher_poll(areq);
+				/*pr_info("task cipher %d %d %d %u\n", ret,
+						sg_nents(areq->src), sg_nents(areq->dst), areq->nbytes);*/
+				/* we are in a thread and complete must be called with softirq off */
+				local_bh_disable();
+				arq->complete(arq, ret);
+				local_bh_enable();
+				break;
+			default:
+				dev_err(ss->dev, "ERROR: invalid request\n");
+				arq->complete(arq, -EINVAL);
+			}
+		} else {
+			schedule();
+		}
+	} while (!kthread_should_stop());
+	return 0;
+}
+
+static struct sun4i_ss_alg_template driver_algs[] =3D {/*
 {       .type =3D CRYPTO_ALG_TYPE_AHASH,
 	.alg.hash =3D {
 		.init =3D sun4i_hash_init,
@@ -77,14 +146,14 @@ static struct sun4i_ss_alg_template driver_algs[] =3D =
{
 			}
 		}
 	}
-},
+},*/
 {       .type =3D CRYPTO_ALG_TYPE_ABLKCIPHER,
 	.alg.crypto =3D {
 		.cra_name =3D "cbc(aes)",
 		.cra_driver_name =3D "cbc-aes-sun4i-ss",
 		.cra_priority =3D 300,
 		.cra_blocksize =3D AES_BLOCK_SIZE,
-		.cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 		.cra_ctxsize =3D sizeof(struct sun4i_tfm_ctx),
 		.cra_module =3D THIS_MODULE,
 		.cra_alignmask =3D 3,
@@ -99,7 +168,7 @@ static struct sun4i_ss_alg_template driver_algs[] =3D {
 			.decrypt        =3D sun4i_ss_cbc_aes_decrypt,
 		}
 	}
-},
+},/*
 {       .type =3D CRYPTO_ALG_TYPE_ABLKCIPHER,
 	.alg.crypto =3D {
 		.cra_name =3D "ecb(aes)",
@@ -208,7 +277,7 @@ static struct sun4i_ss_alg_template driver_algs[] =3D {
 				.decrypt        =3D sun4i_ss_ecb_des3_decrypt,
 		}
 	}
-},
+},*/
 };

 static int sun4i_ss_probe(struct platform_device *pdev)
@@ -313,8 +382,16 @@ static int sun4i_ss_probe(struct platform_device *pdev=
)

 	ss->dev =3D &pdev->dev;

+	crypto_init_queue(&ss->queue, 50);
+
 	spin_lock_init(&ss->slock);

+	ss->thread =3D kthread_run(sun4i_ss_thread, ss, "sun4i_sskd");
+	if (IS_ERR(ss->thread)) {
+		err =3D PTR_ERR(ss->thread);
+		goto error_thread;
+	}
+
 	for (i =3D 0; i < ARRAY_SIZE(driver_algs); i++) {
 		driver_algs[i].ss =3D ss;
 		switch (driver_algs[i].type) {
@@ -347,6 +424,8 @@ error_alg:
 			break;
 		}
 	}
+error_thread:
+	kthread_stop(ss->thread);
 error_clk:
 	clk_disable_unprepare(ss->ssclk);
 error_ssclk:
@@ -359,6 +438,8 @@ static int sun4i_ss_remove(struct platform_device *pdev=
)
 	int i;
 	struct sun4i_ss_ctx *ss =3D platform_get_drvdata(pdev);

+	kthread_stop(ss->thread);
+
 	sun4i_ss_hwrng_remove(&ss->hwrng);

 	for (i =3D 0; i < ARRAY_SIZE(driver_algs); i++) {
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/sunxi-ss/s=
un4i-ss.h
index 2185a05..8cdf00a 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss.h
+++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
@@ -132,6 +132,8 @@ struct sun4i_ss_ctx {
 	struct device *dev;
 	struct resource *res;
 	spinlock_t slock; /* control the use of the device */
+	struct crypto_queue queue;
+	struct task_struct *thread;
 	struct hwrng hwrng;
 	u32 seed[SS_SEED_LEN / 4];
 };
@@ -165,6 +167,9 @@ struct sun4i_req_ctx {
 	struct sun4i_ss_ctx *ss;
 };

+int sun4i_ss_enqueue(struct crypto_async_request *areq);
+int sun4i_ss_cipher_poll(struct ablkcipher_request *areq);
+
 int sun4i_hash_crainit(struct crypto_tfm *tfm);
 int sun4i_hash_init(struct ahash_request *areq);
 int sun4i_hash_update(struct ahash_request *areq);

--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
