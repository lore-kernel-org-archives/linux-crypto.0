From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] crypto: atmel-aes/tdes/sha - remove useless irq init
Date: Fri, 3 Nov 2017 22:27:05 +0800
Message-ID: <20171103142705.GN9011@gondor.apana.org.au>
References: <20171023153441.28825-1-tudor.ambarus@microchip.com>
 <20171023153441.28825-3-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, nicolas.ferre@microchip.com
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38290 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933449AbdKCO13 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 10:27:29 -0400
Content-Disposition: inline
In-Reply-To: <20171023153441.28825-3-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 23, 2017 at 06:34:41PM +0300, Tudor Ambarus wrote:
> irq would be set to -1 and then unused, if we failed to get IORESOURCE_MEM.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
