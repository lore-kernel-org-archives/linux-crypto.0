From: Eric Biggers <ebiggers@google.com>
Subject: Re: vmalloced stacks and scatterwalk_map_and_copy()
Date: Thu, 3 Nov 2016 14:12:07 -0700
Message-ID: <20161103211207.GB63852@google.com>
References: <20161103181624.GA63852@google.com>
 <CALCETrUPuunBT1Zo25wyOwqaWJ=rm9R-WMZGN-7u4-dsdokAnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUPuunBT1Zo25wyOwqaWJ=rm9R-WMZGN-7u4-dsdokAnQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 03, 2016 at 01:30:49PM -0700, Andy Lutomirski wrote:
> 
> Also, Herbert, it seems like the considerable majority of the crypto
> code is acting on kernel virtual memory addresses and does software
> processing.  Would it perhaps make sense to add a kvec-based or
> iov_iter-based interface to the crypto code?  I bet it would be quite
> a bit faster and it would make crypto on stack buffers work directly.

I'd like to hear Herbert's opinion on this too, but as I understand it, if a
symmetric cipher API operating on virtual addresses was added, similar to the
existing "shash" API it would only allow software processing.  Whereas with the
current API you can request a transform and use it the same way regardless of
whether the crypto framework has chosen a software or hardware implementation,
or a combination thereof.  If this wasn't a concern then I expect using virtual
addresses would indeed simplify things a lot, at least for users not already
working with physical memory (struct page).

Either way, in the near term it looks like 4.9 will be released with the new
behavior that encryption/decryption is not supported on stack buffers.
Separately from the scatterwalk_map_and_copy() issue, today I've found two
places in the filesystem-level encryption code that do encryption on stack
buffers and therefore hit the 'BUG_ON(!virt_addr_valid(buf));' in sg_set_buf().
I will be sending patches to fix these, but I suspect there may be more crypto
API users elsewhere that have this same problem.

Eric
