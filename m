From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hw_random: core: Reset user selected rng by writing ""
 to rng_current
Date: Fri, 3 Nov 2017 22:28:11 +0800
Message-ID: <20171103142811.GS9011@gondor.apana.org.au>
References: <20171027170404.21262-1-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, freude@linux.vnet.ibm.com,
        linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38364 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbdKCO2k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 10:28:40 -0400
Content-Disposition: inline
In-Reply-To: <20171027170404.21262-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 27, 2017 at 10:34:04PM +0530, PrasannaKumar Muralidharan wrote:
> User is able to select a chosen rng by writing its name to rng_current
> but there is no way to reset it without unbinding the rng. Let user
> write "" to rng_current and delesect the chosen rng.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
