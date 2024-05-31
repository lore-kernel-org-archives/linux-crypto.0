Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0A228FD
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 05:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717134485; cv=none; b=Pld3gr1NI6pBoJDbMnT6pL6RxZ18cYXyc98P/p/xHfrf0uRNmFt0aKUGvPf5keS6KV8/JKHbVaNcG8Et1LaEJnub6MZMzW5SajvJLHZk1MHvzaKFNxV+ZFS/jHumOGC93Gx6/EXJkzpHC9iN0VGsnpS8z8sRwwd7iZJ6xGFuox4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717134485; c=relaxed/simple;
	bh=ObWTi6TFcadZUcq6ZxKbymBP8ZJdQ2ZSzmIPTwa/5SE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tu2EaXXcHYYky40/l/u6JVmlDllJ3TELl58hte1xNItWYSqJGRm7x9/EavsGNmNHJCyRVfKRuIcQHVAct7Ny1ek0oe4Ns8xUJau1oRRjXTov9fbLCf9RnZdgVsVCghEPGNeiRC6WKWSMlr2bNATvObd3jq8kUIvnMlbmXSqMNvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=K52AJGvA; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="K52AJGvA"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2c19e6dc3dcso1367941a91.3
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2024 22:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1717134483; x=1717739283; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0UJbNmaJFMgZpBYeZAlCzxirBsjEUPoVCwt43VjRfB4=;
        b=K52AJGvAElcSYLab4CUXHpk4s7Qc2Tuk4H5Z0cUPoBrjdcugy2ETeuMT+oNSGE6feY
         /ZkbcBt3WLZYquQNYa5DJQpBQayrXn2nLENF3G84DnFY2t0Kz4bZ5VzCsYrGokeCX0QA
         tXZgFwr15EE3uTF6yTFcCYei9B3BxlRouRWYw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717134483; x=1717739283;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0UJbNmaJFMgZpBYeZAlCzxirBsjEUPoVCwt43VjRfB4=;
        b=JgTyfYtLRIUe7jVvzIsFvDq4TnJQm4vXkQ0xNPormMhi0HEVuwXkqnZzQKtfOu8xhH
         dJFWA0u+78Jmmx1hcUKn8M+08fmPlFT8yBQJ/R4DIK0SdmeQsVEVnj9IMnPc+eXBZcLb
         Eg7gu1Xwc2YJcsUhph0yWLUmGvVFcOKa5AnGJwuv83Eg4b4WvBwLIgV2ERgsmYyOmI8z
         4trLFz65p5TG9Azt8PrN4C6Z4EdQ+S6p9KrNoM+c8vn5qcs0ajZgL1pW0I7Uas6YVZju
         nI6kGqAefrNvMHqXP2PTuZEWbpl+WKFiVHLAg6A0nbOclmGQFa/UYOtBCLHiHBa0pNUA
         ZmpA==
X-Gm-Message-State: AOJu0Yz7CIJiJ+3uzSPjN33Tk6olYLWn89dDJADWkhwdWuVdlPS4P8Ot
	uxsOtQd1YtQPsJNutc1vW3czBQxpnGuIDqSKvIyDPoAp7ozxawAE0h2xRpckbPw/2lnJ1fwjXlo
	=
X-Google-Smtp-Source: AGHT+IFu2B7o010LYh4cB0fI2rrt7OvwTDZfg/9hOJpXql8dZOvxKD7uIYSl/vI+iPdXRjlTZ56EFg==
X-Received: by 2002:a17:90b:84:b0:2c1:bb0c:9af5 with SMTP id 98e67ed59e1d1-2c1dc56c21bmr876480a91.1.1717134483049;
        Thu, 30 May 2024 22:48:03 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:b7f3:e557:e6df:620b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1c28317ffsm690846a91.36.2024.05.30.22.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 22:48:02 -0700 (PDT)
Date: Fri, 31 May 2024 14:47:59 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 1/3] crypto: scomp - Add setparam interface
Message-ID: <20240531054759.GE8400@google.com>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <84523e14722d0629b2ee9c8e7e3c04aa223c5fb5.1716202860.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84523e14722d0629b2ee9c8e7e3c04aa223c5fb5.1716202860.git.herbert@gondor.apana.org.au>

On (24/05/20 19:04), Herbert Xu wrote:
[..]
> +int crypto_scomp_setparam(struct crypto_scomp *tfm, const u8 *param,
> +			  unsigned int len)
> +{
> +	struct scomp_alg *scomp = crypto_scomp_alg(tfm);
> +	int err;
> +
> +	err = scomp->setparam(tfm, param, len);
> +	if (unlikely(err)) {
> +		scomp_set_need_param(tfm, scomp);
> +		return err;
> +	}
> +
> +	crypto_scomp_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
> +	return 0;
> +}

Is the idea here that each compression driver will have its own structure
for params?

In other words, something like this?

static int setup_tfm(...)
{
...
	this_cpu->tfm = crypto_alloc_comp(name, 0, 0);

	if (!strcmp(name, "zstd")) {
		struct crypto_comp_param_zstd param;

		param.dict = ...
		param.cleve = ...

		crypto_scomp_setparam(tfm, &param, sizeof(param));
	}

	if (!strcmp(name, "lz4")) {
		struct crupto_comp_param_lz4 param;
		...
	}

	if (!strcmp(name, "lzo")) {
		struct crupto_comp_param_lzo param;
		...
	}
...
}

Or should it be "struct crypto_comp_params param"?
