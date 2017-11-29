From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: tcrypt - set assoc in sg_init_aead()
Date: Wed, 29 Nov 2017 17:36:27 +1100
Message-ID: <20171129063627.GC21594@gondor.apana.org.au>
References: <20171114145915.13299-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, robert.baronescu@nxp.com,
        horia.geanta@nxp.com
To: Tudor-Dan Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40660 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752981AbdK2Ggf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 01:36:35 -0500
Content-Disposition: inline
In-Reply-To: <20171114145915.13299-1-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 14, 2017 at 04:59:15PM +0200, Tudor-Dan Ambarus wrote:
> Results better code readability.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
