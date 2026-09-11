Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1858839B97E
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 05:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789103686; cv=none; b=O4D9EwzYG7Az0yCrkX07UZhYZg9E/G11Rd2aScVrQioM9pOE+ZooyzvVdb70GUTSaQ+DOuBIyHmOxmNaMdO3Qz57GhR4C8jHE+qj9cBkcbyI2fU8UVCjxevr9BWCrA3maMKt7a1aaYHTVriD/KYRMtOA6jLcVHlZl3WX2m3dhn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789103686; c=relaxed/simple;
	bh=1tOJknf2AgLny+wu2xZL5G1nzl5VTclZUU0dYAYJOaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JuE9qNUzFBMYIrGzvKRawg++P/GgoODG//83gLncuo/vUpbwhwWxPedzbKt85GpXXAoDdCv+e3ca4yHgurvHwgPXwGLlDyUDAkmCpuN+Vy63Dr0rvNws+Gjqlw2keTjAb8Jqw8yZqZPdzoQpXPvbO44nWbBTJ5vrCz/59Bbi8SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qKG7XAFO; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qKG7XAFO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=gKwJ3jC0p+5hgc3NLAgzpd8950q9KCv960kZeqNk0OQ=; 
	b=qKG7XAFOuoE5+6NmKCFBvkGOTmD0/KXkoLz5NHztU+8E/MukF4YMqdbyZoeq59SljDy16WhRnDD
	JLIpJIhl6Bs85nqYVeY08OcpweSgIh3780b2xV/AkYQod5OEjxeIQTT5XiplR3Dh2KyxEvoxBu2wH
	kKl7g25DX8DdlZFsDTAJTAFOPsmwwBwJ0tasMeDHAo4iRXFMV4Ex5uHKJNU7So0VKBpztTkwsIUow
	2FMJXE31BeBz8KFDL8QKwZr1mx+sPVigHdjuPkImRSWtbKbtK5bXm6iA9xbxuZjyPvS5GiaUa6z5I
	GmKnSAvp51+d/hekxYJ1HD4ZXnjy6Fvwdfug==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tay-0000000CtwA-0bYy;
	Fri, 11 Sep 2026 13:14:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:14:40 +1000
Date: Fri, 11 Sep 2026 15:14:40 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - avoid OOB read when stripping RSA leading
 zeros
Message-ID: <aqOOQNR9wTnqQkDt@gondor.apana.org.au>
References: <20260824101744.382099-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824101744.382099-1-ahsan.atta@intel.com>

On Mon, Aug 24, 2026 at 11:17:44AM +0100, Ahsan Atta wrote:
> The logical AND operator uses short-circuit evaluation: the first
> operand is always evaluated, while the second is evaluated only if
> the first is true. Because the first operand dereferences a pointer,
> it may cause an out-of-bounds access before the bounds check in the
> second operand is evaluated.
> 
> Resolve this by checking the vlen prior to the pointer being dereferenced.
> 
> Fixes: a990532023b9 ("crypto: qat - Add support for RSA algorithm")
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
