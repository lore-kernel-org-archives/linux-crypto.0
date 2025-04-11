Received: from relay.smtp-ext.broadcom.com (relay.smtp-ext.broadcom.com [192.19.166.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4FB1F9413;
	Fri, 11 Apr 2025 23:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.19.166.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744415360; cv=none; b=DqWm2agrVFLm0LtbeJ2tyXOMbxjMyRxc6Q791bGjYRRbZKpC23YyFXGmNuApSmSy6LIqnL9IbEdPDiiIqiu6S3ikVE/pKWw96LovvPDXlF+50pGmlUrDkjHrWqnWJO6u9ppui2T7oYLYOPjxiQSMJYWMfBxX9Z+ElHfZ/ayUcfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744415360; c=relaxed/simple;
	bh=KE7xx5fV3DHlKulz2UWAtTlLl8KAKyE2y/a01nvcr8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohYeb1+SGpZP0xwyQ+FKw57F6crEXW0V6rM3LP8A6nm44BxEA01nC41+mAogLoaDotEMrYrt3mL02z39FWKJaSkYcwUetbx49MoZ3Vts5y9L7CipRQwC0hXDI2eQHx/jb6DXujLOG614+g71xgBqGVyzgZqpBi16sRdJ3GXaViw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=TxGl8ei7; arc=none smtp.client-ip=192.19.166.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="TxGl8ei7"
Received: from mail-lvn-it-01.broadcom.com (mail-lvn-it-01.lvn.broadcom.net [10.36.132.253])
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 3468DC0000E7;
	Fri, 11 Apr 2025 16:42:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 3468DC0000E7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
	s=dkimrelay; t=1744414947;
	bh=KE7xx5fV3DHlKulz2UWAtTlLl8KAKyE2y/a01nvcr8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxGl8ei7TG0FMdq8oJTJ1FLRjiUokkxHXRTnAveVbeoc1GT7VVIdqoKVrwCzOApwp
	 Btsja+ZySFOReaIPBkbIPngIiCOnAusNTp+ZB2oR86suP2Wpf1jBIfjA64U9RqYkhw
	 mBv86qa+/9Bf0qh5gjF+r/XNEQMZ5NYb+sT1U6RY=
Received: from fainelli-desktop.igp.broadcom.net (fainelli-desktop.dhcp.broadcom.net [10.67.48.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-lvn-it-01.broadcom.com (Postfix) with ESMTPSA id EC41D18000530;
	Fri, 11 Apr 2025 16:42:26 -0700 (PDT)
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
Subject: Re: [PATCH v2 03/12] ARM: dts: bcm6846: Add interrupt to RNG
Date: Fri, 11 Apr 2025 16:42:26 -0700
Message-ID: <20250411234226.1022410-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250406-bcmbca-peripherals-arm-v2-3-22130836c2ed@linaro.org>
References: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org> <20250406-bcmbca-peripherals-arm-v2-3-22130836c2ed@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

On Sun, 06 Apr 2025 17:32:43 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> The r200 RNG has an interrupt so let's add it.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Applied to https://github.com/Broadcom/stblinux/commits/devicetree/next, thanks!
--
Florian
