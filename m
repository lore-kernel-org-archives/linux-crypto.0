Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1453371CEE;
	Fri, 17 Apr 2026 07:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776412243; cv=none; b=K9TUrqDx4+C/kTZMub+WXUlayWkQrGDzWPWxiBE3XslJUQi8ppVfK4EmtCR7lr05A4ecrGuT4fs5OQ73+Pz/qsvnALVO6Wkaov4km/MAZz9MiYZvDzRHlDdY3NobyE65hGBT3h4vtvrV/TutL8Uu/6tqdvZS5OxxzIwZKAp2ZeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776412243; c=relaxed/simple;
	bh=mN9SIeXfRCe7zV5stdN76y8+361AYnzBpG7i78ynP6E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JoToOxa+lIZRiz7Yup28ttnUQBMmuePprPHsf5Xzjaxg16h5MlLzK2b3BRYFLoLrNCHvQNatGQ9lAOSWUpxN3N7uBXxTbKFIVlXOyS1Aa9P+jOzZQdWR8l0fVWt20R2kq/xHXK6apm1a15j5Be8QoO+WCsINJs1u7vyTmogvsGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=kSSVjutW; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="kSSVjutW"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 7DD1FC5C3D8;
	Fri, 17 Apr 2026 07:51:10 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 00A6360497;
	Fri, 17 Apr 2026 07:50:32 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C98CC10460952;
	Fri, 17 Apr 2026 09:50:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776412230; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=TfT7hmmZx8Kr7kxPd8PXiGjFEe0ZJMTCF2H4FVfguC0=;
	b=kSSVjutW5+6st3wLsgmGMbKBs+AWGo9jKztX2gQQHiLq/D5ZaxHz6TQmy6/ktSAAKONcQq
	f3ydv7wWoVRA6Q5iHv23NRExFtqmD9MxBsLqw46YhA1XbbTeTWEdLuqNRIiUJ25ghokeOm
	+b2o1rbkO6Ue3xrujQzfvDBIKF4otZMr3Wl6w4NGIFcwa7U9Ibfj777V/EBtTxB9DL9ix4
	gLttANP+B7PX+lLr0ygG+R9l7BDCTonz097+IYQlWJdZ0Ug7lkLK82rZhjofdasPo+lkbr
	XIsX6CNajkMrXAtWPPRhhFfWhMYEmWYGQrV8PRbFtQl8v/l3UL9y0V+mTI3WFw==
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
Date: Fri, 17 Apr 2026 09:50:20 +0200
Message-ID: <87tstac9fn.fsf@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

Hi Aleksander,

On 16/04/2026 at 20:04:03 +02, Aleksander Jan Bajkowski <olek2@wp.pl> wrote:

> Hi Miquel,
>
> On 27/03/2026 21:09, Miquel Raynal (Schneider Electric) wrote:
>> diff --git
>> a/include/dt-bindings/interrupt-controller/inside-secure,safexcel-eip201=
.h
>> b/include/dt-bindings/interrupt-controller/inside-secure,safexcel-eip201=
.h
>> new file mode 100644
>> index 000000000000..ead73bd96296
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

Thanks a lot for the heads up, I didn't had that information, I will
adapt the naming to make it more accurate future proof.

> As for EIP-28, it is also part of EIP-94. EIP-94 is supported by the
> amcc driver.
> EIP-94 consists of four components:
> * crypto accelerator (unnamed?),
> * PRNG (EIP-73d),
> * TRNG (unnamed?),
> * PKA (EIP-28).
> Only the first three components are supported by the amcc driver.

Is this driver upstream? I didn't find it. Anyhow, thanks for the
feedback, I will update with this knowledge in mind.

Miqu=C3=A8l
