Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76241EFFA7
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 11:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742555171; cv=none; b=beUAHvEt7Q30bsIHQMALst13fTi6ZTJekd+sGORhK5NGic4kWRCaN+OZQAh7n+IM/bzfDBvswdXrJ7gPMoPGYL5MS3jBTtTfMSBANfCFjP2So3ML0645FqV+dE8ns7PVf66E2Oc7cxMpZefyDR/wAeKBIjFEuZDWWM3H/ILAZfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742555171; c=relaxed/simple;
	bh=Mpz4aeugx5la5dL4Tn+oLyq/Ib/sGnzfgocqlrV5ry4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SSm2miMhJHJcNAnijnmfwn/GVR548KfnWPc3FOUacve9RYv0fGNFgpflvrpNXwtUPxzV8bOg7Bc4lES3h5pSQWeBqPmcV8dyQqUKeZLu+3h22wTlN2I9RavFqkxv51KlJr1Ox31gmLGds8Nmqih5aL1zpGxRzz45ylTFjxZbwr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=RB7ir/gn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="RB7ir/gn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2Jb9o5CmkJkuv8ilR+BQa41kIEgvp1k0+h1Qt86dHa4=; b=RB7ir/gnXbSUU+8jXdLXNcrzBj
	p58MbKg1MlCu2Q8hppfEdKBuMKLXzieaXFBbvCfCA0PGLtfScrdkOgTtgtaefy7Xc/dLKSQXMDyUS
	gVkLJvlVJ+hSWMuvLbiedJKi9k2ih3lDbU3X4vDYPeHmaYBgl+B52mrAGTNCMxXLRtSxJlww7jacv
	prkvUv9vctf7DhZ2tWsCg4Ke2q4t3r0AKx1aRACwbPgXEvMogR+dQfvPmqXnuvY1l7U54YrxiiOq5
	vToy4rAQT955L5040TVXK/rOTjbAxA9vj7jN68lgbvDDowEx8uw4ZrsfihbqQpQVjb8QIzAPFY0L7
	eXuAhIiw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvaCS-0090EN-2U;
	Fri, 21 Mar 2025 19:06:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 19:06:04 +0800
Date: Fri, 21 Mar 2025 19:06:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Bairavi Alagappan <bairavix.alagappan@intel.com>
Subject: Re: [PATCH] crypto: qat - set parity error mask for qat_420xx
Message-ID: <Z91IHO63FHJDogSi@gondor.apana.org.au>
References: <20250314131442.16391-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314131442.16391-1-giovanni.cabiddu@intel.com>

On Fri, Mar 14, 2025 at 01:14:29PM +0000, Giovanni Cabiddu wrote:
> From: Bairavi Alagappan <bairavix.alagappan@intel.com>
> 
> The field parerr_wat_wcp_mask in the structure adf_dev_err_mask enables
> the detection and reporting of parity errors for the wireless cipher and
> wireless authentication accelerators.
> 
> Set the parerr_wat_wcp_mask field, which was inadvertently omitted
> during the initial enablement of the qat_420xx driver, to ensure that
> parity errors are enabled for those accelerators.
> 
> In addition, fix the string used to report such errors that was
> inadvertently set to "ath_cph" (authentication and cipher).
> 
> Fixes: fcf60f4bcf54 ("crypto: qat - add support for 420xx devices")
> Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 1 +
>  drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c     | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
