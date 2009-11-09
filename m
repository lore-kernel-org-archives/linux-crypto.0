From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] x86, crypto, Use gas macro for AES-NI instructions
Date: Mon, 9 Nov 2009 13:56:10 -0500
Message-ID: <20091109185609.GB9588@gondor.apana.org.au>
References: <1257403457.22519.250.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34418 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751814AbZKIS4Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Nov 2009 13:56:16 -0500
Content-Disposition: inline
In-Reply-To: <1257403457.22519.250.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 05, 2009 at 02:44:17PM +0800, Huang Ying wrote:
> Old binutils do not support AES-NI instructions, to make kernel can be
> compiled by them, .byte code is used instead of AES-NI assembly
> instructions. But the readability and flexibility of raw .byte code is
> not good.
> 
> So corresponding assembly instruction like gas macro is used instead.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Sorry, but this doesn't apply:

$ git apply ~/p
fatal: patch fragment without header at line 428: @@ -518,51 +417,37 @@ _aesni_dec1:
$

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
