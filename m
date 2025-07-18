Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4617C2BF012;
	Fri, 18 Jul 2025 11:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752837197; cv=none; b=oq6WFnUzH+quKqmX0MJmTUEpSAGQql9jJtuWmGrmLUBlV+07MToVxAiZODXI9Ih0OizQmYF4pAABYLMEPunNHVrTsHQbqBKScVZCAvZNL68ome805oxN8U76/bgiOdtpOHLvffwaEKLQ7HgUUngz8qOBan3zOfe2gtCqgprxLrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752837197; c=relaxed/simple;
	bh=TqKyTBjFtQ3f36uvZI29BwG1FQzvYrSqzIvXDaAbO6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j2P87eBfszgR8GQgTWo/2j0L6hqQxypR0s1g7OkUm8JC+4n4YEu2eRBPvSKnYAniS2sMw7wssVrp4dMI9J5B06Ak3QO96U8TLeR7ZVVnLqHqFgKA1GgU+1tWcN/42vpCH43/ivQJEvl6njWb4y0gfj/qLwbU4z99ZZzusm+L/IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UKK2fcgW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UKK2fcgW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bnmhsuxiBErW87nw0PaWsg41tpb0/3MqhNgyKWbDaKM=; b=UKK2fcgWSeaGOTul9H6D9DEQRl
	nsp7hckwzEgcrHsNpyzYGVKlGUURT+/eHe49iuici7ACwYbg6/laSIDpDJcjtE87Z2fkF1IqZxMya
	HjBoWwFnltt2GcwTW+k4KUl2jI1TglhJ3nzJZlSnAel0vvlGDs5R4WaH4WtskPx1yMuLWc+GCmb1e
	2Ov0Ww18W8t7JcevuUwTmCuW4tKOulavEQDw6V+Glgdu+KMSwbpoAvNKUOrX4ojrrJZUmxWlrVV2h
	zhA+khC3vLPsiLeV6GL/Rc2ADXwJE4ZU8+KuvqhpFZwbKr/klV2WSi78OhZCFvM+32DfvdJwWgvPj
	WWBa1EHA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ucimB-007ynL-0v;
	Fri, 18 Jul 2025 19:13:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 21:13:11 +1000
Date: Fri, 18 Jul 2025 21:13:11 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org, Ahsan Atta <ahsan.atta@intel.com>
Subject: Re: [PATCH] crypto: qat - flush misc workqueue during device shutdown
Message-ID: <aHosRzM4UO63weHf@gondor.apana.org.au>
References: <20250711122753.9824-2-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250711122753.9824-2-giovanni.cabiddu@intel.com>

On Fri, Jul 11, 2025 at 01:27:43PM +0100, Giovanni Cabiddu wrote:
> Repeated loading and unloading of a device specific QAT driver, for
> example qat_4xxx, in a tight loop can lead to a crash due to a
> use-after-free scenario. This occurs when a power management (PM)
> interrupt triggers just before the device-specific driver (e.g.,
> qat_4xxx.ko) is unloaded, while the core driver (intel_qat.ko) remains
> loaded.
> 
> Since the driver uses a shared workqueue (`qat_misc_wq`) across all
> devices and owned by intel_qat.ko, a deferred routine from the
> device-specific driver may still be pending in the queue. If this
> routine executes after the driver is unloaded, it can dereference freed
> memory, resulting in a page fault and kernel crash like the following:
> 
>     BUG: unable to handle page fault for address: ffa000002e50a01c
>     #PF: supervisor read access in kernel mode
>     RIP: 0010:pm_bh_handler+0x1d2/0x250 [intel_qat]
>     Call Trace:
>       pm_bh_handler+0x1d2/0x250 [intel_qat]
>       process_one_work+0x171/0x340
>       worker_thread+0x277/0x3a0
>       kthread+0xf0/0x120
>       ret_from_fork+0x2d/0x50
> 
> To prevent this, flush the misc workqueue during device shutdown to
> ensure that all pending work items are completed before the driver is
> unloaded.
> 
> Note: This approach may slightly increase shutdown latency if the
> workqueue contains jobs from other devices, but it ensures correctness
> and stability.
> 
> Fixes: e5745f34113b ("crypto: qat - enable power management for QAT GEN4")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_common_drv.h | 1 +
>  drivers/crypto/intel/qat/qat_common/adf_init.c       | 1 +
>  drivers/crypto/intel/qat/qat_common/adf_isr.c        | 5 +++++
>  3 files changed, 7 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
