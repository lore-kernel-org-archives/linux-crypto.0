Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCD61426C;
	Wed, 23 Apr 2025 06:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745390870; cv=none; b=kSQukl2nWXQ/A6OMe8x7lmLMzQU5cUb5PGtRrLIZShT2ImaKWjcfGaQEJfnlbja6TWaTghgKCpv3CBHUYsVuei1Kilv/b2i5962Fpm3l9jFuRqzNCAFifYCSFmYN9+4+52aflSwr7uhV4w7JN/kew4fXfUq62tuq3bLfIlD8/vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745390870; c=relaxed/simple;
	bh=s/1X5YNyN+CdDurbJV7J7vZqXcyMtwS7lCt/LK+S5Gw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ze2Kuo24vrbG89nTV7aM8rccLxB0qnVcOfjIRkvIofOKiVG76bMSeVOQICdPz3YTc8ip7SZnVj4Kc3M854N67Ts1PWSXmYTvWYMqNMBHctw2jQHww/k7ckg8cKH8jpjG/DfYfS+nGYi+3eEYCfAGpuYyTbY8wYfrQgCmQZABXsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-523dc190f95so2635903e0c.1;
        Tue, 22 Apr 2025 23:47:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745390867; x=1745995667;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NNOx3PXNDnzinyO2ItTDl2s1Y3UOOcEz8gmDtrKSNt8=;
        b=QbmTpDaqFgDbNRWOW/gKYFcX7WT1BNnBTxCZf5xx89Vw+aaGgd6ZQc4W8GH359+6Np
         BUyUOA7C5KlfUX62Ld3UN2Hru30hK5+JwXahac46DUsxb/o1fHBESpKN4T7zxYDjX91c
         MwTl4uC8wDNNiWm3tL96ulmD3lh8XPCo5Bt5Abcf6ff6k4HQ6fYDl+GDn0yu4apWvL6m
         1dOhUXbOCZdLGDj0SOuqkS/ZTivrB2W7tnoi6wYeJvT58n2MGH7uGd7E/3LW3E/qg6BU
         eqUSO3QK/JJRpPNj7PwZaiTgIlGr7W+BF31l/dBsCVa2+uwkqc/zV98g+iDi3Sktgltj
         UQWw==
X-Forwarded-Encrypted: i=1; AJvYcCUAihJukWuo4P72m+qokUfyklxSGskIO90uOPZGVSKzf9uuqr3XS9ClvyZFK8QcGgteRXGxVslb2+QyfKc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfPrIC+Cdcrn8reKEs5PAZl2V3P45I9Qo1KekCAFhr83DVzMRL
	gJeLCLhkr1Jh0+Q/0PZKYp2QlBF7vQ4nxuIctd3ekJ3SC3XeZ+B29QvnWt5f
X-Gm-Gg: ASbGncsaKkbzZ8XcL4gL1aIglXLwfAtz4n/fgeY6rql8ptH8oIz2m90fGjnjS/DlLr8
	yxyPZZpit4psRkXM9nXm8fV5HeIS/2aTAdA7ikuO1ydrSsZ18KhmclWIU0E0ivK+gCfWafUbeVf
	23nz8EeaEGx9muskVIKW9OAY4PP7IDOjwJPTay3nRFm9KxANQJhQ56Fp5/QgZ1o5vCWk6IFK9FV
	p9FQ1qWsZ/xBBfQeaRXsHDOEXp3kCZYMJOsz3npzyneBPJ/Y6vVGDjaqD5fbIisFWjyMF0l5Tx3
	PpIAZ9NKgEaw/JFDO17W2pFv2Fb9tJaYmC/yDqqevdWoxLbv2Kf+UBCO5DUrn/5iH48xmegrQEo
	a73w=
X-Google-Smtp-Source: AGHT+IEIfwWSy3c6E6D6wo9aLLH4Ef+bsTbWC4uD9egJerATZDSzG5Mo78EY/hTZk/l/sNDfEznblg==
X-Received: by 2002:a05:6102:21a4:b0:4b2:adfb:4f91 with SMTP id ada2fe7eead31-4cb80233fa9mr10924892137.21.1745390866878;
        Tue, 22 Apr 2025 23:47:46 -0700 (PDT)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-4cb7dd7bf14sm2568687137.2.2025.04.22.23.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 23:47:46 -0700 (PDT)
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-873ac8037ecso2159063241.3;
        Tue, 22 Apr 2025 23:47:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVXweBVMg+totZCPKw7JDoZcHJtAm1zv4MIOsiVsLpMzZamuhxFdaAchGQknMFJ/zc8HLAWaWgTlRZPljY=@vger.kernel.org
X-Received: by 2002:a05:6102:55c8:b0:4c1:801e:deb2 with SMTP id
 ada2fe7eead31-4cb8011dfacmr9907626137.7.1745390866356; Tue, 22 Apr 2025
 23:47:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250419161543.139344-1-ebiggers@kernel.org> <20250419161543.139344-2-ebiggers@kernel.org>
In-Reply-To: <20250419161543.139344-2-ebiggers@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 23 Apr 2025 08:47:34 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU6coLggkFt-CKsaLJ7fCcc+8q51QFYUp6_6QgWtGfmrQ@mail.gmail.com>
X-Gm-Features: ATxdqUEAjYzB4VDfBMC5OibqqaiFWBcBJ1xMq81c3OoazPmPD4fLzYADLc586G8
Message-ID: <CAMuHMdU6coLggkFt-CKsaLJ7fCcc+8q51QFYUp6_6QgWtGfmrQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] crypto: tcrypt - remove CRYPTO_TEST from defconfigs
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Sat, 19 Apr 2025 at 18:18, Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> CONFIG_CRYPTO_TEST enables a benchmarking module that is only really
> useful for developers working on the crypto subsystem.  It is in a bunch
> of defconfigs.  But as with most of the other crypto options that tend
> to be randomly set in defconfigs, it is unlikely that much thought was
> put into these, especially when placed in "production" defconfigs.
> Clear it out of the defconfigs for now.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks for your patch!

All of these are modular, so I don't think it's a big issue, even on
"production" defconfigs. It just means the test is available when
someone feels the urge to run it.
Hence I try to make all tests available as modules in m68k defconfigs.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
