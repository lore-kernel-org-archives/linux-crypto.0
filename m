Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A403339B2D;
	Sat, 31 Jan 2026 03:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769828451; cv=none; b=k5Fa2494fgrpo1tCLiM5KvjgPfSbTKnzfcGVm8UCygaW/qKRypivY7Mx2hliLpb0z5/tHki4/QFmqmFvtcAqhRoGybsUmnnCe+gw+1hRHzpSe096jzcfd/FrX7ra8UmhQg5gmSRVbZDiAr09zRR7DnROUhBrktHxyP657xG+hss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769828451; c=relaxed/simple;
	bh=vyhdPq+00pK5gGS6nxCAyyTaC105FugOLxef1Ad4+YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=thEDHvXhTGw90hTicNO76rC8XCI/C20So+olxq27rh3yjc/u6yurCGP0Z3eGDTwhh0fOKRwKyN0SGBDSKzjrWjWqAARaypKK4eg4lhT30hIZIJ/yO5AoXJQ6nxQoEEwG+xsBlbFvSLCkCT63BcJrWwve/APqTWQiadHwmA//RLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=AeqH+gSu; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="AeqH+gSu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=CdGrTvNhWeOpvhk+dviYYCXKhMM6anyNw+pMqO5L7D0=; 
	b=AeqH+gSueONnVahXlfnztD3GFSBtlIX7k46K3Y0HkFleRGwLCrzRx9gnX9LtIZfvm+PhscQTFWl
	od0v8z5IEKQ9D4mN25R/Lxvj0eniegUd7a2JnAsZ2O14oKWwI8jsErLMXgxlEIvweD1gd57L4r1IN
	+I+0rJCI+WitLuLh62APVFv9toM1AFser1WVlYfw2AtRB5ETKfm+YvL6RPrJb36Hbtt+ASlDmrty0
	YHovVlreLC8jBjHlnOhh6AHsMiN9wT6PjjW0vdaNjLdb38FJAqUjOijYbayAY+lFq8lubJSbLovfO
	CdEam/pcJ9HIRXaSs7QgO/n3WfyrCFthXROw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vm1Dq-003S4m-0u;
	Sat, 31 Jan 2026 11:00:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Jan 2026 11:00:30 +0800
Date: Sat, 31 Jan 2026 11:00:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	davem@davemloft.net, leitao@debian.org, kuba@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 1/1] crypto: caam: fix netdev memory leak in
 dpaa2_caam_probe
Message-ID: <aX1wTpxIAy2kSdpi@gondor.apana.org.au>
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
> ---
> v2:
>   - fix the build error with CPUMASK_OFFSTACK disabled
>   - instead of the movement of free_dpaa2_pcpu_netdev, implement it
>     directly in dpaa2_dpseci_free
> v1: https://lore.kernel.org/all/20260116014455.2575351-1-jianpeng.chang.cn@windriver.com/
> 
>  drivers/crypto/caam/caamalg_qi2.c | 27 +++++++++++++++------------
>  drivers/crypto/caam/caamalg_qi2.h |  2 ++
>  2 files changed, 17 insertions(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
