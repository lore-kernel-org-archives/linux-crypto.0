Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A337436B05E;
	Mon, 20 Apr 2026 14:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776694055; cv=none; b=NJqsOcLXo6DbwNChjivcCKmVtCk+oWUs+znymseAHibt4rNlF7R77G2ONJAqMwlrZlUIRPl1abgCpJNctT42IfoXegWOQF54LlKAsdWP6ififcgStu7kZuw0bEHrDMZ/vHsNCISqfMC770NQH/6sBfczSTtRx1VduZoAlQJaJtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776694055; c=relaxed/simple;
	bh=d80QDEnxF/ilpFms2KfQO1UNLF3wo4wPPu1B5+qU10o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lemz7N5UnDsKN/PFTZ72mAM1hlcQ9M4W/fVbGJHTYBdQOGp4OXL+1PfGw1NAEUjzG1HTyIe5oZqBBtNKWwNUEIJ5fPwrdEkFvNefDUddWk5XC1a2nJv443xrKDWQlUh6c+IxvUOGLtfkSwZW+XkdmWZUdzrJ1Ue5ECuzYkY8ReY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J2Wb67bq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J2Wb67bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD59C19425;
	Mon, 20 Apr 2026 14:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776694055;
	bh=d80QDEnxF/ilpFms2KfQO1UNLF3wo4wPPu1B5+qU10o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J2Wb67bqeB63dy4hokMUqABHv9VGNfMqKSK/q1/tAXRpen3mpHhP93s0Ag0Aokafh
	 weU1wnR8UDgRJYke/yAJLQtumXxCtuVELwNr4AC86mjMYnI454BGXmg4OwurXq9wni
	 RX62PVCzhG0XdwT9OF/063G9U8AbRG2qBjvwo8nMnXwRYrE/FTLbJZNBEfmHQ7eKXY
	 HILp2bgoRGP4oArlsX2frM8fa9xaQEKTc567Hbtbl7WgrtRti5bwZtaLWuTDbyaMRm
	 cVznFsS1ZmW+B3k5KkZAQ6qxI9OoCxD2oR6h06qp4WPo5nlNDCViiNJszT//lNT1Uo
	 An5H/uCq9nQ7g==
Date: Mon, 20 Apr 2026 16:07:33 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Sean Wang <sean.wang@mediatek.com>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v3 1/2] dt-bindings: rng: mtk-rng: add SMC-based TRNG
 variants
Message-ID: <20260420-flat-rook-of-hail-bbede5@quoll>
References: <585fc832e4e5d3656bd25ecee6bafb636993104a.1776600269.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <585fc832e4e5d3656bd25ecee6bafb636993104a.1776600269.git.daniel@makrotopia.org>

On Sun, Apr 19, 2026 at 01:05:01PM +0100, Daniel Golle wrote:
> +    rng {
> +            compatible = "mediatek,mt7981-rng";

I asked at v1. Reminded at v2. Nothing serious, but repeating myself is
pointless and kind of waste of time.

Best regards,
Krzysztof

