Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8FC1272A6
	for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2024 10:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726222788; cv=none; b=IsrgM3dKpE7de4AmigEtE5bCHcy6k9y+cbpOLSLsUntATyHZqXlynSsTZ1sCUaReCiykPX81id6UOxRHkEad15GcgGF439TRc+SKHvjP897+ZhShoZV1QqQV22aIwLdGkMmylHGzUtQ+IRYKxsY/IDNXlXpnKAPEWwkohw/mYSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726222788; c=relaxed/simple;
	bh=PMFZ7A8Sj0yMRXBDm/g2jC60Ro2xvUbuMvpnPh/qnig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ux1bVVC1Q9iKMEy7ATf2GHVuKqJqYEAM989drZYQNmBSGAslwR8FUgpu+GeMg8pzoGSAhaUrrrsHn2rX6wh5jEQNMqOlvYWwSeWtQwhuV1Dmldqe9J8Xjx/fz7q6QdwU2jXbAgGcTsd/oV8tdCcWibj668rhGtHbb/VZl+idgPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IRW4kvBn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IRW4kvBn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wnjZmjd4Wy+T54pRyFjKLH429gdVCH831i4iiY1Mbsc=; b=IRW4kvBn0o7Ur2ggV3HLkgRHGH
	6a6a/sVOhiNvlpFXMgglwBd/qt6UYgj7lMaQxqIUECVV8fRe6nLfPHkhRx8Zwz1KXl9gNuEuIkztz
	r1Wp2EIdwFWmD0sTPhsZF05ZAvAoS/NKEOorzWx3KAjcWY0EPA+VmPjXUatULgFlMToLbDjsZ9b4H
	mCVL5MtrRDav1Pb5nt2z9FCsApLI4r3cJLwYqOd7hwQAUzvD0O2TM6HWsoJn4RpGZNY7rsx46HqTJ
	DDtx7InxCBS5pSXkwSh9pgCzwZi/JbLwINYXNXOlEjJkujYgnLaazvEqTA8bG/Ylnx7lH/mPVlwrI
	iaFSbEnw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sp3Eh-002Dim-0c;
	Fri, 13 Sep 2024 18:19:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Sep 2024 18:19:20 +0800
Date: Fri, 13 Sep 2024 18:19:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Li Zetao <lizetao1@huawei.com>
Cc: giovanni.cabiddu@intel.com, davem@davemloft.net,
	lucas.segarra.fernandez@intel.com, damian.muszynski@intel.com,
	qat-linux@intel.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next] crypto: qat - remove redundant null pointer checks
 in adf_dbgfs_init()
Message-ID: <ZuQRqP9CgDp7cuGi@gondor.apana.org.au>
References: <20240903144230.2005570-1-lizetao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903144230.2005570-1-lizetao1@huawei.com>

On Tue, Sep 03, 2024 at 10:42:30PM +0800, Li Zetao wrote:
> Since the debugfs_create_dir() never returns a null pointer, checking
> the return value for a null pointer is redundant, and using IS_ERR is
> safe enough.
> 
> Signed-off-by: Li Zetao <lizetao1@huawei.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_dbgfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
> index c42f5c25aabd..ec2c712b9006 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
> @@ -30,7 +30,7 @@ void adf_dbgfs_init(struct adf_accel_dev *accel_dev)
>  		 pci_name(accel_dev->accel_pci_dev.pci_dev));
>  
>  	ret = debugfs_create_dir(name, NULL);
> -	if (IS_ERR_OR_NULL(ret))
> +	if (IS_ERR(ret))
>  		return;

There is no point in creating patches like this.  It doesn't
make the code better at all.  IS_ERR_OR_NULL usually compiles
to a single branch just like IS_ERR.

However, I have to say that this code is actually buggy.  Surely
this function should be passing the error back up so that it does
not try to create anything under the non-existant dbgfs directory?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
