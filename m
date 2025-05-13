Received: from relay.smtp-ext.broadcom.com (relay.smtp-ext.broadcom.com [192.19.144.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706FD1F1511;
	Tue, 13 May 2025 08:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.19.144.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747126587; cv=none; b=jaaZOI4QfzjfX3YGOBZN+ZnGRaPKtxtLdQZJxQI3BjOggntUo91FatsnXdKMPAQB4M4a9fyBna9WvMEFoINctID4uRM6uqu4qXgIyUK31euXMLekZTainnJ/bfR5tJWi45Lr95US9dnnX4rDY5FpNhbhvxv888C8UaPocEH+sNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747126587; c=relaxed/simple;
	bh=T0ibg3U914tadzkdlJ83unkROgclGmyfF23V6v04o/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/fKbvnYsTwUtYmQBVA48MVtIQbcYnzz17MmgzBKgYUbZJYIovr8HGWpIndACz/c7YO12F67Fx/USIMX7qR90Ofak0dYbQx2Al0k0C15sM6H6dBZShJQVC0ADLkhL+w2vO8MQv5txXWKetrDTyaSUktKtIXYRahpt5lc2CktatE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=K+f2JiFk; arc=none smtp.client-ip=192.19.144.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="K+f2JiFk"
Received: from mail-lvn-it-01.broadcom.com (mail-lvn-it-01.lvn.broadcom.net [10.36.132.253])
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 3C684C001A13;
	Tue, 13 May 2025 01:56:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 3C684C001A13
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
	s=dkimrelay; t=1747126585;
	bh=T0ibg3U914tadzkdlJ83unkROgclGmyfF23V6v04o/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+f2JiFk5jFPGiwzDoLi+HMgrAis/qnCFHrqnEDuh3HBexuHpD+JWpyL57ng/lc7b
	 D0UJGxR7mnuXARZjkQdFjHCW54kh39Aqh5SAItACW2URDNEShr1rHUvSaxDorpykFw
	 mqFm+8GjplOUmvm2QQTBCPjQ6fn3Fbuf5Gl0MbZU=
Received: from fainelli-desktop.igp.broadcom.net (fainelli-desktop.dhcp.broadcom.net [10.67.48.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-lvn-it-01.broadcom.com (Postfix) with ESMTPSA id B898F180008FB;
	Tue, 13 May 2025 01:55:54 -0700 (PDT)
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
Subject: Re: [PATCH v3 06/12] ARM: dts: bcm63138: Add BCMBCA peripherals
Date: Tue, 13 May 2025 01:55:54 -0700
Message-ID: <20250513085554.2043646-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250512-bcmbca-peripherals-arm-v3-6-86f97ab4326f@linaro.org>
References: <20250512-bcmbca-peripherals-arm-v3-0-86f97ab4326f@linaro.org> <20250512-bcmbca-peripherals-arm-v3-6-86f97ab4326f@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

On Mon, 12 May 2025 14:05:52 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> All the BCMBCA SoCs share a set of peripherals at 0xff800000,
> albeit at slightly varying memory locations on the bus and
> with varying IRQ assignments.
> 
> Extend the peripheral interrupt window to 0x10000 as it need
> to fit the DMA block.
> 
> Add the GPIO, RNG and LED and DMA blocks for the
> BCM63138 based on the vendor files 63138_map_part.h and
> 63138_intr.h from the "bcmopen-consumer" code drop.
> 
> This SoC has up to 160 possible GPIOs due to having 5
> registers with 32 GPIOs in each available.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Applied to https://github.com/Broadcom/stblinux/commits/devicetree/next, thanks!
--
Florian
