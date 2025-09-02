Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AF62DE718;
	Tue,  2 Sep 2025 08:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756801702; cv=none; b=fwCy3gCcMoR9jUyqya53smWlOgHEvDLXZyzcxA3fYCjz4Zx4wr7ZQOB66jdR4sSG6kcJN0JG3IurFpQl0WTE8sQ7qqw0Ms+UWLXh2LfQbXtNdbWNszP8F6FarplN8cqJ6NW4nJ5pJdxbw+SBSQzN688XSarM9qK1kTvNEnX8GAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756801702; c=relaxed/simple;
	bh=fHtFB2EK/hQfYznyMzrSFtvE/NSVHxb0u1eXMQCohC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hrXJ98+PWqePUbcUlUF6uUvjWVDzDaP3Zu6ea2nLyRmtX5RCn3skS42LrIbucNnz7WztoO5Xbr2FkAXpKKfiZR9YhJChj5h/ujw6F7sQ0lTU/XJjp74jl+ZiVU3IJhKypnP6l4Wm9Du44sccbXvMP5HlEzq6NfeMpbiiZowDBnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dtO1WlLP; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dtO1WlLP"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3cbb3ff70a0so3175578f8f.2;
        Tue, 02 Sep 2025 01:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756801699; x=1757406499; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EYi7YS5Qq+0CzIjZoMG1Nokr/1cjz/XeUHMSUMjA068=;
        b=dtO1WlLPfKnBN3VQatzZHjE+f+p9db6U9ZiLBfa7YC5UWDw6j/LRpjzRK0zOr2Dlmg
         OLAbi6ncuxgZ6btI9dH8gA2Tx974YTAZM6WcbTnQnqdICiHfJKP0HZ7TmZmA0b3+XjJI
         lHRhpkgZOlMt4cGpbfNKuFyv0NellvmSEgXS2MTNnP1jaGCLR00Iis4QDFjQyxCqa+ED
         ZAhItzQVipfjx+VRexEglu6S8YmvGNOQFb18xcdnhR0PQBoADby+5iH32/8k6ZZPyXmv
         yi84ITotYaqXd7aujL1EkfrQ6QPDm3wpn2ZaUHrl7vWUMpQAIQc3+37ML4BTt7xlY30q
         OweQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756801699; x=1757406499;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EYi7YS5Qq+0CzIjZoMG1Nokr/1cjz/XeUHMSUMjA068=;
        b=WvZBfWi88ANE0q7vk+ahR59NpdynJMRuyfZ9OI9A9Wybxe2M4CZyg8SoVeR1HwpLVW
         YYjQuiUVtSWpvGllDOtgeWQCJDrlGWyrRvJO1l3j0nizG2noxL3qL0Lx4FghVca0kA22
         3B867LGrCumBpaY3pn3mUKZs4iHGF4i0UY3pwefoA/bFm99jvDKUhf38QVUyo64Y1d5M
         pwm7E3W2NRxripaDe493JrX1166fRbpsa1KugD6EgdcsVSbJsdNclFMNHCHiGkn5lMnV
         c2Qn/hVX2TkKQBYyazuZSf0rs7XSnUcjNmk5yUZGY+Fzd5SliiNE+gcra/34FDWN6gX4
         ZYfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYLaGr6AecPrykUdluAJnUkievmF/PRNh3xqgNKA9xVJlMhXD0Q6mFzlP7DqQD2Gp9OqOLDUlt6KaULCs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIACTMY2g7PGHJty4YbGRw3jPRc/Y4vr+mwEhcdVBfSs+ZhDu6
	Y5Pi8YPLNQahoYd7LNQrelSX4+rzSR1VwMRTI3c57p59lc2TjbGuh8O2
X-Gm-Gg: ASbGncsMMNQv9JknCa7wmtEeC0LaOVMgT2jHgFKsPx7bkH92E0Xadvyi9jGzWsugety
	to+dD9j0hRDjFkp7Q/s6D1foHIRp2gDHZ/ZaQlteqNUDQ5KJq/6GBhFUR2PYJridVwoJWcPfGYy
	cKAthr7Qzi94SvdJeRQZ/JKXHUkt7B9gqukK5R3BYpDmJQG4/EH59r816gl9MdpW2CvDBRnf83t
	XG9koueYBLnZZ95SmZNc+cOucZpO+Ha9o40muYS6vj3N5J0oKT8If7tu8gBLeUG2yHehK5rMKsh
	nB3RwBWdtfhtTSS11Elfsbgn/IpmKW/+T7/Cn9DQFao2F7iQqzntMpzu1dRwK4MLA6DYpsA0k8d
	l0Vmn9nwzY1FARdEjaEI9A8tICfdAG4LKVAaMvnGvo07ZhEwXNiB8KxZCxCi70qH9YY0AnpU8sY
	qmnu9aJ9hCZfxcF24=
X-Google-Smtp-Source: AGHT+IGEW3FMFNBENaH1qOwa3eT0f2IAy11Q8fanUxaWe3GVSuuH9Cwt+zbB5yUYHi9gyhn1+sX4jg==
X-Received: by 2002:a5d:5f4a:0:b0:3cf:5eaa:b005 with SMTP id ffacd0b85a97d-3d1dfc06e10mr7683379f8f.34.1756801698704;
        Tue, 02 Sep 2025 01:28:18 -0700 (PDT)
Received: from ?IPV6:2a02:2f0e:c207:b600:978:f6fa:583e:b091? ([2a02:2f0e:c207:b600:978:f6fa:583e:b091])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf34491a65sm18362516f8f.56.2025.09.02.01.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:28:18 -0700 (PDT)
Message-ID: <8130dc95-1782-47b2-99e7-d3b090e58f12@gmail.com>
Date: Tue, 2 Sep 2025 11:28:17 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] crypto: sha256 - Implement export_core() and
 import_core()
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>, qat-linux@intel.com,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>
References: <20250901165013.48649-1-ebiggers@kernel.org>
 <20250901165013.48649-3-ebiggers@kernel.org>
Content-Language: en-US
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
In-Reply-To: <20250901165013.48649-3-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/1/25 7:50 PM, Eric Biggers wrote:
> Since commit 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in
> API"), the recently-added export_core() and import_core() methods in
> struct shash_alg have effectively become mandatory (even though it is
> not tested or enforced), since legacy drivers that need a fallback
> depend on them.  Make crypto/sha256.c compatible with these legacy
> drivers by adding export_core() and import_core() methods to it.
> 
> Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reported-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> Closes: https://lore.kernel.org/r/aLSnCc9Ws5L9y+8X@gcabiddu-mobl.ger.corp.intel.com
> Fixes: 07f090959bba ("crypto: sha256 - Use same state format as legacy drivers")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>


Tested-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

Thanks,
Ovidiu
