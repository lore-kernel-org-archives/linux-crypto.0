Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF732C029B
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 16:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759337113; cv=none; b=J5HGljClFBJBId7VcDMCO4YnTJ3T2m4PIaZOy9FRQIMxqyZPjkUOMUPe6AEYDCnWXGgOE+CgBAHIWOFDydNpyYKDbNxU28pfJEcL+kqArhkyc43b/L6LLLmJl226JvLnrqCBOjDCiAN3f/HrpAO8A6xXWMGuxsLTunHU6YDPtN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759337113; c=relaxed/simple;
	bh=K7YWwtRoXyrnO3YXAJ6rlkNgEypHfVsTVv9EU7Z16Qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MRPSkFsibwW3jIOf0GfHX57zzcXAttdY/13rK6LEYMwMa1RmjGUbmT8jMk+R9dQsz1To+yVHI5RYqKUoU41iXQR+UxC/iFi2IvdtT06c0zieIdtGWSfnFRZzjGg+jlB6e14C8vdZHdRJFDJX6cWHgqK41L0Gujdc0dVW19WKvYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b3d50882cc2so15965066b.2
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 09:45:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759337110; x=1759941910;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8RpMi9Th+Po7AoazGbT2yu6utd+ZudWSIE+dBXn6AEw=;
        b=HsZ/byAD6v5qoNnHdL53uEA5xxKfN/egp10JFVt/DzC4mNVsyORIFv5/Y36kQrzRUi
         qKGz3CMezRx7vJ2zy8iUqF6K+3ZY24PQ27q4dOHSLRbkibyA3+E74suMHnWTL6vGQ5y5
         pomKcYlzUXNOeuKGaNTBA7RKYa0Dt4jdSmmquF+7r/g0sPEeQWaSgWN9FrloQqYLTgvM
         /YuG88lwq5A+wZxrLShk0ZjZfWQngPWch1dcme3h8RsKwxSEDTotHoFMCG72IAtgD46r
         CcJq4uHnLOqT4dTbTDoD6uOaBX7/9BteBhDmH59c3lxL9E5GIHFDV1IFo52mLh43517b
         scyQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6GiDCcBxaCuVuT7FQP0uz7unPmxlY0qnICNt92LX42dk38ulxelw2mxOr06c/rMTJou7eAiGPJKoMRyw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCXHfN74uHN0BTNFe4HsY1w1CPc7X0OJ26aV6Nq7lXe/FGMEKk
	1QhjSjcfErL/UBs5UyqFKVzPUBspL9iT6ZHOevPEj/s0K4X+QGwMJ88b
X-Gm-Gg: ASbGnctwyPR8f1Zv9kYeoZnEOIRVOX0/gsPpbFeYGmuPrl4Cty5d9acMALr2CX4bmkB
	DqlXPUxkV36K7UT4FLak92NJ2005eLWd5M6/l5fL2loGTu6seUv9z6IH8UH+LHDqQhI5rtdC7PJ
	Jw3STjbdofXKhTTorS+YmWFpZJ5UY/uzxRqzpzAg7PT1GeDmN1+iJYJ7hhk4nG9y/7BYFrLqlHb
	Kc98Pn60AAErzlRnXynKPgrF8nADbeNoB7c8UKDo9z3ln/eeXCnp60a275KzmlN3NgHDYF8ENrw
	rNETzNaGzteIxbmGEkAyVGu6QEvzkiD4NAmYWAhOf7jruVugiLkxHwTlYnMXpqMiBhwDzgn0iK6
	BbQJgUaJ5bD8dpUtLm+DSADkgF4wuescblZefiQ==
X-Google-Smtp-Source: AGHT+IFaatL0zRpXljYvk9pU9uM41+0gFgUFUB28SfXW6ic2vlnE+OWGmtK1CqAf9k3bMM7SwTnkww==
X-Received: by 2002:a17:907:1c95:b0:b3c:31c2:b57d with SMTP id a640c23a62f3a-b46e99531a7mr534332566b.55.1759337109937;
        Wed, 01 Oct 2025 09:45:09 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:74::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486a178610sm1548866b.92.2025.10.01.09.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 09:45:09 -0700 (PDT)
Date: Wed, 1 Oct 2025 09:45:07 -0700
From: Breno Leitao <leitao@debian.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: gregkh@linuxfoundation.org, sashal@kernel.org, stable@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, Michael van der Westhuizen <rmikey@meta.com>, 
	Tobias Fleig <tfleig@meta.com>
Subject: Re: [PATCH] stable: crypto: sha256 - fix crash at kexec
Message-ID: <jm3bk53sqkqv6eg7rekzhn6bgld5byhkmksdjyxmrkifku2dmc@w7xnklqsrpee>
References: <20251001-stable_crash-v1-1-3071c0bd795e@debian.org>
 <20251001162305.GE1592@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001162305.GE1592@sol>

Hello Eric,

On Wed, Oct 01, 2025 at 09:23:05AM -0700, Eric Biggers wrote:

> This looks fine, but technically 'unsigned int' would be more
> appropriate here, given the context.  If we look at the whole function
> in 6.12, we can see that it took an 'unsigned int' length:

Ack. Do you want me to send a v2 with `unsigned int` instead?

> This also suggests that files with lengths greater than UINT_MAX are
> still broken.  Is that okay?

I've tested it but kexec fails to load it, so, it seems we are safe
here:

	# kexec --load kernel --initrd foo 
	kexec_file_load failed: File too large

> Anyway, I'm glad that I fixed all these functions to use size_t lengths
> in newer kernels...

Thanks for that!
--breno
