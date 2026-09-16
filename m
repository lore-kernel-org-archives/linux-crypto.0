Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E33E3B7B7B;
	Wed, 16 Sep 2026 12:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563238; cv=none; b=s5G9hu7f9wviCU4wCp5MsfsQ7wzp6TCvfzf3G/bbXaNNSeFpnsYaYrXCiObqpaakI27dGzR4ZHq7jC2Lup/DbKBKRSYM6gTQaPPhWkl+9BMsmKIiiJCpQsCxlk9F3dfilZfSYw9lb2saAJp+G8o6Djxgc6bXEOJ1E0BeLRWplQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563238; c=relaxed/simple;
	bh=SMgzNYx5VatGkXZ1gT4DF7kHMDMRw80erbXnSQxCoWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJwY/lZ1RzUNfT3q4bwx1OThf45eGoMs5m2IFD41gujAbPmn1cpsO5YP0Jaxos1+OdfyGrYFP/U4EVkMmbveD5lcCvvA3+nESNXmQwZNrERoPy7dWINIk1qZnZZQ2zTAFUZJTPibROTFTq9ldBBrFrZxp2wxEJNHVbprOJjhC2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=bA9oBbaR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="bA9oBbaR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=payEqoM1tt7cXO6DPJ23pvWYjxDt/TMkkk/2jV3eSmc=; 
	b=bA9oBbaR538zvmY75y7VkC3r6IzWRP51+euLRh29gg+M0XCrbcW+CiqSGe2bsQYeoEo0G3WweWB
	zgWvCnFv3IHHoKGD15FI0HyMuDsfFHclEOg5Vnmj72t6Ece5z5Ny8GBZ0VGlLiCPGo8ALSnasUnO2
	rboWcAFapExQQeII4/5XbQcj5nyM2YTX9WVUwkHAN9j2AWlujzFY/b6r9Otmz0amgYJsJA28+rZxy
	BTDCSPu7EsDwtwRXGpACoUp5TYR9ep+CKt+x5Xhg8ijxt4fHNq2NiXYKKyptcey/hPVPt7PFbUs4+
	aNygkQoLXABMQ4oTP2M6y9d3wGivE2hVtexw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6p8p-0000000EcYS-0e8d;
	Wed, 16 Sep 2026 20:53:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Sep 2026 22:53:35 +1000
Date: Wed, 16 Sep 2026 22:53:35 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	George Cherian <gcherian@marvell.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] crypto: fix typos in comments
Message-ID: <aqqRT6L16_qBpYuM@gondor.apana.org.au>
References: <20260904114345.27509-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904114345.27509-1-hemanth.selam@gmail.com>

On Fri, Sep 04, 2026 at 05:13:39PM +0530, Hemanth Selam wrote:
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
>  drivers/crypto/atmel-sha.c                       |  4 ++--
>  drivers/crypto/cavium/cpt/cptpf_main.c           | 12 ++++++------
>  drivers/crypto/cavium/cpt/cptvf_main.c           |  4 ++--
>  drivers/crypto/cavium/cpt/cptvf_mbox.c           |  4 ++--
>  drivers/crypto/cavium/nitrox/nitrox_main.c       |  2 +-
>  drivers/crypto/ccp/ccp-dev.c                     |  2 +-
>  drivers/crypto/ccree/cc_buffer_mgr.c             |  4 ++--
>  drivers/crypto/chelsio/chcr_algo.c               |  2 +-
>  drivers/crypto/hisilicon/sec/sec_algs.c          |  2 +-
>  drivers/crypto/marvell/octeontx/otx_cptvf_mbox.c |  4 ++--
>  drivers/crypto/omap-sham.c                       |  4 ++--
>  drivers/crypto/qce/aead.c                        |  2 +-
>  drivers/crypto/s5p-sss.c                         |  2 +-
>  13 files changed, 24 insertions(+), 24 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
