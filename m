Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E745939E6D4;
	Tue,  3 Mar 2026 14:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547095; cv=none; b=u64ykbWSkLvg+ZYi/VCGM8cCkGtWiBjhnr6ZPAEYsraYGvIJVZHtWZBnQO1PSwA6WmB1jkoOR5ODMWVFkEL85ETrkamuB7+RA+OT6nfQfcvUz8oZSAftzagkftMZgCZqK8y23ROGF71oueQjTRCYBxC1cE7U/Rm+OmYb7iNusf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547095; c=relaxed/simple;
	bh=gqpj5LlBtH7M/NHlGkNd2PMy/VhJqn7LsUBN9beRTb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ht4LFiBMh409XzcpLJY/aW3RH/mVEXPiO90wamf0fi62KYQNH9FoMKJnoeTDAEt97/Sffn4MrYh/RYy/8tMTd9jNUa1fHsJbLQav4+UdoDfsnOw2KU5I8egFZE3PlNAhGJ88MLMvdxOj1RmxvAxOghNReDBdmCNLXca4ETETvjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=iUOMBAPQ; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="iUOMBAPQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1772547092;
	bh=gqpj5LlBtH7M/NHlGkNd2PMy/VhJqn7LsUBN9beRTb4=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=iUOMBAPQf6QqMV9DwdlzOU9GODujSmrfgGXt3SXGgKc6ACzhdl4NDmaZ2XvuGWlfY
	 bD4M/LphRvhi9kXNjP4XEGjBoMcBItv9gqxKL97RQpzz512UfkhcQEHMPalaiGifKQ
	 IPgFCQpz2SPr5P5HV1emJvF6upCqj0XLAEU3Fh9dCSr0U24SywxCQU7I2WurUU1eA5
	 Itw5UyILKvlny34u/Cy4/PcOYJU+CpJbm/43e6qvzm+LVzbprt5yrS0PXhtK49OG0H
	 jKo+53AN9zN542I5m2yYObS49Q48NNrIPvoB8DnN/FCncbEpjHzQabVY50+3Cr6dEW
	 8t1ugUpQk07QA==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B4D1617E03E5;
	Tue,  3 Mar 2026 15:11:31 +0100 (CET)
Message-ID: <5b384601-cb49-4f69-8df7-f751c947c336@collabora.com>
Date: Tue, 3 Mar 2026 15:11:31 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] arm64: dts: mediatek: add crypto offload support
 on MT7981
To: Aleksander Jan Bajkowski <olek2@wp.pl>, herbert@gondor.apana.org.au,
 davem@davemloft.net, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, matthias.bgg@gmail.com, atenart@kernel.org,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20260302230100.70240-1-olek2@wp.pl>
 <20260302230100.70240-2-olek2@wp.pl>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <20260302230100.70240-2-olek2@wp.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Il 03/03/26 00:00, Aleksander Jan Bajkowski ha scritto:
> The MT7981 as well as the MT7986 have a built-in EIP-97 crypto accelerator.
> This commit adds the missing entry in the dts.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


