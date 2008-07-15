From: Greg KH <greg@kroah.com>
Subject: Re: [stable] Crypto Fixes for 2.6.26
Date: Tue, 15 Jul 2008 10:17:36 -0700
Message-ID: <20080715171736.GA13328@kroah.com>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080509132343.GA12979@gondor.apana.org.au> <20080602080512.GA22059@gondor.apana.org.au> <20080709003741.GA32340@gondor.apana.org.au> <20080710125126.GA25843@gondor.apana.org.au> <6101e8c40807151007p3367a985sb3f70e876e109d76@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	stable@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Oliver Pinter <oliver.pntr@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33816 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbYGORVL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Jul 2008 13:21:11 -0400
Content-Disposition: inline
In-Reply-To: <6101e8c40807151007p3367a985sb3f70e876e109d76@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 15, 2008 at 07:07:47PM +0200, Oliver Pinter wrote:
> [CC stable]
> 
> On 7/10/08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > Hi Linus:
> >
> > Just found a regression introduced back in 2.6.25.  This causes
> > packet leaks when IPsec is in use.  When that leak grows it can
> > eventually lead to hung connections (as their send buffers are
> > used up) or worse.
> >
> > Please pull from
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

Herbert, can you let me know what the git commit id is for this fix?

And do you want it added to the .25 and .26 -stable releases?

Oliver, thanks for the pointer.

thanks,

greg k-h
