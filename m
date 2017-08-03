From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ecdh: fix concurrency on shared secret and pubkey
Date: Thu, 3 Aug 2017 14:23:20 +0800
Message-ID: <20170803062320.GH12039@gondor.apana.org.au>
References: <20170719070421.GA9426@gondor.apana.org.au>
 <20170720073739.8680-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        nicolas.ferre@microchip.com
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58414 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbdHCGX1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 02:23:27 -0400
Content-Disposition: inline
In-Reply-To: <20170720073739.8680-1-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 20, 2017 at 10:37:39AM +0300, Tudor Ambarus wrote:
> ecdh_ctx contained static allocated data for the shared secret
> and public key.
> 
> The shared secret and the public key were doomed to concurrency
> issues because they could be shared by multiple crypto requests.
> 
> The concurrency is fixed by replacing per-tfm shared secret and
> public key with per-request dynamically allocated shared secret
> and public key.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
