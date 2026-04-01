Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DA63B19BF;
	Wed,  1 Apr 2026 09:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775034639; cv=none; b=n1nXZvGrcZaTa9tyEfsXBfoFiCbe5FkB0h3I83UaeaN1VuOzRe8aiIWKd9IEoY64vol39pdJyB0eWMjvwYkbp38ntTXxq8+Hq9hNj6RmVhtLfTpJUgAo5dIAw//phPyW72m46CGfMOQ6qRZysj511ouNohFzB4lDflwCNzcZzQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775034639; c=relaxed/simple;
	bh=67tehFPULsnBQBSHurQ2H+katU3ihm8OP1wiQ5SN8fk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Pa7LvKZ7V3HmPpzEK0nyHAPTDd+vIjcVYmzoPDsyU2D5NgccDAu28PNR/Sk3i6dio+IGkSBeTrTcPk1+3t4vzdYPnKBVCOIMoMC0EWUe2rha5NlJ+WyyKkwlLvWxAmJH7mOeDBJGSRors2khKTtgMcYOYvsXTdrTa0//u8JMglU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=LwhwsEKj; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="LwhwsEKj"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 3CBB0C5996A;
	Wed,  1 Apr 2026 09:11:06 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 41314602BF;
	Wed,  1 Apr 2026 09:10:35 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id EA9F8104502B1;
	Wed,  1 Apr 2026 11:10:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1775034634; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=gfFQ035rSqrjjpjp2jqpEiQh/kF9oL8HMuP9CrZqj/Y=;
	b=LwhwsEKjNlEBqqEVyofN+JFGNFS15C4QOr1PXfOjON/7jKRYAAQiD028lxS7GCtUJR8+f2
	TzoBwQKcYTWGoVgCLXvajbBd9zGtjWBRqo43GIsGlSObzXofhEwEd8Q8MNkqS1Ok5/TdIB
	IHbPeVMmtpsmK9X90J+CFkSPqhUF3R0CvQSuTti+Vfq+GcT4capSvhSRZSvdsVc2X/9Ppg
	jnakrNXj0PDlHGbfHQMDaNKe26qjnNEyd2aWX9/apcjTtz0tubwQAB59nqAt7bnzo70FuZ
	DIajGeSqt590jxe/ifGehmLSYe5WWY3rGWBXrbXV6AKPo0YaeZ7Njlmsj0WhSQ==
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Thomas Gleixner <tglx@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>,  Stephen Boyd
 <sboyd@kernel.org>,  Rob Herring <robh@kernel.org>,  Krzysztof Kozlowski
 <krzk+dt@kernel.org>,  Conor Dooley <conor+dt@kernel.org>,  Olivia Mackall
 <olivia@selenic.com>,  Herbert Xu <herbert@gondor.apana.org.au>,  Jayesh
 Choudhary <j-choudhary@ti.com>,  "David S. Miller" <davem@davemloft.net>,
  Christian Marangi <ansuelsmth@gmail.com>,  Antoine Tenart
 <atenart@kernel.org>,  Geert Uytterhoeven <geert+renesas@glider.be>,
  Magnus Damm <magnus.damm@gmail.com>,  Thomas Petazzoni
 <thomas.petazzoni@bootlin.com>,  Pascal EBERHARD <pascal.eberhard@se.com>,
  Wolfram Sang <wsa+renesas@sang-engineering.com>,
  linux-clk@vger.kernel.org,  devicetree@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-crypto@vger.kernel.org,
  linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 12/16] irqchip/eip201-aic: Add support for Safexcel
 EIP-201 AIC
In-Reply-To: <87pl4oayll.ffs@tglx> (Thomas Gleixner's message of "Sat, 28 Mar
	2026 14:10:46 +0100")
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
	<20260327-schneider-v7-0-rc1-crypto-v1-12-5e6ff7853994@bootlin.com>
	<87pl4oayll.ffs@tglx>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Wed, 01 Apr 2026 11:10:29 +0200
Message-ID: <87bjg36o6y.fsf@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

Hello Thomas,

>> +struct eip201_aic {
>> +	struct device *dev;
>> +	void __iomem *regs;
>> +	struct irq_domain *domain;
>> +	struct irq_chip_generic *gc;
>> +	u32 type;
>> +	u32 pol;
>> +};
>
> Please follow:
>
> https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#struct=
-declarations-and-initializers

Ah, I didn't know about this document, I'll go through it and fix the style.

Thanks for the feedback,
Miqu=C3=A8l
