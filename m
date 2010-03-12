From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Add AES-NI accelerated CTR mode
Date: Fri, 12 Mar 2010 08:19:51 +0800
Message-ID: <20100312001950.GA9928@gondor.apana.org.au>
References: <1267424076.1640.82.camel@yhuang-dev.sh.intel.com> <20100311121510.80a16ec4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50256 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753365Ab0CLAT4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Mar 2010 19:19:56 -0500
Content-Disposition: inline
In-Reply-To: <20100311121510.80a16ec4.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 11, 2010 at 12:15:10PM -0800, Andrew Morton wrote:
>
> > +	movq TCTR_LOW, INC
> > +	movq CTR, TCTR_LOW
> 
> ^^ these two lines don't assemble with gas 2.16.1:
> 
> arch/x86/crypto/aesni-intel_asm.S: Assembler messages:
> arch/x86/crypto/aesni-intel_asm.S:752: Error: suffix or operands invalid for `movq'
> arch/x86/crypto/aesni-intel_asm.S:753: Error: suffix or operands invalid for `movq'

I guess we will have to hard code this.  Thanks for reporting
this Andrew.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
