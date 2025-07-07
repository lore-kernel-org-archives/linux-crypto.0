Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D256429008E;
	Mon,  7 Jul 2025 09:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751880925; cv=none; b=WBMAahFHun1G7t5yKlPbX8x77YWUJEQy9HI8W8xwoQfL5zsEtQL6eDtLBvFotlCbyRM6rumxCVD7eE/qRl4gOP3Oz2PmIAMkWng2J2p1ALSbD8cBXm3Th1CxQqcMXQiSrDC4AaLDIirtQO1eAkOhsuA73C3IndnrJievTHrvXSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751880925; c=relaxed/simple;
	bh=2KBGhRNRyu3KxKn6GIG4TbV6xPdWbM2wn5dZMB9SwMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KLV3IZOjqE1fcMQA9UNB/7fVGlDdojFK/Kiy5A3Qyep+r6X1J3gij9Jfr7l5xhasFMTQ5oCqoJo/wRUzFOMBV15EIRc6RIJQHNdibS+GTXvYxhLWWfmLO3lxQMcT5rah2dR7MTQb45BLJZxXFXYeC/hcy1HV15sh7glB4+OrAGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=Oldu+a0V; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="Oldu+a0V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1751880922;
	bh=2KBGhRNRyu3KxKn6GIG4TbV6xPdWbM2wn5dZMB9SwMg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Oldu+a0VgFeTz4ZmDWKL4P8Va82avt4ARmhJlS2yFgTJjOSAayotvoVgOBdyLKQrX
	 I1dtTSwd42mT7lZsbD3fUGE9ZzXFPtJOzhZn1zvpto+sPhUwZLXxhSqrBhv2rhCek5
	 /2++qG08N8VwEHBH5vEJKp4pFpNZeOasVjsgBGiPR6hZIV7hraT1lwaXLWs1w2dkoQ
	 Q+0qQlXcTqD6GjGJqVSoNf3wL2xXb9KF+7t7hpq9yLmcIRMBD/7wOqrpTTKyMEsowE
	 FkeAIcxgQYx5wE9J9a5a9p8ikU+pXvBbtk/V0kK7+84js2Hax5tP1YMfH/GjvrtdDz
	 blzzKR5GBKwEA==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9F59717E1083;
	Mon,  7 Jul 2025 11:35:20 +0200 (CEST)
Message-ID: <ae202795-5194-40a6-8d3d-3a17c85c878d@collabora.com>
Date: Mon, 7 Jul 2025 11:35:18 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/80] hwrng: Remove redundant pm_runtime_mark_last_busy()
 calls
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Nicolas Ferre <nicolas.ferre@microchip.com>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Claudiu Beznea <claudiu.beznea@tuxon.dev>, Hadar Gat <hadar.gat@arm.com>,
 Sean Wang <sean.wang@mediatek.com>, Matthias Brugger
 <matthias.bgg@gmail.com>, Avi Fishman <avifishman70@gmail.com>,
 Tomer Maimon <tmaimon77@gmail.com>, Tali Perry <tali.perry1@gmail.com>,
 Patrick Venture <venture@google.com>, Nancy Yuen <yuenn@google.com>,
 Benjamin Fair <benjaminfair@google.com>, Daniel Golle
 <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>,
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
 Heiko Stuebner <heiko@sntech.de>, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Alexandre Torgue
 <alexandre.torgue@foss.st.com>,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
 Marek Vasut <marex@denx.de>,
 Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
 openbmc@lists.ozlabs.org, linux-rockchip@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com
References: <20250704075225.3212486-1-sakari.ailus@linux.intel.com>
 <20250704075359.3217036-1-sakari.ailus@linux.intel.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <20250704075359.3217036-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Il 04/07/25 09:53, Sakari Ailus ha scritto:
> pm_runtime_put_autosuspend(), pm_runtime_put_sync_autosuspend(),
> pm_runtime_autosuspend() and pm_request_autosuspend() now include a call
> to pm_runtime_mark_last_busy(). Remove the now-reduntant explicit call to
> pm_runtime_mark_last_busy().
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

For MediaTek:

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


