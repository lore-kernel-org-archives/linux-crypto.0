From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH v8 4/4] crypto: algif_akcipher - enable compilation
Date: Fri, 11 Aug 2017 15:56:18 +0300
Message-ID: <1d8f2d85-2f6f-6beb-eec1-d2d980e2dbeb@microchip.com>
References: <26359147.tCiuJ5s8mz@positron.chronox.de>
 <2936451.27GRxPPosH@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:51373 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752763AbdHKM5F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2017 08:57:05 -0400
In-Reply-To: <2936451.27GRxPPosH@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Stephan,

On 08/10/2017 09:40 AM, Stephan Müller wrote:
> Add the Makefile and Kconfig updates to allow algif_akcipher to be
> compiled.
> 
> Signed-off-by: Stephan Mueller<smueller@chronox.de>
> ---
>   crypto/Kconfig  | 9 +++++++++
>   crypto/Makefile | 1 +
>   2 files changed, 10 insertions(+)

Any reason why you keep this patch separately?
I think you can squash this patch with patch 3/4.

Cheers,
ta
