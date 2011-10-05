From: Hamid Nassiby <h.nassiby@gmail.com>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Wed, 5 Oct 2011 13:33:33 +0330
Message-ID: <CAFuf8QOCKXOgMyu7FceYRGh_oTw+pt96tasVC19pS1Zzd96mxQ@mail.gmail.com>
References: <AANLkTinGGsjgBKD1LqhL2u4DOU_XrACK4D67nHfPnL5e@mail.gmail.com>
 <20101230211900.GA22742@gondor.apana.org.au> <AANLkTinm8uy34ni_4XFLZTcdkndy0B_jeFXag0onxA66@mail.gmail.com>
 <AANLkTin8au=98mmfsaJjOSyJNibk3foZWihj6EGTGWK-@mail.gmail.com>
 <20110126070939.GA18150@gondor.apana.org.au> <AANLkTi=m0jVWSqR1FNX9r9HH32LbA0aWJxSQtLd_VszW@mail.gmail.com>
 <20110126233315.GB26664@gondor.apana.org.au> <CAFuf8QO1gG2WUMmgywHANBHgBj1D8RV8xkJvMYOdiJSovduG+A@mail.gmail.com>
 <20110705065351.GA31107@gondor.apana.org.au> <CAFuf8QPV248w=S06s7mz=vLzYdsrjQ7nvChui-3P3kgMzV8vHA@mail.gmail.com>
 <20111004075755.GV1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55622 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab1JEKEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Oct 2011 06:04:05 -0400
Received: by bkbzt4 with SMTP id zt4so1912576bkb.19
        for <linux-crypto@vger.kernel.org>; Wed, 05 Oct 2011 03:04:04 -0700 (PDT)
In-Reply-To: <20111004075755.GV1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 4, 2011 at 11:27 AM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Sat, Oct 01, 2011 at 12:38:19PM +0330, Hamid Nassiby wrote:
> >
> > And my_cbc_encrypt function as PSEUDO/real code (for simplicity of
> > representation) is as:
> >
> > static int
> > my_cbc_encrypt(struct blkcipher_desc *desc,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct scatterlist *dst, struct sca=
tterlist *src,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int nbytes)
> > {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 SOME__common_preparation_and_initializa=
tions;
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&myloc, myflags);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 send_request_to_device(&dev); /*sends r=
equest to device. After
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 processing request,device writes
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 result to destination*/
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 while(!readl(complete_flag)); /*here we=
 wait for a flag in
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 device register spa=
ce indicating completion. */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&mylock, myflags=
);
> >
> >
> > }
>
> As I told you already in the private mail, it makes not too much sens=
e
> to parallelize the crypto layer and to hold a global lock during the
> crypto operation. So if you really need this lock, you are much bette=
r
> off without a parallelization.
>
Hi Steffen,
Thanks for your reply :).

It makes sense in two manners:
1. If request transmit time to device is much shorter=A0than request
processing time
=A0spent in device and the device has more than one processing engine.

=A02. It also can be advantageous when device has only one processing
engine and we
have multiple blkcipher requests pending behind entrance port of device=
,
because delay between request entrances to device will be shorter. The =
overall
advantage will be that our IPSec throughput gets nearer to our device b=
ulk
encryption throughput. (It is interesting to note that with our
current driver and device
configuration, if I test gateway throughput with a traffic belonging to=
 two SAs,
traveling through one link that connects them, I'll get a rate about
280Mbps(80Mbps
increase in comparison with one SA's traffic), while our device's bulk
processing is
about 400Mbps.)

Currently we want to take advantage of the latter case and then extend =
it.

>
>
>
> >
> > With above code, I can successfully test IPSec gateway equipped wit=
h our
> > hardware and get a 200Mbps throughput using Iperf. Now I am facing =
with another
> > poblem. As I mentioned earlier, our hardware has 4 aes engines buil=
tin. With
> > above code I only utilize one of them.
> > >From this point, we want to go a step further and utilize more tha=
n one aes
> > engines of our device. Simplest solution appears to me is to deploy
> > pcrypt/padata, made by Steffen Klassert. First instantiate in a dua=
l
> > core gateway :
> > =A0 =A0 =A0 modprobe tcrypt alg=3D"pcrypt(authenc(hmac(md5),cbc(aes=
)))" type=3D3
> > =A0and test again. Running Iperf now gives me a very low
> > throughput about 20Mbps while dmesg shows the following:
> >
> > =A0 =A0BUG: workqueue leaked lock or atomic: kworker/0:1/0x00000001=
/10
> > =A0 =A0 =A0 =A0last function: padata_parallel_worker+0x0/0x80
>
> This looks like the parallel worker exited in atomic context,
> but I can't tell you much more as long as you don't show us your code=
=2E

OK, I represented code as PSEUSO, just to simplify and concentrate prob=
lem's
aspects ;),  (but it is also possible that I've concentrated it in a
wrong way :D)
This is my_cbc_encrypt code and functions it calls, bottom-up:

int write_request(u8 *buff, unsigned int count)
{

	u32  tlp_size =3D 32;
	struct my_dma_desc *desc_table =3D (struct my_dma_desc *)global_bar[0]=
;
	tlp_size =3D (count/128) | (tlp_size << 16);
	memcpy(g_mydev->rdmaBuf_va, buff, count);
	wmb();

	writel(cpu_to_le32(tlp_size),(&desc_table->wdmaperf));
	wmb();

	while((readl(&desc_table->ddmacr) | 0xFFFF0000)!=3D 0xFFFF0101);/*wait=
 for
 						transfer compeltion*/
	return 0;
}

 int my_transform(struct my_aes_op *op, int alg)
{

		int  req_len, err;
		unsigned long iflagsq, tflag;
		u8 *req_buf =3D NULL, *res_buf =3D NULL;
		alg_operation operation;
		if (op->len =3D=3D 0)
			return 0;
		operation =3D !(op->dir);

		create_request(alg, op->mode, operation, 0, op->key,
			  op->iv, op->src, op->len, &req_buf, &req_len); /*add
			header to original request and copy it to req_buf*/

 		spin_lock_irqsave(&glock, tflag);
	=09
		write_request(req_buf, req_len);/*now req_buf is sent to device
				, device en/decrypts request and writes the
				the result to a fixed dma mapped address*/
		if (err){
			printk(KERN_EMERG"Error WriteReuest:errcode=3D%d\n", err);
			//handle exception (never occured)
		}
		kfree(req_buf);
		req_buf =3D NULL;

		memcpy(op->dst, (g_mydev->wdmaBuf_va, op->len);/*copy result from
			 fixed coherent dma mapped memory to destination*/
		spin_unlock_irqrestore(&glock, tflag);
	=09
		return op->len;
}

static int
my_cbc_encrypt(struct blkcipher_desc *desc,
		  struct scatterlist *dst, struct scatterlist *src,
		  unsigned int nbytes)
{
	struct my_aes_op *op =3D crypto_blkcipher_ctx(desc->tfm);
	struct blkcipher_walk walk;
	int err, ret;
	unsigned long c2flag;
	if (unlikely(op->keylen !=3D AES_KEYSIZE_128))
		return fallback_blk_enc(desc, dst, src, nbytes);


	blkcipher_walk_init(&walk, dst, src, nbytes);
	err =3D blkcipher_walk_virt(desc, &walk);
	op->iv =3D walk.iv;

	while((nbytes =3D walk.nbytes)) {

		op->src =3D walk.src.virt.addr,
		op->dst =3D walk.dst.virt.addr;
		op->mode =3D AES_MODE_CBC;
		op->len =3D nbytes /*- (nbytes % AES_MIN_BLOCK_SIZE)*/;
		op->dir =3D AES_DIR_ENCRYPT;
		ret =3D my_transform(op, 0);
		nbytes -=3D ret;
		err =3D blkcipher_walk_done(desc, &walk, nbytes);
	}

	return err;
}

>
> >
> > I must emphasize again that goal of deploying pcrypt/padata is to h=
ave more than
> > one request present in our hardware (e.g. in a quad cpu system we'l=
l have 4
> > encryption and 4 decryption requests sent into our hardware). Also =
I tried using
> > pcrypt/padata in a single cpu system with one change in pcrypt_init=
_padata
> > function of pcrypt.c: passing 4 as max_active parameter of alloc_wo=
rkqueue.
> > In fact I called alloc_workqueue as:
> >
> > alloc_workqueue(name, WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE, 4);
>
> This does not make sense. max_active has to be 1 as we have to care a=
bout the
> order of the work items, so we don't want to have more than one work =
item
> executing at the same time per CPU. And as we run the parallel worker=
s with BHs
> off, it is not even possible to execute more than one work item at th=
e same
> time per CPU.
>

Did you turn BHs off, to prevent deadlocks  between your workqueues and
network's softirqs?
If there is any other thing that will help, I am pleased to hear.

Thanks.
