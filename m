Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529A8222584;
	Sat, 31 Jan 2026 02:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769827888; cv=none; b=Ez6xSaNACloVycVUFVSIindIubx5qCytQvg/AOhoihOnuuDH2HIeJFnQJmS+lNFnwdTttupcZuzaSs/B0GFluAD9o4+4JQRflJrM63OBubBJ3UBgnwzS0Cdv/virMtKmyFXLvlyXjzc5hxEBALZwwiGOFF9jUb40BbbAZRZ51/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769827888; c=relaxed/simple;
	bh=bHtsEUFlKu9dWfeTzceBy5JF8kkATwdj5MzNf8BzKjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DAnuPD5wD9lET7m8o1xK9JL7NoF7lDX8eCvXVeDKVAAA5Sd8qDBY4LXSiBA22Vil0XW0R/zpZvFAHUrQBOsQUFgd1iNeXbNFoVMveydOEFjWTtb2t+dy/4NETroK55tNvbOBsRAbYUIvux75BxtrImu2OW6hTmucrg+0Dold6/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cIwTeMe2; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cIwTeMe2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=XwTZvf90Q0/ZiQiDf033n6HLd/eCmwjI8aHKLe2j3RY=; 
	b=cIwTeMe2DGawNVZAcxX0uzCavRFgi/KseVVkwhC+A/0rDViJdToutcIHhByMlTM/Q0AyukeNKl1
	JijFga/DzGXHxO3FJTB3ANo9eCPIpN02+DA0aJP+TGAKarU/fya9VC+KM8QZwosrOor5Q1rPC32ER
	Td0x3B0nBvJwF2T01UOjLkZxfWbYqcJmUJWaJjUjO5vE/CGGc8nhN/+FfSlQJ68FUj6MEU/hyr44V
	+qHAmTXdB9iEyo5or6PSNFf3aUh3Iy7aC60/JBd/RazXhvVHcEIwGT0BBS2J8zGZea2BGKzf+f5Cy
	lKITDUh7vXOjSvBnnkTIS6rYAJ+9JCYnjHDg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vm14p-003RvN-2X;
	Sat, 31 Jan 2026 10:51:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Jan 2026 10:51:11 +0800
Date: Sat, 31 Jan 2026 10:51:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: krzk+dt@kernel.org, davem@davemloft.net, robh@kernel.org,
	conor+dt@kernel.org, andrew@lunn.ch, gregory.clement@bootlin.com,
	sebastian.hesselbarth@gmail.com, matthias.bgg@gmail.com,
	atenart@kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, kernel@collabora.com
Subject: Re: [PATCH v2 0/4] Fixes for EIP97/EIP197 binding and devicetrees
Message-ID: <aX1uH28_Zd1i-d_A@gondor.apana.org.au>
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
>   arm64: dts: marvell: Add SoC specific compatibles to SafeXcel crypto
>   arm64: dts: mediatek: mt7986a: Change compatible for SafeXcel crypto
> 
>  .../crypto/inside-secure,safexcel.yaml        | 22 +++++++++++++++++++
>  arch/arm64/boot/dts/marvell/armada-37xx.dtsi  |  3 ++-
>  arch/arm64/boot/dts/marvell/armada-cp11x.dtsi |  3 ++-
>  arch/arm64/boot/dts/mediatek/mt7986a.dtsi     |  2 +-
>  4 files changed, 27 insertions(+), 3 deletions(-)
> 
> -- 
> 2.52.0

Patches 1-2 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
