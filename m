From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH] Crypto: atmel-ecc: Make a couple of local functions
 static
Date: Thu, 20 Jul 2017 10:05:46 +0300
Message-ID: <0368986a-0274-25b4-931a-6c4ddfc4d4e3@microchip.com>
References: <20170719092415.9553-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Colin King <colin.king@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:58360 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933155AbdGTHGF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jul 2017 03:06:05 -0400
In-Reply-To: <20170719092415.9553-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 07/19/2017 12:24 PM, Colin King wrote:
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

Acked-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Thanks,
ta
