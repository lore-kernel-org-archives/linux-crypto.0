Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81D32BAF3;
	Thu, 20 Jun 2024 06:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718865711; cv=none; b=a2yZvo61W+kYAyc9DeKqx8WUNXFAilUAWVrwgth7fh15WLtOqw6anIiWSC/0oSvUtgGR4R3gLVsA4d3q0MCwpoKZZj1+cVWhrHDobtIyeRnoM+0Y2z5/ynMzYEUfn1Zpyko7+TJErUTePZOEAK0QYLkuSdjTvwzvjG8es56ZOek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718865711; c=relaxed/simple;
	bh=X61PCRgIY2z6sVnDZpOzsWgDtdDJ6JoE4ZcWzPPwAAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P2vutDtsbkgXkeMpKg8KxCM3PspWBbrbQMWPWHr5Jtq5pypdO4VmR30xe0+66dl3cXaRqaT9xnHbok+x+PWP4247EXZgbpIsidTpSb6zPcSuMitgmzB03g9eJJrXf/sGNWcWCAwnzBOBeOgwdLac2eSkASPkKjDwD+gVq+QDCIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=egBVVmC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="egBVVmC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AAFC4AF07;
	Thu, 20 Jun 2024 06:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718865711;
	bh=X61PCRgIY2z6sVnDZpOzsWgDtdDJ6JoE4ZcWzPPwAAo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=egBVVmC7rmD3cF6lMTryq5aipxeu3PDtseK5AQEBmEARZxW0ZayrNcaFfkN35JACX
	 02U0BcWvH4kzEqF3fdqDJSwYUQ8L45NzIaDLml6hixGzYmQRt3oONKhvH+g8Cb/4I8
	 vqhSGizhS80ZCb/GCF+nzx40ekxgZ5jVm0OZjHIZwUdp5/scKIjUbqyR1A6dGIGs0F
	 vhSyPY5IdMG8SE0Sqmbis9s850+79/4ArqUMSgtimicEVCesQA/WvEnXhzmktC+yDZ
	 1RaQN1xQfk0CaXWw55Utw7NqU/6iZVEuWScdYJVNTirLhNTnAt+3m0APpFrtCBi8T/
	 wxoJthQTC1LAg==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52cc671f170so1391791e87.1;
        Wed, 19 Jun 2024 23:41:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUf4TSgosDg9bLvlapoBTyNlzc4m3qjSpRK9dpCEHfE2MQ3pizMyHrOUiJ76G0Q0SCM7o8fpZn6dDerjmEfXQpo0BlDcwJ+stes/s5O
X-Gm-Message-State: AOJu0YynUTMd7JWWg9iSooFJNFAXLGPC7bqkSTVK8lPizOD6YWch7IV+
	bac6gin1YLb1rACFcmPWnEj3JhuriOaS9iqjsMCCVmzjMqsoAbU8Rz2s7NWM6pA+UbOx7gR2XUw
	6jIuDD6SuXy8+xnMmOGZqJg655qU=
X-Google-Smtp-Source: AGHT+IG01DDjEcI34PxmR+Fo+pVV5qbIp5dvfYnUUJoOsoVen5OkcHRV6/R9dYZG9lEYx18JHXmzT8B0P//1qfo3sn4=
X-Received: by 2002:a05:6512:3049:b0:52c:a88e:945e with SMTP id
 2adb3069b0e04-52cca1f35bcmr1326522e87.31.1718865709626; Wed, 19 Jun 2024
 23:41:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mterW6Qqyz=oirYr1iV5jLRAvfU5yGGd2MOqpkwaE0qhQ@mail.gmail.com>
In-Reply-To: <CAH2r5mterW6Qqyz=oirYr1iV5jLRAvfU5yGGd2MOqpkwaE0qhQ@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 20 Jun 2024 08:41:36 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHYWKeGJvkPWVmOmOq8w4xCdx2DwxuGV1YoRxDubKh68g@mail.gmail.com>
Message-ID: <CAMj1kXHYWKeGJvkPWVmOmOq8w4xCdx2DwxuGV1YoRxDubKh68g@mail.gmail.com>
Subject: Re: how to verify which crypto driver is loaded by crypto_alloc_shash
 when more than one available for the algorithm
To: Steve French <smfrench@gmail.com>
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 20 Jun 2024 at 00:03, Steve French <smfrench@gmail.com> wrote:
>
> Was trying to see which driver was loaded by:
>
>    crypto_alloc_shash(hmac(md5), ...);
>
> and it was confusing because it looked like there were at least five
> drivers that export that cra_name (most presumably hardware specific),
> so was wondering what is the "default" that would be chosen and how to
> tell which of the five ended up being used.
>

You could check the cra_driver_name of the shash's underlying crypto_alg

crypto_alloc_shash(hmac(md5), ...)->base.alg->cra_driver_name
