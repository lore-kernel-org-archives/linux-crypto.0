Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795447051;
	b=Syd/SKnOb7Dv2MDpPMc/Ni9FRCehq4tUI6UAO1X9hdDgtzZwlrTLNrNoNYEPYDEQHQWg
	 Alf2bfLcAbhlEIbYBeUZ5JNlqz1mh4/u5mHiFW9qZe3OfGeJ6Xx1rFK+/bQmfS23Sx4vw
	 CQklzBRSB1Dvb9kiYjYzeqTwbHEDi3Pvq11JsaSki5/Ke/iSWFsl7j8gs1FGN3hP4ojrS
	 ym8qeWC0BihUBbnULHavgz+xawdJey//Upe7MpqtxQXsCzJu2MSep43Q7gyfjdIbrhiCz
	 Tnvwc3QRgLZbXgP6vY5wdUyn3dqoFItsc0jbh45rUQFQ8L4sdVgvVEosP+rkQULOTjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447051;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=C5aNcu3GvO5Up90upPaZCZkJZOPRV9A3kJARFId0yVk=;
	b=ii7cpf6BZZ2FNd2MKAbtkxFvc/TZ2Gvh3KEnvPeL7TW9pbf9Cs/VY8Tyn4jrdEAiurN1
	 072yxiDxwsWCZRyY4FBSFdsBHX7hfHX0TtyvhI/zt5/w3NAykyKC6E922GYjIGW1fvodI
	 RXgGRABDBCiNLvnzF8rCwFd0T8xzugsDqavZYuY+6PoIQxtxPon9wwE4zzcpKbmYx/w8X
	 isnCtOeDnhCukRUWAwKy+V5uby71JscXi8MBcnhCAvyR5+kVt1pPrwZspGSVyxvTzsdqp
	 vEbzHspcmRbF1YA7xtIBHwGZSB8osZwq6bbyeHr5dG0y7z9dNQXNDUej0HHEW/41HJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bry6XqTM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEEF606A31E;
	Mon, 23 Nov 2026 15:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bry6XqTM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE371F000D0;
	Mon, 23 Nov 2026 15:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795447050;
	bh=C5aNcu3GvO5Up90upPaZCZkJZOPRV9A3kJARFId0yVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bry6XqTMoBjePbT3l51cOq64wABJspYaYwOmelefOaG7NaZp91VnjTHeaJcw/eQ0t
	 gok3vzSyO36oFHeY/jb9eXfW2u1q5c6BmL994MbmYK14E4tX0/59Jh3GoZca8YfVj9
	 Ls5ZQHdQRaEvhwjzXrCmSr4Jy4r8yJFo5MPKoHqhcrGTijUO5ElPq+Y8SJTZTr4Wjy
	 OToWzwyDRHj38hopu+dTUjnchM1bZB+XadQeI7T4KGI0oY8lkP97Suiu2XJMG2NqgG
	 lDtT2muHd5qmyAc4d5paPL3PlbM4ytwvoWCoXEFd9GgupuwYq+yL6zNjKj3eCapHzC
	 h+q2e1XlrW2rQ==
Date: Mon, 23 Nov 2026 09:17:26 -0600
From: "Serge Hallyn (AMD)" <sergeh@kernel.org>
To: Kim Phillips <kim.phillips@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rijo Thomas <Rijo-john.Thomas@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ccp - unwind PSP sub-devices on partial
 psp_init() failure
Message-ID: <awRZBnEZxx-PTtT6@shallyn-amd>
References: <20261116203622.615371-1-kim.phillips@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116203622.615371-1-kim.phillips@amd.com>

On Mon, Nov 16, 2026 at 02:36:22PM -0600, Kim Phillips wrote:
> psp_init() initializes sub-devices sequentially but returns immediately
> on the first failure, leaving earlier sub-devices registered. Its caller
> psp_dev_init() then sets sp->psp_data = NULL, so the later
> psp_dev_destroy() on unbind bails out early and never unregisters them.
> 
> Non-devm resources such as the /dev/sev and /dev/dbc character devices
> stay globally visible while their devm-allocated backing structures are
> freed by the driver core, giving a use-after-free if userspace opens the
> orphaned device.
> 
> Add reverse-order unwind labels to psp_init() so each sub-device is torn
> down before the error is propagated. Every *_dev_destroy() is already
> NULL-guarded on its own psp->*_data pointer, so skipped or unreached
> sub-devices are no-ops.
> 
> sp_init() continues to ignore the psp_dev_init() return value on
> purpose: a PSP failure must not fail the probe, as the CCP can still
> initialize successfully.
> 
> Fixes: 33960acccfbd ("crypto: ccp - add TEE support for Raven Ridge")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-0de87f0c-0f5a-4dad-8ef1-f49844eb4cce
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Rijo Thomas <Rijo-john.Thomas@amd.com>
> Cc: Mario Limonciello <mario.limonciello@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

All looks good, thanks.

Reviewed-by: Serge Hallyn (AMD) <sergeh@kernel.org>

> ---
> v1: https://lore.kernel.org/linux-crypto/20261021215716.1076732-1-kim.phillips@amd.com/
> 
>  drivers/crypto/ccp/psp-dev.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index b14ce51065d5..3d9341c2876d 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -207,19 +207,19 @@ static int psp_init(struct psp_device *psp)
>  	if (!psp_check_tee_support(psp)) {
>  		ret = tee_dev_init(psp);
>  		if (ret)
> -			return ret;
> +			goto e_sev;
>  	}
>  
>  	if (!psp_check_sfs_support(psp)) {
>  		ret = sfs_dev_init(psp);
>  		if (ret)
> -			return ret;
> +			goto e_tee;
>  	}
>  
>  	if (psp->vdata->platform_access) {
>  		ret = platform_access_dev_init(psp);
>  		if (ret)
> -			return ret;
> +			goto e_sfs;
>  	}
>  
>  	/* dbc must come after platform access as it tests the feature */
> @@ -227,15 +227,28 @@ static int psp_init(struct psp_device *psp)
>  	    psp->capability.dbc_thru_ext) {
>  		ret = dbc_dev_init(psp);
>  		if (ret)
> -			return ret;
> +			goto e_platform_access;
>  	}
>  
>  	/* HSTI uses platform access on some systems. */
>  	ret = psp_init_hsti(psp);
>  	if (ret)
> -		return ret;
> +		goto e_dbc;
>  
>  	return 0;
> +
> +e_dbc:
> +	dbc_dev_destroy(psp);
> +e_platform_access:
> +	platform_access_dev_destroy(psp);
> +e_sfs:
> +	sfs_dev_destroy(psp);
> +e_tee:
> +	tee_dev_destroy(psp);
> +e_sev:
> +	sev_dev_destroy(psp);
> +
> +	return ret;
>  }
>  
>  int psp_dev_init(struct sp_device *sp)
> 
> base-commit: 26ca5f34841f0a86d0883664a1c13be89a01d351
> -- 
> 2.43.0
> 
