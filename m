Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF99728B7FC;
	Mon, 21 Jul 2025 09:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753090571; cv=none; b=bfDW9jpPxRVWBBbBJTEJkLlF/SD1eXQabeSuLIkowPPnfx/96kmZzknvX9Of8/sZsF45TAlG7RJR35+LEj8NwS6711plAN+9W0AxArEAsKkRSpFd+ve0D1flBv4jFX7XDv9qUt1ywcQ3+7VQnX5TyZLy3sZ6ebGV1Z+DVMCXg8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753090571; c=relaxed/simple;
	bh=amn7S0NK0vIN78Usz2dx0uMxGfBGU5rx/5LvBfYs5/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IuXHOkUwFuXqmvMeadgjCYJn48vz3aNm5ZN32/puGIrFb9eUEwWVsjH3xsREJM8IyDTFG/wXrhDeXK+Dc+VlvOylrzI45j3YzA03f7dwjhM8b1bAJoTbc4XrcKR/TzyUHogdYFzejcV8jOlvsIpnNi90EhdywAcvaGzJijpzE0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IgGamjwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IgGamjwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3F0C4CEED;
	Mon, 21 Jul 2025 09:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753090571;
	bh=amn7S0NK0vIN78Usz2dx0uMxGfBGU5rx/5LvBfYs5/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IgGamjwtmndD+gnnGza+t+EPyeECFRH27kjjM+ujLlTLy1QsDQfEXjn5HP4wShXwF
	 RwDiLWL9Fpa3Rwnlnb/d8HX7dVZQg+MFJIgOLDCrhYTrp8vdnunLAynHcTe96tvUM+
	 FtsS3jqnN2ecBF/3SBuKMJRqHer7r9HwMGU2TLuP8ked97MWkY8WzbHGnnYQ3BOt7f
	 iSMfyX0cVBq6mLJj8EYjtFuaZdQpusHgKk7HqKkkPK0aZM0pkJ8qHJMYndyCrKXZ0F
	 ndQAKDdxsGBBq2xFCCS/XLDigkB8KP90WkR+458zI4kVIRelwf2hcmCt80wNHVHZyo
	 e6RReoc5oGFQw==
Date: Mon, 21 Jul 2025 11:36:08 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, matthias.bgg@gmail.com, 
	angelogioacchino.delregno@collabora.com, atenart@kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 2/2] arm64: dts: mediatek: add crypto offload support on
 MT7981
Message-ID: <20250721-camouflaged-dramatic-rattlesnake-e7f87f@kuoka>
References: <20250720174903.1321533-1-olek2@wp.pl>
 <20250720174903.1321533-2-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250720174903.1321533-2-olek2@wp.pl>

On Sun, Jul 20, 2025 at 07:49:03PM +0200, Aleksander Jan Bajkowski wrote:
> The MT7981 as well as the MT7986 have a built-in EIP-97 crypto accelerator.
> This commit adds the missing entry in the dts.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  arch/arm64/boot/dts/mediatek/mt7981b.dtsi | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt7981b.dtsi b/arch/arm64/boot/dts/mediatek/mt7981b.dtsi
> index 5cbea9cd411f..ebab8dde1e70 100644
> --- a/arch/arm64/boot/dts/mediatek/mt7981b.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt7981b.dtsi
> @@ -94,6 +94,20 @@ pwm@10048000 {
>  			#pwm-cells = <2>;
>  		};
>  
> +		crypto@10320000 {
> +			compatible = "inside-secure,safexcel-eip97";

Missing SoC compatible. You should not use IP block compatibles alone
and your previous patch explains why: some wires can be connected
differently.

Best regards,
Krzysztof

