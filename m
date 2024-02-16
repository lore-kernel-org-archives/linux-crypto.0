Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD70317BD6
	for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 08:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708072215; cv=none; b=bDWEGuytCrzVGQyDzBVFFjIzLXZS7HDbBlMT5EZ1vvRQ+nmvoUnMjE5ANwMho31CE4vRW8mF9bYSYYR5s1aC9/ZM0tt1G/0nj6wFwErsrMybOBOAXUYA9Brl8FCifgf7tfTh5US6+8Sql5MH7lMrICoLs+xx//KKUPCFyleGiz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708072215; c=relaxed/simple;
	bh=GdhjGGCW1tp746L2kvnuzcO0JGGixFXgKt1BGfXddiY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fC0ypB97hq8Gv0i/pAVbk1HbrHNJ4Z1+xGBsLnHkWcvmMJibnPWn7czg0XREOWeJNABABrv7wC4mnG+Y71uK9SJxR3YqPAk127ETJGV1dqScXS9rTq1O5w58AERi7+WRs1EQ/H0PTRQvcO9YOFQjCAp3LShTvr8qEEOVD9Ba/eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--yosryahmed.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U4LmP0dC; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--yosryahmed.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U4LmP0dC"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64b659a9cso3160751276.3
        for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 00:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708072212; x=1708677012; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E+T406awSm0PZWvamxb/O4glPc/yswynyie5XG4DmHE=;
        b=U4LmP0dCaq4iHak9mnXeylJInSYJBN1c9RyGjaGrqu3c6Q62tDgnXHeZNF5J2s/xdR
         K0y9/GD6Xy7avGjAki16V9natPYQErk6JaWgj4PP7q7KvkGkENFrAwEyoO+8tfbSw+fu
         5PSXqMO7xToNSnGozZFLLHaX2YbNRFY6sYhDKodTeV++1/VvuZKvMIuQRCCFS1/f22au
         nrXFTx7qfDe05HdZzNoYtzKINvQCvJtQUGyImdOf6VM5w8d/4W1y9+5pZ9rPQL2sXUe2
         nNI3S6rSBAPu5/24iYxBcXxd7yDj97T/sbJgYLV+ZXgJXYEmku0eLnJ3dWSwV3vjLUrx
         wOGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708072212; x=1708677012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E+T406awSm0PZWvamxb/O4glPc/yswynyie5XG4DmHE=;
        b=L5G/eIpeuz2231C7O3A5xWOQB1u7HMSfT2wQL7tZBf7uJ9uAVJ6I3PG8AXBjrCE+8n
         y07g63CoyAvLpCHpa+tMiYRgjgbqmUimQZnaJYVIz5LHnCc5qVJstMyDr2N+TXdqbRMj
         KEdcMyf2Q1vrEMpAwwziALRr4K5TXwgzR91ai4IsOeiy4iJaaewN9zjGuvgDkTgMqJpJ
         B4LUWcwuOsEp3M8cMmuKgrobGUMKcRtlCPFnGNCPlS7f7o5KK3zT375K9wEim9n5Y/jo
         mS+o2+0Bbf8QSIkPkcTyrtttt3HBlZGHZuJiL9YBBg91YgQBgWHhDeeYvbxXxpvySujq
         +69Q==
X-Forwarded-Encrypted: i=1; AJvYcCVTI5RASguV9wyjNPlR39ZDT7YzDfbBX43kgrDROjfY0nx8IdGkJdMO332LMPSJ8Dk02GQ8ZCO5ixK386/eZJQoLDTUbBbvMCn15lNt
X-Gm-Message-State: AOJu0YwZb2izcq+Xh1WoeThQMeIxrI5hGqeCPYq0Ab8ghrP3yB2P6TUK
	LvgjxVOTk2y1ZwzvTA/wYC3Dtn05+qjHJ4iMsbvtYvtLuuP9xjBBum5kwhp6uXiCx1iIAqY0xzt
	CN4FkX7RRE2MgfbsShQ==
X-Google-Smtp-Source: AGHT+IF3trf13BJQXu17kJIafk/jn8S7KsSWkMDfarAi4KXYdoqAcTw5cjuzS+fWLBF6eBz3av4bvJ/YSiMvk+Xj
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:29b4])
 (user=yosryahmed job=sendgmr) by 2002:a05:6902:728:b0:dcd:ac69:eb1a with SMTP
 id l8-20020a056902072800b00dcdac69eb1amr950084ybt.12.1708072212743; Fri, 16
 Feb 2024 00:30:12 -0800 (PST)
Date: Fri, 16 Feb 2024 08:30:10 +0000
In-Reply-To: <20240216040815.114202-3-21cnbao@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240216040815.114202-1-21cnbao@gmail.com> <20240216040815.114202-3-21cnbao@gmail.com>
Message-ID: <Zc8dEn7eqFmC_Kcd@google.com>
Subject: Re: [PATCH v2 2/3] mm/zswap: remove the memcpy if acomp is not sleepable
From: Yosry Ahmed <yosryahmed@google.com>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, davem@davemloft.net, hannes@cmpxchg.org, 
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, zhouchengming@bytedance.com, chriscli@google.com, 
	chrisl@kernel.org, ddstreet@ieee.org, linux-kernel@vger.kernel.org, 
	sjenning@redhat.com, vitaly.wool@konsulko.com, 
	Barry Song <v-songbaohua@oppo.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 16, 2024 at 05:08:14PM +1300, Barry Song wrote:
> From: Barry Song <v-songbaohua@oppo.com>
> 
> Most compressors are actually CPU-based and won't sleep during
> compression and decompression. We should remove the redundant
> memcpy for them.
> 
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> Tested-by: Chengming Zhou <zhouchengming@bytedance.com>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> ---
>  mm/zswap.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 350dd2fc8159..6319d2281020 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -168,6 +168,7 @@ struct crypto_acomp_ctx {
>  	struct crypto_wait wait;
>  	u8 *buffer;
>  	struct mutex mutex;
> +	bool is_sleepable;
>  };
>  
>  /*
> @@ -716,6 +717,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  		goto acomp_fail;
>  	}
>  	acomp_ctx->acomp = acomp;
> +	acomp_ctx->is_sleepable = acomp_is_sleepable(acomp);

Just one question here. In patch 1, sleepable seems to mean "not async".
IIUC, even a synchronous algorithm may sleep (e.g. if there is a
cond_resched or waiting for a mutex). Does sleepable in acomp terms the
same as "atomic" in scheduling/preemption terms?

Also, was this tested with debug options to catch any possible sleeps in
atomic context?

If the answer to both questions is yes, the change otherwise LGTM. Feel
free to add:
Acked-by: Yosry Ahmed <yosryahmed@google.com>

Thanks!

>  
>  	req = acomp_request_alloc(acomp_ctx->acomp);
>  	if (!req) {
> @@ -1368,7 +1370,7 @@ static void __zswap_load(struct zswap_entry *entry, struct page *page)
>  	mutex_lock(&acomp_ctx->mutex);
>  
>  	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
> -	if (!zpool_can_sleep_mapped(zpool)) {
> +	if (acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) {
>  		memcpy(acomp_ctx->buffer, src, entry->length);
>  		src = acomp_ctx->buffer;
>  		zpool_unmap_handle(zpool, entry->handle);
> @@ -1382,7 +1384,7 @@ static void __zswap_load(struct zswap_entry *entry, struct page *page)
>  	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
>  	mutex_unlock(&acomp_ctx->mutex);
>  
> -	if (zpool_can_sleep_mapped(zpool))
> +	if (!acomp_ctx->is_sleepable || zpool_can_sleep_mapped(zpool))
>  		zpool_unmap_handle(zpool, entry->handle);
>  }
>  
> -- 
> 2.34.1
> 
