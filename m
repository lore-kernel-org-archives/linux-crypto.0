Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8760C3EF0AC;
	Fri, 10 Jul 2026 09:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783676133; cv=none; b=utuVTK8oTUME6dZaCR0Y91Il+59u+5Pd7T1VViCZ3pUHLcAtjEdqesaX1ZHizWnRyoAykDViifia9Ie5UkfWbDpsSCBaT3Ld9vcFq/azHeVYL4NuG4Jt4u2M3O74oda8BuHcAReF5O7yRmmKgIn1KcFYIdVM0fVsI4Xzu0oMG4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783676133; c=relaxed/simple;
	bh=Y7o2uOQnU0O45QUBV45x3iTyOBBL2VrU2Fr3Mt5Lnm4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=TJeprdZZpCTs+HlfaGmi1llSASJnH7B77GIUYczm48JAj6P5vr4G6wz/y+kU7JIE/v31PThKPvJ9XydZYP//vXdbCo6AG9NEDVJl4gpJRnfMp3lzkVJgAUMLSFFL1wo2El0AYdUV7NEvLWYtWu8rN7Yk8gGRVnUaevcqVphZWfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=gv9PQac6; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="gv9PQac6"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 71AB0C2F4FE;
	Fri, 10 Jul 2026 09:35:44 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id B30B560341;
	Fri, 10 Jul 2026 09:35:29 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AF11811BD18F0;
	Fri, 10 Jul 2026 11:35:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1783676128; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=04Ye3yuYTISol3ighYQm4DeZ4Ndw6daOs3zln0ZTqVc=;
	b=gv9PQac6Cswbuf/VoBnruoDjQWwYMTlucUsqx40kUWzZ5ktNrgRd+MPtfW/9l7ubHyUmYZ
	8u3jkWgGbTY1PfgQM3jRJFJfP8F5AAzafDkptKGIqPzgIeaK2GYk43SUlnxmoUGuEEkY3Z
	ozRpF3pKamd/OztCVZVQhIb9rir1TtnbS/m8JCL51rdVN0FNNNY8W0TKgQa6rgc/HzMwZU
	6YObTMvFrC3PIg9gjFy9/znDIb9ciiZ9oAhsUjtOFm4GwOoWyAPi3ZjAW8PouL+cOR3iJQ
	fJBmYhE9Z4XSNJkuLfMgoIt6bVaTh/aTAATG5PA0H/5jscF/A7q/JM4rTsBqWg==
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Rob Herring <robh@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>,  Stephen Boyd
 <sboyd@kernel.org>,  Krzysztof Kozlowski <krzk+dt@kernel.org>,  Conor
 Dooley <conor+dt@kernel.org>,  Thomas Gleixner <tglx@kernel.org>,  Olivia
 Mackall <olivia@selenic.com>,  Herbert Xu <herbert@gondor.apana.org.au>,
  Jayesh Choudhary <j-choudhary@ti.com>,  "David S. Miller"
 <davem@davemloft.net>,  Christian Marangi <ansuelsmth@gmail.com>,  Antoine
 Tenart <atenart@kernel.org>,  Geert Uytterhoeven
 <geert+renesas@glider.be>,  Magnus Damm <magnus.damm@gmail.com>,  Thomas
 Petazzoni <thomas.petazzoni@bootlin.com>,  Pascal EBERHARD
 <pascal.eberhard@se.com>,  Wolfram Sang
 <wsa+renesas@sang-engineering.com>,  linux-clk@vger.kernel.org,
  devicetree@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-crypto@vger.kernel.org,  linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 01/16] dt-bindings: clock: Introduce nexus nodes
In-Reply-To: <20260407192900.GA3531350-robh@kernel.org> (Rob Herring's message
	of "Tue, 7 Apr 2026 14:29:00 -0500")
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
	<20260327-schneider-v7-0-rc1-crypto-v1-1-5e6ff7853994@bootlin.com>
	<20260407192900.GA3531350-robh@kernel.org>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Fri, 10 Jul 2026 11:35:23 +0200
Message-ID: <874ii7i3vo.fsf@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

Hello Rob,

>> +title: Clock Nexus
>> +
>> +description: >
>> +  A nexus node allows to remap a phandle list in a consumer node throug=
h a
>> +  container or a connector node in a generic way. With this remapping,
>> +  the consumer node needs to know only about the nexus node. Resources
>> +  behind the nexus node are decoupled by the nexus node itself.
>> +
>> +maintainers:
>> +  - Miquel Raynal <miquel.raynal@bootlin.com>
>> +
>> +select: true
>> +
>> +properties:
>> +  '#clock-cells': true
>
> No need for this.

I wasn't sure, I'll drop it.

>> +  clock-map:
>> +    $ref: /schemas/types.yaml#/definitions/uint32-matrix
>> +
>> +  clock-map-mask:
>> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>> +
>> +  clock-map-pass-thru:
>> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>
> I think this can be omitted because there aren't common cell definitions=
=20
> for clocks like there are for GPIO and PWM.

I agree, same here I wanted to mimic the existing nexus, but I agree it
is not super useful for clocks. It can be added later anyway, if ever
needed. I assume you mean here that we must drop both clock-map-mask and
clock-map-pass-thru, but obviously not clock-map.

Thanks,
Miqu=C3=A8l
