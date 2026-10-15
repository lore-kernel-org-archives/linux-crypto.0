Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084B547F3B6
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 23:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792107906; cv=none; b=kXOdys7R57SJndE+tIDpyJEE1PQTrm/wwoslC9NYdWbOz3Zb+Q+13gNhykh1LYwy61d5McJcxddj4VinfiOldSFq0b9nRfbimcx+dkyZi331gKqMECefcne7MwaORhfhfh7sMyuFqmcK/ucyZg0+ZzMD6EqlF8pdy2G+dKSxM1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792107906; c=relaxed/simple;
	bh=FCVqDMzrGgpkq8WGhMSthtCX8+3wWMMPfMohVJNwoNw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jF5izZbXV/ESHbZ7G7HRwjt5Vroe9709WRH83R3Xr+OYsGTIcPP0HbVNrriDyge6va/eRTxRRhGbPm1pA5eA93uuvR86z0d92hEvFkRkG/+7B/yYfuNgjgIWbJ2b6DtIaW0XbMiKx/DEOZZdhlQYFy0ZADOpxbHVs9Pk00RkWnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C4sb3hyR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C4sb3hyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC8E1F000C6
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 23:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792107905;
	bh=FCVqDMzrGgpkq8WGhMSthtCX8+3wWMMPfMohVJNwoNw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=C4sb3hyRJFXiWbeZ/6XrHtDW54pSeydB8hmUsGSsctsu/OYM9RdHXcvZ6S0hBQo0k
	 wYSA53xBFPJM2Kytf6kKVPFiQaxmoBwBI1CzheBzIfKk+00lVeyWeKt9ZEp6JpO6xw
	 41OHUi866Dg4mI0A8DZh8m0X3T1L7uZrJmScX3LheLPhxQBf7qw9NvGDQtN1LhBP9m
	 rnDaZDjo45TY5oOOHges+qBZYbOSRhVePaHoZLR5OoTGmPNwGLO7VoG01EIhCqabbz
	 BnmfiJoHwXO/P6MUUF0Y7j+PBQhAJ9YBOPdPjwbH0sZQnil+Sk4bI2S7mL68TJ7+5e
	 ojzxrAiqOH4jQ==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b167ffd132so9505706a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 16:45:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzNjwGhgWXIIuYvjdhvCxbiq3ShgGjXSp03aGdRVggxWm2iIyh9LxyQbzvJ8Kvl03Bg6b0dGJzappOMixo=@vger.kernel.org
X-Gm-Message-State: AFq9FYKRxEKhr2WkPm0TjNvHB0fHkjY/+sN/6cUdbT1avRCsiPHf7wjk
	IQGnVSNh6/lfLy5BHl5fUCV8mhKZI+Jc0SEnrQIJTEf7CawprngA/e6xkusho4fSZw7EDiWlXk4
	HgAPg7guA0nQi6iPhW051HKv5hywRZU8=
X-Received: by 2002:a17:907:3f2a:b0:c2d:fc0b:551c with SMTP id
 a640c23a62f3a-c31a9fcf4f2mr1949378066b.16.1792107904655; Thu, 15 Oct 2026
 16:45:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com> <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
In-Reply-To: <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 15 Oct 2026 16:44:52 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
X-Gm-Features: AclHuK8pqaYpWR70T_a5K64RldUi1KMaCsjej6fZWhQkmdzR1e8fyDYr4JkyQVk
Message-ID: <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"

> > > > > > How much of the performance benefits come from patch 6 vs patch 8?
> > > > >
> > > > > This is how the performance changes: Average throughput is averaged
> > > > > from 10 iterations of usemem.
> > > > >
> > > > > patch 6: 19,119 KB/s
> > > > > patch 8: 17,593 KB/s
> > > > >
> > > > > So the acomp_do_req_chain() path that ZSTD goes through with patch 8
> > > > > causes a regression, even though it provides a generic batching
> > > > > framework in acomp.
> > > > >
> > > > > I was able to retrieve performance with the following change in acompress.c:
> > > >
> > > > Why add it to begin with in this case?
> > >
> > > Patch 3 ("crypto: acomp - Add trivial segmentation wrapper.") was
> > > co-developed with Herbert. The request chaining for non-segmentation
> > > algorithms was as in Herbert's original implementation. Since this
> > > causes a regression, I would like to get Herbert's Ok on replacing the
> > > request chaining in this part of crypto_acomp_compress().
> >
> > I mean, why add patch 8 if it doesn't improve performance? Seems like
> > even with your diff, we only recover performance, but we don't improve
> > it after patch 6?
>
> Patch 8 does improve performance over patch 6 (19,578 KB/s vs. 19,119
> KB/s) by 2.4%. Besides, patch 8 provides a compress batching framework
> in zswap, which is the purpose of this patch series.

No, the purpose of this patch series is to improve performance, be it
through the compression batching framework or otherwise. The
compression batching framework made sense as it provided greater
performance gains with HW batching/concurrency. Without that, I am
honestly skeptical. 2.4% can be within the noise.

> zswap is the
> first user of the crypto_acomp compress batching API provided earlier
> in this series, which I think, is a great starting point for us to
> evolve this further, as mentioned in the cover letter.

Without a non-trivial performance benefit (e.g. with HW batching), I
don't see enough justification. My advice is to try to push 6 (and its
dependencies) separately.
