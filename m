From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: caam - fix gfp allocation flags (part II)
Date: Thu, 22 Jun 2017 17:00:12 +0800
Message-ID: <20170622090012.GD25859@gondor.apana.org.au>
References: <5215CFD1-A162-4668-A34C-1C29509DC27E@sigma-star.at>
 <20170619084446.27967-1-horia.geanta@nxp.com>
 <20170619084446.27967-2-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: David Gstir <david@sigma-star.at>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>, richard@sigma-star.at,
        Radu Solea <radu.solea@nxp.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:34682 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752745AbdFVJAs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 05:00:48 -0400
Content-Disposition: inline
In-Reply-To: <20170619084446.27967-2-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 19, 2017 at 11:44:46AM +0300, Horia Geantă wrote:
> This is the 2nd part of fixing the usage of GFP_KERNEL for memory
> allocations, taking care off all the places that haven't caused a real
> problem / failure.
> Again, the issue being fixed is that GFP_KERNEL should be used only when
> MAY_SLEEP flag is set, i.e. MAY_BACKLOG flag usage is orthogonal.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
