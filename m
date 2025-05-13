Received: from relay.smtp-ext.broadcom.com (relay.smtp-ext.broadcom.com [192.19.166.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979FC1F5435;
	Tue, 13 May 2025 09:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.19.166.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747126998; cv=none; b=gIBw2lKV0lfEE/mKytd2PE3wYMOWWWHc/19tpqOvkh65U/x+KFJSK+bvBJ0uSz0uQEi6a88UIbrf8m5QRaPNR3PuE4ldEgnGcdEqwHxxALhrn6XC4cZnQ312D8r8HL/w+hOQXhPoFkj4jHR9eHuRIx0F9BlqO8CGBbdg+JiLyp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747126998; c=relaxed/simple;
	bh=1PIMUnhPT/x/cOjklIjbG6p0kHEOPlvlg9KhHn9J+dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOmcU3F8J2X7jgy8aVeXPPdjT79elJh7Xmp8kcVvrAV68qlKp0sZxDLoyg7yorLw7KCAuX2UAxdYPuK1wWo01tcrie5viCgCVrOhwUa0sIHuIz5KX250o4dyJY/1pwvOfppk/rtecHWyNWyi7l/16IcczUatf5lQSKPNhtNFP7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gB+zzZ6W; arc=none smtp.client-ip=192.19.166.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gB+zzZ6W"
Received: from mail-lvn-it-01.broadcom.com (mail-lvn-it-01.lvn.broadcom.net [10.36.132.253])
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id EEC29C0004C9;
	Tue, 13 May 2025 01:56:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com EEC29C0004C9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
	s=dkimrelay; t=1747126597;
	bh=1PIMUnhPT/x/cOjklIjbG6p0kHEOPlvlg9KhHn9J+dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gB+zzZ6WwEQ4ve2jWEgKNkJij/nN4FItYGABEEcL2LF3kZfNzU5V3zhKAoiPuyl8F
	 0qBAIjD8fDF98Z9vp7tVw/SXniwu+ttINt6mIthUAkDnkmhuTqWooA+SkrvHXJsks5
	 gfbDjAcyKqr8QHI7ousaQekcbrDtoi7LiiR23bhs=
Received: from fainelli-desktop.igp.broadcom.net (fainelli-desktop.dhcp.broadcom.net [10.67.48.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-lvn-it-01.broadcom.com (Postfix) with ESMTPSA id ABEA918000A4A;
	Tue, 13 May 2025 01:56:06 -0700 (PDT)
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
Subject: Re: [PATCH v3 07/12] ARM: dts: bcm63148: Add BCMBCA peripherals
Date: Tue, 13 May 2025 01:56:06 -0700
Message-ID: <20250513085606.2043730-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250512-bcmbca-peripherals-arm-v3-7-86f97ab4326f@linaro.org>
References: <20250512-bcmbca-peripherals-arm-v3-0-86f97ab4326f@linaro.org> <20250512-bcmbca-peripherals-arm-v3-7-86f97ab4326f@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

On Mon, 12 May 2025 14:05:53 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> All the BCMBCA SoCs share a set of peripherals at 0xff800000,
> albeit at slightly varying memory locations on the bus and
> with varying IRQ assignments.
> 
> Add the GPIO, RNG and LED and DMA blocks for the
> BCM63148 based on the vendor files 63148_map_part.h and
> 63148_intr.h from the "bcmopen-consumer" code drop.
> 
> This SoC has up to 160 possible GPIOs due to having 5
> registers with 32 GPIOs in each available.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Applied to https://github.com/Broadcom/stblinux/commits/devicetree/next, thanks!
--
Florian
