From: Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH 3/9] crypto: Add a generic Poly1305 authenticator
 implementation
Date: Thu, 04 Jun 2015 21:42:31 +0200
Message-ID: <1433446951.2945.6.camel@martin>
References: <1433159044-30753-1-git-send-email-martin@strongswan.org>
	 <1433159044-30753-4-git-send-email-martin@strongswan.org>
	 <20150604095910.GA24246@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:57567 "EHLO
	mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbbFDTwD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Jun 2015 15:52:03 -0400
In-Reply-To: <20150604095910.GA24246@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

> I just realised that this doesn't quite work.  The key is shared
> by all users of the tfm, yet in your case you need it to be local

I agree, as Poly1305 uses a different key for each tag the current
approach doesn't work.

> I think the simplest solution is to make the key the beginning
> of the hashed text instead.  So the first two blocks that you
> process get used as the key.

Yes, that makes sense. I'll prepare a fix, might require some days,
though.

Thanks!
Martin
