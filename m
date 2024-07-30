Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC37C19EECC;
	Tue, 30 Jul 2024 10:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.11.138.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722335834; cv=none; b=A26V2Fb31PihcgwEU8cILLcHJeqxuDljJeLyf7y+Y8e/RBDfdWNRXiPvvQ5VQOdSIBAnrj9y4jXyDGAWBkKoCLVc2e6GrbRlIfnayWKNkh2JpV6QqGjBPEJAKXxr8lYroHrpxzBNjMQa6YN63+DRjLazrK1Zk7qmv1oc0QM6vIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722335834; c=relaxed/simple;
	bh=0SgQaEY8DZuj3TmOOql7MlYsQeToAOZWAyjpozBErJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qeh/uImY1PHn8IDSVoRIQ136TE5jjTiJkbS5bnHH0oL75fyD1ve58d8kR8s3GfUpXfNyUKFeocDIOfsTprnram/t0Z+TFW8VFRmclilhNStmDCUrUzxhWYCePKP/ttbYZao8tey9y4Y4zZx8feEyrZZe62uylEWNuGrQv4Tu2GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de; spf=pass smtp.mailfrom=sntech.de; arc=none smtp.client-ip=185.11.138.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sntech.de
Received: from i5e86192c.versanet.de ([94.134.25.44] helo=diego.localnet)
	by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <heiko@sntech.de>)
	id 1sYkDk-0007C3-Qa; Tue, 30 Jul 2024 12:36:44 +0200
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Dragan Simic <dsimic@manjaro.org>, Daniel Golle <daniel@makrotopia.org>,
 Diederik de Haas <didi.debian@cknow.org>
Cc: Chen-Yu Tsai <wens@kernel.org>, linux-rockchip@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, Martin Kaiser <martin@kaiser.cx>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <ukleinek@debian.org>,
 devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
 Philipp Zabel <p.zabel@pengutronix.de>, Olivia Mackall <olivia@selenic.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
Date: Tue, 30 Jul 2024 12:36:43 +0200
Message-ID: <17577153.5WZRyvrzyv@diego>
In-Reply-To: <6690040.iosknibmi9@bagend>
References:
 <cover.1720969799.git.daniel@makrotopia.org>
 <ZqgjTQMgWZO2FjaC@makrotopia.org> <6690040.iosknibmi9@bagend>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Dienstag, 30. Juli 2024, 11:03:06 CEST schrieb Diederik de Haas:
> On Tuesday, 30 July 2024 01:18:37 CEST Daniel Golle wrote:
> > On Wed, Jul 24, 2024 at 08:07:51AM +0200, Dragan Simic wrote:
> > > Thanks a lot for the testing.  Though, such wildly different test results
> > > can, regrettably, lead to only one conclusion:  the HWRNG found in RK3566
> > > is unusable. :/
> 
> FTR: I agree with Dragan, unfortunately.
> 
> > The results on RK3568 look much better and the series right now also
> > only enabled the RNG on RK3568 systems. However, we have only seen few
> > boards with RK3568 up to now, and I only got a couple of NanoPi R5C
> > here to test, all with good hwrng results.
> > 
> > Do you think it would be agreeable to only enable the HWRNG for RK3568
> > as suggested in this series? Or are we expecting quality to also vary
> > as much as it (sadly) does for RK3566?
> 
> Unless we get *evidence* to the contrary, we should assume that the HWRNG on 
> RK3568 is fine as the currently available test results are fine.
> So I think enabling it only for RK3568 is the right thing to do.
> 
> So a 'revert' to v7 variant seems appropriate, but with the following changes:
> - Add `status = "disabled";` property to the definition in rk356x.dtsi
> - Add a new commit where you enable it only for rk3568 and document in the 
> commit message why it's not enabled on rk3566 with a possible link to the v7 
> thread for clarification on why that is

I was going to protest about the "disable" until reading the 2nd part :-D .

And yeah that makes a lot of sense, "add" it to rk356x.dtsi, as the IP is
part of both variants, but only enable it in rk3568.dtsi because of the
seemingly faulty implementation on the rk3566.


> You could probably also integrate that into 1 commit, but make sure that the 
> commit summary and description match the implementation.
> IMO that wasn't 'technically' the case in v8 as the rng node was added to 
> rk356x, but it was only enabled on rk3568.
> 
> My 0.02




