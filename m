From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -v4] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Date: Mon, 2 Nov 2009 09:28:24 -0500
Message-ID: <20091102142824.GA31981@gondor.apana.org.au>
References: <1253064946.15717.372.camel@yhuang-dev.sh.intel.com> <20091019025332.GA26624@gondor.apana.org.au> <20091031173015.69e8e9f8.akpm@linux-foundation.org> <20091101175043.GA25257@gondor.apana.org.au> <20091102075039.GA15942@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Huang Ying <ying.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Daniel Walker <dwalker@fifo99.com>,
	"H. Peter Anvin" <hpa@zytor.com>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45378 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755232AbZKBO2h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Nov 2009 09:28:37 -0500
Content-Disposition: inline
In-Reply-To: <20091102075039.GA15942@elte.hu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 02, 2009 at 08:50:39AM +0100, Ingo Molnar wrote:
> 
> A cleanup request: mind creating two macros for this PSHUFB MMX/SSE 
> instruction in arch/x86/include/asm/i387.h, instead of open-coding the 
> .byte sequences in ~6 places?

I had a go at doing that, but it seems that i387.h isn't really
meant to be included in an asm file at this point :)

> ( After the .33 merge window we'll collect such instruction format 
>   knowledge in arch/x86/include/asm/inst.h. That file is not upstream 
>   yet so i387.h will do for now for FPU/SSE instructions. )

I'm happy to revisit this once inst.h exists.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
