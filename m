Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42CE2773F8;
	Fri, 17 Oct 2025 08:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689053; cv=none; b=bUrteJPOx6gOislKdAuEdjwEdr9Fw/W6zr6NaSir1qprnHid4A+rXGL63c51fWfD8DEWsX8WlHF9cF5Np6yWMLUz4+2E4DLpOiGqxgW/10m2skodii+WUDE8R4u61edOqApEo5HT+BNIJKTU8ihdKvAsocJazdVznOhfSOrP430=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689053; c=relaxed/simple;
	bh=+PYM39Twc/szISPmAYiB6H0ndq/jpjYkUMdbfEeBidw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=evJLF954k5YU72NQS8k63QL4TBGBvzWnqtep9EoDBG53nv1Fb2+XgSebpfF61ewh4OoB6MdFV0LIr6p736bdiXxvmdd4ZFUDMfQ/2UHCADwYk38TAlq8EA0Rnpbi4eo9J6i5pflNLsPK2sBvfqLIBQhQEdjRdDE7PUiMPiZYyUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=fokktwOv; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="fokktwOv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0kTgle6u9fm0sJzXddOabsq9uoagx6McwvKCZsvp3tU=; 
	b=fokktwOvKCGaFhEnU9gD79d7LggqwGIIepD8t6X7z9MrHeGmp9nK/FHMqtLsuUpAVqLK9cMpeO+
	rsszNN2Ptn83nmuXUZrIGAQykzvf789SQtzd3gaf0Nh3rqu/4XZrnQ6z+56z1HeXd7PD3Y2LlLnZ4
	WXMnRezQgBtBE7L5oVBn5qHBq/knHWThclQfPcOOnXZ857+bIaQl1ECuQyKdrN45Q5QZcUTrYwfhl
	x/L4ijQv4p8w5nihbDpOWHU3RgrrS/BvZ7PEudn80FBxMB0+T6/On/SKQkRJMVAoZUraUrJHj0meB
	wF5+aUsFaPPaU2PJn6eal8RdyxDR1n0beS0A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9feG-00DMzA-29;
	Fri, 17 Oct 2025 16:17:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 16:17:16 +0800
Date: Fri, 17 Oct 2025 16:17:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kael D'Alcamo <dev@kael-k.io>
Cc: Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: rng: microchip,pic32-rng: convert to DT
 schema
Message-ID: <aPH7jK7lxUFeXldZ@gondor.apana.org.au>
References: <20250923093330.31649-1-dev@kael-k.io>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923093330.31649-1-dev@kael-k.io>

On Tue, Sep 23, 2025 at 11:32:34AM +0200, Kael D'Alcamo wrote:
> Convert the Devicetree binding documentation for microchip,pic32mzda-rng
> from plain text to YAML.
> 
> Signed-off-by: Kael D'Alcamo <dev@kael-k.io>
> ---
>  .../bindings/rng/microchip,pic32-rng.txt      | 17 --------
>  .../bindings/rng/microchip,pic32-rng.yaml     | 40 +++++++++++++++++++
>  2 files changed, 40 insertions(+), 17 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/microchip,pic32-rng.txt
>  create mode 100644 Documentation/devicetree/bindings/rng/microchip,pic32-rng.yaml

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
