Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C3F3BB67F;
	Wed, 29 Jul 2026 07:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785311433; cv=none; b=ErajCrrwuQeRDk136EsU0EDyWLcggVkvJybi3Ck+08x5upzLp+24ew/6a50bQyzG5R37++7jvezBiCMBASPvRxQ9VrhNWVfRLeP/cPRHMBN3c9bi7Y9KU8Wv/ueJS8XB74TVXWFjRWiM197G+54VD34e9zExqLKe31s22Mq3ryI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785311433; c=relaxed/simple;
	bh=65vERaYEfZgzRNyVxkXiMhyL9DeBArY3kGujTlJ7ROc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kzCSPGom7r6eqD1R26BY76BJsBcsXok/on8bB+AI3SRCAnpZrNXdSgcz//f03E0klSjZXH+yndc6aM21PmHtc/OYjYShX1/yLrU7RNPvqP/sj+Dk6Zf5JoUlnUTxyJqqPRBeb+PFPHzepEeY7Wx2QsPf2t/lTkFNblFEePXXT9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=qhzMCgI0; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="qhzMCgI0"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id CC3D91A12EC;
	Wed, 29 Jul 2026 07:50:23 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 9BFB56039A;
	Wed, 29 Jul 2026 07:50:23 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AC94911C14A66;
	Wed, 29 Jul 2026 09:50:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1785311418; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=65vERaYEfZgzRNyVxkXiMhyL9DeBArY3kGujTlJ7ROc=;
	b=qhzMCgI0cYznjxStafWw4+f5+UJI9KKOHwo1fRhHyU/o2E+wAtTQ9EEJqxU/4qsONrMhPy
	BdzGoCg0TQQhG5LZaARC1P6zZbacYxbslU9Ui1wxWZewNeCZF7xpx0QffP4ydTHs+2XBV4
	A/wMql8yTQmxEub1os/9yKe/rm6Y2BnK4pi9CloQbW+hlLjq/C836kBsdNydl5MnLvtgJZ
	xSIp0CEneLi/u9rA8S7s6Cij3eOTbdGs7OzmlZK7Ge++snffhFTtk2+gO3ti41/ckke6Ck
	ML3iE5boLmdXS1pjdpDOX/GGE3HbK3SUr5yz6RLrFXzUuOsmn8QvUxtlzH48EA==
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Frank Li <Frank.li@oss.nxp.com>
Cc: Stephen Boyd <sboyd@kernel.org>,  Brian Masney <bmasney@redhat.com>,
  Michael Turquette <mturquette@baylibre.com>,  Rob Herring
 <robh@kernel.org>,  Krzysztof Kozlowski <krzk+dt@kernel.org>,  Conor
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
  linux-crypto@vger.kernel.org,  linux-renesas-soc@vger.kernel.org,  Herve
 Codina <herve.codina@bootlin.com>
Subject: Re: [PATCH 10/16] clk: Add support for clock nexus dt bindings
In-Reply-To: <al58xBD6B1i3Yt3S@lizhi-Precision-Tower-5810> (Frank Li's message
	of "Mon, 20 Jul 2026 15:53:40 -0400")
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
	<20260327-schneider-v7-0-rc1-crypto-v1-10-5e6ff7853994@bootlin.com>
	<acqT3Dh03y3JiLLc@redhat.com> <87y0j76p8o.fsf@bootlin.com>
	<177595635458.5403.1619739189587608339@lazor>
	<87jyr3gjbe.fsf@bootlin.com>
	<al58xBD6B1i3Yt3S@lizhi-Precision-Tower-5810>
User-Agent: mu4e 1.12.12; emacs 30.2
Date: Wed, 29 Jul 2026 09:50:10 +0200
Message-ID: <871pcmp74d.fsf@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

Hi Frank,

> Any progress about this? we are trying to use it at
>
> https://lore.kernel.org/imx/20260629074734.3643227-2-chancel.liu@oss.nxp.=
com/
>
> This is quite useful. Is it possible to split clock part to make it
> progress?

Yes, I've sent a couple of iterations, the last one being v4 at the moment:
https://lore.kernel.org/linux-clk/amOuamq7CHo6xeCW@lizhi-Precision-Tower-58=
10/

But I see you found it! I can Cc you in the next submissions.

Thanks,
Miqu=C3=A8l
