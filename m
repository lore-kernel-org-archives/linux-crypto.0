Received: from relay.smtp-ext.broadcom.com (relay.smtp-ext.broadcom.com [192.19.166.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27661F4CBF;
	Tue, 13 May 2025 09:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.19.166.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747127043; cv=none; b=jm87ZkM4NKrRib9aLWLExSm/yw4wtxKHpiTNNYN9sKKtuJMws7Sa9Jd2Nge5O4r7Bkp6uiEJlPOKcm+sZkDjVheWC6oZEJEioiXEz8yw8xdloorXm1Pa84IHNGCGtYwyL/dkXM8wwjTi8oJCEApAQd9yUlsM4ov7wmeiRAK1+7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747127043; c=relaxed/simple;
	bh=+N+H69i3QY/I8zdPy6wEWY2n9jbqBZCggLSC0AyHIYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbJxOLOXiqhkO/wBL4Lp8KxWRoBeHg2YQGKdYAvGiQsJM1T7urgN0iMlMmje+78lDIURB66QmvRUpdej8vfjPhfaZwwYi/d0cgWffFBblnNl2Z7NNd7IHKGzL6xiDjLRDLsjgn7xhVqjKBV4Ok1GnegSgJ5rbjmvIkYNOlvoOK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=eZHw+hT5; arc=none smtp.client-ip=192.19.166.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eZHw+hT5"
Received: from mail-lvn-it-01.broadcom.com (mail-lvn-it-01.lvn.broadcom.net [10.36.132.253])
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 9C5E9C0000EC;
	Tue, 13 May 2025 01:55:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 9C5E9C0000EC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
	s=dkimrelay; t=1747126519;
	bh=+N+H69i3QY/I8zdPy6wEWY2n9jbqBZCggLSC0AyHIYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZHw+hT5XDBfPmh7jJbiEFFoE7F4vKY5e+CIH749VfuFQXeDE2yF6m2UH3LflEk5B
	 tL6ZoB7Wl9I3Af+imHeygojyfnahB3W6HhhyjERauSM8LvuXHll/FUJFMVGbkGtFyV
	 W1xQVGu75mL0+9p9C5e61kDF3kZVEpBzV/rfOKCU=
Received: from fainelli-desktop.igp.broadcom.net (fainelli-desktop.dhcp.broadcom.net [10.67.48.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-lvn-it-01.broadcom.com (Postfix) with ESMTPSA id 590A918000530;
	Tue, 13 May 2025 01:55:19 -0700 (PDT)
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
Subject: Re: [PATCH v3 03/12] ARM: dts: bcm6846: Add interrupt to RNG
Date: Tue, 13 May 2025 01:55:18 -0700
Message-ID: <20250513085518.2043398-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250512-bcmbca-peripherals-arm-v3-3-86f97ab4326f@linaro.org>
References: <20250512-bcmbca-peripherals-arm-v3-0-86f97ab4326f@linaro.org> <20250512-bcmbca-peripherals-arm-v3-3-86f97ab4326f@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

On Mon, 12 May 2025 14:05:49 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> The r200 RNG has an interrupt so let's add it.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Applied to https://github.com/Broadcom/stblinux/commits/devicetree/next, thanks!
--
Florian
