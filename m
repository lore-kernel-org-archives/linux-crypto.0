Received: from relay.smtp-ext.broadcom.com (relay.smtp-ext.broadcom.com [192.19.166.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7072A2BEC48;
	Fri, 11 Apr 2025 23:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.19.166.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744415059; cv=none; b=pkKCMoOOdP042zm4bYxiVTQAztb3ai6gjJEqssMs2cks7a2nYTZh9Cg9nK9WfLNn6luaEGvsyTafHa8MTBs9juwJcRc0zbpDfynoDoXb2h5i1fQP8iSnsBRHi/WXMIJnqYCcq5eEZlBeSdI8eoQ52Z2bEBxu/B+o5A1vu23QJxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744415059; c=relaxed/simple;
	bh=fEKOzKlvelgdVgB8dlcuUPM3nk96uyOOonGkap/UOq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmBjbVO1UGeRbU4fZusrzIhmKEUeiIxVshClqSD9+Smw3cEqHA/w+bGpVo+xKn9zZZqGDfLyJXUAJOzYTsOGl4V1kVbGVoYg0nm1gffAXJ2DGle1fFUj/BhvNveZ8X1pE6jZnto5nY0yEXrHXmduEL+fc0+is0pvngpSw7NWZms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=lX6+nAd4; arc=none smtp.client-ip=192.19.166.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="lX6+nAd4"
Received: from mail-lvn-it-01.broadcom.com (mail-lvn-it-01.lvn.broadcom.net [10.36.132.253])
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id B3280C0004E9;
	Fri, 11 Apr 2025 16:44:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com B3280C0004E9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
	s=dkimrelay; t=1744415056;
	bh=fEKOzKlvelgdVgB8dlcuUPM3nk96uyOOonGkap/UOq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lX6+nAd4pejMDMA7GYM46vJ5l7AgaTy/INmtG6LPpDwJ+qSw99OnYMCJYYIn6aDOY
	 NO7ucUnoOmdXKqtfr6jFZhp4ULjzsDV7AmhB0kEh6DPbVlSQJESArsdWGj0/gG0P+v
	 ju9A/jp2B1yLNkj7072QO7ladG6rQngNn6xEFoPU=
Received: from fainelli-desktop.igp.broadcom.net (fainelli-desktop.dhcp.broadcom.net [10.67.48.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-lvn-it-01.broadcom.com (Postfix) with ESMTPSA id 7DB48180004FC;
	Fri, 11 Apr 2025 16:43:46 -0700 (PDT)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: bcm-kernel-feedback-list@broadcom.com,
	Linus Walleij <linus.walleij@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	William Zhang <william.zhang@broadcom.com>,
	Anand Gore <anand.gore@broadcom.com>,
	Kursad Oney <kursad.oney@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?iso-8859-2?q?Rafa=B3_Mi=B3ecki?= <rafal@milecki.pl>,
	Olivia Mackall <olivia@selenic.com>,
	Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 12/12] ARM64: dts: bcm63158: Add BCMBCA peripherals
Date: Fri, 11 Apr 2025 16:43:46 -0700
Message-ID: <20250411234346.1023364-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250406-bcmbca-peripherals-arm-v2-12-22130836c2ed@linaro.org>
References: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org> <20250406-bcmbca-peripherals-arm-v2-12-22130836c2ed@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

On Sun, 06 Apr 2025 17:32:52 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> All the BCMBCA SoCs share a set of peripherals at 0xff800000,
> albeit at slightly varying memory locations on the bus and
> with varying IRQ assignments. On BCM63158 the PERF window was
> too big so adjust it down to its real size (0x3000).
> 
> Add the watchdog, GPIO blocks, RNG, LED, second UART and DMA
> blocks for the BCM63158 based on the vendor files 63158_map_part.h
> and 63158_intr.h from the "bcmopen-consumer" code drop.
> 
> The DTSI file has clearly been authored for the B0 revision of
> the SoC: there is an earlier A0 version, but this has
> the UARTs in the legacy PERF memory space, while the B0
> has opened a new peripheral window at 0xff812000 for the
> three UARTs. It also has a designated AHB peripheral area
> at 0xff810000 where the DMA resides, so we create new windows
> for these two peripheral group reflecting the internal
> structure of the B0 SoC.
> 
> This SoC has up to 256 possible GPIOs due to having 8
> registers with 32 GPIOs in each available.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Applied to https://github.com/Broadcom/stblinux/commits/devicetree-arm64/next, thanks!
--
Florian
