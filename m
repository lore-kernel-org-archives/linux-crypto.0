From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1 v8] Add CryptoAPI User Interface Support v8
Date: Wed, 25 Feb 2009 11:26:33 +0800
Message-ID: <20090225032633.GA31120@gondor.apana.org.au>
References: <DB599F406D04E34389140B7D99C71B1B06F2B86C@SDCEXCHANGE01.ad.amcc.com> <20090128044634.GE13157@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D605D3F8FD@SDCEXCHANGE01.ad.amcc.com> <20090223093558.GC10515@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D605E823E1@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
	Shasi Pulijala <spulijala@amcc.com>
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50730 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754006AbZBYD0l (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Feb 2009 22:26:41 -0500
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D605E823E1@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 23, 2009 at 10:46:43AM -0800, Loc Ho wrote:
>
> I'd like to see a name field.  It's better to have user-space
> pass through a string for the type instead of an ID.
> 
> The reason you want user-space to pass that through is so that
> you can locate the crypto_type object and then call crypto_alloc_tfm
> on it..
> 
> [Loc Ho]
> The name field would not be known here. It will be at the cryptodev layer as it is the layer that create the tfm. In the above two functions, the parameter tfm has already been created.

Well it would be known if you added a name field to uspace_session
below :)

> Also the other two functions should take a void * instead of
> crypto_tfm * since crypto_alloc_tfm now returns that.
> 
> [Loc Ho]
> The function ctxsize, init, exit, and show already existed. For cryptodev, I added only uspace_setparam and uspace_op. We will change their first parameter to void *.

Right I only meant the new functions.  These existing functions
will retain the crypto_tfm.

> > struct uspace_session {
> > 	__u8 alg_name[64];
> > 	__u32 front_type; /* I don't believe we need this - leave for now */
> 
> So instead of front_type I'd like to see front_type_name.
> 
> [Loc Ho]
> Okay... Maybe you see some value having a front_type_name. But as of right now, I only see the need for alg_name, type, and mask. 

It makes a difference because for different types we need to call
different construnction/alloc functions.  In fact, I think we should
add a construction function to the type object too.

> [Loc Ho]
> Okay... This would requires the caller to call the recvmsg and make use of standard async/sync socket interface. For async interface, caller will have to call the recvmsg. A sendmsg will always returns success unless HW ring is full. For sync interface, the function will block until the operation completed. If we switch to this interface, are you going to stick with this interface and apply this - at least until there is a better reason to change? Even if there is a good reason to change, I would like to see a version available in the crypto tree if not Linux kernel release tree. We will also look at splice as well if time permit.

Well once an interface hits Linus's tree that's it, game over :)
So that's we're having all these discussions in order to make sure
that we don't have any regrets.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
