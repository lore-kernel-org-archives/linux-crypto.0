Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907802DA762;
	Fri, 17 Apr 2026 07:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776412308; cv=none; b=sXacqjv20zpD48fXY3KwuuVAB+Wsb+DMusJh44/530gwc7Wg3WvKQZIUVZ+j0kskPVtDouEFTdZIyzmv5lXhoyPgnt+8ezYl/tE3dSiOzVoCIqhYhfnXiMfJP7iSM7vmy9EvieqkwrW+S/VEADCgaVWrV4wKe8ccxgCuBny3atc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776412308; c=relaxed/simple;
	bh=XDpFdE3oVxDXK2rAt/ZVLQzVPJuoIOfluQJ5LNBdXj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HiVs0OXrCl2hToa8MLhNdw6iGBS3loYsrMfBG5CqKpEFOJydD8T8u4tzT3q16o+3Xrf1THlxuMzSY8hmA8f8YmVj1A/gg9hvUtSDnHAawrqD6LHWY0E+WLlLjz8N4GoBFGd6LyZS9V9gQLkAWU+IRvAa4dAr8M1uM8Rjc9Q5OSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=pYCLsWGg; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="pYCLsWGg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=MFx+6P24sUjVA8e9kWaqWgUD8PuMXmCy9x6KoXX4A6Q=; 
	b=pYCLsWGgm5T2zg9CezVsDBgn4DuYCw79KYigJuoexvezfAPpImC/Eg7eH2pTOSlGxBgDXcfPTXK
	qwf3dsJxXc/hxqrCdnf+QBCzUaQVkxYfTJ87kmvMT8/kPa2Qec5oDCXxMF6+BKhYCUs4Kfah5XJhe
	79C1WTxvTjOUlmVoZAEIBehDnMPEOkKSk5lX5GFg/SHddvaTcM1X4gnP1HmxivnmdkisItFgoQGCf
	5iKibBovajPDLuscDuZC6mcv5MQ8VS4JteLa813axqSfczy1n1Q7q/JCww5J2eXRofPfjo5cKWAgT
	m9Ipa/RyD3wNd3ijJGVn0et4WujfmPXMaGyQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wDdyy-006kYV-2Y;
	Fri, 17 Apr 2026 15:51:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Apr 2026 15:51:20 +0800
Date: Fri, 17 Apr 2026 15:51:20 +0800
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
Message-ID: <aeHmeAz-Z-Rx2MqX@gondor.apana.org.au>
References: <20260417002449.2290577-1-tj@kernel.org>
 <aeGCMkdg5Fgv8UMS@gondor.apana.org.au>
 <aeGElQ-TcCclEHwo@slm.duckdns.org>
 <aeGIsGi9fBqu9EZT@gondor.apana.org.au>
 <aeHjjGEhlikSsxCX@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeHjjGEhlikSsxCX@slm.duckdns.org>

On Thu, Apr 16, 2026 at 09:38:52PM -1000, Tejun Heo wrote:
>
> Also, taking a step back, if rhashtable allows usage under raw spin locks,
> isn't this broken regardless of how easy or difficult it may be to reproduce
> the problem? Practically speaking, the scx_sched_hash one is unlikely to
> trigger in real world; however, it is still theoretically possible and I'm
> pretty positive that one would be able to create a repro case with the right
> interference workload. It'd be contrived for sure but should be possible.

rhashtable originated in networking where it tries very hard to
stop the hash table from ever degenerating into a linked list.

If your use-case is not as adversarial as that, and you're happy
for the hash table to degenerate into a linked-list in the worst
case, then yes it's aboslutely fine to not grow the table (or
try to grow it and fail with kmalloc_nolock).

It's just that we haven't had any users like this until now and
the feature that you want got removed because of that.

I'm more than happy to bring it back (commit 5f8ddeab10ce).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
