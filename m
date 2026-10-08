Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDF64398FD
	for <linux-crypto@vger.kernel.org>; Thu,  8 Oct 2026 08:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791447670; cv=none; b=hsr/mwqpFjXIoeBU+Jzpj5Nf6X2THZVivYDaLU8RgyRNwVwW/huSt9YuXtU6vQW26H8M6UjhXRQFCKBVcFqX0yu6uGYu838AosOGt16qFP/pzCCdZHUZFYjFwg0UFwxkUOh88hO/o/mtyRfW2t6xBe3YOblymoVBc0EuBedIsqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791447670; c=relaxed/simple;
	bh=6ccbWd1EoUxceiyj9zWXFg2+OmxMmY5np7VsoFAz1HI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KoiIPLl6P1dk9N1gjRqm7YSwppyfu1s6B1ZaxUquX+HfTFsUhHgWBsEF9NMgUdPx+Scwpkyq6of2rNsM8KH3QtT4UQrBdVeqHvRCZERabM71CSGe10y46E3ERsk67/6WuDBfVXtgvvcNTV+EvCtfaXEfxxNPHbUjsJV5TzThSvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=T/lsxIjP; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="T/lsxIjP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=QGpe0oIvwVZnB5Cnm0lPXRAAgKaetwy9XPVJzW3MCjY=; 
	b=T/lsxIjPU064lj7+qsKfBRP30JgZ34SEAryxiWbpi8yV5ey4ioU9CCP+j32MHPz+kU5psrCTkX2
	u3U2VscKf6k/iey+SyyzgXiUa5B0GbhCuDPznDjmLYeou9lxcbV+sj1/mjMK7acZRwBq4DYYYaiLU
	goMw8npNCLhUnsCZDfotzMXJ1aqT24lxEIZbzgVaZFmz4cwdzbHCVdOhVC72ayl/w3TRNeu1clOl5
	blwr35ySQ61i/yPtAKSOx4soqGqCV8m/RQjf6C+DXVJKrwUlR6tVKGLC4oWANvrJpXD9Sov6ZbfPp
	U2t5I8pyWChr9S9UVDqxOVC5VY40sdE21fqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjN9-00000001njM-2CN9;
	Thu, 08 Oct 2026 16:21:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:21:03 +1100
Date: Thu, 8 Oct 2026 19:21:03 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: George Abraham P <george.abraham.p@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - force an edge when re-enabling all VF2PF
 interrupts
Message-ID: <asdSb9mEivTt81kv@gondor.apana.org.au>
References: <20260929083837.2102260-1-george.abraham.p@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929083837.2102260-1-george.abraham.p@intel.com>

On Tue, Sep 29, 2026 at 02:08:37PM +0530, George Abraham P wrote:
> VF2PF interrupts are edge-triggered: a source only fires on a
> masked -> unmasked transition of VM2PF_MSK, not by being unmasked.
> adf_enable_all_vf2pf_interrupts() does a plain read-modify-write
> unmask, assuming VM2PF_MSK still holds the all-masked value left by
> adf_disable_all_vf2pf_interrupts().
> 
> That breaks across a device reset: adf_dev_autoreset() (and AER
> recovery) FLR the PF while VFs stay alive, so a VF can latch a source
> in VM2PF_SOU with no vectors set up to deliver it. The FLR then resets
> VM2PF_MSK to its power-on default of 0 (unmasked) without a software
> write, so the following RMW unmask writes 0 over an already-0
> register: no edge occurs and the latched VF2PF message is never
> delivered.
> 
> Fix by having adf_enable_all_vf2pf_interrupts() mask all sources
> immediately before unmasking them, mirroring the idiom already used in
> adf_gen4_disable_pending_vf2pf_interrupts(), forcing the required edge
> regardless of the prior state of VM2PF_MSK.
> 
> Fixes: 575185000539 ("crypto: qat - keep VFs enabled during reset")
> Signed-off-by: George Abraham P <george.abraham.p@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_isr.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
