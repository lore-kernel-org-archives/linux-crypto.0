Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44778335BA
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 05:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744003442; cv=none; b=mwwADJtzR92oLPQk4+8aO8NesOUIYm3ehCq9d2ahSNPhjWRIMyhVsXXPM4DjKtH9paMPUcqNPJy3vbzg209MG7YOWUPljPpYVVs14MAn+f4Co43Kcbc5XFo3J/p/Clv5h7foF3UYtCDMptaDwEgm9H49J9AGj/eWp03aK0Lzqos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744003442; c=relaxed/simple;
	bh=B8hDgw2EP54cnNpGE0aYDiTfDDaf2Eq9SsV0Txs8X48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a5oKzr0oy38N8U/GhOI6o0vdYDzrs2bJpRtugTK55AHXQZwb+9hGiY234WBh+B6W08X2TLNoLi/NmlbglAWfFhly/0/DgGSFaIbfrJde1rQJSB+xY3+yk18AOGWFqqb+DMu9w3RzXQVREC0Zab8y+6eUx9YbbyFi1Weer9k5eRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=st6461Xd; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="st6461Xd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bhTPGQfwQLch+mX2H//WW0iLDXn/UUwyBBUHPbjpMgg=; b=st6461XdEiI2V8hlY0Rsls6lz3
	134s3IYOaLlGNbiBmD/d1qPY/gIy6NhYlvQUVHFzW5wJV46SM6Sax+zQzRIjtXspSBITbYYdDBXyt
	SLpWZhfAVRAY5qmcydLE1E+krDkuHw9BenXmmUKNhukQ1gR8vTnP8UOVXRtPFPtGJ4YRbRrb3oDD0
	jgjcyk0P6CqQHRoTx1nBDQJibxeT4//tA9IPQko5CX0f/xxgAorcY9fGdHSsRBkJhby+Ydn762Bzj
	UXarRJvIafSOfEbMieSFXTkXcqE9HA8mYeXjO/59k1gWX7GcnqjtIGfXW5dQSBVLrixP2BGKSHNCj
	L/0a/kog==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1exe-00DNIC-28;
	Mon, 07 Apr 2025 13:23:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 13:23:54 +0800
Date: Mon, 7 Apr 2025 13:23:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] crypto: qat - remove initialization in device class
Message-ID: <Z_NhahfkC2jB_8wd@gondor.apana.org.au>
References: <20250326162309.107998-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326162309.107998-1-giovanni.cabiddu@intel.com>

On Wed, Mar 26, 2025 at 04:23:01PM +0000, Giovanni Cabiddu wrote:
> The structures adf_hw_device_class_* are static.
> Remove initialization to zero of the field instance as it is zero
> by C convention.
> 
> This does not introduce any functional change.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c           | 1 -
>  drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c             | 1 -
>  drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c           | 1 -
>  drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c       | 1 -
>  drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c             | 1 -
>  drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c         | 1 -
>  drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c     | 1 -
>  drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c | 1 -
>  8 files changed, 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
