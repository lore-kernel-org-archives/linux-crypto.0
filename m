From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Asynchronus crypto API
Date: Wed, 14 Feb 2007 09:14:06 +1100
Message-ID: <20070213221406.GA30000@gondor.apana.org.au>
References: <20070209110800.GB25171@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Joerg Roedel <joerg.roedel@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4485 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325AbXBMWOX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Feb 2007 17:14:23 -0500
Content-Disposition: inline
In-Reply-To: <20070209110800.GB25171@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Feb 09, 2007 at 12:08:00PM +0100, Joerg Roedel wrote:
>
> Since this sentence is present at least since kernel 2.6.0 I would like
> to ask what the current state in the development of that API is?
> Is somebody still working on that API or are there some existing ideas
> for that which want to be implemented? I would like to help out with
> that if the help is needed.

I was planning to get the infrastructure ready for 2.6.21 but
unfortunately travel has intervened.  However, there should be
plenty of time for it to make 2.6.22.  I'll start pushing the
bits into the cryptodev-2.6 tree when I get home next week.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
