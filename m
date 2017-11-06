From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v3 PATCH 2/3] crypto: atmel-aes/tdes - remove empty functions
Date: Mon, 6 Nov 2017 15:09:01 +0800
Message-ID: <20171106070901.GE14274@gondor.apana.org.au>
References: <20171026133549.20654-1-tudor.ambarus@microchip.com>
 <20171102151225.12949-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51746 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbdKFHJa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 02:09:30 -0500
Content-Disposition: inline
In-Reply-To: <20171102151225.12949-1-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 02, 2017 at 05:12:25PM +0200, Tudor Ambarus wrote:
> Pointer members of an object with static storage duration, if not
> explicitly initialized, will be initialized to a NULL pointer.
> The crypto API checks if these pointers are not NULL before using them,
> therefore we can safely remove these empty functions.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
