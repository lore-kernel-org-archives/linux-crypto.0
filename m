Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A9C214204
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 15:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779811115; cv=none; b=gs20rTfFKOMd11YJ2p7d5wow6h1Fk1zfLkvOWktZHaDfsEiTZ1+rZmb45oi6/tzQLw8xbCxAFNZmmuAyRJrZouZe9EZJ0LThr3+wtsyEpj1r48B5ysWM0DM6L5dvNafQ6Jqvr7HqI1+VCiPm4GQdD8U1ag2/u3iBMwzj1pnygzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779811115; c=relaxed/simple;
	bh=luCcXwP82NKzZTQdXDuXXpas0iy8/T2cK1g8ZZZMa+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Be68b45byFLbn3GXlgmYrc4fM/weIePPAy+kvNPgeQSLmSXbhM/GK6EZmXDTP6hm0zSwWWz3lZJYlWaJZsUV8N+81ZyCFNA4rHgOlr2jII/7lDyN3aEeP2gChVEfhdsnPfF5sqw2pbRRtonw0/2OMY0ofznwWqH7bHFUWlykw+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=OaEzKCoY; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="OaEzKCoY"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-47c6f914617so5109696b6e.1
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 08:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779811113; x=1780415913; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DBREw0EFwsoyVbz1ezFdLWJUb0tEhym45QW/V9DqyOc=;
        b=OaEzKCoYTjDFupGXgDqHvA60tQHvH8uhQAJf0FF3+yd8Lp09r59r6JN0ReiOo5Sg/H
         R03Js4qy31KLSLJsCFDOMwOuWryqT8e3gV1RpxO38tDzlwDne7YJ31V+eveOUM8kd8yy
         pvMFMygUkXBGF0/DjasxuUwyERKQXO0nFTZYOu8KPjchCzA90V3w5+XFG4NrCDxM0sOS
         iNJsXY5R+e1Gl3paQi49m9A9fWg7n+v+xW/81ORc8TQppKvYD6psMNykD5jY6VKjwJv/
         l7N/yyb1s2SXYcKLb0vKuTmtV4LnWCaaHg2WWM9yoILbupaZL7vzq4pzzmGjTZGJXxIy
         WNjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779811113; x=1780415913;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DBREw0EFwsoyVbz1ezFdLWJUb0tEhym45QW/V9DqyOc=;
        b=bs5DbcLagC2Loj+RH42pzXilq+Nn7INmFC4NOdg4xmakFuyYPl4Rmf1FSr8Aqq4L2n
         bh4aeFEhRN4xtTHD7D+ToHUAsgvQM4f/ZLJrenzbNOvohT7nTX3FHd3Og+o/zHfMgqZm
         xwkyGk3Q+hft4Y3QNYCzGTvMpJS/islsUJVwVyXHsIT42RR4e5UkinamO5vMhjtNy0yk
         3KjnMcs4MHC7TIrP9t/78QLoEX0l81ziN9eQZY80+Gk0F1hTMx7YOx8SZQ8H2t+b8mGl
         Ujlghfo2ywb9wV4ZCqXkEZNvz9mivpNXzIIkvFmkxEg4Moe86KBgNHbc1ZHGweMQSstC
         isBQ==
X-Forwarded-Encrypted: i=1; AFNElJ+6oTg5ca51y77b0F8wZVXXXpGRJvOGS2tXSSvKtWTNJl1ZcPVozRSEMBmIsU8so5i9o2XP8dparsdPnzk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNIfZ5+/Lqmc3TlUk6HMdylmknNVMQM50Bi/ad7pZh7IW/9Bts
	054zruDBr+XGVGW/1q7hAOljxT2xrt6OIt5lsfwgFkFNm+cEDvoimsYtvkias3Fsy6Q=
X-Gm-Gg: Acq92OEPGpDln95WqdhQXyXnTq9xczZ6bgvLs9Fhurn6AGf+rox41jJ4imkclJYumGG
	HolRW82BeUkTlwB7Z42rw9n3iz8RPEy+CSK9PIBn85elWjTaGUJGid6duJ+HloIcJQy/yFuY8RZ
	PXCu9uLT54VT5WOBuoGRIEIXT1QWiDm6JQNOud3eofSGnjbilg85Vy54v0zE/f+H0G06VaeOm91
	urw8/UhcjJfdzjmqNuAbwEJ9XGm/1oqSunKB5BOvJocLoUjWL/jyMxRsIbdoOiunh5eeQgbcKWJ
	rqm+qxWZ2qKirFuMCP2wvwddL6SqNXUpK2uUzzKWNipXxm3NsKi9MI/XWDF2NbkCEq8BxSCG4By
	7kKhlEc+0c6/sMu+c029czj0cioBjq4bwWD7i3rT/h/5Axnp9aI6a2rstmA4WL6Np/0C/EyHhmP
	oeVaYEMWgwiLbkapg0fxCKflKaJqwyOB2uEzcFUeADj9W6wI/5CyfaAx80q4v9ksvNVSOHdqBoh
	kE7gROLE08X1Cil1zk=
X-Received: by 2002:a05:6808:1a1c:b0:479:e96e:65aa with SMTP id 5614622812f47-4854a2ab967mr10906128b6e.42.1779811112545;
        Tue, 26 May 2026 08:58:32 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-485544e320csm6341688b6e.5.2026.05.26.08.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 08:58:31 -0700 (PDT)
Message-ID: <92db3ff0-8f0b-4b61-a167-5004ffcf9025@kernel.dk>
Date: Tue, 26 May 2026 09:58:27 -0600
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] net: Remove support for AIO on sockets
To: Christoph Hellwig <hch@infradead.org>, demiobenour@gmail.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>,
 Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-doc@vger.kernel.org, =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?=
 <toke@toke.dk>, linux-api@vger.kernel.org
References: <20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com>
 <20260523-af-alg-harden-v1-1-c76755c3a5c5@gmail.com>
 <ahQCZQNoyO8GQt3H@infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ahQCZQNoyO8GQt3H@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/25/26 2:03 AM, Christoph Hellwig wrote:
> On Sat, May 23, 2026 at 03:43:02PM -0400, Demi Marie Obenour via B4 Relay wrote:
>> From: Demi Marie Obenour <demiobenour@gmail.com>
>>
>> The only user of msg->msg_iocb was AF_ALG, but that's deprecated.
>> It can be removed entirely at the cost of only supporting synchronous
>> operations.  This doesn't break userspace, which will silently block
>> (for a bounded amount of time) in io_submit instead of operating
>> asynchronously.
>>
>> This also makes struct msghdr smaller, helping every other caller of
>> sendmsg().
> 
> So we just had a discussion at LLC about how networking needs to support
> AIO better for zero copy.
> 
> The current TCP zerocopy implementation provides completion notification
> through the socket error code, which is freaking weird and doesn't
> integrate well with either io_uring or in-kernel callers.

We already have that via io_uring, and without needing msg_kiocb or the
(very) weird socket error code retrieving.

-- 
Jens Axboe
