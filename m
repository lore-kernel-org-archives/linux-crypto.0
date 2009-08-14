From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: ansi_cprng - Do not select FIPS
Date: Fri, 14 Aug 2009 13:13:40 +1000
Message-ID: <20090814031340.GA2380@gondor.apana.org.au>
References: <20090619123400.GA18778@gondor.apana.org.au> <20090619125500.GA18153@hmsreliant.think-freely.org> <20090813112955.GA25239@gondor.apana.org.au> <20090813144156.GA31826@shamino.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Neil Horman <nhorman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58505 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754442AbZHNDNm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2009 23:13:42 -0400
Content-Disposition: inline
In-Reply-To: <20090813144156.GA31826@shamino.rdu.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 13, 2009 at 10:41:56AM -0400, Neil Horman wrote:
>
> Is there a good way to select a tristate from a bool?  The logic is the right
> thing to do above, it just seems the mechanism comes up a bit short

I suppose you could turn FIPS itself into a tristate.  As it
should be used in just one spot, that would be easy to fix up.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
