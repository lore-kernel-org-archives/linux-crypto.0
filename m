Received: from relay.smtp-ext.broadcom.com (relay.smtp-ext.broadcom.com [192.19.144.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303021F152D;
	Tue, 13 May 2025 09:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.19.144.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747126881; cv=none; b=lCwXBC85TLrYv0QyPOqar5WfLhOETDWQzdYpg3kqNDg33S2lMxPuikd94WcosSQf3W8GkuzF99wpmTO7BZWBwSfQtEsH0lijOHpohiOYFfniGz5L0lnDyr67r32BxKWr13O+tnBR+M7nEf6S1D4r+tgLV+xErRKrrE9U+z8gCLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747126881; c=relaxed/simple;
	bh=6JaYxfdAQJiPRQ8zXP1h2w7gcM977OHUbEVJN7BCbr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hi5zkaETBnZQFPzX0ZH7p5GP8/AyOLCZQ5Eb4ZIJlhN6Xf9lUfgpWIdZm/81e0EDZ7EfmjSGtk10Av01FfIpexrwLC/j3BcZk0Ock9DwPGFyqNzRDTboQtBpXpQEf5ol+RdzQ16tCQ5O+ByLgUwRQkMbO3GZvpNhr16qKAzzbBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Ulz46r/t; arc=none smtp.client-ip=192.19.144.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ulz46r/t"
Received: from mail-lvn-it-01.broadcom.com (mail-lvn-it-01.lvn.broadcom.net [10.36.132.253])
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id B83A5C0003DE;
	Tue, 13 May 2025 01:52:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com B83A5C0003DE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
	s=dkimrelay; t=1747126349;
	bh=6JaYxfdAQJiPRQ8zXP1h2w7gcM977OHUbEVJN7BCbr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ulz46r/t0gAYZzJQVapdPbIhLe6hnr49XYFJfAzTH1GCNETAG5h1Dq5ytb1ymj+Q7
	 c4DFlOZwSRUdP9luneeZA0mF5cUvfOgjQHeduw9DAEH+A8ssitOnaQr6fGGgc9l1Zb
	 Rv/VKta2gS+7+8ir+tqJ4Fp4UYZCMT9Ft+DK9BOI=
Received: from fainelli-desktop.igp.broadcom.net (fainelli-desktop.dhcp.broadcom.net [10.67.48.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-lvn-it-01.broadcom.com (Postfix) with ESMTPSA id 4437118000530;
	Tue, 13 May 2025 01:52:29 -0700 (PDT)
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
Subject: Re: [PATCH v3 01/12] ARM: dts: bcm6878: Correct UART0 IRQ number
Date: Tue, 13 May 2025 01:52:28 -0700
Message-ID: <20250513085228.2043216-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250512-bcmbca-peripherals-arm-v3-1-86f97ab4326f@linaro.org>
References: <20250512-bcmbca-peripherals-arm-v3-0-86f97ab4326f@linaro.org> <20250512-bcmbca-peripherals-arm-v3-1-86f97ab4326f@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

On Mon, 12 May 2025 14:05:47 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> According to the vendor file 6878_intr.h the UART0 has IRQ
> 92, not 32.
> 
> Assuming this is a copy-and-paste error.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Applied to https://github.com/Broadcom/stblinux/commits/devicetree/next, thanks!
--
Florian
