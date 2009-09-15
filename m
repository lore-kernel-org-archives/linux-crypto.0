From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: ESP hardware acceleration
Date: Tue, 15 Sep 2009 12:09:47 -0500
Message-ID: <20090915170947.GA30954@gondor.apana.org.au>
References: <4AAF945F.8060501@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dimitrios Siganos <dimitris@siganos.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38108 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753995AbZIORJr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2009 13:09:47 -0400
Content-Disposition: inline
In-Reply-To: <4AAF945F.8060501@siganos.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dimitrios Siganos <dimitris@siganos.org> wrote:
> 
> What I would like to know is:
> 1) does the xfrm/ESP implementation support asynchronous/parallel packet 
> operation?
> 2) If yes, does it support it in both directions (tx/rx)?

Yes on both counts.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
