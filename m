Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60771E8322;
	Mon, 19 May 2025 05:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634353; cv=none; b=rA9haht3aGXIMzmnR19RXtzWI1dTiUVvNY6UK5arZtchgoZfPglPN6Sw5cKsLVzs5gX3HHqhfXpLDYUpwZTcbHvBabwFc0dRH/8MtB6FYcOZqTKSGyygnkCxVQ7tAIih4iD3o+wkoF19E3M7DnkS2rW558ZtV57g+KZcOz8WM1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634353; c=relaxed/simple;
	bh=n/dkDqn3wtmj9I9LnEjFD/UHDiubZwME3PQYi1tsRls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O5dKR6bwyVBW4W+eY8JLqrR6itiko/lTLPPVEYl558KH+eJvbqQ349H3rs+KWXU7TNlEcbhV2ohBDsjxDHrGetmSJIrZJAgr5UeZAbmembJrAonGEQyfbiMtk/VIbV4JbvhtIk60Mb+As/gtTuP+zEgz10L6CFx2MCJnp+ubN70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=N16puEtq; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="N16puEtq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+pzO567reKqYUr85nuYrYLMhA8F8krXVSp/XRKO6IOc=; b=N16puEtqWMnyIK00715C3QQw5n
	3Q3IyCgvsb7YfzpwbZpvmiKsOj0h7dzzPvkzxkbmf8X+onv+NUOtx+CB7f/YERJsjUPxH6tmEEyRq
	gC4oGF1FdmZZIeQ5GWkdQSzpEUgOggjFbcgHhh2tk78oPJC/QBysh2u8cnr8HTox/aTHODeYggGEu
	PXbE82sRQ/Fd0QwvRLwVKSBGWwJmdaH4wKJcXGJq9CNGuE17LD1Eg2GSyowdSd2uAg6up8FiW3+Zs
	wpxfAf7WXgz9XLXCDWP+4KJZaaFr8d7MgwpYTQhufJn4nJJuC3yGBcpr89pCyrNi30XYwMWHYrOvP
	vLUkHEvA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtWh-00782i-0Z;
	Mon, 19 May 2025 13:59:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 13:59:03 +0800
Date: Mon, 19 May 2025 13:59:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: fsl,sec-v4.0: Add fsl,sec-v6.0
Message-ID: <aCrIp9u4qoX_BLsk@gondor.apana.org.au>
References: <20250513184030.3051100-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513184030.3051100-1-robh@kernel.org>

On Tue, May 13, 2025 at 01:40:28PM -0500, Rob Herring (Arm) wrote:
> The fsl,sec-v6.0 binding is the same as the fsl,sec-v4.0 binding, so add
> it to the existing schema and drop the old .txt binding.
> 
> The compatibles in the .txt binding don't match the 1 user. Follow the
> user for the schema.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  .../bindings/crypto/fsl,sec-v4.0.yaml         |  10 +-
>  .../devicetree/bindings/crypto/fsl-sec6.txt   | 157 ------------------
>  2 files changed, 9 insertions(+), 158 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/fsl-sec6.txt

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
