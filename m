Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555BF14F135;
	Wed, 16 Oct 2024 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729099747; cv=none; b=FCJr6JhuT05JPzHjZlayLvTz2rzbOMfpa2oFPg41YMgGn5bl3YcA67HbmW8h2SeQdhc43ecZkCe7xlsGJmYYfAeY2/gm0Ky997hKKl05ptZjQON6/V9MzJc3O+tjgPd5DR9qRkRZzW4E/SEp3Rn3CGC1QsJkXgrIZPwprNpulcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729099747; c=relaxed/simple;
	bh=BW13X3BVPZ8dJHNzenWTM18AmsI72wIJFWJRFxPbA0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aFTb8n5t6uSlUZnLpTPZwb/VzgmpaN6+SHnNJ12zONPSNCfc0LE6in1j77wxcvYzHezevOhk/6Mg9OMqkiO3ngvkJo3Pv7ZZEuRKvMxp8r/65AvalLDur8Gf34jizUn+DHPu4dZT6fyrvKVC4JQdI+m8JabGU8v6va6BCKffnq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N/a6bKwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N/a6bKwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF607C4CEC5;
	Wed, 16 Oct 2024 17:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729099746;
	bh=BW13X3BVPZ8dJHNzenWTM18AmsI72wIJFWJRFxPbA0w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N/a6bKwSdQt80+PgmhqSCXpEJlLy1Kt/p6ix2RBJIjIjzLrBVYeNAdeL8JivXMyWz
	 G2lSzWlDR9whzWNn9f+uPWy96Ht2iPsPt1sfoZfQlEjSXrJakazkI3je8ttJtX06Hc
	 5iargpPCCPjnpkL6mwyeygX+e0d9Svw7ui7eqyFDnNwY2oqpUEykj541iT/W79Ms7v
	 8Ew1J4NNk8FWNuhslTqE233QgI/jwVmXVQ58DCHq814IA4tvSwDkslqNW+wrnTL28k
	 iTC/lIYGsK/s959v2qteA8TrDJzysBrZhH1CIPZcKVBBY05Nqit0pEoXYGK9pooGol
	 E6SQen2iKafZw==
Date: Wed, 16 Oct 2024 12:29:05 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	linux-crypto@vger.kernel.org,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-stm32@st-md-mailman.stormreply.com,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	devicetree@vger.kernel.org, marex@denx.de,
	Olivia Mackall <olivia@selenic.com>,
	Lionel Debieve <lionel.debieve@foss.st.com>,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Conor Dooley <conor+dt@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/4] dt-bindings: rng: add st,stm32mp25-rng support
Message-ID: <172909974498.2070654.12815494490287458504.robh@kernel.org>
References: <20241016-rng-mp25-v2-v4-0-5dca590cb092@foss.st.com>
 <20241016-rng-mp25-v2-v4-1-5dca590cb092@foss.st.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016-rng-mp25-v2-v4-1-5dca590cb092@foss.st.com>


On Wed, 16 Oct 2024 10:04:18 +0200, Gatien Chevallier wrote:
> Add RNG STM32MP25x platforms compatible. Update the clock
> properties management to support all versions.
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
> ---
> Changes in V4:
> 	- Changed the restrictions on clock-names per compatible
> 	- Removed a useless constraint on clocks Items
> 
> Changes in V3:
> 	- Add constraint on clock-names for st,stm32mp25-rng compatible
> 
> Changes in V2
> 	-Fix missing min/maxItems
> 	-Removed MP25 RNG example
> 	-Renamed RNG clocks for mp25 to "core" and "bus"
> ---
>  .../devicetree/bindings/rng/st,stm32-rng.yaml      | 28 +++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

