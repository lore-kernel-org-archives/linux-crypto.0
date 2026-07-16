Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E98409E01
	for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2026 10:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784198688; cv=none; b=QNKCFKztD7GFNx3GZfSeBo6LZXFRzoZTwDMwbNVw16IJaR7WV8B740YdQ+tY2veG8bW12zjo/Ef4Cbdp5KSAd+BtOCH4ekB5kgPBcdRb10WG6ukn95C7Lq7FhaEaQxr+VLPlv0CBNtEniYcocrEApZK9a3AXrn/Tw/zSYWhHXCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784198688; c=relaxed/simple;
	bh=QfvC1FGivIYwMNcU81A7ydKOruNfuDO836KrBsFCpag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EL4GIWWRWCmoVoh5nlZTVzlJ5/uqeeiOXLjQH2KE1C6PF1F6TdmuQ8d9Qaknanc+HdfwaH692ix38KAmhNLnYJENIZt/+ITOhdjbn+OkAldMMOzqNG1Xmu8Mi6tdsZfkIlr8tzkeSqtQmmr6QOBm+02fqYDdzfl64X+uk/GMv80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SqXxYypC; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SqXxYypC"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47defd0c1c5so2421189f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2026 03:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1784198685; x=1784803485; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bG7DiFK2AkiQJxlm6ywiTGbJgNucHDn6Zq82S4v139g=;
        b=SqXxYypCpqoUaKnL+1ZBREuJm+K0EsRLoUl/CwRpnYe/yXcrJOnNa+nDUTo/NFoOWp
         lncl0kx7gvH0G6f4I3aRSayMztXMUMoY9/i64H4YAarlczoILYjEZ2JYs8ZjYXzBzmqW
         H5R/EI05tkHFOWiqbWsaJP8/4N7vvZl0KIAhtLaE+STBCqJQK1g45GsRS4kjcbH2Ed1b
         b4H1mkgX+FsKk09gnEfNTsh/VrPfQP1dTp13Y+unoOOrUovq90z4h11PLdgjunYbgQlo
         zsBtGRZ0HW4cmVI7ZV8GmyxxJVnCEbqcLBQJ4tkPlLcIqn3p6dZT1KlInfwoIiLQyM3G
         f5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784198685; x=1784803485;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bG7DiFK2AkiQJxlm6ywiTGbJgNucHDn6Zq82S4v139g=;
        b=I/KN0K+Xk0z2RHlLp3evOT27sXMNeYiyb1rn9kahOO35qKmkuXE97dSAtDsaz79dCe
         DLDqyokEnq1X4AS4Ynl2xW5p5onryKa+cYIei/D/3ys/w9O04Xis9YIcgi33DKDDkrjA
         kmCoSPQOHTlSMufM9aAvhdfNPEyKkTGu6hTLwnaZL6YDlwmYb+sV0FcduxUBE44uaGcx
         wYMVxiviQ9SXCpUaDMsaNPvNIbmcSUYOkLiEhchQRR5JXE95d8RdZbxPysIvvBfVUall
         iQNIOFPC3BtUyTMemsSHtHgIvU+qNNRSo6PYDX2NIqPPzkSqx/QzQloTh6Ns0pvfOhtV
         AxRg==
X-Forwarded-Encrypted: i=1; AHgh+RpacrhG7rItYsGm8gimis9wobANEpES1TNz8MBJVi2P0sPG2r5eesSPp3MmyVOqyFZ7IHyHacw4DfTbHgw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXzeFQF/Z9UrFTYyrOXXSGKP1CPvYBYqE00YeKlBQdxQiUQosf
	6VY2bkJlrloOLXgAyCRpMEqi2feYxR0NJcdmnFX8ZHIe7KuOLL+PBxDkeJLZMmH3ZdU=
X-Gm-Gg: AfdE7ckFy90Ig3REBhpSX5YXDAczKk1OjyPkQkHOS4OFTiKC1cMq6ctHNPRURjoTeeh
	6F3tnfQNsVxRPs2LrdsDhHTCtypC7u0aSMgbcWEcGT9AZ7lVkELK+PJms3vW3IL3joDLWH1yVDf
	DWM3exqbBn7n3bRQ8+AiE/cmf9AZQGBCUIjwAgrQHGzcvlERGZCQtkBMBTziavjjYYiqENaUXVK
	38YGPim5cEJ+JyZJZBQzVBYR628oc5fthNfSjAKeArbQmqE9gIKTADWay0G33ZMUUAIIfDrJV6C
	fNPbxpbGJ7s3yZjuYkEEHlZIEAHKPoQtbDj6AkgnjS8uZMVHM+ubHgygxXYfN5vqTb9DsFiO6h1
	LiKic84bfXLicgyfIMgeXDLj76vVIfqWEDuANi5t6Dyjx0Q+Z6QT8C3ciugYqGvCqakFlkkWav/
	AHKds+gAq+NZdfGg==
X-Received: by 2002:a05:6000:310d:b0:477:6da:1b6f with SMTP id ffacd0b85a97d-47f2dc9c5b1mr23909548f8f.23.1784198684979;
        Thu, 16 Jul 2026 03:44:44 -0700 (PDT)
Received: from linaro.org ([2a02:2454:ff24:7210:a01c:aecf:c14b:e17e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464c1f84sm23851143f8f.29.2026.07.16.03.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 03:44:44 -0700 (PDT)
Date: Thu, 16 Jul 2026 12:44:39 +0200
From: Stephan Gerhold <stephan.gerhold@linaro.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Udit Tiwari <quic_utiwari@quicinc.com>,
	Md Sadre Alam <mdalam@qti.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
	Andy Gross <agross@codeaurora.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH v21 06/14] dmaengine: qcom: bam_dma: add support for BAM
 locking
Message-ID: <ali2F4dDuLRWJsfi@linaro.org>
References: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
 <20260713-qcom-qce-cmd-descr-v21-6-bc2583e18475@oss.qualcomm.com>
 <alYGGu7_3G6mJAzQ@linaro.org>
 <CAMRc=MevqXga1u-XC8LYc3hnjjzmdESntsSGYP25XECeeySfJA@mail.gmail.com>
 <alepDnRJmRLbFGRQ@vaman>
 <alewA9ubkYKHpnuj@linaro.org>
 <CAMRc=McZK1=S2SFgpCjtHSRecY0SiQWbBqsUxGX1w4229s2yKg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=McZK1=S2SFgpCjtHSRecY0SiQWbBqsUxGX1w4229s2yKg@mail.gmail.com>

On Thu, Jul 16, 2026 at 12:43:04AM -0700, Bartosz Golaszewski wrote:
> On Wed, 15 Jul 2026 18:06:27 +0200, Stephan Gerhold
> <stephan.gerhold@linaro.org> said:
> > On Wed, Jul 15, 2026 at 09:06:46PM +0530, Vinod Koul wrote:
> >> On 15-07-26, 14:43, Bartosz Golaszewski wrote:
> >> > On Tue, 14 Jul 2026 11:49:14 +0200, Stephan Gerhold
> >
> 
> ...
> 
> > I would avoid using struct dma_slave_config->dst_addr (like in v11) [1]
> > though, since it's more a "address to dummy register" now than the
> > actual dst_addr of the peripheral. That's why I suggested
> > struct dma_slave_config->peripheral_config.
> 
> As in:
> 
> struct bam_dma_peripheral_config {
> 	phys_addr_t scratchpad_addr;
> };
> 
> struct dma_slave_config cfg = { .peripheral_config = &scratchpad_addr };
> 
> ?
> 

I think you have the same thought in mind, but there are a little bit
too many odd typos in your example to give you a simple "yes". :-)
(Why assign &scratchpad_addr to .peripheral_config and not the struct?)

While at it, perhaps we could rename scratchpad_addr to have something
with "lock" in the name, to make it clearer what it is used for?
(lock_scratchpad_addr? lock_dummy_register? lock_scratch_register?)

Thanks,
Stephan
