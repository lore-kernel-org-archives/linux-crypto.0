Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C8C47A87C
	for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 08:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153522; cv=none; b=Rbt5uwC7vSeiE+1EeZNd7k7n8+lPuwIWZHpveXfIp+SUIlCVu2bM78J3q+Gx9mMchCj7PJBh8gljuHPxNOc9VU8kAYUFiT1b2XoOfSPM/5n8Gr1MckU9C1Q1kc/m/E55cDSDgif5t2WxIWUdFH4Z1V8k3Y9yXNIBcJnvUO6xRAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153522; c=relaxed/simple;
	bh=GYHUsFJL9TCul171Eemv5FyaEoIygtINolRy0WzYzCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qRBRuAbrHAbU1l6DVYk/3/vMgqLl99YV6O+vqbgzieBQDiySF64s6C70GzqmkEwgD/z8xte0Cf3XX6Pwex58hh5jBoUxyEV6svE1ENfifyIBGK1S9T4g1AOhUhHoQfM1S7pSozHL2xbf4LgZWoUj99KtAItUy7nSsNyDieprAaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=XH7mwdGp; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="XH7mwdGp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=u3ePGHqczZDIHlCDOW1M6GsDPt7ehxETF3zyjH4yboc=; 
	b=XH7mwdGpZ9t4ewT3lbES+KH5FjJ7FrRyKrJPUl6b8SB5kc29zJHvQlU/ugnz8RIlwQGIGjer7R+
	H4m1Se863R5oJfd8JuylK/PC/Vkjytzk7YzTRFwTxWE70nZXRErfTFbuZJRRmALpTy0AcnhONoW69
	4wqRy2OA3eSIHPEZ8vtSVrq10O1QAEhDJMmUvESNJEjp3Q1x57Y1N3cYU1O1gyCPgNFASkKEWgYbb
	WP1LsEkV26YSFjpK+aMTB4xCg5Hw6FsAb8oxG2TyzwuMANtlxlaNCvwQA0ah5bXjU8Gu2ryyb8NAx
	D559G8i8cfWpnryAcq59U8RM1pHNuUfnCTnQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9Ihm-0000000GyGn-2hZU;
	Wed, 23 Sep 2026 16:51:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:51:54 +1000
Date: Wed, 23 Sep 2026 18:51:54 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/2] crypto: qat - fix config table locking
Message-ID: <arOTKjeCqb-QKKHT@gondor.apana.org.au>
References: <20260918124112.537571-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918124112.537571-1-ahsan.atta@intel.com>

On Fri, Sep 18, 2026 at 01:41:10PM +0100, Ahsan Atta wrote:
> The per-device configuration table is protected by cfg->lock, but not
> every access to it takes that lock. adf_cfg_sec_find() walks the section
> list unlocked and returns a pointer that its callers then dereference
> under cfg->lock, so the section can be freed between the lookup and the
> use. The dev_cfg debugfs reader walks both the section list and each
> section's key-value list under a driver-global mutex that none of the
> writers take, so it does not serialise against config writes, device down
> or device removal, any of which can free the entry it is walking. This
> series moves these accesses under the per-device cfg->lock and then drops
> the redundant list walks that are no longer needed once the section is
> resolved under that lock.
> 
> Note on the debugfs lock change:
> The dev_cfg reader now takes a lock that lives inside the structure freed
> by adf_cfg_dev_remove(). This is safe because every cleanup path calls
> adf_dbgfs_exit(), which removes the dev_cfg file, before
> adf_cfg_dev_remove() frees the table, and debugfs_remove() waits for
> in-flight file operations to complete.
> 
> In summary:
> Patch #1: Take cfg->lock around the config section lookups and switch the
> dev_cfg debugfs reader to the same per-device lock. This closes the
> use-after-free windows against section deletion and key updates, makes the
> lookup and insert in adf_cfg_section_add() atomic so that a section can no
> longer be created twice, and removes the now unused global
> qat_cfg_read_lock.
> 
> Patch #2: Look up an existing key-value entry once in
> adf_cfg_add_key_value_param() and act on that pointer directly. With the
> section already resolved under cfg->lock, the list walks done by
> adf_cfg_key_val_get() and adf_cfg_keyval_remove() are redundant, so both
> those calls and the on-stack value copy are dropped. No functional change.
> 
> Ahsan Atta (2):
>   crypto: qat - hold cfg->lock when accessing config sections
>   crypto: qat - avoid redundant config list walks when adding a key
> 
>  drivers/crypto/intel/qat/qat_common/adf_cfg.c | 84 +++++++++----------
>  1 file changed, 38 insertions(+), 46 deletions(-)
> 
> 
> base-commit: c72ab95b5aae0f0412dc1d3284ec446ad1b315e2
> -- 
> 2.50.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
