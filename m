Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560420;
	b=OhG7QZ16EgEKf0pfWQw8ufYKKRm+ZYiaHpUkX9j7xS46UUlLJMLEM7RH8xspVurYIF0T
	 ekNCp9Oevp8AXRv6/u5QQFH6WXPZs/mrCEc2FqnyYO35V7mZuyII25ZcPJfr5WSXaDubU
	 FHVm4moHcQVvUzcxLjjk33fM7mSdwLtfquGuENf5slV1droKqPnRFxpQlvBOaZTkLqx4V
	 NlZ07+U+HR9yRfJhcWbk+uFIZG44yt9U4kZshrhxKl+EwXQDo3GaLRmdrBsvr/z8a9MFb
	 ijPSUa1CyZ5uHw8D5e+1PJVIX0wwrmgndaOfTLykiDvlMdLYofhZxhUQWbAOVsLQ7Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560420;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=dGrsxz1+ro/3rFfEAB6ci5C/H0ebR/cTy916rc0qDIU=;
	b=sy9+H1RFNvRzmbz0uKMEGEu9sa/xvYCqbrre575jx0UlWN6DlyyBUMEpSf4eA0igt3u4
	 gSv8WSOeqrrAIFN5sqEcy6RG3yNvF53MVh24eR/S5iJ1p8sf0x0xcQNqsJx2Nwf1lkuxP
	 9benZRboYFC1yrDrgnrgZsMeeWaYL1v+n6re+fQHW5PrSevkgBG7kMY4PB935sHBF1o1O
	 wNn1ygCY8eefS5GX2gh6hnXrz+UcWojTrMGIdxtbJa1uNjTfbLRleRDOqDfbv1yE7NFbZ
	 zg4ghCOKmwSdZ5n2Fd740RY68eo/ULTE44a70Cy3BL2Q0k/bjnU1y5520RJ1RhBmmyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=r3KuwrcJ;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CC4606A31F
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 05:26:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7CC4606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=r3KuwrcJ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=dGrsxz1+ro/3rFfEAB6ci5C/H0ebR/cTy916rc0qDIU=; 
	b=r3KuwrcJag+LO97GjON9zMqr9cYFrL5xFyJuuDEdXd3VjAJ8pRFBmWOSgpu6DMlRhjtK/M3rw24
	rv1dYVcJJYrGOrccBlhccruZeKaUeyOdpIpMPILGEB/CE/cvNkyACnvfio2iStiie3G7S6qXPCKvT
	BB4ah21I6ZLfrAwRoWS/ItH9U8qCLW04/PFwUKraMyZYP+ZxUfGPZQJGzEyuTvOWJkjV85af8rgre
	P+IThUI3nZ6tOgL9uSVR9Gv4x4J3TJqbLqEPupyP1pQIuUW8TaciJ5T1vsQsP2Qq6NTRG+aJx9ooL
	9XI3wewWhpkYnpIgcuUgw/fyln1uCOUzOISg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xJOqk-000000064GM-2HU8;
	Wed, 21 Oct 2026 13:26:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 21 Oct 2026 13:26:54 +0800
Date: Wed, 21 Oct 2026 13:26:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michael Roth <michael.roth@amd.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	ackerleytng@google.com, thomas.lendacky@amd.com,
	ashish.kalra@amd.com, aik@amd.com, seanjc@google.com
Subject: Re: [PATCH v2 0/9] crypto: ccp - Make sev_cmd_mutex more granular
Message-ID: <athNHhrMegveNJBU@gondor.apana.org.au>
References: <20261016041109.1778673-1-michael.roth@amd.com>
 <4snves2iefswr3cnswjllztvjwmm5mw72ns4krsbslioq6buaz@j3zovm5cmewd>
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
In-Reply-To: <4snves2iefswr3cnswjllztvjwmm5mw72ns4krsbslioq6buaz@j3zovm5cmewd>

On Tue, Oct 20, 2026 at 04:42:19PM -0500, Michael Roth wrote:
>
> Hi Herbert,
> 
> It looks like the above-mentioned KVM patches are queued for 7.4, so these
> CCP fixes would be needed to avoid the above-mentioned deadlock scenario
> with KVM.
> 
> Would it be possible to get these CCP fixups in for 7.4?

Sorry, these patches are too big and too late for 7.4.

If there is a specific bug that must be fixed in 7.4, please
post a minimal fix for it without including the refactoring.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
