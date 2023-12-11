Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="2iwH3yc5"
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E2BFE
	for <linux-crypto@vger.kernel.org>; Mon, 11 Dec 2023 00:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1702285121; x=1733821121;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hnUoUwUq1XC7m3eX4krct50rHCSyImYnGb3EmPQUoEY=;
  b=2iwH3yc5MhKaRYtVq26mI0+7sMOdw24ca0NmUgMPg/YUlP0c6J59GYUd
   W/7cb3KCmomPedTUloKZGIDuThxoRY50Vs4kG4wZxPTCxho2KkB0vgsW2
   jSSTAeBYjQPSmIvsO1IVGPssvmDrhCn+r3X+tTuVhnHXsV2ddve1L41tc
   EK7zbaG4096kYLkbYzbkwNRVVwMqf90HNpq3kPAT/dT4QB9vK+v10TicM
   c0vOBHyOQLxoTMG/6zAw1yrSc4HZJhTRhLFjcmDicuwv8m+bbVBPTVaIJ
   MKr7gU4IShR3HrMvvDbHpvDo3yRAmp7SWh0aIUtee9I1SnJaR2ESmeQ1k
   g==;
X-CSE-ConnectionGUID: QwuSQWWcQjGLWaHUNBS8GQ==
X-CSE-MsgGUID: Pnu145umRx2ZiW2FToAXZw==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,267,1695711600"; 
   d="scan'208";a="13979817"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2023 01:58:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 11 Dec 2023 01:58:22 -0700
Received: from [10.159.245.205] (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Mon, 11 Dec 2023 01:58:20 -0700
Message-ID: <e2360a12-7c1d-4eb6-80a3-8ca48f63f281@microchip.com>
Date: Mon, 11 Dec 2023 09:57:39 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/12] hwrng: atmel - Convert to platform remove callback
 returning void
Content-Language: en-US, fr-FR
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Olivia
 Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>
CC: Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea
	<claudiu.beznea@tuxon.dev>, Rob Herring <robh@kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kernel@pengutronix.de>
References: <cover.1702245873.git.u.kleine-koenig@pengutronix.de>
 <89f6eebfa85b31c635b774e613f19b84b32f3e1f.1702245873.git.u.kleine-koenig@pengutronix.de>
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <89f6eebfa85b31c635b774e613f19b84b32f3e1f.1702245873.git.u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit

On 10/12/2023 at 23:12, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
> 
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

> ---
>   drivers/char/hw_random/atmel-rng.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
> index a37367ebcbac..e9157255f851 100644
> --- a/drivers/char/hw_random/atmel-rng.c
> +++ b/drivers/char/hw_random/atmel-rng.c
> @@ -161,15 +161,13 @@ static int atmel_trng_probe(struct platform_device *pdev)
>          return ret;
>   }
> 
> -static int atmel_trng_remove(struct platform_device *pdev)
> +static void atmel_trng_remove(struct platform_device *pdev)
>   {
>          struct atmel_trng *trng = platform_get_drvdata(pdev);
> 
>          atmel_trng_cleanup(trng);
>          pm_runtime_disable(&pdev->dev);
>          pm_runtime_set_suspended(&pdev->dev);
> -
> -       return 0;
>   }
> 
>   static int __maybe_unused atmel_trng_runtime_suspend(struct device *dev)
> @@ -218,7 +216,7 @@ MODULE_DEVICE_TABLE(of, atmel_trng_dt_ids);
> 
>   static struct platform_driver atmel_trng_driver = {
>          .probe          = atmel_trng_probe,
> -       .remove         = atmel_trng_remove,
> +       .remove_new     = atmel_trng_remove,
>          .driver         = {
>                  .name   = "atmel-trng",
>                  .pm     = pm_ptr(&atmel_trng_pm_ops),
> --
> 2.42.0
> 

