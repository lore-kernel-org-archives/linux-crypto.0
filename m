Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46875179647;
	Mon, 26 Aug 2024 13:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724680250; cv=none; b=fySmLf3VVgUjIsYExvorT1fcAxnYYbLmuDnATfO3O6nrXtZsOsBIiRBmBsvrDhaTcaekDqdFyB0olMyiKhil/Z5yxHHnqDX7CsJWJvdiUIAOBHMajgzzoE5UmA3JfkN92zallDjmC8gGh92YHxqoQ8+BW3Czy4v91AizNJirx0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724680250; c=relaxed/simple;
	bh=3wcKQRoEo8FMvT0tRhB90fjTIKRp8q5ysFETw691w5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbNLIxQpNqpq/hIsAdEAilbhLdWCY3dYiw+8bh65/ntiRiz39sRIxx5IaEU22oJHw6PFr0cLfuPQrZA2LkCL3vAyYkA0SEK3r5WN36gBx9z5yJXMrpW4jU3ztmove0C8B89JqHXWOa/6K0EBhJhwz3vTuGWFZoBeiAgsBh1waAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qGcLDUmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qGcLDUmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3653C52FC7;
	Mon, 26 Aug 2024 13:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724680250;
	bh=3wcKQRoEo8FMvT0tRhB90fjTIKRp8q5ysFETw691w5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qGcLDUmuNTlSpIq1qHQpIoPDJNNVelf4oqQrkK+t6xXt1kizdmDaEEkowCPaYli9P
	 Vgf2ciaBgChFiju1IlLBLSFR4TuPDrxM/BLsgg9iLXhJRuKFFKjqFYfAiJ5chYg5CE
	 YBwj7CGcQb0z6ZHmcqHstLB/7+dH5UMAi8XLl7t2Qoc1vUpknbDrpRvWc+0FDDwskF
	 CFXN+W/eDWd4Ec3stRW7oAl0ZJDx4HUMKUJJZtNP7CJRWgRUk2rXFNJK0chrHTIznF
	 onKo2fEFV3Pp/ANi3YNqrKcxtm4sAh5vpZL9xxXRvVooEEVd8QbRBV/y0wzsz0S9Fz
	 DgRdpS9QsUEag==
Date: Mon, 26 Aug 2024 08:50:47 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Alexey Romanov <avromanov@salutedevices.com>
Cc: robh+dt@kernel.org, linux-crypto@vger.kernel.org, clabbe@baylibre.com,
	neil.armstrong@linaro.org, jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com, linux-kernel@vger.kernel.org,
	linux-amlogic@lists.infradead.org, vadim.fedorenko@linux.dev,
	linux-arm-kernel@lists.infradead.org, kernel@salutedevices.com,
	krzysztof.kozlowski+dt@linaro.org, davem@davemloft.net,
	conor+dt@kernel.org, herbert@gondor.apana.org.au,
	devicetree@vger.kernel.org, khilman@baylibre.com
Subject: Re: [PATCH v9 17/23] dt-bindings: crypto: meson: correct clk and
 remove second interrupt line
Message-ID: <172468024695.61392.174903956615697419.robh@kernel.org>
References: <20240820145623.3500864-1-avromanov@salutedevices.com>
 <20240820145623.3500864-18-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820145623.3500864-18-avromanov@salutedevices.com>


On Tue, 20 Aug 2024 17:56:17 +0300, Alexey Romanov wrote:
> GXL and newer SoC's uses the DMA engine (not blkmv) for crypto HW.
> Crypto HW doesn't actually use the blkmv clk. At RTL level, crypto
> engine is hard-wired to a clk81 (CLKID_CLK81). Drop clock-names
> field from schema: name "blkmv" is invalid and "clk81" is confusing
> and sounds like something global.
> 
> Also, GXL crypto IP isn't connected to the second interrupt line.
> This binding is useless, there are no users of this line.
> We must remove it from dt-bindings.
> 
> Fixes: 7f7d115dfb51 ("dt-bindings: crypto: Add DT bindings documentation for amlogic-crypto")
> Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
> ---
>  .../bindings/crypto/amlogic,gxl-crypto.yaml           | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

