From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel AES-NI
	instructions
Date: Mon, 15 Dec 2008 22:28:46 +1100
Message-ID: <20081215112846.GA31804@gondor.apana.org.au>
References: <1229054926.5936.160.camel@yhuang-dev.sh.intel.com> <20081212195722.GA24489@Chamillionaire.breakpoint.cc> <1229307542.5936.204.camel@yhuang-dev.sh.intel.com> <20081215090745.GA4991@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Huang Ying <ying.huang@intel.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"tglx@linutronix.de" <tglx@linutronix.de>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37594 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753116AbYLOL27 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2008 06:28:59 -0500
Content-Disposition: inline
In-Reply-To: <20081215090745.GA4991@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 15, 2008 at 10:07:45AM +0100, Sebastian Andrzej Siewior wrote:
>
> You have to it if you want to bypass the crypto layer and call asm
> functions directly and I'm not sure whether bypassing the crypto layer
> is a good thing. Both asm routines (the 32bit and 64bit) assume that
> keylen ist at +0 followed by enc key, dec key. Ach and they don't do the
> ALIGN thing.
> 
> Herbert what do you thing?

I think it would be OK if it called the assembly routine directly
and we moved this under asm/x86-64.  We should do the latter anyway
regardless of what we decide.

However, I'm skeptical about whether we should use of a fallback at
all rather than making this work in softirq context.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
