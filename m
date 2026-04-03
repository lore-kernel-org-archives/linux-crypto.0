Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7F626FDBF
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 01:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775178282; cv=none; b=lug6HiJSW9A4nJppQU5z37LAB5BrC/viEbovTqOekOSDYPen6Rn5LDfTBIwDnp3d2e0Zfir5N3kpI3Yva4eSROQvjkgWYSDpQQBWuvHtBOdXo55jGFljHxBn7XQMFRFXtDjIb3C+CgQHSF584OUgJ4+UdxGRxURyC/7Kq212KW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775178282; c=relaxed/simple;
	bh=N71k0NEaP6X46lXlUCG4hP0cgCkpgatYZl8h9RkdDYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jW5aep5eaPDhp2RPq9P5mUU5wilAH3TV/CAcW5RTqMqc6G6FAT5JyDx2VyHrVpTdheSgf83OSxBNK9OJPodZMMon3b1iVsTQMjdmBLuzX+kP405eLGJLPL6h6GiPfPTrngEwssMqaiZhEvLsn1lUvkI+9c5l5r983WbYqbOKWOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Q0Vs2t0o; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Q0Vs2t0o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=nPVABNdfJungBl8QNRbz973MFkL1/ekyuh2onsNSZ+U=; 
	b=Q0Vs2t0oDSZgRo5McMYuDfLkaBxbqJA2iUDPX7SwXELkGcBGao9fONh7UE+0+XIxE+p30Qtcb+M
	rReeNYpmDFfG7Fdr6tvsWQVLEFSf4BmdLVEZI8ZGeY4MNJf3aRFBu1YD3YafLvcBbCZD6xYLvgAlF
	QK9jA6/aCtacyjtEtwZOy72+9G51e/BonbJ4bhq1AUb/eQ5yNyEg6kWFYRLja9x+kClPiwvjwZGBs
	EtPZFsfoP10nhXF6TDqBBbqt6INoVYlii/bE23GS4Coc9VpmY/upO5nJAiV6UHxUY6uKTyzntBfVI
	mCkrkKpkHg1nkQufhDbHi+ysrBS+Jc2HwaeA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8SYD-003QyV-2Q;
	Fri, 03 Apr 2026 09:04:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 09:04:36 +0800
Date: Fri, 3 Apr 2026 09:04:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: Re: [PATCH] crypto: qat - use acomp_tfm_ctx()
Message-ID: <ac8SJNsa19QTRGBy@gondor.apana.org.au>
References: <20260324165221.114280-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324165221.114280-1-giovanni.cabiddu@intel.com>

On Tue, Mar 24, 2026 at 04:52:11PM +0000, Giovanni Cabiddu wrote:
> Replace the usage of crypto_acomp_tfm() followed by crypto_tfm_ctx()
> with a single call to the equivalent acomp_tfm_ctx().
> 
> This does not introduce any functional changes.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_comp_algs.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
