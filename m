From: Willy Tarreau <w@1wt.eu>
Subject: Re: process? [Re: Crypto Fixes for 4.19]
Date: Wed, 19 Sep 2018 19:00:55 +0200
Message-ID: <20180919170055.GB32582@1wt.eu>
References: <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20180919062201.ov5o4vljvholgsed@gondor.apana.org.au>
 <20180919132324.GA24399@kroah.com>
 <d8c061a9-b415-e092-c28f-9e433d83b59b@infradead.org>
 <20180919164019.GA7195@kroah.com>
 <06e6fac1-6011-7117-454f-af930a288d75@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <06e6fac1-6011-7117-454f-af930a288d75@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 19, 2018 at 09:48:42AM -0700, Randy Dunlap wrote:
> On 9/19/18 9:40 AM, Greg KH wrote:
> > On Wed, Sep 19, 2018 at 09:10:55AM -0700, Randy Dunlap wrote:
> >> submitting-patches.rst says:
> >> The Signed-off-by: tag indicates that the signer was involved in the
> >> development of the patch, or that he/she was in the patch's delivery path.
> > 
> > Yes, but not for git pulls.
> > 
> > I have not applied any patches sent in emails at this point in time, so
> > there's nothing that I could have even signed off on.
> 
> OK, I see.

Just FWIW, if this line was added, it would change the commit message
hence the resulting hash. That's why it only appears on patches really
committed by the mentioned people (typically using "git am").

Willy
