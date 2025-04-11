Received: from relay.smtp-ext.broadcom.com (relay.smtp-ext.broadcom.com [192.19.144.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F5B1F9413;
	Fri, 11 Apr 2025 23:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.19.144.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744415356; cv=none; b=KnFUUMsXMlDEguoy9+uUYv/u65u9oufbZF85EZ8TTriZR2EO9KLCx5gn5+MaUEbHPQGrWk/K50grITFFxlgmeSO8D9GvvrsHuH1GhNIM4uNgH4LeE89PbY9tZJvkhRMo8tdwDiB1z/0c4UfKn1O4ON4YZEwubLtIpwu0GY/YCoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744415356; c=relaxed/simple;
	bh=EkyXE6kp7s08RsmhTG89JIe7wCX1seuLLb87FHwSC+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGO4gfmWs8/mZVcLg4p6HZiB+1Ewb2xKLap4o5z/3GHMuaWGGNNqw87sN7VBA90UxZhZeMCvSBOMQKb0eav+2mqSayKx0BkznOLpLBl7KRpmSBewjnp+gMaXSbJ9AjlhK5E3OG3ivTt9erGm95FFza3lYqoO27yASDm+7l/d7uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=iUO72L8+; arc=none smtp.client-ip=192.19.144.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="iUO72L8+"
Received: from mail-lvn-it-01.broadcom.com (mail-lvn-it-01.lvn.broadcom.net [10.36.132.253])
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id B550EC00153E;
	Fri, 11 Apr 2025 16:42:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com B550EC00153E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
	s=dkimrelay; t=1744414935;
	bh=EkyXE6kp7s08RsmhTG89JIe7wCX1seuLLb87FHwSC+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUO72L8+twkIp+ygo84e5/htNyP8J0+UNXgv4E+06bqO5IwwJKjL9UF69xDuQTa8e
	 W72QKk74HbhFxBHHcN8jFY+HaATnuE/80wJB+BBGyWtNressDbB8r+4s+upR+RR2GQ
	 QIOWrJrZXO4j/SiG+uoPrdYVxYXgxm6Wu+p/UFH0=
Received: from fainelli-desktop.igp.broadcom.net (fainelli-desktop.dhcp.broadcom.net [10.67.48.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-lvn-it-01.broadcom.com (Postfix) with ESMTPSA id 3A53218000530;
	Fri, 11 Apr 2025 16:42:15 -0700 (PDT)
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
Subject: Re: [PATCH v2 01/12] ARM: dts: bcm6878: Correct UART0 IRQ number
Date: Fri, 11 Apr 2025 16:42:14 -0700
Message-ID: <20250411234214.1022241-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250406-bcmbca-peripherals-arm-v2-1-22130836c2ed@linaro.org>
References: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org> <20250406-bcmbca-peripherals-arm-v2-1-22130836c2ed@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

On Sun, 06 Apr 2025 17:32:41 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> According to the vendor file 6878_intr.h the UART0 has IRQ
> 28, not 32.
> 
> Assuming this is a copy-and-paste error.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Applied to https://github.com/Broadcom/stblinux/commits/devicetree/next, thanks!
--
Florian
