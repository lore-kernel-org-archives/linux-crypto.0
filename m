From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 00/13] crypto: caam - fixes, clean-up
Date: Tue, 18 Jul 2017 18:39:33 +0800
Message-ID: <20170718103933.GT6479@gondor.apana.org.au>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
 <20170710054039.21555-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33350 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751580AbdGRKkA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 06:40:00 -0400
Content-Disposition: inline
In-Reply-To: <20170710054039.21555-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 10, 2017 at 08:40:26AM +0300, Horia Geantă wrote:
> [
> Change log:
> v1 -> v2
> -patch 05/13 - add missing check in ablkcipher_giv_edesc_alloc(),
> to make sure number of reserved S/G entries is not overflown
> -patch 12/13 - fix author - replace my Freescale address with
> corresponding NXP one
> ]
> 
> Hi,
> 
> Current patch set consists of:
> 
> Patches 1-4 fix some issues in caam/qi driver;
> they should be sent to -stable.

While they should go to stable eventually, I think as the bug has
been around for so long we might as well wait for another cycle.

> Patches 5-7 also fix some problems in caam/qi driver, however these are
> ARM-specific. Considering that caam/qi does not have support for ARM in
> kernel v4.12 (lacking one dependency - Queue Manager), there's no need
> to be applied on v4.12.y.
> 
> Patches 8-13 contain code clean-up.

All patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
