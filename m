From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 12/35] crypto: padlock - Switch sha to shash
Date: Wed, 15 Jul 2009 12:28:18 +0200
Message-ID: <20090715102818.GM20288@secunet.com>
References: <20090715071424.GA19023@gondor.apana.org.au> <E1MQyij-0004zN-Ec@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:44702 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbZGOKZl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 06:25:41 -0400
Content-Disposition: inline
In-Reply-To: <E1MQyij-0004zN-Ec@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 15, 2009 at 03:16:05PM +0800, Herbert Xu wrote:
> crypto: padlock - Switch sha to shash
> 
> This patch converts the padlock-sha implementation to shash.
> In doing so the existing mechanism of storing the data until
> final is no longer viable as we do not have a way of allocating
> data in crypto_shash_init and then reliably freeing it.
> 
> This is just as well because a better way of handling the problem
> is to hash everything but the last chunk using normal sha code
> and then provide the intermediate result to the padlock device.
> 
> This is good enough because the primary application of padlock-sha
> is IPsec and there the data is laid out in the form of an hmac
> header followed by the rest of the packet.  In essence we can
> provide all the data to the padlock as the hmac header only needs
> to be hashed once.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  drivers/crypto/Kconfig       |    2 
>  drivers/crypto/padlock-sha.c |  333 ++++++++++++++++++++-----------------------
>  2 files changed, 156 insertions(+), 179 deletions(-)
> 

Just FYI, I'm getting the following compiler error:

 CC [M]  drivers/crypto/padlock-sha.o
  LD      kernel/built-in.o
/home/klassert/git/linux-sinafe-2.6/drivers/crypto/padlock-sha.c: In function 'padlock_sha256_finup':
/home/klassert/git/linux-sinafe-2.6/drivers/crypto/padlock-sha.c:166: error: impossible register constraint in 'asm'
/home/klassert/git/linux-sinafe-2.6/drivers/crypto/padlock-sha.c:166: error: impossible register constraint in 'asm'
/home/klassert/git/linux-sinafe-2.6/drivers/crypto/padlock-sha.c:176: confused by earlier errors, bailing out
make[3]: *** [drivers/crypto/padlock-sha.o] Error 1

