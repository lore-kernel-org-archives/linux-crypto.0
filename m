Received: from fhigh8-smtp.messagingengine.com (fhigh8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29612495CC;
	Sat, 22 Jun 2024 23:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719099480; cv=none; b=icf52upkDj1T+++SdvwJT3XEQEqsSCSULGR4AnC2FMvZwxApZO0sK8eahXGKWmL6vMBCGaT4vzvmjl7oib+/W6wqXtxgQmkg4RIdUCVplIioc2SLP0u39oQCwSkIxykJDkIiSCoquKwQndUiqvHO9+aRGlNPZmfQj7DIMGsVc2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719099480; c=relaxed/simple;
	bh=1OqJpHQ366I2P8KyTSVSP//3azJ6U2em0Ustkmco2kM=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=tmWId7yGT0WbPXgL6nu9aLFbq6G63XkHKZ/uZnX4Y7DD8EWG0h528Kj/pFXRryG0xEv3/9B0srTbcTNkC101E0Jo/0CX9eV4PlXL8QZVsb5WnlAr6wg1xdvUb97L31/CBOSjBhxnTKuHUj2PwBg2jaMrksfkSlxWzNvgHLBOVCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=testtoast.com; spf=pass smtp.mailfrom=testtoast.com; dkim=pass (2048-bit key) header.d=testtoast.com header.i=@testtoast.com header.b=otkW9YU/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cXy9C5mS; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=testtoast.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=testtoast.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=testtoast.com header.i=@testtoast.com header.b="otkW9YU/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cXy9C5mS"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 4628611400A7;
	Sat, 22 Jun 2024 19:37:57 -0400 (EDT)
Received: from imap47 ([10.202.2.97])
  by compute5.internal (MEProxy); Sat, 22 Jun 2024 19:37:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=testtoast.com;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1719099477; x=
	1719185877; bh=k5o5mQ9UnR2y4q+VUneHpWeUtJa3ONEuJTFdu0HoL3E=; b=o
	tkW9YU/psI5nX8jr+RGHteDFvodoKVI+PDfz27ncz0Bbo0YPpyslLyurd+6iwU+Y
	kWipgnKuunHFJWl5InwT4onoixjC1UOftpSO6q7tFN9eLHJ8vW4pnenPtUsGAO28
	7VpgNSaY/1hGOf59BujrlUsnMV320o1tNFfmQXLz8nQIHjyAMFXMOomecSHICgD0
	E4j0TQ5GtlUcILyqVbxzF2h1OK0FIgQJNxcASo8uKWQDIF9ObywEcNeYWm8mgq3v
	4c0J4OAzKqILku4NANA93YzhJ0JshTSiJssxRqrqaJhRMWktdvYHh+G3rm/SXnkA
	xVLfWEfaNP137xIyyN7gg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1719099477; x=1719185877; bh=k5o5mQ9UnR2y4q+VUneHpWeUtJa3
	ONEuJTFdu0HoL3E=; b=cXy9C5mSIlcy+/WsSqsjUFscEuhbyoG0/xgy8gfoj+UA
	IEvzqgpCBs7QJwSdMBcZwyFB8lOswvPELdGsoXiuNdhFKHQNqKViMT1SlqfIFcmB
	L19R6m7uMJvDAwsum6I6J+T647PsrPznmN3FMeQZLK/fgJVneH0fhEH0NQCb/NKO
	AkAh9Dlp/w+hfl/LAsMfZw9bwP7bFadVI/JaOZVNfz0BMMXE++f/GVz8QjUBtujz
	3uBZEuOo9lj9h/RA/R0hUy7mUtNd3sifPSC+vxZHlp/Rd9XQ/j67QVkdKPM1X6/K
	GtQz3nAiX5/UNysIrGN2eKbzx6A65aRn2LDEGIrT0w==
X-ME-Sender: <xms:U2B3Zm0HFak589UUx0r-pwY3rbPqk4P4Q_0lYiJwk4MoSc1UnYq_pw>
    <xme:U2B3ZpEzEok5CLfgarFrxR3IkJfdmslaXNYoZNp2p5uHlugfLMYPLBYyRYcJBSg8g
    yP3-IggAoMU7bqalA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrfeefjedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftfih
    rghnucghrghlkhhlihhnfdcuoehrhigrnhesthgvshhtthhorghsthdrtghomheqnecugg
    ftrfgrthhtvghrnhephedvveeigedujeeufeegffehhfffveduhfeijefgtdffteelgfet
    ueevieduieejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homheprhihrghnsehtvghsthhtohgrshhtrdgtohhm
X-ME-Proxy: <xmx:U2B3Zu6SIPZU4BR9rsKn0dJ5YH_t-xrioU2mJv8ZL2pO28gFV3ccZw>
    <xmx:U2B3Zn3PKyx1wazstsIM8EPbAZ7oS-twMQOD4JNbW-cnADYmGc-bYg>
    <xmx:U2B3ZpFqkRRHtvMdxzBVAOlDLEVwk_w7ZXYaOhLrAsLgb9cSKGXQ8w>
    <xmx:U2B3Zg9CO-QQlBzHqToOrj2FhmiQ2oXyWO2zDZSC-0oczJZKOeGGdw>
    <xmx:VWB3ZhGXkAw64lWpUHEcBl9gVArdxhMQMparEvMiZINDpo0SF_jEwkGC>
Feedback-ID: idc0145fc:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 6AD38A60078; Sat, 22 Jun 2024 19:37:55 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-522-ga39cca1d5-fm-20240610.002-ga39cca1d
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <2d88450a-9b4e-46f3-9ec5-136feb4e680c@app.fastmail.com>
In-Reply-To: <20240616220719.26641-1-andre.przywara@arm.com>
References: <20240616220719.26641-1-andre.przywara@arm.com>
Date: Sun, 23 Jun 2024 11:37:35 +1200
From: "Ryan Walklin" <ryan@testtoast.com>
To: "Andre Przywara" <andre.przywara@arm.com>,
 "Corentin Labbe" <clabbe.montjoie@gmail.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>, "Chen-Yu Tsai" <wens@csie.org>,
 "Jernej Skrabec" <jernej.skrabec@gmail.com>,
 "Samuel Holland" <samuel@sholland.org>, "Rob Herring" <robh@kernel.org>,
 "Krzysztof Kozlowski" <krzk+dt@kernel.org>,
 "Conor Dooley" <conor+dt@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-sunxi@lists.linux.dev, devicetree@vger.kernel.org
Subject: Re: [PATCH 0/4] crypto: sun8i-ce: add Allwinner H616 support
Content-Type: text/plain

On Mon, 17 Jun 2024, at 10:07 AM, Andre Przywara wrote:

Thanks Andre!

> Corentin's cryptotest passed for me, though I haven't checked how fast
> it is and if it really brings an advantage performance-wise, but maybe
> people find it useful to offload that from the CPU cores.

Running the rngtest gives the following output:

localhost:~# rngtest -c 10000 < /dev/random
rngtest 6.16
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 200000032
rngtest: FIPS 140-2 successes: 9991
rngtest: FIPS 140-2 failures: 9
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 2
rngtest: FIPS 140-2(2001-10-10) Runs: 2
rngtest: FIPS 140-2(2001-10-10) Long run: 5
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=144.496; avg=808.068; max=866.977)Mibits/s
rngtest: FIPS tests speed: (min=17.199; avg=60.937; max=62.949)Mibits/s
rngtest: Program run time: 3369060 microseconds

So looks like a nice performance boost. 

> One immediate advantage is the availability of the TRNG device, which
> helps to feed the kernel's entropy pool much faster - typically before
> we reach userland. Without the driver this sometimes takes minutes, and
> delays workloads that rely on the entropy pool.

CRNG bringup now also very fast:

[    1.114790] sun8i-ce 1904000.crypto: CryptoEngine Die ID 0
[    1.116253] random: crng init done

Tested-by: Ryan Walklin <ryan@testtoast.com>

Regards,

Ryan
