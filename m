From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_remove_spawns: BUG: unable to handle kernel NULL
	pointer dereference at 0000000000000018
Date: Mon, 15 Feb 2010 16:11:55 +0800
Message-ID: <20100215081155.GA18566@gondor.apana.org.au>
References: <20100214174507.GA8688@x200> <20100215052729.GA17156@gondor.apana.org.au> <b6fcc0a1002142347n1aff4326p3275e70b0ecea0e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45351 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755356Ab0BOIL7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Feb 2010 03:11:59 -0500
Content-Disposition: inline
In-Reply-To: <b6fcc0a1002142347n1aff4326p3275e70b0ecea0e3@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 15, 2010 at 09:47:25AM +0200, Alexey Dobriyan wrote:
> On Mon, Feb 15, 2010 at 7:27 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > Is this reproducible every time you unload aes_x86_64 after boot?
> 
> No, what I do is
> 
> 1. setup ipcomp in tunnel mode _in fresh netns_ and immediately exit
> 2. modprobe/rmmod all modules (not much)
> 
> ~1 hour of this workload and it hits sometimes with aes_x86_64,
> sometimes with aes_generic.

Was this with that IPCOMP bug fixed?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
