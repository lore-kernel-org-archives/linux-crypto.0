Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBF3391846;
	Tue, 18 Aug 2026 17:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075040; cv=none; b=L5ObjG9iMQzoXC9ZbXg+NKOrf9i5DnhzlXj5JSXGIYnmlGYl77TU6PzwtESX6YJWEIljosy2v5U/VibaaIOlImdHmhykXUpWOQJy/fz7wmo38wlJek/VHQ+njSKm2LERAk4GGF0H90atieo1o8fG1Bee22NHi6qDJAc2z+81LAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075040; c=relaxed/simple;
	bh=lI+1Ym6LZdNwkSfDv0IcQeotRPtkIh67GDz3ylIMRlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1OFSsIRCjIHICkE2tOXr88GG26r0Tvz7zpf6FBw86xLSYELHKIisdgSn4Z0BL6PY0AYo0pPzp7lDwhDPduSTtt3UBLCHXZfkcf1WMnUmSRZXx8p4aFLlDllCAAmgaRaOMuF5PInNtqkW72mchzevvpdxdgMdBa6xksjGKEDDWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iG+fdD4T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iG+fdD4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E0B1F000E9;
	Tue, 18 Aug 2026 17:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787075039;
	bh=coPuo6DlMjz6XUYFqtoCQOf7Mjzi2tu4MlwoML98W5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iG+fdD4TZ8co0TJrZnZRAMEzk+7DBr/xgnXnAamdru7pLg7eIfRerZuseVCPERot/
	 uQmkQ0ea2dIrg2Cddc82YAq6qdNQuuiicCZnbDZW1BpuclSShfQ041YsZRzbl03R4X
	 gVUyjtID7cWOcCJu6AfPZW/h4AUUFOaVuaMqO3RQz6mgmFz1IR8PRAb+R/pKOtq2wJ
	 EjTLQnFASoIoT9YEOzQ9Va0oeibBKHbEpMxFpjDYqoAutZEus9A43SYAEyccBL5EkL
	 aLZQQD5+B6EiXSEJA7FKesUtTi9wmy/0UIptfDQrICKF/ek7PrcMBbtUmteqD7lz2I
	 p++vIFK8T3kFg==
Date: Tue, 18 Aug 2026 10:43:56 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Dawid Olesinski <dawidro@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Diederik de Haas <diederik@cknow-tech.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Conor Dooley <conor+dt@kernel.org>,
	Corentin Labbe <clabbe@baylibre.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] crypto: rockchip: Add RK356x/RK3588 cryptographic
 offloader driver
Message-ID: <20260818174356.GD2249@quark>
References: <20260708175837.1718437-1-dawidro@gmail.com>
 <20260816194112.552100-1-dawidro@gmail.com>
 <20260816194112.552100-3-dawidro@gmail.com>
 <20260818-enigmatic-friendly-lizard-bc8aaf@quoll>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-enigmatic-friendly-lizard-bc8aaf@quoll>

On Tue, Aug 18, 2026 at 09:36:44AM +0200, Krzysztof Kozlowski wrote:
> On Sun, Aug 16, 2026 at 08:39:45PM +0100, Dawid Olesinski wrote:
> > Add a driver for the second-generation Rockchip cryptographic hardware
> > accelerator found on RK3568 and RK3588 SoCs (compatible strings
> > "rockchip,rk3568-crypto" and "rockchip,rk3588-crypto").
> > 
> > The hardware provides:
> >   - AES block cipher engine: ECB, CBC, and XTS modes, 128/192/256-bit
> >     keys. XTS hardware is limited to single-SG requests.
> >   - Hash engine: SHA-1, SHA-256, SHA-384, SHA-512, MD5, SM3.
> >     The hardware padding engine (HW_PAD) requires the total message
> >     length upfront and cannot maintain state across LLI descriptor
> >     boundaries, so multi-SG and unaligned requests are routed to a
> >     software fallback.
> >   - DMA engine: linked-list descriptor (LLI) based, with a 20-entry
> >     coherent descriptor table.
> 
> Hardware encryption drivers are being removed or at least tried to be
> removed multipled times, so would be nice to see here WHY this one
> should be added.

Well, it is the usual drivers/crypto/ pattern.  It's being pushed as an
"accelerator" despite the SoC already having ARMv8 CE which is almost
certainly much faster (ARMv8 CE support is mentioned in the datasheet),
MD5 (!) is being pushed for some reason, it's not properly tested, and
no use case is described.  These crypto driver submissions are basically
spam at this point.  Only thing that really saves them is that not many
people have the hardware, so there tend not to be independent voices in
the room besides the people pushing the driver as a checkbox feature.

- Eric
