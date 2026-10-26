Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793026842;
	b=jIUm/KbzNvyFKCtK7n1YU4uZSXiHvUT2R+m+f4H+VKsNgQlSUcSBG169fWUIwXwgo8nz
	 RYTohv+KDeCMwn21bILMY6AgU1hu++cJOe9e6MpCz2AcLmldXJfRbh+AwuHkHIUnCk99v
	 kd2CU1VSBTT8cHIV6dLm+em8duCFZIEUw2qhvhEC6NgfMkbCB7v4H9b/g5jpsnBfE4ctg
	 GSxHtkocCHx45ctXVyt4egpRrf+sl+/Idf8pVq2NCgfU5eQwRUatL6O4NQdQUCPU3u/sD
	 0SRM2G1qMnPGg5qYN2LqBp51fFD8u7AbQw7pIB4DgAOWAE6+WxRhcFQ/OiCsDOiWw+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793026842;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2fEUp+1KLX1g9pxymcQPGBgvQdM6meDnFJ6iLYfyBzk=;
	b=yiDvqAB94eaBO65sOjgdva9o+0JU5S+qJTJUhFw8tyU+YRjbk3mkf65xd3vY+awSLYDJ
	 RqRYFFlmMr5STBc2roGiji2IQzPoEkAiFOqG9Z6H21uriYAErE9Qj/yE5aBwJf4teItes
	 BWoyLO3nxPyQbL0WSmLmTEsSOa/gXDv3vRGyus4k/4g10oWmWPv0+cNyVWLMBXxAgkfVt
	 lnK2b1W+82GPQCHBX6Q0rd8HsBl/t0tOtDsuVtNKgNKaPluIe+2uOJSmWZA/vrYU5VHQb
	 W0YK+fvHjEv3WUdXMGpC49UYZe9fQhAGFvPZIZK6TJWK4oswVEPFcGWrPoxnRz1ODew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Lra6s915;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6700C606A31D
	for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2026 15:00:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6700C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Lra6s915
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so12494715e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2026 08:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793026841; x=1793631641; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2fEUp+1KLX1g9pxymcQPGBgvQdM6meDnFJ6iLYfyBzk=;
        b=Lra6s915j8vZyMBLzKiUyF9yhNwktX1OzErVRKT/BPE+RAJfo5Llf4uPPZuAlrYz6b
         eeFUllvSvT/2MXKEr6n9XgjdQLi1t6K2eETXDEyNCAB0a5CHGAwoMlvmHZyTNKRvcchi
         CtnKpn4dR9H/ozlsReAL7ghF+31+8KZ0KmGJeMxWjk5/1NMR5ZmZ3+n89Iqj6naf+CUM
         wsAbxiw0VIujFV8WDECRIJbpa53lWo3Cd+qOJbhXtoyOQeWWVwmzTmZR5YP5rzrpSisF
         kSOHzF7RpnsfTQsuQ34tmfVSxzFTtOJM9rsiabq26H3iShsLuI1J14tRIIxtkOTFu9hu
         3hxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793026841; x=1793631641;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2fEUp+1KLX1g9pxymcQPGBgvQdM6meDnFJ6iLYfyBzk=;
        b=CDJO4rUmTZQrJI+IHLMQYj4IMT2AFAFX2UJuf1x/1LsQP4eJAEU/t8JgQJHQ/VgLj/
         tlL+H0yZN0KIa8lDvUXG99U6+HhiqdF9c6cdnK1mBXHqyKUIvYE0ilrbs4XAXhTwsqn1
         zaIkl4K7xvSMoHN0PYsKUoUC3ovOXfXBnMpvcvwzOn64AqWTBUcdc3XDSbFTh63a8z1N
         5A3SXo2Pbi7LLH/qJ1ULdBdOgq7TrXgtzK17LS2+QB0Scg5TkIukXPlLZ6/SVsx4tIXF
         gYW19/KUvzdowMhwosXGjxR7dG0HALkX4qwWlMbRflpnBM/dU25hsuvFYAdMXVsqIvbP
         GDNQ==
X-Forwarded-Encrypted: i=1; AKwUvByH9V/xwmQQeuJm3U2lp40ClgRf9g1f7KHLa4ujIwWiE3i6sjFPIR06dGJu2nmZvYlAMFQu+XPt8T669po=@vger.kernel.org
X-Gm-Message-State: AFq9FYKK19JTCiv1cI7YllM8QfFyF7p6mO4LEZ2nOtsVw0zR0KpR1KZp
	EtuWPNHQ8FEBGFpjPDGDER2jvx9oUKoVf5Sssc4i4IZ033IDZIfMz0bD
X-Gm-Gg: AYBFou0zqxeskD9OJvswdv+ukasKSOe1Eq61Xzu/j3BVVnaVoWVEtatFw3R5map/7y3
	RWwrf93MsAYJIiR2vZLsBQzYjMUake6kh7V+mkir5o+J7s1b5peJMqoIgQFU4YXV+epTjLYl94f
	SATWfpkbfahy6NyenOMCHWWV0YjeiIXgmlQ8KL3b9teUYYRNtLaJE5C2yhqqlYacDDnQEsLv8ck
	ANhq/xNTzVjpu80iW9DbYqadY+Ewq3HaidlnApZqDiueZy3e0GIkKQTVG0YkESM14d8Yy1MuXH9
	JSG9xvUf5FLsShzrcwwWRIuIzWCEdNig314OU95SPldswuzjKQxVzS1lc4V9JQfazeWLhxU60vv
	NPbXiX3UlfHZTJ1M8NyEev43+vXgNxh103s1n4ZI47bH9YXtJmTtmQ1c/pvK7izUzwyRHJSSB6T
	CLhmeO/BomNxT48Ia+zGplge+6s1W7RVwOHuWVJmLG7JGPzuWsHoTX3whuPIcqgwX29hSQ1TweZ
	Vfji/7IPozXqcfmPghqa6+mjjQ8F0rNzJOp1gdF24aVFPh51bB2LfT42a49xw3a6uercflFuCPd
	LEvEuw9QTmmR+SSn
X-Received: by 2002:a05:600c:3b82:b0:4a2:18c4:61a5 with SMTP id 5b1f17b1804b1-4a35ae71a3emr134917565e9.6.1793026840517;
        Mon, 26 Oct 2026 08:00:40 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a0cc374sm207837235e9.9.2026.10.26.08.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 08:00:39 -0700 (PDT)
Date: Mon, 26 Oct 2026 15:00:38 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] raid: remove obsolete MMX optimized code
Message-ID: <20261026150038.6d08478c@pumpkin>
In-Reply-To: <20261025191207.86590-1-ebiggers@kernel.org>
References: <20261025191207.86590-1-ebiggers@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 25 Oct 2026 12:12:04 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> This series retires 32-bit MMX optimizations for RAID.
> 
> Affected CPUs, such as the Pentium MMX and Pentium II, will just fall
> back to the existing well-tested scalar code instead.

Seems like a good idea.
I wonder if all that loop unrolling was needed :-)

David

> 
> This was the only remaining MMX optimized code in the kernel.  MMX
> optimizations for the much more commonly called functions memcpy(),
> copy_page(), and clear_page() were already removed years ago by commit
> c6dbd3e5e69c ("x86/mmx_32: Remove X86_USE_3DNOW").  There are zero MMX
> optimizations for anything else, like crypto or CRC, which left the RAID
> code as an outlier.
> 
> Patch 3 also cleans up the CPU feature checks in the RAID6 code.
> 
> Eric Biggers (3):
>   xor: remove MMX optimized code
>   raid6: remove MMX optimized code
>   raid6: simplify CPU feature checks
> 
>  lib/raid/raid6/Makefile      |   4 -
>  lib/raid/raid6/x86/mmx.c     | 118 --------
>  lib/raid/raid6/x86/pq_arch.h |  69 +----
>  lib/raid/raid6/x86/sse1.c    | 136 ---------
>  lib/raid/xor/Makefile        |   2 +-
>  lib/raid/xor/x86/xor-mmx.c   | 515 -----------------------------------
>  lib/raid/xor/x86/xor_arch.h  |   5 -
>  7 files changed, 12 insertions(+), 837 deletions(-)
>  delete mode 100644 lib/raid/raid6/x86/mmx.c
>  delete mode 100644 lib/raid/raid6/x86/sse1.c
>  delete mode 100644 lib/raid/xor/x86/xor-mmx.c
> 
> 
> base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7

