Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B8218CC15;
	Thu,  5 Jun 2025 17:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749145624; cv=none; b=JmjOer6vJ5R4Jh58ebRZ+lz1+gL6cwHcksNFUpgXxqvcScszXe9hNJJ3JFhicgfEfsxGnH6ASdLDjGslSfq2jJ2HDXMkdE8qcpyujaS2MEeCAlCj7vpBCoO7Vvc4cedj7d8qxgvVX3gOdDHxqEa5l4e2TcdOEojO3paEfWEaw68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749145624; c=relaxed/simple;
	bh=A9RpDTJfroy6Nf58gs7nteWyYIb6O/JiEfFMidvPV4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dDQVw1ODuERSeqzqvzMSYaHnLnCZ5Z6ErBO6BjwMT6yzIb60PXQdOmVqZNA5Tzq/HwDDi5ww48EyX8XRlnpO2WrxGcD99/1qcDafX7VgOcoPL82kdtKnmRPQwVv5OV3jI0kK66ebwQS3H2upQW7GJkK3BPFWENBjt42rtFbij0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oALIow4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oALIow4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8295C4CEEB;
	Thu,  5 Jun 2025 17:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749145624;
	bh=A9RpDTJfroy6Nf58gs7nteWyYIb6O/JiEfFMidvPV4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oALIow4+z7B1COWINlhhGxNrlechLn0+VV9GIwo5q+nxNL7LRD876BkqYHWUx9ulK
	 k8EkcdVm3QfUgoUTNICgJ0KHnC23wmPwLJgZaagQJKnrj0l9k8kFskWm9AH3Nam3/3
	 +yw5MdLL7iazit8LwiJvQJr1M+6pwtiqUclZc5pwSCpF0sqVPLI3l7lqDK7tADKam7
	 b1QNVMjAnnQfI5MgNEUpNgA6QN1elXWlkx/FQqtP5kTo4JQFQmVstsHP0HJ2hDzpgo
	 AF14Os6Qrw4qWwJsVIfl7OGXAw8rf5lM3poqUf8O7NnvrO5KKLgS7nHlRlvdVaqH0D
	 sPq3bgZvWRy9w==
Date: Thu, 5 Jun 2025 12:47:02 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: John Ernberg <john.ernberg@actia.se>
Cc: Conor Dooley <conor+dt@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Gaurav Jain <gaurav.jain@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
	devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
	Sascha Hauer <s.hauer@pengutronix.de>, Frank Li <Frank.li@nxp.com>,
	Fabio Estevam <festevam@gmail.com>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	"David S . Miller" <davem@davemloft.net>,
	Pankaj Gupta <pankaj.gupta@nxp.com>
Subject: Re: [PATCH v4 3/4] dt-bindings: crypto: fsl,sec-v4.0: Add power
 domains for iMX8QM and iMX8QXP
Message-ID: <174914560256.2922686.17606744758003855636.robh@kernel.org>
References: <20250605132754.1771368-1-john.ernberg@actia.se>
 <20250605132754.1771368-4-john.ernberg@actia.se>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605132754.1771368-4-john.ernberg@actia.se>


On Thu, 05 Jun 2025 13:28:02 +0000, John Ernberg wrote:
> NXP SoCs like the iMX8QM, iMX8QXP or iMX8DXP use power domains for
> resource management.
> 
> Add compatible strings for these SoCs (QXP and DXP gets to share as their
> only difference is a core-count, Q=Quad core and D=Dual core), and allow
> power-domains for them only. Keep the old restriction for others.
> 
> Signed-off-by: John Ernberg <john.ernberg@actia.se>
> 
> ---
> 
> v4:
>  - Reword commit message (Frank Li)
>  - Add explicit imx8qxp compatible (Frank Li)
>  - Move the job-ring constraints back to the job-ring section under an
>    'allOf:' to avoid the warning from v2 (Rob Herring)
> 
> v3:
>  - Fix warnings discovered by Rob Herring's bot
>  - Declare the compatibles correctly (Krzysztof Kozlowski)
> 
> v2:
>  - Adjust commit message (Frank Li)
>  - Only allow power-domains when compatible with imx8qm (Frank Li)
> ---
>  .../bindings/crypto/fsl,sec-v4.0.yaml         | 41 ++++++++++++++++++-
>  1 file changed, 40 insertions(+), 1 deletion(-)
> 

With the indentation fixed,

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

