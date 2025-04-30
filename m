Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E747FBA2
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 03:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745983100; cv=none; b=lXVeKxshpPdC2yyJOrg9TF94YeXm9J3pmn80PCWC1MrSxmHHEItj8gzGVQE9EjDO81w24DZ08bJHPksSMc4/P90ThuJsS2RYmna7kZiwY/OogfHm5Ob33C0uzEDiQLH2Gjv7jFk1quVMeuRkyKIT0Godwzc+SEajlHPNaflK4ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745983100; c=relaxed/simple;
	bh=YkVGDjPL/E9Q9N82kZqGf5GT93xUBmnoiGBaz5ngWms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VnKFv641pw6Ko95Fy4WCvUSals6Qlz3WoyU5+3c1i5RW+HeTBAtPuy1al/TjqpuMXsTv7CpcqRjVqEOY8SivyfZXbttITvCmpKVZjxe9UPW1MrMD3s6hl6E1f+GBrOoFja1Ae8Spaq+qWbdbs0Dwd8RKIA6I4RiEbhsnXm0wVrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XWbrTLbS; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XWbrTLbS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aq7aBg7nTr2LWQxqediALytxPRYEe7a9W075nGgrtJs=; b=XWbrTLbS+KwjKUPsCyMJBw6KZI
	QLML7rpJVgtpM8VP8qFqx90u9MRhYtTQr901CZvZFROcS96r2kZCcuAStYQKakgeQ4mlYnvfTDcID
	VWZCEQgZsGxcMKauC676H+fnpdGKU32bpqKQDNXWQa9MhoxKfl8sPoaFKPfyuwDoc1SYCWZKKVyCn
	ptFZYzRD9D9nnTfZXIftA0VoX1La7hGYb1IyQv+D0yLNLOSFXmFrxt9IDxbJOxUaiD42rMY8WuCzl
	Axcxc8382sjleH8c0O9wtHxURMBkZigZs7YbTxEENWkP3Ll9oU6gtNnp2vVG1Qn3GFY2G8lKpkNI3
	lILgXL3A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9xxe-0029Dc-0J;
	Wed, 30 Apr 2025 11:18:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 11:18:14 +0800
Date: Wed, 30 Apr 2025 11:18:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/1] Revert "crypto: run initcalls for generic
 implementations earlier"
Message-ID: <aBGWdqS5KjgUkj3s@gondor.apana.org.au>
References: <aBBoqm4u6ufapUXK@gondor.apana.org.au>
 <20250429164100.GA1743@sol.localdomain>
 <aBGJR55J3hkFZvfJ@gondor.apana.org.au>
 <20250430031623.GA277467@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430031623.GA277467@sol.localdomain>

On Tue, Apr 29, 2025 at 08:16:23PM -0700, Eric Biggers wrote:
>
> If arch is really too early for arch/*/lib/, then subsys should be used instead.
> The point is that putting different algorithms at different levels would be
> confusing.

Alright I'll shift them all to subsys_init.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
