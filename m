From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX] Fix AES-NI CTR optimization compiling failure with
	gas 2.16.1
Date: Sat, 13 Mar 2010 16:29:06 +0800
Message-ID: <20100313082906.GA24675@gondor.apana.org.au>
References: <1268377307.1640.491.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47066 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758910Ab0CMI3M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 13 Mar 2010 03:29:12 -0500
Content-Disposition: inline
In-Reply-To: <1268377307.1640.491.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 12, 2010 at 03:01:47PM +0800, Huang Ying wrote:
> Andrew Morton reported that AES-NI CTR optimization failed to compile
> with gas 2.16.1, the error message is as follow:
> 
> arch/x86/crypto/aesni-intel_asm.S: Assembler messages:
> arch/x86/crypto/aesni-intel_asm.S:752: Error: suffix or operands invalid for `movq'
> arch/x86/crypto/aesni-intel_asm.S:753: Error: suffix or operands invalid for `movq'
> 
> To fix this, a gas macro is defined to assemble movq with 64bit
> general purpose registers and XMM registers. The macro will generate
> the raw .byte sequence for needed instructions.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Patch applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
