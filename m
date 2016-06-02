From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: engine: permit to enqueue ashash_request
Date: Thu, 2 Jun 2016 17:19:40 +0800
Message-ID: <20160602091940.GB16160@gondor.apana.org.au>
References: <1464615122-16685-1-git-send-email-clabbe.montjoie@gmail.com>
 <1464615122-16685-2-git-send-email-clabbe.montjoie@gmail.com>
 <20160602083258.GB15226@gondor.apana.org.au>
 <20160602091213.GA2521@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, baolin.wang@linaro.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56640 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbcFBJTu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 05:19:50 -0400
Content-Disposition: inline
In-Reply-To: <20160602091213.GA2521@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 02, 2016 at 11:12:13AM +0200, LABBE Corentin wrote:
> On Thu, Jun 02, 2016 at 04:32:59PM +0800, Herbert Xu wrote:
> > On Mon, May 30, 2016 at 03:32:01PM +0200, LABBE Corentin wrote:
> > > The current crypto engine allow only ablkcipher_request to be enqueued.
> > > Thus denying any use of it for hardware that also handle hash algo.
> > > 
> > > This patch convert all ablkcipher_request references to the
> > > more general crypto_async_request.
> > > 
> > > Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> > 
> > First of all your patches break bisection which is unacceptable.
> > 
> 
> How do I break bisection ?

Because the kernel won't compile after your first patch.

Either do it as one single patch or use the more elaborate "new
interafce" + "switchover" + "delete old interface" ritual.

> So, if my hwcrypto can handle hash and ciphers, I need to have two engine and each crypt_one_request()/hash_one_request()
> need to lock the engine.
> Having only one engine that handle all types permit to avoid this locking.

OK then we should add some type-checking as you suggested.  What
I don't want is just blind casting by the user of crypto_engine.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
