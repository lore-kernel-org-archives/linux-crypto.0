From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: CTR DRBG - prevent invalid SG mappings
Date: Wed, 30 Nov 2016 21:18:09 +0800
Message-ID: <20161130131808.GA4126@gondor.apana.org.au>
References: <1833318.YYJALW9cvC@positron.chronox.de>
 <1506389.b84a3PTDCG@positron.chronox.de>
 <20161129080556.GA5467@gondor.apana.org.au>
 <1602385.dkYy1y29re@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48143 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752786AbcK3NSR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2016 08:18:17 -0500
Content-Disposition: inline
In-Reply-To: <1602385.dkYy1y29re@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 29, 2016 at 09:45:04AM +0100, Stephan Mueller wrote:
> When using SGs, only heap memory (memory that is valid as per
> virt_addr_valid) is allowed to be referenced. The CTR DRBG used to
> reference the caller-provided memory directly in an SG. In case the
> caller provided stack memory pointers, the SG mapping is not considered
> to be valid. In some cases, this would even cause a paging fault.
> 
> The change adds a new scratch buffer that is used unconditionally to
> catch the cases where the caller-provided buffer is not suitable for
> use in an SG. The crypto operation of the CTR DRBG produces its output
> with that scratch buffer and finally copies the content of the
> scratch buffer to the caller's buffer.
> 
> The scratch buffer is allocated during allocation time of the CTR DRBG
> as its access is protected with the DRBG mutex.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
