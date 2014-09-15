From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: memzero_explicit - make sure to clear out
 sensitive data
Date: Mon, 15 Sep 2014 19:52:39 +0800
Message-ID: <20140915115239.GA5057@gondor.apana.org.au>
References: <1410125018-27277-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, hannes@stressinduktion.org,
	linux-crypto@vger.kernel.org, gmazyland@gmail.com,
	Julia Lawall <julia.lawall@lip6.fr>
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:33386 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbaIOLwx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Sep 2014 07:52:53 -0400
Content-Disposition: inline
In-Reply-To: <1410125018-27277-1-git-send-email-dborkman@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Sep 07, 2014 at 11:23:38PM +0200, Daniel Borkmann wrote:
> Recently, in commit 13aa93c70e71 ("random: add and use memzero_explicit()
> for clearing data"), we have found that GCC may optimize some memset()
> cases away when it detects a stack variable is not being used anymore
> and going out of scope. This can happen, for example, in cases when we
> are clearing out sensitive information such as keying material or any
> e.g. intermediate results from crypto computations, etc.
> 
> With the help of Coccinelle, we can figure out and fix such occurences
> in the crypto subsytem as well. Julia Lawall provided the following
> Coccinelle program:
> 
>   @@
>   type T;
>   identifier x;
>   @@
> 
>   T x;
>   ... when exists
>       when any
>   -memset
>   +memzero_explicit
>      (&x,
>   -0,
>      ...)
>   ... when != x
>       when strict
> 
>   @@
>   type T;
>   identifier x;
>   @@
> 
>   T x[...];
>   ... when exists
>       when any
>   -memset
>   +memzero_explicit
>      (x,
>   -0,
>      ...)
>   ... when != x
>       when strict
> 
> Therefore, make use of the drop-in replacement memzero_explicit() for
> exactly such cases instead of using memset().
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
