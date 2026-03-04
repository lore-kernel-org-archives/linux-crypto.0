Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EAD370D52;
	Wed,  4 Mar 2026 12:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772626908; cv=none; b=PUtDPJqumboJMO6sG75aV+fJPXnvT9O/Kr/WKzQ0JbXgMZ6Y/2X6EuiNeJaH3pQFf2mjPxAih7kKcbdOTUMO2+lgFaWuDSCVfQoxl2A5vq3fgE4dGHCzPuDztYFmP7MnyRo15m44npG0rCeM6XPzTgnpYkQ4BWFEcHq23bwgp6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772626908; c=relaxed/simple;
	bh=JDVXbq3eOC/zJw81WOQUnROLAFMCRFNMxbplwqDG3IE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBhMWFLNT694jiMYDBW5+T2ukLLAZdDtqEhT9XGYPFTvrKICR2Y0N5zjMN5ZvJw0oeJFRUZ3v8/wgS/qFfi3n1cAEnGZsZqzC8HvGX3/L4FdY8OI/aIMJtYT5X/gC2GIz7kX6BpK1IcZNFheh84xldnNVT7Eg1MdpFWtid70s9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1vxlES-0000000031c-25Dx;
	Wed, 04 Mar 2026 12:21:40 +0000
Date: Wed, 4 Mar 2026 12:21:32 +0000
From: Daniel Golle <daniel@makrotopia.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sean Wang <sean.wang@mediatek.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 1/2] dt-bindings: rng: mtk-rng: add SMC-based TRNG
 variants
Message-ID: <aagjzL4c-3jVuOM5@makrotopia.org>
References: <04622e0bc917aed4145a9a3b50b61f343fc89312.1772585683.git.daniel@makrotopia.org>
 <20260304-defiant-echidna-of-examination-b1e798@quoll>
 <aagiPIgoosVqsA0t@makrotopia.org>
 <8e685c37-afca-4f2e-ac0a-76a0b060805d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e685c37-afca-4f2e-ac0a-76a0b060805d@kernel.org>

On Wed, Mar 04, 2026 at 01:18:20PM +0100, Krzysztof Kozlowski wrote:
> On 04/03/2026 13:14, Daniel Golle wrote:
> > 
> > Starting with MT7981 and followed by MT7988 and MT7987 it is
> > technically the same hardware, but on those ARMv8 SoCs TF-A assigns
> 
> So they are compatible, I presume?

Yes. MT7988 and MT7987 are just like MT7981 in that regard.

> 
> > the MMIO range of the TRNG to only be accessible from within the
> > secure/trusted land, and TF-A provides a (vendor-specific) API
> > allowing non-trusted land (ie. Linux) to acquire random bytes.
> > 
> > With MT7986 they made the unlucky choice to initially allow direct
> > access to the MMIO range, but later updates to TF-A then also locked
> > it to secure/trusted land, offering the same API as on the newer SoCs.
> > So for MT7986 the driver has to try and figure out which convention to
> > use.
> > 
> 
> 
> 
> Best regards,
> Krzysztof
