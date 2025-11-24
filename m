Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A30B2E8E10;
	Mon, 24 Nov 2025 13:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763989457; cv=none; b=i6IqMy0BTtx+SBNX2Jwt5mgdekBSkCv1SuTlH/psWolw4+RvBt5gh09HNfVehaelKfMns9NEyrp1gMvj+u/cPAt5UPQZf8ooUumZ9o9+agH3fBWn5GLoBy/lyUctAEwDhf2dArD97MD4etOPIumTE1cb6MTqH4n8s6HtpDzSfgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763989457; c=relaxed/simple;
	bh=0UAP833jY/lb8txc7zCx1KB4AkZTvgzHkZy42y98Tew=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=lZlOLW8yHawdsaSkN7IUs6bTocU/GJ1TXr7ySUdA0K8d461gEEkFDYPID4qU0WXqGf+rE5F5nof7b226VLcm6gGfawec2lQsi4kbgmjvOcHIsEhFG9Gi/MuEDnI0OT25BnrOe7IMAclXqxCYQ8iAeHBod/IgPjVU0Iw1muIrS54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org; spf=pass smtp.mailfrom=yoseli.org; dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b=Zt4h9Xnc; arc=none smtp.client-ip=217.70.183.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yoseli.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b="Zt4h9Xnc"
Received: by mail.gandi.net (Postfix) with ESMTPSA id 3CCD644287;
	Mon, 24 Nov 2025 13:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yoseli.org; s=gm1;
	t=1763989453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Iz84JXpr1Wzt9qHfLXBjH0UwcZH1zgAuKf5TwypISLI=;
	b=Zt4h9Xnc+VgkZ+ClQYTR6tf/8V365T0zZK/TVtsBVREhskVhXLeb0YvbgwGMnDNIN8eBZe
	BoJRnoA76OHe92Pcw3tDIb5VVY6nOn8qCGWRLVqaTD9cpzEQWri1H52H7tTqvgTM5sqwwl
	ji+nvZrUT9Z7QFL2vcLl1Q4Zq5oW3f9md+wm+RpJuYvhtjxkXhHy6LFrXmGrrCnYsQ4BCp
	OiQ4p35od93O0+9a4d8vL4xSgYhnwaEiZOYMGgg6muUNa7TtaUTLxo0lSuyepjQZ4oRTam
	SRBLcFXb+TCen7HjJ5xkAroshnwFlEXrsur1UNEpRE3E8hSkEPitE6M6iPK0AQ==
From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Subject: [PATCH v3 0/3] m68k: coldfire: Add RNG support and const
 qualifiers for MCF54418
Date: Mon, 24 Nov 2025 14:04:05 +0100
Message-Id: <20251124-b4-m5441x-add-rng-support-v3-0-f447251dad27@yoseli.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMVXJGkC/42NQQ6CMBBFr0Jm7Zi2FAVX3sOwaG2BSZQ2UyQQw
 t2tnMDle8l/f4PkmXyCW7EB+5kShTFDeSrgOZix90guMyihKinFFa3Gd6W1XNA4hzz2mD4xBp5
 QdM7WTgslhYG8j+w7Wo72o808UJoCr8fVrH72n+qsUGDXSHepq7pUtrmvIfkXnQP30O77/gW44
 mqfwwAAAA==
X-Change-ID: 20251107-b4-m5441x-add-rng-support-0fdb8d40210a
To: Greg Ungerer <gerg@linux-m68k.org>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Shawn Guo <shawnguo@kernel.org>, 
 Sascha Hauer <s.hauer@pengutronix.de>, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 Fabio Estevam <festevam@gmail.com>
Cc: linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, 
 Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763989450; l=2074;
 i=jeanmichel.hautbois@yoseli.org; s=20240925; h=from:subject:message-id;
 bh=0UAP833jY/lb8txc7zCx1KB4AkZTvgzHkZy42y98Tew=;
 b=IOWyT2SHmlZDdAReG6ykhqIOoK01euZHGQiy2C+rgvsv+tKNJH6if5FdUVJ+ZQ/8I0educP0Z
 8XDIw3GfNVzBvtAUKienQlIP7lEmgPrEZdRBNx8mGNJ7S3xfEngGXJU
X-Developer-Key: i=jeanmichel.hautbois@yoseli.org; a=ed25519;
 pk=MsMTVmoV69wLIlSkHlFoACIMVNQFyvJzvsJSQsn/kq4=
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfeekieejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhufffkfggtgfgvfevofesthejredtredtjeenucfhrhhomheplfgvrghnqdfoihgthhgvlhcujfgruhhtsghoihhsuceojhgvrghnmhhitghhvghlrdhhrghuthgsohhisheshihoshgvlhhirdhorhhgqeenucggtffrrghtthgvrhhnpeekkeevfeelffehgedvuefhieektdellefhffeuueffkefhueetudetkeevffegudenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedvrgdtudemvgdtrgemudeileemjedugedtmeekkegsfeemheduheefmegtvdeigeemgehfsgenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedvrgdtudemvgdtrgemudeileemjedugedtmeekkegsfeemheduheefmegtvdeigeemgehfsgdphhgvlhhopeihohhsvghlihdqhihotghtohdrhihoshgvlhhirdhorhhgpdhmrghilhhfrhhomhepjhgvrghnmhhitghhvghlrdhhrghuthgsohhisheshihoshgvlhhirdhorhhgpdhnsggprhgtphhtthhopeduhedprhgtphhtthhopehjvggrnhhmihgthhgvlhdrhhgruhhtsghoihhsseihohhsvghlihdrohhrghdprhgtphhtthhopehlihhnuhigqdgrrhhmq
 dhkvghrnhgvlheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehgvggvrhhtsehlihhnuhigqdhmieekkhdrohhrghdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtohepfhgvshhtvghvrghmsehgmhgrihhlrdgtohhmpdhrtghpthhtohepshhhrgifnhhguhhosehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsrdhhrghuvghrsehpvghnghhuthhrohhnihigrdguvgdprhgtphhtthhopehimhigsehlihhsthhsrdhlihhnuhigrdguvghv
X-GND-Sasl: jeanmichel.hautbois@yoseli.org

This series adds support for the MCF54418 hardware random number generator
(RNGB) and improves type safety for platform device resources.

The MCF54418 contains an RNGB hardware block compatible with the imx-rngc
driver. This series enables its use by:
- Adding platform device registration for the RNG hardware
- Enabling the clock at platform initialization
- Making the imx-rngc driver compatible with Coldfire's always-on clock
model using devm_clk_get_optional()

Additionally, following Frank Li's suggestion, all static resource array
in arch/m68k/coldfire/device.c are marked const, moving them to read-only
memory and aligning with kernel API expectations.

Testing on DLC Next board shows:
- Hardware RNG throughput: 26 MB/s
- FIPS 140-2 quality: 0.2% failure rate (rng-tools)
- Boot time improvement: CRNG initialization 7 seconds faster

Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
---
Changes in v3:
- Depend on COLDFIRE is enough
- Split the clock change in a dedicated commit
- Link to v2: https://lore.kernel.org/r/20251107-b4-m5441x-add-rng-support-v2-0-f91d685832b9@yoseli.org

Changes in v2:
- Split const qualifier changes into a separate patch as suggested by
Frank Li
- Mark all resource arrays (including RNG) as const in device.c
- No functional changes to RNG implementation

---
Jean-Michel Hautbois (3):
      m68k: coldfire: Mark platform device resource arrays as const
      hwrng: imx-rngc: Use optional clock
      m68k: coldfire: Add RNG support for MCF54418

 arch/m68k/coldfire/device.c       | 52 ++++++++++++++++++++++++++++++---------
 arch/m68k/coldfire/m5441x.c       |  2 +-
 arch/m68k/include/asm/m5441xsim.h |  9 +++++++
 drivers/char/hw_random/Kconfig    |  3 ++-
 drivers/char/hw_random/imx-rngc.c |  9 ++++++-
 5 files changed, 60 insertions(+), 15 deletions(-)
---
base-commit: ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d
change-id: 20251107-b4-m5441x-add-rng-support-0fdb8d40210a

Best regards,
-- 
Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>

