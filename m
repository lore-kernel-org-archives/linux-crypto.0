Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83CB439F62
	for <linux-crypto@vger.kernel.org>; Sat, 10 Oct 2026 10:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791627298; cv=pass; b=gGBVm5rD8eN17uhPTHFypEPNk2lIeqU0Fs+SLYx8deMJquKEpK2g4+x0sQy5MhrQFZslj+021J1yZwVZXEjpT5sldAIgnHupM2JuZDCRqvJi30xjBYA3niCX8W1Px93Ks94FjZEA971FllbuQKw7iknCc7CCgHUHRhgydnxelaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791627298; c=relaxed/simple;
	bh=to0DTtAZWnV/meuGGusMEzel5dBXd8LQTc50qPpb4A8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tY30cikUnlGxLzB970pH1RZkc7tFJcr0OPvtAxm7LXV7Ry4HhCoVWoHqs9eHFBnviru1FUFusjU+/9ZX57wIc2SaCRKwLD3Rd9TEj+/E21eIWeWGSkA5vyMQE/3ODeSuBGUA7v9zaHAjBJEmassuR5GLSfaZCxODYZwCbAhtbto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NMCoGtcQ; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NMCoGtcQ"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-487048857f6so490721f8f.3
        for <linux-crypto@vger.kernel.org>; Sat, 10 Oct 2026 03:14:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791627295; cv=none;
        d=google.com; s=arc-20260327;
        b=MnioGpOUhIYpSSSxNf1VrHazbRPQrdZy4JLcuZkj/a00V0xWcAxk1DmIDaYyJIcopu
         /4KQE+P6PYJzsxURpb+oZq4uX9G4tar8URaDBSgoCyh1SU2cUbHi6PVJ9fF1xNu0QlZC
         pX8VzgAtYpZHskW2bBQJx6Q6yuMF3smQ3SQLsn1C5fwuOnIkazn+5RwOdCxmfQhhE/g8
         ch9kKSw5GgKBzBnnq4UTX8oXjo7GqP16pBS/KxoWdmryl0Ffszinkfw9VmJSGcnwEfG8
         GuZ2qjvUYNDZ4h9+1fmHTFAZKFn3Y8WLZU+HAnwswUCQBEE+csFEEuZdAaRgAgFrhKSc
         ozwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4ZCwz3KK4ioGo2sblpjh0J8bdLeG8IsOrV/Z4ACQP54=;
        fh=Qpge+PQwjPZpKyJ5qZeSd2tHkYfybBqpNIiOEyyfaHM=;
        b=lfVUpgaVlXu0trJl/LM4VQD8OnfUHqQPl5a+kIzvU4zWERFTASAys+n302j0V7d2PT
         xTJ6zt/jXWN9cL8Fjt/60kPsefSjdQEbuCnLZO0+0QoNNpdYUw/eQd69JF8K4pcFpoLw
         7lkjTof3HDLj03HY2Fniwx/QEsE7EzFqRH0r4VWkcTENjIHbayIax2LHTTDAhKGisfnX
         JfWeME0YrnNifYMqk81mIb6bpLkopQOqrZqmKVtuXqZ6lavS0yK/8YdkFTX0OOxf8oLy
         PWWx5CKlWWTXoCtLjgJqq00/E/W6NUaNO4ui29FBV6TPvBk+XbJ0pDl/vuE7i/rA9Fp4
         +/rQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791627295; x=1792232095; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4ZCwz3KK4ioGo2sblpjh0J8bdLeG8IsOrV/Z4ACQP54=;
        b=NMCoGtcQ0QY+nCy8fRACIZuo0G4YycaFF6FzJyqBf4KJmDt8HkHnas7PtnkOYWm4Ki
         0lKLyE3+5dnG+c2lLgyHKS7hVCYJUkIt6FpGv19VDpdMVCAmHy6wndDsMuJO/MuzdB+6
         app9oROrc1/+t8dQY0I7MJdZbor6tR4hMVLreSpiAGdMZxTHcX7v6XKfPWGU3rtH/0/H
         92LRxuER/emjnd1qKvby1E1/cyrhR7+yQfRTu0Mqoi25w7T+qlum3m+K7DXPu37RI3kx
         BTezhG055u6ENLe6d32gFxq0Xg1dQe0XmRCUwdoiNOu2o+RRDD9zi1TPb/YXs/p1KdUk
         MkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791627295; x=1792232095;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4ZCwz3KK4ioGo2sblpjh0J8bdLeG8IsOrV/Z4ACQP54=;
        b=Quuhn9hTwOLRUjp7Qan9hZh+lZI2JEcmKSVquQU/PT07pQPjX7Nh4JPsaLTUGsh8A/
         NiGK0dPhFM1M2d/Ev39n0XSoBhEHStPJZCYTuI2G5gp4drLeFI3VhxU9FXKnaem1q+e8
         DYdQffZQrDjinPqH+csP96JerpXFGv96UHYTM6TDtW0gaZjwG92xN3TJZ7u0UzYYVvIf
         0XJGtxn2LfcDjfsrj5+URAGp/pLvGlAtVauUOKrQ5ULErLDaLTf5iyojTSZsoiOQC3Hs
         ep0qeUJ2XfxTHGBK3VAbHX5RNw20jXmVjWdthepsS2oMN9hStkVxeohs211tsPsoocHq
         /avw==
X-Forwarded-Encrypted: i=1; AKwUvByXy8wdKTKerGNB5pKHoort+zP5Tzx3DxUgApmNJv6D4Tk/Laq1jtasbwK83rU9uUW4LrtQJOl/BDc/fUQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYJCfNSqQZHIVak2ovocpdgBTEJ49RyvrH+QLjqR0+pM9AGrHa7r
	+DS10MWoWbUx/upM5ujfuvqJ7jxHxeNdmjVMkXmkOKbZuvEQdOlBIzaCDWGOBZx3Lhv3YSGC0DV
	Eoa6+rnwkjL6SVY/LbDJQkuHKtxGI4Jda0a9ehZQ=
X-Gm-Gg: AYBFou1AwVoXdI9k6pGieYZOSo150EafvUekeUVAD9qqweoi/g7pzgTlxAmxzh5sQ1j
	xxt6E9M/D6IuWBsvgjvmWcGEtyWw9dffxl8E94zNGEBi37ZGGeKq8LNcl71x8GvttLou3kcVrEm
	cMxOymj6fAPRL3vdEgqymtIIoqLNYbx4neb7kw26vUPPy5BOF4qz+MemIco0wHHnVONTBGsycoU
	YH3aOoIHdEiCF5ruC9L/bYfM8m9pVemgWxgXMi/wTl5jivsR1h/BfYG25WTmkyZBlCNkt1oCadL
	ixVqLm6zPJZkE/CxoMpPOxTXB+M3iKfFj69ugDyZ3/BfR5I/hxShO/SpmerjUO/sN+gCZ54hOLN
	H1wFqYwaJSxw=
X-Received: by 2002:a05:6000:4917:b0:48c:7302:96ea with SMTP id
 ffacd0b85a97d-48dbace4edemr8358190f8f.51.1791627294664; Sat, 10 Oct 2026
 03:14:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261009163146.83112-1-usama.arif@linux.dev> <20261009163146.83112-2-usama.arif@linux.dev>
In-Reply-To: <20261009163146.83112-2-usama.arif@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 10 Oct 2026 12:14:42 +0200
X-Gm-Features: AclHuK8eHrKrxCU2Kz0-csCBZga-KHX89XLvw82csYCAbhZVbUsSPi6LOzolr2M
Message-ID: <CAKEwX=NFGr9hwavYof=zGtZ-nXGcWWsxnt6xQE_F5D1ZO1MnBA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: zswap: use separate compression and
 decompression requests
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	terrelln@fb.com, yosry@kernel.org, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, senozhatsky@chromium.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 9, 2026 at 6:31=E2=80=AFPM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> Stores and loads serialize on the same per-CPU acomp request and mutex.
> A low-priority store can be preempted as soon as the compressor drops
> its stream lock, while it still holds the mutex. A higher-priority load
> on that CPU then waits until the store runs again, which can take a
> long time when other tasks are runnable.
>
> Give compression and decompression their own request, completion wait
> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> compression, so group it with the compression request. Independent
> requests can share the per-CPU transform; the codecs and drivers
> synchronize their shared state internally. Loads can still wait for
> each other on the decompression mutex, and stores still serialize on
> the compression mutex.
>
> acomp_request_free() ignores NULL requests, so drop the check in
> acomp_ctx_free().
>
> This follows the proposal from Sergey Senozhatsky for the same split
> for zram [1].
>
> [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chro=
mium.org/
>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Nhat Pham <nphamcs@gmail.com>

Herbert, does this also look good to you?

> ---
>  mm/zswap.c | 108 +++++++++++++++++++++++++++++++----------------------
>  1 file changed, 64 insertions(+), 44 deletions(-)
> +       if (zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp)=
 ||
> +           zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {

This really breaks my brain...
