Received: from mail-yw1-f195.google.com (mail-yw1-f195.google.com [209.85.128.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B62D15D1
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 13:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758720670; cv=none; b=WVLxg/xiRkWAdVrejKiruUJjL1iSMF5MsZbW4Eg6b7KKNDTJN1HImehXaWficPE18f2iWURUL8qogX0NmVsYp4RCEYOLW28RcNa5p2qWHTkvGW4pFBxllAjxtxSrtP9y9QaLHUDmHzVGi9aCB2gU+Qy9crAVN4Rg5Kv8Y0kNGSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758720670; c=relaxed/simple;
	bh=46Xxj40QWyWAnu3jMesyuN/ZQk0DISGVbez5MDqEi+0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FH/54XGCrTqjVNk/4QlcS/bnsuIvGyRVNeeVsGcXM7WnaX6zT5TMA6RgUnS/yoq+ZTK4Thk5oo5FGIXaixcVLvW7eBkzrR1wixt0aPTEWeBMOjxK2hKhsUSaLHDQ1UjYYKszYBJgAgDDVZ4bz0rmv5OlYJiVfBtu2hotUG/rQpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R4Jw7hSh; arc=none smtp.client-ip=209.85.128.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R4Jw7hSh"
Received: by mail-yw1-f195.google.com with SMTP id 00721157ae682-71d6083cc69so69997177b3.2
        for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 06:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758720667; x=1759325467; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8o/bKsm97JI+1qdk5N1JW8cXmeYcYmwcOzqbBYKqO7k=;
        b=R4Jw7hShU4EUiHUiSodMZuOyEFRG1unHDRJWdejF0JnHlXLNrZgqg5wFW1FecSTPJy
         ptBEqwezJ7D8PrPBCr+v0AzIdsQTM1SdolplSumzKwHFgVKAVS5OvZFnL6tOCGTBnFTw
         BYyYks7VE75GfKnG97DEbruHvYYTyS96iuTvzE6BFgP8B6XfZfbESaCKT4I8urnN/+Mi
         D0iZu5DyE4rgA9jPkxRXh0SXKsQ/HAYiaBmYp31Iqq5Gg9fFTT3hVCNB+xq8hET5wKDh
         eeqzuC1pKVF6/4+rYzrsSEaLb7gMpgmru4a1Sy83/mhRjcFXJmPPwPwz347hO7lhTBRj
         QnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758720667; x=1759325467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8o/bKsm97JI+1qdk5N1JW8cXmeYcYmwcOzqbBYKqO7k=;
        b=NRJ+0AKJaH7k9isHPHjv30A1pcruNuzsQn3FMvmr/4/3z0m5T2MaodOEyIGgjPVUtj
         C0kZjyZcH29D4V3juPHWXTAoRyWY9RU2eZE7ypWLjHwUyNzB1ExovZzlz/tla29uR6xb
         7CnPpatQU3ZrNhqxrGHA/UZiYuR+s1Wsh1D3KpK03tE43JsCZeQLTmOOWWaE9YD6K0pn
         JIJLpEowQbKKdqhPxzpeiXroOoLAUoWaDw/nEgWk+RmeTrxwft6J1tqKu3Emt9Rt4BiV
         BywLh1i8Anwa88SE6NG1SFcCDL72DTl2xhaIXK7uNyRiNhIv3CprGCdLKYmaLQHMkuEJ
         G5zA==
X-Forwarded-Encrypted: i=1; AJvYcCXtIwCbqqyEbXCAT5N3KOKTXymqDOIWJ7mEoImfXxALUcc4Om2OLIbCo96RHY0G26V8m76FiplPkYFuyfU=@vger.kernel.org
X-Gm-Message-State: AOJu0YywaNlUxZ7GN+8tz8KyDhDT8IIwOgL15zGSK1EumRxm2+F/+Ldv
	Xlyc5dWHnOCNlPu2Zj1mVHufn9AwpBulD5rI/bas3LAKcFvMhOrd4KimECgkaREKegfpiBQuShI
	g+GVuRNPaGpnWE14caaIqKxqNPBHnSXn/XXAJz0MvUc+L
X-Gm-Gg: ASbGncv1nbAYWH/7Pc+iktAL/DabFWfdOrbWi2rmBMX15zXj8gu/2ltFm7CIaQwCg3s
	jheA9auTIVFGqIVsb6ovYjGluUbQBgCON92qci0jg9QUfZZYSCorPkJICQEfgZXMBP9m0c4AnHN
	a2N4p3YIwQkMi2WuFZUiQFOZDYv0JFmGWuDOdtH+xHCJzyAD9V80lFw87+BghgMjZrPecWh0NG9
	+v25oGE938pxMswvA==
X-Google-Smtp-Source: AGHT+IHigQU1SwnbWbVt1/aemZ0rPCMfZqnHtTtQdJGn9ZTnDZqlnur9YC7rS9LNtus8SBzPJRH3iPXI+diPpCNf4V4=
X-Received: by 2002:a05:690c:2c0d:b0:762:772b:917d with SMTP id
 00721157ae682-762772b94b8mr7441717b3.49.1758720667090; Wed, 24 Sep 2025
 06:31:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250923060614.539789-1-dongml2@chinatelecom.cn>
 <aNI_-QHAzwrED-iX@gondor.apana.org.au> <CADxym3YMX063-9S7ZgdMH9PPjmRXj9WG0sesn_och5G+js-P9A@mail.gmail.com>
 <175862707333.1696783.11988392990379659217@noble.neil.brown.name>
In-Reply-To: <175862707333.1696783.11988392990379659217@noble.neil.brown.name>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Wed, 24 Sep 2025 21:30:55 +0800
X-Gm-Features: AS18NWA1CfSWZmw6na-YTZ-8p6J_kZkV2o8XdVYVoFzGsKTU8FazQhmxkraJz4g
Message-ID: <CADxym3ZA7FsdeA3zz34V7mHHjBC358UoJjrpV6wieZ1LF2aFxA@mail.gmail.com>
Subject: Re: [PATCH] rhashtable: add likely() to __rht_ptr()
To: NeilBrown <neil@brown.name>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, tgraf@suug.ch, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 7:31=E2=80=AFPM NeilBrown <neilb@ownmail.net> wrote=
:
>
> On Tue, 23 Sep 2025, Menglong Dong wrote:
> > On Tue, Sep 23, 2025 at 2:36=E2=80=AFPM Herbert Xu <herbert@gondor.apan=
a.org.au> wrote:
> > >
> > > Menglong Dong <menglong8.dong@gmail.com> wrote:
> > > > In the fast path, the value of "p" in __rht_ptr() should be valid.
> > > > Therefore, wrap it with a "likely". The performance increasing is t=
iny,
> > > > but it's still worth to do it.
> > > >
> > > > Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
> > > > ---
> > > > include/linux/rhashtable.h | 5 +++--
> > > > 1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > It's not obvious that rht_ptr would be non-NULL.  It depends on the
> > > work load.  For example, if you're doing a lookup where most keys
> > > are non-existent then it would most likely be NULL.
> >
> > Yeah, I see. In my case, the usage of the rhashtable will be:
> > add -> lookup, and rht_ptr is alway non-NULL. You are right,
> > it can be NULL in other situations, and it's not a good idea to
> > use likely() here ;)
>
> Have you measured a performance increase?  How tiny is it?
>
> It might conceivably make sense to have a rhashtable_lookup_likely() and
> rhashtable_lookup_unlikely(), but concrete evidence of the benefit would
> be needed.

I made a more accurate bench testing:  call the rhashtable_lookup()
100000000 times.

Without the likely(), it cost  123697645ns. And with the likely(), only
84507668ns.

I add the likely() not only to the __rht_ptr(), but also rht_for_each_rcu_f=
rom()
and rhashtable_lookup().

Below is the part code of the testing:

    for (i =3D 0; i < num_elems; i++) {
        objs[i] =3D kmalloc(sizeof(**objs), GFP_KERNEL);
        KUNIT_ASSERT_NOT_ERR_OR_NULL(test, objs[i]);
        objs[i]->key =3D i;
        INIT_RHT_NULLS_HEAD(objs[i]->node.next);
        ret =3D rhashtable_insert_fast(&ht, &objs[i]->node, bench_params);
        KUNIT_ASSERT_EQ(test, ret, 0);
    }

    /* for CPU warm up */
    for (i =3D 0; i < 1000000000; i++) {
        u32 key =3D 0;
        struct bench_obj *found;

        found =3D rhashtable_lookup(&ht, &key, bench_params);
        KUNIT_ASSERT_NOT_ERR_OR_NULL(test, found);
        KUNIT_ASSERT_EQ(test, found->key, key);
    }

    rcu_read_lock();
    t0 =3D ktime_get();
    for (i =3D 0; i < 100000000; i++) {
        u32 key =3D 0;
        struct bench_obj *found;

        found =3D rhashtable_lookup(&ht, &key, bench_params);
        if (unlikely(!found)) {
            pr_info("error!\n");
            break;
        }
    }
    t1 =3D ktime_get();
    rcu_read_unlock();

>
> Thanks,
> NeilBrown
