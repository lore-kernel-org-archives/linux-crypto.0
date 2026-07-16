Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58493348C46
	for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2026 03:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784170913; cv=pass; b=JyvP/2c79QejHSubZGzqxdR7LEi38nAcqG29Fvz/ouQnIR587TTfQARBC99I8qsfYWiqAD7wyip99h4yB8ekwu7FiqDcGh9/F1ohi5vUB44wk045KpZ3JplfnwipvNm+C4RZ/DNj1VY5N/mz0SVJyzpKqxVJ/KY+aiA18ZoVUmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784170913; c=relaxed/simple;
	bh=Q/O4O+Tb8F2DDC2Bde3ADmEp8EWDMN/oIqjeQQ3lkag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eV76BDnhbrmwT4H3wGUgZNtIhUTAs8411SjtEUdCkLAAOpigAFtsZH0F2ynerWLn9eRu9d6KDOgghpi9agtLGweMmRGRmeaxm0+dBzbLxGdX+XZ+PkyKCkDz6Givu37ye+csGWQSYJYVYMDWdu2zs54CKKPKEzbERe39aHnq+/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jhlkIEZn; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jhlkIEZn"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c15bf5000so39566531cf.3
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 20:01:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784170904; cv=none;
        d=google.com; s=arc-20260327;
        b=b5UWOOZDk3laTjelpzUS1bVBPpSUUEcwq6Yrh9SILCJQoq/3EXwmFL+PVQ0D0HYGqw
         UiNtpT4BR3GoSkbSBqHl46qwDxz2xqTIcOF7kXFhlLVFZzo8ZiCMClxQnG2vrDAchNAO
         SdqHgHpcdUA53dqnsihmJrKkVxnrnDaZHmB5FjtI8TY/0aAzkqHj9ffK5ML4HsDf368L
         eJei86+MPkcBPzQxyw4FfegZ6LZMd+ob9570H3bQylG7FlDQumqysCc3/aBXtKZs15z+
         u84hYhbQs+0usr1TOAaAbbKBLiEYH26qOy3bDq8mDjqk2Ks9sJD/A4QmfynDsOZ6lxFR
         J9qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q/O4O+Tb8F2DDC2Bde3ADmEp8EWDMN/oIqjeQQ3lkag=;
        fh=y3sYxZcObmijtwu/3iaMargyrGbtZSPSIwbzN88PT1A=;
        b=AXyFdjnpSxIKVDVy4zXdW4PIXBDMmSHf7ZRg2haK9nYybjyISbuuQKoXag5EeIPQGM
         1up/pPo2/1SJ7MWw6PmF8wxR5aSTlZfHmaV8SZxJTHgNBphnToXTOVLfkkThKCPBU/W6
         krODke95rJ3vLmkRSYMoIulnfSSxm94r60RnjzCefQwXj0BnBtq6qtRWHBU6UOgulnPM
         sD+rAwk1Pp0BqXbiRHl0IcHiElmIR6+8V6DyFt9+2Q8EOUPi9kF3fH+ykBEWyg0pTF/Q
         C2ybU6jgx2KLo6qycZjMf4pq+oufXRisKS4SMnO7Czw/DDWFkOvxt4VgyHoMRhWgiCtf
         EQXw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784170904; x=1784775704; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q/O4O+Tb8F2DDC2Bde3ADmEp8EWDMN/oIqjeQQ3lkag=;
        b=jhlkIEZnAlpZaMdEbHiqp1ny958zleda9n2i4v6d1LMtpZBHD/qtIjKXzr4YE/cWyS
         ++jzxgTV0KStgWy2glXJ8tC6ZZp701MTH15AKW5Eo7kqJOzTvl3KrPox0tR+6sLrJQts
         beQovZqJvimvs5WczyYnoJGpp6/bVoRK1wreHzBh268K3wSNG7OC9Vn4359pSI5DItv6
         3zrvPfixVaDb+4YQKt3DnkLIHGxXhKgkSgtV/xQ1oAjCPJYH+3DO5zXw8e3hR+cvsCQe
         076zsPPwketyvbleWfoQcsXHxYR6f8mqP/twzCdi8WQ7dD/8PQD7iw8gzA9V6OQg5n5C
         3UOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784170904; x=1784775704;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q/O4O+Tb8F2DDC2Bde3ADmEp8EWDMN/oIqjeQQ3lkag=;
        b=HC0NGcib0Yl9FwRUA7bII6FiaWV6OXNuNjQ13+tb71n5cllMeB4XaHjv4lcvfFK7up
         Vn9jSl8SAV+4f3hA6CcHeMeyeyEJoE6M3fIt9zjDy+cZMda0mk9pu4IEBN77bUlynCGI
         IY0uoMmq/6n5y+8jSOBn+rGKDaOvZxL1CUvNPmreqJNbELnjZJDIdjj0hWe47cy9X49a
         5kFcwI3l/vOXrWirAmXuppH0paaAIHe2TiJw2a6gozrxnOfnAyBNAImvNGi7mLMCGa4x
         Qw63FYUViVNaoUqeZrZjF5OBmZQjF67Ksi+ok1RVOAJ5wsOYBHBLWr1beszm90g/Dh6W
         s2dQ==
X-Forwarded-Encrypted: i=1; AHgh+RrH4hwjPD+gSTPKEIHcYxOkuuabzcrRdOuNydqsUAmUgWgcdqUA6WFt6dUFsHcVhPAcv3HPcsz/z/J5Ob0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3UP+yWuIEHHk/sm7snvy58TNXbvcc6gJ8Lw7nPCNl9kSBJj+C
	4OVyMvtDnPmtpjurntSePPvub/FYM45JJBx3N79w46GomyMxrDdJ8k4TZvc84wkqFquJnx/klot
	sxrsrzs9KYKrHqlCEmB/KYoiM73cuMvBPMf/6esc=
X-Gm-Gg: AfdE7cnti06D8EntDqy57Qm6xOk48hAjfGPFPEZyjcW2z3v1ga2X4tKht97Yztov2jG
	KVM4VfQ0l4Dn7BZdbOswvOqnCOJ0TiZLq9QftPM+SazHhgSIrZyqxmt+ckAUfqdxEEtfTLKpMTE
	UQcK4SavXTK8rpjAWqv7HywDwZfNy5vMBrCg4tO++4qUWEv0lWysg7BTleOh2FyHMULYrCdZSJg
	P0KwURLfXVznlH0s37wrLNEThjU1KN97j/4KCyof4RM8swZux1jCGcp5y6i
X-Received: by 2002:a05:622a:164f:b0:51c:7b12:600b with SMTP id
 d75a77b69052e-51e4f267a68mr59945471cf.87.1784170903664; Wed, 15 Jul 2026
 20:01:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712022618.1665-2-muhammetkaankilinc@gmail.com> <20260712105304.agent5-0003@kernel.org>
In-Reply-To: <20260712105304.agent5-0003@kernel.org>
From: =?UTF-8?B?TXVoYW1tZXQgS2FhbiBLxLFsxLFuw6c=?= <muhammetkaankilinc@gmail.com>
Date: Thu, 16 Jul 2026 06:01:31 +0300
X-Gm-Features: AUfX_mzU6TMIogSxrDNTuEjEZLGeqckoVjCgv3nE2wt3_4DMq_EgOyFxiJulKcw
Message-ID: <CAAGBmJFRQ7VgYbTXrhO3=M5tH4mcX=abVEjhNEgQSfXPkga-Qg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] crypto: algif_skcipher - snapshot IV for async
 skcipher requests
To: Sasha Levin <sashal@kernel.org>
Cc: herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Sasha - you were right, and I confirmed it on a running kernel:
with the v2 snapshot, two 16-byte MSG_MORE chunks over separate
io_submit() calls produce a wrong second chunk on ctr(aes), cbc(aes) and
both cryptd() variants. statesize =3D=3D 0 means skcipher_noexport() carrie=
s
nothing, so the chaining rides on the req->iv writeback that the snapshot
redirects into memory af_alg_free_resources() frees.

v3 forces the operation synchronous instead. The result matches
mainline's crypto/algif_skcipher.c as it stands today, down to the same
now-dead -EIOCBQUEUED check. Sent to stable, since fcc77d33a34c never
reached 7.1.y and all seven supported trees are still affected:

https://lore.kernel.org/linux-crypto/20260716025838.2672-1-muhammetkaankili=
nc@gmail.com/

Kaan


On Sun, Jul 12, 2026 at 11:27=E2=80=AFPM Sasha Levin <sashal@kernel.org> wr=
ote:
>
> > MSG_MORE chunked chaining is unaffected: it is carried by ctx->state vi=
a
> > crypto_skcipher_export()/import(), independent of the IV snapshot.
>
> This isn't true for cbc/ctr: their statesize is 0, so export/import carry
> nothing. The chained IV propagates only through the req->iv writeback, wh=
ich
> this patch redirects into the freed snapshot - AIO + MSG_MORE cbc/ctr sil=
ently
> produces wrong output.
>
> --
> Thanks,
> Sasha
