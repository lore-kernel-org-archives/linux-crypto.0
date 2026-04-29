Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A7E3EBF35;
	Wed, 29 Apr 2026 11:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777461546; cv=none; b=SJQTp+G03k7j61GZeit6ZZdIO8NJH9BrisH8yTW929vvsch1uoQZnVqI0HYb5t+zBuYENkUNkAiTET+X3LSG2jFUpodOBQw3QPokCrTwdo/dRdgxxaIpwYArrFAuiJ+Z38YSN5d1KJIdLqf7PnnfKaX+Rdks1Hc1zBC2q3jrJgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777461546; c=relaxed/simple;
	bh=1v5mK1UjqVjyC5QYbgyYeV6o8ONrWI6PT0weCyXl12Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sdF1mADSK+8fNfSdtOy9+XwuvcjEOfrGLBWc5W15D4PR8urH64D+jJYEVJATvUpBlOSD7cA/pa0ZxG1WpelD9xPHRwjqmQHIHQmoc121uxECMetozZt1Bo5w/zogaKr8fNvj9Dth32d/fXPUQlc8Diq3N9D1psH46h1aKJKgcIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnTM7In2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnTM7In2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216E6C19425;
	Wed, 29 Apr 2026 11:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777461545;
	bh=1v5mK1UjqVjyC5QYbgyYeV6o8ONrWI6PT0weCyXl12Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CnTM7In2SJenzZQOhToLK0g8dO/gAAVBuPh7A4U+/HpGJOUN8/tyb6odZcqvwbvRT
	 En3qvEg5K0W3GqoL73dOj6jWtAwMJ5lZGPEFplB9L0UZe65+6PoI5P/bb/6yo+Km3c
	 ao3QQsrZJWPToQBjGgEOmqwCsWvmF7giFJj4kKrwbd/3GuwIOlDgv/umGMy/GkBHe2
	 7c9ZO91yQiufTRZiT0FYv1NRY3vYAcWxRaj/zYQY7r2fRxigclRGcHeq0HmS4nCr/f
	 fGbVgztJFhDp+9S9M5riodntFnMrUtnvSda6OhZGbqS4Hj6JJQ7pJb6DMcFEp5/Koo
	 Cr3cw8D4SVZ+Q==
Date: Wed, 29 Apr 2026 20:19:03 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm/slab: Add kvfree_atomic() helper
Message-ID: <rnunkscwmelmfz3sj3ttbcrrgmq3j77xyc3lzoatflyqpsvmul@3jzdw55vmjdo>
References: <20260428161419.94695-1-urezki@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428161419.94695-1-urezki@gmail.com>

On Tue, Apr 28, 2026 at 06:14:18PM +0200, Uladzislau Rezki (Sony) wrote:
> kvmalloc() now supports non-sleeping GFP flags, including
> the vmalloc fallback path. This means it may return vmalloc
> memory even for GFP_ATOMIC and GFP_NOWAIT allocations.
> 
> Freeing such memory with kvfree() may then end up calling
> vfree(), which is not safe for non-sleeping contexts.
> 
> Introduce kvfree_atomic() helper for such cases. It mirrors
> kvfree(), but uses vfree_atomic() for vmalloced memory.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---

Oh, allowing k[v]free() to be called in interrupt context but not in
non-sleepable context is confusing... but that's not new.

Looks good to me,
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks for fixing it, Ulad!

-- 
Cheers,
Harry / Hyeonggon
