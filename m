From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: atmel-ecc: fix signed integer to u8 assignment
Date: Thu, 3 Aug 2017 14:23:29 +0800
Message-ID: <20170803062329.GI12039@gondor.apana.org.au>
References: <20170720094140.3y36xergecw6eysj@mwanda>
 <20170720133549.27078-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dan.carpenter@oracle.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58430 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbdHCGXn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 02:23:43 -0400
Content-Disposition: inline
In-Reply-To: <20170720133549.27078-1-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 20, 2017 at 04:35:49PM +0300, Tudor Ambarus wrote:
> static checker warning:
>         drivers/crypto/atmel-ecc.c:281 atmel_ecdh_done()
>         warn: assigning (-22) to unsigned variable 'status'
> 
> Similar warning can be raised in atmel_ecc_work_handler()
> when atmel_ecc_send_receive() returns an error. Fix this too.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
