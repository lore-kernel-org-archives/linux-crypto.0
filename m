Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971433A5E86;
	Tue,  3 Mar 2026 14:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547095; cv=none; b=tpn4eLLIkze4hJcLvQFKbMyMnkkpQMeoMvdQmdOFi1TOi8nsClqgb8irE2diYNzUY7+wmm19Msv1kTFxzv8oU9U10PeenuTcgv4JRl/ULlYiGHgHukTjR/HFDbTKj54dV9/YAvwm0P7LZ3gEbgs7YLRBsIKHGlH89yrqV++GbCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547095; c=relaxed/simple;
	bh=4Fs2LOLFj3vFatS1R2AiwItYeScasVwwFnu5VG+0qtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OGqebuOurkOulbS/CgggEfY4qwRvX0CnPA2wNff4Ms9Lwl7A7gUG+OnA2MktRK+QH1XYPqUc+ZvWpVgD30dezPjF8Zyi/EHqNw/FKhgPwpdXGUq5GKhnm4zkw26h7mTrD81ckcQRnuXe2brS1GxCPeSodXOuEDZydN/P3T5VNAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=NgOhU4mF; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="NgOhU4mF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1772547092;
	bh=4Fs2LOLFj3vFatS1R2AiwItYeScasVwwFnu5VG+0qtQ=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=NgOhU4mFBjwD/qYrXg3iGt9pKCVGWn15p5dEAT+3Lgx0UmaLEzggspRGZ1W23jWrW
	 9VXFQ+JaKEbfiCZ6ic2Tou4Rir/8GOLEz4c2sik8bx/ggyW5GYcim6KgqjtY0atlxG
	 VpANOEQhFtr9QJPynLmuPVjekpK4NY+8BZi0YJ9VsMtqn3TOXOw3QKfCEKIlShI+Lb
	 VNx72g/fVn0qQclTYDF6G7QFvhLq6sm6YFKzHzpXj7J3GIrkc2XUZNLUbo6yUOejrq
	 6pAyxGpil/evTvkvPs1Y1C9/NDCzVmCImimSU85m/q7K2wWD5rCI0mYQlftITamW0H
	 0/vZJsqKAyIDw==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 6F45317E0EA3;
	Tue,  3 Mar 2026 15:11:32 +0100 (CET)
Message-ID: <97d053db-83e2-4ac5-b423-2b0174e3229e@collabora.com>
Date: Tue, 3 Mar 2026 15:11:32 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: inside-secure,safexcel: add
 compatible for MT7981
To: Aleksander Jan Bajkowski <olek2@wp.pl>, herbert@gondor.apana.org.au,
 davem@davemloft.net, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, matthias.bgg@gmail.com, atenart@kernel.org,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20260302230100.70240-1-olek2@wp.pl>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <20260302230100.70240-1-olek2@wp.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Il 03/03/26 00:00, Aleksander Jan Bajkowski ha scritto:
> The MT7981 as well as the MT7986 have a built-in EIP-97 crypto accelerator.
> This commit adds a compatible string for MT7981.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


