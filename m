Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5C21F542A;
	Sat, 13 Sep 2025 04:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757737763; cv=none; b=CC3qxd+reSILCNyUMNzakfZ/wUVMF2OOK2l6rvS7lyvLOnryVxAltwaRypbj8jEFFEEjtFoz3IwSrdDnrlAfwdce2GPE/DxvgAPtHXOPCKgrd/gA1lb+hEIWWcHNBZakqQLFNokY7brgBqyxlV+wMefj/PnP9qcryIGIPE9gmXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757737763; c=relaxed/simple;
	bh=k9s075dtAsSQOFVXvJ4q1Cos+jsyC3EJrwu2ldNstyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n9sBuz9+S2om/ujRsx2C1lv1cnMoTlPV5SVVF2wlGa1DxkpMEXZqWOt/Nqz5mydGDpN9ewAxDJYsRQ7hW8QC7XCu7iLo6D8ldxXCleOQDJ5xbaM/E+vch/uI0ozEcKygYLofeRfbdEvJF33MVqQiqJ2BQ0Jn8fbWPj/u/eLRg0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=F7Sy/bwU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="F7Sy/bwU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3qrUTkz6i3AJQkIN2H7qcP8LhRth/2DtjB2PsX8h3Kk=; b=F7Sy/bwU6Ledj6bC4LuFwoXHyJ
	s/RE0bEhe35x/E2JXV2q5iYbKUR91kGDI/op0eU4N0oJfbai2cLsrjRnu64u+us2eRejOIL8BeRmS
	Re9hYjBAvB/h9QPvQi7/sAfl9DyxRMT9yjZFlxARvCcUJNX6EzBVgfLYvIrZaR3YZrpyJhT1HVLlI
	DpOEfZrx5vQ5xeVrzFKd1SD1cnJpFDfeWVy2rZxOIo2yutLbWZUQnYURgWBvbsDbzDEI/p7cuG7y+
	gfJRA2u2OFwOY4YeZiMttiA6KMf6MzpE783clalFDTQuk0iYLNz/V0E7YHjwF9dqt4wo8OHTLT/MU
	uxnkeJMg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uxHdZ-0053vU-2V;
	Sat, 13 Sep 2025 12:29:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Sep 2025 12:29:18 +0800
Date: Sat, 13 Sep 2025 12:29:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Michal Hocko <mhocko@suse.com>,
	"David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1] crypto: WQ_PERCPU added to alloc_workqueue users
Message-ID: <aMTzHmhzooLDlTMg@gondor.apana.org.au>
References: <20250905085701.97918-1-marco.crivellari@suse.com>
 <20250905085701.97918-2-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250905085701.97918-2-marco.crivellari@suse.com>

On Fri, Sep 05, 2025 at 10:57:01AM +0200, Marco Crivellari wrote:
> Currently if a user enqueue a work item using schedule_delayed_work() the
> used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> schedule_work() that is using system_wq and queue_work(), that makes use
> again of WORK_CPU_UNBOUND.
> This lack of consistentcy cannot be addressed without refactoring the API.
> 
> alloc_workqueue() treats all queues as per-CPU by default, while unbound
> workqueues must opt-in via WQ_UNBOUND.
> 
> This default is suboptimal: most workloads benefit from unbound queues,
> allowing the scheduler to place worker threads where they’re needed and
> reducing noise when CPUs are isolated.
> 
> This default is suboptimal: most workloads benefit from unbound queues,
> allowing the scheduler to place worker threads where they’re needed and
> reducing noise when CPUs are isolated.
> 
> This patch adds a new WQ_PERCPU flag to explicitly request the use of
> the per-CPU behavior. Both flags coexist for one release cycle to allow
> callers to transition their calls.
> 
> Once migration is complete, WQ_UNBOUND can be removed and unbound will
> become the implicit default.
> 
> With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
> any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
> must now use WQ_PERCPU.
> 
> All existing users have been updated accordingly.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
> ---
>  crypto/cryptd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
