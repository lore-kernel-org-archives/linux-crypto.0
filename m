Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C353C368276;
	Fri,  2 Oct 2026 08:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790929544; cv=none; b=tI13e3IGyWX1hZWIrDSmZKbE3+Wx8B33dj3GG1cG4Er+LlxKid4JK61jgqoAuvvGDfuOm5bTLThiCSWwux3xtNF2RuwLeg1NFcFfTGuZxpD2Z/SWZMS1EgdsFQaW4anSV4B9iY2cGWt4N9pUt4/i24pThdwB04gAzLsbs1V2kUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790929544; c=relaxed/simple;
	bh=eft9RffMpTXqzVPxPWRzttbbDmk+cBGfqOf2lAFjEzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=doKAvlFaqaw1BRNOtzTKFTxVUsKKSw9+czYozuLXCjXkEgU1tvyijfNIq5ab3Nxv2qPLU/T73D+5Vf9vUrLG19aqUm7HuQuiplCSw/HVIQBzOdaQIGtqnas6P6gDPyt7D92cLJTJ3/GPijhmc4ufwQj7P9DGljqswq2k1P9Pxbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=T9rjftMb; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="T9rjftMb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IFwl7Y7yCQ1De8p+oQQyyW3EZP3FRAJDCTHGxzPL7mw=; 
	b=T9rjftMbMtye4kNBct3orGlDaFTd6vw/CmJO/nXkbbKaLUMhi4LzkKToCZMpgP7zTX5x02e52Vf
	DeerZPyr+1NEyAr5EGRPrnF4n4KEyxTA2DoPTNKLypJvhajzHq8YyKKarGU9+yFpQfc28Q0WYzwCu
	li7UhTQj+25/Y1KyXD/DHMpAAi9UloY+U82smTCJGVrqg0Rv4HYyh8Sy874BRQ4R+ZTKWEsOwNsDk
	v8xIuUklBvBZm+UyuY0a7UAR/afFGlEJ+4zHifDBTc+eWsLXlhRKV/3IZujsAuY2clUdnhfru3z7M
	yGgHJWhfgL1VDQM4NwqErXrJnEZ7bXs6DafA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCYaE-00000002mjD-0f42;
	Fri, 02 Oct 2026 16:25:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 18:25:34 +1000
Date: Fri, 2 Oct 2026 18:25:34 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>, Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Prarit Bhargava <prarit@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] hwrng: intel - return -ENOMEM when kmalloc_obj()
 fails
Message-ID: <ar9qfsqVUScDGF7e@gondor.apana.org.au>
References: <20260922181102.67309-3-blum@kernel.org>
 <20260922181102.67309-4-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922181102.67309-4-blum@kernel.org>

On Tue, Sep 22, 2026 at 08:11:02PM +0200, Thorsten Blum wrote:
> intel_rng_mod_init() incorrectly returns -ENODEV when kmalloc_obj()
> fails. Return -ENOMEM instead.
> 
> Fixes: ee527cd3a20c ("Use stop_machine_run in the Intel RNG driver")
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/intel-rng.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
