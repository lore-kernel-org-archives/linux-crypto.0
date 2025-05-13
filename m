Received: from relay.smtp-ext.broadcom.com (relay.smtp-ext.broadcom.com [192.19.166.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027191EB19F;
	Tue, 13 May 2025 08:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.19.166.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747126677; cv=none; b=i1wYdbXUF0TkrKETePDQoFpDaDRChIKw7kVXFxi2XP+NFp7NiqYjba/t6JsQviHzTJE+J66LlbnK5Q4S5ypBhm43k4T//0Ia7oiUgHCY17A9KZeNhru2tkkvwIf2tlKEQWbXpN/WVGINnMuqKZxXACyytvarCYMNfiC5ykkbkjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747126677; c=relaxed/simple;
	bh=b+k8lkSLd+Vrlvdq5cfbxfQlOn+tLWVGB9Bap/aqSGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRH+zyGJm7sxq1YFtQPaX6uG0uvQfi1CX249afIHKCREvtGL3ykqu65nxXsN1ezvtXkEPxRE6M9mDBa0ytJod+Y3Iwd8rLP75hs16usZYi5zWc9TmaanGWRYTN1RtQocxUTFgWWuM4TEuX+fWlp5SqG9V3t41AnT7c3LUqIFgiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=k941fE0O; arc=none smtp.client-ip=192.19.166.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="k941fE0O"
Received: from mail-lvn-it-01.broadcom.com (mail-lvn-it-01.lvn.broadcom.net [10.36.132.253])
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 2751BC0000F3;
	Tue, 13 May 2025 01:57:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 2751BC0000F3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
	s=dkimrelay; t=1747126675;
	bh=b+k8lkSLd+Vrlvdq5cfbxfQlOn+tLWVGB9Bap/aqSGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k941fE0OnzJFduPGzZaB0mZt1Q6cAlvrZW8GSF0QStSl+tlzHd1oR6MJK4jhxP7w2
	 PHMSjGbzLJAU6r73Euk4wURSbsw4SqYwHg/WOJlMfN9ix/yflNcpN3K3nVB8wSs9sb
	 PFxwRQDUbE/u8KFfoO/JixibFelySHnL4iHoUuUo=
Received: from fainelli-desktop.igp.broadcom.net (fainelli-desktop.dhcp.broadcom.net [10.67.48.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-lvn-it-01.broadcom.com (Postfix) with ESMTPSA id E235C18000530;
	Tue, 13 May 2025 01:57:54 -0700 (PDT)
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
Subject: Re: [PATCH v3 09/12] ARM64: dts: bcm4908: Add BCMBCA peripherals
Date: Tue, 13 May 2025 01:57:54 -0700
Message-ID: <20250513085754.2043945-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250512-bcmbca-peripherals-arm-v3-9-86f97ab4326f@linaro.org>
References: <20250512-bcmbca-peripherals-arm-v3-0-86f97ab4326f@linaro.org> <20250512-bcmbca-peripherals-arm-v3-9-86f97ab4326f@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

On Mon, 12 May 2025 14:05:55 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> All the BCMBCA SoCs share a set of peripherals at 0xff800000,
> albeit at slightly varying memory locations on the bus and
> with varying IRQ assignments. ARM64 SoCs have additional
> peripherals at 0xff858000, we extend the peripheral bus
> range to 0x400000 to cover this area.
> 
> Add the watchdog, remaining GPIO blocks, RNG, and DMA blocks
> for the BCM4908 based on the vendor files 4908_map_part.h
> and 4908_intr.h from the "bcmopen-consumer" code drop.
> 
> This SoC has up to 320 possible GPIOs due to having 10
> registers with 32 GPIOs in each available.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Applied to https://github.com/Broadcom/stblinux/commits/devicetree-arm64/next, thanks!
--
Florian
