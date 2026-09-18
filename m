Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6609547076;
	Fri, 18 Sep 2026 09:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789722213; cv=none; b=dt63gLpPj8zGMm9VIQRbk2XzOyz4AEwSMTVxjQEekPncN3PcrjN5QZr0YsIP42I+Kx991rh9BRJX3SNNgjLlxhWHvh+HVxQfS4wHIpv9dyvhK/cZnRkSp6KmV8ethnd0+RG7rOZTTRyPQf7Juvfj5H+7jpeHmjB/WVBULkUbMGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789722213; c=relaxed/simple;
	bh=SmRpdnSy79TQXwRIfJf4QLYyNeoEKaT4lUq8NlSOkTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WuGp+GpGFEfj+JBXmoARWydAsblQR8yBbBavJLWa6qgOI3UU8ZOJowbFCr6v6Zv0ONdJRJjMvSj1zzsAZirASc3HlpnXgiLh5vsirJhq/zkb7+glONK5U8m109DD5+xAvJ1btJLM/uyxNwdB7dk/KFuMOjYHu60jObQfO/qFuvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=GuoDw64+; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="GuoDw64+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=iOgq4f3mB73kJ7lB0i+83zUxcceVtkVmTY4k5rR7t3A=; 
	b=GuoDw64+dVeVW2fwE/a4rEbB/h+0ul99IEWoxKa+LY5aJEO9BbITD207ShQmF2XmjWefNp9IXeI
	jgH1F11EW8rgbfEnDZ4IOj/+z3sQNSo4zMgaxCvATbq0UeUiaOy9t4y7PFBlKnk3mw6z4CHyEvYWU
	WYM2UP79gsMZC+59EP3rDNMEac4uRIttXfTkU9ixPJYdZ1pNHMRqaYLiJu4bEEiYdpgl1YzAa4zd7
	G4dSCvzfZnw1sG8IZW0hoD6xPgiB+PA+/GtVowuBtKAUsMDc0mvarboEHhB3UFpanCDQFYuORtkIa
	fwoh5JgIOYEKbZEPuMNV0bNYJRv+oTUZcLJw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7UV7-0000000FKs9-3rfP;
	Fri, 18 Sep 2026 17:03:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:03:21 +1000
Date: Fri, 18 Sep 2026 19:03:21 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, brgl@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v7 00/12] crypto: qce - Fix crypto self-test failures
Message-ID: <aqz-Wfa7sLNMlxym@gondor.apana.org.au>
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>

On Thu, Sep 10, 2026 at 03:00:41PM +0200, Bartosz Golaszewski wrote:
> This iteration - in addition to the previous fixes - proposes to split
> the QCE driver into a core part necessary to bind to the QCE DT node and
> enable runtime power management in order to allow to drop the
> interconnect votes, and the crypto part registering the crypto
> algorithms. The core module is then enabled in arm64 defconfig while the
> crypto part stays disabled by default.
> 
> The QCE hardware crypto engine has several limitations that cause it to
> produce incorrect results or stall on certain inputs. This series fixes
> several bugs and adds workaround allowing the deiver to pass crypto
> self-tests.
> 
> The failures addressed are:
> 
> - HMAC self-test failures for empty messages
> - AES-XTS returning success on zero-length input (should be -EINVAL)
> - AES-CTR: partial final block causes the engine to stall, output IV
>   derivation was incorrect
> - AES-XTS with key1 == key2 is not supported by the CE
> - AES-CCM: partial final block and fragmented payload both stall the
>   engine
> 
> All fixes were tested on an SM8650 QRD board with
> CONFIG_CRYPTO_SELFTESTS=y and CONFIG_CRYPTO_SELFTESTS_FULL=y.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---
> Changes in v7:
> - Add follow-up changes converting the QCE crypto driver to auxiliary
>   bus, adding the core QCE driver under drivers/soc/ registering the
>   auxiliary device and removing the BROKEN Kconfig label
> - Link to v6: https://patch.msgid.link/20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com

For some reason your patches do not apply, please fix this and
resubmit:

https://sashiko.dev/#/patchset/20260910-qce-fix-self-tests-v7-0-cdbd2718af14%40oss.qualcomm.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
