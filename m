Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942FE3A2E25;
	Wed, 23 Sep 2026 08:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153889; cv=none; b=oIY6F/1FIR5T+6DOhkQk15p33Xn2n0rHmZbkU94qzUUgXOMty+L9IDXRvo1rXehQK3pBRyJEwGXBx3TQ+wdrPXLhfvZ/ytYwEbK8hvwR/LoO6ds7h2+HRMGdzAUey/imV8/nDgzg9YCAOvxH5ww1PiBfe+W0a0rGH7qCB06FUEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153889; c=relaxed/simple;
	bh=tkKPAgR8xddobsqxKmKMLf3FSXTDAAj9rexAFwpr4eE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=jYdreGev30UKrp1wv6IdoCDi4NIIBw8WpmLsyWV/SlMOZX7iE9a0qdBV8ADcmTT5WB5aitquakkRPYkIghJZeX6RrlgEepWJja6bYJpQS5Eg8aPF8qzgpEdHebNBGLAoYS63XMScJvpdBNIcgEgmhqr6mRc3xQiGxw93NZDvgi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=QdFml6A1; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="QdFml6A1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=rjIsRR4qSBlJBi9gImnZ792ye+6NSyLpCEtNYKrFohg=; b=QdFml6A1CyxOtTyxJkTAOOwwws
	AMMOrL4ZUcfZgupX4PbuGBuUaWVttqWJAgy9+DgCooZJzCiYOP8RHum+kEofiH3WOz+PGqOOKJbrg
	6etGkU1fDfZFDZqYQQBUvkwVHqv23suzV/gI7b48PYRpIaJ8LqRWFKmrg16YwIVKJDmazopoXVnW4
	BkJi0E21G1aVtTsc4ZUxHTuP6hPb7APvZn6AVEf18PgYrWyXkMzFWmgLAuAuJS6CtmNqO5n4/emY8
	JUY2qwiuSr085GOoiuQ2DraeviXy4mu4yLGN5CEvC6xfepMNzWKRwe47rXcZPbTzdbPm9sKSgpcwU
	nykmCRGQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9Inf-0000000GyOt-0psh;
	Wed, 23 Sep 2026 16:58:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:57:59 +1000
Date: Wed, 23 Sep 2026 18:57:59 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Muhammad Bilal <meatuni001@gmail.com>
Cc: thomas.lendacky@amd.com, john.allen@amd.com, davem@davemloft.net,
	bp@alien8.de, ashish.kalra@amd.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, meatuni001@gmail.com
Subject: Re: [PATCH] crypto: ccp - fix SFS ioctl race against device teardown
Message-ID: <arOUl7OArmq40doN@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919192432.272680-1-meatuni001@gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Muhammad Bilal <meatuni001@gmail.com> wrote:
> sfs_ioctl() reads psp_master->sfs_data and caches it in sfs_dev before
> taking sfs_ioctl_mutex, while sfs_dev_destroy() frees sfs_dev->page
> and sfs_dev->command_buf with no locking at all and only clears
> psp->sfs_data afterwards. A call to sfs_ioctl() that reads sfs_data
> just before sfs_dev_destroy() runs will still acquire the mutex and
> go on to use the now-freed command buffer in send_sfs_cmd().
> 
> Have both functions take sfs_ioctl_mutex before touching
> psp->sfs_data, so a call that is already using sfs_dev completes
> before teardown can free it, and a call arriving after teardown sees
> sfs_data cleared and returns -ENODEV instead of racing it.
> 
> Fixes: 648dbccc03a0 ("crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver")
> Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
> ---
> drivers/crypto/ccp/sfs.c | 9 ++++++---
> 1 file changed, 6 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
