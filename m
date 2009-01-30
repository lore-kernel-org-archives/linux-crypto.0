From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] MPI module
Date: Fri, 30 Jan 2009 14:25:06 +1100
Message-ID: <20090130032506.GA2822@gondor.apana.org.au>
References: <20090130001523.GA909@artemis.corp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Pierre Habouzit <madcoder@debian.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:32948 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751508AbZA3DZJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Jan 2009 22:25:09 -0500
Content-Disposition: inline
In-Reply-To: <20090130001523.GA909@artemis.corp>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Pierre Habouzit <madcoder@debian.org> wrote:
>
> My endgame is simple, I'd like to see an in-kernel SSL/TLS
> implementation in Linux happen. There are many reasons to want that,
> ranging from performance reasons (waking the userland each time you
> perform a handshake isn't particularly nice, and it's easy to make
> system-wide session caches) to really cool features being enabled:
>  - you can send "secure" file descriptors around through Unix Sockets,
>    or prepare a "secure" socket, let it be your stdin/stdout pair and
>    exec a service knowing nothing about SSL (think inetd-like stuff) ;
>  - you can deploy secure services where the actual server knows nothing
>    about the certificate that is used ;
>  - you can have a system-wide service dealing with peer certificate
>    validations and have a real system-wide policy in this regard ;
>  - you could even think of some netfilter stuff to enforce security on
>    a given socket, even if the service behind the socket knows nothing
>    about it (bye bye stunnel)...
> 
> Nowadays, the kernel has most of what we need cipher-wise for TLS/SSL.
> Only the key-exchange protocols and the very TLS protocol are lacking.
> I'm currently addressing the former issue, namely, bringing RSA and
> Diffie-Hellman to the kernel.

Stop right there.  There is absolutely no reason why you need
to do the TLS stuff in kernel to achieve the goals you listed
above.

What you should do is have user-space create the session, and
then give the keys to the kernel to do the data-path.  Please
take a look at IPsec for an example of how the work is divided
between user-space and the kernel.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
