Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FA95522F;
	Sat, 14 Sep 2024 00:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726275276; cv=none; b=jAvq8KJeRTIjWaoutxgU9m6T/+5rYsgS+Y374MGoUqLIm5hag+BKNYA15TX6oak403X/kKoyzGGBrGymH5lfgwykxbw7NzzN3zyYdQe4BCPLb69LcuNj3OSkgg4Gu4U2tErzkk75T7wZlFONMtxelpZUZcILXWyodBULWa+uGIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726275276; c=relaxed/simple;
	bh=71Mxsc00Dm7BfW+xFXzkqgOTmD7+9+zL0cKzfS1bR0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S84j3LYeDuzVwfvR8eFnoUkNLYTofL4CH5VddDfYFrdTqLh3RCKOklZmhbWiplkx5tKBxWW57tAKYT5bGCaD5oLh32pbIWa0hkelHjzhc5hPg5hWdBldSJC+9bhyAsjbOBfM9MBikha2pZHmfuRcROG+L+uKQCB2V+kellJ0Pbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Iv5qEgsF; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Iv5qEgsF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:Subject:Message-ID:MIME-Version:
	Content-Type; bh=lJkbF3iMBGWJtvxgguGivuOXH7NOw6sqGg/07oPeCKY=;
	b=Iv5qEgsFeIlK39z6jCZ8QBhaKjREdUZLof6lyp7noqy+zevZk3DLXGSr/49bB3
	yh9FaNkLGmt8JJ8XOgFPZrbNmF83yNdWwhh57DY1WljnIYV2Hny5ZE+Y8hIGNz5j
	DFeF9ajnYOp+hJYq/2todgsPSff2sHn0jDyqTXpDfwd1U=
Received: from localhost (unknown [120.26.85.94])
	by gzsmtp1 (Coremail) with SMTP id sCgvCgDn_SmL3uRmgAKRBg--.34555S2;
	Sat, 14 Sep 2024 08:53:31 +0800 (CST)
Date: Sat, 14 Sep 2024 08:53:30 +0800
From: Qianqiang Liu <qianqiang.liu@163.com>
To: davem@davemloft.net
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/mpi - Fix an "Uninitialized scalar variable"
 issue
Message-ID: <ZuTeivSjXN_uP-dZ@iZbp1asjb3cy8ks0srf007Z>
References: <20240913140741.5944-1-qianqiang.liu@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240913140741.5944-1-qianqiang.liu@163.com>
X-CM-TRANSID:sCgvCgDn_SmL3uRmgAKRBg--.34555S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKrWrZFy3Aw1DCr18Ww1rZwb_yoW3tFg_WF
	nYgF40gr18Jr10vr4FkFW2qa1F9F4F9rWrK3WxJry5tasFyrW3WFs7Xr1DXFZ8Cr4IqF43
	Zr43Aa4akr13AjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU84CJDUUUUU==
X-CM-SenderInfo: xtld01pldqwhxolxqiywtou0bp/1tbiRQtaamXAo6DjzAAAs3

On Fri, Sep 13, 2024 at 10:07:42PM +0800, Qianqiang Liu wrote:
> The "err" variable may be returned without an initialized value.
> 
> Fixes: 8e3a67f2de87 ("crypto: lib/mpi - Add error checks to extension")
> Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
> ---
>  lib/crypto/mpi/mpi-mul.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
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
> 2.34.1

Could you please review this patch?

-- 
Best,
Qianqiang Liu

