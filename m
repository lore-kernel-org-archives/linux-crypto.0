Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCFA3054E9;
	Fri,  7 Nov 2025 10:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762511392; cv=none; b=pofsC40zECBmq6jZaQrBowLstOPNwNpgLiol5JRdwp8JqUOJrRmYomLPQcaYFo48L790Nfwkxjz3FHCu7ibBH/7m3WBt2do/RDT3DUTYgf7oJhxshbylLjMNO8doolVbgD84jxf0ZaqZl4IzSp6aHhe4NNlFIJo0QpsaYEBVvT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762511392; c=relaxed/simple;
	bh=MUNYUXR+6Apmlduc5P0840WUQkROO+KLh9YaxqpeACI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=vBkEPy0NEJwRO93QSZtZcWNfRgp7APUkRS2Vl/ktv2LCC6PWKLcZEHE7U1y2q5vEbReNfO/mS40TcuKrwoaFRM4yD9P68S7TOARpZqpRzCnvdn849dzfwxKEBHzG9w2y29dG3SnLvn3qbdNGJsUrsExIwKYPzU2v8zpiYZ1Ne30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org; spf=pass smtp.mailfrom=yoseli.org; dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b=TmdEkJ75; arc=none smtp.client-ip=217.70.183.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yoseli.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b="TmdEkJ75"
Received: by mail.gandi.net (Postfix) with ESMTPSA id 603D6441E6;
	Fri,  7 Nov 2025 10:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yoseli.org; s=gm1;
	t=1762511388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=43yyG9LNy5Zyb96mTIsBza5rvvnkZsHU9mwls4Id0h8=;
	b=TmdEkJ75lNDvbZzF3RAYKGUmIJfu/FQKzzHTFCF46egr3grD0MHW8oAqSD0tmpdBu4RW9P
	gjLM9Q3PEP+LSqfSCvmAiS7ZU9NaBuIU6fZj5cGiOKBnXVr8O5wc2Ijnh51O55on+h3aIM
	pvVAWCivuHMlgnACT7jsgDPDZIOZ4FyGvi/OeMWFSSli2hr2obP5pC3uplYlzW2rtHgjx5
	IMYvQlUAinb2UCUYHeRlCoI2keUA7ctSmuGi5B3+VZvhyGjA6L5bUlX2eZi4vyLpsK4rtM
	ZIkjUc+uY58wfMZ/kK2N8XgJ3LXlThyEIspz8wYwyDy40hfvMCLgh/deqGHExQ==
From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Subject: [PATCH v2 0/2] m68k: coldfire: Add RNG support and const
 qualifiers for MCF54418
Date: Fri, 07 Nov 2025 11:29:42 +0100
Message-Id: <20251107-b4-m5441x-add-rng-support-v2-0-f91d685832b9@yoseli.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABbKDWkC/x3MQQqEMAxA0atI1gbSUnGYqwyzqCZqFlNLOoog3
 t3i8i3+P6GIqRR4NyeY7Fp0TRW+bWBcYpoFlavBk++cox6HgL8uBHdgZEZLM5Yt59X+SBMPLw7
 kHUWofTaZ9Hjen+913eC3QNJrAAAA
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762511384; l=1826;
 i=jeanmichel.hautbois@yoseli.org; s=20240925; h=from:subject:message-id;
 bh=MUNYUXR+6Apmlduc5P0840WUQkROO+KLh9YaxqpeACI=;
 b=eVGUWoVGiY2HGHRt1PEYYMxNqqX3aeQhPojZB5FNxte8LKv8HnWJFBlR1zIUSo5fr78aoXEG2
 273WE5cmvwQBKRezy3ONRUdo25kJxA+1nN7Ps6ANkITL/hGheH6GZF8
X-Developer-Key: i=jeanmichel.hautbois@yoseli.org; a=ed25519;
 pk=MsMTVmoV69wLIlSkHlFoACIMVNQFyvJzvsJSQsn/kq4=
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeelgeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhufffkfggtgfgvfevofesthejredtredtjeenucfhrhhomheplfgvrghnqdfoihgthhgvlhcujfgruhhtsghoihhsuceojhgvrghnmhhitghhvghlrdhhrghuthgsohhisheshihoshgvlhhirdhorhhgqeenucggtffrrghtthgvrhhnpeduteehgeeihfelleelkeetkeetvefhvddugeduvddvudegheelkeeltdfftdehjeenucfkphepvdgrtddumegvtdgrmeduieelmeejudegtdemkegtrgdtmedukegtjeemhegvfhgtmegtsghfvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedvrgdtudemvgdtrgemudeileemjedugedtmeektggrtdemudektgejmeehvghftgemtggsfhdvpdhhvghlohephihoshgvlhhiqdihohgtthhordihohhsvghlihdrohhrghdpmhgrihhlfhhrohhmpehjvggrnhhmihgthhgvlhdrhhgruhhtsghoihhsseihohhsvghlihdrohhrghdpnhgspghrtghpthhtohepudehpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvr
 hhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlsehpvghnghhuthhrohhnihigrdguvgdprhgtphhtthhopehgvggvrhhtsehlihhnuhigqdhmieekkhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjvggrnhhmihgthhgvlhdrhhgruhhtsghoihhsseihohhsvghlihdrohhrghdprhgtphhtthhopehfvghsthgvvhgrmhesghhmrghilhdrtghomhdprhgtphhtthhopehgvghrgheslhhinhhugidqmheikehkrdhorhhg
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

Changes since v1:
- Split const qualifier changes into a separate patch as suggested by
Frank Li
- Mark all resource arrays (including RNG) as const in device.c
- No functional changes to RNG implementation

Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
---
Jean-Michel Hautbois (2):
      m68k: coldfire: Mark platform device resource arrays as const
      m68k: coldfire: Add RNG support for MCF54418

 arch/m68k/coldfire/device.c       | 52 ++++++++++++++++++++++++++++++---------
 arch/m68k/coldfire/m5441x.c       |  2 +-
 arch/m68k/include/asm/m5441xsim.h |  9 +++++++
 drivers/char/hw_random/Kconfig    |  3 ++-
 drivers/char/hw_random/imx-rngc.c |  9 ++++++-
 5 files changed, 60 insertions(+), 15 deletions(-)
---
base-commit: 5e5629c7ce42cfa1da9c6aaaa6d7aff0d396c46e
change-id: 20251107-b4-m5441x-add-rng-support-0fdb8d40210a

Best regards,
-- 
Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>

