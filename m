From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] Export symbol ksize()
Date: Sun, 15 Feb 2009 19:54:39 -0600
Message-ID: <1234749279.5669.225.camel@calx>
References: <1234435521.28812.165.camel@penberg-laptop>
	 <20090212105034.GC13859@gondor.apana.org.au>
	 <1234454104.28812.175.camel@penberg-laptop>
	 <20090215133638.5ef517ac.akpm@linux-foundation.org>
	 <1234734194.5669.176.camel@calx>
	 <20090215135555.688ae1a3.akpm@linux-foundation.org>
	 <1234741781.5669.204.camel@calx>
	 <20090215170052.44ee8fd5.akpm@linux-foundation.org>
	 <20090216012110.GA13575@gondor.apana.org.au>
	 <1234747726.5669.215.camel@calx>
	 <20090216015229.GA13892@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Geert.Uytterhoeven@sonycom.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20090216015229.GA13892@gondor.apana.org.au>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2009-02-16 at 09:52 +0800, Herbert Xu wrote:
> On Sun, Feb 15, 2009 at 07:28:46PM -0600, Matt Mackall wrote:
> >
> > Yeah. That sucks. We should probably stick in an skb-friendly slab size
> > and see what happens on network benchmarks.
> 
> I don't see how that's going to help since we don't want it to
> cross page boundaries either (having just wasted a day tracking
> down a virtual networking bug because of slab debugging and
> crossing page boundaries).

I'll bite.. what's wrong with page boundaries? Do we play per-SKB TLB
games in virtual network drivers?

-- 
http://selenic.com : development and support for Mercurial and Linux


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
