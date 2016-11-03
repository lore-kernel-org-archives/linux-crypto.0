From: Eric Biggers <ebiggers@google.com>
Subject: vmalloced stacks and scatterwalk_map_and_copy()
Date: Thu, 3 Nov 2016 11:16:24 -0700
Message-ID: <20161103181624.GA63852@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        luto@kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

I hit the BUG_ON() in arch/x86/mm/physaddr.c:26 while testing some crypto code
in an x86_64 kernel with CONFIG_DEBUG_VIRTUAL=y and CONFIG_VMAP_STACK=y:

	/* carry flag will be set if starting x was >= PAGE_OFFSET */
	VIRTUAL_BUG_ON((x > y) || !phys_addr_valid(x));

The problem is the following code in scatterwalk_map_and_copy() in
crypto/scatterwalk.c, which tries to determine if the buffer passed in aliases
the physical memory of the first segment of the scatterlist:

        if (sg_page(sg) == virt_to_page(buf) &&
            sg->offset == offset_in_page(buf))
                return;

If 'buf' is on the stack with CONFIG_VMAP_STACK=y it will be a vmalloc address.
And virt_to_page(buf) does not have a meaningful behavior on vmalloc addresses.
Hence the BUG.

I don't think this should be fixed by forbidding passing a stack address to
scatterwalk_map_and_copy().  Not only are there a number of callers that
explicitly use stack addresses (e.g. poly_verify_tag() in
crypto/chacha20poly1305.c) but it's also possible for a whole skcipher_request
to be allocated on the stack with the SKCIPHER_REQUEST_ON_STACK() macro.  Note
that this has nothing to do with DMA per se.

Another solution would be to make scatterwalk_map_and_copy() explicitly check
for virt_addr_valid().  But this would make the behavior of
scatterwalk_map_and_copy() confusing because it would detect aliasing but only
under some circumstances, and it would depend on the kernel config.

Currently I think the best solution would be to require that callers to
scatterwalk_map_and_copy() do not alias their source and destination.  Then the
alias check could be removed.  This check has only been there since v4.2 (commit
74412fd5d71b6), so I'd hope not many callers rely on the behavior.  I'm not sure
exactly which ones do, though.

Thoughts on this?

Eric
