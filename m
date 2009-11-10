From: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 2/2] x86, crypto, Use gas macro for AES-NI instructions
Date: Tue, 10 Nov 2009 10:59:11 +0800
Message-ID: <1257821951.22519.2415.camel@yhuang-dev.sh.intel.com>
References: <1257403457.22519.250.camel@yhuang-dev.sh.intel.com>
	 <20091109185609.GB9588@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:17434 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZKJC7H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Nov 2009 21:59:07 -0500
In-Reply-To: <20091109185609.GB9588@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2009-11-10 at 02:56 +0800, Herbert Xu wrote: 
> On Thu, Nov 05, 2009 at 02:44:17PM +0800, Huang Ying wrote:
> > Old binutils do not support AES-NI instructions, to make kernel can be
> > compiled by them, .byte code is used instead of AES-NI assembly
> > instructions. But the readability and flexibility of raw .byte code is
> > not good.
> > 
> > So corresponding assembly instruction like gas macro is used instead.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> Sorry, but this doesn't apply:
> 
> $ git apply ~/p
> fatal: patch fragment without header at line 428: @@ -518,51 +417,37 @@ _aesni_dec1:
> $

Sorry, I will re-sent this.

Best Regards,
Huang Ying


