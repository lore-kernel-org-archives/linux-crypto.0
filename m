From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Export symbol ksize()
Date: Fri, 13 Feb 2009 07:09:34 +0800
Message-ID: <20090212230934.GA21609@gondor.apana.org.au>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name> <1234435521.28812.165.camel@penberg-laptop> <20090212105034.GC13859@gondor.apana.org.au> <200902130010.46623.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Christoph Lameter <cl@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	Geert.Uytterhoeven@sonycom.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46555 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750776AbZBLXKE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Feb 2009 18:10:04 -0500
Content-Disposition: inline
In-Reply-To: <200902130010.46623.nickpiggin@yahoo.com.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 13, 2009 at 12:10:45AM +1100, Nick Piggin wrote:
> 
> I would be interested to know how that goes. You always have this
> circular issue that if a little more space helps significantly, then
> maybe it is a good idea to explicitly ask for those bytes. Of course
> that larger allocation is also likely to have some slack bytes.

Well, the thing is we don't know apriori whether we need the
extra space.  The idea is to use the extra space if available
to avoid reallocation when we hit things like IPsec.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
