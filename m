Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE6A194C88;
	Wed, 10 Jul 2024 18:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720635170; cv=none; b=POP1hyrX3UeHQHewLji8ZffMf6gormPxRW+D4mZ3+TZApz5UJ8EAxvXAtCX0/62HvQws8bl6AA1f4FeIqat1q37guD0GmGnaYf8XCMJHJ/RakMvJt0EdN9zNYJHJGz2VA9RMetqRJ+RJElphHW/EaGeikHShyAIN4BR7h2PAxQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720635170; c=relaxed/simple;
	bh=DTB/owbaLdVNB4YxmcTgE8wy8iO9uCeP3XquloUK1Iw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AreCfSJQ8N/znWMmmGvP60FqzregU8M1HE2GLr/fxWgdcEzXfm0UDnMKlbP3ShKBkUmHLhbm2mUZvdRd3becc5IwyxJey5ZRQEub0MPj0htqg9moozzxH0TUzht8Y9uQqtoSHt3m/C8Di6tJrpuQ6KT+/vdXryBBU5olPN+VXXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDA9C32781;
	Wed, 10 Jul 2024 18:12:50 +0000 (UTC)
Received: from wens.tw (localhost [127.0.0.1])
	by wens.tw (Postfix) with ESMTP id 081105F7C0;
	Thu, 11 Jul 2024 02:12:48 +0800 (CST)
From: Chen-Yu Tsai <wens@csie.org>
To: Corentin Labbe <clabbe.montjoie@gmail.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jernej Skrabec <jernej.skrabec@gmail.com>, 
 Samuel Holland <samuel@sholland.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Andre Przywara <andre.przywara@arm.com>
Cc: Ryan Walklin <ryan@testtoast.com>, 
 Philippe Simons <simons.philippe@gmail.com>, linux-crypto@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev, 
 devicetree@vger.kernel.org
In-Reply-To: <20240624232110.9817-1-andre.przywara@arm.com>
References: <20240624232110.9817-1-andre.przywara@arm.com>
Subject: Re: (subset) [PATCH v2 0/4] crypto: sun8i-ce: add Allwinner H616
 support
Message-Id: <172063516802.1318387.15865465528678150093.b4-ty@csie.org>
Date: Thu, 11 Jul 2024 02:12:48 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13.0

On Tue, 25 Jun 2024 00:21:06 +0100, Andre Przywara wrote:
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
> [...]

Applied to sunxi/dt-for-6.11 in sunxi/linux.git, thanks!

[4/4] arm64: dts: allwinner: h616: add crypto engine node
      https://git.kernel.org/sunxi/linux/c/6ed9a85f1c44

Best regards,
-- 
Chen-Yu Tsai <wens@csie.org>

