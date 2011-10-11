From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Tue, 11 Oct 2011 11:42:22 +0200
Message-ID: <20111011094222.GB1830@secunet.com>
References: <AANLkTinm8uy34ni_4XFLZTcdkndy0B_jeFXag0onxA66@mail.gmail.com>
 <AANLkTin8au=98mmfsaJjOSyJNibk3foZWihj6EGTGWK-@mail.gmail.com>
 <20110126070939.GA18150@gondor.apana.org.au>
 <AANLkTi=m0jVWSqR1FNX9r9HH32LbA0aWJxSQtLd_VszW@mail.gmail.com>
 <20110126233315.GB26664@gondor.apana.org.au>
 <CAFuf8QO1gG2WUMmgywHANBHgBj1D8RV8xkJvMYOdiJSovduG+A@mail.gmail.com>
 <20110705065351.GA31107@gondor.apana.org.au>
 <CAFuf8QPV248w=S06s7mz=vLzYdsrjQ7nvChui-3P3kgMzV8vHA@mail.gmail.com>
 <20111004075755.GV1808@secunet.com>
 <CAFuf8QOCKXOgMyu7FceYRGh_oTw+pt96tasVC19pS1Zzd96mxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Hamid Nassiby <h.nassiby@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:49373 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863Ab1JKJm3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Oct 2011 05:42:29 -0400
Content-Disposition: inline
In-Reply-To: <CAFuf8QOCKXOgMyu7FceYRGh_oTw+pt96tasVC19pS1Zzd96mxQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 05, 2011 at 01:33:33PM +0330, Hamid Nassiby wrote:
> 
> OK, I represented code as PSEUSO, just to simplify and concentrate problem's
> aspects ;),  (but it is also possible that I've concentrated it in a
> wrong way :D)
> This is my_cbc_encrypt code and functions it calls, bottom-up:
> 
> int write_request(u8 *buff, unsigned int count)
> {
> 
> 	u32  tlp_size = 32;
> 	struct my_dma_desc *desc_table = (struct my_dma_desc *)global_bar[0];
> 	tlp_size = (count/128) | (tlp_size << 16);
> 	memcpy(g_mydev->rdmaBuf_va, buff, count);
> 	wmb();
> 
> 	writel(cpu_to_le32(tlp_size),(&desc_table->wdmaperf));
> 	wmb();
> 
> 	while((readl(&desc_table->ddmacr) | 0xFFFF0000)!= 0xFFFF0101);/*wait for
>  						transfer compeltion*/
> 	return 0;
> }
> 
>  int my_transform(struct my_aes_op *op, int alg)
> {
> 
> 		int  req_len, err;
> 		unsigned long iflagsq, tflag;
> 		u8 *req_buf = NULL, *res_buf = NULL;
> 		alg_operation operation;
> 		if (op->len == 0)
> 			return 0;
> 		operation = !(op->dir);
> 
> 		create_request(alg, op->mode, operation, 0, op->key,
> 			  op->iv, op->src, op->len, &req_buf, &req_len); /*add
> 			header to original request and copy it to req_buf*/
> 
>  		spin_lock_irqsave(&glock, tflag);
> 		
> 		write_request(req_buf, req_len);/*now req_buf is sent to device
> 				, device en/decrypts request and writes the
> 				the result to a fixed dma mapped address*/
> 		if (err){
> 			printk(KERN_EMERG"Error WriteReuest:errcode=%d\n", err);
> 			//handle exception (never occured)
> 		}
> 		kfree(req_buf);
> 		req_buf = NULL;
> 
> 		memcpy(op->dst, (g_mydev->wdmaBuf_va, op->len);/*copy result from
> 			 fixed coherent dma mapped memory to destination*/
> 		spin_unlock_irqrestore(&glock, tflag);
> 		
> 		return op->len;
> }
> 
> static int
> my_cbc_encrypt(struct blkcipher_desc *desc,
> 		  struct scatterlist *dst, struct scatterlist *src,
> 		  unsigned int nbytes)
> {
> 	struct my_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
> 	struct blkcipher_walk walk;
> 	int err, ret;
> 	unsigned long c2flag;
> 	if (unlikely(op->keylen != AES_KEYSIZE_128))
> 		return fallback_blk_enc(desc, dst, src, nbytes);
> 
> 
> 	blkcipher_walk_init(&walk, dst, src, nbytes);
> 	err = blkcipher_walk_virt(desc, &walk);
> 	op->iv = walk.iv;
> 
> 	while((nbytes = walk.nbytes)) {
> 
> 		op->src = walk.src.virt.addr,
> 		op->dst = walk.dst.virt.addr;
> 		op->mode = AES_MODE_CBC;
> 		op->len = nbytes /*- (nbytes % AES_MIN_BLOCK_SIZE)*/;
> 		op->dir = AES_DIR_ENCRYPT;
> 		ret = my_transform(op, 0);
> 		nbytes -= ret;
> 		err = blkcipher_walk_done(desc, &walk, nbytes);
> 	}
> 
> 	return err;
> }
> 

I can't tell much when looking at this code snippet. One guess would be
someone (maybe you) has set the CRYPTO_TFM_REQ_MAY_SLEEP flag, as
blkcipher_walk_done calls crypto_yield() which in turn might call
schedule() if this flag is set. prcypt removes this flag explicit.

> 
> Did you turn BHs off, to prevent deadlocks  between your workqueues and
> network's softirqs?
> If there is any other thing that will help, I am pleased to hear.
> 

Basically, the bottom halves are off to keep up with the network softirqs.
They run with much higher priority and would interrupt the parallel
workers frequently.
