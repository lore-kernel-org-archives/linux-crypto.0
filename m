Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CB0192B6D
	for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 08:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730105672; cv=none; b=d++kopK+uoKvYnZikGAlNmSCzYrYnIBgk4B8xTGng3YKj+m/iIbVZWdUrglBCk6nE33DMjn37wRhP9gQbCS8grYpR+n729AOFbTkRtvib3nI0azycfxcQuSH5uOlX4ZIzG8UVOLnl4OFhOismi/3QLVLNDWE/dxeE8N1okBnPoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730105672; c=relaxed/simple;
	bh=YUetvKzd46adoVApbL2fh+0ppPiQVBMI3J39BvdqVfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=COK4lEWSYgtai7cL8iLqXRia5N5/oXYivr4JQtsy1FHVsVppauIFvjVB2jDmXNJzyACgTPxpz+Dxltwbzuelv7ypkJ3BK95Ad8ajrXmwerUeVeslpanY4yz/bCWawazwqT+MZI5FG6prdLtjmlkP9glZbFdl40D+ktLO46Md2RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G2om3ARN; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G2om3ARN"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-431695fa98bso39856845e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 01:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730105669; x=1730710469; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l/R6e74JyYvRc6gOjM1TEYninS6Et/kGOYELmgbhJKQ=;
        b=G2om3ARNFMCLl8BRBfwQSGa3nytgttrYTOZcWlmlJDmTTTt2lTEj9Gku/54REDAZW5
         l+RIQepstitStoDf8m/fHYKUYmHKMJUgQq4X7xfl9RM5HcvfXJNCsm16unsk1BDf5owP
         qC8+sUB1lV988pdAM0N2gC7eAOoI+DbXw0KeJuSXZRC+/X2YdpUa5yQcWm0ueD9f3MKh
         qfSfDjxGYr8ZY3pAZILr6ds2l2XgiO33e5dmyX7Xzmx/xRjafRndAZFXZdtLY7SJxBTd
         6ZRCOib0uhp5NhwIwc6UYrrCyiyo7MJV8G07BPy53ViZfSrMq7/XCZOxmYlDf8+ZaePK
         kSDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730105669; x=1730710469;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l/R6e74JyYvRc6gOjM1TEYninS6Et/kGOYELmgbhJKQ=;
        b=wAPl4wwxcxD2ZmYap6ZQgtTEKE6UFlgaTkABD7wO98Xh+Vrodflknr3ME0gct0zDGx
         fnNbGSdC06b+wE7JcOXPsx+fN8wLHLKvsp7KcblB4MDHaFOm+ScV1rARZZFOd5s+3A3s
         eZnZzErWgzZohsgWhE/uvG/mxWe2ULIDw1GZjyQjt0L44YWsh8hiyHuENGLEZBdVzv1c
         CmxKKzsNKOaFqu+7/5tAKmBFmpLi6xglQJRI4mO+gtI9qy3Nd69T2BXDTyUyJI1nKonb
         xJf40G8HN5xk6PFXaDDRLBLj1yPs6GzNtvevwYynCOLB5cBk3dJdNVg5IrZxv0goZOuJ
         ipkw==
X-Forwarded-Encrypted: i=1; AJvYcCUJxMFygRDUTzpItMcAmyQWIwkQxUixvZsOBmnpguuV/AQmO6dHn2mSEsZC0PfOvXQzszMyRhVuxilwRpQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjxpqAkqXSnO6a4R26CunhevSMlss4vG75LUqMJvD5SI/5xAhZ
	oc0RDFgSxUBmp2bDkyVI1rLruQ5tGuE+bO+bitRoDMOX1cDfaWHfius9K2sVBbc=
X-Google-Smtp-Source: AGHT+IFAR7aw2P0zLeO2hMSdxBoiLLXBRMAWipIDAb/3G9chQY281aHj3wqQikEwOL/Sd7zLxykqDw==
X-Received: by 2002:a05:600c:4f56:b0:431:52c4:1069 with SMTP id 5b1f17b1804b1-4319ac997c7mr67096825e9.8.1730105668837;
        Mon, 28 Oct 2024 01:54:28 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4318b567e18sm131027405e9.26.2024.10.28.01.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 01:54:28 -0700 (PDT)
Date: Mon, 28 Oct 2024 11:54:24 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Christian Marangi <ansuelsmth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v4 3/3] crypto: Add Mediatek EIP-93 crypto engine support
Message-ID: <2347a34a-f82d-44bf-85fd-e220c45deb8d@stanley.mountain>
References: <20241025094734.1614-3-ansuelsmth@gmail.com>
 <8011818d-bdc1-433a-a348-648955c55535@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8011818d-bdc1-433a-a348-648955c55535@stanley.mountain>

On Mon, Oct 28, 2024 at 11:47:14AM +0300, Dan Carpenter wrote:
> drivers/crypto/inside-secure/eip93/eip93-hash.c:162 _eip93_hash_init() error: uninitialized symbol 'sa_record_hmac'.

This one is a false positive.  Smatch doesn't understand bit flags very well.

regards,
dan carpenter

