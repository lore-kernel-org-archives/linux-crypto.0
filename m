Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BC3317715;
	Mon,  9 Feb 2026 13:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770643531; cv=none; b=rVT6t+VnNE46didULgNBEKCFa23cPXdbQ46Gmp5IJ5XIKgMQz1RdwxUfI5rzcyAQOqDucS+UVB57f2m7BLlfU0stjs/lYWM5dlGhrbVhJoFRqQhHQkjKyhGfIFOXT92kHNchmI7bRTEyU5wVud8NE5a7MJyQhoGP2caf2zZpFDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770643531; c=relaxed/simple;
	bh=x/JFFSSdXz21Xwy0PVHHauItjrrsvw406j0rnGBJUAk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N0RdYETgAn5koOS5EIgq+9dxpCMjDcDzcTllOuTkd4cMrEV0KlaQ3RTzUUkad+lm1q7mUW1NDWZkKa/ZX8BFWyTw5ihP6v1Nycozasls8YW8ulBgNEtSH46DNt7J5NlPLCGDNunoxD/yA4vLxEZkz0x3dZT2g/rcNwoaLXC97M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=JnbnDVZI; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="JnbnDVZI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1770643530; x=1802179530;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x/JFFSSdXz21Xwy0PVHHauItjrrsvw406j0rnGBJUAk=;
  b=JnbnDVZIHtH/jewkt9aVdKqILMEvGtR+Tx8puWlW3YDjmSk7IvosXqKE
   wznSHQ0LwBR9QemmlLYitexO9TDEiW4pfVTyknraEc45itrNYBnmXO8K6
   iahjIvHrR8mQ8vmkrhz1tPtAzmbO0Dh1kdfhe6qUWv+nB/cVbDiCnDAyz
   bM8r9qCyoXxITBHSQLGaONL5xqDzCcHf7uCFi70RjthobCALRDeHnAHT+
   8rVNI1aRgos+qkwYi5ghO/jotJZKi0ECoKOZksC2MYfzkINtC8AUp3/kl
   b8PM0bg2SU81Vc691N8dkqRJpnhu/oGhB/u/vsNW4JULR4SiPomfaOkSk
   g==;
X-CSE-ConnectionGUID: oP1LAc5MQFujvwkAhKJHHQ==
X-CSE-MsgGUID: IBJrM1wyRPKl5KcA381PqA==
X-IronPort-AV: E=Sophos;i="6.21,282,1763449200"; 
   d="scan'208";a="60392621"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Feb 2026 06:25:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Mon, 9 Feb 2026 06:24:58 -0700
Received: from DEN-DL-M70577 (10.10.85.11) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Mon, 9 Feb 2026 06:24:52 -0700
Date: Mon, 9 Feb 2026 14:24:52 +0100
From: Daniel Machon <daniel.machon@microchip.com>
To: Robert Marko <robert.marko@sartura.hr>
CC: <robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
	<claudiu.beznea@tuxon.dev>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lee@kernel.org>, <andrew+netdev@lunn.ch>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<Steen.Hegelund@microchip.com>, <UNGLinuxDriver@microchip.com>,
	<linusw@kernel.org>, <olivia@selenic.com>, <richard.genoud@bootlin.com>,
	<radu_nicolae.pirea@upb.ro>, <gregkh@linuxfoundation.org>,
	<richardcochran@gmail.com>, <horatiu.vultur@microchip.com>,
	<Ryan.Wanner@microchip.com>, <tudor.ambarus@linaro.org>,
	<kavyasree.kotagiri@microchip.com>, <lars.povlsen@microchip.com>,
	<devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
	<linux-spi@vger.kernel.org>, <linux-serial@vger.kernel.org>,
	<luka.perkov@sartura.hr>
Subject: Re: [PATCH v5 08/11] arm64: dts: microchip: add LAN969x support
Message-ID: <20260209132452.avsmiidcyjcqys7j@DEN-DL-M70577>
References: <20260115114021.111324-1-robert.marko@sartura.hr>
 <20260115114021.111324-9-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260115114021.111324-9-robert.marko@sartura.hr>

> Add support for Microchip LAN969x switch SoC series by adding the SoC DTSI.

Acked-by: Daniel Machon <daniel.machon@microchip.com>
