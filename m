Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440A017758
	for <linux-crypto@vger.kernel.org>; Fri,  3 May 2024 10:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714733635; cv=none; b=E83EN303U8O/r+/mp4TPakNTdjybeRTOR+2MxuN0hydXzmmNEW8VaD6MUM0w/z2qTPxp9GNC20JgOOARW06H1CBphRIPZEzG0u9gVxSa2X/hjKWmZQTIcd35+KjrZvwqnux0PRoEBIBzg5/ZGS4iCj1nY9fjW5aTNvAMn6Rw7NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714733635; c=relaxed/simple;
	bh=jouzIe433+XmDa8qk2FCJSeeinRfQmu588bhPGSgOVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/UC/LysphwjHw7cCD96CDklXAiMyJgm3kQ7Pyjgwhjateyd0Q5osEjvQIqmYx4FQvlPhZEy/npEaWBKq+bsqbBtjd+fpT3Qv/7hes8eNf2Rcji6+EwWunDO4KsPRCNg42m9Qp2i91/WTYLym1+iMi6/mjNLq5VdZ+RzJYySzPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s2qY1-009vWM-0p;
	Fri, 03 May 2024 18:53:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 May 2024 18:53:49 +0800
Date: Fri, 3 May 2024 18:53:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>
Subject: Re: [PATCH] crypto: qat - specify firmware files for 402xx
Message-ID: <ZjTCPaYYYJF6fALd@gondor.apana.org.au>
References: <20240422141324.7138-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240422141324.7138-1-giovanni.cabiddu@intel.com>

On Mon, Apr 22, 2024 at 03:13:17PM +0100, Giovanni Cabiddu wrote:
> The 4xxx driver can probe 4xxx and 402xx devices. However, the driver
> only specifies the firmware images required for 4xxx.
> This might result in external tools missing these binaries, if required,
> in the initramfs.
> 
> Specify the firmware image used by 402xx with the MODULE_FIRMWARE()
> macros in the 4xxx driver.
> 
> Fixes: a3e8c919b993 ("crypto: qat - add support for 402xx devices")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_4xxx/adf_drv.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
