From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API.
Date: Mon, 4 Aug 2008 18:48:03 +0800
Message-ID: <20080804104803.GA9834@gondor.apana.org.au>
References: <1217842507.20845.18.camel@localhost.localdomain> <1217844725.3454.580.camel@pmac.infradead.org> <20080804102557.GA21265@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Woodhouse <dwmw2@infradead.org>,
	Austin Zhang <austin_zhang@linux.intel.com>,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39733 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753098AbYHDKs2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 06:48:28 -0400
Content-Disposition: inline
In-Reply-To: <20080804102557.GA21265@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 04, 2008 at 12:25:57PM +0200, Sebastian Siewior wrote:
>
> I'm not sure if I remeber correctly but I thing Herbert was planning to
> convert all users over to the crypto API to avoid compile time
> dependency.

Yes that's the plan.  I've been busy with the crypto testing
stuff but I'll get onto this soon.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
