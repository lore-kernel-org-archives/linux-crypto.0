Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7407B67E;
	Wed, 16 Oct 2024 05:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729057903; cv=none; b=IACOoj/3XEsffcOCjxBl1k6zOwah+0hyhOhQwmLH/4Co4CuPmFTsqBy505s44fZJqj5ORkd+ZLHNtPH86INXFI/D2XQeV1d6Z7sRMx9pu79p2GaCjPBAzVBMhiJ3WnwKqrj59ilem/4uubOf8tV8DSp4HUrBqdtPBf8NXq8xEBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729057903; c=relaxed/simple;
	bh=Ewgkb9Wn/3FQ0Pr73GfDMt7CgKYxSWWI5TOHTj8Ki8g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G9DSzmLcrOx/bfJ6y527Tc0mnBhflvOmqvPdJQkhtE1HzGjcxk07t5IMYnxAp+Zd2CZnCyQ4MZqEjtPivXyICI8XDy5mJcgp735A1Nkt9sGOiLGqlJCKeMS866wnjXhM2rLZ+wyFjrwzyc3Xve+GeNSz9cxXm86LgRskvPJn4fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hv5jQLWc; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hv5jQLWc"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-37d808ae924so1011624f8f.0;
        Tue, 15 Oct 2024 22:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729057900; x=1729662700; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ewgkb9Wn/3FQ0Pr73GfDMt7CgKYxSWWI5TOHTj8Ki8g=;
        b=hv5jQLWce5d0Oc+E0qIvwJrrOd00Y+iNGiRx5wTiMd92no/3e06BBqMPeVXNgvZwon
         IgurUHgXlDGKSdclfsUe3bkiUZ/6Vt3cugXEtOF0S+b+JW10v3RMjKU5w9s2o1FRv8r9
         iQbmqx3HwxuHMzSZ+YAJ8vKWoOXt9q4rqXSb8bgzv79LZhtvk2LABHw/ZrdAsTAIwB3V
         Eky5v897jEd0j08qe3+rvxbeutuPp0g8vzR/Nq6SJ4ayMDZlpbvGNRpq0LE3urKZT4L3
         287HaNsE4wur4KZOWgdwIrfawSohoL8g+JmujEqFcCheKyaVqWM0bSagRGiElwUWh33h
         k05g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729057900; x=1729662700;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ewgkb9Wn/3FQ0Pr73GfDMt7CgKYxSWWI5TOHTj8Ki8g=;
        b=eCEogiEWcBeqUyFxPqcUcazMKgSTirJWPGbKqaqInu9Srrnn3Z4571wHM+vjzh2d6D
         sss1VzH3V1+ddRCzlXODghWvQUDS03YtvxdR9muwkCPmJ0Bk187y3Zh5D0RNyyjWS2kF
         PnYbIuoo/JN/kJIkI4c2cHi0hrbEHYj3ds333pdl2RTv+liCX7ubW1AQ1+1JCT2RJG1j
         dsszR0f1a9h9C3mvmedtdxWCbVNIkAE4R+CZSJQJw4kBkFCXOLpCQgjVDUX/B/4wyn3d
         ItnD15fO5j+e7WOK/UzxlBqpqhRXkYB8HHV+8iTw1NL+EMj6zbXdMjSlOKsUgFWHK9NY
         xEdg==
X-Forwarded-Encrypted: i=1; AJvYcCXYVfM9B+JVWT057sL7U1k1wGHKJogSFXJUYJJnmZNbkb1quM6QRDxsR/TuieEcL6DQUjRnO3N4tTaafbg=@vger.kernel.org, AJvYcCXvRFC2u4LMzDdBgHwCQE0Df2aEgJvYNA5J5cGg1I/FYEQQF4sJnXAK/czBW1NFoW6mpWTwvBrlWBT9mKrK@vger.kernel.org
X-Gm-Message-State: AOJu0YyTU8/9bPpWdWw0UV6u34WD8l0JhTLCZ7fgTYSVaWn2bvW/pycj
	K8ioyFzjfkv7yiea7PEVKczlfnJRR03OuV/dDG6e9r1FyLbXYAOG
X-Google-Smtp-Source: AGHT+IGG+VSZkImyOL6QNrq28Q8mz8xCnrVJoJEtOZgMGGpNZc0RJ09HoI6sfiW/UD12giBs8jdB0g==
X-Received: by 2002:adf:ea41:0:b0:37d:4cd6:6f2f with SMTP id ffacd0b85a97d-37d86ba83b6mr1775930f8f.3.1729057899920;
        Tue, 15 Oct 2024 22:51:39 -0700 (PDT)
Received: from ?IPv6:2a02:168:6806:0:98d9:e1d9:9a9e:88ea? ([2a02:168:6806:0:98d9:e1d9:9a9e:88ea])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d7fbf8313sm3336774f8f.66.2024.10.15.22.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2024 22:51:39 -0700 (PDT)
Message-ID: <2ae8006f3cfc40ae66b34659365596ac8507d1da.camel@gmail.com>
Subject: Re: [REGRESSION] alg: ahash: Several tests fail during boot on
 Turris Omnia
From: Klaus Kudielka <klaus.kudielka@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org, Linux Crypto
 Mailing List <linux-crypto@vger.kernel.org>, Boris Brezillon
 <bbrezillon@kernel.org>, Arnaud Ebalard	 <arno@natisbad.org>, Romain Perier
 <romain.perier@free-electrons.com>
Date: Wed, 16 Oct 2024 07:51:38 +0200
In-Reply-To: <Zw9AsgqKHJfySScx@gondor.apana.org.au>
References: <1fc4db6269245de4c626f029a46efef246ee7232.camel@gmail.com>
	 <ZwObXYVHJlBaKuj2@gondor.apana.org.au>
	 <38a275a4e0224266ceb9ce822e3860fe9209d50c.camel@gmail.com>
	 <ZwZAExmK52txvHE8@gondor.apana.org.au>
	 <7e38e34adddb14d0a23a13cf738b6b7cccbfce6f.camel@gmail.com>
	 <ZwduxHxQtHdzz-kl@gondor.apana.org.au>
	 <ZwePSPG8aWm6mwKK@gondor.apana.org.au>
	 <15fadc356b73a1e8e24183f284b5c0a44a53e679.camel@gmail.com>
	 <Zw31JIEyh28vK9q7@gondor.apana.org.au>
	 <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
	 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.0-1+b1 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-10-16 at 12:27 +0800, Herbert Xu wrote:
> On Tue, Oct 15, 2024 at 07:38:27PM +0200, Klaus Kudielka wrote:
> >=20
> > So, I applied the TDMA-disable patch, and I saw the same errors.
> > Then, I applied the printk patch on top of that, and here is the result=
.
> >=20
> > Not sure, whether this makes any sense...
>=20
> Interesting, I think this shows that the non-TDMA path doesn't
> work at all :)
>=20
> Can you apply the TDMA-disable patch, and revert the asynchronous
> self-test patch? If it still fails, then we'll know for sure that
> the non-TDMA path is simply broken.
>=20

Just to be sure, I checked again:
- Plain 6.11.0 -> all self-tests PASSED
- Non-TDMA patch on top of 6.11.0 -> ahash self-tests FAIL

I tend to agree - it was a nice try, but non-TDMA doesn't work at all.

Cheers, Klaus
