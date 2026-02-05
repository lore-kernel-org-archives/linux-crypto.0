Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D65823E342;
	Thu,  5 Feb 2026 04:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770265010; cv=none; b=k8+39es/d/6iqQd+1FSNLZ2hkuErYy5pRJa91O1wDBJAzlQuL/3J4A73Dh+OXYoz9NSTMnG9wmr5IWwN11Fhb7siMNpAunNi5U2RLcAC2VcvuTX9p+Z6YJw5APJIpDskORyLUPCssHsVBKvxKdhZUMXIc6cPze7RjXLDtSZ9oLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770265010; c=relaxed/simple;
	bh=iStc7w727bIhmrDAC/PSj9Kt4h2TaUKxIYmL3JhYKA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rLQsF7j71NhqNd94uATHK6nqTBytqPhVQK86hMC6sP34Tm538gi90ey8G9NOdALZnMQH7xtsbsNmVAFhQmOkrTibhONpd1UODVtmwGB5TDPh00NxUNh+2btyirv77WvoDlhRDWga38njcnja2dUpYqNpiqiqkrH9z3D/AgXmfO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=huepo6yn; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="huepo6yn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Lg84RfkI/0u9tfwUkwG5gebJADOIUofTA9PDMtsrLJ8=; 
	b=huepo6yn7ETjMtBjjbKxFX3j8PjAwq4ZQVDu//1Qwh4uhb0bHNJhF4rd+KETFBjmOOPeS5Uuh0a
	dLehGYzWbnRRzHRe92uWcd9H016ATpvdyoUENLZbKuOdU56yGfp68BGlQPCtJQHV72gTMgMP+xHVB
	l26hmYFRlTXufIlsW1JgAaS5Iy/C9cNdH32k4yQ4VF++6AwCKXqA+cHdgaoAoDQfpRHYu8Z1Zq58C
	E8wT/h9EQ4fBwiML3Y+3TgMk29n2zTxrBrE4DrJsgb6xgvJ/ZH7PPJtfdn+B3cLwy+g3Wm4YV7vbx
	zLWKORCZBGbAjo2NBBkvoUnlOgSZtdkwGYXQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vnqn0-004dxr-0U;
	Thu, 05 Feb 2026 12:16:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 05 Feb 2026 12:16:22 +0800
Date: Thu, 5 Feb 2026 12:16:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, senozhatsky@chromium.org,
	sj@kernel.org, kasong@tencent.com, linux-crypto@vger.kernel.org,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, giovanni.cabiddu@intel.com,
	wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 00/26] zswap compression batching with optimized
 iaa_crypto driver
Message-ID: <aYQZliax5c7-fVJm@gondor.apana.org.au>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <nlsqmn3x56ug7vfxw3vmpsmlyc6sie2plr22hpu7q6j7jq3adx@jbgg7sza67mv>
 <20260204103925.fd15632afc3bccc0ea8f500d@linux-foundation.org>
 <t6n4qhqpexui7gfzkdw6r4ai3pztt7qg45fc5hjg3qydodp77n@oh5k6pzpyjwa>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <t6n4qhqpexui7gfzkdw6r4ai3pztt7qg45fc5hjg3qydodp77n@oh5k6pzpyjwa>

On Wed, Feb 04, 2026 at 06:49:03PM +0000, Yosry Ahmed wrote:
>
> Herbert, are the crypto patches ready to be picked up? If yes, could you
> please pick them, then we can figure out how to route the dependent
> zswap patches based on the timeline?

I can take the first half of the series (up to patch 15) and
we can use that as the base for the next revision.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
