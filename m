From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v1] compiler: prevent dead store elimination
Date: Mon, 1 Mar 2010 23:27:16 +0100
Message-ID: <20100301222716.GC29531@one.firstfloor.org>
References: <4B8984EE.8090605@gmail.com> <20100228211511.60981829@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Roel Kluin <roel.kluin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Mikael Pettersson <mikpe@it.uu.se>, penberg@cs.helsinki.fi,
	Brian Gerst <brgerst@gmail.com>, andi@firstfloor.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Herbert@gondor.apana.org.au
To: Arjan van de Ven <arjan@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:45404 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab0CAW1W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Mar 2010 17:27:22 -0500
Content-Disposition: inline
In-Reply-To: <20100228211511.60981829@infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 28, 2010 at 09:15:11PM -0800, Arjan van de Ven wrote:
> On Sat, 27 Feb 2010 21:47:42 +0100
> Roel Kluin <roel.kluin@gmail.com> wrote:
> > +void secure_bzero(void *p, size_t n)
> > +{
> > +	memset(p, 0, n);
> > +	ARRAY_PREVENT_DSE(p, n);
> > +}
> > +EXPORT_SYMBOL(secure_bzero);
> 
> 
> please don't introduce bzero again to the kernel;
> 
> make it secure_memset() please.

Would there ever be any reason to set the key to something
else than 0? 

IMHO bzero is less error prone. With memset there are regular 
bugs when the two end arguments get exchanged. 

You could call it differently if you have a problem with old BSD
names, but inherently there's nothing wrong with them. One possibility
would be the same name as VC++ uses.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
