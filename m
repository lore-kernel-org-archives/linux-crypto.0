Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E780233149;
	Sat, 18 Apr 2026 00:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776473091; cv=none; b=DyCz3dgSYjaIi6vizPTZRXBQYO8Go/bGDTX0i/39iyqK8bFTOfLDRQaZv9O1AsB20767de2hmHGGXkrpJYmsHsjIDiunYFOQL5lJi0ueU2yrDdVt1r2s8J08JJR3ROCZ2TNwFfSoUTOCeaN9zv4G94Cg+65PFxycKyZE5QOEE14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776473091; c=relaxed/simple;
	bh=Nuo+88UCa0iaS8POzDSfIe7BxGr6Mgk7Sb1LXPAofjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5wmZb+thTTIOZf7v3IbMOWagHtn+Js1JngUEaVxm2pTRoNwOZDtm+31D7Rp8Dd0kggDNbbxlL4yYlAHWYQ0JEz+eH4OxmG2JQW0q2jYpMH37NYH+FTRs99WTlaRz+TA5Lg06iuUVDEzSqyxidJGfJl75AEHl+ZGhM3shRKUEo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ZcM/QZmE; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ZcM/QZmE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+pbjrHcX/jlzfZusT22ubU6pu9qES5VlBik4giyg9B8=; 
	b=ZcM/QZmEBd8ZsMmw67SXueej2Gt8RhJ1WRTqXnbMCxn0sLk0EJiLYoXDCN5LbY3K+pxwZkdI4Iw
	XRcqcyynyKPdezTLlOOuvG3I20K3RGSyRkbWg50b7ozTYn4X8NJb9xbAoFztj29nISt+/Y9el5uyf
	qLe5Hh8F98sCmdHtgaUnepYdxSbpv12quIV7EaF2/YHleX/zSGa1adbyhAzPOpG5pHb0ApvSDupNC
	SINqEaY6XLFCMpfvq2WAC8vEyOV2ROZwj8muHwsS1GqXrcfQqU3JgymSpOZHfssgu2LvhrPtjCVLF
	Q5x2I1sW2HWURnYHcPtqkp4i8qNI4A9tBTkg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wDtnV-006vp5-2t;
	Sat, 18 Apr 2026 08:44:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 18 Apr 2026 08:44:33 +0800
Date: Sat, 18 Apr 2026 08:44:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	linux-crypto@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	netdev@vger.kernel.org
Subject: Re: [PATCH for-7.1-fixes 1/2] rhashtable: add no_sync_grow option
Message-ID: <aeLT8eB_xfzLxqbI@gondor.apana.org.au>
References: <20260417002449.2290577-1-tj@kernel.org>
 <aeGCMkdg5Fgv8UMS@gondor.apana.org.au>
 <aeGElQ-TcCclEHwo@slm.duckdns.org>
 <aeGIsGi9fBqu9EZT@gondor.apana.org.au>
 <aeHjjGEhlikSsxCX@slm.duckdns.org>
 <aeHmeAz-Z-Rx2MqX@gondor.apana.org.au>
 <aeJe8oIyYUi-NtCQ@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeJe8oIyYUi-NtCQ@slm.duckdns.org>

On Fri, Apr 17, 2026 at 06:25:22AM -1000, Tejun Heo wrote:
>
> That'd be great but looking at the commit, I'm not sure it reliably avoids
> allocation in the synchronous path.

If insecure_elasticity is set it should skip the slow path
altogether and just do the insertion unconditionally.  So
there will be no kmallocs at all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
