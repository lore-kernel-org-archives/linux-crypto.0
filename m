From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Export symbol ksize()
Date: Thu, 12 Feb 2009 18:43:49 +0800
Message-ID: <20090212104349.GA13859@gondor.apana.org.au>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name> <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com> <20090210134651.GA5115@epbyminw8406h.minsk.epam.com> <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
	Christoph Lameter <cl@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	Geert.Uytterhoeven@sonycom.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45103 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756355AbZBLKoT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Feb 2009 05:44:19 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 10, 2009 at 04:06:53PM +0200, Pekka J Enberg wrote:
> 
> Herbert, what do you think of this (untested) patch? Alternatively, we 
> could do something like kfree_secure() but it seems overkill for this one 
> call-site.

I don't understand why you want to limit the use of ksize.  If
kmalloc is reserving more memory than what the user is asking for,
then we should let them know the exact amount so that the extra
bits aren't wasted.

The only way to do that is through ksize.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
