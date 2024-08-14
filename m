Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243E680C09
	for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 06:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723616103; cv=none; b=q41k51PcTyW990DJ/wa7ne8UmgdW0430JdN8SQ+YfT99SSC5KpJ/UYY1P/+va4MzvoNYBRaO0qxDTVkKOjgxReZNHSo42ObueYqI9CPv3o8rPNI5zqIoz0uVyTaXPe7+0XUIr4nMfE8XZHmdLvzBdzg8ghznU/1SVw+Q0sL8/KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723616103; c=relaxed/simple;
	bh=o8VshW/qHMVax0T8KrHSJiaFvotvebrmKSHz14Kdu9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fcvzI5CgCFHApy5wyV/7qTD71UKkFwVAwQf3uOfncqiNazdGPnGFtJiS3fzve5oijRvDhrb91khoTYlcYlw9DPBdGnHCyjbI0GwP55U92047T3+aSnhTNGPKJXdiVbCF+FJ0NQ1IZ2btxAWSvc0IR7fQt7hu9T/R8QEPuPwqbb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TSaDnIFR; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TSaDnIFR"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a7aabb71bb2so649691666b.2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2024 23:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723616097; x=1724220897; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FZil0/SackO01yqLZXR+2a2UWsCCpCTO6qDp2xWbFuk=;
        b=TSaDnIFRKKhsqLPjOrHei3iZtwS/MZTCxiokEK2FnpcsAfGo6MTyy1qxxdWc2Uocpn
         B8MJt6WE8edB/tgUXvaB5MVQVsptXriDVRQwxsrHlnQ082sRJM24l2ReLjuejU/OgcIP
         9X4K8x+tfGT833IYCgZjyTNuGQenRZYQZYUKVV5MWLvnkQw6iB41IDJLvaq/ZLimQdZo
         S843pU6n5C+H2/cDDrCqOct7KHvyPWgwXxJlMn1VK0RrRyoHa063jtrxFolvyZk+yz4X
         w+f+/8MbxjWkH3rrDwNuIeVxOhuizsWKCwxvOECfCVgXw6D8MXudo/z0zr+18i/BrZsr
         3U3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723616097; x=1724220897;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZil0/SackO01yqLZXR+2a2UWsCCpCTO6qDp2xWbFuk=;
        b=w9xIL4D2ULOD6IkaahClNvuDGGAX1uZhR/EgQtZmRCwd8u7pJuZRHLUMCDZshfV+O8
         KpDjxF2zZ/D/7dxljI1t6xw3wDZUplfNr/L7mTa7JqT2ccTP4R7DPeT02iFdLL779sLs
         ufk5GHuCicJD3SzRX4hqVw3sHmnNPP1nJQP9jTfR6RRAsz+KF2N8/Pwtn/YafnYFHtqb
         0hiYuRpCpadtFRca+I99r6D2AeexTLLmR4aIxEQoF7zz9I7mYhpwmsbsqPWIH431I50b
         bRXBWOoBAoEnE4h0fygg52y1lj7m/BQyizJ8PCW52sr31CGqZVyjHUq43I7qam6+K9ms
         LqZg==
X-Forwarded-Encrypted: i=1; AJvYcCXsg1MmpKbasPSrqClpVFLnkZ765kQS6hMDCCdP3UMMmk0nvgAdip/TQy/aks1Tjpc+eRclCbWtC8X2XaCOMreA9IipECkcwdVDj4id
X-Gm-Message-State: AOJu0YxbRzEu8t4AUM9Y/7mk7WUt7DZLH8P9WSI0N5y6QWJAOYQpZWCh
	969cY80bS4JeVTRvgLVCxxIJVCHjLQ1QRiUY6/Z4KlXVL1nrHO4yFajGEI1ChNKEHJgVpKmcPtc
	=
X-Google-Smtp-Source: AGHT+IEyiaPYtVku3SMV2wUF47BKRW4I8CezTfvS5akSHpsseasFMRoJbGdiK3WHTsvFhslKwpzhNg==
X-Received: by 2002:a17:907:7e9c:b0:a7a:aa35:409a with SMTP id a640c23a62f3a-a83670701eamr98104766b.68.1723616097191;
        Tue, 13 Aug 2024 23:14:57 -0700 (PDT)
Received: from [10.156.60.236] (ip-037-024-206-209.um08.pools.vodafone-ip.de. [37.24.206.209])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f414e37dsm133209266b.173.2024.08.13.23.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 23:14:56 -0700 (PDT)
Message-ID: <7ee049f1-17fb-41eb-b52c-60cc4cdf9a40@suse.com>
Date: Wed, 14 Aug 2024 08:14:55 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: x86/sha256: Add parentheses around macros' single
 arguments
To: Fangrui Song <maskray@google.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Thomas Gleixner <tglx@linutronix.de>, linux-crypto@vger.kernel.org,
 x86@kernel.org
References: <20240814044802.1743286-1-maskray@google.com>
Content-Language: en-US
From: Jan Beulich <jbeulich@suse.com>
Autocrypt: addr=jbeulich@suse.com; keydata=
 xsDiBFk3nEQRBADAEaSw6zC/EJkiwGPXbWtPxl2xCdSoeepS07jW8UgcHNurfHvUzogEq5xk
 hu507c3BarVjyWCJOylMNR98Yd8VqD9UfmX0Hb8/BrA+Hl6/DB/eqGptrf4BSRwcZQM32aZK
 7Pj2XbGWIUrZrd70x1eAP9QE3P79Y2oLrsCgbZJfEwCgvz9JjGmQqQkRiTVzlZVCJYcyGGsD
 /0tbFCzD2h20ahe8rC1gbb3K3qk+LpBtvjBu1RY9drYk0NymiGbJWZgab6t1jM7sk2vuf0Py
 O9Hf9XBmK0uE9IgMaiCpc32XV9oASz6UJebwkX+zF2jG5I1BfnO9g7KlotcA/v5ClMjgo6Gl
 MDY4HxoSRu3i1cqqSDtVlt+AOVBJBACrZcnHAUSuCXBPy0jOlBhxPqRWv6ND4c9PH1xjQ3NP
 nxJuMBS8rnNg22uyfAgmBKNLpLgAGVRMZGaGoJObGf72s6TeIqKJo/LtggAS9qAUiuKVnygo
 3wjfkS9A3DRO+SpU7JqWdsveeIQyeyEJ/8PTowmSQLakF+3fote9ybzd880fSmFuIEJldWxp
 Y2ggPGpiZXVsaWNoQHN1c2UuY29tPsJgBBMRAgAgBQJZN5xEAhsDBgsJCAcDAgQVAggDBBYC
 AwECHgECF4AACgkQoDSui/t3IH4J+wCfQ5jHdEjCRHj23O/5ttg9r9OIruwAn3103WUITZee
 e7Sbg12UgcQ5lv7SzsFNBFk3nEQQCACCuTjCjFOUdi5Nm244F+78kLghRcin/awv+IrTcIWF
 hUpSs1Y91iQQ7KItirz5uwCPlwejSJDQJLIS+QtJHaXDXeV6NI0Uef1hP20+y8qydDiVkv6l
 IreXjTb7DvksRgJNvCkWtYnlS3mYvQ9NzS9PhyALWbXnH6sIJd2O9lKS1Mrfq+y0IXCP10eS
 FFGg+Av3IQeFatkJAyju0PPthyTqxSI4lZYuJVPknzgaeuJv/2NccrPvmeDg6Coe7ZIeQ8Yj
 t0ARxu2xytAkkLCel1Lz1WLmwLstV30g80nkgZf/wr+/BXJW/oIvRlonUkxv+IbBM3dX2OV8
 AmRv1ySWPTP7AAMFB/9PQK/VtlNUJvg8GXj9ootzrteGfVZVVT4XBJkfwBcpC/XcPzldjv+3
 HYudvpdNK3lLujXeA5fLOH+Z/G9WBc5pFVSMocI71I8bT8lIAzreg0WvkWg5V2WZsUMlnDL9
 mpwIGFhlbM3gfDMs7MPMu8YQRFVdUvtSpaAs8OFfGQ0ia3LGZcjA6Ik2+xcqscEJzNH+qh8V
 m5jjp28yZgaqTaRbg3M/+MTbMpicpZuqF4rnB0AQD12/3BNWDR6bmh+EkYSMcEIpQmBM51qM
 EKYTQGybRCjpnKHGOxG0rfFY1085mBDZCH5Kx0cl0HVJuQKC+dV2ZY5AqjcKwAxpE75MLFkr
 wkkEGBECAAkFAlk3nEQCGwwACgkQoDSui/t3IH7nnwCfcJWUDUFKdCsBH/E5d+0ZnMQi+G0A
 nAuWpQkjM1ASeQwSHEeAWPgskBQL
In-Reply-To: <20240814044802.1743286-1-maskray@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14.08.2024 06:48, Fangrui Song wrote:
> The macros FOUR_ROUNDS_AND_SCHED and DO_4ROUNDS rely on an
> unexpected/undocumented behavior of the GNU assembler, which might
> change in the future
> (https://sourceware.org/bugzilla/show_bug.cgi?id=32073).
> 
>     M (1) (2) // 1 arg !? Future: 2 args
>     M 1 + 2   // 1 arg !? Future: 3 args
> 
>     M 1 2     // 2 args
> 
> Add parentheses around the single arguments to support future GNU
> assembler and LLVM integrated assembler (when the IsOperator hack from
> the following link is dropped).
> 
> Link: https://github.com/llvm/llvm-project/commit/055006475e22014b28a070db1bff41ca15f322f0
> Signed-off-by: Fangrui Song <maskray@google.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>

Thank you for taking care of one of the many instances! That said,
upstream (binutils) plans now appear to be to continue to support
usages like the ones here, no matter that I'm not really happy about
that. Hence I'm uncertain whether that Clang hack you refer to can
actually be dropped any time soon.

Jan
