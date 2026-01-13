Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AC6632;
	Tue, 13 Jan 2026 22:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768343832; cv=none; b=RBTTVML0NupwCqwIOotEMuiA8PgdswFzIwh3ow1Ovrtis5lQSrTO39fbFbQLudG4wugItN2oLQ7dOQt9QROxzrkh1BkZ0jwURxP1uyPPBJn1bsRGViPUbJ8kM6XGVoigCfYvXLHET+Ckl1r9y+R4W2xgMCS73q/1Okdo07Jn4Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768343832; c=relaxed/simple;
	bh=e3CTtEWdP+YYk0zGKgbECMVxrxJeiEy35VeU8e0usYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Em0rFMywhAOcq1ZugZnpjyEJb3iE2GBhAi9M/iuhFcDnfqiL7iGjGTY5guY7620K9Fi95pX5uPQ481ArA88OzBJqtxecjmNO3S9cOULJZDhziFUAO/xDO5Hp95zYqkOUiqLUppe8dO/NXEI3hCXInbnWX6BxRaFmeqp/AXK3iBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZTjJgzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZTjJgzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744CBC116C6;
	Tue, 13 Jan 2026 22:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768343831;
	bh=e3CTtEWdP+YYk0zGKgbECMVxrxJeiEy35VeU8e0usYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EZTjJgzlvfioRepLNfbiKbV1N8Ug+xze0gtWzyvbyFxpKv95a782K2SskkGdEa4TL
	 Ug3fR7DR8iRKQSJ+cNcFQHWfHIFXp00CdqZtf+Itq/Kc4fZ0B4c+56AJSpQPRqFTyT
	 ESoWiEExlyisKrOZEZjW8TRBMK5ycWnxdfvIx4YlTVLIJKGM3dzdH68OPxedREBTGs
	 CYKF6qSlNNQHTatHhJrFyWu5/IaDctzsNEE8MjQ8mgnV28jY9kc7Q8QQEOofcU0b+W
	 GNkcgetxB9M0pCT/0Buy/vYi6a1vOd6R217wGFoee0ChPm6iZUE681mKPV5teutY7g
	 STJrtLkoIRkwA==
Date: Tue, 13 Jan 2026 16:37:10 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: gregory.clement@bootlin.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, andrew@lunn.ch, atenart@kernel.org,
	linux-mediatek@lists.infradead.org, krzk+dt@kernel.org,
	davem@davemloft.net, matthias.bgg@gmail.com,
	devicetree@vger.kernel.org, kernel@collabora.com,
	linux-kernel@vger.kernel.org, sebastian.hesselbarth@gmail.com,
	linux-arm-kernel@lists.infradead.org, conor+dt@kernel.org
Subject: Re: [PATCH v2 2/4] dt-bindings: crypto: inside-secure,safexcel:
 Mandate only ring IRQs
Message-ID: <176834382993.367039.14372601260257226212.robh@kernel.org>
References: <20260112145558.54644-1-angelogioacchino.delregno@collabora.com>
 <20260112145558.54644-3-angelogioacchino.delregno@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112145558.54644-3-angelogioacchino.delregno@collabora.com>


On Mon, 12 Jan 2026 15:55:56 +0100, AngeloGioacchino Del Regno wrote:
> Not all IP implementations of EIP97 and EIP197 have the EIP and
> MEM interrupts hooked up to the SoC, and those are not required
> for functionality as status for both can be polled (and anyway
> there's even no real need to poll, but that's another story).
> 
> As an example of this, the MediaTek MT7986A and MT7986B SoCs do
> not have those two interrupts hooked up to their irq controlller.
> 
> For this reason, make the EIP and MEM interrupt optional on the
> mediatek,mt7986-crypto.
> 
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> ---
>  .../bindings/crypto/inside-secure,safexcel.yaml    | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

