From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Hardware acceleration indication in af_alg
Date: Fri, 21 Oct 2011 15:23:36 +0200
Message-ID: <20111021132336.GA1080@gondor.apana.org.au>
References: <20111018131351.GB24865@qi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Matthias-Christian Ott <ott@mirix.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56592 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab1JUNXj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Oct 2011 09:23:39 -0400
Content-Disposition: inline
In-Reply-To: <20111018131351.GB24865@qi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Matthias-Christian Ott <ott@mirix.org> wrote:
> I did some experiments with af_alg and noticed that to be really
> useful, it should indicate whether a certain algorithm is hardware
> accelerated. I guess this has to be inferred by the priority of the
> algorithm could be made available via a read-only socket option. Any
> thoughts on this?
> 
> I can imagine, an alternative approach and perhaps better approach
> would be to measure the speed of the kernel provided algorithm against
> a software implementation, but there are many other factors that could
> influence the results. Therefore, it is perhaps better to just make
> the assumption that hardware acceleration is faster which is made in
> the kernel anyhow.

You have to be careful to distinguish between hardware acceleration
that is directly available to user-space (such as AESNI) and those
that aren't.

For the former it makes zero sense to go through the kernel as
you'll only make it slower.  The latter case is the reason why
this interface exists.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
