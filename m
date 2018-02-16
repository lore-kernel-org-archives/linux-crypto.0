From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH] crypto: atmel: Delete error messages for a failed memory
 allocation in six functions
Date: Fri, 16 Feb 2018 10:41:51 +0200
Message-ID: <285d8666-5992-cccb-6c91-e83e85947a7d@microchip.com>
References: <77cf1006-966d-78a9-0fdc-b53ccdd80df2@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:43579 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754775AbeBPIl5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Feb 2018 03:41:57 -0500
In-Reply-To: <77cf1006-966d-78a9-0fdc-b53ccdd80df2@users.sourceforge.net>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 02/15/2018 02:24 PM, SF Markus Elfring wrote:
> From: Markus Elfring<elfring@users.sourceforge.net>
> Date: Thu, 15 Feb 2018 11:38:30 +0100
> 
> Omit extra messages for a memory allocation failure in these functions.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring<elfring@users.sourceforge.net>

Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
