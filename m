Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC4738DF9;
	Sat,  4 Jan 2025 01:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735953609; cv=none; b=Qi6ZyzM5fpX+JOWdnTJ4N//hd8fxTKxF8bnJM7DcWyxlupia7+r74UYThZV/Ep3osD+z9fpAKatqRWaj8PV/WQj/V984A4wUYx7VNG0d2a4grIYYAoPW+lGTinXybifZv5/ii9kIUPmrSKe3wgO9YPW+uBcXFKDW4HKxoG/fB5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735953609; c=relaxed/simple;
	bh=P8uXA07ddkGRUwsXjK0YZeChljl7pCq63QIWdF+SeqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sCHZMIPCrRrK5kRevlk4lm5HNYiGZDov6r42rsOjtwGwIut2zpY2dm88Mq1sxacFVbxHutI8OXhFSgI4qKkIBvzf63xYhbKfRGbQ7GfNz+RBIX/zxo+A3EY5LaqJoPjmEAzFnpk2VBX8QKuFDcjxIT0dnJyBUw7srlUOC09eugs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UvHdxhYW; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UvHdxhYW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oYI9tpm8yn2nfgtr7ozaD2EARJPCAcjw3C0HNMbYMG4=; b=UvHdxhYWlcZt3+Z2qW5fzQsbHg
	5lFYNgLPZUwrz9cZ5wX797YXyU5dy+po/jWz5lS8z8/qcKlTtJUx3F7hFwy7pGU68vBEQufVWGIYD
	+8FW4uRyDqLr+tbaD6N1n/3im+Voz5tcn8YC9PD3pRJxueVJNccC0YgBfdZKhd9eM/NOQ5eFdiXPW
	5XiLaoJGzzB4YRkxz9GJJ81K0z6rrOiG0cQ53swB54sI9VBc6ISXhwRvRiuGDXGZScuSV9dx8QK+s
	PoYUZAl18KuliedFesX7tjad3W6wssSX3rpXdAFFmhG6rcSMt4DIBpP3EUWvy3s07BC/hLeyw8tgm
	EGMJKxAg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tTscS-005fbZ-2N;
	Sat, 04 Jan 2025 09:19:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 04 Jan 2025 09:19:45 +0800
Date: Sat, 4 Jan 2025 09:19:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Dan Kruchinin <dkruchinin@acm.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: fix sysfs store callback check
Message-ID: <Z3iMsYth_EoiTmJ5@gondor.apana.org.au>
References: <20241227-padata-store-v1-1-55713a18bced@weissschuh.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241227-padata-store-v1-1-55713a18bced@weissschuh.net>

On Fri, Dec 27, 2024 at 11:32:01PM +0100, Thomas Weiﬂschuh wrote:
> padata_sysfs_store() was copied from padata_sysfs_show() but this check
> was not adapted. Today there is no attribute which can fail this
> check, but if there is one it may as well be correct.
> 
> Fixes: 5e017dc3f8bc ("padata: Added sysfs primitives to padata subsystem")
> Signed-off-by: Thomas Weiﬂschuh <linux@weissschuh.net>
> ---
>  kernel/padata.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
