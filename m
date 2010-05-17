From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 3/4] padata: Add some code comments
Date: Mon, 17 May 2010 09:02:46 +0200
Message-ID: <20100517070246.GG2184@secunet.com>
References: <20100514114336.GB2184@secunet.com>
 <20100514114606.GD2184@secunet.com>
 <20100514091857.cd576ed2.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:47489 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab0EQHEq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 May 2010 03:04:46 -0400
Content-Disposition: inline
In-Reply-To: <20100514091857.cd576ed2.randy.dunlap@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Randy,

On Fri, May 14, 2010 at 09:18:57AM -0700, Randy Dunlap wrote:
> 
> Hi Steffen,
> 
> These comments are roughly 90% of the way to being kernel-doc notation,
> so how about going the rest of the way, please?
> 

yes of course we can. I read Documentation/kernel-doc-nano-HOWTO.txt,
so I need to use /** for all comments that I want to add to kernel-doc.
Anything else to do?

> 
> Use:
> /**
> in multiple places.
> 

I wondered several times why some comments start with /** while
others start with /*. Anyway, I did not pay too much attention
to this, because it was just the beginning line of a comment.
Now I know the difference :)


> /**
> 
> > + * padata_get_next - Get the next object that needs serialization.
> 

This one is a static function, I would not mind to add it to kernel-doc
too, but that's probaply not needed.

I'll resend this one with the suggested changes,
thanks for pointing this out.

Steffen
