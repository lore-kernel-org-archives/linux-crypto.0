From: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH -v4] crypto: Add PCLMULQDQ accelerated GHASH
 implementation
Date: Tue, 03 Nov 2009 13:47:16 +0800
Message-ID: <1257227236.30470.1192.camel@yhuang-dev.sh.intel.com>
References: <1253064946.15717.372.camel@yhuang-dev.sh.intel.com>
	 <20091019025332.GA26624@gondor.apana.org.au>
	 <20091031173015.69e8e9f8.akpm@linux-foundation.org>
	 <20091101175043.GA25257@gondor.apana.org.au>
	 <20091102075039.GA15942@elte.hu>
	 <20091102142824.GA31981@gondor.apana.org.au>
	 <20091102143258.GA23776@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Daniel Walker <dwalker@fifo99.com>,
	"H. Peter Anvin" <hpa@zytor.com>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12398 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZKCFrO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Nov 2009 00:47:14 -0500
In-Reply-To: <20091102143258.GA23776@elte.hu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2009-11-02 at 22:32 +0800, Ingo Molnar wrote: 
> * Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > On Mon, Nov 02, 2009 at 08:50:39AM +0100, Ingo Molnar wrote:
> > > 
> > > A cleanup request: mind creating two macros for this PSHUFB MMX/SSE 
> > > instruction in arch/x86/include/asm/i387.h, instead of open-coding the 
> > > .byte sequences in ~6 places?
> > 
> > I had a go at doing that, but it seems that i387.h isn't really meant 
> > to be included in an asm file at this point :)
> 
> Please use the standard construct and put an #ifndef __ASSEMBLY__ around 
> it.
> 
> > > ( After the .33 merge window we'll collect such instruction format 
> > >   knowledge in arch/x86/include/asm/inst.h. That file is not upstream 
> > >   yet so i387.h will do for now for FPU/SSE instructions. )
> > 
> > I'm happy to revisit this once inst.h exists.
> 
> No reason to not do most of the change first though, the way i suggested 
> it.

How about something as below? But it seems not appropriate to put these
bits into i387.h, that is, to combine C and gas syntax.

Best Regards,
Huang Ying

.macro xmm_num opd xmm
.ifc \xmm,%xmm0
\opd = 0
.endif
.ifc \xmm,%xmm1
\opd = 1
.endif
.ifc \xmm,%xmm2
\opd = 2
.endif
.ifc \xmm,%xmm3
\opd = 3
.endif
.ifc \xmm,%xmm4
\opd = 4
.endif
.ifc \xmm,%xmm5
\opd = 5
.endif
.ifc \xmm,%xmm6
\opd = 6
.endif
.ifc \xmm,%xmm7
\opd = 7
.endif
.ifc \xmm,%xmm8
\opd = 8
.endif
.ifc \xmm,%xmm9
\opd = 9
.endif
.ifc \xmm,%xmm10
\opd = 10
.endif
.ifc \xmm,%xmm11
\opd = 11
.endif
.ifc \xmm,%xmm12
\opd = 12
.endif
.ifc \xmm,%xmm13
\opd = 13
.endif
.ifc \xmm,%xmm14
\opd = 14
.endif
.ifc \xmm,%xmm15
\opd = 15
.endif
.endm

.macro PSHUFB_XMM xmm1 xmm2
xmm_num pshufb_opd1 \xmm1
xmm_num pshufb_opd2 \xmm2
.if (pshufb_opd1 < 8) && (pshufb_opd2 < 8)
.byte 0x66, 0x0f, 0x38, 0x00, 0xc0 | pshufb_opd1 | (pshufb_opd2<<3)
.elseif (pshufb_opd1 >= 8) && (pshufb_opd2 < 8)
.byte 0x66, 0x41, 0x0f, 0x38, 0x00, 0xc0 | (pshufb_opd1-8) | (pshufb_opd2<<3)
.elseif (pshufb_opd1 < 8) && (pshufb_opd2 >= 8)
.byte 0x66, 0x44, 0x0f, 0x38, 0x00, 0xc0 | pshufb_opd1 | ((pshufb_opd2-8)<<3)
.else
.byte 0x66, 0x45, 0x0f, 0x38, 0x00, 0xc0 | (pshufb_opd1-8) | ((pshufb_opd2-8)<<3)
.endif
.endm


