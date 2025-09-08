Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD5D22173F;
	Mon,  8 Sep 2025 16:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757350180; cv=none; b=nuECgFXj1tU62RcyVCvyZCDvvusFkIJKrmMdVaUoqLJ5QTBUD9RtSovzUkvvz1pEjsGqv4QCOpLI9HG+2419Ggkb947063lPv/kM3zX6vZw98PuLK1Z8QxEeDXUwWDUh9s3Spu0koAJOxnu5QvbV/UfebZXUteZcjL+4s6Ir59w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757350180; c=relaxed/simple;
	bh=qJ4M9NhyUUiwSrixiBqxntWQFHUQIk2D8Q+Syr+++4I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bi5ACnEB9qegOTwTLfDeFotUi3dBujQ5ySOtK4xomoQR7p8ogpF7SqI1xsABMHg4uQykyXyk/Zu+PH9KbssaL9/9I4hEqWzqPuwsvIXpWWA4PQc5Mgkov1dSd9saYpZI9nJhOgbE/MJ5rAQoZSvBlA/r/KNd5EVMLiFdKbl5umE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=Vv9fpBv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Vv9fpBv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D4AC4CEF5;
	Mon,  8 Sep 2025 16:49:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Vv9fpBv6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1757350177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QpB5tNXBjyOovnphQdFXz5SaIPdBCpYHvTLfm99HsZs=;
	b=Vv9fpBv6zOVNc2wiXzUH8hqPT6/w9QKa42prXd24TRVkuGq0vms78eRkV0/+5GmHSeQT0u
	or/xt3dOnIUEUBJWkn/794RW0z1Z1G+xf5zTtotCA37n/G11BfLwVJH0fUxsbvr3WRq8mI
	V16AkEUbATUXANihR8D2O9swr/NmZWw=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6dd8059c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 8 Sep 2025 16:49:37 +0000 (UTC)
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-61e74d0539bso890062eaf.3;
        Mon, 08 Sep 2025 09:49:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWGSjp8q7EiQghpsDrJS7PBTZxVAqApYWNLLKxQsK3Cp95byyCQypNduCoI+L9uQRd1XvIQWsd3ahIfBwg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4GssCMk1HJc2ffmS07xoUv178DjWKeZ72gKEzWtIyTAoyy4TH
	54cf+Z4OOaYkt3nynMvQ8dnKQ9zD5lDa1XrCJtWuaoOXrGESzZIeRK6bbGK7blBoBfsN9GNNwjh
	AmvjAj/2OI2IzFF2P4OM2HCuIqe82TqI=
X-Google-Smtp-Source: AGHT+IG1k1MmnF81J1Vo2jmXSIx1yHc4qgVkpm2QOFlj3gX2CeXc8Y5S0Gow70vJKvxabq0LnsYZB9vjl73O/LZxUXQ=
X-Received: by 2002:a05:6808:15a0:b0:439:1c13:4585 with SMTP id
 5614622812f47-43b29a8995amr3903338b6e.20.1757350176315; Mon, 08 Sep 2025
 09:49:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250906213523.84915-1-ebiggers@kernel.org> <20250906213523.84915-13-ebiggers@kernel.org>
 <CAHmME9qyfbn539Um9xoFJu2Mm9mM0zuOxyLgeOjF-R5nktbz4w@mail.gmail.com> <20250908164706.GA1331@sol>
In-Reply-To: <20250908164706.GA1331@sol>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 8 Sep 2025 18:49:25 +0200
X-Gmail-Original-Message-ID: <CAHmME9q3qa2ZmPrZWAe5tkWp2xGgNd=1BBx0APa_ACb3=bo-1Q@mail.gmail.com>
X-Gm-Features: AS18NWCGPRb7OwMUI-tVEiz_hU1uUOJpyLd0OY7Ve43ZcitTO73IQk18snpDrbA
Message-ID: <CAHmME9q3qa2ZmPrZWAe5tkWp2xGgNd=1BBx0APa_ACb3=bo-1Q@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] wireguard: kconfig: Simplify crypto kconfig selections
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Zhiqi Song <songzhiqi1@huawei.com>, 
	Longfang Liu <liulongfang@huawei.com>, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 8, 2025 at 6:48=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Mon, Sep 08, 2025 at 06:35:04PM +0200, Jason A. Donenfeld wrote:
> > Hi Eric,
> >
> > Just a small nit -- would you commit this with the subject line all
> > lower case, like the other wireguard commits?
>
> Done.
>
> > By the way, I have been reading every single one of your patches. It
> > didn't seem like it'd be useful for me to respond endlessly with
> > Acked-by/Reviewed-by, so I haven't. But I have quite actively been
> > looking through these series. Thanks for doing these cleanups and
> > reorganizations. This patch here especially is quite the relief...
>
> Thanks!  I think Acks/Reviews would still be helpful, as it shows that
> someone else really read the patches.  Maybe you'd at least like to send
> those for the cleanups for the algorithms used by WireGuard?

I can do it for everything I read, I suppose. I care about a lot more
than just wg, anyhow.

Jason
