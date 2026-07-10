Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9D8421A13;
	Fri, 10 Jul 2026 11:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783683930; cv=none; b=RVZg+aPCXiQVAESXmqBmqbRJvl+tShCnlD3YJRGPJNW8pq9n6PjWbYyG82nXQlNoWnuJUp7LooaW7qOZ/9oHYmH4dn1kq3bXR8U1tB049JJvVz9NxbI/gfoJsYPiX6MQ43gn5I52efh7v3ZyehgaDwqX15fF7hojmcGKhJkIpt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783683930; c=relaxed/simple;
	bh=u5nphNG168GZ/VoM3JlEPFsfbmOIChAwWaJlqtZYhRU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hVXEJra9sYuDd4oW1Zz+zynJ59vSI9JbInyixL1o0y3iQ/R/SShbCTBFQp26YF6b3lTIiJEX5jufZvfgMo7QbvPdmvhRQxqI8VOyoDozqfTICJ70yAVXBJ/ak976kuUUeR/tav54kIge+tYjLJHC+kXOpDbWN0VF9C0B83xJatY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=QYTxTAwl; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="QYTxTAwl"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id BA1C21A0F3A;
	Fri, 10 Jul 2026 11:45:10 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 828E560342;
	Fri, 10 Jul 2026 11:45:10 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0B21111BD0281;
	Fri, 10 Jul 2026 13:44:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1783683909; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=lNEfnd2GOwK6OV6o3n233rtSH9H6bRRqMfAyW9Ht5sQ=;
	b=QYTxTAwl8ZZXjQUPTzcKeqjX0JGuQk0ZxPy1WBaHghwxQ14Zbow3vbxZLkweXwy9an4Rrs
	iF83k5c+2MPNBs52qoP9HCDa10QpUnqxWF+90v+GHdaaFRIU8sH+BsNMsRcfJIPqNhQoj5
	/JyDADaosgmQ3YFMvJa/694nNHppGxSrixD96m1Z9qWZ3LfzvDacOcUJfbQ3NT4Yzvy90v
	Gj3FoBW+DOqcbX/E2tByHZxsmKxfTeDAezvKuaFuFlmdgV4016fhRh1xRKFcbAIEEL9mdG
	Nchh02+7vjL7SK9qqTVdwab/4W5DIfcjRyILYca8ShWQjF4smF+DWQoc438ZRg==
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Brian Masney <bmasney@redhat.com>,  Michael Turquette
 <mturquette@baylibre.com>,  Rob Herring <robh@kernel.org>,  Krzysztof
 Kozlowski <krzk+dt@kernel.org>,  Conor Dooley <conor+dt@kernel.org>,
  Thomas Gleixner <tglx@kernel.org>,  Olivia Mackall <olivia@selenic.com>,
  Herbert Xu <herbert@gondor.apana.org.au>,  Jayesh Choudhary
 <j-choudhary@ti.com>,  David S. Miller <davem@davemloft.net>,  Christian
 Marangi <ansuelsmth@gmail.com>,  Antoine Tenart <atenart@kernel.org>,
  Geert Uytterhoeven <geert+renesas@glider.be>,  Magnus Damm
 <magnus.damm@gmail.com>,  Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
  Pascal EBERHARD <pascal.eberhard@se.com>,  Wolfram Sang
 <wsa+renesas@sang-engineering.com>,  linux-clk@vger.kernel.org,
  devicetree@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-crypto@vger.kernel.org,  linux-renesas-soc@vger.kernel.org,  Herve
 Codina <herve.codina@bootlin.com>
Subject: Re: [PATCH 10/16] clk: Add support for clock nexus dt bindings
In-Reply-To: <177595635458.5403.1619739189587608339@lazor> (Stephen Boyd's
	message of "Sat, 11 Apr 2026 18:12:34 -0700")
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
	<20260327-schneider-v7-0-rc1-crypto-v1-10-5e6ff7853994@bootlin.com>
	<acqT3Dh03y3JiLLc@redhat.com> <87y0j76p8o.fsf@bootlin.com>
	<177595635458.5403.1619739189587608339@lazor>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Fri, 10 Jul 2026 13:44:53 +0200
Message-ID: <87jyr3gjbe.fsf@bootlin.com>
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

>> > Before I left my Reviewed-by, I should have double checked Sashiko. It
>> > has several questions about this patch. The first is:
>> >
>> >     Are there other places in the clock framework that need to transit=
ion to the
>> >     new map API to ensure assigned clocks work?
>> >=20=20=20=20=20
>> >     For instance, assigned-clocks and assigned-clock-parents are parse=
d in
>> >     drivers/clk/clk-conf.c using of_parse_phandle_with_args(). If a de=
vice
>> >     specifies an assigned clock that routes through a nexus node, will=
 it fail
>> >     to configure because the map is not traversed?
>>=20
>> The goal of the nexus node is to isolate what is behind. Are
>> assigned-clocks et al. supposed to traverse a nexus node? I am tempted
>> to say "no", but I'm open to discussing this ofc.
>
> Why would assigned-clocks not traverse the nexus node? If I'm a DT
> author I would think any clock specifier should be routed properly
> through the nexus node.

Ok, giving this another thought, it may indeed be relevant to apply a
default frequency which needs to traverse the nexus to be active. I've
done the same change in the clk-conf.c file and tested with a dummy
example, it just works.

Thanks,
Miqu=C3=A8l
