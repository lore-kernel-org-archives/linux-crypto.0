Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59D41FC7CB;
	Wed, 14 May 2025 21:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747259758; cv=none; b=c01bYTcTIPO4FWjyKuXc7C0h0VlrnFl6g91k5K7NsZkYHHRkMX9K53EDMkJ4n7wbLyci0Xhh2RwicbZlJM/DKiRHzSayT+DLHS0qZzh/1tlYhku3Iq2K1TE+A+ZlIltdwZAh9Undsat2PIC2XNeVOeACXyWBqUFcGUyToCgzLfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747259758; c=relaxed/simple;
	bh=B9AnOxBtfLbjXRuIemT0SPiTgpAkH53dyjMLTG03uJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G4l6Qn33bMRu6bc2vA8tbg4/DxJ4ELa91Gx+UnLMeNs+HP7m46Rv5NwOek80ETh2FmK+lRkpZXTwMHLCG4193JYGwgsdMAJGAY5oLb8SzLhPuwZQhNW5/gkmqYsk64xzINTXbU+RDpr+2EmD4c4Op/VjaIamDXUiWGdePpjDNn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8MVsKQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8MVsKQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3FBC4CEE3;
	Wed, 14 May 2025 21:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747259758;
	bh=B9AnOxBtfLbjXRuIemT0SPiTgpAkH53dyjMLTG03uJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W8MVsKQkHOYg7EXRVD3ZDrSrO2k+hAlBFUJKCHvJ2fV+xipeA0DOsJnGHNQC06Bym
	 mDkzxwrtQgzVIr/O546cxLfSxSfhB6PJfNtDoHISvjUMshzvyovV7P5iM3Y9r4t3XJ
	 6dx7CBqfp6qF2seWxnY6DYrDT9uSjpvhUq9vgCqGSxBBvaWg1aPVRrDOl1EZhU6VfZ
	 ySsLVyfW6TgIpMQiT5aFHdPvCMsFq3RlQ/ez703BwVrbIzInvkx2QRXIVhYPWaSl6n
	 vJCnywafz84hvTTnvxTJkQoFO1FXNOzbuGt53PdvBWm3cUyb+ZrmWh8gPb1p6OcM92
	 BV/RbuekkgRjg==
Date: Wed, 14 May 2025 16:55:56 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Ryan.Wanner@microchip.com
Cc: linux-crypto@vger.kernel.org, claudiu.beznea@tuxon.dev,
	conor+dt@kernel.org, krzk+dt@kernel.org,
	linux-arm-kernel@lists.infradead.org, olivia@selenic.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	herbert@gondor.apana.org.au, davem@davemloft.net
Subject: Re: [PATCH 4/9] dt-bindings: rng: atmel,at91-trng: add sama7d65 TRNG
Message-ID: <174725975592.3107278.8713820681723567309.robh@kernel.org>
References: <cover.1747077616.git.Ryan.Wanner@microchip.com>
 <68e45a56e70e0b0b001870905917e8f7ddac61a3.1747077616.git.Ryan.Wanner@microchip.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68e45a56e70e0b0b001870905917e8f7ddac61a3.1747077616.git.Ryan.Wanner@microchip.com>


On Mon, 12 May 2025 12:27:30 -0700, Ryan.Wanner@microchip.com wrote:
> From: Ryan Wanner <Ryan.Wanner@microchip.com>
> 
> Add compatible for Microchip SAMA7D65 SoC TRNG.
> 
> Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
> ---
>  Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>

