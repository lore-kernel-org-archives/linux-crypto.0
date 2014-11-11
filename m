From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: zeroization of sensitive data in af_alg
Date: Tue, 11 Nov 2014 10:53:14 +0800
Message-ID: <20141111025314.GA14173@gondor.apana.org.au>
References: <1979092.odOtqL46qU@tachyon.chronox.de>
 <20141110140518.GD8578@gondor.apana.org.au>
 <1533864.71MuF2upah@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1533864.71MuF2upah@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 11, 2014 at 03:06:32AM +0100, Stephan Mueller wrote:
> Am Montag, 10. November 2014, 22:05:18 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Sun, Nov 09, 2014 at 11:33:52PM +0100, Stephan Mueller wrote:
> > > while working on the AF_ALG interface, I saw no active zeroizations of
> > > memory that may hold sensitive data that is maintained outside the kernel
> > > crypto API cipher handles. I think the following memory segments fall
> > > under that
> > > category:
> > Are you talking about temporary data that we generate as part of
> > the processing? If so they should be zeroed by the entity that
> > generates them.
> 
> I currently see that the IV buffer (owned by skcipher) and the message digest 
> buffer (owned by hash) are not memset(0) before freeing them. I agree that 
> both are not really sensitive data. But wouldn't it be prudent to memset(0) 
> them nonetheless in the skcipher_sock_destruct and hash_sock_destruct 
> functions, respectively? 

Yes please submit your patches.
 
> Apologies, my bad as I did not check get_user_pages_fast well enough. I see 
> now that we operate on the pages in user space directly without copy_from_user 
> that would imply a kernel-internal copy. Please disregard my comment.

OK.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
