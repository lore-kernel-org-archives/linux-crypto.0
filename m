Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922303002DD
	for <linux-crypto@vger.kernel.org>; Thu,  8 Oct 2026 08:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448251; cv=none; b=AcLvV2nTsex9+Jjo7OkypQTN8RAds0mo+ZD2H6ebgEKKOBIHaF12QdYwSA/EUHL84X0OquUAGS2t28UpIKoST2LIBLDzK7fBXMdjjaL+gw0SjHIeb3zzBleNYe6MoUU/nXv/UPdHJnIRUc/EaWQsDS6kSRV+uPWPinShDmca7jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448251; c=relaxed/simple;
	bh=2z7foNV+A9ZqDY33LFwDJEmgnkm5KIg4lbELzO2aff0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XhMJxFocfo9R7Z6HXlFwZlRFnV49akW6skZEAKAchEbS7aTKzCj7UpOqSUOVu2CoDeAxgS4JKy4emy1XiyG+DieiTeVXIS/PMQnHUM+/L9/WOPSP0cWynlZb+DgWJo3VzN5hbK7rJN0jgsUZopnQ/KkqEMuaChtDDsZgVKb8U24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Blny+af9; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Blny+af9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=HUS0m9nkAVt5akFvzEt3C9BHk93ENoKJofI3CAc0Jzg=; 
	b=Blny+af9GRuSjPKl1sqfGoY7GMhVWoyYuqRV2hfo3etG1pguzDjpqQ4oZI1nrKyJfEBYvAVbGuk
	cA9Gqd0FyI3sq1sSn0FrPFw0SEcq6GHSg5f2NvyxRv3elh6vtv5SjZHsgjNkYhgxKmS3UzMmBKqz5
	zszZhiG5pMywD6k3+VlukaxF7S70Dn7jSRPpHpi14yw86RZz7FhqcS9AhbW0FV/iOjzULisRo/TD6
	C6u2Kna+YvgCnUjKEKwVDL/JbMhgbf5A2kCYGKyonjfcFt9GcsFwAjnwsD+cfNAZMkphUlnsnrlM5
	Dk7sXAn+P/pTKOqvfNkOOW6+Dz5xKZwFqdWA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjWX-00000001o13-02xC;
	Thu, 08 Oct 2026 16:30:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:30:45 +1100
Date: Thu, 8 Oct 2026 19:30:45 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - remove unused get_num_accels()
Message-ID: <asdUtSboy8oa_FIm@gondor.apana.org.au>
References: <20261001122841.2271248-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001122841.2271248-1-ahsan.atta@intel.com>

On Thu, Oct 01, 2026 at 01:28:41PM +0100, Ahsan Atta wrote:
> The get_num_accels() hook in struct adf_hw_device_data has had no
> callers since commit d237230728c5 ("crypto: qat - remove unused
> character device and IOCTLs"), which deleted its last user in
> adf_ctl_drv.c. Every device driver still populates it and two
> implementations are still exported, all of it dead code.
> 
> Remove the hook, its generation-level implementations
> adf_gen2_get_num_accels() and adf_gen4_get_num_accels(), the
> per-device static implementations and all the assignments.
> 
> The hw_data->num_accel field is left untouched as it is still used.
> 
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c   | 1 -
>  drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 1 -
>  drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c     | 6 ------
>  drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   | 1 -
>  .../crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c   | 6 ------
>  drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c     | 1 -
>  drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c | 6 ------
>  drivers/crypto/intel/qat/qat_common/adf_accel_devices.h  | 1 -
>  drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c   | 9 ---------
>  drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.h   | 1 -
>  drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c   | 6 ------
>  drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h   | 1 -
>  .../crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c | 1 -
>  .../intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    | 6 ------
>  14 files changed, 47 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
