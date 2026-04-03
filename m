Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9B430EF6B;
	Fri,  3 Apr 2026 16:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775233868; cv=none; b=HhOaB32+kaCIzi4fetE7LTUjXhLHPA8XGaEFPNCo7zJtJ3OUaGBCQAlIvjSknR7C/3Db5hnBnRxtIoPQzNHmsbZyz+yGi4djtjlIZ8sJoodbRxpu4qE6smRZEUfYVN/njVwxYrozYEUF+trySbumW+7sS2nQ96HH68SehgnwXWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775233868; c=relaxed/simple;
	bh=vAu5xDULmUDVRflPCz8uMYqeqlNDlanNU9eapaLwCXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hAYrVh+pTLmc4rUuQu+EMd4RQs54LBdNIMmble6cqmTmrl9QhXyLKEZEIX7vfHHEahXYgqTrmggo1riz8/sXPptQKuvNfsi27kEctYG5om1XBvy0Qwf5n3+GHhwwRDTPlPH6VTPmykM2RdruzjxEVluAAGDIMMU5F0cKMOGcCuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=N0L3FCMx; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="N0L3FCMx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1775233867; x=1806769867;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vAu5xDULmUDVRflPCz8uMYqeqlNDlanNU9eapaLwCXM=;
  b=N0L3FCMxVLB/CNWWbbGn9UDurnroJXa7oNSmhy0ukMtGOUkb8jbVMGlu
   YXsvBhZK3yrcrfdehRG7GIvC6jxmc+bLFuD5vCqmRkNf7Pa1irFLMZygI
   wy4QC+2/LeX3rKfZdl+/CkhH6eAjO/sYMDHLBqWWrh7JIysspXM2U567/
   A605+OFnaxGB5jsZZUGoc1szseZrYDXtxykfru/EuyajT6wpPD4DK/Rqw
   bdUvJ9k8HS9ZKqKiSxXhZwD4ULVZFsSMnxTvhBoUPOS/3UBDdDENM9bnE
   leNZ+19zLk5KeQM2NSBjcJVewp2IQqRoeDBQbHB2qqM75blHoZiWaUTAh
   g==;
X-CSE-ConnectionGUID: E/PdIr15RDaZGqnfevhQgw==
X-CSE-MsgGUID: DgoYrBvXTna9L4fcG6YzCQ==
X-IronPort-AV: E=Sophos;i="6.23,158,1770620400"; 
   d="scan'208";a="222904266"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 09:30:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.87.151) by
 chn-vm-ex4.mchp-main.com (10.10.87.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Fri, 3 Apr 2026 09:29:32 -0700
Received: from [10.159.245.205] (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Fri, 3 Apr 2026 09:29:30 -0700
Message-ID: <0fdf436d-af96-4798-8099-31469217ac86@microchip.com>
Date: Fri, 3 Apr 2026 18:29:29 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: atmel-ecc - add Thorsten Blum as maintainer
To: Thorsten Blum <thorsten.blum@linux.dev>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea
	<claudiu.beznea@tuxon.dev>
CC: <linux-crypto@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
References: <20260403112135.903162-5-thorsten.blum@linux.dev>
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Content-Language: en-US, fr
Organization: microchip
In-Reply-To: <20260403112135.903162-5-thorsten.blum@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit

On 03/04/2026 at 13:21, Thorsten Blum wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Add Thorsten Blum as maintainer of the atmel-ecc driver.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

> ---
>   MAINTAINERS | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c3fe46d7c4bc..c23110384b91 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17216,9 +17216,10 @@ F:     Documentation/devicetree/bindings/media/microchip,csi2dc.yaml
>   F:     drivers/media/platform/microchip/microchip-csi2dc.c
> 
>   MICROCHIP ECC DRIVER
> +M:     Thorsten Blum <thorsten.blum@linux.dev>
>   L:     linux-crypto@vger.kernel.org
> -S:     Orphan
> -F:     drivers/crypto/atmel-ecc.*
> +S:     Maintained
> +F:     drivers/crypto/atmel-ecc.c
> 
>   MICROCHIP EIC DRIVER
>   M:     Claudiu Beznea <claudiu.beznea@tuxon.dev>

