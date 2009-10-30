From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: pcrypt - Add pcrypt crypto parallelization
	wrapper
Date: Fri, 30 Oct 2009 09:30:55 -0400
Message-ID: <20091030133055.GB31693@gondor.apana.org.au>
References: <20091008072537.GG15653@secunet.com> <20091008072818.GI15653@secunet.com> <20091008.231833.107456737.davem@davemloft.net> <20091030100609.GR15653@secunet.com> <20091030125818.GA6379@gondor.apana.org.au> <20091030132734.GS15653@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56161 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756742AbZJ3Naz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Oct 2009 09:30:55 -0400
Content-Disposition: inline
In-Reply-To: <20091030132734.GS15653@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 30, 2009 at 02:27:34PM +0100, Steffen Klassert wrote:
>
> Ok, if it's required that BHs are off then everything is fine.
> In fact I solved this problem for pcrypt by switching off the BHs.
> I just was not sure whether this is the right way to do.

Yeah having random contexts for completion functions would only
create chaos :)

> I'm going to send a workqueue based version of padata/pcrypt
> within the next week.

Awesome!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
