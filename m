From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: Remaining crypto API regressions with CONFIG_VMAP_STACK
Date: Sat, 10 Dec 2016 00:39:23 -0800
Message-ID: <20161210083923.GB8630@zzz>
References: <20161210060316.GC6846@zzz>
 <20161210081643.GA384@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel-hardening@lists.openwall.com, luto@amacapital.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, luto@kernel.org, smueller@chronox.de
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20161210081643.GA384@gondor.apana.org.au>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Dec 10, 2016 at 04:16:43PM +0800, Herbert Xu wrote:
> Why did you drop me from the CC list when you were replying to
> my email?
> 

Sorry --- this thread is Cc'ed to the kernel-hardening mailing list (which was
somewhat recently revived), and I replied to the email that reached me from
there.  It looks like it currently behaves a little differently from the vger
mailing lists, in that it replaces "Reply-To" with the address of the mailing
list itself rather than the sender.  So that's how you got dropped.  It also
seems to add a prefix to the subject...

I
> >> Are you sure? Any instance of *_ON_STACK must only be used with
> >> sync algorithms and most drivers under drivers/crypto declare
> >> themselves as async.
> > 
> > Why exactly is that?  Obviously, it wouldn't work if you returned from the stack
> > frame before the request completed, but does anything stop someone from using an
> > *_ON_STACK() request and then waiting for the request to complete before
> > returning from the stack frame?
> 
> The *_ON_STACK variants (except SHASH of course) were simply hacks
> to help legacy crypto API users to cope with the new async interface.
> In general we should avoid using the sync interface when possible.
> 
> It's a bad idea for the obvious reason that most of our async
> algorithms want to DMA and that doesn't work very well when you're
> using memory from the stack.

Sure, I just feel that the idea of "is this algorithm asynchronous?" is being
conflated with the idea of "does this algorithm operate on physical memory?".
Also, if *_ON_STACK are really not allowed with asynchronous algorithms can
there at least be a comment or a WARN_ON() to express this?

Thanks,

Eric

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
