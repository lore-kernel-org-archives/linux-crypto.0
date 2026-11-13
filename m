Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575486;
	b=eaVv9Ol4Ylp2JYmZIb3peY4zHhq7urLZk3c6LjF9Q05Uejw1Syram2RHP3D8H46t539d
	 DWudSwWgP47Z9LPkZ7aCagQI+gZHa+bT7uYH47mQvYJ0FDuesLIlDBzsgrg3rRrnFVnKi
	 /LYA/jFTToElbBRlOhUDcvCT8z4P2gv2ZIhRRzeh+FWv8VA/D1fPsDUrB8HByXphlVI8O
	 Kk1A74ID69GSvMKUkkB+DsoxXrkJOagafPMwLyyslKxXQwEnhvjx8zcgQKUV1MxaB1CKE
	 HgsSeQdtoamELh4+oKDqoyQote/usuMESpL6CaZtv8HNDJ8sjsk/T2VQAF8fOn0XbVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575486;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=U0ygKyLutILP/XtWeh+LVZtQfdAEhW04usgP+2QPJoY=;
	b=rO1pjSDn/5TooiQaMMLATTb5xikxUlZA0ZQ7gX7RtLfyzbmfjQHUmy9dAc9ie0taGs6b
	 nMyRtsk00jgoipBPB9yqrSbYa53HEj1tvY4UI5REHnz7T3KzZc1Bk0V1YmvcWPqK6zuxd
	 x16BzYOGdz1waTwWJVOTKEBK1HGfr8lFydgE7vObEc3ii0Ns2HU9SmQIIf2f+vSQhFhpR
	 zWOMSHT8O46NSJewUnnCaFjC/Mpx/VeDq+o109bEWgJsq5RFp6b6srXG+r2G5ERTsmxFz
	 Qd12orP/s7sWqnPNsVSJt5wke4gEE0JohM8nwzJ/hw4uK9DIxsMM2meC0HVMUP9iCfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=FQHXsfW6;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FE6606A333;
	Fri, 13 Nov 2026 13:11:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0FE6606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=FQHXsfW6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=U0ygKyLutILP/XtWeh+LVZtQfdAEhW04usgP+2QPJoY=; 
	b=FQHXsfW6A/lZ13C3f/x7iX9wJM4zgUp9cTH18l0OawuFvH2A/hIVKmCVIabC0KOACNNTNgOFpEc
	lW/oRvZ9po56s7phT+lDfDVLtYXOOdVTTOXUPOuhkU41JjTifH8GF4/GCuUsCZ+X4P9Ejz+qtoJO6
	RrgTVSjIdtsF1PPZbaklfyChr+cX7vrUKwnjjift+bjqDgjE7Sp2iUok+WHM17kMVHWKtUp75fd4q
	aqRb5GsFSbErpXSBXuJY/lk9ekUopwULyZSHt2bVVHt+KqKSedn/Ed9CsnE/EpYSTQB4GHhA9IRsM
	E7vIyEPTaGisJ4vClzzGC2R+Ow/P43BDwPWQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRr3q-0000000EfPV-15oM;
	Fri, 13 Nov 2026 21:11:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:11:22 +0800
Date: Fri, 13 Nov 2026 21:11:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Walter McKelvie <walt@mckelvie.org>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org, ebiggers@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: algif_aead - Allow gcm(aes) for privileged
 users
Message-ID: <avcMesCb2A70wzKj@gondor.apana.org.au>
References: <2e4c2648-72b2-4249-89d3-8dd111b84395@app.fastmail.com>
 <20261106043459.1169202-1-walt@mckelvie.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106043459.1169202-1-walt@mckelvie.org>

On Thu, Nov 05, 2026 at 11:34:59PM -0500, Walter McKelvie wrote:
> iwd depends on the AF_ALG algorithm "gcm(aes)", although iwd's own
> source never mentions "gcm(aes)" or L_AEAD_CIPHER_AES_GCM.  The
> dependency is indirect, through the TLS implementation in libell (ell)
> that iwd uses for EAP-TLS, EAP-TTLS and EAP-PEAP: iwd's
> src/eap-tls-common.c hands the EAP tunnel to l_tls_new().  In ell, the
> TLS 1.2 cipher suite table in ell/tls-suites.c uses
> L_AEAD_CIPHER_AES_GCM for the eight *_WITH_AES_{128,256}_GCM_* suites,
> ell/cipher.c maps that to the AF_ALG name "gcm(aes)", and
> tls_change_cipher_spec() in ell/tls.c instantiates it with
> l_aead_cipher_new().  Before offering a suite, ell checks that its AEAD
> could be bound on an AF_ALG socket (l_aead_cipher_is_supported()) and
> drops the suites whose bind() failed.
> 
> With af_alg_restrict=1 the bind of "gcm(aes)" fails even for iwd, which
> holds CAP_NET_ADMIN, so the AES-GCM suites silently disappear from
> iwd's ClientHello and EAP authentication fails against RADIUS servers
> that only accept GCM suites (common for eduroam deployments).  This
> contradicts the intent of commit 2f204fe718f5 ("crypto: af_alg - Add
> af_alg_restrict sysctl, defaulting to 1"), which was to keep iwd
> working under the default restriction level; the iwd algorithm list it
> was based on evidently did not account for the algorithms used by
> ell's TLS code.
> 
> Add "gcm(aes)" to the privileged part of the AEAD allowlist.  It is
> the only AEAD that iwd actually uses: ell's TLS code has no CCM or
> ChaCha20-Poly1305 suites, and no other ell or iwd code creates an AEAD
> cipher.  (ell does bind "ccm(aes)" once at startup, in
> init_supported() in ell/cipher.c, to probe which AEADs are available,
> but nothing uses it, so its allowlist comment is left as is.)
> 
> Fixes: 2f204fe718f5 ("crypto: af_alg - Add af_alg_restrict sysctl, defaulting to 1")
> Link: https://github.com/NixOS/nixpkgs/issues/583203
> Cc: stable@vger.kernel.org
> Signed-off-by: Walter McKelvie <walt@mckelvie.org>
> ---
>  crypto/algif_aead.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
