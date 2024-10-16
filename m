Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9DE208962
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 14:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729087736; cv=none; b=ZdrXgiry9oYXfTZUXdkRWwhF5cCWhOK7xmOKOJNkpLfIKtZ78JELiYt/3X6+Z1XP38DmuckA8S7W9tW0Wwyif66SAJ+6SGrjEEF1ss6SO4+C/zCCZ5X5yTBAFkN5W7OthcbIMAex02en5Cw/pqedk3LocRR7RvKKsq4iIlI/GbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729087736; c=relaxed/simple;
	bh=GQUJ3eKisCsTRvXDxMDYYOjc1EhHQWbwOFnOYSYPClQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gTqf8wybQT3wRCfNmX8rylPR+/nY32MyzR6ovbyVFiHrE1WZZ92Wpc62T5R33kaseuTwty/jV9ZRN394ocQkTIt0fHo8RS9WD8hjw3FjY4W5YknQrcTu+YdYBavHFfGI/ZO6d+VhXyn29LUk8n1M6qHYr9GkW6iWOLXVt6KysYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=cU4/ttkM; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="cU4/ttkM"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4XTCW61Hlxz9skn;
	Wed, 16 Oct 2024 16:08:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1729087730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mfFlAXRjsrFHQmKuUonxFC9FFmavK/xM3MW0wCAFJ9o=;
	b=cU4/ttkMxMRRDtDsMjijiLIlxqBUterVHQJ5g5gdA9SfpPUlkswgwBQxXafdXuV5/Rreje
	XvDxj++62GPBxSyJSq61gSsWCtBxri2+m1V3Jbag4QOa5ZlikQBJw8ULboTR6XFTF5gcnv
	dGgf9hXIfZ7u1sqw5nlIuUwxEDqUMTxlgfag/B5tzLjVlokNSdYAMJLrSvhYpgZ6XAWYTA
	E0+oS33r4AO1DtVnzsRHEC9i5nT8dnILOJ4KdB+8T5OSAlZO9ph9Ntu+PkZlzK8qXhvLc6
	2RgHrUSeuQN37wQJoEtgT5ezGC+WI35i+Xb3YzX5V7tpEhsf7fWBTz6/lFJmrw==
Date: Wed, 16 Oct 2024 16:08:47 +0200
From: Erhard Furtner <erhard_f@mailbox.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Subject: Re: WARNING: CPU: 1 PID: 81 at crypto/testmgr.c:5931
 alg_test+0x2a4/0x300 (Thinkpad T60, v6.12-rc2)
Message-ID: <20241016160847.1accffcd@yea>
In-Reply-To: <Zw9QzDg5StgUflMV@gondor.apana.org.au>
References: <20241010013829.68da351d@yea>
	<20241015200850.6a1d0e2e@yea>
	<Zw9QzDg5StgUflMV@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-MBO-RS-ID: f1541eae6aa4adfdfec
X-MBO-RS-META: yjzaitej3f8de48hdwdu961xmr4s3rpc

On Wed, 16 Oct 2024 13:36:12 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> This patch should fix the problem and I'll push it into 6.12-rc.
> 
> commit 6100da511bd21d3ccb0a350c429579e8995a830e
> Author: Qianqiang Liu <qianqiang.liu@163.com>
> Date:   Fri Sep 13 22:07:42 2024 +0800
> 
>     crypto: lib/mpi - Fix an "Uninitialized scalar variable" issue
>     
>     The "err" variable may be returned without an initialized value.
>     
>     Fixes: 8e3a67f2de87 ("crypto: lib/mpi - Add error checks to extension")
>     Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/lib/crypto/mpi/mpi-mul.c b/lib/crypto/mpi/mpi-mul.c
> index 892a246216b9..7e6ff1ce3e9b 100644
> --- a/lib/crypto/mpi/mpi-mul.c
> +++ b/lib/crypto/mpi/mpi-mul.c
> @@ -21,7 +21,7 @@ int mpi_mul(MPI w, MPI u, MPI v)
>  	int usign, vsign, sign_product;
>  	int assign_wp = 0;
>  	mpi_ptr_t tmp_limb = NULL;
> -	int err;
> +	int err = 0;
>  
>  	if (u->nlimbs < v->nlimbs) {
>  		/* Swap U and V. */
> -- 

I can confirm your patch fixes the issue. Thanks!

Regards,
Erhard
