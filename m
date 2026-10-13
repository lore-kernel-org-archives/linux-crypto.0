Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0BF53978F
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 21:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791925233; cv=none; b=DrxQ9kTz5jPKNKtwLoRXUcOnyFRcLs8REfPWhbeEou14ISNK2zMaTyPeCvMLBTYvVp1jrrC0p3SD8caVWjqh9yQ2yhuyWj6I+LPT4fdL1YpeAuvel/uWEIEWP57OeWqAFODSV28At+HoP9wk+ycHpdAXtwaDIjceE7aRdh1nYl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791925233; c=relaxed/simple;
	bh=1eJZLXSPO2QvZyB5xQJce+abk3qpL0hKOdB+BIHoOX0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rE+XMiW6ifPo+7UPEvTREocvQWfileyuXfufIui1qzlBYCg/2umSYiTvgndlzUkiiQgvJ0Y9UscFFxM5f8z9e6rdzqlm+R2y/9PpJWfPMeZtQOtEFDDUgxBxzz1To6XAJGkn+znyO7usHi5BXG5rKNtDqTbtXCqfoT8vN9Gw51s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQ1WC7nM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQ1WC7nM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1421F0089D
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 21:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791925230;
	bh=1eJZLXSPO2QvZyB5xQJce+abk3qpL0hKOdB+BIHoOX0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IQ1WC7nM0pZVI6Tj7H6gP/mQFDhPwEKc03cSJODDkpo68c0MSXQHb/kS+cU95I6Ig
	 4EVGxC3D0+B3W44j/9XjpnMM8CsUo8DcfLz3HPhPwKFeWOTHaQ2rEgTa0sZM7SNsBC
	 ZFT/YIF7MYqeHX5aNlYJetDfHNIq/1uVvxQ4UMs2WRtSUzARolyRXlrv5WIK69BS4Z
	 mUeQvIKXspWdHGGNOflGNIseRHzbeNSJgMeXROkkkXtOQWXqOSozot6/oXaD9gSqyV
	 J+YVrKT2E2hNivnWYkz31jsH3Dh6QiLq3P2m2KxHpCbDG0Af0sw5diomqaehr1rwqw
	 DBga817lt3uRw==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c2e2007dd8bso575972966b.2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 14:00:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwK2d3G4jjY76XhXkgm2mK/wwrUIErp/BleC2LWjINPCtmJhYNZeXDFiadtR+/7REU5Q8b+38hNIBNV6wc=@vger.kernel.org
X-Gm-Message-State: AFq9FYLU27vLq8UO+zJ2io1eEOOylf1a5+LzxiXGGRAcuX+QidU1j4Ty
	zFp1O7vYGCl0a1r7qPcBUkjZFyIxLASgnmBtp1xvvARpg7KGfuCUpUcD5iyhTmqvARa/kUlj8N7
	NuHQAdAOWv6xuefq++VVmQ800kT7WY30=
X-Received: by 2002:a17:907:7fab:b0:c26:1691:b368 with SMTP id
 a640c23a62f3a-c31a9f6b728mr1375436066b.33.1791925229423; Tue, 13 Oct 2026
 14:00:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261013151007.2093943-1-usama.arif@linux.dev> <20261013151007.2093943-4-usama.arif@linux.dev>
In-Reply-To: <20261013151007.2093943-4-usama.arif@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 13 Oct 2026 14:00:17 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMVULy2B1YNK7qNzrH6idiZe0RpkW97OV2ux0tQTQWPuA@mail.gmail.com>
X-Gm-Features: AclHuK_LdHV_et7vmuF6kLVqnUbLnv-N7hBpQnpqxarZFOSSyQ0eEVdNmZzRHFE
Message-ID: <CAO9r8zMVULy2B1YNK7qNzrH6idiZe0RpkW97OV2ux0tQTQWPuA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm: zswap: use stack requests for synchronous decompression
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, terrelln@fb.com, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, senozhatsky@chromium.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 8:11=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> With separate requests for compression and decompression, loads still
> serialize on the per-CPU decompression mutex. A low-priority load that
> is preempted after the codec drops its stream lock keeps holding the mute=
x
> and stalls every other load on that CPU, including higher-priority ones.
>
> Synchronous algorithms can use an on-stack request, so decompress with
> one and take no zswap lock. All in-tree software compressors qualify.
> The Crypto API enforces MAX_SYNC_COMP_REQSIZE during initialization,
> so checking acomp_is_async() is sufficient. Asynchronous algorithms
> keep the per-CPU request and mutex, which is still taken before the
> zsmalloc read lock.
>
> Reading the per-CPU context without the mutex is safe. Since
> commit ef3c0f6cb798e ("mm: zswap: tie per-CPU acomp_ctx lifetime to the
> pool"), it is set up before its CPU comes online and is not torn down
> until the pool is destroyed. The codecs keep their own stream locks, and
> crypto_acomp_decompress() rejects on-stack requests only for
> asynchronous transforms, which never take this path.
>
> For software compressors this drops the heap request added for
> decompression. The on-stack request and wait take 216 bytes, which
> makes the load path about 270 bytes deeper on x86-64. Asynchronous
> algorithms pay this too.
>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Yosry Ahmed <yosry@kernel.org>
