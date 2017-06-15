From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 4.12
Date: Thu, 15 Jun 2017 17:42:10 +0800
Message-ID: <20170615094210.GA32322@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161215160732.GA16580@gondor.apana.org.au>
 <20170111115646.GA8943@gondor.apana.org.au>
 <20170304074119.GA3041@gondor.apana.org.au>
 <20170523034211.GA12748@gondor.apana.org.au>
 <20170608092320.GA6478@gondor.apana.org.au>
 <20170615005443.GA30435@gondor.apana.org.au>
 <CA+55aFwU1ZvJZK8x9QQtROjOVHG_ks-H3XpU+hjuf8BTxndN3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:56666 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdFOJmj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 05:42:39 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFwU1ZvJZK8x9QQtROjOVHG_ks-H3XpU+hjuf8BTxndN3g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 15, 2017 at 06:04:44PM +0900, Linus Torvalds wrote:
>
> Then you *could* implement SHASH_DESC_ON_STACK() as a kmalloc, and
> SHASH_DESC_DEALLOC() would be a kfree - but with an alloca()-like
> allocation the SHASH_DESC_DEALLOC() would be that "barrier_data()".
> 
> At that point the interface would make _sense_ at some conceptual
> level, rather than being a random hack for a small collection of
> random users of this thing.

Yes we could probably do that.

> There's a fair number of SHASH_DESC_ON_STACK users, are all the others
> safe for some random reason that just happens to be about code
> generation? Did people actually verify that?

If I understand this correctly this is only an issue if you directly
return a value from the shash_desc struct allocated on the stack.
This is usually rare as normally you'd return an error code and the
hash result would be written directly to some memory passed in from
the caller.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
