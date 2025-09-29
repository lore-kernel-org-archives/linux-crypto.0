Received: from mail-yw1-f195.google.com (mail-yw1-f195.google.com [209.85.128.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824B9275AFE
	for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 08:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759135505; cv=none; b=eJ+Q+Niujg2ZK6F5H8UTdTO/OaCzdIOXGYFS50EQNw89ue5azuL6TRuEGHvX2kFZEZ3wiCnTtcmew3e289z4/Cm545EGR+zGo4tcdQCQ9I1AeqsvN9Hkq++qn0xqjCYasKCy/TiA89Ilvsbk0glt0M0bXcnXV4CkOZWSqbxQ4gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759135505; c=relaxed/simple;
	bh=X75ObHJZr1Ef5aDV2F1f9MYR+RaTFrZG0VaxFYaJTtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OvIGzTkeYG7XbM/tnFBjiqL1bq/GUxoiolEJkWWkvebnF4IJH8VXXyMFRKsCXgZUuJPBO6IRnk9dH+m4im66TCESYISLuKJi7eWqitmUCqWVlV9u2O0hmTfjZIdov+Y9YhxKRwygM1DRfTY2zEZYK1+sVQKFUHsREVhtn1cGUbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nF4jrYDH; arc=none smtp.client-ip=209.85.128.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nF4jrYDH"
Received: by mail-yw1-f195.google.com with SMTP id 00721157ae682-71d5fb5e34cso59185877b3.0
        for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 01:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759135501; x=1759740301; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JP8IQIErWyVyQbQCHDd0KKmnOzs9hqCQnTWShHnXfyA=;
        b=nF4jrYDHYPpYw5ga/XFlhep4Zp6CCMkdaMOmCupi0ovTPYRVmjtzrrr2laGR0X3L4y
         tDcWr/wzUkXUJxmqkJtNmm+R1cJAVhD3Mk/aHHYMF6D2f4MFztDzDK/2h/C+e/UCNX+U
         8v2X/RYGFcioFRJXXfafqznEunb/qpjZE7HafC8Mfs8BEC5/lEMJMUUBuj6aW/j79r+N
         EhJfwpxYu4Lxzq36pf6jxzXxuPzfusTG1KpRJE4xeOdj9AhVOiAbVEJZuI+svjr/txn8
         ezfM6wUoOz9+4Luta0nnjIhaCgl/thkiVbvNFiCQiwnS8Sp28viDzGjD0Tsj91ITglrt
         bM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759135501; x=1759740301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JP8IQIErWyVyQbQCHDd0KKmnOzs9hqCQnTWShHnXfyA=;
        b=laSxhCiqs1ZoJqS4hpDgTsv8+zNxM9rMUxUbC8WwhxM8KDse+w9AbnK4HCAk5ipGnB
         zZ3l4hhYb68x+JgWctId1VUV4vO+NMUbIIPsufOj1txdJjq9pE7r6pezMmskdpePlG4e
         4wVW+dX5ruuJ9LO5vdXIln7nyqAs3f65MpGniugi5rC+CKpOiMv13NBa6cruKQPjzoMT
         hz8f9zW2xVzhR4VgWLNFBQwVPZcYwpvTi3ZoTjYH1F6sb6emSDE4U9ccp+S+b2kUqRvG
         QjC36hR2xQ0s1/If79uH4TcI91eRwc7DdgA7fFnheB723NqYW+W91V9rXvzAF5Vo/5T4
         QItQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBQGae8vZ1ToS258tDrAIoHtHd92ZEVdXwBkpcXlWCNZUpjHUTxEw/yZmG/QsQs+iwpPnkAEBMrF9UmAM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7lEiZJgBarAH3VQ3Bnq0rCZWup/aqaAUX9bh6+2NE15aFg7uw
	pryDQS6UwapDU1aPC0xVJlCLdVrOJn5VOFbv7ozoaXaaQkEmK1KHWFm0MUjhzII7Uk+2UaV0jm5
	oOG/dH9Gf+ljL8E56FZHg4T0Z01HnfW4=
X-Gm-Gg: ASbGnctiduX401WqHs8QN0tZY5W3MJhp4mflPmOhzdczj2B0KsxJAcfQAekc1Nscs8+
	XD/rT7dnuitrPDq3jpHcamZul7efNCAcq2YxZBjajLIzg1MEoHIhkNxbl7xKNO48RH1K+OWF+2g
	N7n2bk0pXJoILiSTU0Y/OFqkq+4DGO8SVDbq9AIt8qnMoHFIkbdMi76g4XWM6uwe1tB1kAySfTH
	dIT3342RNNQON641w==
X-Google-Smtp-Source: AGHT+IFxYtBs5xRDiUYvTaJKzeNeG/IYt0ldkmoGNhRwvsol4gj4zN4L1p96bEyvoXGcb6J+7ZYjL3MG/05LU6Ra36M=
X-Received: by 2002:a53:7e05:0:b0:635:34f5:51a4 with SMTP id
 956f58d0204a3-636dddb3f9cmr6667956d50.13.1759135501484; Mon, 29 Sep 2025
 01:45:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250928061950.34531-1-dongml2@chinatelecom.cn> <175911730161.1696783.8081419303155421417@noble.neil.brown.name>
In-Reply-To: <175911730161.1696783.8081419303155421417@noble.neil.brown.name>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Mon, 29 Sep 2025 16:44:50 +0800
X-Gm-Features: AS18NWAWEWKS_kXuZX19DMBkYVbBkJRhoGuXBBDUCeDDp3ILgruju3i5YpW8Vlw
Message-ID: <CADxym3bHM3ykp6nSCNT_8fCVAGk04c1qgoFeAQbrCURSHk3NDg@mail.gmail.com>
Subject: Re: [PATCH] rhashtable: use likely/unlikely for rhashtable lookup
To: NeilBrown <neil@brown.name>
Cc: herbert@gondor.apana.org.au, tgraf@suug.ch, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jiang.biao@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2025 at 11:41=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrot=
e:
>
> On Sun, 28 Sep 2025, Menglong Dong wrote:
> > Sometimes, the result of the rhashtable_lookup() is expected to be foun=
d
> > or not found. Therefore, we can use likely() or unlikely() for such cas=
es.
> >
> > Following new functions are introduced, which will use likely or unlike=
ly
> > during the lookup:
> >
> >  rhashtable_lookup_likely
> >  rhashtable_lookup_unlikely
> >  rhltable_lookup_likely
> >  rhltable_lookup_unlikely
> >
> > A micro-benchmark is made for these new functions: lookup a existed ent=
ry
> > repeatedly for 100000000 times, and rhashtable_lookup_likely() gets ~30=
%
> > speedup.
>
> I generally like this patch - it seems well structured and leaves the
> code easy to maintain.
>
> I think you have made a good case for rhashtable_lookup_likely() and it
> seems sensible to optimise that case.
>
> I'm less sure of rhashtable_lookup_unlikely() - you have provided no
> measurements for that.
>
> In general we expect an rhashtable to be between 33% and 75% full.  The
> inevitable hash collisions will mean that the number of used slots in
> the bucket table will be a little less that this.  But let's assume 50%
> of the buckets are in use at any time on average.
>
> If you are using rhashtable_lookup_likely() you expect to find the
> target so you expect the bucket to not be empty, so it is reasonable to
> tell the compiler that it is "likely" that the pointer isn't NULL.
>
> However if you don't expect to find the target, that DOESN'T mean you
> expect the bucket to be empty - it could have another item it in.  All
> you can really say is that the probability of an empty bucket matches
> the degree of utilisation of the table - so about 50% as discussed
> above.
>
> So I don't think it is reasonable to ever tell the compiler that an
> bucket being empty is "likely".  You also use "likely()" for deciding
> whether or not to subtract the key offset from the address before
> returning a pointer.  This is a valid thing to tell the compiler, but we
> would need numbers to confirm whether or not it was worth adding to the
> API.
>
> If, however, you could provide numbers showing that in an rhashtable
> with lots of entries, a lookup for a non-existing key was faster with
> the rhashtable_lookup_unlikely() code, then I would find that
> interesting and worth pursuing.

Ah, you are right, I wasn't aware of this part. I think it makes no sense
to use unlikely() if the possibility of hitting the budget is ~50%. The onl=
y
thing that may matter is the using of unlikely() in rhashtable_lookup()
before returning the pointer.

I'll do a bench testing on that part, and I'll remove the unlikely version
directly in the next version if it doesn't help.

Thanks a lot!
Menglong Dong

>
> In general it would be interesting to know the number for both
> successful lookups and unsuccessful lookups across all three proposed
> lookup versions.  I don't know how helpful it would be, but I would find
> it interesting...
>
> Thanks,
> NeilBrown
