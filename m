From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ecdh - remove empty exit()
Date: Mon, 6 Nov 2017 15:08:53 +0800
Message-ID: <20171106070853.GD14274@gondor.apana.org.au>
References: <20171102144647.11847-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51740 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751930AbdKFHJT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 02:09:19 -0500
Content-Disposition: inline
In-Reply-To: <20171102144647.11847-1-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 02, 2017 at 04:46:47PM +0200, Tudor Ambarus wrote:
> Pointer members of an object with static storage duration, if not
> explicitly initialized, will be initialized to a NULL pointer. The crypto
> API checks if this pointer is not NULL before using it, we are safe to
> remove the function.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
