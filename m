From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] hwrng: Clean up RNG list when last hwrng is
 unregistered
Date: Fri, 22 Dec 2017 20:12:19 +1100
Message-ID: <20171222091219.GK32542@gondor.apana.org.au>
References: <151336772989.60446.16322941485803241258.stgit@sosxen2.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46500 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932637AbdLVJNt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 04:13:49 -0500
Content-Disposition: inline
In-Reply-To: <151336772989.60446.16322941485803241258.stgit@sosxen2.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 15, 2017 at 01:55:59PM -0600, Gary R Hook wrote:
> Commit 142a27f0a731 added support for a "best" RNG, and in doing so
> introduced a hang from rmmod/modprobe -r when the last RNG on the list
> was unloaded.
> 
> When the hwrng list is depleted, return the global variables to their
> original state and decrement all references to the object.
> 
> Fixes: 142a27f0a731 ("hwrng: core - Reset user selected rng by writing "" to rng_current")
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
