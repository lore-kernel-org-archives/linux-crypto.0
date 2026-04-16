Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CC01514F8
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 18:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776362652; cv=none; b=S/DT81Su/zGFSbe/JEvwUgGi2rxjIFec7E8Etv78Fdm1j1Xdna/6yQ0JveE0iqHJ4cu7JjixS4tYQKnned5cGnYiDlRclUstpQRuvwqPnBoPbh8v+8EZWjQ8vA0SCurZABiI23d+WGuoZTlCcokl9dH2HAD1HVkWdUCpl7Bpd84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776362652; c=relaxed/simple;
	bh=1aJB64SpCLSB+TqXKVC4Eo6mW4snqfD2tZf6JN6ekUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UQ50U0UpDKJZYBeERNkqRdS/N4LRw3hwE9AaCsh+hDHg8SslF7c679h3uUenx4v9W2GvJ/V9GkNNOxp3GYp/aeZ2KbhuXKpvZFausj5GUl7FGrNKySTWMBWVMNY7XB2v/O2QO6VTEE4w5dd2GFelJVZF1ZtOm/rFTsfan2yQPjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=bNZv8G4S; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="bNZv8G4S"
Received: (wp-smtpd smtp.wp.pl 28894 invoked from network); 16 Apr 2026 20:04:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1776362644; bh=q2TLkBLJgx5iZgaI4yK1wJo0nl+wnUsigpfkHfj26wo=;
          h=Subject:To:Cc:From;
          b=bNZv8G4S4o5+V5wPHaAst1IsRHZxM/suNW+W7V59KiBJ9WHPirx0Yr8wrBYaPYGp/
           8stCJm7EhJ3ZlkqWGi0rPsPtqnK0ZtAj+9ORqhkOqcTJ5InqYz8NwbtNaaR2URznLp
           jQ0HvbCKrAfhOC04zh3Q9vroty62tI0HHpAtZeoqXs92rcrhFwcEJvGAQ86550uXFt
           Dh99zMUvZqyGkr+i1uzI9yPkm46P1x/2xtArvO6eqT5Pprt1ehleLq60/UwtPa3SoV
           VIndGzx4fdoul/pqZcglagPy6a/Jf9G61N3HKbt7U40y1F5J4TmJbX/T2RmqSvwxad
           z4KsgncRhu2+A==
Received: from 83.24.120.84.ipv4.supernova.orange.pl (HELO [192.168.3.203]) (olek2@wp.pl@[83.24.120.84])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <miquel.raynal@bootlin.com>; 16 Apr 2026 20:04:04 +0200
Message-ID: <444b4349-3873-4da6-aadd-3605e738ad0d@wp.pl>
Date: Thu, 16 Apr 2026 20:04:03 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] dt-bindings: interrupt-controller: Describe EIP-201
 AIC
To: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>,
 Michael Turquette <mturquette@baylibre.com>, Stephen Boyd
 <sboyd@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Jayesh Choudhary <j-choudhary@ti.com>,
 "David S. Miller" <davem@davemloft.net>,
 Christian Marangi <ansuelsmth@gmail.com>, Antoine Tenart
 <atenart@kernel.org>, Geert Uytterhoeven <geert+renesas@glider.be>,
 Magnus Damm <magnus.damm@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Pascal EBERHARD <pascal.eberhard@se.com>,
 Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-clk@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
 <20260327-schneider-v7-0-rc1-crypto-v1-2-5e6ff7853994@bootlin.com>
Content-Language: pl
From: Aleksander Jan Bajkowski <olek2@wp.pl>
In-Reply-To: <20260327-schneider-v7-0-rc1-crypto-v1-2-5e6ff7853994@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-WP-MailID: 7de5bd77c80430cfb5ca2f9c375fd890
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [wfNc]                               

Hi Miquel,

On 27/03/2026 21:09, Miquel Raynal (Schneider Electric) wrote:
> diff --git a/include/dt-bindings/interrupt-controller/inside-secure,safexcel-eip201.h b/include/dt-bindings/interrupt-controller/inside-secure,safexcel-eip201.h
> new file mode 100644
> index 000000000000..ead73bd96296
> --- /dev/null
> +++ b/include/dt-bindings/interrupt-controller/inside-secure,safexcel-eip201.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: (GPL-2.0-only OR MIT) */
> +
> +#ifndef _DT_BINDINGS_IRQ_SAFEXCEL_EIP201_AIC_H
> +#define _DT_BINDINGS_IRQ_SAFEXCEL_EIP201_AIC_H
> +
> +#define AIC_PKA_INT0 0
> +#define AIC_PKA_INT1 1
> +#define AIC_PKA_INT2 2
> +#define AIC_TRNG_INT 3
> +#define AIC_RESERVED 4
> +#define AIC_SL_ERR_INT  5
> +#define AIC_PROTECTION_INT 6
> +
> +#endif

This interrupt mapping is specific to the EIP-150. The EIP-201 is also 
integrated
into other accelerators, such as the EIP-97, EIP-196, and EIP-197, and the
interrupt mapping is likely different there. Maybe it would be better to use
eip150 name instead of eip201?

As for EIP-28, it is also part of EIP-94. EIP-94 is supported by the 
amcc driver.
EIP-94 consists of four components:
* crypto accelerator (unnamed?),
* PRNG (EIP-73d),
* TRNG (unnamed?),
* PKA (EIP-28).
Only the first three components are supported by the amcc driver.


Best regards,
Aleksander

