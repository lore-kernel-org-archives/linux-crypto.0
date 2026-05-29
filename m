Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DB42C15A5;
	Fri, 29 May 2026 06:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780034819; cv=none; b=dZFAEAyalTL5XN2AbYNUluFXI4YlKV9PTV7aPAM9d+/1QmEZlVl8i9as3gTwJljPmktR+W4aLoSAAzgVIO0TVW9FYQUQ309ae6cuXVTBz9VjCDy/wLiXp0/YntIu89yauSjqAYwT2XbWnZ0FR7bRxC3qjWZq2b/5aYUEpW6s0PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780034819; c=relaxed/simple;
	bh=81cfYUkyN8UNA/ZW6TECOqBVcJvowccDnEePsta8KEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YA6/fuiBojuA9SoH+2dAofWc/0wpUsTLZnhxLnV1qCYvsRpOA3l40Ilquobd0dwiWrE+F2gaOLwZfYL3BhoFwvycA+c7Y8hxwNrf2Hfua2Kozqq0m+RsO5jnPbyvAjJjG8EOj5ZH8vJ2Hpg5NIkxrtoeTnRuYJ2JflB+wY9PS7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=oZ0MBIha; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="oZ0MBIha"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7+yDRc/3NVFLq/ijybsOclS67Zvlmo6PM+bottO0v6s=; 
	b=oZ0MBIhauH52tgttoZZSkfHQ7Fjd/WW8bybUFGt/KE8BsNHO/qUDk/NJzR9GK2+cSEEECbLqVm1
	Am1FbtalwWBdJOQq5exWDjq5iF5bAFR1PNy9rI59+ZLtIQuzu+B3myYusYIcjUmbTg1OXE4GjRRHx
	FWhS1XjrOnximlbzk9+6voJ+H+JykK2SEsOnurUSxmvwgThY6vX2+HYl/QWovxHUWYuxuIK54unDu
	1jRyuscFhRUTcMUbu+OxW4lKagLFgyRRk6rmjJN0W+HYgUboxkfqgaev6k7/8biF8RAnrB8CuVDQG
	sy3kfQiPp8mcGPj4BHt456tCb9J2o94mk6mw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wSqMw-000dFr-25;
	Fri, 29 May 2026 14:06:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2026 14:06:54 +0800
Date: Fri, 29 May 2026 14:06:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org,
	Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - protect service table iterations with
 service_lock
Message-ID: <ahks_mppiaa-Ee_Z@gondor.apana.org.au>
References: <20260520124155.211119-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520124155.211119-1-ahsan.atta@intel.com>

On Wed, May 20, 2026 at 01:41:55PM +0100, Ahsan Atta wrote:
> The service_table list is protected by service_lock when entries are
> added or removed (in adf_service_add() and adf_service_remove()), but
> several functions iterate over the list without holding this lock.
> 
> A concurrent adf_service_register() or adf_service_unregister() call
> could modify the list during traversal, leading to list corruption or
> a use-after-free.
> 
> Fix this by holding service_lock across all list_for_each_entry()
> iterations of service_table in adf_dev_init(), adf_dev_start(),
> adf_dev_stop(), adf_dev_shutdown(), adf_dev_restarting_notify(),
> adf_dev_restarted_notify(), and adf_error_notifier().
> 
> The lock ordering is safe: callers of the static helpers (adf_dev_up()
> and adf_dev_down()) acquire state_lock before service_lock, and no
> event_hld callback or service_lock holder ever acquires state_lock in
> the reverse order.
> 
> Cc: stable@vger.kernel.org
> Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Co-developed-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
> Signed-off-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_init.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
