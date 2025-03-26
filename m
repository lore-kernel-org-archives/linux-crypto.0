Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8C71A0BDB
	for <linux-crypto@vger.kernel.org>; Wed, 26 Mar 2025 13:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742994482; cv=none; b=nHUlSccWiqqQg5mf7NhIo28iSlqDwfz4IC3MWpgl7+y0/Qw9MHZBQSxOOunaS78JCSSMrAax6/dmES/UKXfutnlXAOU+LiKtsBdQLAs9p2fvYq+STtErn/iwaXc8WwF0GdMTvYqegur9mnr9FF0pj4hZo1+98TBecMUC//AWCvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742994482; c=relaxed/simple;
	bh=TmDa0KU2rbE0lKHscOTJOnqg0t+9XyFiT/lQE5B3d4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CiKvBKJKE4HC02WinnV84WuyzUdA4MlRKAI4ZO+vZi2d8wE5NqrYtgeazZMyWVgiYyGAtosFM32boKLPDybWYTd0iQ8EhKZM7c77humAquVHi4xTlChkNdrze+nAOqOj63Zc1NBeaFC/tWfu8kDfIhjs1PHg/JIOPpXoM8jaEe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DIvcn/hz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DIvcn/hz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pGyjcCATZkBu1lQY561/vfUCRz/FTwiQWknkgaO5wi4=; b=DIvcn/hz6qJjyP25FVNfGeK8XZ
	hlRvFcX5fo7ySLHjK7ipDg+pjYG4iDk+or2ONLsVHuZ9JVtPSvbMJpNUHbFOoXlQyrqb81eBxrQov
	wChgizz72q8PR494ul+x627QwFeeg9gf77ncEfwA6VnjfiW6rNPDHQi9nD7M4cgE2tvZXEgCK2QKp
	9v1IXzQCxfGmpeVW+7Cm8i8YcW4m/mH0wlQ/huXmQ5oufSdrKqoPWVlMAnV+wXET+S53QSuKs3hX6
	+em0JdBj0AcRNpTcCqSqqVFfSJW8MqdJmE5LnY5vC4jkfrwNofWjPNrcKSolnIX3x6sIw/wmH/bR1
	eXVDt34A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1txQU7-00AI1l-0J;
	Wed, 26 Mar 2025 21:07:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Mar 2025 21:07:55 +0800
Date: Wed, 26 Mar 2025 21:07:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Manorit Chawdhry <m-chawdhry@ti.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>, Udit Kumar <u-kumar1@ti.com>,
	Pratham T <t-pratham@ti.com>
Subject: Re: [v2 PATCH] crypto: sa2ul - Use proper helpers to setup request
Message-ID: <Z-P8K81SPGsicNh-@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
 <Z-P78_9NKGMBFs3s@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-P78_9NKGMBFs3s@gondor.apana.org.au>

On Wed, Mar 26, 2025 at 09:06:59PM +0800, Herbert Xu wrote:
>
> This means that one of the filler test requests triggered an EINVAL
> from your driver.  A filler request in an uneven test can range from
> 0 to 2 * PAGE_SIZE bytes long.

Make that 0 to 16 * PAGE_SIZE bytes.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
