Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792684323;
	b=AIBgTMLDxbznPOFWk+ndRjNhP57OQxvHHSNtJrdYX36lDPrsKoBkRjRRkD/OjFbDrdJH
	 wLDkx8Xw/4P9VJ/O569q86gwyOYQ5aV4riod1+hGRhS2SQPZbBhobku21NSzjGnq6xl1B
	 lurBcrFFKKdNklqVSp41TkmfHszxw/KslUOc3cuRpfdHyKn8i9mX9a0ThyNkasNJ/261Z
	 DrSIQRZmQWE4b/xsh0SxeCeBKKtkzaig2Dg6CYv9Vb9MNEyQowhQpWQasPn6ZTP/u4wUs
	 YkZFmLAwNV3pLNV5Vt1MnD4hqj33ZMKGWz6j/8bqNnZNmdbfOcwhi3M0G6P3P/MXX+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792684323;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=JAYxwJeGd7Vqjt15irwA6c0ELx0VJ3FSuBJg/5kMUGI=;
	b=k7GDnifIdl+XcOmjeN2mYnXneEPcL+8YCqLmeaNOuUM8rNX/n4jxX7zjD3p4tA43onk3
	 UAhBBSGd1OJvcxa75j5ny+fwBeuFI0ClaLVl9C6ECWWfZBmdZRVy1Nd3fxA1hv1vw9GUq
	 XwsY7DfdtTaBGp0XvjnEH3WlgAcUK5Hef41A7IzokYDnF6WN8RP8dXifIi1SOfL2/HP+i
	 RhZYON6jeuALYwQvY58Xg1ibcx1Nd+1TRgbQVyJhdlImfm6S1feA4xqQ2Wl+Eg9CXL/Qs
	 WtCIKqK64RjlC1kP+uBi5dKz+gJSFYyS8LKF8DEAgJ6pjIaiK1CMlByDVgUuA55wThQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--suseendranb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=gnkF18Of;
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C15606A321
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 15:51:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8C15606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suseendranb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=gnkF18Of
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-89f71ac2e2fso10940b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 08:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792684317; x=1793289117; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JAYxwJeGd7Vqjt15irwA6c0ELx0VJ3FSuBJg/5kMUGI=;
        b=gnkF18OfjLU42FJeqmRAO7jxj8th9GbaGyT/7gO/Mw0Zxk+ipMlY3gIgr+ou8nlQs8
         FOq9A9SJ3QXVGe7o64yiH8gCy6U72TUmQR62del2LeD3FvMclQEAld8SeayV4BiyH5VQ
         WSoihZDezdVU7NnOU5H60CrVMv4q3sXlZkTtmaUCbEM5w1ZX+upDkwO/txnaXD/L88AX
         rJJ/dXjeVFdByvbKlNmjDUPIXfUBNQI04Kg5JMWU9IzSiVVcN4nm/AHFeL+9lmLHGa8C
         +2as/gN/O4CYqsxejiCU6qqmaYQCagIRci/qvkM0zrstmxjTfxCtdiYL2+y7Dq4suZil
         jBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792684317; x=1793289117;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JAYxwJeGd7Vqjt15irwA6c0ELx0VJ3FSuBJg/5kMUGI=;
        b=ezaWdD04wNRhBJtfGv/IDr5OtacFBtITvQYXaDP6QsUGtW1/94vkKxaaSII7qlZ6tg
         rmMYKv0vstBZWjDdXdBhXy1Sg8UhUXdyL4+sR1aHlOT1oRbvMLuWwmF3BPT8F5u8VU8z
         WHL5ZkH8yBHNbYNfj+yR7BRJJSv3YIl/4MPWzTxIi76VKTsBFkLq/XhLIt6sFexnJhZ9
         ZqZgFqdA4CY+cFAMEuez4NFadZIaMSWm6KxD4jsrLeL4syhpHMAnj88DG8J4XuaYMbKO
         NjFZHw4epbl8L+uTcMXKpBXAi5LOehFQD3FbHv9K+NDcuoSXzcBnwkg2K6d/QwKQdFZu
         AWwA==
X-Forwarded-Encrypted: i=1; AKwUvBwHAoXNW0qwvYn/a6WoHsi6kGRfRKguEYfrzO/hA3w6QkENBgGFVmoWqY4HL/HNVhe1Nt+Wa5FxnZc7uKs=@vger.kernel.org
X-Gm-Message-State: AFq9FYKFNwFW2EoHZXTjUwnBvHUBRcKX0K9izjaAbZnvnRBwkoTE3p+d
	ooDgiFeT3IMf3/VI63OCdR585WBg6xMZFyp/BJobMNV0IX7/JlNiL2id0mo1wNBEylGginw4l9T
	M0LsmMcXN6vq6Ms4VPEvZE8MNeg==
X-Received: from pfay28.prod.google.com ([2002:a05:6a00:181c:b0:885:756d:3709])
 (user=suseendranb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1905:b0:8a0:1dab:fd50 with SMTP id d2e1a72fcca58-8a089e1f4dfmr4253077b3a.20.1792684316760;
 Thu, 22 Oct 2026 08:51:56 -0700 (PDT)
Date: Thu, 22 Oct 2026 15:51:44 +0000
In-Reply-To: <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-3-suseendranb@google.com> <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261022155144.4177200-1-suseendranb@google.com>
Subject: Re: [PATCH 2/2] mm/zswap: classify compression dst overflow as poor compression
From: Suseendran Bhaskaran <suseendranb@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Suseendran Bhaskaran <suseendranb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Oct 21, 2026 at 02:47:46PM -0700, Yosry Ahmed wrote:
> On Wed, Oct 21, 2026 at 1:57 PM Suseendran Bhaskaran
> <suseendranb@google.com> wrote:
> >
> > 1. When zswap writeback is disabled (e.g. memory.zswap.writeback = 0),
> >    zswap_compress() sets 'comp_ret = comp_ret ? comp_ret : -EINVAL' and
> >    jumps to unlock. Whether the compressor fails on destination overflow
> >    with -EINVAL or succeeds with dlen == PAGE_SIZE, comp_ret becomes
> >    -EINVAL. Consequently, incompressible pages are misaccounted in
> >    debugfs under reject_compress_fail instead of reject_compress_poor
> >    (leaving reject_compress_poor stuck at 0 and triggering false
> >    compressor failure alerts on normal incompressible workloads).
>
> Hmm IIUC this is completely fixed by patch 1, so it doesn't belong here, right?

You are right, thank you for pointing this out. For the destination
buffer overflow case, Patch 1 alone fixes it since comp_ret is already
-ENOSPC and 'comp_ret ? comp_ret : -EINVAL' preserves it. The only case
not covered by Patch 1 when writeback is disabled is when compression
succeeds (!comp_ret) with dlen >= PAGE_SIZE, where 'comp_ret ? comp_ret :
-EINVAL' sets comp_ret to -EINVAL instead of -ENOSPC.

> > 2. When zswap writeback is enabled, any non-zero comp_ret (such as
> >    -EINVAL from an invalid compressor context, -ENOMEM, or a hardware
> >    accelerator error) is treated identically to an incompressible page:
> >    comp_ret is cleared to 0 and the raw page is stored uncompressed in
> >    zsmalloc. This silently masks genuine compressor failures
> >    (reject_compress_fail is never incremented) and miscounts pages that
> >    encountered a compressor error under stored_incompressible_pages.
>
> Storing pages in zswap when compression fails to avoid LRU inversion
> was intentional in commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE
> compression failed page as-is"). Unless we think this needs to be
> changed, I think all we really need to do is make sure we account
> debugfs correctly for -ENOSPC vs other error codes? Or am I missing
> something?

Thank you for the context. Keeping the writeback-enabled behavior from
commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
as-is") as-is makes sense.

With that unchanged, existing zswap_compress() already accounts -ENOSPC
vs other error codes when writeback is disabled, except for the
!comp_ret && dlen >= PAGE_SIZE case mentioned above:

-			comp_ret = comp_ret ? comp_ret : -EINVAL;
+			comp_ret = comp_ret ? comp_ret :
+				   (dlen >= PAGE_SIZE ? -ENOSPC : -EINVAL);

Would you prefer that I narrow Patch 2 to just that change in v2, or drop
Patch 2 and only send Patch 1?
