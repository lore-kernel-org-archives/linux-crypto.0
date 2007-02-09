From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Asynchronus crypto API
Date: Fri, 9 Feb 2007 15:31:02 +0300
Message-ID: <20070209123100.GA3988@2ka.mipt.ru>
References: <20070209110800.GB25171@amd.com> <20070209113108.GA11467@2ka.mipt.ru> <20070209121602.GC25171@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Joerg Roedel <joerg.roedel@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:48776 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946415AbXBIM5J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Feb 2007 07:57:09 -0500
Content-Disposition: inline
In-Reply-To: <20070209121602.GC25171@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Feb 09, 2007 at 01:16:02PM +0100, Joerg Roedel (joerg.roedel@amd.com) wrote:
> Hello Evgeniy,
> 
> On Fri, Feb 09, 2007 at 02:31:11PM +0300, Evgeniy Polyakov wrote:
> > On Fri, Feb 09, 2007 at 12:08:00PM +0100, Joerg Roedel (joerg.roedel@amd.com) wrote:
> > > Background: I recently bought a HIFN crypto card and would like to use
> > > it under Linux without the need to use some external patchsets :)
> > 
> > Not for now - either use acrypto [1] or ocf [2].
> 
> Yes, these two I meant with "external patchsets" :-)
> It would be nice to have an asynchronous API in the mainstream kernel.
> An the documentation says it is under development, therefore I ask :)

It is - Herbert's work on stackable algo registration is a first step,
although when we had async crypto discussion last time (about a year or couple
ago) we was unable to get into consensus - I still think that it is
quite impossible to have good async support with existing
software-oriented cryptoapi, while Herbert have some ideas in mind.

Work is being done, just not too fast.
You can find a brief todo in archive of how Herbert planned to implement
that and, if you like, get into that too - that would be very
appreciated.

> Joerg
> 
> -- 
> Joerg Roedel
> Operating System Research Center
> AMD Saxony LLC & Co. KG
> 

-- 
	Evgeniy Polyakov
