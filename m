Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D6610E5
	for <linux-crypto@vger.kernel.org>; Fri, 16 May 2025 07:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747381652; cv=none; b=AJCiS6cX7DVFB8n4zyFXnVuYbs/fwmMIYzHhwiWnQSuax5RA3Tp/QxxA4qDYhvb8jVvtO/tgPGAhR2QotbAho8zgeKHPre5if2mErs/BnthfUnvGSL+jdgJp9Y5uNCO9Lr0b+GDXRpgP+Rk56LMpT64e1rqyL1zcHYtXEEdAP20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747381652; c=relaxed/simple;
	bh=Mk1ztH0sYUCh63H6RDEkt0DPwLNxga+FUbp9Z/Rl5U0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u3wd2iyzfmdQ93lbyG2qkUh0adSAfQg9d8tV2dh74CoJIEDdDM+HPooSvD4tLghlFDADskbCsCkTxGvwoqRvKEdXFmyl3UORR59xed1KQ0AX3tVBCnt+vRqjQU8euad0dT54tZELZgCm8ZIeLsws02CKX/VSz3dzEV2JcJNstmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=i8xdmKKi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="i8xdmKKi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Xcy96BGJhInjsVlvampiwQUQXXRWRG/GihA5EXMsZhY=; b=i8xdmKKi6Nq0s2EjVQUHU7JO4D
	MJHV6m2DKhT6/MuEdBJ/kbiT6on7iI+ulcoRpKAy+UufVwIwL2djXawdbpwS3dOEZjY44o4Aly25M
	H0VWATcrshdZIHcwMWaaPyRNe0V1IxD9MzBeahTAQDS+erEVZyuf65GgNeD6aqaQK7J/Bi0lobk6Y
	AR1QLIaqvwhAwsrtoOKWRcwHtsOu6raOldDyt/P/TajR1WBJwDpavY7P5q/MN2MiEtkKLV5HTEKQJ
	itkykQsueexJm8VOpOa5i/Cl9q3ZAGeSIG6v9g0mmHlNDIyq3nf8ZB3m88L66+cSmg8Nrn2vV3Xte
	Gw/j5jTQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFpmt-006WkR-39;
	Fri, 16 May 2025 15:47:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 May 2025 15:47:23 +0800
Date: Fri, 16 May 2025 15:47:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Ingo Franzki <ifranzki@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: Re: CI found regression in s390 paes-ctr in linux-next
Message-ID: <aCbti3N4mC2Sa8iy@gondor.apana.org.au>
References: <ee7489d9b2452e08584318419317f62b@linux.ibm.com>
 <9a6ec8ae5c7ff550b663f54189d93a67@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a6ec8ae5c7ff550b663f54189d93a67@linux.ibm.com>

On Fri, May 16, 2025 at 09:37:59AM +0200, Harald Freudenberger wrote:
> 
> I've appended a fix for this finding. However, as the reworked PAES is
> already on the way in the s390
> feature branch and will be merged into the next kernel merge window, there
> is no need to apply this
> fix to the upstream kernel. Maybe for stable kernels the fix should be
> integrated.

Good catch! This should probably go into 6.15 as well as stable.
 
> diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
> index 511093713a6f..8e92a7710294 100644
> --- a/arch/s390/crypto/paes_s390.c
> +++ b/arch/s390/crypto/paes_s390.c
> @@ -874,7 +874,7 @@ static int ctr_paes_crypt(struct skcipher_request *req)
>                 }
>                 memcpy(walk.dst.virt.addr, buf, nbytes);
>                 crypto_inc(walk.iv, AES_BLOCK_SIZE);
> -               rc = skcipher_walk_done(&walk, nbytes);
> +               rc = skcipher_walk_done(&walk, 0);

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
