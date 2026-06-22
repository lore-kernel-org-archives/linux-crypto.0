Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05DE392C3C
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 08:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782117769; cv=none; b=gXT0q45PQgKH4MPUJ8vLEYU/UYYTBfg5mJ1cWqj0uHhCAkiEg23SD32qrNm6Qj89PZ9kYRAT3hVaVYRtDWoY3nmgymRWwAswm07yDyJUlcuAhPySNyZtKuSK1ZNpaNN4E5VIBvBWoHQh9J6vhTMx/+k26A6txDfpUcb6VBXzLos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782117769; c=relaxed/simple;
	bh=IER6Q4RbEHU+TqBNCFXousE9wjBARqNFqdXSUnckiEg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FLVeNsCmZXJbf2GpVbtQEyfEbgxhdEKzXndO//tokSNcUb5iTFWxjOFoKcSjd6Wcj7Lvlkb+SxzQGb9Ai4MkjvNNmTVGvj3sMGvO16oi5FzbqJpRPMXJXkiFWSkQIyu+6XUpOpVon+OmDzzXTbVUtoY80E3DFK+LIHQmPEQxl+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ROskh/8t; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ROskh/8t"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-464192ab2e1so2533346f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 01:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782117765; x=1782722565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bFnA4MB3rhX4hW9kwKpEDdWQh6n3FEg0cpZAkJWsmhQ=;
        b=ROskh/8tfIJaOesnEZqCHlQNJbZWki5RbTqza/lsX5eovRkaYimKsd+YXB/k2zMi/m
         /oMxYwZTti4VBo4Zu7g+ne/XnDzRPkeytOwEHJ1QPmKrsfs8gcwvBhLar3NiR6OJGf0L
         +J8cEmu4EM9EXTaOXzKCB3rcDsY6oG2rx0tNv24ObV21OlAfSpd7lVCwHX7BM5qlSMrU
         0Y+stJ4hQbL/MqG06XGIR3AP4JZd7J5kU0fBgPGMIRm0x4a2O+CoKjF5iYge8niCKb3T
         4w+mIabC6ghr2q6JO+5qYmEFnGpSPuxK8BZC5l6QgOh4KqNC3bjBRyqs8iNZbdgiJDoz
         PvCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782117765; x=1782722565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bFnA4MB3rhX4hW9kwKpEDdWQh6n3FEg0cpZAkJWsmhQ=;
        b=FYLBVrzdvUOIfNil6i2ZwpJK0Au0XtAVry/Q3mc0Nros5bEKAkNpq5f2hlIH5/Kmpe
         oZVupSHG2U3Kfk9JJ0PtArNi9mz+2fyZh+0dELYAysQ9W/fwW6OX7V73iaD2OOLaZFQW
         wkvTRC4yqT8g4Wdu0HPuedhFtnm1S67aBKbs8S+yTuZNxeIa2hspuaMLWZUKmKwjxaUE
         pG9N0ukWPJiWl/d0C0yTc90BRz+q438YNuSd3SBlGqYchetiMy17SRz93q6yz3KkH6sv
         UtmvP8nNX9OoJUTgYuyMz6JXnLMAcjtm382IdH5QdRA1aTUmUpN8VphRoAYQfbTr5a/n
         lhWQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpypfo3+OGiQqc2l7r6SR2X+/GeLl1vZTX7YQHEaAbKGsg8kSajW7dSbOJNAUY8AA1y13Rcoo4DfCPQsCo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1rDXjK8r1B9IkXCldm5ztPLtmnaK05ymbmtfOXknoiPpVeSUG
	AtPM51elBUSs5HoYoovzNVgMaU1vxYrxuf43bVwDcqreK52IOkcKzB0/
X-Gm-Gg: AfdE7clWWZPby4CBhY7J8hm5vq0trAbLSVvTTVHulAKL/x2L2x5cBrwE1MMD+TvQJtL
	DfPS6T3f96N7UxG1dgwmUK1RbGPafkDEIs+Z7qSUX2YTxtIimsnnj+GseRoaWnY9oXqd3FpuXPv
	aMr5LFVZBkYOOha4ak5Zidpgut3Nb2vej7Y3bVaj+ZCf0J8HaZXQaGdGeKRD2zZAndr2FZtZzCJ
	031CcXhc/JHXrz2SlxKKyViYYl/mEMjjYfZlFjGp2H0/5w7+82ThqKo8cFWxs+jJhF+eIx1Bi4K
	HyC4ZhxEZo6E0gvOBNDffRcGzBienJW2ZM5MhRAWiEDEMjDA6pt14IjIYgJQK4Muwaq4BHheLtZ
	3DDXGqKqPCDg/6tufD1voMNutq8+gYLGVtwGrXe1FVhyDkL3Uu4PKcs8Gb86BWl0levyZvrVy6v
	nwPd/aVsz3uMlmYwNtI/tH2aNWqdD1HsTEEYYYPz8UJkbHFCer0nt9zBI39D8v
X-Received: by 2002:a05:6000:2006:b0:460:1e5a:2267 with SMTP id ffacd0b85a97d-4650090b736mr21019711f8f.17.1782117764761;
        Mon, 22 Jun 2026 01:42:44 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46666c57afasm24839972f8f.29.2026.06.22.01.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 01:42:44 -0700 (PDT)
Date: Mon, 22 Jun 2026 09:42:42 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo
 <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de
 Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner
 <tglx@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Paul Moore <paul@paul-moore.com>, Andy
 Shevchenko <andriy.shevchenko@linux.intel.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Howells
 <dhowells@redhat.com>, Simona Vetter <simona.vetter@ffwll.ch>, Randy Dunlap
 <rdunlap@infradead.org>, Luca Ceresoli <luca.ceresoli@bootlin.com>, Philipp
 Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org, sched-ext@lists.linux.dev,
 linux-mm@kvack.org, virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v3 1/7] list: Add mutable iterator variants
Message-ID: <20260622094242.64531b9a@pumpkin>
In-Reply-To: <20260622040533.29824-2-kaitao.cheng@linux.dev>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
	<20260622040533.29824-2-kaitao.cheng@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Jun 2026 12:05:31 +0800
Kaitao Cheng <kaitao.cheng@linux.dev> wrote:

> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> The list_for_each*_safe() helpers are used when the loop body may
> remove the current entry.  Their API exposes the temporary cursor at
> every call site, even though most users only need it for the iterator
> implementation and never reference it in the loop body.
> 
> Add *_mutable() variants for list and hlist iteration.  The new helpers
> support both forms: callers may keep passing an explicit temporary cursor
> when they need to inspect or reset it, or omit it and let the helper use
> a unique internal cursor.

I'm not really sure 'mutable' means anything either.
It is possible to make it valid for the loop body (or even other threads)
to delete arbitrary list items - but that needs significant extra overheads.

It might be worth doing something that doesn't need the extra variable,
but there is little point doing all the churn just to rename things.

> 
> This makes call sites that only mutate the list through the current entry
> less noisy, while keeping the existing *_safe() helpers available for
> compatibility.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++------
>  1 file changed, 231 insertions(+), 38 deletions(-)
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 09d979976b3b..1081def7cea9 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -7,6 +7,7 @@
>  #include <linux/stddef.h>
>  #include <linux/poison.h>
>  #include <linux/const.h>
> +#include <linux/args.h>
>  
>  #include <asm/barrier.h>
>  
> @@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struct list_head *list,
>  #define list_for_each_prev(pos, head) \
>  	for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
>  
> -/**
> - * list_for_each_safe - iterate over a list safe against removal of list entry
> - * @pos:	the &struct list_head to use as a loop cursor.
> - * @n:		another &struct list_head to use as temporary storage
> - * @head:	the head for your list.
> +/*
> + * list_for_each_safe is an old interface, use list_for_each_mutable instead.
>   */
>  #define list_for_each_safe(pos, n, head) \
>  	for (pos = (head)->next, n = pos->next; \
>  	     !list_is_head(pos, (head)); \
>  	     pos = n, n = pos->next)
>  
> +#define __list_for_each_mutable_internal(pos, tmp, head)		\
> +	for (typeof(pos) tmp = (pos = (head)->next)->next;		\

Use auto

> +	     !list_is_head(pos, (head));				\
> +	     pos = tmp, tmp = pos->next)
> +
> +#define __list_for_each_mutable1(pos, head)				\
> +	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
> +
> +#define __list_for_each_mutable2(pos, next, head)			\
> +	list_for_each_safe(pos, next, head)
> +
>  /**
> - * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
> + * list_for_each_mutable - iterate over a list safe against entry removal
>   * @pos:	the &struct list_head to use as a loop cursor.
> - * @n:		another &struct list_head to use as temporary storage
> - * @head:	the head for your list.
> + * @...:	either (head) or (next, head)
> + *
> + * next:	another &struct list_head to use as optional temporary storage.
> + *		The temporary cursor is internal unless explicitly supplied by
> + *		the caller.
> + * head:	the head for your list.
> + */
> +#define list_for_each_mutable(pos, ...)					\
> +	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
> +		(pos, __VA_ARGS__)

The variable argument count logic really just slows down compilation.
Maybe there aren't enough copies of this code to make that significant.
But just because you can do it doesn't mean it is a gooD idea.
I'm also not sure it really adds anything to the readability.

And, it you are going to make the middle argument optional there is
no need to change the macro name.

	David


