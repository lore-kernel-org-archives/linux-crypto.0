From: James Hartley <James.Hartley@imgtec.com>
Subject: RE: [PATCH V3 1/2] crypto: Add Imagination Technologies hw hash
 accelerator
Date: Tue, 10 Mar 2015 12:30:20 +0000
Message-ID: <72BC0C8BD7BB6F45988A99382E5FBAE54446353E@hhmail02.hh.imgtec.org>
References: <1425610707-9869-1-git-send-email-james.hartley@imgtec.com>
 <1425610707-9869-2-git-send-email-james.hartley@imgtec.com>
 <1582962.nmzkjGWQFm@tauon> <20150310093707.GA17289@gondor.apana.org.au>
 <72BC0C8BD7BB6F45988A99382E5FBAE54446310E@hhmail02.hh.imgtec.org>
 <20150310095537.GA17765@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Stephan Mueller <smueller@chronox.de>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"pawel.moll@arm.com" <pawel.moll@arm.com>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	"galak@codeaurora.org" <galak@codeaurora.org>,
	"Andrew Bresticker (abrestic@chromium.org)" <abrestic@chromium.org>,
	Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:24523 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbbCJMaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Mar 2015 08:30:23 -0400
In-Reply-To: <20150310095537.GA17765@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Herbert Xu
> Sent: 10 March 2015 09:56
> To: James Hartley
> Cc: Stephan Mueller; robh+dt@kernel.org; pawel.moll@arm.com;
> mark.rutland@arm.com; galak@codeaurora.org; Andrew Bresticker
> (abrestic@chromium.org); Ezequiel Garcia; linux-crypto@vger.kernel.org
> Subject: Re: [PATCH V3 1/2] crypto: Add Imagination Technologies hw hash
> accelerator
> 
> On Tue, Mar 10, 2015 at 09:54:49AM +0000, James Hartley wrote:
> >
> > > Hi Herbert, and Stephan,
> > >
> > > The difficulty here is that the driver was written by a summer
> > > placement student who has since left the company, and despite
> > > searching our internal commit logs I'm unable to find any reason why
> > > 301 and 3000 are used.  I am happy to set them to 300 if that is a
> sensible figure to use.
> 
> OK please resend the patches with that change James.

Will do, I want to address Andrew Bresticker's review comments first though.

Thanks, 
James

> 
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
