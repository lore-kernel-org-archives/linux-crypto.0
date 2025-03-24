Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FC81DF72C;
	Mon, 24 Mar 2025 21:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850948; cv=none; b=ZrrZhLXTAnPLTNeyQggWenl8W2Po/qGmg+/C9tL3pLfJKhkO7s6rNqfSJTqUf/SohKcSEqSBgbu4Nd9MwZh3iCExEyn590BWkuyXU+0wke6BfC+V4Xgyy7XXNuOd8E0g1NZijIB+JynA4m/0L2eInVXBja24cKdxUm4RwcRRX5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850948; c=relaxed/simple;
	bh=sg90PfFqCUCmU+2v+BsRP6GS/5oxOs7ge6RVmWp0PvA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VBuur6TPQHNDVvAUTflF7yE3MYPWvj22GKZFiMuZvToyqzSW5wb9zzoYfJB07++kEe1gkdOqbQMcruArXU3nqgB/IL0etbCOFkPKfudRdtVdEIZc9vgXLWtmxrxANa4R6TiwhauvzYznE9CRgLKAqZiF2VRcsgNkZ670wG2SiiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bixBpWlw; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bixBpWlw"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6e8f4c50a8fso41012586d6.1;
        Mon, 24 Mar 2025 14:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742850945; x=1743455745; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSKBIP8Mkd5GDvgLOVXFICnmH/X830uwa0zqRwzeZJE=;
        b=bixBpWlwkkM4MCwC5oPsIVmGd8D9Nm9lAgIwlHFI7Vwmk2zgqPU17JEUGRE2oUcZe0
         9HJ5DC15HYE6O41OJnNp7cjzeBOvWE4D/6LL2J6jE9/5Q1BB7mSCXM3jN+yK0dRQgpm9
         QVT6n1w+NVTnytlPo6AuUL0V9we+FTiJ0dVoI2h4iP68JmZFUU1NPfdkv8Id1XUCQZyw
         kpgHHPhnbd/a3kIsERYSjj+dkyNBZ5RKSVWYRXYXN55Pnl4Z0xkSyd2FDce7yXFxUf0t
         vB8V077ZNMx+Xa7cn7ISV9IzxUODu3PJjrvTLwbl9UupaAavIIHdW3pBblJaXmMX9+Jr
         EMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742850945; x=1743455745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lSKBIP8Mkd5GDvgLOVXFICnmH/X830uwa0zqRwzeZJE=;
        b=GDDtwTDoUNIPA2Kvmukf0Egx2kZ/YTZt9/eZfweYLY1suwI8LjSeiAbJI99HpomoHQ
         7VK+wBI0yc7/fU0CcDCytCgX1zkLEpDIjNc+rfxOCRrI2FWEmi5AhiOMZ595tlae2nPi
         6pajqvkVWDuycKhd0CXrQDsd8g7EeR3cg0RDTbavk+cCW6CI+SekAKmGysU7oy6czwVx
         OaquSNYGx1UEOymNOk8ldBreHkX4/X06WDrucd52R+ayPJnm0vqiOzw1X8f2ju+Ic8Ra
         3d2I7Gu1zfqkY6/wTydNF76S0oflgm7cy4l4xb/oFO7GdsMS+gauEWFkVQX3HEVV6f0o
         T6QA==
X-Forwarded-Encrypted: i=1; AJvYcCUurusHZWjyn45c7tjZLkNEEMdGOqc7Q6cjsRfjWcByJFhdwCX0c+8WBPuMhtzmfuyBcNhwaNnx@vger.kernel.org, AJvYcCXU7BiWSBHqY/OGAlKbLL4skmA3/OxCPQLStIHBXsvSkd5HVBnVmaGngJIznwGyMnEw23GtPHQR8ekeobE=@vger.kernel.org, AJvYcCXfIljA8NfpXnN0NO1VWo30Gx8FM9bZ4Ca4FPlpzD//K22rbVmkYMpWUq8Mcl6H2tkEyy7DDhRiEDa/fM+u@vger.kernel.org
X-Gm-Message-State: AOJu0YzsSmdS6hwaUbt4yYsN62gZFwWal2rhU+4q+gO8sraNw6FDgK+O
	V4OxsV58o+zL2SFktVepR4BZt4xI3HLrJi3fEUakbQoTNUjRUwTxzR3MvvdYZZMoFu65+hd+0le
	NaM3ZIuSznlWQgI4ZhC+uFOBN1hw=
X-Gm-Gg: ASbGnctQdikd1r5LcpMlQoLNvnXVYWDWoRWVYeBcmj5FNv8p24rcKbizIl0Wq3hjACM
	Cp19pYncKg4P6HqBT7vquT5CWkgL481SZBt0iES3nUKQGv/zySJIqfPaxl82JZAdDBqSv91u2JD
	D/PVgF3BKbacw2gI52mExSqHA5
X-Google-Smtp-Source: AGHT+IFiDPL/9ISevfih3CU+IAz3/VPVmZN+89C5TtaK3nDklX0FR4qkhj35fyVMgxs6lvCDmNrjxWYjkj+AwQVv5+8=
X-Received: by 2002:a05:6214:ca9:b0:6e8:9a2a:145b with SMTP id
 6a1803df08f44-6eb3f2d6f65mr232017376d6.23.1742850944891; Mon, 24 Mar 2025
 14:15:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250226185625.2672936-1-yosry.ahmed@linux.dev>
In-Reply-To: <20250226185625.2672936-1-yosry.ahmed@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 24 Mar 2025 17:15:33 -0400
X-Gm-Features: AQ5f1Jr-uvoD-QGCe-ufQ2MPjnSeMYo7k_udyRgT5ya7AQurboow-ceIHS0yntI
Message-ID: <CAKEwX=NmSaLdUHTdaCYamtdNhLVsDgzdkGbByFXmEcWe1w_esQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm: zswap: fix crypto_free_acomp() deadlock in zswap_cpu_comp_dead()
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "David S. Miller" <davem@davemloft.net>, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, 
	syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2025 at 1:56=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> Currently, zswap_cpu_comp_dead() calls crypto_free_acomp() while holding
> the per-CPU acomp_ctx mutex. crypto_free_acomp() then holds scomp_lock
> (through crypto_exit_scomp_ops_async()).
>
> On the other hand, crypto_alloc_acomp_node() holds the scomp_lock
> (through crypto_scomp_init_tfm()), and then allocates memory.
> If the allocation results in reclaim, we may attempt to hold the per-CPU
> acomp_ctx mutex.
>
> The above dependencies can cause an ABBA deadlock. For example in the
> following scenario:
>
> (1) Task A running on CPU #1:
>     crypto_alloc_acomp_node()
>       Holds scomp_lock
>       Enters reclaim
>       Reads per_cpu_ptr(pool->acomp_ctx, 1)
>
> (2) Task A is descheduled
>
> (3) CPU #1 goes offline
>     zswap_cpu_comp_dead(CPU #1)
>       Holds per_cpu_ptr(pool->acomp_ctx, 1))
>       Calls crypto_free_acomp()
>       Waits for scomp_lock
>
> (4) Task A running on CPU #2:
>       Waits for per_cpu_ptr(pool->acomp_ctx, 1) // Read on CPU #1
>       DEADLOCK
>
> Since there is no requirement to call crypto_free_acomp() with the
> per-CPU acomp_ctx mutex held in zswap_cpu_comp_dead(), move it after the
> mutex is unlocked. Also move the acomp_request_free() and kfree() calls
> for consistency and to avoid any potential sublte locking dependencies
> in the future.
>
> With this, only setting acomp_ctx fields to NULL occurs with the mutex
> held. This is similar to how zswap_cpu_comp_prepare() only initializes
> acomp_ctx fields with the mutex held, after performing all allocations
> before holding the mutex.
>
> Opportunistically, move the NULL check on acomp_ctx so that it takes
> place before the mutex dereference.
>
> Fixes: 12dcb0ef5406 ("mm: zswap: properly synchronize freeing resources d=
uring CPU hotunplug")
> Reported-by: syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/67bcea51.050a0220.bbfd1.0096.GAE@goog=
le.com/
> Cc: <stable@vger.kernel.org>
> Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

As per:

https://lore.kernel.org/linux-mm/Z-GjbPTEEoo76uQu@google.com/T/#m6ccc248da7=
5acb73b75c9bf05c90c40d626b12c9

Tested-by: Nhat Pham <nphamcs@gmail.com>
