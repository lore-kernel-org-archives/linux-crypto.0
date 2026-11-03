Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=5.75.144.95
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705837;
	b=mb7qNnsnxXPKDFpsGqzV5cdUWuTOhEWVw+bxL6CDbFCNz1aw6Dp7el1rhFy45UCg716W
	 ythgurzhsSvHcySkat6CQoVsGSAdI8KA160/YzA+iH60GUggmj+pXijH3Cs0eHm5JKoOg
	 ypcQyGthPa5qXmC6AMXWXXWAsS/n+2xMepC2TvFy9eKeTGShkwmGS7R1vGp7HcsTREQej
	 rifo5up20lZcY1nKZ1ypumYVpbqzC5DtWCKiGdRt/fkRVlgEfhvjqz+RmzSWPAeuWlmQL
	 ApMqzYFF135Mlba9Hq8X6n1qRwefr26fmm4qlLSBgyGnj1/zgrmyOZ5vvKR5FUBBMMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705837;
	h=DMARC-Filter:DKIM-Signature:DKIM-Signature:Date:From:To:CC:Subject:
	 In-Reply-To:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=pJdbATKNC3xFtCfDJQB9vkk9sNbtSPHMZ0TwFiWOJ7c=;
	b=AwkUqgAqiKIahzJvmnsBYvg4hOuvnA9NcRhggH+w53e05GkCAB4TAu0G2jwv+Ss9U1L3
	 /wZ9kHUcx7XyAhsvvNzU/Mv5OrsGaaVU9qG3trPwUDbpqKkXQT9WwLhXnwjDIVifMTOLu
	 YCQNqFb9FFtWtG8vcYO22z9UFaVNlHJ2LTVeG4aEqu9hIFdHTn2L3ix0jk2kSCWGlYwyl
	 zI7+00iVwUQo4djaG5cL8YFKUhyZOvy4e5SMcHkCOEUmTtHXaK9Cp9nOhK4o2Jvc+dKQ0
	 0MIP6ryb9pbn/vE2InKJK71fyrKGLdL3cluh4QFS9XawRE/wBppj8i2jXymRu1z6M5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mainlining.org;
	spf=pass smtp.mailfrom=mainlining.org;
	dkim=pass header.d=mainlining.org header.i=@mainlining.org header.a=rsa-sha256 header.s=202507r header.b=lHiadR+T;
	dkim=pass header.d=mainlining.org header.i=@mainlining.org header.a=ed25519-sha256 header.s=202507e header.b=wTGgPEtI;
	arc=none smtp.remote-ip=5.75.144.95
Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85840606D811;
	Tue,  3 Nov 2026 11:37:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85840606D811
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mainlining.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mainlining.org header.i=@mainlining.org header.a=rsa-sha256 header.s=202507r header.b=lHiadR+T;
	dkim=pass header.d=mainlining.org header.i=@mainlining.org header.a=ed25519-sha256 header.s=202507e header.b=wTGgPEtI
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1793705783; bh=pJdbATKNC3xFtCfDJQB9vkk
	9sNbtSPHMZ0TwFiWOJ7c=; b=lHiadR+TAxE9SrsaaXl3dXKVyUlNHidUFfr7QSKqajBmoPff6A
	BytLHljGtOqVWwrTMJDVK2cb3CewfHu9gm4VDwtTeTs2amksQLofQV2rLrZnkmMEmudsxz9pjq1
	c9zujwW5pQW+n1ULSkL70wO0zGunyK8xpHDRCsMRq/BWT3wv/Fd7rYsaPVDgfvzfBW/5MxV4GKX
	K46AFJz5bo5c1hYsTbWlLXdD1b7ndiQbXqwFEcLHTwpcEvWqfXSoIPef8E2uPcE2ivaGT987AcI
	wZaN5GoEuiY8uHl+eXmc9pRl3WztkWGdfxW3OC9BZ3T+ZNZEkMjrhLMtj8CJFzFL2Vg==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1793705783; bh=pJdbATKNC3xFtCfDJQB9vkk
	9sNbtSPHMZ0TwFiWOJ7c=; b=wTGgPEtIZQD0PD/uZORSMKWgmhRLAlKfldIhszVbev+oKnB4Dw
	UhEeHcleZMraOr0kR72qxkq19tdMkGkAPBAw==;
Date: Tue, 03 Nov 2026 11:36:24 +0000
From: Bradley Morgan <brads@mainlining.org>
To: tristmd@gmail.com
CC: daniel.m.jordan@oracle.com, herbert@gondor.apana.org.au,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, steffen.klassert@secunet.com,
 tristan@talencesecurity.com
Subject: Re: [PATCH] padata: fix lockdep warning in padata_find_next()
In-Reply-To: <20261102155353.1268322-1-tristan@talencesecurity.com>
Message-ID: <9BC449D3-C881-406E-87AA-F023C1A864F8@mainlining.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 2 November 2026 15:53:53 GMT, Tristan Madani <tristmd@gmail.com> wrote:
>padata_find_next() acquires reorder->lock while the caller
>padata_reorder() already holds squeue->serial.lock. Both locks are of
>type struct padata_list and thus share the same lockdep class, which
>triggers a false positive recursive locking warning even though the two
>instances always protect different data.
>
>Annotate the inner lock with spin_lock_nested() to tell lockdep about
>the valid nesting.
>
>Fixes: 16295bec6398 ("padata: Generic parallelization/serialization interface")
>Cc: stable@vger.kernel.org
>Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
>---
> kernel/padata.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/kernel/padata.c b/kernel/padata.c
>index 0d3ea1b68b1f7..2f769ba7dfa99 100644
>--- a/kernel/padata.c
>+++ b/kernel/padata.c
>@@ -253,7 +253,7 @@ static struct padata_priv *padata_find_next(struct parallel_data *pd, int cpu,
> 
> 	reorder = per_cpu_ptr(pd->reorder_list, cpu);
> 
>-	spin_lock(&reorder->lock);
>+	spin_lock_nested(&reorder->lock, SINGLE_DEPTH_NESTING);

I'll bite.

Reviewed-by: Bradley Morgan <brads@mainlining.org>


> 	if (list_empty(&reorder->list))
> 		goto notfound;
> 
>

--- Thanks!
