From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Fri, 31 Dec 2010 08:19:00 +1100
Message-ID: <20101230211900.GA22742@gondor.apana.org.au>
References: <AANLkTinGGsjgBKD1LqhL2u4DOU_XrACK4D67nHfPnL5e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Hamid Nassiby <h.nassiby@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:38202 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab0L3VTD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Dec 2010 16:19:03 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTinGGsjgBKD1LqhL2u4DOU_XrACK4D67nHfPnL5e@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hamid Nassiby <h.nassiby@gmail.com> wrote:
> Hi,
> 
> As some good news and additional information, with the following patch
> I no more get
> "UDP bad cheksum" error as I mentioned erlier with Iperf in udp mode.
> But some times I get the following call trace in dmesg after running
> Iperf in UDP mode, more than one time (and ofcourse Iperf stops
> transferring data while it uses 100% of CPU cycles.
> 
> 
> 
> [  130.171909] mydriver-aes: mydriver Crypto-Engine enabled.
> [  134.767846] NET: Registered protocol family 15
> [  200.031846] iperf: page allocation failure. order:0, mode:0x20
> [  200.031850] Pid: 10935, comm: iperf Tainted: P            2.6.36-zen1 #1
> [  200.031852] Call Trace:
> [  200.031860]  [<ffffffff8108ab39>] ? __alloc_pages_nodemask+0x6d3/0x722
> [  200.031864]  [<ffffffff810b454f>] ? virt_to_head_page+0x9/0x30
> [  200.031867]  [<ffffffff810afac2>] ? alloc_pages_current+0xa5/0xce
> [  200.031869]  [<ffffffff810899ad>] ? __get_free_pages+0x9/0x46
> [  200.031872]  [<ffffffff8102bbbf>] ? need_resched+0x1a/0x23
> [  200.031876]  [<ffffffff811a10ad>] ? blkcipher_walk_next+0x68/0x2d9

This means that your box has run out of memory temporarily.
If all errors were handled correctly it should continue at this
point.
 
> --- mydriver1   2010-12-21 15:20:17.000000000 +0330
> +++ mydriver2   2010-12-21 15:24:18.000000000 +0330
> @@ -1,4 +1,3 @@
> -
> static int
> mydriver_cbc_decrypt(struct blkcipher_desc *desc,
>                  struct scatterlist *dst, struct scatterlist *src,
> @@ -14,18 +13,17 @@ mydriver_cbc_decrypt(struct blkcipher_desc
>        err = blkcipher_walk_virt(desc, &walk);
>        op->iv = walk.iv;
>        
> -       while((nbytes = walk.nbytes)) {
> +       

However, your patch removes the error checking (and the loop
condition) which is why it crashes.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
