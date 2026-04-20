Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21072D77EE;
	Mon, 20 Apr 2026 14:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776696529; cv=none; b=GaStRGAB58u15UYmfkzzXxwqGzfUqs2uQEYsP8DCr5eERUSrUr0DWzzxvcsO+xzYQf9SX2O1YUfW4JQt62EocQUmS7yHDvocWNZLL4kkB/HyCFRWCGC5XoxPmRd6IHnGHg+2krZnhYUFjFqfOoaQrw7RYT77BPXm+x6pYyf+5rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776696529; c=relaxed/simple;
	bh=cSKan6b0zx/w9plQlbydVNsQaYcl0NWgrRbpHIQDyt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqFE0MQKGVEpkS8Q22EB7zZL1NXeehA0kcaznFpPRRK2grQ6RUd6LQt+k+TGten7oI5osZDLMZQjfoAeDzG0n3Og7ZZnZsIwC3nSZ1SWTfDibXfno9znN2O+uI4gvGf6/2MUMNSkn+Wc65TxtH3e/dfRWEJxomq8boDdYMxMgD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wEpvU-000000000GN-0rQq;
	Mon, 20 Apr 2026 14:48:40 +0000
Date: Mon, 20 Apr 2026 15:48:36 +0100
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
Message-ID: <aeY8xF82FB7Plu7W@makrotopia.org>
References: <585fc832e4e5d3656bd25ecee6bafb636993104a.1776600269.git.daniel@makrotopia.org>
 <20260420-flat-rook-of-hail-bbede5@quoll>
 <aeY3HuP01VYl5x6X@makrotopia.org>
 <e747a3c5-1c43-412b-8ff6-f447ee33995c@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e747a3c5-1c43-412b-8ff6-f447ee33995c@kernel.org>

On Mon, Apr 20, 2026 at 04:43:00PM +0200, Krzysztof Kozlowski wrote:
> On 20/04/2026 16:24, Daniel Golle wrote:
> > On Mon, Apr 20, 2026 at 04:07:33PM +0200, Krzysztof Kozlowski wrote:
> >> On Sun, Apr 19, 2026 at 01:05:01PM +0100, Daniel Golle wrote:
> >>> +    rng {
> >>> +            compatible = "mediatek,mt7981-rng";
> >>
> >> I asked at v1. Reminded at v2. Nothing serious, but repeating myself is
> >> pointless and kind of waste of time.
> > 
> > Replying *once* telling what you would actually want, or replying to
> > me asking back would have helped enormously:
> > https://patchwork.kernel.org/comment/26880354/
> > 
> > All I can see is that you concluded "no improvements" without telling
> > *what it is you would like to see improved*.
> > 
> 
> Yes, and then you should go to v1 and read the review. There was only
> single comment in this spot, so trivial to find.
> 
> AGAIN:
> 
> Use four spaces for indentation.

Thank you, that IS helpful.

I've read the "no improvements" statement as an overall conclusion and
not even considered it to be specific to any *place* without further
context.

Is that the only remaining problem you see in the binding right now?
