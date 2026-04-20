Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F693A7F7C;
	Mon, 20 Apr 2026 14:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776695091; cv=none; b=KCqV3J7TxZLCipg99FY/bzct9dw1WEQIp0Rmah3jWTRQkxzJAfdJJ8sWOyek4594wpT1oEUhG0oavq5X3GNPU81KUj+/rOOjVcOmJJiotIDip1wZxokT7GnYYN2/MNAQtYOCxV13r8xBnXGysSF/o0T1bwM3pf8B19+pc1CVbiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776695091; c=relaxed/simple;
	bh=0lGfRSEcpfkHP4tjhbzldVYPoBHk1TuI3OH6+fPCTOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z79DugS+1AtFOJ/n1V7zbvXS/g/v7YWhL7u8xI6HhFMTv23q75u6I8GK4wYqYh5qiT9xz49jYvRS9l4iRWjRE7Vp4sBGAYMeS09BR/FkoSMECFluewsDUXWO+I8i9yNDQWhCh43+QIuDB4WssLtJf4DQNtNUYuxz5MLMIeuRdEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wEpY9-000000008Uq-2UVl;
	Mon, 20 Apr 2026 14:24:33 +0000
Date: Mon, 20 Apr 2026 15:24:30 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sean Wang <sean.wang@mediatek.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v3 1/2] dt-bindings: rng: mtk-rng: add SMC-based TRNG
 variants
Message-ID: <aeY3HuP01VYl5x6X@makrotopia.org>
References: <585fc832e4e5d3656bd25ecee6bafb636993104a.1776600269.git.daniel@makrotopia.org>
 <20260420-flat-rook-of-hail-bbede5@quoll>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420-flat-rook-of-hail-bbede5@quoll>

On Mon, Apr 20, 2026 at 04:07:33PM +0200, Krzysztof Kozlowski wrote:
> On Sun, Apr 19, 2026 at 01:05:01PM +0100, Daniel Golle wrote:
> > +    rng {
> > +            compatible = "mediatek,mt7981-rng";
> 
> I asked at v1. Reminded at v2. Nothing serious, but repeating myself is
> pointless and kind of waste of time.

Replying *once* telling what you would actually want, or replying to
me asking back would have helped enormously:
https://patchwork.kernel.org/comment/26880354/

All I can see is that you concluded "no improvements" without telling
*what it is you would like to see improved*.

You want me to drop the whole example? Drop the compatible?
I did drop (and replace) the negative list with a positive list, and
thought that was what you have asked me for
https://patchwork.kernel.org/comment/26817847/

This binding is dead simple: It's a compatible, describing the identical
hardware now hidden behind and SMC call.
