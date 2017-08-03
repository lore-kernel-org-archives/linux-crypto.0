From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp: remove duplicate module version and author
 entry
Date: Thu, 3 Aug 2017 14:23:12 +0800
Message-ID: <20170803062312.GG12039@gondor.apana.org.au>
References: <20170720032908.48902-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary R Hook <gary.hook@amd.com>,
        "David S . Miller" <davem@davemloft.net>
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58406 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751032AbdHCGXT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 02:23:19 -0400
Content-Disposition: inline
In-Reply-To: <20170720032908.48902-1-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 19, 2017 at 10:29:08PM -0500, Brijesh Singh wrote:
> commit 720419f01832 ("crypto: ccp - Introduce the AMD Secure Processor device")
> moved the module registeration from ccp-dev.c to sp-dev.c but patch missed
> removing the module version and author entry from ccp-dev.c.
> 
> It causes the below warning during boot when CONFIG_CRYPTO_DEV_SP_CCP=y
> and CONFIG_CRYPTO_DEV_CCP_CRYPTO=y is set.
> 
> [ 0.187825] sysfs: cannot create duplicate filename '/module/ccp/version'
> [ 0.187825] sysfs: cannot create duplicate filename '/module/ccp/version'
> 
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Gary R Hook <gary.hook@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
