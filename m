Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C77425F7A9;
	Wed, 20 May 2026 01:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779240763; cv=none; b=T2txUucMB5DQdfZCtrjNluW1El4RFcj4qT0tArWVnD7OiGZZp/Nn0iNqiGPuTD6mTGKxHSLk2MbQuxFn2hBut4KmAsNsaI/axyp4TYc/RmGGh9sCCSIcQ56pqOnbl/nAH7glsfPEI37CMMR+cdcQnuBvm7RKO6jWcPliaHzO2Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779240763; c=relaxed/simple;
	bh=BdyJHuVpPY7zwcZprjiskqH04T+ITunPNyGUcbfOkU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NAqRJRFK8St1+Cl74jR24T1IlKc3EwftONN8jYJwo5xzAiVynKpYg7pjnbIHYs2Jwwuke4g4KVUkX4dUK1v/AtqfCg7LDvvzYjTd90QestwmLxpxUepPCijfciJ4swfwJFNG1y/R9oJUNq6REE/iM517zIn5KUu6hbyOSY8zIfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W/KRZRR6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W/KRZRR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A391F000E9;
	Wed, 20 May 2026 01:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779240761;
	bh=p4Ifn2jfqY/2F3xc53JoT9BDij/b4B+A2cu31tVOrUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W/KRZRR68EdnzZ66frFgeyI0iuQZC6UVvyaUVPRlnem7gxzcuTP/SvEB4sVEQ0Dpt
	 a6pB+xnLlkhrLoysrthPBZqNEK4ubtVRxynLK4CyuMmdAxqhSCmlGkPhuNgrEJc+8D
	 VfafEpOxGX16ZcajYAChYZMSdf22xAkHfViZ6EmgRmc6TR6RtJ+I3LewXekCi82D8J
	 CBzAkYQIyUnWQmPXPewspCDIC653pRuym6YiSVNI3x7f84aG0l2rKxeNZerLGfOjRl
	 QBogVfFJ2o/8EChX0amGFIBkY10aPfWR1H2GIzYV6HzD5qivfg5a7Ge9Vg98kNRdQG
	 +DbC7C8vb4xUA==
Date: Wed, 20 May 2026 01:32:40 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: liulongfang <liulongfang@huawei.com>
Cc: Chenghai Huang <huangchenghai2@huawei.com>, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	qianweili@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/sec2 - lower priority for hisilicon
 crypto implementations
Message-ID: <20260520013240.GC1875993@google.com>
References: <20260511004927.3469951-1-huangchenghai2@huawei.com>
 <fe78b23b-37bb-5995-94b5-64fcf9578722@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe78b23b-37bb-5995-94b5-64fcf9578722@huawei.com>

On Wed, May 20, 2026 at 09:22:49AM +0800, liulongfang wrote:
> On 2026/5/11 8:49, Chenghai Huang wrote:
> > From: lizhi <lizhi206@huawei.com>
> > 
> > Lower the priority of HiSilicon's crypto implementations to allow more
> > suitable alternatives to be selected. For example, certain kernel
> > use-cases do not benefit from HiSilicon's symmetric crypto algorithms.
> > This change ensures that more appropriate options are chosen first while
> > retaining HiSilicon's implementations as alternatives.
> > 
> > Signed-off-by: lizhi <lizhi206@huawei.com>
> > Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> > ---
> >  drivers/crypto/hisilicon/sec2/sec_crypto.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> > index 2471a4dd0b50..77e0e03cbcab 100644
> > --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
> > +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> > @@ -20,7 +20,7 @@
> >  #include "sec.h"
> >  #include "sec_crypto.h"
> >  
> > -#define SEC_PRIORITY		4001
> > +#define SEC_PRIORITY		80
> >  #define SEC_XTS_MIN_KEY_SIZE	(2 * AES_MIN_KEY_SIZE)
> >  #define SEC_XTS_MID_KEY_SIZE	(3 * AES_MIN_KEY_SIZE)
> >  #define SEC_XTS_MAX_KEY_SIZE	(2 * AES_MAX_KEY_SIZE)
> > 
> 
> Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Makes sense, but perhaps this driver should just be removed entirely?

- Eric
