From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: IV copy strategy
Date: Fri, 16 Nov 2007 14:11:10 +0300
Message-ID: <20071116111110.GB31765@2ka.mipt.ru>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115211005.GA21159@Chamillionaire.breakpoint.cc> <20071116020851.GC32509@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43237 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbXKPLMa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Nov 2007 06:12:30 -0500
Content-Disposition: inline
In-Reply-To: <20071116020851.GC32509@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 16, 2007 at 10:08:51AM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > So a general question: Is it a must (requirement by the crypto API) to
> > copy the IV back or not? I guess not if we move completely to async (one
> > day) :)
> 
> You must copy it back to allow chaining.  Even when we go async
> someone may wish to chain.  So in that sense you've just found a
> bug in the hifn driver :)

That's a question - should it copy IV back or not?
Currently it is not required by crypto users.

P.S. Sebastian, your mailer seems not to setup reply-to, since each time
I reply, your mail is copied to the header :)

-- 
	Evgeniy Polyakov
