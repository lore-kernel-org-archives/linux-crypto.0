From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v4] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Date: Mon, 2 Nov 2009 15:32:58 +0100
Message-ID: <20091102143258.GA23776@elte.hu>
References: <1253064946.15717.372.camel@yhuang-dev.sh.intel.com> <20091019025332.GA26624@gondor.apana.org.au> <20091031173015.69e8e9f8.akpm@linux-foundation.org> <20091101175043.GA25257@gondor.apana.org.au> <20091102075039.GA15942@elte.hu> <20091102142824.GA31981@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Huang Ying <ying.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Daniel Walker <dwalker@fifo99.com>,
	"H. Peter Anvin" <hpa@zytor.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:49151 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283AbZKBOdK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Nov 2009 09:33:10 -0500
Content-Disposition: inline
In-Reply-To: <20091102142824.GA31981@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Mon, Nov 02, 2009 at 08:50:39AM +0100, Ingo Molnar wrote:
> > 
> > A cleanup request: mind creating two macros for this PSHUFB MMX/SSE 
> > instruction in arch/x86/include/asm/i387.h, instead of open-coding the 
> > .byte sequences in ~6 places?
> 
> I had a go at doing that, but it seems that i387.h isn't really meant 
> to be included in an asm file at this point :)

Please use the standard construct and put an #ifndef __ASSEMBLY__ around 
it.

> > ( After the .33 merge window we'll collect such instruction format 
> >   knowledge in arch/x86/include/asm/inst.h. That file is not upstream 
> >   yet so i387.h will do for now for FPU/SSE instructions. )
> 
> I'm happy to revisit this once inst.h exists.

No reason to not do most of the change first though, the way i suggested 
it.

	Ingo
