Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7829230FC22;
	Fri, 14 Nov 2025 10:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763115732; cv=none; b=RjuHwsiqdCUQmW+mVh3eVHGBJ1TZ8BBszjXnCv4X3W9ElhDCaXp4i0lKQbjpKtP1qTgRsYpanXohdvILlLjl66WVuzpNVXFZy5XualKJyyxH0tfzz0tTjIinQjQNnKILPy/cWx/y6M+mBDYaUmrLP1vBpy+TbXXf3akqZhzuzuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763115732; c=relaxed/simple;
	bh=soho2DC1h1zUwwWABxgTvfpHG6kQI1vZj3m3ltH2slg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r0zmkKg4AAeACccRuqhYQGN6DamzL4XtUEaJhVhad9tJcNV4Jykuusb1qsj92VBH8OnCevG2PgjjSppHBQbqaMCFUtlrwWyRdBu4AxFI6ah4kCypvf6qwk0eh/yeKIBPc7t7vWRzZ76lseH2lCNmzWWt0KmJTEO2FOirxCNKzBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=M4aZ43AA; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="M4aZ43AA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=yqZuiqR5XpCaInMgn5MgwyEPMHFWgFOqSEmpewRRB+I=; 
	b=M4aZ43AAbD2/9h6zWA/Ze9XUhfFgkrvK5NUUBwTMAvjQvxRYy4ei/6xJBbTzpMprazXXtSIUXKL
	g7xJ/FxR+QFENwXtwreme5X4d9tyVvC+hjMfTKhZi0t0zK4Srjp0VzJTocEXufYvyrWdLjUIp/DJh
	99isXsWKbP00opmC4qjrCRL0go5P5baxvZyZwITn5pC2NOHi9i86g+nwpyqZ8PdUreOkxPLaPDPhA
	VsnFN3oxtjfCEaoOQ+2cdzvfJFdVLyUD5BLAjJz1vtuzUciPmYbrhjc2Ss7Mg4OM46V+0ipxeVHWL
	ecqaMTVDZIg9gI+PiMrzCBG2/6Px67bTrxKA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vJqwO-002yON-1l;
	Fri, 14 Nov 2025 18:22:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Nov 2025 18:22:04 +0800
Date: Fri, 14 Nov 2025 18:22:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Michal Hocko <mhocko@suse.com>,
	"David S . Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Subject: Re: [PATCH] crypto: atmel-i2c - add WQ_PERCPU to alloc_workqueue
 users
Message-ID: <aRcCzMZTcO_GXvfg@gondor.apana.org.au>
References: <20251106163758.340886-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251106163758.340886-1-marco.crivellari@suse.com>

On Thu, Nov 06, 2025 at 05:37:58PM +0100, Marco Crivellari wrote:
> Currently if a user enqueues a work item using schedule_delayed_work() the
> used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> schedule_work() that is using system_wq and queue_work(), that makes use
> again of WORK_CPU_UNBOUND.
> This lack of consistency cannot be addressed without refactoring the API.
> 
> alloc_workqueue() treats all queues as per-CPU by default, while unbound
> workqueues must opt-in via WQ_UNBOUND.
> 
> This default is suboptimal: most workloads benefit from unbound queues,
> allowing the scheduler to place worker threads where they’re needed and
> reducing noise when CPUs are isolated.
> 
> This continues the effort to refactor workqueue APIs, which began with
> the introduction of new workqueues and a new alloc_workqueue flag in:
> 
> commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
> commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")
> 
> This change adds a new WQ_PERCPU flag to explicitly request
> alloc_workqueue() to be per-cpu when WQ_UNBOUND has not been specified.
> 
> With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
> any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
> must now use WQ_PERCPU.
> 
> Once migration is complete, WQ_UNBOUND can be removed and unbound will
> become the implicit default.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
> ---
>  drivers/crypto/atmel-i2c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
