Received: from relay.smtp-ext.broadcom.com (relay.smtp-ext.broadcom.com [192.19.166.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F06522126B;
	Fri, 11 Apr 2025 23:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.19.166.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744414998; cv=none; b=D46Y5iF50OrZJOwqLvQOXWZxUsDe3tzgDLXsNRaiYAVp9e7vVutqTJH/RDhkrJL0JKqW3TTycvM+1gq9WQUnL6a+OI+suYzYozeVlfLKSFpmxbBackWPX5wR8Vmc8dyG5QK8F8ef8SS778fV+zmr1+yReaK+JrM/g4589zidzsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744414998; c=relaxed/simple;
	bh=R9cSfNoj8XYtLswy63/tc4b6hplxuTpNLz5Xze37v48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovHcfP1I6K4p9d1adBemj1MBhohXKAqr6nNCvEMToa46/WMhyxMZMw4JyJMcQQ53gVeOz0pT0VG6IsYC7LXKznioEwnvDAIXMPKXfoLhJgh+8nmbTUGOnY1JFcPqIefp0olM3CPn4oe6prhfHgzm/QQQbu9AZIAog4ewV+ietpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=KVoVbP4n; arc=none smtp.client-ip=192.19.166.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KVoVbP4n"
Received: from mail-lvn-it-01.broadcom.com (mail-lvn-it-01.lvn.broadcom.net [10.36.132.253])
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id AF9A0C0004E8;
	Fri, 11 Apr 2025 16:43:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com AF9A0C0004E8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
	s=dkimrelay; t=1744414996;
	bh=R9cSfNoj8XYtLswy63/tc4b6hplxuTpNLz5Xze37v48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVoVbP4nVZ4cqUPVSAW9pXLhLa5pLwV3lVgn2rFXbaXhohZ+bVghKaYBQg9Tmgq2U
	 bsHRKMtym9OSJ08q0Ki9SQtVetN4rRQKbETPX3emAxY9qy9t6RWmB7jj371kO8bcIn
	 zS9PLpyBPhOdMiFktl5+VD+Q9O0zx2JBvqoJCjFM=
Received: from fainelli-desktop.igp.broadcom.net (fainelli-desktop.dhcp.broadcom.net [10.67.48.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-lvn-it-01.broadcom.com (Postfix) with ESMTPSA id 761AF180004FC;
	Fri, 11 Apr 2025 16:43:16 -0700 (PDT)
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
Subject: Re: [PATCH v2 08/12] ARM: dts: bcm63178: Add BCMBCA peripherals
Date: Fri, 11 Apr 2025 16:43:16 -0700
Message-ID: <20250411234316.1022980-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250406-bcmbca-peripherals-arm-v2-8-22130836c2ed@linaro.org>
References: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org> <20250406-bcmbca-peripherals-arm-v2-8-22130836c2ed@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

On Sun, 06 Apr 2025 17:32:48 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> All the BCMBCA SoCs share a set of peripherals at 0xff800000,
> albeit at slightly varying memory locations on the bus and
> with varying IRQ assignments.
> 
> Add the watchdog, GPIO, RNG, LED and DMA blocks for the
> BCM63178 based on the vendor files 63178_map_part.h and
> 63178_intr.h from the "bcmopen-consumer" code drop.
> 
> This SoC has up to 256 possible GPIOs due to having 8
> registers with 32 GPIOs in each available.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Applied to https://github.com/Broadcom/stblinux/commits/devicetree/next, thanks!
--
Florian
