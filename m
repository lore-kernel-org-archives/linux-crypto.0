Received: from relay.smtp-ext.broadcom.com (relay.smtp-ext.broadcom.com [192.19.144.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987211EB19F;
	Tue, 13 May 2025 08:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.19.144.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747126716; cv=none; b=DCpZ5Ivx8Cx3ZtPlVMRqLAs8WxidA8WId5QWBgpgPubjxpYrkYkHSISx5MdEyMxwcQM96G3jYRJ2EnPTc+ul+ppp3Km2EbTZCp18ocTOUnX8H/tXU+jSq+bjPvMWqYt39bg7IaWI/CAOg17UBoHf55jlEEF2K0pJ/WJUA1e/u/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747126716; c=relaxed/simple;
	bh=uJ/Eo/HZCOs93L7AFacDxhydNK8rTPJMgLqqopN2lSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHG7Xdob7TB1Jc64pS3jFCloxiEEeXd0thw7NwYd4kHI6LgDbt55C9UrCuOgRaJbwX95yC95AsSuqa4Faq5ngpasWqc/E9aLbOp9Gz/LIYye/EnnOPvSgMoV0iVCJVpNeR4j6fhV2mfYsF/7Og6ESIJzcirOonu3DC0JKdWjUiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BETEHyLc; arc=none smtp.client-ip=192.19.144.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BETEHyLc"
Received: from mail-lvn-it-01.broadcom.com (mail-lvn-it-01.lvn.broadcom.net [10.36.132.253])
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 869A5C002111;
	Tue, 13 May 2025 01:58:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 869A5C002111
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
	s=dkimrelay; t=1747126713;
	bh=uJ/Eo/HZCOs93L7AFacDxhydNK8rTPJMgLqqopN2lSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BETEHyLctY4z7R0leZXw2dmh3GGwYkOaGUgGBosYAnDVTXg/6b08IkQfB3BZFW/35
	 rSAJu3j9wKP9M7JHIoLrBCcDOokfuLtuSieejfze+Mwk+kv9khr3MBEXI1VF0aRhfL
	 IUVBKiefJZNop87/iVDgnwTNyGy+Uafho6DrjY9k=
Received: from fainelli-desktop.igp.broadcom.net (fainelli-desktop.dhcp.broadcom.net [10.67.48.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-lvn-it-01.broadcom.com (Postfix) with ESMTPSA id 1563E18000530;
	Tue, 13 May 2025 01:58:33 -0700 (PDT)
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
Subject: Re: [PATCH v3 11/12] ARM64: dts: bcm6858: Add BCMBCA peripherals
Date: Tue, 13 May 2025 01:58:32 -0700
Message-ID: <20250513085832.2044114-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250512-bcmbca-peripherals-arm-v3-11-86f97ab4326f@linaro.org>
References: <20250512-bcmbca-peripherals-arm-v3-0-86f97ab4326f@linaro.org> <20250512-bcmbca-peripherals-arm-v3-11-86f97ab4326f@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

On Mon, 12 May 2025 14:05:57 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> All the BCMBCA SoCs share a set of peripherals at 0xff800000,
> albeit at slightly varying memory locations on the bus and
> with varying IRQ assignments. ARM64 SoCs have additional
> peripherals at 0xff858000. Extend the peripheral window range
> to 0x400000 and add the DMA controller at offset 0x59000.
> 
> Add the watchdog, GPIO blocks, RNG, LED, second UART and DMA
> blocks for the BCM6858 based on the vendor files 6858_map_part.h
> and 6858_intr.h from the "bcmopen-consumer" code drop.
> 
> This SoC has up to 256 possible GPIOs due to having 8
> registers with 32 GPIOs in each available.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Applied to https://github.com/Broadcom/stblinux/commits/devicetree-arm64/next, thanks!
--
Florian
