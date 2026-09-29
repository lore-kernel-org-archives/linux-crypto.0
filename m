Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716B933064D;
	Tue, 29 Sep 2026 09:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790672897; cv=none; b=X249iP/4i51J+x2CRDoJRa9tOqLptTcpOHMdnlDb+kX7D1RHfhmRyy0ww2aWdPUtdNcvzaF/XWKyf9MHJqtK/rrHLn4PBebbW70/Vxzw8f1uKQYxE2w/qYxG+kJb9BC1Q6tuLSMzY8u+mhd9VPsZ3AV0fg/2up6ziMsqr4LMJ+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790672897; c=relaxed/simple;
	bh=if0EC2KY8oU8BKb74zxHUy6TfyoX2qnSEvkPHf7GNc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SFlti2USuXu32gz75dwrN72Nk4uTxc9gyjzrlVKTGA2jc4hAIfmSxjR7QcxWjusqex/v4t8gX6VQlsva4/VvUTTPO5BjvQrGQGnukG4ckJWseK/GQIQNnq38ijQgJ9mwGiSxi9KuOR3yu9pl8ReJb61fyR7tgn8Jk69+prbXKc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xd8e5971; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xd8e5971"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243161F000FF;
	Tue, 29 Sep 2026 09:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790672887;
	bh=A6VnXMvmMGHgshh8xKZ4QB+UrfsOk0/f/UxrXPs17hU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xd8e5971R7TTujpnU5XrdzDmGVZ5c1F4klF6YV0NwdZZ8f4YhgYf19vkm8VfuptL2
	 9TlYkwgCPxn4LzsGmkrw0j1YC2pRSGM9oFwgFx3Ydb3Y/i8c79qBSMMVob2eYvhA6X
	 9VqbrX0nXwdpqncJXI1IuU6q3pOnmeQOfeXSRMKE/HhuQC4aoIt02jIGHjeBzs9tPB
	 7MhD657hzeyvSia5G4uwv1PiDTD6PRe3dMAGjyH/Hjl3mP3GiH16DqK6rCxks/6jn6
	 FRUQGLB+Ql3cEbjDtN/txeVCrPOAluU/jqh4TvtGfEs6lVYH75IbtQTUZVdMcBKWsF
	 zc1H2q8h9Dynw==
Date: Tue, 29 Sep 2026 11:08:03 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Vincent Jardin <vjardin@free.fr>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>, 
	Pankaj Gupta <pankaj.gupta@nxp.com>, Sahil Malhotra <sahil.malhotra@nxp.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/3] dt-bindings: crypto: fsl,sec-v4.0: add
 fsl,qi2-crypto-priority
Message-ID: <20260929-mysterious-fast-cormorant-37005b@quoll>
References: <20260928-for-upstream-caam-qi2-priority-v1-0-e4a8e5f01dbc@free.fr>
 <20260928-for-upstream-caam-qi2-priority-v1-2-e4a8e5f01dbc@free.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260928-for-upstream-caam-qi2-priority-v1-2-e4a8e5f01dbc@free.fr>

On Mon, Sep 28, 2026 at 04:01:04PM +0200, Vincent Jardin wrote:
> Let a board set the crypto API priority of the algorithms the DPAA2
> front end (dpaa2_caam) registers.
> 
> Benefits: Its DTS decides whether the SEC or the CPU is the default for
> in-kernel crypto.
> 
> Signed-off-by: Vincent Jardin <vjardin@free.fr>
> ---
>  Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml | 9 +++++++++
>  1 file changed, 9 insertions(+)

Same as previous tries for crypto drivers - not a hardware property.

You described the desired Linux feature or behavior, not the actual
hardware. The bindings are about the latter, so instead you need to
rephrase the property and its description to match actual hardware
capabilities/features/configuration etc.

Best regards,
Krzysztof

