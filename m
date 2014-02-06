From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH] crypto: caam - fix ERA retrieval function
Date: Thu, 6 Feb 2014 11:41:28 +0200
Message-ID: <52F358C8.2020105@freescale.com>
References: <1391675239-11289-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <vakul@freescale.com>,
	<ruchika.gupta@freescale.com>
To: Alex Porosanu <alexandru.porosanu@freescale.com>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:36807
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755605AbaBFJlu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Feb 2014 04:41:50 -0500
In-Reply-To: <1391675239-11289-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2/6/2014 10:27 AM, Alex Porosanu wrote:
> SEC ERA has to be retrieved by reading the "fsl,sec-era" property
> from the device tree. This property is updated/filled in by
> u-boot.
>
> Change-Id: Ie1620354a0cf2cac5cd2c72bd5f2449f55858378

Change-Id should be dropped.

> Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
> ---
>   drivers/crypto/caam/ctrl.c | 36 ++++++++++--------------------------
>   drivers/crypto/caam/ctrl.h |  2 +-
>   2 files changed, 11 insertions(+), 27 deletions(-)

Reviewed-by: Horia Geanta <horia.geanta@freescale.com>

"fsl, sec-era" has been in u-boot and in dt bindings for over a year.

Regards,
Horia
