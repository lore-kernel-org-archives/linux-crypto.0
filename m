Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC25451992;
	Fri, 14 Aug 2026 10:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786703325; cv=none; b=e7xxs+dBj5FuyAphD2ngfB0cLZmAO+DZOHQKflorrSRgEQn2Zqu3EhtLwJFc8cnI3mSeG2pUvziGhV8LHZ17AnlJ6JA2VoYturxFk0PADAnh9YFOXWiZ6/cUH7lfA94eiFw694j/qoRH+nQBMUlDFzeZGd0ohlgWU6ik+Brle5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786703325; c=relaxed/simple;
	bh=jmNZWfKbO5LMIr9sUlyAH2hsrSTRjdYAX/yEpKcdh7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KdRGLjJZ9T6Z18ep2H48uat0C6/EaR3LJ70ThRdsvEZ7jm2f6cuEKum4AoHP+rYYtLcPf44hmOuzeyebYiJRUVk1Hq6RCvD1IfuveQgPKbDbv1b615ViaGAiHkg3hVtNQufjta+jRTXMRlFUkmJQbPTSZ6RNuZkl6e+C7oX+w/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UgmDCVcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UgmDCVcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632B31F000E9;
	Fri, 14 Aug 2026 10:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786703316;
	bh=ouEgkRTfeWu92lCKKXn0sUW7l4zcekTfMbkVfkP+wso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UgmDCVcjtdhbEztMw7TgOpCmzXdXh3E8PSfbfHUVCygEDjyK6QzI3f+Po+QIU5lTK
	 h28ouihEOl+1ec1+t3JRzZEbJIZkqYMUdLq9Q2k+ofKpV3rP/XGdy9/Bm20l4XXZm4
	 BqqcmxoKlXiZQ9xOF6LsfskmCHiMKrs1ALr3IGMhaAYi0pUZa0JugT9++y8EtnbYbV
	 ILVQwLs8MsME2Rica7mbAUWPrTzcIMvxzL39azudUH4f3FU1wdWtdVb6J/2z/Ye7jg
	 ClMNww9Y3U6624JxU3SfXJEpJUiCWV6dvTWCDDs8CACDu5LJ7cqW+3LcZ7eRHMKd8g
	 XUutGgpq77mhA==
Date: Fri, 14 Aug 2026 12:28:25 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Vladislav Leonov <vlad@zlab.su>
Cc: linux-rockchip@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, Simon Glass <sjg@chromium.org>, linux-clk@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Aurelien Jarno <aurelien@aurel32.net>, Conor Dooley <conor+dt@kernel.org>, 
	Daniel Golle <daniel@makrotopia.org>, Heiko Stuebner <heiko@sntech.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, Olivia Mackall <olivia@selenic.com>, 
	Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 20/25] dt-bindings: rng: rockchip: Add RV1106 compatible
Message-ID: <20260814-screeching-fragrant-llama-fd2477@quoll>
References: <20260810121121.210040-1-vlad@zlab.su>
 <20260810121121.210040-21-vlad@zlab.su>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260810121121.210040-21-vlad@zlab.su>

On Mon, Aug 10, 2026 at 03:11:11PM +0300, Vladislav Leonov wrote:
> Add rockchip,rv1106-rng as a variant of rockchip,rk3588-rng, following
> the pattern used for fallback compatibles in the schema (an items list
> with an enum and a matching const fallback), so RV1106 can reuse the
> existing rk3588-rng driver bindings.

All last three lines are redundant, as mentioned in other answer.

> 
> Signed-off-by: Vladislav Leonov <vlad@zlab.su>
> ---
> 
>  .../devicetree/bindings/rng/rockchip,rk3588-rng.yaml  | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> index fcc5be80142d..60ceac2697c0 100644
> --- a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> +++ b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> @@ -13,10 +13,13 @@ maintainers:
>  
>  properties:
>    compatible:
> -    enum:
> -      - rockchip,rk3576-rng
> -      - rockchip,rk3588-rng
> -

Do not remove blank line.

Best regards,
Krzysztof

