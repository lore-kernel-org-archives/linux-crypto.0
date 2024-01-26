Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4091B80B
	for <linux-crypto@vger.kernel.org>; Fri, 26 Jan 2024 09:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259957; cv=none; b=smjqJPSKVB5Ao/idmriAS8flVHXf8CovpkNIHD9M5M0nSt+mcEFYM8TOLJ02KhhoPSP93+0bpuBMBM7HhrkpuI28EPZM74L8zM5pCZTrNvVMdQqsn7Jk3vaDbM5w/yoUZmmvK/ao/x6sKAgb90U5yD59jhU2QfoBt0RISyEYH50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259957; c=relaxed/simple;
	bh=/ZA3UKL2ERyjTCSs3HTe8lqXK6DewPafvWsngcCNVbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZtKFiDwzkeqE2E1VH2dPiUWGkVMfxjXOZ4WAFhY4WAIvUgXWgEPauQavTXhFrJcDBz1c2i9oESW7A2yulbwL/hTbi3F334Xqg/IFIIlqwrwo9CQWeVLXhMG39prqV1bL5fgVryQPmT3qXAlBzVsRKYCMf1YzGHEB7/tcadq0Pe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rTI9m-006EtU-FM; Fri, 26 Jan 2024 17:05:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Jan 2024 17:06:03 +0800
Date: Fri, 26 Jan 2024 17:06:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Damian Muszynski <damian.muszynski@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - fix arbiter mapping generation algorithm
 for QAT 402xx
Message-ID: <ZbN1+2qzutqF7lYP@gondor.apana.org.au>
References: <20240119161325.12582-1-damian.muszynski@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240119161325.12582-1-damian.muszynski@intel.com>

On Fri, Jan 19, 2024 at 05:12:38PM +0100, Damian Muszynski wrote:
> The commit "crypto: qat - generate dynamically arbiter mappings"
> introduced a regression on qat_402xx devices.
> This is reported when the driver probes the device, as indicated by
> the following error messages:
> 
>   4xxx 0000:0b:00.0: enabling device (0140 -> 0142)
>   4xxx 0000:0b:00.0: Generate of the thread to arbiter map failed
>   4xxx 0000:0b:00.0: Direct firmware load for qat_402xx_mmp.bin failed with error -2
> 
> The root cause of this issue was the omission of a necessary function
> pointer required by the mapping algorithm during the implementation.
> Fix it by adding the missing function pointer.
> 
> Fixes: 5da6a2d5353e ("crypto: qat - generate dynamically arbiter mappings")
> Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
> index 479062aa5e6b..94a0ebb03d8c 100644
> --- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
> +++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
> @@ -463,6 +463,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
>  		hw_data->fw_name = ADF_402XX_FW;
>  		hw_data->fw_mmp_name = ADF_402XX_MMP;
>  		hw_data->uof_get_name = uof_get_name_402xx;
> +		hw_data->get_ena_thd_mask = get_ena_thd_mask;
>  		break;
>  	case ADF_401XX_PCI_DEVICE_ID:
>  		hw_data->fw_name = ADF_4XXX_FW;
> 
> base-commit: 71518f53f4c3c3fadafdf3af86c98fa4c6ca1abc
> -- 
> 2.43.0

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
