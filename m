Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE95C13EFFB;
	Fri, 26 Apr 2024 09:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714123929; cv=none; b=l8P1PDaxpnyRDJhqbPbuEFE8OZQG0nV5ce1LhThmDUPHXCKbR+1DY96GPYExMARsaXzUkR+jwEGtL0IxbOwjndFxHPxO726zvCkqeYlxjxOo9rbEaSqbhr2BLdtHWuwn9stxbPfJfYuagUIabj+1eBrBLFBAcjt24s8plQzY14M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714123929; c=relaxed/simple;
	bh=pwGoOCEqKkv+f3OCZ4qmdhgBMIK+ooWfHZcGOZErUK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MgGtbKsQAH4J35siz8tIHIE3bWwg5XG2gfpx7kvrRZjCMnq9wsWXeCa7hCo24jJ99AtWI1GKrPkwdc5GfBiWBmiAkEtcYo14TKcpyWfK4vIMihx/gxxO6+aO4kSMV9dUUlcNk71ZawmEAliER3aDLmLI4Li+xmgXsZhi8WB+23k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1s0Hvr-006eOC-02; Fri, 26 Apr 2024 17:31:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Apr 2024 17:32:09 +0800
Date: Fri, 26 Apr 2024 17:32:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: starfive: Restore sort order
Message-ID: <Zit0mewmCl3fPV68@gondor.apana.org.au>
References: <1b1bb24987409fcd7ea80940e92be2e9aa67ea49.1713282603.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b1bb24987409fcd7ea80940e92be2e9aa67ea49.1713282603.git.geert+renesas@glider.be>

On Tue, Apr 16, 2024 at 05:51:49PM +0200, Geert Uytterhoeven wrote:
> Restore alphabetical sort order of the list of supported compatible
> values.
> 
> Fixes: 2ccf7a5d9c50f3ea ("dt-bindings: crypto: starfive: Add jh8100 support")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  .../devicetree/bindings/crypto/starfive,jh7110-crypto.yaml      | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
