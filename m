From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ansi_cprng: fix inverted DT increment routine
Date: Mon, 24 Nov 2008 21:20:43 +0800
Message-ID: <20081124132043.GA18313@gondor.apana.org.au>
References: <200811131136.15875.jarod@redhat.com> <20081113184431.GB18604@hmsendeavour.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	davem@davemloft.net, linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49903 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751175AbYKXNUx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2008 08:20:53 -0500
Content-Disposition: inline
In-Reply-To: <20081113184431.GB18604@hmsendeavour.rdu.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 13, 2008 at 01:44:31PM -0500, Neil Horman wrote:
> On Thu, Nov 13, 2008 at 11:36:11AM -0500, Jarod Wilson wrote:
> > The ANSI X9.31 PRNG docs aren't particularly clear on how to increment DT,
> > but empirical testing shows we're incrementing from the wrong end. A 10,000
> > iteration Monte Carlo RNG test currently winds up not getting the expected
> > result.
> > 
> > From http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf :
> > 
> > # CAVS 4.3
> > # ANSI931 MCT
> > [X9.31]
> > [AES 128-Key]
> > 
> > COUNT = 0
> > Key = 9f5b51200bf334b5d82be8c37255c848
> > DT = 6376bbe52902ba3b67c925fa701f11ac
> > V = 572c8e76872647977e74fbddc49501d1
> > R = 48e9bd0d06ee18fbe45790d5c3fc9b73
> > 
> > Currently, we get 0dd08496c4f7178bfa70a2161a79459a after 10000 loops.
> > 
> > Inverting the DT increment routine results in us obtaining the expected result
> > of 48e9bd0d06ee18fbe45790d5c3fc9b73. Verified on both x86_64 and ppc64.
> > 
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
