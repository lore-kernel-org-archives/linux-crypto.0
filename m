From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] Export symbol ksize()
Date: Mon, 16 Feb 2009 19:29:59 +0200
Message-ID: <84144f020902160929k67ce1881p959646a326bb3f40@mail.gmail.com>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
	 <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com>
	 <20090210134651.GA5115@epbyminw8406h.minsk.epam.com>
	 <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI>
	 <20090216135643.GA6927@cmpxchg.org>
	 <1234801952.20430.33.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Johannes Weiner <hannes@cmpxchg.org>, "Kirill A. Shutemov" <kirill@shutemov.name>,
	Christoph Lameter <cl@linux-foundation.org>, Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>, Geert.Uytterhoeven@sonycom.com
To: Joe Perches <joe@perches.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1234801952.20430.33.camel@localhost>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2009-02-16 at 14:56 +0100, Johannes Weiner wrote:
>> One problem is that zeroing ksize()
>> bytes can have an overhead of nearly twice the actual allocation size.

On Mon, Feb 16, 2009 at 6:32 PM, Joe Perches <joe@perches.com> wrote:
> A possible good thing is when linux has a
> mechanism to use known zeroed memory in
> kzalloc or kcalloc, it's already good to go.

Hmm, kzfree() is not going to be all that common operation so there
won't be that many known zeroed regions and I suspect tracking them
will have more overhead than just doing the memset().

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
