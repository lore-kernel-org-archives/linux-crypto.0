Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DF0A47
	for <linux-crypto@vger.kernel.org>; Sun,  9 Feb 2025 00:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739059631; cv=none; b=ryutnZVlLxVHuvBu99vfaNgKt/HSETSFpEAc5k6mMt08Q5+ACJLp4DzrCDgS1c79xqkbrDKyesTJj/WHwpm2wKwrk1W+FArD/2WKqjFDnQaH3rzcWML5vsNmsDlVt/aITMWE7cch6I6Cs/P0czxn0IwLkNE8zLLnh6TAJ4sQIzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739059631; c=relaxed/simple;
	bh=Rnod+Cv9JGN27bc74JTeUwsZwKe+/eQ5wUgORPxiuzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6avc0QzDLsGlrOC/nk8U5u9nAnK0HrK+IObRKkzA/VVzDDh6k41v5z5oAlDwBmTw9TR3RRDEHF0GGShO9jAjQf9BfcyXG+0eSD8lkZtm9t8QNFfzRxCN2EOmjr8Xf89XjlkOXZaJ8PD2FBUi2Tp8IPntIIkUbCu4Zavk8MeuEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=SR2TmtIo; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="SR2TmtIo"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 04481240103
	for <linux-crypto@vger.kernel.org>; Sun,  9 Feb 2025 01:07:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1739059628; bh=Rnod+Cv9JGN27bc74JTeUwsZwKe+/eQ5wUgORPxiuzc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:From;
	b=SR2TmtIo67z05s4kxF0Ofa2/igGTbKkcbZPByXWXy8i6zm9KWjhNMQ/3Vaqi5EU6A
	 JkqODKQmGafdbjTgaw6zvXIjbwCea1icwXx7XJkKGwDvjrw6cOwzih3KjdBWDEkmeQ
	 TAV2d8GBB+HcI8v0XRjQ89eked08X5Fnl4rHWmiAxvOraVLYfkyXf4raGqN9z9w9Gy
	 VmloYIu+RyuefxPplg8tyDFctF4eRcBdw1kFlC36JnybCRp/IEQgKYg+M3g7QvpWUG
	 ohkM9bj5pnzu735rDicaTmq0dj+A2G8d9R/pUbzadWaJ8mfgVociMnpq9oukqQgHOv
	 /dTErrwHPl7Ag==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4Yr7LD23pfz6v0D;
	Sun,  9 Feb 2025 01:06:59 +0100 (CET)
Date: Sun,  9 Feb 2025 00:06:59 +0000
From: =?utf-8?Q?J=2E_Neusch=C3=A4fer?= <j.ne@posteo.net>
To: j.ne@posteo.net
Cc: devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	Krzysztof Kozlowski <krzk@kernel.org>, imx@lists.linux.dev,
	Scott Wood <oss@buserror.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Lee Jones <lee@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?utf-8?Q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>, Mark Brown <broonie@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-watchdog@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-mtd@lists.infradead.org
Subject: Re: [PATCH v2 06/12] dt-bindings: pci: Convert fsl,mpc83xx-pcie to
 YAML
Message-ID: <Z6fxo4j5a6ro0f1w@probook>
References: <20250207-ppcyaml-v2-0-8137b0c42526@posteo.net>
 <20250207-ppcyaml-v2-6-8137b0c42526@posteo.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250207-ppcyaml-v2-6-8137b0c42526@posteo.net>

On Fri, Feb 07, 2025 at 10:30:23PM +0100, J. Neuschäfer via B4 Relay wrote:
> From: "J. Neuschäfer" <j.ne@posteo.net>
> 
> Formalise the binding for the PCI controllers in the Freescale MPC8xxx
> chip family. Information about PCI-X-specific properties was taken from
> fsl,pci.txt. The examples were taken from mpc8315erdb.dts and
> xpedite5200_xmon.dts.
> 
> Signed-off-by: J. Neuschäfer <j.ne@posteo.net>
> ---
> 
> V2:
> - merge fsl,pci.txt into fsl,mpc8xxx-pci.yaml
> - regroup compatible strings, list single-item values in one enum
> - trim subject line (remove "binding")
> - fix property order to comply with dts coding style
> ---
>  .../devicetree/bindings/pci/fsl,mpc8xxx-pci.yaml   | 115 +++++++++++++++++++++
>  Documentation/devicetree/bindings/pci/fsl,pci.txt  |  27 -----
>  2 files changed, 115 insertions(+), 27 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/pci/fsl,mpc8xxx-pci.yaml b/Documentation/devicetree/bindings/pci/fsl,mpc8xxx-pci.yaml
> new file mode 100644
> index 0000000000000000000000000000000000000000..57c5503cec47e6e90ed2b09835bfad10309db927
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pci/fsl,mpc8xxx-pci.yaml
> @@ -0,0 +1,115 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +
> +$id: http://devicetree.org/schemas/pci/fsl,mpc8xxx-pci.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Freescale MPC83xx PCI/PCI-X/PCIe controllers
> +
> +description: |
> +  Binding for the PCI/PCI-X/PCIe host bridges on MPC8xxx SoCs.
> +  See also: Documentation/devicetree/bindings/pci/fsl,pci.txt

This is obviously a bit wrong; I ended up putting the information from
fsl,pci.txt entirely under the fsl,pci-agent-force-enum property, but
forgot to remove the reference to the old txt file.

> +properties:
[...]
> +  fsl,pci-agent-force-enum:
> +    type: boolean
> +    description:
> +      Typically any Freescale PCI-X bridge hardware strapped into Agent mode is
> +      prevented from enumerating the bus. The PrPMC form-factor requires all
> +      mezzanines to be PCI-X Agents, but one per system may still enumerate the
> +      bus.
> +
> +      This property allows a PCI-X bridge to be used for bus enumeration
> +      despite being strapped into Agent mode.
> +
> +required:
> +  - reg
> +  - compatible
