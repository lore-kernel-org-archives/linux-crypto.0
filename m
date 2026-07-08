Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1974657DD;
	Wed,  8 Jul 2026 12:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783515597; cv=none; b=LmWLTec1Hzr0qKZepHxNlWG+HsiZe0dvd1EraEgdi/4fkL/1pxcKFLBPgxnm/5eJ/cVjTRY2Pdo4KB1psrTDc0DBZl6vYQSqkIKWXjrSJzCbq71GjwOWoTuu7AW87jfOmIdfGTewTsQSH2kE6O6OWJKehcURyiicDupxOuZAlK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783515597; c=relaxed/simple;
	bh=V7aK68/26qBGEJjFgpBRUzW4ex72yHCq+Vx2aTGwmY0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JnGPBq3OcKdOyrk310u43pTH5fvTiDyVqSc6eia3zHbfQ7jnyllsdePSiXbDZv9xBc7B2EUMm014XSKwFiAp787K+xaIAoLjYuviWqKf7SCOvZJuca9rMA5FViHTQoZu0fbotkh7U6SKRzDC4xjAcTtSL2uZ78TRC6K7giMhfxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=VOAH5+5D; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="VOAH5+5D"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 121164E40CF7;
	Wed,  8 Jul 2026 12:59:55 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id D759060337;
	Wed,  8 Jul 2026 12:59:54 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C0E2411BC0DDB;
	Wed,  8 Jul 2026 14:59:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1783515593; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=KqbPk7W/xg9la/kQEemsDvBwfwa0jXXj/79ki0DXFUk=;
	b=VOAH5+5DHS2rc2xNoQRdbNJZoXcP50tsx2tg6u9Vn+1G8/gWEAO0EhcRuPez+p7StIu5MH
	5fcxKSvilbQdrohHObOos7NpPJBK8lX44UxS3cvlop87Sm0cSG8YYmO44ycvaW0orfuhZy
	NQghTqrl59BpuSjzHFOXtUQPv5YMjTLAtDyDT40cNKtXO8QcPdl1X4jtZiUWsz2zCJ2Rgl
	CeWCSdKD9pGBpJYBBUA9rQQp2tPdQ5D0x5EhdaZLqtQeTsFPLSGQ0Qy5JlSbbYP7ixkq6i
	602YLUhIXs7OP5tq88tgmqV5VIyFmyTd7GLXGVYeyb6fWcndHksvT6yg0Lgjzw==
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Turquette <mturquette@baylibre.com>,  Stephen Boyd
 <sboyd@kernel.org>,  Rob Herring <robh@kernel.org>,  Krzysztof Kozlowski
 <krzk+dt@kernel.org>,  Conor Dooley <conor+dt@kernel.org>,  Thomas
 Gleixner <tglx@kernel.org>,  Olivia Mackall <olivia@selenic.com>,  Herbert
 Xu <herbert@gondor.apana.org.au>,  Jayesh Choudhary <j-choudhary@ti.com>,
  "David S. Miller" <davem@davemloft.net>,  Christian Marangi
 <ansuelsmth@gmail.com>,  Antoine Tenart <atenart@kernel.org>,  Magnus Damm
 <magnus.damm@gmail.com>,  Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
  Pascal EBERHARD <pascal.eberhard@se.com>,  Wolfram Sang
 <wsa+renesas@sang-engineering.com>,  linux-clk@vger.kernel.org,
  devicetree@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-crypto@vger.kernel.org,  linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 12/16] irqchip/eip201-aic: Add support for Safexcel
 EIP-201 AIC
In-Reply-To: <CAMuHMdWr5OT0iAbZMgDAizO9KnhmyUN3hsqFnp+JYRao4aKu_A@mail.gmail.com>
	(Geert Uytterhoeven's message of "Wed, 8 Apr 2026 10:05:18 +0200")
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
	<20260327-schneider-v7-0-rc1-crypto-v1-12-5e6ff7853994@bootlin.com>
	<CAMuHMdWr5OT0iAbZMgDAizO9KnhmyUN3hsqFnp+JYRao4aKu_A@mail.gmail.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Wed, 08 Jul 2026 14:59:48 +0200
Message-ID: <87ldbliqm3.fsf@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

Hello Geert,

Sorry for the late replay.

>> --- a/drivers/irqchip/Kconfig
>> +++ b/drivers/irqchip/Kconfig
>> @@ -826,4 +826,12 @@ config SUNPLUS_SP7021_INTC
>>           chained controller, routing all interrupt source in P-Chip to
>>           the primary controller on C-Chip.
>>
>> +config SAFEXCEL_EIP201_AIC
>> +        tristate "Safexcel EIP201 AIC"
>
> Is there any platform dependency that could be added here?

In practice no, because this is an IP block that has been integrated in
many SoCs (I don't have the list). However if you care about reducing
the list of possible options I can make it depend on the RZN1
architecture, where I need it, but I don't see this as an relevant
move. What do you prefer?

Thanks,
Miqu=C3=A8l
