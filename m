Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1C7341660;
	Thu, 29 Jan 2026 11:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769686565; cv=none; b=OlRVry9H+WSQbAW5ocbflMTOGXSQZj20uvSUkXH885aVQKxtuuya2lAKU4rSWSos9xQNXahov06YOTSbe6vxzjWxjYf2xDYBpSQ678sUtxtpxvqEOIyl4LNCzR1DKdt6p5bJxFocx+uqGYQ1HO3fcBBIkaAF/GhgWjmFAozrLLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769686565; c=relaxed/simple;
	bh=g71um/NffG96uDEK2tS+xb8H08+FWhLc/qNYIUd3MPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j3ri5UvSOKCqBfF2iGvIKaWiqrTyBTRFSvh/fRvGYGEhEz2o+dpPz2sDkWsGnfSIx0KZuFJQVIsLWV4Vme8xeFWO9/3zOnbvzd0q99KVv8Ur6m//AJ2jB0ld8aIWLNOmhQcA+OgjjyY82Tosb5IjAyXLcrqdnO4UliNUmNQ9YBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=ijF1bzsq; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="ijF1bzsq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Cna7e9KPKzT1F8wQyII968o0UPI5xSa/MlaeIKiS4Es=; b=ijF1bzsqaxZwhv/1phIjE+CMLX
	dcTvg4kT2B9ySeCv3UsE1u2QUa9ufAJeBBjvZnSjuwsFOf7FGRnX5+HKx03dnGSAtfXAIplLmxnp5
	GGErNH77Cp9cPpnQ3GVzZoDQbuCMUBBihUemGDsL8MAJ4bEVA8io9YGjT5Yxr2bE3KoF2zD3EEJfj
	HIm0vOBZfMn4gRZ+do58P2Rk8i9eGBG3TwCXgmpLQjZ0SdhNSi47igYab8kZDG5ig4fm5vuqm/1Gg
	k5SHJMcCnYNDyT4ySHnp+Z7C6ST5FNBIYASi7uKGgDaPR+I/+MkKgxM1ddCFPY3guzuIyIe5ohyP0
	FDm9N8Wg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vlQJL-000ueb-AK; Thu, 29 Jan 2026 11:35:43 +0000
Date: Thu, 29 Jan 2026 03:35:38 -0800
From: Breno Leitao <leitao@debian.org>
To: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 1/1] crypto: caam: fix netdev memory leak in
 dpaa2_caam_probe
Message-ID: <aXtGAS8goIlVr74K@gmail.com>
References: <20260120015524.1989458-1-jianpeng.chang.cn@windriver.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120015524.1989458-1-jianpeng.chang.cn@windriver.com>
X-Debian-User: leitao

On Tue, Jan 20, 2026 at 09:55:24AM +0800, Jianpeng Chang wrote:
> When commit 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in
> dpaa2") converted embedded net_device to dynamically allocated pointers,
> it added cleanup in dpaa2_dpseci_disable() but missed adding cleanup in
> dpaa2_dpseci_free() for error paths.
> 
> This causes memory leaks when dpaa2_dpseci_dpio_setup() fails during probe
> due to DPIO devices not being ready yet. The kernel's deferred probe
> mechanism handles the retry successfully, but the netdevs allocated during
> the failed probe attempt are never freed, resulting in kmemleak reports
> showing multiple leaked netdev-related allocations all traced back to
> dpaa2_caam_probe().
> 
> Fix this by preserving the CPU mask of allocated netdevs during setup and
> using it for cleanup in dpaa2_dpseci_free(). This approach ensures that
> only the CPUs that actually had netdevs allocated will be cleaned up,
> avoiding potential issues with CPU hotplug scenarios.
> 
> Fixes: 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in dpaa2")
> Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>

Reviewed-by: Breno Leitao <leitao@debian.org>
