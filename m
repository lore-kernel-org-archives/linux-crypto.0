Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230294B7A41
	for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 09:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789722078; cv=none; b=hWrkxE0xA5UlrJEiZ/JEsGhwovFx35C9Q0K855D59HrVeLvGnYGZmS6225l6Oex4eQoEPWR40q6uwyOzhfy5+9k5GgksC5QLDmrkDeeGxBDiJHCVvJ5yS67MqUoADH1NIqKkp07gxLgU3Y/DwUHBuIS86K7eakncKX++/ijtvNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789722078; c=relaxed/simple;
	bh=Mhj2VPVGoqV30jQRu+BMiHZDT5rwJGqPmU/oxpYq6Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=rOVTLoIbQZSEshdtlW8c2DnferypUpyVQRZlxHA3G7A4G9HO1lvOqqKiP2+nJTZkvDo9tDYIN+uEoeBUruRWt6JjCop9yGrappjjKbaaDwOKnG6LPYY4kcgJIgEuSUCuIw/f+7XRpLkK/dRc1yAYWstaWU+X5hSY4xfUCKT+fG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=c0+DEtIV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="c0+DEtIV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=E30ytcIGCqWOh2mjDmm+3IdyFGixePGYi0rWHmLp7A4=; b=c0+DEtIVxSX8OxtEwIpVLsYdjE
	IADMS3dGE3r2OA0yV40jYCCFi58H4xaL2YJu5hP2wyM/ElA1+fW8ka2OZkbYSOePnQv56G4x92sZ+
	aU3CdjPopIaK5hkyPfqGfypJE+O2g5UNZ3qPaJavZNbt4+JSv14s7FpB/aMt7RR0JblYU+kkzs2aO
	VqWKPPMDY5UlAcqrTyg2I/V9+iT1pXrbklBFuOvNyEnmfuLKPjxCofLKX3bNurwwhewan4XHEq22t
	Bq74YsHMYVu9+izwWiHBybBr2ufMYiPCBVW1F6If9UbfC7xSMIuUx1ZgniGSJrK5rBG+aYWpzjmIS
	81NyEMrA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7USy-0000000FKra-3bQF;
	Fri, 18 Sep 2026 17:01:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:01:08 +1000
Date: Fri, 18 Sep 2026 19:01:08 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Peng Hao <flyingpenghao@gmail.com>
Cc: dsaxena@plexity.net, olivia@selenic.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] hwrng: omap - fix runtime PM and clock leak on
 EPROBE_DEFER in probe
Message-ID: <aqz91MKmrN90dy01@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910112421.39372-1-flyingpeng@tencent.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Peng Hao <flyingpenghao@gmail.com> wrote:
> omap_rng_probe() calls pm_runtime_enable() and pm_runtime_resume_and_get()
> before requesting the optional "reg"/functional clocks. When either
> devm_clk_get() returns -EPROBE_DEFER, the probe bails out with a bare
> "return -EPROBE_DEFER;", bypassing the err_register cleanup that does
> pm_runtime_put_sync() + pm_runtime_disable() (and clk_disable_unprepare()).
> 
> As a result every probe deferral leaks a runtime PM usage count and leaves
> runtime PM enabled; the next probe attempt then hits an unbalanced
> pm_runtime_enable(). The second deferral point additionally leaks the
> already-enabled functional clock.
> 
> Redirect both -EPROBE_DEFER paths to err_register. clk_disable_unprepare()
> is a no-op for the NULL/ERR_PTR clocks on these early paths, so the cleanup
> is safe.
> 
> Fixes: b166be004491 ("hwrng: omap - Fix clock resource by adding a register clock")
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
> drivers/char/hw_random/omap-rng.c | 12 ++++++++----
> 1 file changed, 8 insertions(+), 4 deletions(-)

Your patch does not apply:

https://sashiko.dev/#/patchset/20260910112421.39372-1-flyingpeng%40tencent.com

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
