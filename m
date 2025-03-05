Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D268C2ED;
	Wed,  5 Mar 2025 01:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741137291; cv=none; b=HgAhTT95SpSBTPk9dBui98tX3wGLtB4ldHVkPGAL/rX44pgioWoOnUINx/IZXhrocsRZCdGRio9eLQlmdlKSCaKIAS23qJ7r736RmnCLT4LMSa6wkXuFxDbn0w3YKXgJspaPM65Vp/s+2xzQuLDHMbE4ByN2sMPb9jTFJEq9NEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741137291; c=relaxed/simple;
	bh=RYGnwl0rJHRwUNOO5HnlCMGwVLqQ3fc/hS1Slq7f99c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tnqNKfHOYrthV1kDPtKCNR9sDD2En03FV+1rMpyF86NS8qcex2pl1SaR7FpPiue6txmWPbS40zBlvoSpJRN+utI54WCnxzQDhmxAu/5WThONXcWong1NX/Axo7RUfr90Qvo14b92P1+ahsrLcQmyKcq0/3HoZYhVAgrhdARHq5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jM+ikE04; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jM+ikE04"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7c3bf231660so252695085a.0;
        Tue, 04 Mar 2025 17:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741137289; x=1741742089; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=suOTOr25WB6SV8l48qDy7pW0uKJWJLMiY0MiityYTyU=;
        b=jM+ikE046OgVNhtIyvSscobsAfTLvL4QavyRuaafitKaXXRKwikn1amxWR8sK82/zD
         wJyZvihq0MpNScTEupob4F64Wup7CfcSvKYnBvruIS5HE6PJ7R6sMxpmByHtWXRzao6J
         TBQfeQVVW/3+y2acu7gzYVlktwMS9DFGu6NK2EfXWElQlvnDRwp2kI3xru/rPQiCXvZ2
         AWtL5ZPR8usl88hZp4uDh1Z8IxGuchPPkfnMiFvUc5mth+qhfewWUNmWknApmQmDyOqb
         Bn5TefUqVqo1XTTpgHB4CCywmSeYI5jeUnD+HQbz8t9yyRnb0Qu9BEBmXK8OXafMJGZG
         ph8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741137289; x=1741742089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=suOTOr25WB6SV8l48qDy7pW0uKJWJLMiY0MiityYTyU=;
        b=SgrG3maHS14+VDb3GFHthZQLTTPFPtgf5FyBCtIFAdVGe+hdUYZ0iRmS64+4FgjzQ/
         pAlfPC92Tqex2EUXUkBYZjWoXQqybdVdyshbED+evvA0u2co8/E2qBkJnlTzdjbHDQJF
         JVmop8DwEJTY+HTaS1fGS8rbjCOoDA75vVq0IfEMzcbN1tDaB/wy2sHLD3CTlQ/QNCOK
         gR4gqvfdKUeuyPxPGHAgwsjvXyTwadnarRNETsv1ct8dLQ7mz1kekSHf7TzTANfXbeb5
         KXuNzxUxaJOKgyBhQQP3gZx0ACoJiL1kjGGUp99UOiPDaCfAyZshbt8Ze9var0U6gY53
         wPZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTAWv7Os2rd+LALkWZKFQJ7VRUIh59PXgk65iP8j0z5dcvYGgbT7zj5OIGBezFH9NP+EQgc3O2@vger.kernel.org, AJvYcCX6jPL14hgZQ2/qHBSRmnfaJZq0A6IwIXCOBX74XoNKZ82U2Pl09zLfUvbyALDFBeCniuHgSP6fyV/eUoMW@vger.kernel.org, AJvYcCXDYwA2lhyijl6sQbicXnM3pswgYBUNCzB5srk1U1xMTUJizvskjZUfUsqOxwlS2aBKkdhcNw5x/xshrCA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZBCnXEIONyjonftt77u9q/XhRvAawksI4P6y7pCzpMRw7G5it
	mZd9DeLwNRwCenUQ2GUPs/veib5+j8myE495WPtC5N3cCWnyEkaGchff24GcjlTb+8Q5Amq72nS
	8PWdVIZBWHTMrlgEsRIGeJ61lFIk=
X-Gm-Gg: ASbGnctzllRduHC+IaSbPuPtf2rNGvCULvQb3hqZEjkbBRQal9ElqlW6YeSVe/9F8Ig
	1Br2nIj1FF9v2tpAdocwfv66ToLKHsrypZGvCDmSh25fBgFTDEFY6MxIKzp+B0R9gE2oBHUW0+h
	fqaVvoSSSNit20+wJ+vOa1BXwK7Js/TQWmnoPiN9c9Gwuds4HS+1YjRxajBg==
X-Google-Smtp-Source: AGHT+IHd0Ik8MKlGNyWY5VodmCLxXOCOIs1Z8pMpdK53XKeHhyQPI3Gd2CyTe/JDWIfbt+6my10FhpnMdStAu91BGEo=
X-Received: by 2002:a05:620a:4899:b0:7c3:d21a:4c38 with SMTP id
 af79cd13be357-7c3d8eacc17mr270289085a.40.1741137288766; Tue, 04 Mar 2025
 17:14:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250226185625.2672936-1-yosry.ahmed@linux.dev>
In-Reply-To: <20250226185625.2672936-1-yosry.ahmed@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 4 Mar 2025 17:14:37 -0800
X-Gm-Features: AQ5f1JqLiz20AwoTsOju7OJR_duk5wrvJnvDyIN--P9eMfe9lSeJ5T9ZsfyKkqA
Message-ID: <CAKEwX=MtmHKnN2Frrny7dZ6=B6d_nzAKeUCwKcMs2zhoDwb3jg@mail.gmail.com>
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

On Wed, Feb 26, 2025 at 10:56=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev=
> wrote:
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

Lolll I was scratching my head with this issue while stress-testing
some of my zswap patches. Beat me to it :)

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

LGTM! Thanks for fixing it.
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
