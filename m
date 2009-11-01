From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v4] crypto: Add PCLMULQDQ accelerated GHASH
 implementation
Date: Sat, 31 Oct 2009 17:30:15 -0700
Message-ID: <20091031173015.69e8e9f8.akpm@linux-foundation.org>
References: <1253064946.15717.372.camel@yhuang-dev.sh.intel.com>
	<20091019025332.GA26624@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Huang Ying <ying.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Daniel Walker <dwalker@fifo99.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933364AbZKAAay (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 31 Oct 2009 20:30:54 -0400
In-Reply-To: <20091019025332.GA26624@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 19 Oct 2009 11:53:33 +0900 Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Sep 16, 2009 at 09:35:46AM +0800, Huang Ying wrote:
> > PCLMULQDQ is used to accelerate the most time-consuming part of GHASH,
> > carry-less multiplication. More information about PCLMULQDQ can be
> > found at:
> > 
> > http://software.intel.com/en-us/articles/carry-less-multiplication-and-its-usage-for-computing-the-gcm-mode/
> > 
> > Because PCLMULQDQ changes XMM state, its usage must be enclosed with
> > kernel_fpu_begin/end, which can be used only in process context, the
> > acceleration is implemented as crypto_ahash. That is, request in soft
> > IRQ context will be defered to the cryptd kernel thread.
> > 
> > v4:
> >  - Fix some style issues.
> > 
> > v3:
> >  - Revise GHASH implementation, performance increase about 2x.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> Patch applied to cryptodev.  Thanks!

x86_64 allmodconfig, GNU assembler 2.16.1:

arch/x86/crypto/ghash-clmulni-intel_asm.S: Assembler messages:
arch/x86/crypto/ghash-clmulni-intel_asm.S:103: Error: no such instruction: `pshufb %xmm5,%xmm0'
arch/x86/crypto/ghash-clmulni-intel_asm.S:105: Error: no such instruction: `pshufb %xmm5,%xmm0'
arch/x86/crypto/ghash-clmulni-intel_asm.S:119: Error: no such instruction: `pshufb %xmm5,%xmm0'
arch/x86/crypto/ghash-clmulni-intel_asm.S:123: Error: no such instruction: `pshufb %xmm5,%xmm6'
arch/x86/crypto/ghash-clmulni-intel_asm.S:130: Error: no such instruction: `pshufb %xmm5,%xmm0'
arch/x86/crypto/ghash-clmulni-intel_asm.S:143: Error: no such instruction: `pshufb %xmm5,%xmm0'

