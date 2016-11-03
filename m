From: Eric Biggers <ebiggers@google.com>
Subject: Re: vmalloced stacks and scatterwalk_map_and_copy()
Date: Thu, 3 Nov 2016 16:10:18 -0700
Message-ID: <20161103231018.GA85121@google.com>
References: <20161103181624.GA63852@google.com>
 <CALCETrUPuunBT1Zo25wyOwqaWJ=rm9R-WMZGN-7u4-dsdokAnQ@mail.gmail.com>
 <20161103211207.GB63852@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andrew Lutomirski <luto@kernel.org>, linux-mm@kvack.org
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20161103211207.GB63852@google.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 03, 2016 at 02:12:07PM -0700, Eric Biggers wrote:
> On Thu, Nov 03, 2016 at 01:30:49PM -0700, Andy Lutomirski wrote:
> > 
> > Also, Herbert, it seems like the considerable majority of the crypto
> > code is acting on kernel virtual memory addresses and does software
> > processing.  Would it perhaps make sense to add a kvec-based or
> > iov_iter-based interface to the crypto code?  I bet it would be quite
> > a bit faster and it would make crypto on stack buffers work directly.
> 
> I'd like to hear Herbert's opinion on this too, but as I understand it, if a
> symmetric cipher API operating on virtual addresses was added, similar to the
> existing "shash" API it would only allow software processing.  Whereas with the
> current API you can request a transform and use it the same way regardless of
> whether the crypto framework has chosen a software or hardware implementation,
> or a combination thereof.  If this wasn't a concern then I expect using virtual
> addresses would indeed simplify things a lot, at least for users not already
> working with physical memory (struct page).
> 
> Either way, in the near term it looks like 4.9 will be released with the new
> behavior that encryption/decryption is not supported on stack buffers.
> Separately from the scatterwalk_map_and_copy() issue, today I've found two
> places in the filesystem-level encryption code that do encryption on stack
> buffers and therefore hit the 'BUG_ON(!virt_addr_valid(buf));' in sg_set_buf().
> I will be sending patches to fix these, but I suspect there may be more crypto
> API users elsewhere that have this same problem.
> 
> Eric

[Added linux-mm to Cc]

For what it's worth, grsecurity has a special case to allow a scatterlist entry
to be created from a stack buffer:

	static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
				      unsigned int buflen)
	{
		const void *realbuf = buf;

	#ifdef CONFIG_GRKERNSEC_KSTACKOVERFLOW
		if (object_starts_on_stack(buf))
			realbuf = buf - current->stack + current->lowmem_stack;
	#endif

	#ifdef CONFIG_DEBUG_SG
		BUG_ON(!virt_addr_valid(realbuf));
	#endif
		sg_set_page(sg, virt_to_page(realbuf), buflen, offset_in_page(realbuf));
	}

It seems to maintain two virtual mappings for each stack, a physically
contiguous one (task_struct.lowmem_stack) and a physically non-contiguous one
(task_struct.stack).  This seems different from upstream CONFIG_VMAP_STACK which
just maintains a physically non-contiguous one.

I don't know about all the relative merits of the two approaches.  But one of
the things that will need to be done with the currently upstream approach is
that all callers of sg_set_buf() will need to be checked to make sure they
aren't using stack addresses, and any that are will need to be updated to do
otherwise, e.g. by using heap-allocated memory.  I suppose this is already
happening, but in the case of the crypto API it will probably take a while for
all the users to be identified and updated.  (And it's not always clear from the
local context whether something can be stack memory or not, e.g. the memory for
crypto request objects may be either.)

Eric

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
