From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] x86, crypto, Generate .byte code for some new
	instructions via gas macro
Date: Thu, 5 Nov 2009 09:23:36 -0500
Message-ID: <20091105142336.GB1910@gondor.apana.org.au>
References: <1257403455.22519.249.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38553 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756993AbZKEOXs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Nov 2009 09:23:48 -0500
Content-Disposition: inline
In-Reply-To: <1257403455.22519.249.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 05, 2009 at 02:44:15PM +0800, Huang Ying wrote:
> It will take some time for binutils (gas) to support some newly added
> instructions, such as SSE4.1 instructions or the AES-NI instructions
> found in upcoming Intel CPU.
> 
> To make the source code can be compiled by old binutils, .byte code is
> used instead of the assembly instruction. But the readability and
> flexibility of raw .byte code is not good.
> 
> This patch solves the issue of raw .byte code via generating it via
> assembly instruction like gas macro. The syntax is as close as
> possible to real assembly instruction.
> 
> Some helper macros such as MODRM is not a full feature
> implementation. It can be extended when necessary.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Once Ingo acks this I'll throw it into cryptodev.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
