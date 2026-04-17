Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E901A682C;
	Fri, 17 Apr 2026 01:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776388289; cv=none; b=cK2URNwOY0Zw0JcZjzRl2g8ph9BDYueCtLzL2iuE0WutcaPq+ui1ECThmrTNWsfQph3YMuNrE/E/QjZngxMi1uLOb5EaFGk1tzoLki1R1LRU0El+5l4Ip86OtFw7ovUrijRGLkPFbvE9w11NC+k5kXHH3iNrJexvlpmltRgOwyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776388289; c=relaxed/simple;
	bh=WMSMos5iVbUo0mZwfTJOl5aWrEDlEy5VqJeLIp3vp1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t4CkvcDlwDKpPhL9O6DGOphMi9NY4D3xdoxoouklLJFL3wjQZp9LbKqIjIE+8NQExlXhzqFXHZpRg5PQWMLQq21X9g2NoDapmKA0R49gtaO7EABe0tK22vKXA19PtFnWcn0uaoil15Q8Hf704axDB7pnnWWf0SED1nPsYpd8BT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=nO19NUGo; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="nO19NUGo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=jiH9B4PEmmh2Yk95Os0y6miFjBZpZjOMuVtNsfFJLlE=; 
	b=nO19NUGoRksLkXsDGvp7ABK27LOtxeLoKjDczc26MH9n3fh9NG5jcXWnvnxEEhD96LEoVUwjuvJ
	JbMwZQJXzhEW0CpSKAeVOlBvaDvGcshbFwdC/NHBvILFBbzG5i9eqXWk3YbYEgb80vbEP0+RR0prp
	LuMX0PV6k6a0XOXvOyjuVLntIWjfDNj4wpEgQo26VsZANSE5/TT661eyW7lY+dXDUBKqXEPYKLAE/
	hEaGi1CiYvNMf5kzS4R5Etcl/pWKHCmIU85n7g5Kj4XiD8XFAAn0n3pY5GdKmhgLA7R4WdAZVIWCE
	SgYrZy77EoDSgA7WiHqt4YWykUYy+/p8g8gw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wDXjk-006gpl-26;
	Fri, 17 Apr 2026 09:11:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Apr 2026 09:11:12 +0800
Date: Fri, 17 Apr 2026 09:11:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	linux-crypto@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.1-fixes 1/2] rhashtable: add no_sync_grow option
Message-ID: <aeGIsGi9fBqu9EZT@gondor.apana.org.au>
References: <20260417002449.2290577-1-tj@kernel.org>
 <aeGCMkdg5Fgv8UMS@gondor.apana.org.au>
 <aeGElQ-TcCclEHwo@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeGElQ-TcCclEHwo@slm.duckdns.org>

On Thu, Apr 16, 2026 at 02:53:41PM -1000, Tejun Heo wrote:
> 
> Oops, that's a mistake. I meant GFP_ATOMIC kmalloc allocation. kmalloc uses
> regular spin_lock so can't be called under raw_spin_lock. There's the new
> kmalloc_nolock() but that means even smaller reserve size, so higher chance
> of failing. I'm not sure it can even accomodate larger allocations.

We should at least try to grow even if it fails.

> Another aspect is that for some use cases, it's more problematic to fail
> insertion than delaying hash table resize (e.g. that can lead to fork
> failures on a thrashing system).

rhashtable is meant to grow way before you reach 100% occupancy.
So the fact that you even reached this point means that something
has gone terribly wrong.

Is this failure reproducible?

I had a look at kernel/sched/ext.c and all the calls to rhashtable
insertion come from thread context.  So why does it even use a
raw spinlock?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
