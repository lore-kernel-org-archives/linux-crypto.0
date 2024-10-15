Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D72189B88;
	Tue, 15 Oct 2024 06:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728973463; cv=none; b=SVxRRNBMyp4YdtwbK0B0aXPatcoxaPOp5rtITqGgG+/fTZ+DULUfsvJsNhuTrMYPyoJj9r8i1FeSxjIDDisgkXLo7HkcehNYCxTTny7qFwe+G2OcRQbcUN8h/czDMcZI4eb94EvCzZ2BcJ4MgCGRCrOZLcHxLM6IyJE2Uet31ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728973463; c=relaxed/simple;
	bh=FqxeBKUSF4YzO24qe/B/5MSnoqbuPJw/4FZvim8DKts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e9SWZoMa3SX2V0waHed2wjaZ58DqhhsTVwPnuqslTeqXo/sjlEDcn09M0VZqNr0GiOLRNZo0Vrs91fwV9Dys0MfHWlS8n4pwY5+o7kKHJpOapvFU8XP/nYfFcNonjaqnIeowLH6uEnGpJ/BlWB579cpmPpPYbIEWnQ0bl8Ioi60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oxrUFvCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oxrUFvCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F53AC4CECD;
	Tue, 15 Oct 2024 06:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728973463;
	bh=FqxeBKUSF4YzO24qe/B/5MSnoqbuPJw/4FZvim8DKts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oxrUFvCCXqq8tRPyBfrXUgFV6loELPv0mo85a/RPryoaejKqn/IRhMeFtPKqkc5N8
	 9EWqmeW2UVpbdfRkZA9uoAGG3zbx37SvGzWHSeg53NlaLKUPX0Dt+4BvANEkRIYgK0
	 q5OPuxtetCYGXbyjm8fjjQcc3KbK4vByglPKPe+eBAitKmR48TFtQyYkYfTzgK847j
	 3ARKBm3sTBH+9acpgyXzMCbzu2tdnr4ZLB/6cAbDZnZTm++zOKw5J5OV/XH+8SMJCf
	 aZgacKQqmkbLxmxKDfcHDB1PkcbbvPYFagHdBlBH9lYHowp4QJe46+Ig/PkrE4dVy5
	 cPh8Fd3qlildQ==
Date: Tue, 15 Oct 2024 08:24:18 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jayesh Choudhary <j-choudhary@ti.com>, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: rng: Add Marvell Armada RNG support
Message-ID: <zy2mqac5jxh7eyxk3lazdsplthlmluvtvqtyuth37jvqxijym2@jzjqpjkxg24n>
References: <20241014185457.1827734-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241014185457.1827734-1-robh@kernel.org>

On Mon, Oct 14, 2024 at 01:54:57PM -0500, Rob Herring (Arm) wrote:
> The Marvell Armada RNG uses the same IP as TI from Inside Secure and is
> already using the binding. The only missing part is the
> "marvell,armada-8k-rng" compatible string.
> 
> Rename the binding to inside-secure,safexcel-eip76.yaml to better
> reflect it is multi-vendor, licensed IP and to follow the naming
> convention using compatible string.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  ...g.yaml => inside-secure,safexcel-eip76.yaml} | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>  rename Documentation/devicetree/bindings/rng/{omap_rng.yaml => inside-secure,safexcel-eip76.yaml} (79%)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

