From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Tue, 4 Oct 2011 09:57:55 +0200
Message-ID: <20111004075755.GV1808@secunet.com>
References: <AANLkTinGGsjgBKD1LqhL2u4DOU_XrACK4D67nHfPnL5e@mail.gmail.com>
 <20101230211900.GA22742@gondor.apana.org.au>
 <AANLkTinm8uy34ni_4XFLZTcdkndy0B_jeFXag0onxA66@mail.gmail.com>
 <AANLkTin8au=98mmfsaJjOSyJNibk3foZWihj6EGTGWK-@mail.gmail.com>
 <20110126070939.GA18150@gondor.apana.org.au>
 <AANLkTi=m0jVWSqR1FNX9r9HH32LbA0aWJxSQtLd_VszW@mail.gmail.com>
 <20110126233315.GB26664@gondor.apana.org.au>
 <CAFuf8QO1gG2WUMmgywHANBHgBj1D8RV8xkJvMYOdiJSovduG+A@mail.gmail.com>
 <20110705065351.GA31107@gondor.apana.org.au>
 <CAFuf8QPV248w=S06s7mz=vLzYdsrjQ7nvChui-3P3kgMzV8vHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Hamid Nassiby <h.nassiby@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:33851 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab1JDH6D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Oct 2011 03:58:03 -0400
Content-Disposition: inline
In-Reply-To: <CAFuf8QPV248w=S06s7mz=vLzYdsrjQ7nvChui-3P3kgMzV8vHA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 01, 2011 at 12:38:19PM +0330, Hamid Nassiby wrote:
> 
> And my_cbc_encrypt function as PSEUDO/real code (for simplicity of
> representation) is as:
> 
> static int
> my_cbc_encrypt(struct blkcipher_desc *desc,
> 		  struct scatterlist *dst, struct scatterlist *src,
> 		  unsigned int nbytes)
> {
> 		SOME__common_preparation_and_initializations;	
> 		
> 		spin_lock_irqsave(&myloc, myflags);
> 		send_request_to_device(&dev); /*sends request to device. After
> 					    processing request,device writes
> 					    result to destination*/
> 		while(!readl(complete_flag)); /*here we wait for a flag in
> 			  device register space indicating completion. */
> 		spin_unlock_irqrestore(&mylock, myflags);
> 	
> 	
> }

As I told you already in the private mail, it makes not too much sense
to parallelize the crypto layer and to hold a global lock during the
crypto operation. So if you really need this lock, you are much better
off without a parallelization.

> 
> With above code, I can successfully test IPSec gateway equipped with our
> hardware and get a 200Mbps throughput using Iperf. Now I am facing with another
> poblem. As I mentioned earlier, our hardware has 4 aes engines builtin. With
> above code I only utilize one of them.
> >From this point, we want to go a step further and utilize more than one aes
> engines of our device. Simplest solution appears to me is to deploy
> pcrypt/padata, made by Steffen Klassert. First instantiate in a dual
> core gateway :
> 	modprobe tcrypt alg="pcrypt(authenc(hmac(md5),cbc(aes)))" type=3
>  and test again. Running Iperf now gives me a very low
> throughput about 20Mbps while dmesg shows the following:
> 
>    BUG: workqueue leaked lock or atomic: kworker/0:1/0x00000001/10
>        last function: padata_parallel_worker+0x0/0x80

This looks like the parallel worker exited in atomic context,
but I can't tell you much more as long as you don't show us your code.

> 
> I must emphasize again that goal of deploying pcrypt/padata is to have more than
> one request present in our hardware (e.g. in a quad cpu system we'll have 4
> encryption and 4 decryption requests sent into our hardware). Also I tried using
> pcrypt/padata in a single cpu system with one change in pcrypt_init_padata
> function of pcrypt.c: passing 4 as max_active parameter of alloc_workqueue.
> In fact I called alloc_workqueue as:
> 
> alloc_workqueue(name, WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE, 4);

This does not make sense. max_active has to be 1 as we have to care about the
order of the work items, so we don't want to have more than one work item
executing at the same time per CPU. And as we run the parallel workers with BHs
off, it is not even possible to execute more than one work item at the same
time per CPU.
