Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F663F164E;
	Fri, 10 Jul 2026 09:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783676930; cv=none; b=tGdBT29alBeA1CyfTmQdI+cJ9PKZZcXn9DHTj/g0tY0p8jiQaGNMj2d6OSfOQeEq8EnI3xuSGmPYrOZvCO7kMsfZhItJXourbRKdDFgefD8KQ/KHMhaqRiC/JcKcUpQ40Ajeh0wE1OjiF1YbFWnysFJ9QaGu1fFAlmMMKGzzQ/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783676930; c=relaxed/simple;
	bh=wuG2shP5X+UkXSmhr4knH5rocVOOk/BakyEWwoAFI/0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=h/Fc8cwg0XpqisHisD4Uoa0SEE+DVd+3Z59Ixun8Jee6jx9L9O0nbzRxn2O2QPhkQ7bemOa+yoF0gAvbvDP6QZT3UsV5dsz+9eSKPyVO9qkd5zQAt8OSZUuThfJ0shkiSiriLE/xKFYra9WE5we+ZuY2aziMJwOXQlii/DRkQpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=ffO+0698; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="ffO+0698"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id EE7704E40D3C;
	Fri, 10 Jul 2026 09:48:45 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id ACA1360341;
	Fri, 10 Jul 2026 09:48:45 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A21C611BD2834;
	Fri, 10 Jul 2026 11:48:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1783676924; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=S8k4iLzkxJVSSUQQwc8HGDvZ17LYlFShfGvdGTUVWi8=;
	b=ffO+0698dM6X34VENvE0Cje5NMC4UCdo5a7VKBYCqDDJFmSorUxab4kQs7JbvzFyYURbcv
	jTwk1gynEPETItolgJXuY0ZTtmn/jbcpEXq+ip3OLqPaOhyK16EgKQFGQFuquH2uf5F52m
	J6WZTychwmy5vzMTENDNgSuFjl0pgprv0h1iOM9ZGzElyDo4By8qCmfqGZL/lOW5ZhOBTm
	TshJisWrE6WbOzwCGGEDbxU9vtLiQ5GW5u/WIkf4RVB5FId3rIdJN7rrxB026RgN1sAavk
	3LxOHW3vk1FVgZPcgmmYNap0tUz1NvwrxangAvzwdh/FZZFRTiOKEAYRthfaow==
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: Michael Turquette <mturquette@baylibre.com>,  Stephen Boyd
 <sboyd@kernel.org>,  Rob Herring <robh@kernel.org>,  Krzysztof Kozlowski
 <krzk+dt@kernel.org>,  Conor Dooley <conor+dt@kernel.org>,  Thomas
 Gleixner <tglx@kernel.org>,  Olivia Mackall <olivia@selenic.com>,  Herbert
 Xu <herbert@gondor.apana.org.au>,  Jayesh Choudhary <j-choudhary@ti.com>,
  "David S. Miller" <davem@davemloft.net>,  Christian Marangi
 <ansuelsmth@gmail.com>,  Antoine Tenart <atenart@kernel.org>,  Geert
 Uytterhoeven <geert+renesas@glider.be>,  Magnus Damm
 <magnus.damm@gmail.com>,  Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
  Pascal EBERHARD <pascal.eberhard@se.com>,  Wolfram Sang
 <wsa+renesas@sang-engineering.com>,  linux-clk@vger.kernel.org,
  devicetree@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-crypto@vger.kernel.org,  linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 02/16] dt-bindings: interrupt-controller: Describe
 EIP-201 AIC
In-Reply-To: <444b4349-3873-4da6-aadd-3605e738ad0d@wp.pl> (Aleksander Jan
	Bajkowski's message of "Thu, 16 Apr 2026 20:04:03 +0200")
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
	<20260327-schneider-v7-0-rc1-crypto-v1-2-5e6ff7853994@bootlin.com>
	<444b4349-3873-4da6-aadd-3605e738ad0d@wp.pl>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Fri, 10 Jul 2026 11:48:38 +0200
Message-ID: <87y0fjgop5.fsf@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

Hello,

>> --- /dev/null
>> +++ b/include/dt-bindings/interrupt-controller/inside-secure,safexcel-ei=
p201.h
>> @@ -0,0 +1,14 @@
>> +/* SPDX-License-Identifier: (GPL-2.0-only OR MIT) */
>> +
>> +#ifndef _DT_BINDINGS_IRQ_SAFEXCEL_EIP201_AIC_H
>> +#define _DT_BINDINGS_IRQ_SAFEXCEL_EIP201_AIC_H
>> +
>> +#define AIC_PKA_INT0 0
>> +#define AIC_PKA_INT1 1
>> +#define AIC_PKA_INT2 2
>> +#define AIC_TRNG_INT 3
>> +#define AIC_RESERVED 4
>> +#define AIC_SL_ERR_INT  5
>> +#define AIC_PROTECTION_INT 6
>> +
>> +#endif
>
> This interrupt mapping is specific to the EIP-150. The EIP-201 is also
> integrated
> into other accelerators, such as the EIP-97, EIP-196, and EIP-197, and the
> interrupt mapping is likely different there. Maybe it would be better to =
use
> eip150 name instead of eip201?

I was about to rename the file (and the ifndef/define section), but in
the end I feel like it does not actually make sense to do that, because
it would require to include one header per container in the
driver. Instead, I propose another way: let's keep the file name as-is,
but mention with a comment above the definitions that these are specific
to the EIP-150 implementation. This way, if someone want to reuse the
controller for another integration, they can just add their own
interrupt names/numbers below, with another comment stating the name of
the container they apply to.

For future people who would like to extend this driver to another
container: mind that there is currently a list of "unused" interrupts in
the v2 of the driver (in the generic chip structure). This list may
simply go away if one needs one of the three interrupts currently
listed.

Thanks,
Miqu=C3=A8l
