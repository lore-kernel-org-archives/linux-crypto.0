From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V3 1/2] crypto: Add Imagination Technologies hw hash
 accelerator
Date: Tue, 10 Mar 2015 20:55:37 +1100
Message-ID: <20150310095537.GA17765@gondor.apana.org.au>
References: <1425610707-9869-1-git-send-email-james.hartley@imgtec.com>
 <1425610707-9869-2-git-send-email-james.hartley@imgtec.com>
 <1582962.nmzkjGWQFm@tauon>
 <20150310093707.GA17289@gondor.apana.org.au>
 <72BC0C8BD7BB6F45988A99382E5FBAE54446310E@hhmail02.hh.imgtec.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"pawel.moll@arm.com" <pawel.moll@arm.com>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	"galak@codeaurora.org" <galak@codeaurora.org>,
	"Andrew Bresticker (abrestic@chromium.org)" <abrestic@chromium.org>,
	Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: James Hartley <James.Hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:43928 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbbCJJz5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Mar 2015 05:55:57 -0400
Content-Disposition: inline
In-Reply-To: <72BC0C8BD7BB6F45988A99382E5FBAE54446310E@hhmail02.hh.imgtec.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 10, 2015 at 09:54:49AM +0000, James Hartley wrote:
>
> > Hi Herbert, and Stephan,
> > 
> > The difficulty here is that the driver was written by a summer placement
> > student who has since left the company, and despite searching our internal
> > commit logs I'm unable to find any reason why 301 and 3000 are used.  I am
> > happy to set them to 300 if that is a sensible figure to use.

OK please resend the patches with that change James.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
