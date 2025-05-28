Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915CE23CB
	for <linux-crypto@vger.kernel.org>; Wed, 28 May 2025 13:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748437631; cv=none; b=aEzDCKXSTXpL25qYCM14ndlH5Lfm/5GUOJOwdpEYsVTMbq+/CR99D8Zg9qzQzHrUP/RBruutdpoZ/d3AIS9jWLiRt2qfEoB8IlPnAVVvU4bjDZhXJmGsA+iIvb2QGsXdqvQCafMg28A6mA9ky1aJXVJis2ln52ohsi0oYwfbi0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748437631; c=relaxed/simple;
	bh=rKzdJjxN1ZBs/PBVJ3+ttMFFYU+EOv3UZFZn4wu6H0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Omk28oPyHDx5Ki4z7sATGE1c+dZWN2hMGsSx0KVZNHXk+l9ysxKIBp7dGgOlFf9NRXONU4ymdSWtzf40qfL3wpHNc3tWPSRLMNu3HKecqtRWcXremmil3dvFvC8DBrAFd7RrJJazWz1h1DtCtNHaG7t+hdlZjcQ1sfNsgASI9SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iqzwSksJ; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iqzwSksJ"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a4d152cb44so4069414f8f.2
        for <linux-crypto@vger.kernel.org>; Wed, 28 May 2025 06:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748437628; x=1749042428; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fJve3zndb49Vryo7N3DSl+geHmJfQfyEWh47hFf1fIg=;
        b=iqzwSksJ9ZYe8NdMOCm+KUaUk2jJIKBv2gof6NUjZxaZlg4eMtfccBER/8U/ClT7e1
         xeiH8ZHQPaCPviUcfWldTX0SotxyumIHIULpOPdXuJtqPVOmUuwcZgsQ8w4XjKFmh0qu
         Pi3HMFLBWVUyIDiYZ2VsqpclXD7TS0Z8KxRdoLVpJnICyAMhi6beFRugKOpqtww5wbX4
         N5xbgsA37HK67EhiKhjba7+IZnmv8adl459yNjqQX8ppb+90CVt/ZEi1TtLDacqKBThe
         eCdb4RgMeW1rjUSqs9OM+1Js9eF7yaJ9lbUke+/cHeV4VYPANHwmQsEjwu51N01bQGDd
         FcAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748437628; x=1749042428;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fJve3zndb49Vryo7N3DSl+geHmJfQfyEWh47hFf1fIg=;
        b=V1/NeIIebJhFBAiBcqs5fFfzIP5mHlSq2UTTPL2drzaCXzs3HtGGXh9W4wHFyIb6u2
         rw/WyUyGQsz0R9q8AR8cvVLeAnwtHk0RTNIOft1v7vzXaF9RwiWO5tHQ5SgwPTHnR/fe
         TH2CxMPT+YINiuKSKxLlbspJFPvbdWx5ZduMODVmhpFHOdjgjZYqql3oe9iV3HTTDThi
         0M0YsjEjumbc8HJouYm3lktk3yjprrFD39TjecS5tYuWLeggFKdkU5hYcWlzJrfCSqiN
         TtxdwRMcGdkxItmacr68oMQl2/dWsFS4IeZdbcb1NjDaI5foopROc7/eV/lURm5o1pAZ
         y+jg==
X-Forwarded-Encrypted: i=1; AJvYcCUzMZxrhHWxFDVGEMVmZGRoXhUi3QxuUFxFmERuTcEW+nL9BXF4TvwLqBjz8+Thkqfp9ziOg6mFa6z4UPQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgCsbw6olsNw2ofO3rwyDks6LtiErtux2cV43VDplZnL4Virb7
	Oj7SgLaxAenE65fanqx7S9Bkyh3JsQSj6t0Xfvv9h/f7gDe4TpBMCP7K
X-Gm-Gg: ASbGncvi9uFMO+fq9/JeR1CudFCXmrT+WDA+x2Ia9HErCPIwWbq66xLiPR1IlvYFfax
	EaX+R7IN87owrGzor2HN+hEOcLvqtxHape5c9JYFxrpvg0burX777ADZs6WBvjg5Y/mI4fKUsn7
	0ub+tZfeBJxeOVVxGPof2PmDuxtlNuJ3cI72VF6p41BE/EXA4D1ypbgdIBil+lyJgih6Z/Pf24n
	vxixhByU8YNHWeD/6wstYD3ESD32Wft2KQW+5h5gx64Si+cXynbo+uDbU+hkOwgU6l6MGlaPpbF
	uOUTH7mW9pYBNvpcy7VzoNTHue3Gt5YQTBYgczwXl0Zc3lj7HlA=
X-Google-Smtp-Source: AGHT+IGvtMs/Cym5cpaNwyMlymv1tXC9XRE6OCDxdC2LiAmRaVLNMwQdU/owkLojUjrEDLqd0tTKYA==
X-Received: by 2002:a5d:64cb:0:b0:3a1:fa6c:4735 with SMTP id ffacd0b85a97d-3a4cb474157mr15066112f8f.35.1748437627134;
        Wed, 28 May 2025 06:07:07 -0700 (PDT)
Received: from Red ([2a01:cb1d:897:7800:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-450787d3be4sm17314405e9.35.2025.05.28.06.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 06:07:05 -0700 (PDT)
Date: Wed, 28 May 2025 15:07:03 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, dsterba@suse.com, terrelln@fb.com
Subject: Re: [v3] crypto: zstd - convert to acomp
Message-ID: <aDcKdxPMLdOxFUEB@Red>
References: <20250527102321.516638-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250527102321.516638-1-suman.kumar.chakraborty@intel.com>

Le Tue, May 27, 2025 at 11:23:21AM +0100, Suman Kumar Chakraborty a écrit :
> Convert the implementation to a native acomp interface using zstd
> streaming APIs, eliminating the need for buffer linearization.
> 
> This includes:
>    - Removal of the scomp interface in favor of acomp
>    - Refactoring of stream allocation, initialization, and handling for
>      both compression and decompression using Zstandard streaming APIs
>    - Replacement of crypto_register_scomp() with crypto_register_acomp()
>      for module registration
> 
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
> v2->v3:
>    - Updated the logic to verify the existence of a single
>      flat buffer using the acomp walk API.
> 

Hello

Please use the right mail prefix [PATCH vX]

Thanks
Regards
