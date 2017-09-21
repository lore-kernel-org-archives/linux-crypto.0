From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG - remove SGL end indicator when chaining
Date: Thu, 21 Sep 2017 08:43:28 +0200
Message-ID: <2756839.ZIDvqujQOX@tauon.chronox.de>
References: <1913314.pET67Fvxje@positron.chronox.de> <4784255.BN0h4dhmNf@tauon.chronox.de> <20170920173133.GA16691@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Greg KH <greg@kroah.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170920173133.GA16691@kroah.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 20. September 2017, 19:31:33 CEST schrieb Greg KH:

Hi Herbert,

> On Wed, Sep 20, 2017 at 03:47:46PM +0200, Stephan Mueller wrote:
> > Am Mittwoch, 20. September 2017, 10:32:09 CEST schrieb Herbert Xu:
> > 
> > Hi Herbert,
> > 
> > > Hmm, this patch does not apply against the current tree.  Is this
> > > a stable-only patch?
> > 
> > This would be a stable-only patch. With the overhauling of the AF_ALG
> > memory handling, this is a no-issue any more.
> 
> If you want this as a stable-only patch, you need to resend it and
> justify it a bunch as to why it isn't in Linus's tree as well.

Would you push it or shall I send it?

Thanks

Ciao
Stephan
