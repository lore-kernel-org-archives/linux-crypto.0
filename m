From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: Remaining crypto API regressions with CONFIG_VMAP_STACK
Date: Fri, 9 Dec 2016 21:55:31 -0800
Message-ID: <20161210055531.GB6846@zzz>
References: <20161209230851.GB64048@google.com>
 <CALCETrW=+3u3P8Xva+0ck9=fr-mD6azPtTkOQ3uQO+GoOA6FcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Lutomirski <luto@kernel.org>,
	Stephan Mueller <smueller@chronox.de>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <CALCETrW=+3u3P8Xva+0ck9=fr-mD6azPtTkOQ3uQO+GoOA6FcQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Dec 09, 2016 at 09:25:38PM -0800, Andy Lutomirski wrote:
> > The following crypto drivers initialize a scatterlist to point into an
> > ahash_request, which may have been allocated on the stack with
> > AHASH_REQUEST_ON_STACK():
> >
> >         drivers/crypto/bfin_crc.c:351
> >         drivers/crypto/qce/sha.c:299
> >         drivers/crypto/sahara.c:973,988
> >         drivers/crypto/talitos.c:1910
> 
> This are impossible or highly unlikely on x86.
> 
> >         drivers/crypto/ccp/ccp-crypto-aes-cmac.c:105,119,142
> >         drivers/crypto/ccp/ccp-crypto-sha.c:95,109,124
> 
> These
> 
> >         drivers/crypto/qce/sha.c:325
> 
> This is impossible on x86.
> 

Thanks for looking into these.  I didn't investigate who/what is likely to be
using each driver.

Of course I would not be surprised to see people want to start supporting
virtually mapped stacks on other architectures too.

> >
> > The "good" news with these bugs is that on x86_64 without CONFIG_DEBUG_SG=y or
> > CONFIG_DEBUG_VIRTUAL=y, you can still do virt_to_page() and then page_address()
> > on a vmalloc address and get back the same address, even though you aren't
> > *supposed* to be able to do this.  This will make things still work for most
> > people.  The bad news is that if you happen to have consumed just about 1 page
> > (or N pages) of your stack at the time you call the crypto API, your stack
> > buffer may actually span physically non-contiguous pages, so the crypto
> > algorithm will scribble over some unrelated page.
> 
> Are you sure?  If it round-trips to the same virtual address, it
> doesn't matter if the buffer is contiguous.

You may be right, I didn't test this.  The hash_walk and blkcipher_walk code do
go page by page, but I suppose on x86_64 it would just step from one bogus
"struct page" to the adjacent one and still map it to the original virtual
address.

Eric

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
