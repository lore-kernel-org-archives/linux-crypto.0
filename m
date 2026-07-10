Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2033F482A;
	Fri, 10 Jul 2026 09:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783676004; cv=none; b=BOYi0IgIAm0X9KcFOCNq/D/4q5Vw2PBDWfgsPQXavDLFGW1O44GqpJiLJ1YIBR67GfYMfL5Yl1DTUZfALJvInXHx1eyd0sd6GWqm6uqU4RGFdSLQTPhEWjSLxz12wjssrFUkfnpRqzGwCruCdMHVBxYNWatA9jNa6ry8bJi3cQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783676004; c=relaxed/simple;
	bh=T04Yklz3oRFt1PRpe4Yj4K9rJt4571BACCXcIi5ZLgs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YgnVC1s4lqEegkmSYDD392yarQ4P4R3tMo9EDzhe9w7w0QmMiXze0T3MZ+ReYVwlsfc3MnqOvtpPfnidlkACGxat7x3OtBFsCHtu8GEdl9eXK8bYTDxYQvWO9xYmD9ghh/ruLW2IvFQQCAFtR2MoIvAK4Ed4c2TRY5PF8aXNrZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=q8mV/dQy; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="q8mV/dQy"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id B1F341A0F3A;
	Fri, 10 Jul 2026 09:33:20 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 8397860341;
	Fri, 10 Jul 2026 09:33:20 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6785F11BD280C;
	Fri, 10 Jul 2026 11:33:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1783675999; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=PdzuN4WWG8ww2PkB8OywBoYS6cV9TEq80igjFkOCi/E=;
	b=q8mV/dQyQsB2f4rYUwBqW3OZLRasJRAZbKA3DU+PyPTl31vCsxi+uQtCG2pbCJGi5Wx/zz
	RgU0cRWpd2k0SPbMFGJwnAhZAwtJYZZ9E1s/RdzaCJUhjbS1xR6Tkv/7U8ZZ/kia6h18AC
	J/h6yzyJdM8QsdGfsN8lrk0mFvFTHTLDkAFkuSiU75sqGVZdKpJD5k9y+meBwBvFzRl5u1
	IE7+z4uRTXMqy/vfwpwuFx7Iwd4KfgAMG0oqKRKU60xA6BrH3vORoo4pIS2irNWU2sKSIn
	0sZZcjaiDevXL9spIHjAH7Vb4Wd7i+0GVphUqHZw6HFVsaYgXQm0+J9eOpB5rw==
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Antoine Tenart <atenart@kernel.org>,  Christian Marangi
 <ansuelsmth@gmail.com>,  Conor Dooley <conor+dt@kernel.org>,  David S.
 Miller <davem@davemloft.net>,  Geert Uytterhoeven
 <geert+renesas@glider.be>,  Herbert Xu <herbert@gondor.apana.org.au>,
  Jayesh Choudhary <j-choudhary@ti.com>,  Krzysztof Kozlowski
 <krzk+dt@kernel.org>,  Magnus Damm <magnus.damm@gmail.com>,  Michael
 Turquette <mturquette@baylibre.com>,  Olivia Mackall <olivia@selenic.com>,
  Rob Herring <robh@kernel.org>,  Thomas Gleixner <tglx@kernel.org>,
  Thomas Petazzoni <thomas.petazzoni@bootlin.com>,  Pascal EBERHARD
 <pascal.eberhard@se.com>,  Wolfram Sang
 <wsa+renesas@sang-engineering.com>,  linux-clk@vger.kernel.org,
  devicetree@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-crypto@vger.kernel.org,  linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 01/16] dt-bindings: clock: Introduce nexus nodes
In-Reply-To: <177595659711.5403.18166114937625609985@lazor> (Stephen Boyd's
	message of "Sat, 11 Apr 2026 18:16:37 -0700")
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
	<20260327-schneider-v7-0-rc1-crypto-v1-1-5e6ff7853994@bootlin.com>
	<177595659711.5403.18166114937625609985@lazor>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Fri, 10 Jul 2026 11:33:11 +0200
Message-ID: <87a4rzi3zc.fsf@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

Hi Stephen,

>> +title: Clock Nexus
>> +
>> +description: >
>> +  A nexus node allows to remap a phandle list in a consumer node throug=
h a
>
> Should this say "remap a clock specifier list" instead of "remap a
> phandle list"? A phandle list sounds like there are zero cells.

That's right, thanks for the suggestion!

Thanks,
Miqu=C3=A8l
