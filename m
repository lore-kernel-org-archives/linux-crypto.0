Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E375128C869;
	Tue, 21 Apr 2026 07:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776755827; cv=none; b=sj3jUYfXiDcdjp7nK/FVyb2TWJvBl4MojZ+HLY0L+dVA+yHjjcSMkIWb6ky3xjuDY5+dGZZpqgxVStCNCnZn0GBwM0GB9WQkhKY9Ab2sKQRpsA/PAAnWabQBe+NQSFZj3ms/sIaOFucBJh4//bkN4KTx1za7yzl3y4ciobi1bgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776755827; c=relaxed/simple;
	bh=oL7Rd9GJ0l4nrvo2o5ZqNhj+AWR0EznmOcr0ETuYJ3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qh9BKCZwFmglAeQg58Ph8HCTlP8NrIyL7H9LGJuiyNdtLMQLiHtvK2HPAD01PGHLbewLgHZbZcEoGNmvcvVPie/jBfJl70eCN302jX/iMJYxa+WqMPQMbxmoPxQs+ZAzUeaMMtIOWg/7sx1xelX+Uk4mv80AeuFm8INhjNn9iWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DKoXBfX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DKoXBfX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29ADC2BCB0;
	Tue, 21 Apr 2026 07:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776755826;
	bh=oL7Rd9GJ0l4nrvo2o5ZqNhj+AWR0EznmOcr0ETuYJ3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DKoXBfX1iDYVokCK1QnBS2adAyetU5axjQ1aYa9P+SRwMXYTmXiUCirgjZaWzpKvu
	 xxIo4rcookmIIrLPNMqBl5/ypTVljyPcSlxkcJSV2qCtuUX3vgxzhmF7D7Ur6AGa/r
	 eRScaiYU9VkKjoSh//mjb9xtVij+CVas8Bf8UnlcSdbqg1fVCCrNIzknYu9UdDKOCj
	 rIqgXJ3WCMZl1+wjqCumDLCmXR6NRLAgX+9lcgPGEEbnby1kcgzhjTRe37eFxB+f9C
	 GkWyHxxzPpv7y/ubyHQEVf5LfE6/B9nEUWymCuSZX3NRylQg1dbjDDY/e7Kzm+XwUc
	 h/YtjfixVpwQQ==
Date: Tue, 21 Apr 2026 09:17:04 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Sean Wang <sean.wang@mediatek.com>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v4 2/3] dt-bindings: rng: mtk-rng: add SMC-based TRNG
 variants
Message-ID: <20260421-axiomatic-sensible-corgi-e18edc@quoll>
References: <912fe579eccf577f3064b69d6c945e2c9087cab8.1776702734.git.daniel@makrotopia.org>
 <63aa9d62fef13e0991c17b16a836d8b5667aca96.1776702734.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <63aa9d62fef13e0991c17b16a836d8b5667aca96.1776702734.git.daniel@makrotopia.org>

On Mon, Apr 20, 2026 at 05:35:09PM +0100, Daniel Golle wrote:
> Add compatible strings for MediaTek SoCs where the hardware random number
> generator is accessed via a vendor-defined Secure Monitor Call (SMC)
> rather than direct MMIO register access:
> 
>   - mediatek,mt7981-rng
>   - mediatek,mt7987-rng
>   - mediatek,mt7988-rng
> 
> These variants require no reg, clocks, or clock-names properties since
> the RNG hardware is managed by ARM Trusted Firmware-A.
> 
> Relax the $nodename pattern to also allow 'rng' in addition to the
> existing 'rng@...' pattern.
> 
> Add a second example showing the minimal SMC variant binding.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

