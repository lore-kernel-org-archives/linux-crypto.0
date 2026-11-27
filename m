Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795756294;
	b=JDoj2wfPmoeU3+0BvCCHHxFlCf433tIOdfqpChEqsyASZ+lrQ2z+L85TkpogRK6JjUUN
	 aAUU1JHBfiWcElCNz9FPjp8k1JK1AF7n+na+h4BfQ1s2N96jrIQC5dg6bS3lgvO9GlSzL
	 6k/iiTniwkmssiPXzA+C1NyjVLEnT2FDjrgMwC4oCEQdNkNj5TtH2PdQXKQuf+VW2nGZa
	 I/nJB7zE42EMefbpNpwuyUpkr3NkiDklp7uRtfntm7NWUZPQOCtxqszJYiPvd7X15h9NA
	 y1tagXrm0Z36Zfc2bZthd1OtQPsNGgFzoKVa9N6yMpWNGwCwdm9da7FoK7X0QQUZgaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795756294;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=BWeIVNtTSNDyXmhmr6LacoSacMJqlDEYelTTFeu08S4=;
	b=irJyfKyKxuzUUL4CU7RnTf3j/wyC37buOXw0+jCFpA08dZMbqN8VqcOh1A+GeOj+YH8Y
	 umHQL/RkkL7k7kMZVIAyujjVBn6oga16bqaXM6awdZgS4mVBEaHJNIezliDdE5y5BFANx
	 71i5ThKdTcDowfDRUgx2A8gq0OBks7RW1cCbwAfSeYYadggifJ2XLm65sZA5SCC0aRE8Q
	 TLucG9Kr3loo/ZZ4XVbAjktGAp/LaHTA+niWrZkFVRrfsg5ttX9MXSffwNg1S91Wcbq25
	 sanqWX9BtVZumqdKoPoIrhK37XuKEIeit6PG9sYOGsihPX84qbwUFHCpwmAqscbtagA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=dHCspOf5;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9EB606A321;
	Fri, 27 Nov 2026 05:11:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C9EB606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=dHCspOf5
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=BWeIVNtTSNDyXmhmr6LacoSacMJqlDEYelTTFeu08S4=; 
	b=dHCspOf52cJuDdawis5490OczscbZMJq91vSiFU8xFehA9Te4YM9qfVr1n4HfULFPeWcovq4NSF
	1KDZi98D35aXC/nLJGilhT4GjVFnuzpciYPZ28VIPMv/jubmt2AEM7I6tVRagsw+Ei0j3l6v1V6x0
	i7O9NvVty0qKSCsm1HLbJ5nuhRWviSsuH6fKg6pfeL9+nrDUy+OFjLHFyx5fNwPap9PnNi7G3LEtp
	/LcYDamwvOh+38DJBpD51JpIp0OSOLdipAUSugMCXa+4DrlY21xfGKskXP5Hs1WRAcItxOybctgtL
	HenLhT22dlMGpXvuD0R0oucpAk+gMPeZjtPg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWoF8-00000002VTs-1nIq;
	Fri, 27 Nov 2026 13:11:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 13:11:30 +0800
Date: Fri, 27 Nov 2026 13:11:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kim Phillips <kim.phillips@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	Rijo Thomas <Rijo-john.Thomas@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ccp - unwind PSP sub-devices on partial
 psp_init() failure
Message-ID: <awkRAsqMd_x6tQQP@gondor.apana.org.au>
References: <20261116203622.615371-1-kim.phillips@amd.com>
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
In-Reply-To: <20261116203622.615371-1-kim.phillips@amd.com>

On Mon, Nov 16, 2026 at 02:36:22PM -0600, Kim Phillips wrote:
> psp_init() initializes sub-devices sequentially but returns immediately
> on the first failure, leaving earlier sub-devices registered. Its caller
> psp_dev_init() then sets sp->psp_data = NULL, so the later
> psp_dev_destroy() on unbind bails out early and never unregisters them.
> 
> Non-devm resources such as the /dev/sev and /dev/dbc character devices
> stay globally visible while their devm-allocated backing structures are
> freed by the driver core, giving a use-after-free if userspace opens the
> orphaned device.
> 
> Add reverse-order unwind labels to psp_init() so each sub-device is torn
> down before the error is propagated. Every *_dev_destroy() is already
> NULL-guarded on its own psp->*_data pointer, so skipped or unreached
> sub-devices are no-ops.
> 
> sp_init() continues to ignore the psp_dev_init() return value on
> purpose: a PSP failure must not fail the probe, as the CCP can still
> initialize successfully.
> 
> Fixes: 33960acccfbd ("crypto: ccp - add TEE support for Raven Ridge")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-0de87f0c-0f5a-4dad-8ef1-f49844eb4cce
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Rijo Thomas <Rijo-john.Thomas@amd.com>
> Cc: Mario Limonciello <mario.limonciello@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
> v1: https://lore.kernel.org/linux-crypto/20261021215716.1076732-1-kim.phillips@amd.com/
> 
>  drivers/crypto/ccp/psp-dev.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
