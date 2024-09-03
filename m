Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BDF1A0BC6;
	Tue,  3 Sep 2024 09:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725357251; cv=none; b=m+aWutV3MASBckfc7CeoABvPx+0VK/50jQrYqUIf5J5kCpCWL3tHTUrMEP46RvMnbYfvT3l4eZo1TNOa9PU8Y66tPTDZF/d0rGk8x6y2cf4I6ZXikRuJ0QWXuwAxJV6hwvHnp8mutnHyNzUfhPZ1DuKhPO3yT6h8rh0thxadXLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725357251; c=relaxed/simple;
	bh=gSZx9Ftz4YqeMezQVs7CELNKANVCRLqxaXuLpm8FapM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X/gG3hoGHGsQ3gprn2TJ3mAlNDMWmEzpvuQNuxACHUx9jeJJr1rTiYTpUYK5UqfuXjYi6btkz10laxuOx5vuCKR/BRj19rDxKBoRAUC+oFaWvN8BaM3jbGnFjaXJHetKDrXq0s7fqA8iwjUzW2p6mKGDDKVLksxAMcx21/NomPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=O524RKUM; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="O524RKUM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZiW7w/YZN8asOcWg8W2o5ZcuBXFyy+c0kNFOkdG5QPU=; b=O524RKUM3cduINesK7N1JErSJc
	aKLWjtUAvfa1stw1uzlQ+fOb2YVWX5qbPJyH/LMlnKJvfQQflIClgBGpGoSCP4VqgwGyp4gvwR/Er
	wjYKET80usDsnKvybZ7Sg5gt4G8KiX877M8WbiQ+MVObRmQm65xEb3EUTVMFVm0x+fAWkB9fcWVQs
	sniRD1yG22YXv8B1FWMRLtvDqscrDBG5J4ww7KQTjhuiefqA6Oau8845wUme9LPe//OmDoyPX4HFN
	LOtVNNgpc8X02qWFUn33hbZB9krmwfoZ/9kRLpFZdU1rVUf7JeA42PJG7smOd+cHCgpLsxLqkoGIR
	FRfB5MSA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1slQEc-009JHS-22;
	Tue, 03 Sep 2024 17:54:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Sep 2024 17:54:02 +0800
Date: Tue, 3 Sep 2024 17:54:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-crypto@vger.kernel.org,
	ltp@lists.linux.it
Subject: Re: [PATCH] crypto: algboss - Pass instance creation error up
Message-ID: <ZtbcumjZQAaF_5hS@gondor.apana.org.au>
References: <ZtQgoIhvZUvpI8K4@gondor.apana.org.au>
 <202409031626.c7cf85de-oliver.sang@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202409031626.c7cf85de-oliver.sang@intel.com>

On Tue, Sep 03, 2024 at 04:40:33PM +0800, kernel test robot wrote:
>
> Running tests.......
> <<<test_start>>>
> tag=cve-2017-17806 stime=1725329707
> cmdline="af_alg01"
> contacts=""
> analysis=exit
> <<<test_output>>>
> tst_test.c:1809: TINFO: LTP version: 20240524-209-g9a6f3896f
> tst_test.c:1813: TINFO: Tested kernel: 6.11.0-rc1-00074-g577bf9f41d61 #1 SMP PREEMPT_DYNAMIC Tue Sep  3 00:19:02 CST 2024 x86_64
> tst_test.c:1652: TINFO: Timeout per run is 0h 00m 30s
> af_alg01.c:36: TFAIL: instantiated nested hmac algorithm ('hmac(hmac(md5))')!
> tst_af_alg.c:46: TBROK: unexpected error binding AF_ALG socket to hash algorithm 'hmac(hmac(md5))': EINVAL (22)

This is actually expected.  Previously the construction error
was discarded so user-space always ended up with ENOENT.  Now
the actual error is returned to user-space.

I recommend that this ltp test be modified accordingly.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
