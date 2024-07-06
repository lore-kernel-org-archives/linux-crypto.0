Received: from norbury.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53F16AB8
	for <linux-crypto@vger.kernel.org>; Sat,  6 Jul 2024 01:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720227652; cv=none; b=fpKPUFmzbKqoqTFJLMV+Hez7G/ir42pT2DbVpiQAtX128B/6aoLeDhSliUhK49MvNXbQfpEhFTfu9qPFBUK0XDTh02V3cz8VWWsZiacjUqtj42uf5Zd/mHQyfxCb6nZ+uwgfj0qfvaAOznK2SgNgBFjwdpNU0kgTF/ea1O47P3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720227652; c=relaxed/simple;
	bh=Eij4TIBMvKRm+0hBbw/dPnWyF+2k31vb8n451hmoMVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mUpCGsi1DrY+gBNyNA/7/mrQ0iyA2TY+xGuRJqt97RzL4K5WtMxrPsoC5XC2LhgYy4FF0beFr/pSW1dzSMVxudpKISfDE9XxKtVR4RT/1aAmWa+WSYYT7z19jB4NasGVZuKzmVLrQApYtXGm6aVS5aT1XyTbMVO2qM+k73DJZEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sPtbs-006h1Y-2e;
	Sat, 06 Jul 2024 10:49:05 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 06 Jul 2024 10:48:51 +1000
Date: Sat, 6 Jul 2024 10:48:51 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ryan Walklin <ryan@testtoast.com>,
	Philippe Simons <simons.philippe@gmail.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 0/4] crypto: sun8i-ce: add Allwinner H616 support
Message-ID: <ZoiUc5TEk64hseK7@gondor.apana.org.au>
References: <20240624232110.9817-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624232110.9817-1-andre.przywara@arm.com>

On Tue, Jun 25, 2024 at 12:21:06AM +0100, Andre Przywara wrote:
> This is an update to the H616 crypto engine support, with the sparse
> warning fixed and the accrued tags added.
> ========================
> 
> This series adds support for the crypto engine in the Allwinner H616
> SoC. The IP and its capabilities are very similar to the H6, with the
> major difference of the DMA engine supporting 34 bit wide addresses.
> This is achieved by just shifting every address by 2 bits in the DMA
> descriptors; Allwinner calls this "word addresses".
> Patch 2/4 adds support for this by wrapping every address access in a
> function that does the shift as needed. Patch 1/4 adds the new
> compatible string to the binding, patch 3/4 adds that string to the
> driver and enables the address shift for it. The final patch 4/4 adds
> the DT node to the SoC .dtsi. Since this is an internal peripheral,
> it's always enabled.
> 
> Corentin's cryptotest passed for me, though I haven't checked how fast
> it is and if it really brings an advantage performance-wise, but maybe
> people find it useful to offload that from the CPU cores.
> One immediate advantage is the availability of the TRNG device, which
> helps to feed the kernel's entropy pool much faster - typically before
> we reach userland. Without the driver this sometimes takes minutes, and
> delays workloads that rely on the entropy pool.
> 
> Please have a look and comment!
> 
> Cheers,
> Andre
> 
> Changelog v1 ... v2:
> - fix sparse warning by treating writel() call differently (2/4)
> - add Acks, R-b and Tested-by: tags
> 
> Andre Przywara (4):
>   dt-bindings: crypto: sun8i-ce: Add compatible for H616
>   crypto: sun8i-ce - wrap accesses to descriptor address fields
>   crypto: sun8i-ce - add Allwinner H616 support
>   arm64: dts: allwinner: h616: add crypto engine node
> 
>  .../bindings/crypto/allwinner,sun8i-ce.yaml   |  2 ++
>  .../arm64/boot/dts/allwinner/sun50i-h616.dtsi | 10 +++++++
>  .../allwinner/sun8i-ce/sun8i-ce-cipher.c      |  8 +++---
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 28 ++++++++++++++++++-
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c |  6 ++--
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-prng.c |  6 ++--
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-trng.c |  2 +-
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  | 15 ++++++++++
>  8 files changed, 65 insertions(+), 12 deletions(-)
> 
> -- 
> 2.39.4

Patches 1-3 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
