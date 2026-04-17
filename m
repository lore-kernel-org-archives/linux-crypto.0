Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B011619995E;
	Fri, 17 Apr 2026 00:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776387222; cv=none; b=Ms5gPBCXF7lZiPFpfAKPwtUtamgjGcqwHMNpFBvr5bq3w7iT/Dxjygm+cIkBwuaA2OlxdLjDM6h9pnzYujmYjC6/sRFmfEpNtjjhkxkntnNa38wJh1yinY8+rWGlln5ZlNbWZPjcHRUK6mBlDpE5JVi2tuyTGgkUiwNxOxGIjvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776387222; c=relaxed/simple;
	bh=8rkM/jOESM4F0Kq8fM+yDFPwKlvoOf0TFX6JyDkY1y0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dXGH3boLJE9peg0cS7yZ7+8jyHoM5sUqwqMsis8PWTZc3L4m1VO0q7nxz/u3GDjDHb34EW/FEE/xHCUYjWQHrCl/2mrbJGYT26cUeKlbGnw7DgIzSv3SEyyEG1cp0ISIDTqflnAkNLuCKwvGKgpRP1EuEBppC7/hgfOxi978sFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnzVoyBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnzVoyBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D23C2BCB3;
	Fri, 17 Apr 2026 00:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776387222;
	bh=8rkM/jOESM4F0Kq8fM+yDFPwKlvoOf0TFX6JyDkY1y0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hnzVoyBpG/lWJiJm8qmwRA+WXZp/vpvFvdDPi9J7t8EnTQ40K1oQ5xfFrBmkTGm4m
	 oAJlNhUol6SMSkYLvADCyE+7Lb1EjfnnJHi9kuoP7GoLldgaiu3QghkMTkM8bgT7ZR
	 +7elpI+X1UMMw4VICy05IdnQtX8ZyAA2UA9uXssdkurbebQOlMBH+7t8Gb7a5B2HAN
	 8dBPip1gGeRq/ZqL1fu0rM/f8p8BJ5A5ldUFk40RyWgVvVNmNropd0H7eknzYKk7Af
	 VKtpo/lHeVb9NsT6Or+eS1Vdj+b99IiXFIfziBQQYKtAvIh5L6FdZrRVUvc48ju6JS
	 mlKW3kBA1BOAA==
Date: Thu, 16 Apr 2026 14:53:41 -1000
From: Tejun Heo <tj@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Graf <tgraf@suug.ch>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	linux-crypto@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.1-fixes 1/2] rhashtable: add no_sync_grow option
Message-ID: <aeGElQ-TcCclEHwo@slm.duckdns.org>
References: <20260417002449.2290577-1-tj@kernel.org>
 <aeGCMkdg5Fgv8UMS@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeGCMkdg5Fgv8UMS@gondor.apana.org.au>

Hello,

On Fri, Apr 17, 2026 at 08:43:30AM +0800, Herbert Xu wrote:
> On Thu, Apr 16, 2026 at 02:24:48PM -1000, Tejun Heo wrote:
> > The sync grow path on insert calls get_random_u32() and kvmalloc(), both of
> 
> Where does the sync grow path call kvmalloc? I think it's supposed

Oops, that's a mistake. I meant GFP_ATOMIC kmalloc allocation. kmalloc uses
regular spin_lock so can't be called under raw_spin_lock. There's the new
kmalloc_nolock() but that means even smaller reserve size, so higher chance
of failing. I'm not sure it can even accomodate larger allocations.

Another aspect is that for some use cases, it's more problematic to fail
insertion than delaying hash table resize (e.g. that can lead to fork
failures on a thrashing system).

> to use GFP_ATOMIC kmalloc only.  Only the normal growth path does
> the kvmalloc for a linear hash table.  The emergency path is supposed
> to do page-by-page allocations to minimise failures.
> 
> As to get_random_u32, we can probably avoid doing it for emergency
> growing and continue to reuse the existing seed.

Oh, that's great.

Thanks.

-- 
tejun
