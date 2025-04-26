Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B176A1A256E;
	Sat, 26 Apr 2025 20:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745699518; cv=none; b=NtjMudwsAKp7vg+LvNaQTSDMIgP4Ne8UXJpvdNZL4pExTJFVRyLbRlPVaE9SLuNp+nZOgIprIVfxtCqu1pT2EZaVVnNycB0hLIl09z+u4zy5x3v3WGgRSz8adeySBN3bjp23HKyW5JN3qwLob79c5auL3Gm8rAOIcU+IUt6d7dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745699518; c=relaxed/simple;
	bh=/d7WgnJlhFDFOPT/pMzYke23MSyxRdwvNSrZRgypGGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JGFAhMDRTbo+Wbjl66utugSCC/OBVyuu2MeCKuMR/NpcDqykjY9hm475M+aXmcu3UQqlnWHv3vNhGVsn6rGcOvXeGwsFkkNvVNWW1jxS7Y1bvBQvbT5srM3nOs8pScIVIWlV7bkUKjhpZq9z4kGFoF2WAoeOqda8ItKRce/CSR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HjNYLvvR; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HjNYLvvR"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-39c13fa05ebso2217079f8f.0;
        Sat, 26 Apr 2025 13:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745699515; x=1746304315; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OlrCwyFIoqZ6mkArF2EMwtxWYwKdteVMOtJ71tqXtAY=;
        b=HjNYLvvR5+TpU++bVJC4lEhITzfZpkGQROVlnmRxcC6LfS07xHYCvRA6qdNETSk+4B
         8uZvfI+dOH3loPaWh27XGjxh/Y5nhJUFR4G+RsTRKZtnWGFpW3LVzpK/rYmOPUsz5mKV
         NDqXKS5WgSNwKfFtee4gbrnjMBAFd17Q8bM0LrdmKz2n9ElLVIoCYFjhDAMasIEkzxAO
         DC9FA6g68Ii3lktt+acQRy+H4wWZLpIR233AlSaKWcTfOPsvCKvlOWBdMxWrdx9n4sQW
         c7BwuLMfPrm8pkc+oxXyHfB16dSl4+yFxG3b0bvZlcUK9j0AB3kRFo5fgNCHM+EhvkG9
         Tjqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745699515; x=1746304315;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OlrCwyFIoqZ6mkArF2EMwtxWYwKdteVMOtJ71tqXtAY=;
        b=LlqDN4kJKubTCgR/bWqQ2WcxXL5TgP1w5yxKZANX1HZn6u77w5V1aMlCgR2TzEiFOM
         XjnlI5l1Bxbw/JWQsvdHIHt/B1FDJYru/5GaWiLMnlQDiQAJqjlJxesrQKn+YYvp+gSm
         3yOVMqpuFkK18BxobPIdg/LeYUad/wLrQvlj+NnBTmbk7LpoZWFF0QTQxBhzB7kVOpEt
         1IQhwyQODAW0StJsA0OmHSOwxt5mg0Gk79kd0pVGV/z0RDsAgPKA+9p4eSjrLvyVsnva
         Aiq8KY32Mxbe4kPQo0CryBydYpJXbSiZut3FdeCPSXmmT5lrTZr4dyuVXHFfUZcQSqQT
         StFw==
X-Forwarded-Encrypted: i=1; AJvYcCUfr0M5R1h7IfPmNr4k5l61vT/Xf8fLhCpxraP1TIUerWGFM8g3/jOw89C9qRzcos0EI6SHZySz/PqRo3M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxB0xJh/N+WTw7R5OtScYnYBrECZVvK0AJVbRI+tYgJi0GxKwW4
	cA43niuL+LqQH4b035V76rpoYZ+sGfAQIVaNv2Y8NLpMZXt7JVRQ
X-Gm-Gg: ASbGncvAh7zscwTW9B7XHbogpTeKrRuywMkq/xtzqYedqsq+ecBty04Ys+igzHAdgT3
	kL3PT8D+fxqYCJ+E5sQj44ufj5Z9noQGvDoAp4atxE+3etvlXcPAN0TiKiU6xyyTCV5+1dF2KRe
	FDP7xTvK18z+GYdTOG5zCYDlu/stHN771B2rbYoilYxNRj5EmNCc5u/qDjM+EMBEqjLtzDipvtV
	aO1N6Svayxeqykc79yX75ixs7WpgKBqTjngJ1MP+aA0amuWtqUWpe6rrpAikib7PQ8RAwyE3xwj
	3Bg0UxkQDIMCF3pPLCD+mKqIoTObxWHh/gDOojZEdQ==
X-Google-Smtp-Source: AGHT+IFo9Zap7VRkBOdcGJybmP2OJOAo05CfEBwmnzTAL2vvIxeY33VY6vR+1R6pEs07a4Uy3ZySGg==
X-Received: by 2002:a5d:4ac6:0:b0:392:c64:9aef with SMTP id ffacd0b85a97d-3a07aa6ea9dmr2626657f8f.20.1745699514803;
        Sat, 26 Apr 2025 13:31:54 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a073e46869sm6534182f8f.72.2025.04.26.13.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 13:31:53 -0700 (PDT)
Date: Sat, 26 Apr 2025 22:31:51 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Clean up the crypto testing options
Message-ID: <aA1Ct6rhGbZlkBKY@Red>
References: <20250422152151.3691-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250422152151.3691-1-ebiggers@kernel.org>

Le Tue, Apr 22, 2025 at 08:21:42AM -0700, Eric Biggers a écrit :
> This series reworks the crypto testing kconfig options to fix some
> longstanding issues:
> 
> - Replace the inverted option CONFIG_CRYPTO_MANAGER_DISABLE_TESTS with a
>   regular option CONFIG_CRYPTO_SELFTESTS.
> 
> - Make CONFIG_CRYPTO_SELFTESTS enable the full set of tests by default,
>   removing CONFIG_CRYPTO_MANAGER_EXTRA_TESTS.
> 
> - Automatically enable CONFIG_CRYPTO_MANAGER when needed for the tests.
> 
> - Rename cryptomgr.noextratests to cryptomgr.noslowtests.
> 
> - Remove cryptomgr.panic_on_fail, as panic_on_warn can be used instead.
> 
> - Rename CONFIG_CRYPTO_TEST to CONFIG_CRYPTO_BENCHMARK.
> 

Hello

I have ibuild/booted tested this against all my crypto hw, no problem.

Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>

Thanks
Regards
