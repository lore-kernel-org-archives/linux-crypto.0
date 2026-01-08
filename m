Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8ED1DE8A4;
	Thu,  8 Jan 2026 14:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767883966; cv=none; b=WXwhGS/3VqARYo42Yha3dWXx/L7pbJoiMOjf8PpjCnuy9teSnIZrApRJ3YRnBbL71D95XrxdqkqVr+7RL/UpLIQpGfX6YixXC4AFbY57tmahQhacT98VdLt/FXBTho6SMfnkRKEmtsrcuAKQBuXLl4KQHBh1HwqnUZxmbOyLhFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767883966; c=relaxed/simple;
	bh=REctfFUcNFnjAlrVe1U10jUaKWccUMTijX0We6uL7+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=enTrHAryQ7PpkmqgQhPcg7gbPKBD3aT3/RbdOFbsVoMgowwJjQ1gtWsuU8r3J+bZr8f0ZxuEMPzC+jrM61YiaI4D+mgFTi8hYNlNJ+Wu+RC/AXAoEzx+1Z0e2pBVyBbG4Qs2AQ0dOQTmwZOu+7rL5cyi5fSrRhl+vx0xBAVSedw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=sfgH9SDD; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="sfgH9SDD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=5RMxX8fLudzgzeaK8Hxa/jVqGVI3C6mJxtJKkvtOXWM=; b=sfgH9SDDp9NHn9HDL2Qa5RRGQb
	aPYiNW/CMH3y50KuXB+F2eWH7m7hdmM0w52cPzR7Q1QsnMLcmcVPA7ahlWtSmWQUj+blZ58Vyb7si
	sqBUI5kxMY7in/N15dSdqgbEKH6i+xi3qVaSVfTxcHlkOsdfrXYghOf4y73nwWWFlNrU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1vdrNE-001xse-J5; Thu, 08 Jan 2026 15:52:28 +0100
Date: Thu, 8 Jan 2026 15:52:28 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: krzk+dt@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net,
	robh@kernel.org, conor+dt@kernel.org, gregory.clement@bootlin.com,
	sebastian.hesselbarth@gmail.com, matthias.bgg@gmail.com,
	atenart@kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, kernel@collabora.com
Subject: Re: [PATCH 1/4] dt-bindings: crypto: inside-secure,safexcel: Mandate
 only ring IRQs
Message-ID: <c65c2f98-7530-470c-b288-d135fd621005@lunn.ch>
References: <20260108110223.20008-1-angelogioacchino.delregno@collabora.com>
 <20260108110223.20008-2-angelogioacchino.delregno@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108110223.20008-2-angelogioacchino.delregno@collabora.com>

On Thu, Jan 08, 2026 at 12:02:20PM +0100, AngeloGioacchino Del Regno wrote:
> Not all IP implementations of EIP97 and EIP197 have the EIP and
> MEM interrupts hooked up to the SoC, and those are not required
> for functionality as status for both can be polled (and anyway
> there's even no real need to poll, but that's another story).
> 
> As an example of this, the MediaTek MT7968A and MT7986B SoCs do
> not have those two interrupts hooked up to their irq controlller.
> 
> For this reason, make the EIP and MEM interrupt optional.

It seems like the order of these patches is the wrong way around. You
should first add the device specific compatibles, and then update the
constrains based on those compatibles, so that the marvell variants
continue to require 6 interrupts, but the mediatek versions only
require 4.

	Andrew
