From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH v2] crypto: memzero_explicit - make sure to clear out
 sensitive data
Date: Mon, 08 Sep 2014 08:17:05 +0200
Message-ID: <1410157025.11627.10.camel@localhost>
References: <1410125018-27277-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, tytso@mit.edu,
	linux-crypto@vger.kernel.org, gmazyland@gmail.com,
	Julia Lawall <julia.lawall@lip6.fr>
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35752 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751483AbaIHGWv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Sep 2014 02:22:51 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by gateway2.nyi.internal (Postfix) with ESMTP id ED422206EC
	for <linux-crypto@vger.kernel.org>; Mon,  8 Sep 2014 02:17:07 -0400 (EDT)
In-Reply-To: <1410125018-27277-1-git-send-email-dborkman@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On So, 2014-09-07 at 23:23 +0200, Daniel Borkmann wrote:
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

I think this Coccinelle patch won't make it completely unnecessary for a
manual audit as it does not take optimizations (dead code eliminitation)
into account?

> 
> Therefore, make use of the drop-in replacement memzero_explicit() for
> exactly such cases instead of using memset().
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org

Thanks,
Hannes
