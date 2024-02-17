Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7E911CAB;
	Sat, 17 Feb 2024 01:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708132483; cv=none; b=kkLtZoTAH4QReUFZnWAuoxOx2mWerr+GDRcP+fUWpWLUHPT5mijMTrbwbsRuoDCjoGtg0be7egGf6T+hjO23PJoACvg+amg99Rz0FZpnjAqidzn+0kA76FBsbFr8XWePWBm4JDXYp7sI9wENU9yBMDLG33SU6v5zk2oZyvYDdNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708132483; c=relaxed/simple;
	bh=bjKF+MX7imkZSRBTn7UO1ZD4OI6rSpKz7bnLRBYvFaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MzKpwG/k9UV36yx9b7qPwhNYCG4/B9pRugbROjOBGFcubQRvv/x0Xz+/1jJyd6j54Y76o1zjFOz2flh1yt4NSc5Krhs6tP5d8GPvsEV2tntYRt0M42iRrsfMnmx7qQYnfaGkuHwrMK9SgtB6ntWlvrJGTswwqg8OAtruagPSPNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rb9Ho-00EeSm-KY; Sat, 17 Feb 2024 09:14:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Feb 2024 09:14:50 +0800
Date: Sat, 17 Feb 2024 09:14:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Damian Muszynski <damian.muszynski@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - change SLAs cleanup flow at shutdown
Message-ID: <ZdAIiqCPJ4nhkepw@gondor.apana.org.au>
References: <20240209124237.44530-1-damian.muszynski@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240209124237.44530-1-damian.muszynski@intel.com>

On Fri, Feb 09, 2024 at 01:42:07PM +0100, Damian Muszynski wrote:
> The implementation of the Rate Limiting (RL) feature includes the cleanup
> of all SLAs during device shutdown. For each SLA, the firmware is notified
> of the removal through an admin message, the data structures that take
> into account the budgets are updated and the memory is freed.
> However, this explicit cleanup is not necessary as (1) the device is
> reset, and the firmware state is lost and (2) all RL data structures
> are freed anyway.
> 
> In addition, if the device is unresponsive, for example after a PCI
> AER error is detected, the admin interface might not be available.
> This might slow down the shutdown sequence and cause a timeout in
> the recovery flows which in turn makes the driver believe that the
> device is not recoverable.
> 
> Fix by replacing the explicit SLAs removal with just a free of the
> SLA data structures.
> 
> Fixes: d9fb8408376e ("crypto: qat - add rate limiting feature to qat_4xxx")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_rl.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
