From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam/qi - abort algorithm setup on DPAA2 parts
Date: Fri, 3 Nov 2017 22:27:26 +0800
Message-ID: <20171103142726.GP9011@gondor.apana.org.au>
References: <20171024062731.28070-1-horia.geanta@nxp.com>
 <20171024062731.28070-2-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38318 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752249AbdKCO1x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 10:27:53 -0400
Content-Disposition: inline
In-Reply-To: <20171024062731.28070-2-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 24, 2017 at 09:27:31AM +0300, Horia Geantă wrote:
> caam/qi frontend (i.e. caamalg_qi) mustn't be used in case it runs on a
> DPAA2 part (this could happen when using a multiplatform kernel).
> 
> Fixes: 297b9cebd2fc ("crypto: caam/jr - add support for DPAA2 parts")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
