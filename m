Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864259;
	b=lMlRgbi9dyakIZuTydghbgH2onLR4rXgVwrjfvnGQChi1NOd0CmfNJraZcqYjuZ4UsHV
	 hg5oCrjw/6Zt5usiMQkWY0ImyOKk+yyL24/RjQ2i45GAVIIxr6b8/leU63/eUwYNCakb8
	 wMWdf/cfQkPSv3J1K4LsztMY70JJn/FcyFFNKdywmJeF+do2BcErAM4XszPbqXbdJ2k2B
	 GmfehFJ6z3J3MbqGL1bW0fkfEUqYch2+Z0UxspiHEP7m4acul3MnzRZnpGsAWkJij72Nb
	 VxhvShaE0WcnblNFNsrVsnMwXkCj5tUzClXEeB/WNtBB8LDwRG8KNJqQYqrGasNRHvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864259;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=nF1lgddmXzEwbIQR/XI4AlniU/W1R7lMyZGbYZTGFus=;
	b=gGmA6N9V5BletvNZSnbuf+/R8LHpX4OfFwQxASQx46BjscGXPbb5Lwq6HdX+1NmMAStR
	 jEvBonyLYAM6yzt7mZ7RON292Ef1vLWQpw28mZPVwMe1HCWBbxB2V8v3fRyUzL+GC/HOG
	 i+ZF4w+RWiT+1NCrDt8Q+YEongBFOnVuo7QpedFMCeenoujhf64sFgpMjzBBvuXDugXZq
	 5BcFmJa/bkXddbyst/VbwpckE64FXKCliG7cBQ9QEex9X2Md+kOL/oxPZwfxYRoDB/DmO
	 SegTZsFMUeSuuxp/ljxt6KxgXH3ss2oxPTm1FNA2qpPuaek38ZSRiBjrExBqP5uPAEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ej4Qwmji;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD5E606A330;
	Mon, 16 Nov 2026 21:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ej4Qwmji
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A8C1F000C4;
	Mon, 16 Nov 2026 21:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794864259;
	bh=nF1lgddmXzEwbIQR/XI4AlniU/W1R7lMyZGbYZTGFus=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ej4Qwmjiv120TbNI1IHtoi9NfN04FA13r3fMfGhYwts70KjNoKyZ5l9GzpgsnTXen
	 TO4I7Dgx3iSPXcYJ/0N+NsR25GTsowwGmz2pTqjLd+1Uf//8/TGjK6KpmYmmHbXSnN
	 tGu8eqwuDqsseHjzGdY0amctDPXOygpcXhw2NXQrABhjn/ar0a4mtbGERwa9r//wdr
	 8U2ik8CS6FQivmbt5HkmBrHv4+MvKPBhrzdGN78zaOjtI57wjPN9FBHddyzyBv94Wa
	 9Ay9vYq8sqe+tYMcp10+2irslI3wzC1YNB+vjGiayeUY5vEKbVkukoe6T+YP6srTbm
	 4wIcSMe3uTSmA==
Message-ID: <c99b891f-05fb-4629-b439-ac3828a4ea0a@kernel.org>
Date: Mon, 16 Nov 2026 15:24:18 -0600
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: ccp - unwind PSP sub-devices on partial
 psp_init() failure
Content-Language: en-US
To: Kim Phillips <kim.phillips@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20261116203622.615371-1-kim.phillips@amd.com>
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20261116203622.615371-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/16/26 14:36, Kim Phillips wrote:
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
> ---
> v1: https://lore.kernel.org/linux-crypto/20261021215716.1076732-1-kim.phillips@amd.com/

Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>

> 
>   drivers/crypto/ccp/psp-dev.c | 23 ++++++++++++++++++-----
>   1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index b14ce51065d5..3d9341c2876d 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -207,19 +207,19 @@ static int psp_init(struct psp_device *psp)
>   	if (!psp_check_tee_support(psp)) {
>   		ret = tee_dev_init(psp);
>   		if (ret)
> -			return ret;
> +			goto e_sev;
>   	}
>   
>   	if (!psp_check_sfs_support(psp)) {
>   		ret = sfs_dev_init(psp);
>   		if (ret)
> -			return ret;
> +			goto e_tee;
>   	}
>   
>   	if (psp->vdata->platform_access) {
>   		ret = platform_access_dev_init(psp);
>   		if (ret)
> -			return ret;
> +			goto e_sfs;
>   	}
>   
>   	/* dbc must come after platform access as it tests the feature */
> @@ -227,15 +227,28 @@ static int psp_init(struct psp_device *psp)
>   	    psp->capability.dbc_thru_ext) {
>   		ret = dbc_dev_init(psp);
>   		if (ret)
> -			return ret;
> +			goto e_platform_access;
>   	}
>   
>   	/* HSTI uses platform access on some systems. */
>   	ret = psp_init_hsti(psp);
>   	if (ret)
> -		return ret;
> +		goto e_dbc;
>   
>   	return 0;
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
>   }
>   
>   int psp_dev_init(struct sp_device *sp)
> 
> base-commit: 26ca5f34841f0a86d0883664a1c13be89a01d351

