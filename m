From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: caam - fix gfp allocation flags (part I)
Date: Thu, 22 Jun 2017 17:00:01 +0800
Message-ID: <20170622090001.GC25859@gondor.apana.org.au>
References: <5215CFD1-A162-4668-A34C-1C29509DC27E@sigma-star.at>
 <20170619084446.27967-1-horia.geanta@nxp.com>
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
Received: from orcrist.hmeau.com ([104.223.48.154]:34672 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752719AbdFVJA2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 05:00:28 -0400
Content-Disposition: inline
In-Reply-To: <20170619084446.27967-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 19, 2017 at 11:44:45AM +0300, Horia Geantă wrote:
> Changes in the SW cts (ciphertext stealing) code in
> commit 0605c41cc53ca ("crypto: cts - Convert to skcipher")
> revealed a problem in the CAAM driver:
> when cts(cbc(aes)) is executed and cts runs in SW,
> cbc(aes) is offloaded in CAAM; cts encrypts the last block
> in atomic context and CAAM incorrectly decides to use GFP_KERNEL
> for memory allocation.
> 
> Fix this by allowing GFP_KERNEL (sleeping) only when MAY_SLEEP flag is
> set, i.e. remove MAY_BACKLOG flag.
> 
> We split the fix in two parts - first is sent to -stable, while the
> second is not (since there is no known failure case).
> 
> Link: http://lkml.kernel.org/g/20170602122446.2427-1-david@sigma-star.at
> Cc: <stable@vger.kernel.org> # 4.8+
> Reported-by: David Gstir <david@sigma-star.at>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
