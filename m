Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66742848B2;
	Sat, 13 Sep 2025 04:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757737826; cv=none; b=prk+2oHompdExI4NwCLPQR9qAJCab6zlklJLdgKOeTCgjVoNqhczXDsb3iFpUv14Cqp3ADNWZMV/qOl1OUHOzNVEzzA9nFeMAbfzTSsPk8cS71zs4nX/NlEwEAuiCUNXv3TlA/ZWuRwYy8thpnSFsKkXYT2TstKZAqtuBukgOwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757737826; c=relaxed/simple;
	bh=DC2FkNv6aE5xCVTeI1DYTjZH3LIiLy/7AYGjvf0yMc0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=nBQ4vjOyOyBW7/BX2YVQfb60B5P8liklS/O6ICmmM2RrTS2eTut7sSJRiRVTYzIKNNg71fxooRrTBWpPpSBZbF3t17hcJaRPMbf52P+Wr5vtvy2+ZnRJM/x9z6yZr6HAXfp/eSMZRX/vIVjUwVTTzubjkAJ+njzNMo/DL+nxHoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OiQmRpml; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OiQmRpml"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=7dmS9b7eQthY4gOU76u4yI54jojh/DjXYRyG9Y4IqDA=; b=OiQmRpmlAYgLhqOxHzCvdbdyBZ
	oO1FdPjZIXf3/WjecU33hucubaps7oh6kfe7eiFZZ9nGsJ9UiEBeyiUSnbuQ7r3vOAZTEZ28q4ZG8
	Oy4h/jWJq3Ut0wxPwWDnQjjFU5QGz8xDDnIyaax4zdyxaBvrWOznoukhJigF0lrxizFigwNHzSz6v
	6OGCcrZVmIRn+y9oDeH19D6L/JPJz8QjktjgTz72o7eAYB1QXtuKcmIcqLLBTptqwq7QDxyowlimM
	w/d6rjTOrtMO3YJvtkVllo+c02IVUb3wO9g73ZqJu9idGUDvzgu35TQ20/NR1QvkCaMmSv3a1Pbvq
	1C26+HkA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uxHeZ-0053vg-1q;
	Sat, 13 Sep 2025 12:30:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Sep 2025 12:30:19 +0800
Date: Sat, 13 Sep 2025 12:30:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	tj@kernel.org, jiangshanlai@gmail.com, frederic@kernel.org,
	bigeasy@linutronix.de, marco.crivellari@suse.com, mhocko@suse.com,
	steffen.klassert@secunet.com, daniel.m.jordan@oracle.com
Subject: Re: [PATCH 0/2] padata: replace wq users and add WQ_PERCPU to
 alloc_workqueue() users
Message-ID: <aMTzW6nGz_FCYzNp@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905090533.105303-1-marco.crivellari@suse.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Marco Crivellari <marco.crivellari@suse.com> wrote:
> Hi!
> 
> Below is a summary of a discussion about the Workqueue API and cpu isolation
> considerations. Details and more information are available here:
> 
>        "workqueue: Always use wq_select_unbound_cpu() for WORK_CPU_UNBOUND."
>        https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
> 
> === Current situation: problems ===
> 
> Let's consider a nohz_full system with isolated CPUs: wq_unbound_cpumask is
> set to the housekeeping CPUs, for !WQ_UNBOUND the local CPU is selected.
> 
> This leads to different scenarios if a work item is scheduled on an isolated
> CPU where "delay" value is 0 or greater then 0:
>        schedule_delayed_work(, 0);
> 
> This will be handled by __queue_work() that will queue the work item on the
> current local (isolated) CPU, while:
> 
>        schedule_delayed_work(, 1);
> 
> Will move the timer on an housekeeping CPU, and schedule the work there.
> 
> Currently if a user enqueue a work item using schedule_delayed_work() the
> used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> schedule_work() that is using system_wq and queue_work(), that makes use
> again of WORK_CPU_UNBOUND.
> 
> This lack of consistentcy cannot be addressed without refactoring the API.
> 
> === Plan and future plans ===
> 
> This patchset is the first stone on a refactoring needed in order to
> address the points aforementioned; it will have a positive impact also
> on the cpu isolation, in the long term, moving away percpu workqueue in
> favor to an unbound model.
> 
> These are the main steps:
> 1)  API refactoring (that this patch is introducing)
>    -   Make more clear and uniform the system wq names, both per-cpu and
>        unbound. This to avoid any possible confusion on what should be
>        used.
> 
>    -   Introduction of WQ_PERCPU: this flag is the complement of WQ_UNBOUND,
>        introduced in this patchset and used on all the callers that are not
>        currently using WQ_UNBOUND.
> 
>        WQ_UNBOUND will be removed in a future release cycle.
> 
>        Most users don't need to be per-cpu, because they don't have
>        locality requirements, because of that, a next future step will be
>        make "unbound" the default behavior.
> 
> 2)  Check who really needs to be per-cpu
>    -   Remove the WQ_PERCPU flag when is not strictly required.
> 
> 3)  Add a new API (prefer local cpu)
>    -   There are users that don't require a local execution, like mentioned
>        above; despite that, local execution yeld to performance gain.
> 
>        This new API will prefer the local execution, without requiring it.
> 
> === Introduced Changes by this series ===
> 
> 1) [P 1] Replace use of system_unbound_wq
> 
>        system_unbound_wq is to be used when locality is not required.
> 
>        Because of that, system_unbound_wq has been renamed in system_dfl_wq.
> 
> 2) [P 2] add WQ_PERCPU to remaining alloc_workqueue() users
> 
>        Every alloc_workqueue() caller should use one among WQ_PERCPU or
>        WQ_UNBOUND. This is actually enforced warning if both or none of them
>        are present at the same time.
> 
>        WQ_UNBOUND will be removed in a next release cycle.
> 
> === For Maintainers ===
> 
> There are prerequisites for this series, already merged in the master branch.
> The commits are:
> 
> 128ea9f6ccfb6960293ae4212f4f97165e42222d ("workqueue: Add system_percpu_wq and
> system_dfl_wq")
> 
> 930c2ea566aff59e962c50b2421d5fcc3b98b8be ("workqueue: Add new WQ_PERCPU flag")
> 
> 
> Thanks!
> 
> Marco Crivellari (2):
>  padata: replace use of system_unbound_wq with system_dfl_wq
>  padata: WQ_PERCPU added to alloc_workqueue users
> 
> kernel/padata.c | 9 +++++----
> 1 file changed, 5 insertions(+), 4 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
