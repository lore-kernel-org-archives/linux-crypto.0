From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Tue, 5 Jul 2011 14:53:51 +0800
Message-ID: <20110705065351.GA31107@gondor.apana.org.au>
References: <AANLkTinGGsjgBKD1LqhL2u4DOU_XrACK4D67nHfPnL5e@mail.gmail.com> <20101230211900.GA22742@gondor.apana.org.au> <AANLkTinm8uy34ni_4XFLZTcdkndy0B_jeFXag0onxA66@mail.gmail.com> <AANLkTin8au=98mmfsaJjOSyJNibk3foZWihj6EGTGWK-@mail.gmail.com> <20110126070939.GA18150@gondor.apana.org.au> <AANLkTi=m0jVWSqR1FNX9r9HH32LbA0aWJxSQtLd_VszW@mail.gmail.com> <20110126233315.GB26664@gondor.apana.org.au> <CAFuf8QO1gG2WUMmgywHANBHgBj1D8RV8xkJvMYOdiJSovduG+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Hamid Nassiby <h.nassiby@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:44819 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1GEGxy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jul 2011 02:53:54 -0400
Content-Disposition: inline
In-Reply-To: <CAFuf8QO1gG2WUMmgywHANBHgBj1D8RV8xkJvMYOdiJSovduG+A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 05, 2011 at 10:15:08AM +0330, Hamid Nassiby wrote:
>
> and preferably to :
> 
> /* Critical PSEUDO code */
> /* distinct locks for write_to_device and read_from_device */
>               spin_lock_irqsave(&lock1, flag1);
>                  write_to_device(op, 0, my_req_id);
>               spin_unlock_irqrestore(&lock1, flag1);
> 
>               spin_lock_irqsave(&lock2, flag2);
>                 ret = read_from_device(op, 0, my_req_id);
>               spin_unlock_irqrestore(&lock2, flag2);
> /* End of Critical PSEUDO*/
> 
> 
> Here, it seems we must have no problem, but as soon as one TCP flow starts
> the system hangs.

Do you know why it hangs?

It sounds like the problem isn't with the synchronisation itself,
which at worst will produce bogus packets, but something else in
your code that is leading to the dead-lock.

Please enable lockdep and related debugging features to track down
the problem.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
