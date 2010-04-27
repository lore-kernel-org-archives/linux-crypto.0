From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] net/ipsec: don't treat EINPROGRESS as a regular error
Date: Tue, 27 Apr 2010 09:35:03 +0800
Message-ID: <20100427013503.GA31427@gondor.apana.org.au>
References: <4B144627.7060901@gmail.com> <20091204212847.GC28480@deprecation.cyrius.com> <4BCB4009.70707@gmail.com> <20100418191719.GA2508@Chamillionaire.breakpoint.cc> <4BCE125F.30200@gmail.com> <20100424144215.GA9057@Chamillionaire.breakpoint.cc> <20100425011821.GA5284@gondor.apana.org.au> <20100425152928.GA14489@Chamillionaire.breakpoint.cc> <20100426011711.GA19734@gondor.apana.org.au> <20100426181142.GA22245@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "L.C." <lucorsel@gmail.com>, linux-arm-kernel@lists.infradead.org,
	Martin Michlmayr <tbm@cyrius.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:51400 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752997Ab0D0Bf2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Apr 2010 21:35:28 -0400
Content-Disposition: inline
In-Reply-To: <20100426181142.GA22245@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 26, 2010 at 08:11:42PM +0200, Sebastian Andrzej Siewior wrote:
>
> Excellent job Herbert, it does solve the problem.

Thanks for testing.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
