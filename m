From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: algif_skcipher: check for IV size superfluous?
Date: Mon, 10 Nov 2014 22:00:02 +0800
Message-ID: <20141110140002.GC8578@gondor.apana.org.au>
References: <8150359.mtACJVFlUb@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8150359.mtACJVFlUb@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Nov 08, 2014 at 01:32:30AM +0100, Stephan Mueller wrote:
> Hi Herbert,
> 
> I am in the process to extend algif_skcipher to support AEAD ciphers as well. 
> The code already works but I want to run final tests before releasing it.
> 
> In the course of the development I stumbled over the following code:
> 
> static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
> 			    struct msghdr *msg, size_t size)
> {
> ...
> 		if (con.iv && con.iv->ivlen != ivsize)
> 			return -EINVAL;
> 
> This code effectively requires that any user space code trying to use a cipher 
> must provide an IV that is equal to the blocksize of the cipher.
> 
> I am wondering why this check is there or whether we can remove that.
> 
> When using the kernel crypto API inside the kernel, there is no such 
> enforcement. One can take shorter IVs which are implicitly padded with 
> trailing zeros.

The kernel requires you to provide an IV that's exactly the size
required by the algorithm.  As otherwise the API would need to
specify an explicit IV size per request.
 
> However, if we conclude that the check should remain, then I am wondering 
> whether we have to move it to the various _setiv functions of the kernel 
> crypto API instead of leaving it in the skcipher interface. 

The kernel interface does not have an explicit IV size in the
request.  Therefore there is no way for us to check.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
