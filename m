Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353213AE709;
	Wed, 21 Jan 2026 18:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769021037; cv=none; b=WGAuFhf7niB/ltoqwI2HL21tner5j1wLb3VvVgpR4cEciTozlFqpCkFFdt817KtokTK/QVf+eKzkzJtUfiE33K1CRgCe8tRXPku7+nH7pHfaZCIYxDZgouH4JUdjaDFDb/mT52jqrf9OpS6t4vqXafDKdeLdxYVQTEWRk3kP2ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769021037; c=relaxed/simple;
	bh=tdP8IcHE3V6E2WPepo9Dt20ryBg+PeyHE8I+374/qzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gog1EmwJtqvfO3gnYtaA8EnFkctoORky3ZfKNoka3+IfxsMOYO8Hywq2RauOs5MPd7I3CFE6XZhi9kewNaluEMQech0VHcF0P25+EaBTAESy098aTN2D5llzg9rIaYLM6fK1wOEYkU2bz4i0iLvq3A3OFfm5U+SNQh4RF5FjdQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u9BQlKNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u9BQlKNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DFBC16AAE;
	Wed, 21 Jan 2026 18:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769021036;
	bh=tdP8IcHE3V6E2WPepo9Dt20ryBg+PeyHE8I+374/qzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u9BQlKNOvdxV7n3Bjtlq1U1gQn6fVBSdcHrOxE+cEly/9B9Qqa4t3qcbuVDvD9Wxq
	 UBrtBLLWe+cMLLOf6u6s+gXXgLj7keOCYiA2FRpydbLPEbZwQ6ROlgBZmFEPY1Lnya
	 uRI6eD73CxMsJLs1mjb3aWS2r3BVQT7FpwkDur0ZwsjqCZcaGcTskJlURDiPREotVX
	 dNcyZU2y1hJrOyRyJjIBpxM7pe/MdtCnSxpfgmoR7WUdx0rRgY3xeTxZ/bwKnrpOAk
	 2+QtIONOjFpbd0Bd9UOMW3SwwmIsmlg47+glaC5usr+Er802DfZMa1IoecM2c1tf7v
	 Fo9V2PGeHK68Q==
Date: Wed, 21 Jan 2026 12:43:55 -0600
From: Rob Herring <robh@kernel.org>
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: krzk+dt@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net,
	conor+dt@kernel.org, andrew@lunn.ch, gregory.clement@bootlin.com,
	sebastian.hesselbarth@gmail.com, matthias.bgg@gmail.com,
	atenart@kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, kernel@collabora.com
Subject: Re: [PATCH v2 0/4] Fixes for EIP97/EIP197 binding and devicetrees
Message-ID: <20260121184355.GA3842411-robh@kernel.org>
References: <20260112145558.54644-1-angelogioacchino.delregno@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112145558.54644-1-angelogioacchino.delregno@collabora.com>

On Mon, Jan 12, 2026 at 03:55:54PM +0100, AngeloGioacchino Del Regno wrote:
> Changes in v2:
>  - Reorder commits
>  - Change to restrict interrupts/interrupt-names minItems to MediaTek only
> 
> This series adds SoC compatibles to the EIP97/EIP197 binding, and also
> fixes all of the devicetrees to actually declare those in their nodes.
> 
> The only platforms using this binding are Marvell and MediaTek.
> 
> AngeloGioacchino Del Regno (4):
>   dt-bindings: crypto: inside-secure,safexcel: Add SoC compatibles
>   dt-bindings: crypto: inside-secure,safexcel: Mandate only ring IRQs

I applied these 2.

Rob
