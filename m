Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794500496;
	b=tFB68SHLUvpWyFMLFwcjirUBbJvcZAs5HXEJ1LPEhjv/5RkKr3ITgPnOG2igMSi53Amk
	 8JlBGpFEIIekIEYfhjtSDxkfYHXSeEIEvgi/dWoE7AK3rnerW95rQ/+99DNiIFOJhhv+T
	 43mXWfcRYYe+2JGoT1BiXGu/DpYJgfUG2DQAf/67X1+wU4JIlgJqOWdr/IGBLScCDzV2y
	 Q4e152oXuU93KxVvmTMoGWDWtCg2y3vLYo6WroREwdi5BPGcZOrcdRW2QgH+eJSqCAHNT
	 EdzrRbNT7iMcnzgmdBhVQNoagPR/ebqlmv1cb3P0WXr0Siz8CIQKej1XFIXO3XGBxog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794500496;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=FvwIi9PGGXoQsiA6+EZQf2O4ZXu7pd1RUjro27vdlbw=;
	b=2exKc/nPdUC+x+YJT5mwMkQTkS9O7qGfiI3Wu4U2LB84WaLgsodqCycAFjLO6/6oZQUL
	 Q9MQo5ZrDyftshrdQglvoZNeP+a+/uKFts81B59jhswFo/lXnoWM+iVsdNeAKoBUtK4UD
	 /Tol8Yw3NSPTg6dGptARqBBe0plcwUC0UUDntz9fk+c9gQmFys/umspSNtFWp8kD59420
	 gGvEogcTfXqkCtzisPq69t3SjzpDW2Ik58lTnnCn71dJkbP2fb8NP6TLsE4FKxThy1ktp
	 vbfXwEEruJupbPloXxtqsadfoUbrVuy+IUhDFpbxjjqku5/babekPaZOBp/dolphBmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmpxchg.org;
	spf=pass smtp.mailfrom=cmpxchg.org;
	dkim=pass header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=t3lZoFQx;
	arc=none smtp.remote-ip=209.85.128.172
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F34606A883
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 16:21:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63F34606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=t3lZoFQx
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b31448caccso500957b3.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 08:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794500494; x=1795105294; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FvwIi9PGGXoQsiA6+EZQf2O4ZXu7pd1RUjro27vdlbw=;
        b=t3lZoFQxr1lPXxTLA82vL4akkgK+Z4i0FUrPphDOtx6gufFLDAaYP3+1+qy4qFJu0d
         1csIKW51+ABMI9QXz4cRqb0/odu3azYJGU3hSav57uyWcT0KHa3hHILLarZASw9WZii7
         b//fowF2YKcFx/9lezoZ3Y+vfjTGtbXOnv021wA5HCp/FeT0dHJFDjWaTcORPxD8TTSr
         xw2L1xQbsNMswEbyL3SyHOq9gHlti4LaSBFi/0Myb6VryoP3Mq03D5WASMBaKd9rNUPT
         W8kovCXoVvP8ZwN6sLzVJA+W5kc+yUgkTwDNfnND/punFpEHYiWZoYtQCYM/wzg7CFHO
         rd1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794500494; x=1795105294;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FvwIi9PGGXoQsiA6+EZQf2O4ZXu7pd1RUjro27vdlbw=;
        b=UCaqto8NdGMt0ingYRxlmwNINzWviWoOzMflN1oIzR39qfKE/eaQk3o5g2jOUWJGp2
         dr7jT0j3pwD+Td4YHqjVq84UsZwLo1+yf79dTElhuYh6IGkKN+m41aZSrawrhrvS9fbf
         +Dr6iJ6VCvN5nK+LmriMGTG0Ir0ZGY4RMdqPr7hRlEfsu9byAqdMUkECPN2UDm2YosOf
         92kAElQSTaLqzF0JbT5h8A0uL8bSov7mFoDJn8JUs1+qJQ/CIky/nzKO0pcRbpB6VT4S
         rFWP2nk43IsR+uJx9vgWVBUXdO3PWi8af0ytYsFEtH7qLYZVauRcgzgW5wJho08TaSr6
         eDCQ==
X-Forwarded-Encrypted: i=1; AL+hErH7BHyJsLcK4/f5cquCXPiY3c093G3zFlfDl9NiGRQKKFxAl/j09At1rdavO/yCion9jBQQ+psj6cksjGI=@vger.kernel.org
X-Gm-Message-State: APuU4Z+0IUxv8d1ZSutoMAvM6q9UXieqBTU0Qwu6Zhyn72DRoV/kUfFK
	QF09WpFcjVk9faUHz4c8A8AJN/T0/rdnorJ7HNjmFQbuHQhedsqH/dQLPcgIpEgd2po=
X-Gm-Gg: AYBFou3S9d2yspwBJfbAnrlQLBEcbYlRya7tOaBo+eu0AFxoq9ZPxSctS+5Qne1T8BP
	48qIY+a/xp3t8IEFrLQU6AImq38hWppKGeu8I1Gs+idw/An2fXOMcrAp95F4Gy58zGE3IZR/JuX
	gBQIqT7YZEF7fDgh9azF+y2uSQIZZ5YGulKXADKiliYXiz39fug9Kn0dlZwgQGkMeBmLZnMqVl/
	al7oJZ1FpQlXHkzP3DFv8tBRS6y8/MzO507Zis8Z2MKVYw1jDLjbLHCMMqzyDBeU7wYJ1sRmUXY
	t/q1rDBydT3M86XekA97AKgKHPb2vjBq7fOzSPndKBboTB91YuK/oXTuYWlc9oGh+cZfSQsr+Ie
	eiKmpUtJmH9spb+lR4/uWuitXI7nEx7ZpQDAfzC2l7/TlnCUWOgP0MjR6XtG1/lNdDTJprKRe1f
	VcHLUYfgP2JeCx8YJqI+/c3c1lqvQGgMQU6hJzSz26wtpfAQao1KBWin9B0/8uSQfpS2ggQajto
	A7VFI8p2DqCyEgyYhFjlx1bZmINE8c8AW441e75HQT/Amgt6yNpLUDkWyHxYgJwCszYtn77MkW0
	VKZ8Ba6+ZQm6MYd/FWoQiPX4qvWz
X-Received: by 2002:a05:690c:9e:b0:8b3:37e1:9263 with SMTP id 00721157ae682-8b4aa3ae8demr296007b3.46.1794500493993;
        Thu, 12 Nov 2026 08:21:33 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b393426f13sm73450137b3.34.2026.11.12.08.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 08:21:32 -0800 (PST)
Date: Thu, 12 Nov 2026 11:21:31 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	terrelln@fb.com, dsterba@suse.com, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, riel@surriel.com,
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH 1/2] crypto: zstd - use vmalloc() for stream workspaces
Message-ID: <avXni0bS7twguZdt@cmpxchg.org>
References: <20261111153532.1036709-1-usama.arif@linux.dev>
 <20261111153532.1036709-2-usama.arif@linux.dev>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111153532.1036709-2-usama.arif@linux.dev>

On Wed, Nov 11, 2026 at 07:07:39AM -0800, Usama Arif wrote:
> The zstd acomp streams retain their workspaces after the last transform
> has been freed. The first is allocated during transform initialization;
> additional per-CPU streams are allocated on demand. They are released
> when the algorithm is unregistered.
> 
> In a 4 KiB-page x86-64 build, each stream requests 1,566,281 bytes.
> If kvmalloc() succeeds via kmalloc(), it occupies an order-9 block
> (2 MiB). vmalloc() needs 383 backing pages (1,532 KiB), 516 KiB fewer
> per stream. Across 384 populated streams, that is 193.5 MiB less
> workspace backing if all would have used kmalloc(). There is no such
> gain when kvmalloc() already falls back to vmalloc().
> 
> Use vmalloc() and vfree() directly to avoid the high-order allocation.
> This uses vmalloc address space, page tables and bookkeeping; the
> figures above compare workspace backing only.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Nice catch. Given the lifetime of these streams, there really isn't
enough turnover to justify the kmalloc optimization to begin with.

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
