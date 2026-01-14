Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A1F37F112;
	Wed, 14 Jan 2026 08:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768379569; cv=none; b=AIFuflPUxYlAWcYpz+FYElcWaVAl7Hhhisg9uW8tBlICtPGjOCoQkAX/kkyIQQrwiIDeUZ+9yWCiKUr/k2TU4NeOBr7TWBzVMAm/ahUZs5axLRp4ye0j/jOVX95fhfjncvRW4HSoXu04s1H9JkKBFzRjvtcC6XYz5py9QQI1Mt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768379569; c=relaxed/simple;
	bh=6+qWrmtEe5KQBvisLBZsta91oEBPrK8AirW4JBB7LyA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=u0bOh4jIfDhZTVwgmTdel01Jw1hjnm8Df2L7TShF1B9oBOriiylpbOF/SvvDODAd3sPB5I7Uq6RbsJNztr/wKmmgabybG8DxoqO1cCkpxOUg9uB44d8zPAAo2oYIJ4wEaumY5gQoViAQ5MrBcGN2jEsuAeP5X7HP7wLYy08TYss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=hzgD7Syv; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="hzgD7Syv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1768379564;
	bh=6+qWrmtEe5KQBvisLBZsta91oEBPrK8AirW4JBB7LyA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=hzgD7SyvgGbS/tl4+IohuHJDQfoJgwHdw5s07scxDXp5Lw6jB9V4Kla+pW4W8QxiF
	 3XdXkjyAiAGyWjdQOvB0e5943LNinneSN9NWQNIZA2Vv7UMXRKIHfJhHsclm5gTrC6
	 7pADv65jEe1olikyATQzxQH5xtzDnMYVJXJ6lC9ZrMGE4Q62Ck+CuLp3Dzhu/pO0nH
	 g1GS9pNv2dv4QL9uYil9952buTWsoRtyDkygGYTTfVRm+Z8yQ2GWf4TYKk2LyIjCMS
	 GA289INV4CQp7rHOSmiCSLo+E08iV5ouXdWcU/jvy+8jSnT9cXMMi8UWSRmbbzw3Oe
	 RH6EZa9IJ5BzA==
Received: from IcarusMOD.eternityproject.eu (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 50AF817E1513;
	Wed, 14 Jan 2026 09:32:43 +0100 (CET)
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
To: krzk+dt@kernel.org, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, robh@kernel.org, 
 conor+dt@kernel.org, andrew@lunn.ch, gregory.clement@bootlin.com, 
 sebastian.hesselbarth@gmail.com, matthias.bgg@gmail.com, atenart@kernel.org, 
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, kernel@collabora.com
In-Reply-To: <20260112145558.54644-1-angelogioacchino.delregno@collabora.com>
References: <20260112145558.54644-1-angelogioacchino.delregno@collabora.com>
Subject: Re: (subset) [PATCH v2 0/4] Fixes for EIP97/EIP197 binding and
 devicetrees
Message-Id: <176837956327.8998.5572106308125358940.b4-ty@collabora.com>
Date: Wed, 14 Jan 2026 09:32:43 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 12 Jan 2026 15:55:54 +0100, AngeloGioacchino Del Regno wrote:
> Changes in v2:
>  - Reorder commits
>  - Change to restrict interrupts/interrupt-names minItems to MediaTek only
> 
> This series adds SoC compatibles to the EIP97/EIP197 binding, and also
> fixes all of the devicetrees to actually declare those in their nodes.
> 
> [...]

Applied to v6.19-next/dts64, thanks!

[4/4] arm64: dts: mediatek: mt7986a: Change compatible for SafeXcel crypto
      commit: 32c5491a8d73713578560f515cccd4e9460d156d

Cheers,
Angelo


