Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE2A2153D0
	for <linux-crypto@vger.kernel.org>; Tue, 22 Apr 2025 10:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745317469; cv=none; b=V2MX5trSKsMXTM5nwYYLghXoez88bqvsaYyxHev6n++ssguARB+w2uBczFb34AABxg4GBhmKkornj9GaTzIkRkUFfPoEX0Mf/9TFgYrn936Ohc0MlFYDB21pqFp/geUPa8g5hTBizQ+Cn6Gfa2gXYWu5tONfINscw4yrkYVR8VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745317469; c=relaxed/simple;
	bh=SgCvUZ2Dp0RNubBkgcpghs+gpJMLGKE0/0/7IcZzQyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YefIR3VgfhkCMR5jSsfjHwMPK364S6k1UfLrYBBLXJeaR6ZuQyVascNcV4ylx/CQqQ7yDSbcRF9PvKQcN2/3UTcKUJpDo5JEYsZIWNb+bXCWpYzteWaOMNioU9xPfRX5hReUC/AltNOrY0tBnxNKF7KVQPfNIaj4PlZaS98xtrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QpWEkbCG; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QpWEkbCG"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-39efc1365e4so1668190f8f.1
        for <linux-crypto@vger.kernel.org>; Tue, 22 Apr 2025 03:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745317466; x=1745922266; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rGpR7DHAu3crb15D4InspITnPezktxxxhM+Ewq44KWQ=;
        b=QpWEkbCGp9JY5duWuwOyD42AjKuQA6fT9QrM03bAUHnjjVoiYU4PYVG1GjMKBd2Exy
         pN99M/rhjZiVpTIhA7m6I8HlXU1J6fhOtPrNcU0VW0Jlqvjnic4+WE7IXsL8iiqgiL29
         X35JdXg0HxAd1gQ9vZlXHH1y6dvGQmcrXye8VtJowOIaj/MBEUMwi8yrmUhfhOM+fLM1
         1Og8a+ArJCxPmipkYE9GDAjUT3UkNMQKAuPRnc25wpF1nPWkLTUvIa4lwAOlytk9rl+B
         1fy9JqNj7XiYzwQCa+i2wMxEKZA66p3MjAxgA6C+UsrWkXmeuynXictud6uwrAfXaZo1
         oO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745317466; x=1745922266;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGpR7DHAu3crb15D4InspITnPezktxxxhM+Ewq44KWQ=;
        b=IgfTKjFgkQgNP8ZJIKBH4LNwNpfE6jWnEEwVZlpeZ8E0sf5aZBEgjyQMeo6PgYYGPu
         yKPE+V0cB61LLCurkZk2tgYBBXJ4tblVIdGzNk3lf9ogmyvE/zzL/ANmd302N5n31ldF
         8U89WiJwIyePcTKypI5c5qKQZoKUosttWX/Tb9DRKkeSk5c6m51hQS4/YW4hHQkGbcw7
         UzmR3hbEvP0gQ/e8K5Kt8ewlPN3QGBzxSB8eT0zlNuE7/tqwGxWZLt6Oc6/2N5LV0ryp
         6urwzau+eGghV61uSvx1/CJj3rh2QgSyUrcHPp2GceHEFr/O+p5RWgNakWrrquO3mCJ8
         v+XA==
X-Forwarded-Encrypted: i=1; AJvYcCXN+ABV6aZWiJhnpTYhh9tQPA9ACmf1oM0hzyEUHe2sQTeneex0y1OLnp3Cu6E7mxSspUlS/gJ3APp8TRE=@vger.kernel.org
X-Gm-Message-State: AOJu0YweNolwiCj8QiwpJ+UosuniqDl2432+dhtCwbHObfzUzdOfJHuy
	D1WAbTqq7PwZ9LxNCXIMCEussWZfKYJCjsT94jFz6LDaH/xU3F0Ivw85trYXCVM=
X-Gm-Gg: ASbGncv8SUEsKKhlkgmV2gZ5WNkAkffRa2XKATRwjcEWJNYrRdiwT3PYmJCJIs3p9LM
	PbrD4UqHwv4lzgnXm2TrUTHi77RdTgU86t0TNAC+ZOBcPsbgs5uXCBoJdctGoetOPDSC+u8RBka
	wIKBuhYugc5FqIooWht39JiqhgVDqe3NuP1Z5Jsikzs03lwa+wVYCmeOcINwCD6JchSHWiFJEa/
	bb16yrxlPmzus7y2fuppHs8fogvq+Zd5qbsRuZvQmRhBXcaYrfOepcnd04N8z7DNhEwszexNMcO
	xffCpSY1Mb7BryUIFUanFtVHzuuNwpz6tAMw1CUBcfftAg==
X-Google-Smtp-Source: AGHT+IHutLphGbGE1hCdZLvaGiMQTDK82f9s6pbuK+KpdDS9Fqw1DprMwHPrbtUhvJfTJXHudGQhPw==
X-Received: by 2002:a05:6000:40df:b0:391:ab2:9e80 with SMTP id ffacd0b85a97d-39efba51048mr10695810f8f.24.1745317465705;
        Tue, 22 Apr 2025 03:24:25 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-39efa43330esm14497713f8f.21.2025.04.22.03.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 03:24:25 -0700 (PDT)
Date: Tue, 22 Apr 2025 13:24:22 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Su Hui <suhui@nfschina.com>, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: using size_add() for kmalloc()
Message-ID: <2169828c-127c-4bf7-b953-2f1194b72830@stanley.mountain>
References: <20250421055104.663552-1-suhui@nfschina.com>
 <aAY0lyWzsRVDge_f@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAY0lyWzsRVDge_f@gondor.apana.org.au>

On Mon, Apr 21, 2025 at 08:05:43PM +0800, Herbert Xu wrote:
> On Mon, Apr 21, 2025 at 01:51:06PM +0800, Su Hui wrote:
> >
> > @@ -433,7 +434,7 @@ static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
> >  {
> >  	struct aead_request *req;
> >  
> > -	req = kmalloc(sizeof(*req) + crypto_aead_reqsize(tfm), gfp);
> > +	req = kmalloc(size_add(sizeof(*req), crypto_aead_reqsize(tfm)), gfp);
> 
> This is just wrong.  You should fail the allocation altogether
> rather than proceeding with a length that is insufficient.

When size_add() overflows then it returns SIZE_MAX.  None of the
allocation functions can allocate SIZE_MAX bytes so kmalloc() will
fail and that's already handled correctly.  Meanwhile if
"sizeof(*req) + crypto_aead_reqsize(tfm)" overflows then the
allocation will succeed and it results in memory corruption.

This is exactly what Kees did with the mass conversion to
struct_size().  I occasionally run across places where Kees's mass
conversion patches did fix real integer overflow bugs.

regards,
dan carpenter

