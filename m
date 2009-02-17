From: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] Export symbol ksize()
Date: Tue, 17 Feb 2009 11:17:19 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0902171115010.29986@qirst.com>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>  <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com>  <20090210134651.GA5115@epbyminw8406h.minsk.epam.com>  <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI>
 <20090212104349.GA13859@gondor.apana.org.au>  <1234435521.28812.165.camel@penberg-laptop>  <20090212105034.GC13859@gondor.apana.org.au>  <1234454104.28812.175.camel@penberg-laptop>  <20090215133638.5ef517ac.akpm@linux-foundation.org>  <1234734194.5669.176.camel@calx>
  <20090215135555.688ae1a3.akpm@linux-foundation.org> <1234741781.5669.204.camel@calx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@linux-foundation.org>,
    Pekka Enberg <penberg@cs.helsinki.fi>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
    linux-mm@kvack.org, linux-crypto@vger.kernel.org,
    Geert.Uytterhoeven@sonycom.com
To: Matt Mackall <mpm@selenic.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1234741781.5669.204.camel@calx>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Sun, 15 Feb 2009, Matt Mackall wrote:

> And it -is- a category error. The fact that kmalloc is implemented on
> top of kmem_cache_alloc is an implementation detail that callers should
> not assume. They shouldn't call kfree() on kmem_cache_alloc objects
> (even though it might just happen to work), nor should they call
> ksize().

ksize does not take a kmem_cache pointer and it is mainly used for
figuring out how much space kmalloc really allocated for an object. As
such its more part of the kmalloc/kfree set of calls than the
kmem_cache_* calls.

We could add another call

	kmem_cache_size()

for symmetries sake.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
