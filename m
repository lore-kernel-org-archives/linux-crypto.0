Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D232E13C9A3;
	Thu,  1 Aug 2024 16:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722531362; cv=none; b=henDQCz/pTlFsEGl3oa+wGNWoxljdmjvq0G1/6PvBex79Z5Ypr6YGdDZzbrXqLUuNTmJDBRAcx2bZmSTLZO6Ojard5ELqk9PA5d2ey4rJ7z110oPWT0dty/hmIBBAq1LNcWcbHBAEDqa8Un3rep7Z2G6tBDx7e2t07AZDG+pqTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722531362; c=relaxed/simple;
	bh=o+Ce2RCnjSSb9G7HSFHCouBxB5GNfboMUGANrgqAglo=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=S29sVZ6vqVgH0APXQ7eK2IZ4N/tLBIeMDM48hCDO+Kq9XdbGKET5zRpsKEuKoFutibuWtYB2dog/BjRAY9D0Es6cLsT6/Q6xbaPwaqIcCPwaF7IFKdWZ7xBOFE4kNR4A5RhN8UWw7EMP//xSk2PlB+njuFDFqc/2y8euea2z8Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=MnoBjUS/; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="MnoBjUS/"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1722530920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jPClc5OP0a9QUvjXpGJsJVrUxn5Ch1JktZFLY54Dr9g=;
	b=MnoBjUS/QslsJRcK0L/SKKwNPnUDn+etkJgm3yZhSmSJMnu5iLcaHVTPuw/0rj3ijsy4sN
	CEkYEIu7JeLHrs6Ygj6NpVDhWGDBbG9PCooB8i8evHCZ870AEFnTeeBOwuKSapGnOKAGG1
	DgNRROAjkM+gzXKutfi+A8uAEDf53QgexbZN9qQgx0A0OP5IDBH3swT0U9Pf6xPEkR7Fpv
	okdNO/othF6Sh1DHxb8seSjY0gPATf/DnxOnaUcnG5STKZsvbIE6yMLdmf+IK0Git1qAgp
	g6eu74Bk/GL0o77yBvY8xPn6qPBTgl2Pf0mCGWjb9XZ3m5xnIr8ncFceFh85cQ==
Date: Thu, 01 Aug 2024 18:48:36 +0200
From: Dragan Simic <dsimic@manjaro.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Diederik de Haas <didi.debian@cknow.org>, Chen-Yu Tsai
 <wens@kernel.org>, linux-rockchip@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>, Conor
 Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org, Herbert Xu
 <herbert@gondor.apana.org.au>, Martin Kaiser <martin@kaiser.cx>, Sascha
 Hauer <s.hauer@pengutronix.de>, Sebastian Reichel
 <sebastian.reichel@collabora.com>, Ard Biesheuvel <ardb@kernel.org>,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
 devicetree@vger.kernel.org, linux-crypto@vger.kernel.org, Philipp Zabel
 <p.zabel@pengutronix.de>, Olivia Mackall <olivia@selenic.com>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Aurelien Jarno <aurelien@aurel32.net>, Heiko
 Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
In-Reply-To: <ZqgjTQMgWZO2FjaC@makrotopia.org>
References: <cover.1720969799.git.daniel@makrotopia.org>
 <3190961.CRkYR5qTbq@bagend>
 <CAGb2v64Dx7XaJOu0HHzFxYYY2ddUZao5Tar8-s1R_miVZqWcXA@mail.gmail.com>
 <4406786.zLnsZ2vfAB@bagend> <faa0baebabd3c31adf1afa7efbbdf608@manjaro.org>
 <ZqgjTQMgWZO2FjaC@makrotopia.org>
Message-ID: <97dfca058858d7a5d933ddf7a84dba61@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Daniel,

On 2024-07-30 01:18, Daniel Golle wrote:
> On Wed, Jul 24, 2024 at 08:07:51AM +0200, Dragan Simic wrote:
>> Thanks a lot for the testing.  Though, such wildly different test 
>> results
>> can, regrettably, lead to only one conclusion:  the HWRNG found in 
>> RK3566
>> is unusable. :/
> 
> The results on RK3568 look much better and the series right now also
> only enabled the RNG on RK3568 systems. However, we have only seen few
> boards with RK3568 up to now, and I only got a couple of NanoPi R5C
> here to test, all with good hwrng results.
> 
> Do you think it would be agreeable to only enable the HWRNG for RK3568
> as suggested in this series? Or are we expecting quality to also vary
> as much as it (sadly) does for RK3566?

I'm a bit late to the party, sorry for that.  The test results so far
show that the HWRNG in RK3566 simply cannot be relied upon, but the test
results also show that the RK3568's HWRNG seems fine.  I'm wondering 
why,
but until we bump into a sample of RK3568 whose HWRNG performs badly,
I'd say that enabling the HWRNG on RK3568 only is safe.

Of course, as other people already noted, the HWRNG should be defined in
rk356x.dtsi, because it does exist in both SoC variants, but should be
enabled in rk3568.dtsi only.  As already noted, describing it as broken
on RK3566 in rk356x.dtsi should also be good.
