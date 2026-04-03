Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6056034EF1B;
	Fri,  3 Apr 2026 16:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775233833; cv=none; b=gY/DTeJz47/Di7V+k/m9egwan3OXxwUrPLamJJ2VTKtQtpKpRp6N5APq/35EiTWSZJN+R5eo0OZVpGjFj2eabrhR0/wqXkKsdgbOaO0DcFBKD5Re/lcaNtWbXe5wWonLfeJQXZFVXsS0BBDAKeAm5S5Nzl+jcmJz7Z3CwPMcCeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775233833; c=relaxed/simple;
	bh=hnXbTiCURWkWhcJukdVHDLVwJkYC/OiQhhQ6AqQbxkw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iEq12xQw8a7s5YGPVhIHIRqVepEjr+seE2DKQ6UcfpcchGl/gUwaRrwshuSKpkn+1lBO/5l+fUMQktxfj8QiOEeLNUvkjZkQ+xuLIWFp81g3YveKSCGbsHt6hnu8066G3zQ8LFL/M0CoW24ZUGSOgrTYV33FiYIHt8SafYJuPmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=exD5dii/; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="exD5dii/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1775233832; x=1806769832;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hnXbTiCURWkWhcJukdVHDLVwJkYC/OiQhhQ6AqQbxkw=;
  b=exD5dii/xUIPongdKWdnaM1VVn9zkmh6u4elrKJd2OBWZ3FODW4VkDS8
   4uqU4Qxf1M2j7i4zuzgOI4kJRiYRFV1kboq8mBEF4NmkbyTpc4WNP8BPM
   BSZUdsOm9pohRymvB8pJ2kaHmcJd1gJaC+USiHA0VlQokH/b+NyHM1Nqa
   PUTtLqsJ4N74QzixQzDZrrFRiYyIwNSTexfBxYCObvJolhTs5VxCL3I9O
   LKLwCb5FFOiZWktHcJT+9RlJ3iQ/WRGqMEuBlwHesgWARF3vgvR/s/mlT
   5MdY3BOGylFrBrDcVXK3xJRUTttlIlszTLdSLxgtwQ1GTp/bdkVv4tgsW
   Q==;
X-CSE-ConnectionGUID: dUDUSQJ+T8aeZQq9X6+uCg==
X-CSE-MsgGUID: iUmQc9GxQcS1JvNTZT1BOQ==
X-IronPort-AV: E=Sophos;i="6.23,158,1770620400"; 
   d="scan'208";a="222904307"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Apr 2026 09:30:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Fri, 3 Apr 2026 09:30:13 -0700
Received: from [10.159.245.205] (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Fri, 3 Apr 2026 09:30:11 -0700
Message-ID: <29b697cf-90ae-4239-898b-2026dbf368dc@microchip.com>
Date: Fri, 3 Apr 2026 18:30:10 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] crypto: atmel-sha204a - add Thorsten Blum as
 maintainer
To: Thorsten Blum <thorsten.blum@linux.dev>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea
	<claudiu.beznea@tuxon.dev>
CC: <linux-crypto@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
References: <20260403112135.903162-5-thorsten.blum@linux.dev>
 <20260403112135.903162-7-thorsten.blum@linux.dev>
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Content-Language: en-US, fr
Organization: microchip
In-Reply-To: <20260403112135.903162-7-thorsten.blum@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit

On 03/04/2026 at 13:21, Thorsten Blum wrote:
> Add a MAINTAINERS entry for the atmel-sha204a driver and Thorsten Blum
> as maintainer.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks Thorsten for taking care of those components.

Best regards,
   Nicolas

> ---
>   MAINTAINERS | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c23110384b91..7317d80592cf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17197,6 +17197,12 @@ S:     Supported
>   F:     Documentation/devicetree/bindings/serial/atmel,at91-usart.yaml
>   F:     drivers/spi/spi-at91-usart.c
> 
> +MICROCHIP ATSHA204A DRIVER
> +M:     Thorsten Blum <thorsten.blum@linux.dev>
> +L:     linux-crypto@vger.kernel.org
> +S:     Maintained
> +F:     drivers/crypto/atmel-sha204a.c
> +
>   MICROCHIP AUDIO ASOC DRIVERS
>   M:     Claudiu Beznea <claudiu.beznea@tuxon.dev>
>   M:     Andrei Simion <andrei.simion@microchip.com>

