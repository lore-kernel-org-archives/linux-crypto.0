From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: algif_aead - skip SGL entries with NULL page
Date: Fri, 24 Nov 2017 18:37:28 +1100
Message-ID: <20171124073728.GA15597@gondor.apana.org.au>
References: <3016707.l0K91qkPze@positron.chronox.de>
 <94396256.4fNdfnqFXK@positron.chronox.de>
 <12084599.cPnBg2z1Zp@positron.chronox.de>
 <9325029.81qbAra0rM@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:39136 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753570AbdKXP7E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Nov 2017 10:59:04 -0500
Content-Disposition: inline
In-Reply-To: <9325029.81qbAra0rM@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 10, 2017 at 11:04:52AM +0100, Stephan Müller wrote:
> Hi Herbert,
> 
> I missed the termination of the outer loop of list_for_each_entry_safe.
> 
> The patch was tested on x86 64 and 32 bit environments.
> 
> ---8<---
> 
> The TX SGL may contain SGL entries that are assigned a NULL page. This
> may happen if a multi-stage AIO operation is performed where the data
> for each stage is pointed to by one SGL entry. Upon completion of that
> stage, af_alg_pull_tsgl will assign NULL to the SGL entry.
> 
> The NULL cipher used to copy the AAD from TX SGL to the destination
> buffer, however, cannot handle the case where the SGL starts with an SGL
> entry having a NULL page. Thus, the code needs to advance the start
> pointer into the SGL to the first non-NULL entry.
> 
> This fixes a crash visible on Intel x86 32 bit using the libkcapi test
> suite.
> 
> Fixes: 72548b093ee38 ("crypto: algif_aead - copy AAD from src to dst")
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
