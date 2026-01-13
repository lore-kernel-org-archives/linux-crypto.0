Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A1A632;
	Tue, 13 Jan 2026 22:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768343816; cv=none; b=a4/C7w1EttqjjxQ6K0oKaH8RefYaati4XXmxPMz4Dfd5cF1Hlivf94IJ7zPlyIIbUqFyoquWA1jqmFXk3nDwadq+QX8IX9ayIVaiUjUwUWhSeBWLrfGuAFLy5ypgS7dpNdSjlloUknQZI8FCkF3KysHq698wBAZY+CmS0vVO9XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768343816; c=relaxed/simple;
	bh=KnVjavPiBn10fAwKoZ9AxMWWLrQDeyNt9CWuUHHMCaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kqqltx8zxChlXMw8J0MrxouT0ykmwW5osvIaSK0/uPJy0Ma44wGx+dAUzmEVg3jiHoeFc3fgoxsJ6Imac5tYt2H6J9VZi03FVCr/V61shxKXJq8yyCrnD0c8bCOGoyNnLpcf+ACBJIGRK+2KKCsBZRTCKLV5XN+Kv8HnJN/jtI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aEd1jP+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aEd1jP+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6461FC116C6;
	Tue, 13 Jan 2026 22:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768343815;
	bh=KnVjavPiBn10fAwKoZ9AxMWWLrQDeyNt9CWuUHHMCaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aEd1jP+3Ckz+Toi+4/j3sSrkYBiGUhlh3646PpYh8fwZotQDP44U2fcLomASRxzA4
	 ZJjIvL0zq7Bf2x/iH5LrGadET7fhRU16mfWwdxA685CK5VklFl5lhw7kl364Pd1viw
	 fv4T23vynYdf4HskNp5o4aFZtYgt252xTwltgpPVochev2I37ztbFuQS/7GHZw96/w
	 FaZl3/2LpUyi6P6eKIItQ5+ZEXv3LgX8HHy8DnagVtdiRD8s8LN6ci7HfpG86K2fSP
	 q7KoYDaN4Nlzf8QEQkT+3oBhN36h/L5dZpupb7FZSEcFgBZsSZsumH8m4nMH3iMU6G
	 Wuq9WJAjN2aSQ==
Date: Tue, 13 Jan 2026 16:36:54 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: davem@davemloft.net, conor+dt@kernel.org, andrew@lunn.ch,
	matthias.bgg@gmail.com, gregory.clement@bootlin.com,
	kernel@collabora.com, devicetree@vger.kernel.org,
	linux-crypto@vger.kernel.org, atenart@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	sebastian.hesselbarth@gmail.com, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org, krzk+dt@kernel.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 1/4] dt-bindings: crypto: inside-secure,safexcel: Add
 SoC compatibles
Message-ID: <176834381386.366633.8858781364146409753.robh@kernel.org>
References: <20260112145558.54644-1-angelogioacchino.delregno@collabora.com>
 <20260112145558.54644-2-angelogioacchino.delregno@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112145558.54644-2-angelogioacchino.delregno@collabora.com>


On Mon, 12 Jan 2026 15:55:55 +0100, AngeloGioacchino Del Regno wrote:
> Add SoC specific compatibles for the SafeXcel crypto engine,
> including one for the EIP197B used by Marvell Armada CP110 and
> and two for the EIP97IES used by Marvell Armada 3700 and by
> MediaTek MT7986.
> 
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> ---
>  .../bindings/crypto/inside-secure,safexcel.yaml           | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

