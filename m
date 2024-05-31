Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A504CDF9
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 06:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717137291; cv=none; b=iuCntAKAJRRLhs/mhy5P8JyL2gVlM5qPeYJDJaWMf68qxNBLGS3eSIKNHbIOIbqBjNETRgo24K8v95JWTAJ+cb8KfVkW+hfO6mQI5onjOCw628jNUX0JKHtGGFFqALQESGEjqgZ27PfyIHMallYqlTlLnocHuRn8tu9RrEfbh84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717137291; c=relaxed/simple;
	bh=8S+CcgH6MFMNQiCnuud0916L3xkZ0U132fyJ/b06AZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=liHDKuBf+Urt0G1dleXtJleFce6aDcdEymSmwRz6EFFnhwwk5AGJRZDjbFSocMOhMf/pw1igkgs4NLYwVHH1SEvMZUHtJj7VC018QINOlPlm98qNwVyf7hl5bn0w7KrRMY8sSZ7jc9RXtuxxaMkJ/tjeO2+nwZ/Gto1rxTbT0yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=KCwirEhq; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KCwirEhq"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-70244776719so370015b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2024 23:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1717137289; x=1717742089; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GEbjNd2SwxM+bzXhuQx2b6GIzGtjhTQDBWBT7w2BeSY=;
        b=KCwirEhqCXFmbcDqaaujsUMfQin/kEucDB0WggIuMusQ3nFIw1SC/tHWD4hE6/qkIg
         7Zyy4f1uwJytkxy001zek9iRVPy2eocf9o9sp8xjsc8imOho6mY0EOJeJfYEP8Ox0T9d
         LXONtMLgd5k3Z2rWvZBlfQKbTdss2zwG3xyh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717137289; x=1717742089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GEbjNd2SwxM+bzXhuQx2b6GIzGtjhTQDBWBT7w2BeSY=;
        b=wuJVwp8ugMIwjEQtMSEqAgmjOctMlSBLUwKMnrTU6plV+oQeoXzHGUyaOwbNLx3opF
         8OEF3LuD9znjb20aBrrzlKj4kBF9Mtag/mnEDQp9eV95kH86Iuslb3dnjRVtPSB24HZ+
         ala6S5CV9SDgXZegok4KHb/A6OAcOIdXz5shkSi9+gyTPkGt9TeR1D3/mZ72jBfmww4J
         5gOA8FnoRs4DhsPgPcoA/eB++7osxHbZowuzK3271wqN6S1VDw7IWYrhT29/ZGFNjk37
         cylECDe9zOp5+Qnh6YYmVuseLm970qFaLHiwXf5rGqw35uY/kmep/99PedK1POYMwGWZ
         oa5w==
X-Gm-Message-State: AOJu0Yy8UMWvr8833a71MWrraj/FgCS2fvaeC73IYD2oxRYUx52tH3fg
	cV0geUaePPbtzOQ31sXhMoWCJtVKxZMEdrPI+oi7UGv1oQCR8+qJV59qN/ZxE8w373wLURRNSCE
	=
X-Google-Smtp-Source: AGHT+IEihfLrnuUqe1p7FBgX4UZjI/BBJE4rtWa2pEF1+ckf/QVpPgrWQzEv1Epjy8/HfVuErVMPlw==
X-Received: by 2002:a05:6a00:1414:b0:6ed:d164:3433 with SMTP id d2e1a72fcca58-702477f9d07mr1034014b3a.14.1717137289158;
        Thu, 30 May 2024 23:34:49 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:b7f3:e557:e6df:620b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702423c7be4sm740902b3a.9.2024.05.30.23.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 23:34:48 -0700 (PDT)
Date: Fri, 31 May 2024 15:34:44 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 1/3] crypto: scomp - Add setparam interface
Message-ID: <20240531063444.GG8400@google.com>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <84523e14722d0629b2ee9c8e7e3c04aa223c5fb5.1716202860.git.herbert@gondor.apana.org.au>
 <20240531054759.GE8400@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531054759.GE8400@google.com>

On (24/05/31 14:47), Sergey Senozhatsky wrote:
> On (24/05/20 19:04), Herbert Xu wrote:
> [..]
> > +int crypto_scomp_setparam(struct crypto_scomp *tfm, const u8 *param,
> > +			  unsigned int len)
> > +{
> > +	struct scomp_alg *scomp = crypto_scomp_alg(tfm);
> > +	int err;
> > +
> > +	err = scomp->setparam(tfm, param, len);
> > +	if (unlikely(err)) {
> > +		scomp_set_need_param(tfm, scomp);
> > +		return err;
> > +	}
> > +
> > +	crypto_scomp_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
> > +	return 0;
> > +}
> 
> Is the idea here that each compression driver will have its own structure
> for params?
> 
> In other words, something like this?
> 
> static int setup_tfm(...)
> {
> ...
> 	this_cpu->tfm = crypto_alloc_comp(name, 0, 0);
> 
> 	if (!strcmp(name, "zstd")) {
> 		struct crypto_comp_param_zstd param;
> 
> 		param.dict = ...
> 		param.cleve = ...
> 
> 		crypto_scomp_setparam(tfm, &param, sizeof(param));
> 	}
> 
> 	if (!strcmp(name, "lz4")) {
> 		struct crupto_comp_param_lz4 param;
> 		...
> 	}
> 
> 	if (!strcmp(name, "lzo")) {
> 		struct crupto_comp_param_lzo param;
> 		...
> 	}
> ...
> }
> 
> Or should it be "struct crypto_comp_params param"?

So passing "raw" algorithm parameters to crypto_scomp_setparam(tfm) can be
suboptimal, depending on the compression driver. For instance, for zstd
(what is currently done in zram [1]) we pre-process "raw" parameters:
parse dictionary in order to get zstd_cdict and zstd_ddict which are then
shared by all tfm-s (as they access C/D dictionaries in read-only mode).
For zram/zswap doing this per-tfm would result in extra per-CPU
zstd_cdict/zstd_ddict allocations, which is a significant overhead.

Does this sound like adding two more callbacks to drivers
(e.g. parseparam/freeparam)?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/drivers/block/zram/backend_zstd.c?h=next-20240529
