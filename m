From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: dh_helper - return unsigned value for
 crypto_dh_key_len()
Date: Thu, 12 Oct 2017 23:19:10 +0800
Message-ID: <20171012151909.GF31122@gondor.apana.org.au>
References: <20170929092106.24276-1-tudor.ambarus@microchip.com>
 <20170929092106.24276-2-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
        keyrings@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37348 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdJLPTd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2017 11:19:33 -0400
Content-Disposition: inline
In-Reply-To: <20170929092106.24276-2-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 29, 2017 at 12:21:05PM +0300, Tudor Ambarus wrote:
> DH_KPP_SECRET_MIN_SIZE and dh_data_size() are both returning
> unsigned values.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
