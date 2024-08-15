Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA571AC8A2
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 11:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723720805; cv=none; b=pKoVg1DjzrYCdzDt7qn+80Mc1GpNu0DAEyvBOj7PZsbbmBwiawZ+rf5a4ANX7c96J3MfmlyZQSxVlluz9PUhYcLCPBv7l0Eoc6gRpozRA0Ic7opX9+af5bFEh2TRtc90clBMe0OtRjmqJclj7szLIv2pKWoY1fQnUATwZlIs3fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723720805; c=relaxed/simple;
	bh=yURztonZrBwHUHibkawREdePNMweVxOWwY8OJ0QSyB0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=r6LxBUriOlCmdhdANvzIvJdhC6XtZMQjyUqZvT6DJu+IOq6/THhYN1Vcdn7Sb6Spw2Gsj6muWxhziMsqAWgnSUnQZvutr/fT+Miqrhd7oyJjEx8NtrHSxKS88UkYHdJ9LwVmt7vXQJ6hGiWDgM2aPhTARBmlvHW9V7OoaNfvMDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NQKrB/tj; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NQKrB/tj"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4280c55e488so4070015e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 04:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723720801; x=1724325601; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nI4171woC8AbIwEQ7yZoKX44iROE7Q6gQWAZSkQrquE=;
        b=NQKrB/tj/k375VSGk79fmL9o7iqpTCgt1iPBQjzQmRdPJxdwqiI8sisfdLcez3fBmt
         1Yf1xUuaREFHR5CG5KZiJYA3ozkQkOOamKlSBIpO6ip1kMqCv6tkfeL9941j4jfWmYlJ
         eaam3qtZdLWsIACtVula3bGHggy4YerhlFQC5/2hL/C9qCa9XNb+YvAzJTWwO00V+cEr
         EDChFrKKSiBojYMFIgLtXKf9dRd0sMEi7k8cn6zSSytgJKFEgI8ZKtbEerIXcjX3p8ob
         7HIJJd0LsVXwIUL95Zp2AC7N3TlFGAx4GspXKBAVXMHovOeXWZIuNiKy4KGCYDWVDrnA
         EAKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723720801; x=1724325601;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nI4171woC8AbIwEQ7yZoKX44iROE7Q6gQWAZSkQrquE=;
        b=BHnlYLozqzvRM7WsSsKr72IAnYRhj5ZtG3mVLnZ1Qr4EIAfsDd40LGQ8RWGYY0nACu
         IKBm3fEXiccsyk6Vr8QVeiCg/R8mvbNsSLin5unZCAumhOCLeBmqRtn+y7WM5MzF9CvC
         WNCLNLg22VvxnoLBIVA0q3nyFB3UqZHgkwNwduklFzSIQ6mmPUz0ZJqNs2KKhuzAfbYm
         UJ3x15gpjW5Dvzdt6HJvetafhL29oIlYcBo/qr1/qnXm7pqT6A6zAeRneudyjypbm7p9
         3DDPvr8khlqB0CXVdLuDIwX8YJ0CMuzUoJWAiX/Gy7t4j0J/O02lufI47wWCllUWRvU8
         vZvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwfuxd4hl9ierlI+5g1muhuAnXFpi25W98Kn5osLPsUc0hOFN8y6hEsVY8OO7DHQma+mpjXeQlibAWKm63HqAIPmBXXAoHAajgOPPd
X-Gm-Message-State: AOJu0YyM6h3rZyl7Nc99yH9caDyRLxH6Y4vhzixJgXCH5l6tyfDe/8te
	PHHuLKwzSlM6PH7eoaJJ09dLuNdGYugfOr5+SwShpcBukb8VO4IGSEnxJjhO3aw=
X-Google-Smtp-Source: AGHT+IHd9j20vHOXcP9rlnZ9ILGmbI3Pz/RRtKxnfVhu+foJuiDVUD5jJfu6OyZ/hkQoLTos92SGtA==
X-Received: by 2002:a05:600c:500c:b0:426:6981:1bd with SMTP id 5b1f17b1804b1-429e233b139mr20497645e9.5.1723720801296;
        Thu, 15 Aug 2024 04:20:01 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429e7bfd90bsm16608105e9.9.2024.08.15.04.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 04:20:00 -0700 (PDT)
Date: Thu, 15 Aug 2024 14:19:56 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: Bhoomika K <bhoomikak@vayavyalabs.com>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ruud Derwig <Ruud.Derwig@synopsys.com>,
	shwetar <shwetar@vayavyalabs.com>
Subject: [PATCH 0/3] crypto: spacc - More Smatch fixes
Message-ID: <df1ed763-0916-41e9-bdcf-a1a51c8ad88a@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

A few more Smatch one liner patches.

Dan Carpenter (3):
  crypto: spacc - Fix uninitialized variable in spacc_aead_process()
  crypto: spacc - Fix NULL vs IS_ERR() check in spacc_aead_fallback()
  crypto: spacc - Check for allocation failure in
    spacc_skcipher_fallback()

 drivers/crypto/dwc-spacc/spacc_aead.c     | 8 +++-----
 drivers/crypto/dwc-spacc/spacc_skcipher.c | 2 ++
 2 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.43.0

