From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] Export symbol ksize()
Date: Sun, 15 Feb 2009 19:38:36 -0600
Message-ID: <1234748316.5669.222.camel@calx>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
	 <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com>
	 <20090210134651.GA5115@epbyminw8406h.minsk.epam.com>
	 <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI>
	 <20090212104349.GA13859@gondor.apana.org.au>
	 <1234435521.28812.165.camel@penberg-laptop>
	 <20090212105034.GC13859@gondor.apana.org.au>
	 <1234454104.28812.175.camel@penberg-laptop>
	 <20090215133638.5ef517ac.akpm@linux-foundation.org>
	 <1234734194.5669.176.camel@calx>
	 <20090215135555.688ae1a3.akpm@linux-foundation.org>
	 <1234741781.5669.204.camel@calx>
	 <20090215170052.44ee8fd5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Geert.Uytterhoeven@sonycom.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20090215170052.44ee8fd5.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Sun, 2009-02-15 at 17:00 -0800, Andrew Morton wrote:
> On Sun, 15 Feb 2009 17:49:41 -0600 Matt Mackall <mpm@selenic.com> wrote:

> The whole concept is quite hacky and nasty, isn't it?.

It is, which is part of why we were trying to kill it. The primary users
were thing growing buffers ala realloc. So we were pushing to change the
callers to just do a realloc. But IPSEC doesn't fit well into that mold.

The fundamental problem here for networking is that 1500 is not very
close to a power of two and just about everything in the VM wants it to
be. If we could get SKBs fitting more nicely in memory, I think it would
cease to be a concern.

-- 
http://selenic.com : development and support for Mercurial and Linux


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
