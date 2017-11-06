From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH 2/2] crypto: atmel-aes - Reset the controller before each
 use
Date: Mon, 6 Nov 2017 17:45:50 +0200
Message-ID: <ff2356ef-2c11-18e5-6da2-654b1d77280c@microchip.com>
References: <20171031152524.25216-1-romain.izard.pro@gmail.com>
 <20171031152524.25216-3-romain.izard.pro@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Romain Izard <romain.izard.pro@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:5464 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932155AbdKFPp5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 10:45:57 -0500
In-Reply-To: <20171031152524.25216-3-romain.izard.pro@gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Romain,

On 10/31/2017 05:25 PM, Romain Izard wrote:
> When using the rfc4543(gcm(aes))) mode, the registers of the hardware
> engine are not empty after use. If the engine is not reset before its
> next use, the following results will be invalid.
> 
> Always reset the hardware engine.

Thanks for the fix! I could reproduce the issue only when running
rfc4543(gcm(aes))) and then, immediately after, ecb(aes).

Have you encountered this bug with other combination of algorithms?

I'm trying to isolate the bug so that we can have a more fine-grained
fix.

Cheers,
ta
