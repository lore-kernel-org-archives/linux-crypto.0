Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0423101DC;
	Fri, 14 Nov 2025 10:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763115799; cv=none; b=BK5Jj1jwaA+O4EtkpkxoOlzJqrap6jtP4tWKeY+28VFuG6qX2TAxGOffSRm9jzmANy1q9KYYh4zNZ73tTEoZiJfEKyG10e4UqwCQt9oCIHu0f+hcNN12/bmtgUIGAup27Ixeb/odrFBK0n3VXwk1q/B5ZtRYJbwr15y2FjbSaf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763115799; c=relaxed/simple;
	bh=Ontk/xqo0280NZ5Ge0ftL1Nt4QkkH+vFrQmkO6LEOMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AUM4blnAqTFIGc1EtY0tSJoDK7imnX7ITCNSAvlQ50Fl+gJjbKnU4LXt1cE6jxrhgT3LkGAGzANJgjaLuK+5pZwjlcf+VyT9p61+W0z2tpiK5zc8X4yMLM2FyJ+UL5C7WG+f32zxy5XE8iZnV/5s08ASsKaBB2f7x5Cwb5IBOts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=mVNHKSZW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="mVNHKSZW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=NLyjsu/cXglRKsLNLch7b9iQktHKKZH+AG+ArSPP9pw=; 
	b=mVNHKSZWR1udfa7kCCSSXuLO2nnCc8bMMW3hVf2GhXY8ZesQupggqqJ+GlBnxtTLG/0XFWIVSRm
	lSKv0uPlpt18RBhLti3//8wF2Uaq382e89OPg08Ws4lSI4pD5WwbNq84hSRlJSNqSD6Km2jfxC5G8
	F+0C/rpVZOQ2NSTXAVfIHX8s5hH0FBYUH5qcWjHoK6w8Dg180j5ev3h8PPttZ2MoH/kgmDR2XoEjZ
	GTLOjvROx7QBaBej0MkcLHnbZZQzioVHdRKWkuac8/9GZYHtqI+NWQFUCypuv+Znnp7p8GRkK+KsB
	ybE0vC43vbPwft/+n+j6QpEVluBs1onnrTMA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vJqxW-002yPn-0A;
	Fri, 14 Nov 2025 18:23:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Nov 2025 18:23:14 +0800
Date: Fri, 14 Nov 2025 18:23:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Michal Hocko <mhocko@suse.com>,
	"David S . Miller" <davem@davemloft.net>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - add WQ_PERCPU to alloc_workqueue users
Message-ID: <aRcDEsXIJukZrZUN@gondor.apana.org.au>
References: <20251107112354.144707-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251107112354.144707-1-marco.crivellari@suse.com>

On Fri, Nov 07, 2025 at 12:23:54PM +0100, Marco Crivellari wrote:
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
> This change adds a new WQ_PERCPU flag to explicitly request alloc_workqueue()
> to be per-cpu when WQ_UNBOUND has not been specified.
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
>  drivers/crypto/intel/qat/qat_common/adf_aer.c    | 4 ++--
>  drivers/crypto/intel/qat/qat_common/adf_isr.c    | 3 ++-
>  drivers/crypto/intel/qat/qat_common/adf_sriov.c  | 3 ++-
>  drivers/crypto/intel/qat/qat_common/adf_vf_isr.c | 3 ++-
>  4 files changed, 8 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
