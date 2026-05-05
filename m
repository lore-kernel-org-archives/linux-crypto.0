Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1883DFC89;
	Tue,  5 May 2026 07:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777966656; cv=none; b=PvkCVnpeOZVcei94QM5yi0YRraa5PxxO/Vg2CwuL4wTkb38N6c+uiOBw/+CN4l2R06kLm5j2V6eePeTAbXlf3CVeOP8icAiT/wEIlrkTxebbirsao5swap+PwGwb1hkHAKg3xw3tQgieEK0b5l04L80qnZxGavWp8bBIE9nhZNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777966656; c=relaxed/simple;
	bh=jU1lW0m0jQHg9R9mxOZX7cqdtS3+6JJA7vU/McmSfTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uIO25VJa5/sVwi780WYGxCFY++EEfDNichhge2QmOOpyaAE4sI7BJJqnug9QcyS8nPUXeKX+cCG2qoYTXc2ZMUSCr3FG1P0/2Ar24myhXPrH5Bp+7xxFzlDSZ38Z/TC5JNZ5RcocucgLjQMD5ef0nmSukNLfmiMH8ZtunZOm3HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spcBzBEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spcBzBEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26541C2BCB4;
	Tue,  5 May 2026 07:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777966655;
	bh=jU1lW0m0jQHg9R9mxOZX7cqdtS3+6JJA7vU/McmSfTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=spcBzBEvG+ukUTzGpk8yuibe8/Qx41+HJtR2l9UH8ueY9NRahZ2nwumaeoKw0E50a
	 V/IVOZ/UImFQo5uhm5TzvvZFOF3x+d3d4mtQwgYHvcUaIn3RjZZl+w/3E27Xkt2Acb
	 IWrobJ3lXq47WTR2sTaoSy7X2iLohVN8FH+7KvctNqoKbLHvtgbtVaAQFs2rbnnYAA
	 Z6ep7XXTZU9goSBXXunOntH+ldwj8tZBpboiYEImdPIkaq2CuWFU4Rbwy4tRA1se6O
	 7Jh3xxfquf9klGhoLE3DSVMFbSETCOGeZh/44Ma2Ep90brTLWOWlTuEFiV092zZHGu
	 ygQ0lMfATgS0A==
Date: Tue, 5 May 2026 09:37:29 +0200
From: Antoine Tenart <atenart@kernel.org>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: atenart@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: safexcel - Remove repeated plus
Message-ID: <afmeHAyypqb8qIyF@kwain>
References: <20260504173250.751589-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504173250.751589-1-olek2@wp.pl>

On Mon, May 04, 2026 at 07:32:47PM +0200, Aleksander Jan Bajkowski wrote:
> Remove repeated "+".
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>

Reviewed-by: Antoine Tenart <atenart@kernel.org>

Thanks!

> ---
>  drivers/crypto/inside-secure/safexcel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> index fb4936e7afa2..812ebabd1309 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -1475,7 +1475,7 @@ static int safexcel_probe_generic(void *pdev,
>  	peid = version & 255;
>  
>  	/* Detect EIP206 processing pipe */
> -	version = readl(EIP197_PE(priv) + + EIP197_PE_VERSION(0));
> +	version = readl(EIP197_PE(priv) + EIP197_PE_VERSION(0));
>  	if (EIP197_REG_LO16(version) != EIP206_VERSION_LE) {
>  		dev_err(priv->dev, "EIP%d: EIP206 not detected\n", peid);
>  		return -ENODEV;
> -- 
> 2.53.0
> 
