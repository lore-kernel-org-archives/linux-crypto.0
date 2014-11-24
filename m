From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto-next] crypto: algif - add and use sock_kzfree_s()
 instead of memzero_explicit()
Date: Mon, 24 Nov 2014 22:05:59 +0800
Message-ID: <20141124140559.GA31373@gondor.apana.org.au>
References: <1416413591-30146-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36286 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaKXOGJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2014 09:06:09 -0500
Content-Disposition: inline
In-Reply-To: <1416413591-30146-1-git-send-email-dborkman@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 19, 2014 at 05:13:11PM +0100, Daniel Borkmann wrote:
> Commit e1bd95bf7c25 ("crypto: algif - zeroize IV buffer") and
> 2a6af25befd0 ("crypto: algif - zeroize message digest buffer")
> added memzero_explicit() calls on buffers that are later on
> passed back to sock_kfree_s().
> 
> This is a discussed follow-up that, instead, extends the sock
> API and adds sock_kzfree_s(), which internally uses kzfree()
> instead of kfree() for passing the buffers back to slab.
> 
> Having sock_kzfree_s() allows to keep the changes more minimal
> by just having a drop-in replacement instead of adding
> memzero_explicit() calls everywhere before sock_kfree_s().
> 
> In kzfree(), the compiler is not allowed to optimize the memset()
> away and thus there's no need for memzero_explicit(). Both,
> sock_kfree_s() and sock_kzfree_s() are wrappers for
> __sock_kfree_s() and call into kfree() resp. kzfree(); here,
> __sock_kfree_s() needs to be explicitly inlined as we want the
> compiler to optimize the call and condition away and thus it
> produces e.g. on x86_64 the _same_ assembler output for
> sock_kfree_s() before and after, and thus also allows for
> avoiding code duplication.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Dave, any comment on this patch?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
