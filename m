Received: from relay.smtp-ext.broadcom.com (relay.smtp-ext.broadcom.com [192.19.166.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CFC20E70E;
	Tue, 13 May 2025 08:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.19.166.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747126743; cv=none; b=WzJ5TC5j7c1N37QNWBmnN6lDUSkHbnLvHWm93LZqb873L7IbeD6ldhqqUahTp4tI6A8EqoP5/Ijf9dx5hzWH0PlbsFdseiM4Oifc9QWYsPfl2WT+BGNjIrDvYi7R9qDsAf7XFIZNj9NVvOXRkoe5tUek+yt1ka+EMgAZnOKUzvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747126743; c=relaxed/simple;
	bh=kSabfnn9ouHXIhZFBha+zShDVdQWFPN3jPDHqtPmpGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWia3YSUT1/lkARrUIcFGG/v6uuylqyy9HPG6cKw6OkwKrVahp2yx6iXuAUDvf42H2iEdaQXCpug8t5RxsBbKYHLpBHkLPQgQBXElBfVfBlcy7/mtwDxxysaNuIyVBtWLA7ORHtLGBI7pe8LbpeOvR4hMTf7YCNuR6G7+4Jqux4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=XMT2hNLq; arc=none smtp.client-ip=192.19.166.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="XMT2hNLq"
Received: from mail-lvn-it-01.broadcom.com (mail-lvn-it-01.lvn.broadcom.net [10.36.132.253])
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id B5419C0004CB;
	Tue, 13 May 2025 01:58:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com B5419C0004CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
	s=dkimrelay; t=1747126738;
	bh=kSabfnn9ouHXIhZFBha+zShDVdQWFPN3jPDHqtPmpGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMT2hNLqY0fTy8+m2KEUlVCxmB/RsrwoNmBuHwyCNBhQyjB08HGSIHEvOZruragYs
	 /ZMIxofOQiFVI/Ks7zl8lCZQgf9bp6k9cRx3OA0MPOgJPf6t1wFOp0BINOsufMvGU6
	 7tq6mTUskZEHTF6H7rsNVAQYbyPLGKpi2itUwxUI=
Received: from fainelli-desktop.igp.broadcom.net (fainelli-desktop.dhcp.broadcom.net [10.67.48.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-lvn-it-01.broadcom.com (Postfix) with ESMTPSA id 862E618000530;
	Tue, 13 May 2025 01:58:58 -0700 (PDT)
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
Subject: Re: [PATCH v3 12/12] ARM64: dts: bcm63158: Add BCMBCA peripherals
Date: Tue, 13 May 2025 01:58:58 -0700
Message-ID: <20250513085858.2044199-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250512-bcmbca-peripherals-arm-v3-12-86f97ab4326f@linaro.org>
References: <20250512-bcmbca-peripherals-arm-v3-0-86f97ab4326f@linaro.org> <20250512-bcmbca-peripherals-arm-v3-12-86f97ab4326f@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

On Mon, 12 May 2025 14:05:58 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> All the BCMBCA SoCs share a set of peripherals at 0xff800000,
> albeit at slightly varying memory locations on the bus and
> with varying IRQ assignments.
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
> at 0xff810000 where the DMA resides, the peripheral range
> window fits these two peripheral groups.
> 
> This SoC has up to 256 possible GPIOs due to having 8
> registers with 32 GPIOs in each available.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Applied to https://github.com/Broadcom/stblinux/commits/devicetree-arm64/next, thanks!
--
Florian
