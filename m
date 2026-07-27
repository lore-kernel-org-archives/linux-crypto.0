Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A08A3F6600
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 11:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785150530; cv=pass; b=ryBuUXi5N4m5Jj0Jm7Gj32QGpCM6uhc1qXGl6Jey5e+AgY4aiDs3wm0uXnZIT1SpWwmK49NVf0t9Ji+VCd2kNOoPEpF3lJ4s49iW2einznF270V2eU/Wofs7da2ZM6ufgggU3Y91ONBZpXO+jtISSRGAryfTxIXEac3YiSWzk0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785150530; c=relaxed/simple;
	bh=pV1TDUaa2YAV2kxJY3x35Y0FQXGiZRc6WWYevwzWDGg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nb1O/HOKN+mddHnjMvlUJ/3LroMEfss460VuKGWe/txEd2NfvL1Ata+VEtl4HG5nVbChvbzCi6yfD6whsWQAXyzE2srOzmenaVgz1f13Vz4zE7kq6rGEnzUu/ji0xvLlFa1P/gvLhdUod8RVT7ubpivhJMKQNcvENfcQRnpuz+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M3mRoCn4; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M3mRoCn4"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8114a4542b2so34405527b3.1
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 04:08:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785150525; cv=none;
        d=google.com; s=arc-20260327;
        b=ACxgomUrrW72wiFq5XKw4IzMOpmzOm7f4daBuj0k2OopuXDFI0LlNXrQl8emIVNcAh
         Ptzi/2lQP8brrwwaTP+i3jaJxYMa9FkP1tqRf26UADlOMWim0MzXW9TnAM+rs4SexKnB
         fgaJvT+5yCWGq4rC9xhD/pIKt64NZHpNKxpOaSWMK4c5dW1HrnVl6Tt7F3bZ2d82GWer
         1xzdJjyR0FQScMUg0X7kW0X8HOwEgqMYitGqKurdxUGV7ErCy7lpeOkPOJnjPmvN5LEW
         hfdtoLAVZWkZADcRh84jO4vbOAuKn25twLjyRgldq9I8SiSr2S+CoAaYlQIJ6al0w/WN
         ebFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pV1TDUaa2YAV2kxJY3x35Y0FQXGiZRc6WWYevwzWDGg=;
        fh=nbxMovYDkOwFPXpJQw03jlHGMtpO0im+noQZwxp5WHA=;
        b=rOoTvICJvI4b5RwbT0MQkLZctx6YRxCd2kZCR+VtjY5ifs+VMiwigV+0hlumOTiHv4
         CPWfuBgK9WdsgRufHx4d0kDk27caRXCfXz+2XPL3G2iW7af1LPGAcHzji0tvzGY2ZBvw
         8p07BGHedYDbOchJ7izalHMD2HXfYUGVWwO7LdAfFypG1g9fFSbl8nrG3AxUmHfkrkoW
         EbA+rwLZPHhlYE77wkwrn+eCZd+sBCn6M6bu38cgC4DWi/Hj9f+f54QYt/CLl55yFqKC
         e5futN7eQlZILXWu9gUwEXIgPGEnzr4dByVKZqPFnBQOnbckTst04rYNiedNz5JxHZB/
         CPOQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785150525; x=1785755325; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pV1TDUaa2YAV2kxJY3x35Y0FQXGiZRc6WWYevwzWDGg=;
        b=M3mRoCn4tl8RPjfQixKwIWWGSOwAsLGhmh+pOW5tV4opu6k/FIUqHgtBSUi/lYWXNo
         K98eF+P/A41j+K8iwFXw6liU49SqTYrvvms0nmGWFjNMcapwdxy/m16HBI26xKOSiPvw
         bHpYUNToOx9zQJmLUksPduoTCqqE2dSxgHeSldgGIbLqv2CWqoDhAou0N3efVhSwmwfM
         VQbpCmhybFLItirVtnzw4TnneJchaVYJVzYdQrFlaDO4vxp9qnK66elczaAbAPUjs+C1
         1bvSmITqLw2KhR3gNZaWHhZGr+7ZSQD962od3gweFtTkzKTtbvFjOOIGdEoRbtgOHS17
         oVMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785150525; x=1785755325;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pV1TDUaa2YAV2kxJY3x35Y0FQXGiZRc6WWYevwzWDGg=;
        b=EXjp5RxtD6nGtnIFNcEI5pI9pJXbdF47fvRWuL2wxS8Vy8QCpxWDIVi6AiFVV3S7Ng
         afNSfNi4hn0Adsl0h9tX4jafi8zWblpsc6SKy0n/FsvoAC0fBkKVXf1rwa/v6UdC2+AM
         qTdkeW/pMsvk8DVTUa1QaOqzw8pG/MR7qaDrdOcNka4hlOUAXZoPWHQXAPzHcjJwMHEk
         MmPTN6NAam4xrEDqlywx9IPg+hO5ZHrYDYQ9itZy0T4W/EGdrERIKmwV6yGFc9JaAa1L
         r/252G5eK2CVo3vdlPciqMt2P897fy0dtQd0oFcMZ5mc00lo+b/SAPlzVqwulzzsOioP
         7cHQ==
X-Forwarded-Encrypted: i=1; AHgh+RrvrV4zTpiBIX9DannqEZnDzqq9a4YCdipLwfR3y0tAH9xJiNe6BTyzF5abivmXW8r/wO9jfj0nh784az4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMfMZVVRUzvSQytwAMgyQuwo+KeIl/fKzXCYV4+NwYjbgaTxOi
	xmIGSyoYQ7Sl0qkWPZmr4PBKBWlAbwRmB3l/t4xB30Kuo5y9FGaHPw4CuiP5I2rUaIlDssoDjDz
	oJxRQ1dxWR4oN/dRsKyhkiCuLAQkZ5Rg=
X-Gm-Gg: AR+sD10+FAZULlF+KzybSfc6HjXD+5PBR+Kc6dgW1Y/F9if+et0MeOJyrDx0snVVcO5
	iySs2p2L7CJTlA35Gf4PL01KYr9EwA3Dq9y+hhHGye6mIcH7to2m+g+yObqAehN5fxbU6ykT4RH
	/Lg2SzNjwpz3TpAC/k0hEWDTDnMa/m6PSnEPBEV89RMseYOUp/qLLJOxIGK8Yvn3A+/Xybhgm6e
	V7ydGmU1vUbfV0iQetl1UQOo18ivYWunz6X+9iSWpPgzkthud01jjlpOnQ=
X-Received: by 2002:a05:690c:3747:b0:809:86c6:ee18 with SMTP id
 00721157ae682-81f69e3978bmr27868337b3.37.1785150525277; Mon, 27 Jul 2026
 04:08:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
 <20260724144822.6af8213f@kernel.org> <0ee1ef4aa7daa908bf28397ccc639c89b6aabd9c@intel.com>
In-Reply-To: <0ee1ef4aa7daa908bf28397ccc639c89b6aabd9c@intel.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Mon, 27 Jul 2026 20:08:33 +0900
X-Gm-Features: AUfX_mzhfgKW48GB4CRuyNKliFu1x1EH8aDGDqYePXeE0rGOBX3Wid5IOU1hKpc
Message-ID: <CABFDxMFMOAZ_3kYxEGCutnGt1OSSmgvmwx-=M1RxGc3VGKORYQ@mail.gmail.com>
Subject: Re: [PATCH 00/36] treewide: remove conditional returns with no effect
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Julia.Lawall@inria.fr, 
	Alex Deucher <alexander.deucher@amd.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Andrew Lunn <andrew@lunn.ch>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>, Borislav Petkov <bp@alien8.de>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Daniel Lezcano <daniel.lezcano@kernel.org>, David Airlie <airlied@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
	Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hans de Goede <hansg@kernel.org>, 
	Hans Verkuil <hverkuil@kernel.org>, Heikki Krogerus <heikki.krogerus@linux.intel.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Jaroslav Kysela <perex@perex.cz>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Johan Hovold <johan@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Julian Anastasov <ja@ssi.bg>, 
	Leon Romanovsky <leon@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Linus Walleij <linusw@kernel.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Mark Brown <broonie@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Sakai <msakai@redhat.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Maxime Ripard <mripard@kernel.org>, 
	Michael Turquette <mturquette@baylibre.com>, Mike Rapoport <rppt@kernel.org>, 
	Miri Korenblit <miriam.rachel.korenblit@intel.com>, Nicolas Palix <nicolas.palix@imag.fr>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Paolo Abeni <pabeni@redhat.com>, 
	Ping-Ke Shih <pkshih@realtek.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Sebastian Reichel <sre@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Simona Vetter <simona@ffwll.ch>, Simon Horman <horms@verge.net.au>, Stephen Boyd <sboyd@kernel.org>, 
	Steve French <sfrench@samba.org>, Takashi Iwai <tiwai@suse.com>, Thomas Renninger <trenn@suse.com>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Tony Luck <tony.luck@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
	Vinod Koul <vkoul@kernel.org>, Will Deacon <will@kernel.org>, 
	Yazen Ghannam <Yazen.Ghannam@amd.com>, cocci@inria.fr, amd-gfx@lists.freedesktop.org, 
	dmaengine@vger.kernel.org, dm-devel@lists.linux.dev, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-edac@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org, 
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-rtc@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, lvs-devel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	nouveau@lists.freedesktop.org, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, Jul 27, 2026 at 5:30=E2=80=AFPM Jani Nikula <jani.nikula@linux.inte=
l.com> wrote:
>
> On Fri, 24 Jul 2026, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 24 Jul 2026 03:45:02 +0900 Sang-Heon Jeon wrote:
> >> Patch 1 adds a Coccinelle script that matches the pattern, including
> >> negation and constant-comparison variants. Where a local variable is
> >> assigned right before the check, the assignment and the two returns
> >> turn into a single return of the assigned expression.
> >
> > Huh, I thought we already had such script. Various script children have
> > been sending such "cleanups" in the past.
>
> We did, and it was removed, I believe in 1a617a8475e8 ("coccinelle:
> misc: remove "complex return code" warnings"), because people just don't
> want this constant churn.
>
> It's perfectly fine to have the error case and happy day scenario
> separated.

Thanks for sharing the history.

I checked the mailing list. The removed script looks similar to the
new one, but it is different. The removed script reported a
conditional return followed by an explicit return 0, where the error
case and happy day scenario are separated as you mentioned, and Johan
also complained about this 10 years ago.

But the new script only reports when both branches return the same
variable, not the explicit 0. So, I think the new script is close to
the restricted version that Julia mentioned 10 years ago, and it
should be acceptable.

>
> BR,
> Jani.
>
>
> --
> Jani Nikula, Intel

Best Regards,
Sang-Heon Jeon
