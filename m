Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BEB2076BA;
	Thu,  7 Nov 2024 11:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730979804; cv=none; b=QFbKuUVrsdE3Rp5VeobAXzu9y6QGs2jUbaiag8PaEETOGfdQwLMFtbPmjlIE1oXF5vHJdQkSquiOU49NSPPt2xzuq/UuQzekwx7lzxCYKynryaF0s0/U7OnlNTPWXx5elEriRP77mY6ugyR/PQAPiYC5MD2H/r8saDxeEyt2j38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730979804; c=relaxed/simple;
	bh=T028A5MmPSNjEPfr6NKkmeNU2bd2lvwO5vXFaDSPhjE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gwlf2KN6zlErkcrH0Ac8RVizqRZsXn9+7Dr6PghPt44guY+eePUT6l2oZIjlfE0u1vEN0goqNTw2BNfrE/UGfYFgIANmx3XQfuxfKMhTveXWblsRugq9KGOLjX6oY8K6XUv3EhykHrrilTzHMnU1TqXI7+7FDVLKnPWpT75bFWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=BiEwpqK0; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="BiEwpqK0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1730979798;
	bh=4Okfvzd2eQr6dRNHt7yCDBwWw5/wg/dsUal/yL3Sw/Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=BiEwpqK0s4x0OUCGOD+kvoaKS9tuCWyAZUnpNV+P05pY47FA+NDLfZ/JWKZp6/PeK
	 LPiJEMlpsFmhZgbLj+pEAU9H/nqekHkImAjNmt9grjgLaFNs7JUGP9HkNorncmuHx/
	 AZp4AlFzI9YMvuzlyB1EMBaFnxG0S2CllABXenX1m6YqEFeypKN3+u1YUFnmMfwNtg
	 xJWlA+ULvM64H9YSotQPBK3I+svyN6uMFBK/8axmH0XDREP0LvfJESv7I5akm96VCI
	 ujNar4HQrlP1e8LDBiJB9dmNthjjdZ3aDAgGlqI58SIdn9gkdBAG9x1ry5DnVm6lPY
	 LM7Hgj+n5bn6Q==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XkgF02sDzz4wcj;
	Thu,  7 Nov 2024 22:43:16 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Michal Suchanek <msuchanek@suse.de>, linuxppc-dev@lists.ozlabs.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Michal Suchanek <msuchanek@suse.de>, "David S. Miller"
 <davem@davemloft.net>, Nicholas Piggin <npiggin@gmail.com>, Christophe
 Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Danny Tsen
 <dtsen@linux.ibm.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Nicolai Stange <nstange@suse.com>
Subject: Re: [PATCH] aes-gcm-p10: Use the correct bit to test for P10
In-Reply-To: <20241106121019.25629-1-msuchanek@suse.de>
References: <20240923133040.4630-3-dtsen@linux.ibm.com>
 <20241106121019.25629-1-msuchanek@suse.de>
Date: Thu, 07 Nov 2024 22:43:17 +1100
Message-ID: <87h68jclre.fsf@mpe.ellerman.id.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Michal Suchanek <msuchanek@suse.de> writes:
> A hwcap feature bit is passed to cpu_has_feature, resulting in testing
> for CPU_FTR_MMCRA instead of the 3.1 platform revision.

Ouch. Good find.

Notably all IBM Power CPUs have MMCRA set, so the feature test is
essentially a nop.

> Fixes: c954b252dee9 ("crypto: powerpc/p10-aes-gcm - Register modules as SIMD")

^ which is only in linux-next so no stable tag needed.

> Reported-by: Nicolai Stange <nstange@suse.com>
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---
>  arch/powerpc/crypto/aes-gcm-p10-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers

> diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
> index e52629334cf8..1f8b67775658 100644
> --- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
> +++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
> @@ -414,7 +414,7 @@ static int __init p10_init(void)
>  {
>  	int ret;
>  
> -	if (!cpu_has_feature(PPC_FEATURE2_ARCH_3_1))
> +	if (!cpu_has_feature(CPU_FTR_ARCH_31))
>  		return 0;
>  
>  	ret = simd_register_aeads_compat(gcm_aes_algs,
> -- 
> 2.46.1
