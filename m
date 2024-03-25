Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CAD1B7F53
	for <linux-crypto@vger.kernel.org>; Mon, 25 Mar 2024 11:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711364738; cv=none; b=HiyzpPG0DsF9gqLH5ek9eaFugDLPDfx1PekyZewX/rB7Ud5lJLfwtTC+f5FGyObLTCp89AQ6fAgBFPg6xK3aUqSdWmHvlXxMGBIGFC6jgz/CalV7SlXszmqVEzcFshUhU/6yW9gO5yETsgkrd/4lr1bmS0KqsC/i4tzZft1TRrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711364738; c=relaxed/simple;
	bh=7iS7PHbquIUiCrCMtkBdkxuqi/jTqc2cY3j9OhS1Ij4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=amU6HUlogVnGZnlNMmPLVRu/SXceIq/Lhf1WTSIviQJTNix1anVqWdyvAHkENvWP/kgIQVJXY/XHdiuPlBw3lY7wVLbH2m/5NPZj4GCsuGgD0yxqR4+/w7/oda4CfYW1b35FhgefcXB629xna+jsakP7Jkqg5RoksPfi5L8ehx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yybf2YRz; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yybf2YRz"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a474d26fb41so158121966b.2
        for <linux-crypto@vger.kernel.org>; Mon, 25 Mar 2024 04:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711364734; x=1711969534; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FRILSzvwAIpvZwjiJmtXP3wS29AHppU0XGaszbPtEV8=;
        b=yybf2YRz6BdziJvnzuIzK0mlybWc0quywKx9lFEYwuMGpFGMwwuqd7rGVqTcWiCUW3
         u5Kf50ZmAXMWjZ+GVzGk7heO5znoRwDrB6jvIcukzzUm1eWgU/RVzCjnJRZpXBPLjo43
         CbKYaS4g1qIH+LPfFB38T6MPWDJbOo4WmrVcnpSb/pIB+LM7ftlKQxhZbjK6zezpxki1
         7QjLFn6ob9ipuRMF1uSgmuzp1bi2pqdlYVKXrfX+BqC3/qy0OfUiQfbvkVC2H6BEvZ7e
         v9aU1GJeto8AgaSTqYR1GBG2achbjMQBRMacmqkej2SVzjOfSuomr/GiDtspIxppE8gD
         f3Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711364734; x=1711969534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FRILSzvwAIpvZwjiJmtXP3wS29AHppU0XGaszbPtEV8=;
        b=e6NQWgw06QUKHuVWK8cD9nJqpno81w8I3leBWpYriOcovOrZrrqbzuw0JGQpVRPW/n
         KGq0Z2ODuNoqCbdswSMGAJiLlEio7VWXa+8Sf5ODUL8tYZpHPMFIiyuxQlYe+Q97JqsY
         uu49rDmmWRFpIpKUee5xatE48k5/+CkLUxNyUtQTT5Dk1VUiu/2uFMH+6G3yNZ2lf0pt
         pxfTZP7o5ylOgyUDZ7FsRTDOQ/XGpOR1yASMbPgTYdn/I/zzI9FWLxTODSoLcvol1USH
         mNE1ldhLFGQIjtkIJKse8K0FZOT/r4qJjuA5rdy5vQaRs0I0anUf+3EF+Qn1+y3hCLsH
         hDGw==
X-Forwarded-Encrypted: i=1; AJvYcCU0avuULXAlj8yoM6rD2M/XiIJDkJ6ptmAd2haDJGt5l4yIPKDvw5KAC9cL36RHNAIHwSsaXCyi+nYmShbIbXykr0QpLXnzAK7/IXpJ
X-Gm-Message-State: AOJu0Yz+m6ORooVtZscHHvZg186f/ZxKkkGl4BufefCqZUqNG414lkXw
	C6XMWmzb+WVmqUtZJE/omHtRZpTLPNll8d531UMVuifaKryNhtvE0Om32Gxgul8=
X-Google-Smtp-Source: AGHT+IEhtdf7x6x6qjqq4K75Nxdbj/nJMl44w91CE9A41I8PB9hLaFhw4s15oV2TjS9l0ZLDyPjoIA==
X-Received: by 2002:a17:906:40ca:b0:a47:206b:5951 with SMTP id a10-20020a17090640ca00b00a47206b5951mr4770720ejk.59.1711364733579;
        Mon, 25 Mar 2024 04:05:33 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id m3-20020a1709061ec300b00a449026672esm2901792ejj.81.2024.03.25.04.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 04:05:33 -0700 (PDT)
Date: Mon, 25 Mar 2024 14:05:29 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	Jonathan.Cameron@huawei.com, Laurent.pinchart@ideasonboard.com,
	airlied@gmail.com, andrzej.hajda@intel.com, arm@kernel.org,
	arnd@arndb.de, bamv2005@gmail.com, brgl@bgdev.pl, daniel@ffwll.ch,
	davem@davemloft.net, dianders@chromium.org,
	dri-devel@lists.freedesktop.org, eajames@linux.ibm.com,
	gaurav.jain@nxp.com, gregory.clement@bootlin.com,
	hdegoede@redhat.com, herbert@gondor.apana.org.au,
	horia.geanta@nxp.com, james.clark@arm.com, james@equiv.tech,
	jdelvare@suse.com, jernej.skrabec@gmail.com, jonas@kwiboo.se,
	linus.walleij@linaro.org, linux-crypto@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	maarten.lankhorst@linux.intel.com, mazziesaccount@gmail.com,
	mripard@kernel.org, naresh.solanki@9elements.com,
	neil.armstrong@linaro.org, pankaj.gupta@nxp.com,
	patrick.rudolph@9elements.com, rfoss@kernel.org, soc@kernel.org,
	tzimmermann@suse.de
Subject: Re: [PATCH v5 08/11] devm-helpers: Add resource managed version of
 debugfs directory create function
Message-ID: <486947a7-98fc-4884-a5fd-354677fa66ce@moroto.mountain>
References: <20240323164359.21642-1-kabel@kernel.org>
 <20240323164359.21642-9-kabel__6885.49310886941$1711212291$gmane$org@kernel.org>
 <f7c64a5a-2abc-4b7e-95db-7ca57b5427c0@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7c64a5a-2abc-4b7e-95db-7ca57b5427c0@wanadoo.fr>

On Sat, Mar 23, 2024 at 10:10:40PM +0100, Christophe JAILLET wrote:
> >   static int pvt_ts_dbgfs_create(struct pvt_device *pvt, struct device *dev)
> >   {
> > -	pvt->dbgfs_dir = debugfs_create_dir(dev_name(dev), NULL);
> > +	pvt->dbgfs_dir = devm_debugfs_create_dir(dev, dev_name(dev), NULL);
> > +	if (IS_ERR(pvt->dbgfs_dir))
> > +		return PTR_ERR(pvt->dbgfs_dir);
> 
> Not sure if the test and error handling should be added here.

Yep.  debugfs_create_dir() is not supposed to be checked here.  It
breaks the driver if CONFIG_DEBUGFS is disabled.  I have written a blog
about this:

https://staticthinking.wordpress.com/2023/07/24/debugfs-functions-are-not-supposed-to-be-checked/

regards,
dan carpenter

