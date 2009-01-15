From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH crypto -v3 2/2] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Date: Thu, 15 Jan 2009 14:18:15 +1100
Message-ID: <20090115031815.GA27916@gondor.apana.org.au>
References: <1231919052.5937.160.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36974 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754118AbZAODST (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2009 22:18:19 -0500
Content-Disposition: inline
In-Reply-To: <1231919052.5937.160.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 14, 2009 at 03:44:12PM +0800, Huang Ying wrote:
> This is not intented to be merged, just for reviewing. If no other
> issues, I will pre-assemble AES-NI instructions in aesni-intel_asm.S,
> because they are not supported by some binutils until now.

Looks good, thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
