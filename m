From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Tue, 2 Jun 2009 13:50:41 +1000
Message-ID: <20090602035041.GB22831@gondor.apana.org.au>
References: <20090513130618.GD20366@secunet.com> <20090513130818.GF20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50992 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755440AbZFBDuo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2009 23:50:44 -0400
Content-Disposition: inline
In-Reply-To: <20090513130818.GF20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 13, 2009 at 03:08:18PM +0200, Steffen Klassert wrote:
> This patch adds an interface to wrap aead algorithms with an
> arbitrary crypto template. This is useful to make a certain
> version of an aead algorithm the system default of that algorithm.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Hmm, it seems that this patch is completely intertwined into the
rest of the patches so we can't just kill it.  Can you elaborate
on the rationale behind this wrap work? I'm curious to find out
what we gain by this over the much simpler patch you had in your
previous set.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
