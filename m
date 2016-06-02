From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v2 1/2] crypto: engine: permit to enqueue ashash_request
Date: Thu, 2 Jun 2016 11:38:35 +0200
Message-ID: <20160602093835.GB2521@Red>
References: <1464615122-16685-1-git-send-email-clabbe.montjoie@gmail.com>
 <1464615122-16685-2-git-send-email-clabbe.montjoie@gmail.com>
 <20160602083258.GB15226@gondor.apana.org.au>
 <20160602091213.GA2521@Red>
 <20160602091940.GB16160@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, baolin.wang@linaro.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160602091940.GB16160@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 02, 2016 at 05:19:40PM +0800, Herbert Xu wrote:
> On Thu, Jun 02, 2016 at 11:12:13AM +0200, LABBE Corentin wrote:
> > On Thu, Jun 02, 2016 at 04:32:59PM +0800, Herbert Xu wrote:
> > > On Mon, May 30, 2016 at 03:32:01PM +0200, LABBE Corentin wrote:
> > > > The current crypto engine allow only ablkcipher_request to be enqueued.
> > > > Thus denying any use of it for hardware that also handle hash algo.
> > > > 
> > > > This patch convert all ablkcipher_request references to the
> > > > more general crypto_async_request.
> > > > 
> > > > Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> > > 
> > > First of all your patches break bisection which is unacceptable.
> > > 
> > 
> > How do I break bisection ?
> 
> Because the kernel won't compile after your first patch.
> 
> Either do it as one single patch or use the more elaborate "new
> interafce" + "switchover" + "delete old interface" ritual.
> 

Since my patch is small and easy (and only one client is modified), do you mind if I choose the first one ?

> > So, if my hwcrypto can handle hash and ciphers, I need to have two engine and each crypt_one_request()/hash_one_request()
> > need to lock the engine.
> > Having only one engine that handle all types permit to avoid this locking.
> 
> OK then we should add some type-checking as you suggested.  What
> I don't want is just blind casting by the user of crypto_engine.

I will add this type checking on my patch against omap-aes/des.

Regards
