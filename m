From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
Date: Wed, 25 Feb 2009 11:40:13 -0800
Message-ID: <20090225194013.GB6193@suse.de>
References: <49A54C23.8090209@suse.de> <20090225142000.GA4136@gondor.apana.org.au> <49A55499.6090700@suse.de> <82ecf08e0902250629n6a190165u557c21b0ebe797d5@mail.gmail.com> <49A556E3.1000309@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thiago Galesi <thiagogalesi@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Frank Seidel <frank@f-seidel.de>,
	akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
	nhorman@tuxdriver.com, lho@amcc.com, kaber@trash.net,
	darrenrjenkins@gmail.com
To: Frank Seidel <fseidel@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:45575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757023AbZBYTr0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 14:47:26 -0500
Content-Disposition: inline
In-Reply-To: <49A556E3.1000309@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 25, 2009 at 03:34:11PM +0100, Frank Seidel wrote:
> Thiago Galesi wrote:
> > If you write static char output[1024]; (even inside a function) it's
> > not allocated on the stack.
> 
> Oh, yes i misunderstood Herbert, sorry. But anyway isn't
> it preferred to kmalloc such arrays?
> Greg, i thought it was you who told me so, is that right?

Generally, yes, it is preferred.  But if it can be static, that's fine
too.

thanks,

greg k-h
