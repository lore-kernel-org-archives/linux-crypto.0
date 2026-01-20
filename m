Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E98B4418ED
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 14:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768918415; cv=pass; b=IPuwcbNf8hIMFlDd6wii48R2vB/xhkh9o7RvX7x1QypVvYM/0eH2EG7BZg9YouKIo+YBejTPr+/flo6pBnBkp+7jPPCjtqFYWQz7AnUeutSAzSJxu/+6wIfWfWJbK4Vmv/q5mtj/C03mbIwprBwdDvyAxtoQ6jUxHqkt6UD0NKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768918415; c=relaxed/simple;
	bh=TbZbO+fx6iRdUpF4L5EkzdrM0Mo3gbhoq53Zn14NnpI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SMDONeGOhiuUlGaOUBiPisMSOTwEvinf4D1GClK4biKhLdDOeI3xwUHx1xrKKAqKpfTK3w2AWI4qehQIh8dBYH+T3eAfWubYsjtJAYMER9aufnXwbDIvntJ4YsfhlGIyoOMzf0X+Xt/crtOR9cvjXNjdEDJV1gd13oVbtw7G+lw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ubYTugLH; arc=pass smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ubYTugLH"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8c52f15c5b3so620376585a.3
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 06:13:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768918412; cv=none;
        d=google.com; s=arc-20240605;
        b=kx2aJh81o5622UWEP8O6PHf5IR/UO/IyQkw8YKcZMFmlFdPjGgE/RMxGAulEEk68+t
         41VRrU/Pld/A7fgSDZH9ctlSX0S4bjD0CKFPL/Skoa8MOT9oacB621z/8ZfvEYY97Ocs
         13kK6Bk8WIKSCNGaEvsLQgjyWfnt5lTFcQzOeRmtGBRimUeWsrgHnoeP3tgty19eFkDM
         aED3h/+Nrv7RYCweTGD24uQDE1OujM3zkbg83A8bgKg2CVTYHXiR+iA6v6a5t2vxffZb
         EnOzsSIrno34ZIFK58cnBpUfOn/VUzSXLwleJ3KSYHf8pxqse6Y08AkZgzbVUYV/nzuC
         jyPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IdYE5jdvNdfk3sHI8GmEWBpt99cM9oMrMqemVzHltu4=;
        fh=WtJLEzQ+nJrpW4eOQ4nCRRzKPNZZ/QvpZsR7rtrxy2I=;
        b=jVzOUl8XVpz/Fa7ZgmVSyRTyhN2XTAJligi4cXB4orGMQNFvQ7qpDEPvo+0eNcs8SZ
         MscSSUj0XeoEq7wnOt8SYYZd9MQMhvPsJMwZSKVpJ6Xzj71RnbCqnpiAWSS8Ucxp0ksY
         IZFeS9ZaJBW6qCzhXwelwfsQPlCckk8yzLQcU5u2RqKosrhS7ZuiQ6u7PnlBxlpzKG+/
         pBNMdo+GFP0aqB6lpPYLJVJ8Lws1bm/X/PFWtkkyNAMHkuJ+L7Eo+CJwYNjqFmOrN5hW
         MkCGhSpCTunlTqbMKBnojXAfxCLWt7zEPyWzRWxwnFtBl/m96iqp45ORtbOT/mTO4Elh
         wk3A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768918412; x=1769523212; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IdYE5jdvNdfk3sHI8GmEWBpt99cM9oMrMqemVzHltu4=;
        b=ubYTugLHLKD5qHk7wxeCXwvzvGEzDc9STp3csWfmDxWVGAC0tPES7Y0kHcQNteRK4o
         D+CMhVLKTo3H5jP23G4qVJuXucrgrhoRQDSfaZS6PyfZGUuSGOGiLnuyhV00XZbA5dhH
         To6PlZxnxT/OUDJbVcPMl+YSy0qj4xWK7EZr2TcN9FES7G5eENDTkVXuYhaABtpi7Q0s
         4F8mF3V76FgL3sC+LJERu4yW+eLp9O2KQ0BoSqOqYb4pD8KudsuH4Mp6E/zlCl9fYdhe
         qN+IjvXCWw0xHr/PmMBZftS79eOOjaz7kznHRa0haSy/IGR4w8bFbYnkIIcWaTybBms2
         WnEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768918412; x=1769523212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IdYE5jdvNdfk3sHI8GmEWBpt99cM9oMrMqemVzHltu4=;
        b=mI44W+nye6esWA0KK6KASZawdRP9jDWR8t+3dA0mt6h4nJcjky/Au25krX1SrvLixF
         EC2zvfLrXl+FLTl/rmV6AX4d2jMTAwpOQD+7GVI7OdPCW4BsQpNMp2E6ERvzOGzF69PQ
         ZigPRNWy1MZhhTstNQhCNtIZfTfaYFzqQcW7T/xgvCZEFi3Ee8WNKNXnOHN7H2qF18Cl
         PwkLxDELSS1x4r7ApPK8YtbOr9oWG/z2lJzCeG5/nXQDgMiqupxHH1JZi209+KS7kng3
         g1P1uvo04lxt0KbxrwLZYaRPkq1+mD4+1rF+mLDg0SNJBIjnhVkg9+Ve6VjjcwJdJs/v
         HY1g==
X-Forwarded-Encrypted: i=1; AJvYcCUsBZ28NZA+iM7dixsbr6FAwpq28ZEox6kwQfJFywZmd4kpRC84WJgoOXwuE7bl1LpS2WSJ3VrB+IpwF7U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZUl7r4ipZ+xi44XkqIQFk6uBqflkVkl/vprG+O6lBLgp0n5S2
	gk4O5G6b3EPybjW1ctlkLTHwPn9OXBucLx5VllNTlSn/gqbZ7aM+U1xzz3uQO4GJXfvD0uxB8R5
	5uwRWd4DWvFsFM+wufFgNVYebTvnLsiB6MPJ5D8/n
X-Gm-Gg: AZuq6aJQuRHk8qJ62qXoWcUAzD6xT183WIFsLkDWdPCtjE3iIXBAuycV9tDBP3krjHm
	VVtzjzaHWOzcRvUJWBKrn15gkOwHJ1lHAXXFW7zrHMuKAO0J/H5OP3plM47UpyQp8XqnXGNA0WO
	uCdinVNhY0QDEnpDuDJj0kiXbuzKqHrmkaFVSejWWr1r13h3GmeaoV/hAODsagp5myG8BtZfuHG
	cKq6Xgi0blF/JLlfft2TQN1C3L2VLEPVz2F+cSs8qXdbqJAvu0IDqLyzjQH2on05iRL7oKchD5I
	836uEyVwnXNCu/r2w7CSOkf/IBvryKYaGFA=
X-Received: by 2002:a05:6214:202b:b0:894:68cf:49fc with SMTP id
 6a1803df08f44-89468cf5432mr19791426d6.23.1768918411939; Tue, 20 Jan 2026
 06:13:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com> <20260112192827.25989-7-ethan.w.s.graham@gmail.com>
In-Reply-To: <20260112192827.25989-7-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 20 Jan 2026 15:12:55 +0100
X-Gm-Features: AZwV_QhSRG2StFyNZkwjvq48dDIr-HhWGfUMqppHNhj04WZytkphQv9nwByXueo
Message-ID: <CAG_fn=VdRkSjvhO7wz7_PEznBOFgLjHCr2hSXwrKoO-hpMqTzg@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] MAINTAINERS: add maintainer information for KFuzzTest
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 8:28=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> Add myself as maintainer and Alexander Potapenko as reviewer for
> KFuzzTest.
>
> Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> Acked-by: Alexander Potapenko <glider@google.com>
>
> ---
> PR v4:
> - Remove reference to the kfuzztest-bridge tool that has been removed
> PR v3:
> - Update MAINTAINERS to reflect the correct location of kfuzztest-bridge
>   under tools/testing as pointed out by SeongJae Park.
> ---
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dcfbd11efef..0119816d038d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13641,6 +13641,13 @@ F:     include/linux/kfifo.h
>  F:     lib/kfifo.c
>  F:     samples/kfifo/
>
> +KFUZZTEST
> +M:  Ethan Graham <ethan.w.s.graham@gmail.com>
> +R:  Alexander Potapenko <glider@google.com>
> +F:  include/linux/kfuzztest.h
> +F:  lib/kfuzztest/
> +F:  Documentation/dev-tools/kfuzztest.rst

Please also add samples/kfuzztest here.
