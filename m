From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: hash finup() issue
Date: Thu, 27 Jan 2011 17:18:57 +1000
Message-ID: <20110127071857.GA30431@gondor.apana.org.au>
References: <4D3ED3CF.4080205@nokia.com> <20110125232917.GA14972@gondor.apana.org.au> <4D3FD18F.2020905@nokia.com> <20110126233217.GA26664@gondor.apana.org.au> <4D41150C.90806@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:33028 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1A0HTA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Jan 2011 02:19:00 -0500
Content-Disposition: inline
In-Reply-To: <4D41150C.90806@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 27, 2011 at 08:47:40AM +0200, Dmitry Kasatkin wrote:
> No.no.. That is not a flag for particular request...
> The flag is how total hash will be handled...
> 
> FINUP flag means that client will call finup().
> So it will be
> 
> update()
> update()
> ...
> update()
> finup()
> 
> 
> not
> update()
> ...
> update()
> final()...
> 
> In other words...
> update() means that it will be more data coming (like MSG_MORE)
> finup() is just final update...
> 
> Basically driver on update() will not do extra buffering..
> 
> Is it clear now?

No I have absolutely no idea what you're saying.  Can you give
an actual example of what the user is doing and what you want to
do in the driver?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
