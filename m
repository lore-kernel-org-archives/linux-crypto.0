Received: from relay.smtp-ext.broadcom.com (relay.smtp-ext.broadcom.com [192.19.166.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5A12BEC48;
	Fri, 11 Apr 2025 23:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.19.166.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744415024; cv=none; b=vFDEI0mJBkbovupa+a3O7n9EYq7ycIcGP4StbT6fZ3hRzP9W548iIFQCuzMj8Od5AReJI+7GqHwxjXT4ZKQhWO/1q5DDSmJPSkPeKx3y5eWJQ/9aRnSoAjpK9wrfISDYN6NDPDgJWcYMc+qEE+jI2PCtHIBRfSwrw0ts0xKjB+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744415024; c=relaxed/simple;
	bh=DzedMiQG3AVGSKDf3skGJdk6le90+TdtXlLYWQkUTdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A842+LoGaOAfJxqPgW/2Dznvn0w5acfFYRcrG+YLGFunJE61wFiZAiRQPbuY69GJECceegB7rv7k+fPz8Mmg/svrMgufQ21RYrwzJhnQ8OuUisSBeyyAQlKlLLz2tc/6LRxKN1ew8YBxqqaavIo3lMRwGiLmDv63ItQdSDuJE1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Eh8SaD6b; arc=none smtp.client-ip=192.19.166.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Eh8SaD6b"
Received: from mail-lvn-it-01.broadcom.com (mail-lvn-it-01.lvn.broadcom.net [10.36.132.253])
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 7848CC00035C;
	Fri, 11 Apr 2025 16:43:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 7848CC00035C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
	s=dkimrelay; t=1744415022;
	bh=DzedMiQG3AVGSKDf3skGJdk6le90+TdtXlLYWQkUTdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eh8SaD6bZlTSo3mbyKoWzXc3+6GygADghR41sy7/4EutbXS4eoH7IZVPy4iufGFTb
	 SbHJbNjOZ/Mx871wyI39tHCx5HbIdruqeWiFAWQza9x63DzLFvuhaToslrkH5m5kKU
	 9YYguey/utDp/YSIZW5xBMMpN0YFlIggHjtH76v0=
Received: from fainelli-desktop.igp.broadcom.net (fainelli-desktop.dhcp.broadcom.net [10.67.48.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-lvn-it-01.broadcom.com (Postfix) with ESMTPSA id 48835180004FC;
	Fri, 11 Apr 2025 16:43:42 -0700 (PDT)
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
Subject: Re: [PATCH v2 11/12] ARM64: dts: bcm6858: Add BCMBCA peripherals
Date: Fri, 11 Apr 2025 16:43:41 -0700
Message-ID: <20250411234341.1023279-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250406-bcmbca-peripherals-arm-v2-11-22130836c2ed@linaro.org>
References: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org> <20250406-bcmbca-peripherals-arm-v2-11-22130836c2ed@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

On Sun, 06 Apr 2025 17:32:51 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> All the BCMBCA SoCs share a set of peripherals at 0xff800000,
> albeit at slightly varying memory locations on the bus and
> with varying IRQ assignments. ARM64 SoCs have additional
> peripherals at 0xff858000. On BCM6858 the PERF window was
> too big so adjust it down to its real size (0x3000).
> 
> Add the watchdog, GPIO blocks, RNG, LED, second UART and DMA
> blocks for the BCM6858 based on the vendor files 6858_map_part.h
> and 6858_intr.h from the "bcmopen-consumer" code drop.
> 
> Curiously, on the BCM6858, the PL081 DMA block is separate
> from the two peripheral groups PERF and PERF1, so we put it
> in its own bus in the device tree to translate the fourcell
> addresses.
> 
> This SoC has up to 256 possible GPIOs due to having 8
> registers with 32 GPIOs in each available.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Applied to https://github.com/Broadcom/stblinux/commits/devicetree-arm64/next, thanks!
--
Florian
