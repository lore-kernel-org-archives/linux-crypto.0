From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: CONFIG_CRYPTO_PCRYPT, CONFIG_CRYPTO_CRYPTD etc. questions
Date: Tue, 11 Oct 2011 11:17:06 +0200
Message-ID: <20111011091706.GA1830@secunet.com>
References: <CAGmahrQ5YC0UynzyjzMcvunh_UgKo-OMF6A9PM_nD3w12hrM2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sverd Johnsen <sverd.johnsen@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:44909 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1JKJRJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Oct 2011 05:17:09 -0400
Content-Disposition: inline
In-Reply-To: <CAGmahrQ5YC0UynzyjzMcvunh_UgKo-OMF6A9PM_nD3w12hrM2Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 09, 2011 at 01:00:08AM +0200, Sverd Johnsen wrote:
> Hey,
> 
> how do they work? Should one use them? Does it work with all ciphers?
> Do they exclude each other?

They don't exclude each other, but using both in an algorithm instance
does not make much sense. It depends on your usecase what to choose.

If a single cpu sends a lot of crypto requests (like it happens on
IPsec networking), it makes sense to parallelize with pcrypt. 

Usually you don't need to setup a cryptd algorithm expicit. If an
algorithm needs cryptd, it cooses it automatically. It is used e.g.
to move the crypto requests out of atomic context (AES-NI does this.)

> 
> Do they need module parameters? What if they are built-in?

They don't need module parameters. It does not matter much if they
are build-in or a module. If they are build-in, they can be just
instantiated. If they are build as module, the crypto layer tries
to autoload the module if it is not already loaded.

If you want to use pcrypt/cryptd on an algorithm that does not coose
them automatically, you have to instantiate (load) these algorithms.

Right now, using 'tcrypt' is the only way to instantiate such nonstandard
algorithms. That's kind of a hack, but things are getting much easier
as soon as we have the crypto userspace configuration API merged.

> How can I verify that they work?

You can look at /proc/crypto, this shows which algorithms are used.
You should find cryptd/pcrypt in the algorithm drivers name if they
are instantiated.

> How do they work? There is absolutely no fucking information
> whatsoever, neither in the help text nor in the docs. Am i missing
> something?

Indeed, there is no documentation.

> 
> Talking mostly about typical disk encryption on SMP machines via
> dm-crypt, interested in best performance. (without AES-NI)

dm-crypt uses it's own workqueue, so you don't need cryptd here.
On recent kernels this workqueue is multithreaded, so if the
crypto requests are send from multiple cpus it behaves well
parallelized. If only one cpu sends crypto requests, it is
serialized to this cpu. pcrypt could help here, but it still
lacks ablkcipher support what is needed for dm-crypt.
