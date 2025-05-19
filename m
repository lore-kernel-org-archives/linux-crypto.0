Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523541EDA09;
	Mon, 19 May 2025 06:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634420; cv=none; b=KdnoLq/eD4Zy5H28A7nbykdDhQTDMQqfkY8/5m2Ji071ToyaVne0dyYc9AUfoKHoQsYrD2CfYf/N1v0dqT+khW0YpTj7gA00Mo7QYGriz6zE8qzLw2RPAbLtKkEMnSpNocKqc0IZD4zq0dG9FapaWKgZ5IF1n9hkx5CJgZHUt0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634420; c=relaxed/simple;
	bh=B4YsbQryJckvw6AmtFYh6SymNFMyUT0BIMu7Gyl/mm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTTnHU10n0pSiiq9T1htO+8TasfWZU2MNWFCFu2FpYiGOi53X0W0bbxd9JhnpjHFucyk7MsBdRSEbwaNyvCAT6ou1wEVX+gBYXtLyGnvTbi1B2M92Kb+ZEK1v+zYzDXE6KEbGWUpcIIWezMR6XNr3WODtzTCORT2g/RE8H4xYDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BVSbrw5r; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BVSbrw5r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1p3QHTNxrsteFt7LZOR1mu0APof0C2SHBn8WrMA9DdQ=; b=BVSbrw5rhI+A1eI1srFpI5x3+T
	efXRbgqPOO/7t0dZnN/Gz9J7xzoAL6QCfngjogIStp1D2UxOl4dbFkOjPQGe1Uq8gp+udS5l2IXIy
	X+fckz5xB6cS36Ym12IEba1QmdwBobZHLN5XxY9/xjVVVMOsa85REC2jNEGVPA4WSJ9DMuTO4Caph
	XzrmmHZv7bn6Cp+jTXvLkEijC9bmOzE3qWEQJE0A/0FBi2x9QhOlS0Pn+RJu+QWhznlhhS/Ccv0dC
	gCkJfP3TtnlolSCQSxWTzlYTCNGaLHSCZlPSmbtEbqkyYnrX1I0kiJ9kz1z23AZHKOKDjDDqUTt/v
	a323a7rQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtXm-00785D-2t;
	Mon, 19 May 2025 14:00:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 14:00:10 +0800
Date: Mon, 19 May 2025 14:00:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Rob Rice <rob.rice@broadcom.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: Convert brcm,spum-crypto to DT
 schema
Message-ID: <aCrI6pi4K2udVpX6@gondor.apana.org.au>
References: <20250513184103.3052055-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513184103.3052055-1-robh@kernel.org>

On Tue, May 13, 2025 at 01:41:02PM -0500, Rob Herring (Arm) wrote:
> Convert the Broadcom SPUM/SPU2 binding to DT schema format. It's a
> straight forward conversion.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  .../bindings/crypto/brcm,spu-crypto.txt       | 22 ----------
>  .../bindings/crypto/brcm,spum-crypto.yaml     | 44 +++++++++++++++++++
>  2 files changed, 44 insertions(+), 22 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
>  create mode 100644 Documentation/devicetree/bindings/crypto/brcm,spum-crypto.yaml

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
