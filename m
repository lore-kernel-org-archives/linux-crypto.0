From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Crypto: atmel-ecc: Make a couple of local functions
 static
Date: Thu, 3 Aug 2017 14:22:40 +0800
Message-ID: <20170803062239.GE12039@gondor.apana.org.au>
References: <20170719092415.9553-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tudor Ambarus <tudor.ambarus@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58394 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751032AbdHCGWz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 02:22:55 -0400
Content-Disposition: inline
In-Reply-To: <20170719092415.9553-1-colin.king@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 19, 2017 at 10:24:15AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Functions atmel_ecc_i2c_client_alloc and atmel_ecc_i2c_client_free are
> local to the source and no not need to be in the global scope. Make
> them static.
> 
> Cleans up sparse warnings:
> symbol 'atmel_ecc_i2c_client_alloc' was not declared. Should it be static?
> symbol 'atmel_ecc_i2c_client_free' was not declared. Should it be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
