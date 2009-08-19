From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Wed, 19 Aug 2009 09:15:49 +0200
Message-ID: <20090819071549.GB14755@secunet.com>
References: <20090603115931.GA13361@gondor.apana.org.au> <20090605092030.GO20366@secunet.com> <20090605092021.GB8724@gondor.apana.org.au> <20090605093430.GP20366@secunet.com> <20090608052808.GB19826@gondor.apana.org.au> <20090608064518.GQ20366@secunet.com> <20090625065112.GA31869@gondor.apana.org.au> <20090629110410.GE20366@secunet.com> <20090629115950.GA6594@gondor.apana.org.au> <20090629135257.GG20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:56873 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbZHSHNC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Aug 2009 03:13:02 -0400
Content-Disposition: inline
In-Reply-To: <20090629135257.GG20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 29, 2009 at 03:52:57PM +0200, Steffen Klassert wrote:
> On Mon, Jun 29, 2009 at 07:59:50PM +0800, Herbert Xu wrote:
> > 
> > OK.  Can you send me the patches you used against the current
> > cryptodev tree (I only just pushed so give it an hour or so)?
> > I'll see if I can reproduce it here.
> > 
> 
> I'll send the remaining two patches in reply to this mail.
> The strange thing is that I can instantiate pcrypt if the priority is
> lower than the priority of authenc, but not if it's equal or higher.

Any ideas why it's not possible to instantiate pcrypt?

In between I updated padata to use the dynamic percpu allocator,
so the instantiating of pcrypt is the last issue I know of for the
moment.
