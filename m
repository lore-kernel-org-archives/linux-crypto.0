Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAC130FC22;
	Fri, 14 Nov 2025 10:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763115738; cv=none; b=rW5kEk0v8BvZ6B0uwa+3Y3x61vpLJ5svVpLOaLot5iLi4P1KTzJE4VeBrzSlxtYuSxBDBehY+DN1cZN6g5qGDV4FNe0yDyGZhh0V4InJiBoMHfFvNcu5x3gtmxDEPeLGzGUAePCgGz3b4pdXkX2JJEYjQ4JtUwk9vYV81gq5oTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763115738; c=relaxed/simple;
	bh=roxFtnzuRkMpVmMngmMbrFnsoA97ovUMzkdQu17m+Ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V7F2xoZBQkXLmPROqUbQ3lyrdkECf9n40aBLnQpUYNBDAlKlenlCv/lOU16jdFsd+IbgMyGDjxnWOJImair+eIuj5W4Li09lZX7A84BknMixNVayR7mj9GNUihqxWYsCXey28z2wHTSqdvAiXaC9W6AGyTlOZEoqgMQ5Q/OaHJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=kGrEOoIt; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="kGrEOoIt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=s8WLRgGe3nIjen0XaffMdObT975V6kaP5eCQBJs1sug=; 
	b=kGrEOoItzCpGhuSJ2jbwDP1OhGaDco8UuAKWO1uHDSpg/uIGOAtkkiOPY4UB3lNVgJ4CLupwNY0
	ZHHInSuv4xNCIZLTOg374Z4qbT846AfmvK5bOJlKgnPdRcnqPxJWHd341/67QML26MotB5fISUPny
	V+HjQuUxbtfzAbe/2miUkBoX/YPpJ4DG3wMne7KtvTB4iKU+Bel+wXKn937yCVDkTB6rY3iKoGqHh
	dZkUDVO7AWQElEzIOUNF6N0arxjySDHRdoB+hOKNH95BJKgdydXrph827wIxX+rSSgpDJf2hyMvhG
	O8DwpQjyz5/tdTnbSxLviU6T59L57RUmUGIw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vJqwW-002yOU-1x;
	Fri, 14 Nov 2025 18:22:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Nov 2025 18:22:12 +0800
Date: Fri, 14 Nov 2025 18:22:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Michal Hocko <mhocko@suse.com>,
	"David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: cavium/nitrox - add WQ_PERCPU to alloc_workqueue
 users
Message-ID: <aRcC1BbR6qNf1P2E@gondor.apana.org.au>
References: <20251106164236.344954-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251106164236.344954-1-marco.crivellari@suse.com>

On Thu, Nov 06, 2025 at 05:42:36PM +0100, Marco Crivellari wrote:
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
>  drivers/crypto/cavium/nitrox/nitrox_mbx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
