Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A941DF754
	for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 21:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749676899; cv=none; b=ItAekGVVc7W+1tkOuzodFI6y9dWhz1UZxCifNvZnggjam8K/0to2aFbanDYxWfkM6ej6tDM1Jm+J4ogxDl3PqBsMIby7k0KkAN28V9l/p/RZs13MSuE71L5VV+k4y0wx0JYQumO1uzVzn0vatX+TvSV6JGTg51iilVS4ADhUU+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749676899; c=relaxed/simple;
	bh=M6HxvA49p+fK8bp/m2l/SRceWAjSLs3kZZfYsnrgxUg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P39yY9hTxyzKHJ3wQw8K+Cp41cbj4TTqRrylpO7l45V2q4FPUMK3Vb7dUYXhpzweT1ZDlbe9x6xJhx5kshnOxVYpUisuwnUGMZlAouwQwlhJnpRvt39pxCzQejxg9GccBh/DnCL/YvO+1eAIVIAGU1CGFBoKPghq3+L9Tuw8b20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZEw3xTYh; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZEw3xTYh"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-addcea380eeso49025466b.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 14:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1749676896; x=1750281696; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OgzdZm4+49mKePkx+kNZ7H8LSMYhd60zWxBKo/56OGU=;
        b=ZEw3xTYhQtfK1GfVgl2KU6awL5GPzlwb6Ba6X1ue3Xuqs5H3MhGtQu7PW+ldn4ej3g
         LJ+s32gQ6FVR9/MKdSFbjqCbu8Rvt+p+rxp90X9SORXwkZKKEwNdNiZST5oF8rBgOOim
         xoMDwEUsiznoSYFtBKQBQYMAiIQ4lWfAsZiqQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749676896; x=1750281696;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OgzdZm4+49mKePkx+kNZ7H8LSMYhd60zWxBKo/56OGU=;
        b=L4RUTJdnHZqa9l3hyPriY/WNpdM1iR/t9DmSSegA7+CdDwA/YKLDujM4a83b9TXCM4
         aPbVQzNDdsFUdrQ7gtDTVKKhqnwKYKIHLOpeGXAaq3cjpR09RSUbXw8SIhOFic4uGC23
         G3wEbJQAvpv4HNP6BKYv9YVnIYd30xh3GOehieoL+Txm5JTEUjdjxauKTvsBO18PPRdz
         tno352TpMO5MdubtUj+Q5o+H8TDbesJZQfw+8SvQANXzR8ocMWs4sxjtjl0+ZLBmCKWN
         TCVm85NQpUeaOQfppvD8+gos77B/2oQ1FpuI4cZ9cMX0n/Hf1zKS5rjJGD1ahi59gMQR
         D8IA==
X-Forwarded-Encrypted: i=1; AJvYcCUlSILer5YUYez3jXeuRQwMIaq7D1jWlA31maki0BeB1kk5EgrJJHGxlhxU7c3pkpw706CbTf8asPWNPoQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyao/yikc+v5/QveOYjq9rV4Dx9s2rwYz6ZMXvlOZIcWgrzChwp
	VctngVeciGmhAoZ4IKPrs6QFVTFLGrspVbBfOoBMwviKrY3JbEbcVuR6kK1kyqr1JHcMysFRGI7
	q7cM3V5I=
X-Gm-Gg: ASbGncsM3GzkDBelzOU0ty7f2MSMF8n9C3Cc5rJFODuwJLWKV7FuVC9FJ5nGJ1JaxMn
	T2TZnVhCgkvxKe8pGovRr3CbeUreP+Nb2qeD33Gcqx9jczrRgb3xkwacaJYrYfoIzGGoAywbAH3
	JT9w+c2l5lpLu8OszcQE0WsrslibDcABis+odwHhXRqh62bQneLjq4sfwrmUS6zRRjkAk7HQmWF
	n+qXDJsHC5ui8qT9PJoCKs9A/7uhtoPgcOyz1RCWVIyvHzN83+l7PCpzZpJjDCcU+4AENpqiQaF
	gOK3sJR7l70d1h3YSzqe3qG3SD6OewAmzloVqaAlyyoCOKa3Cn3l/9OLxTq+CHaxWKNNMbUhr8H
	KGOmmZcmBUQIrHNgmYjKcNAiEzLbk30+sZ38Z
X-Google-Smtp-Source: AGHT+IGFdn1zvm2e3Sd6WQZ+X4ePFh8+ExfTPpLwSALs3zgWMffpgGMBcGqNIb85+u5N5kNdmCWqeg==
X-Received: by 2002:a17:907:3e27:b0:ad8:9b5d:2c38 with SMTP id a640c23a62f3a-adea92b4fb9mr60331066b.26.1749676895795;
        Wed, 11 Jun 2025 14:21:35 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adeadf4284bsm12416366b.179.2025.06.11.14.21.34
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jun 2025 14:21:34 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-606b58241c9so575024a12.3
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 14:21:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVL0LDeP7Y/53ykeZmPAdVkz6xaeOBWIM8cFJ7g3BHcryoTO1wIir4yK1D6q/tpfuIXAddpicPQ6LED5jQ=@vger.kernel.org
X-Received: by 2002:a05:6402:34c8:b0:601:6c34:5ed2 with SMTP id
 4fb4d7f45d1cf-6086a8d8175mr280985a12.4.1749676894398; Wed, 11 Jun 2025
 14:21:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <301015.1748434697@warthog.procyon.org.uk> <CAHC9VhRn=EGu4+0fYup1bGdgkzWvZYpMPXKoARJf2N+4sy9g2w@mail.gmail.com>
 <CAHk-=wjY7b0gDcXiecsimfmOgs0q+aUp_ZxPHvMfdmAG_Ex_1Q@mail.gmail.com>
 <382106.1749667515@warthog.procyon.org.uk> <CAHk-=wgBt2=pnDVvH9qnKjxBgm87Q_th4SLzkv9YkcRAp7Bj2A@mail.gmail.com>
 <20250611203834.GR299672@ZenIV>
In-Reply-To: <20250611203834.GR299672@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jun 2025 14:21:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgGMd31KshGecZJCupkGJQteupgk1SqswBsbHadMfpVhg@mail.gmail.com>
X-Gm-Features: AX0GCFtJBJ0_GDTJQXbaSb0DbKUaXWaGBcUByl4A2_DrwE75v36idPEAZwBhho8
Message-ID: <CAHk-=wgGMd31KshGecZJCupkGJQteupgk1SqswBsbHadMfpVhg@mail.gmail.com>
Subject: Re: [PATCH] KEYS: Invert FINAL_PUT bit
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Paul Moore <paul@paul-moore.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Jarkko Sakkinen <jarkko@kernel.org>, 
	keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Jun 2025 at 13:38, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Speaking of the stuff fallen through the cracks - could you take another
> look at https://lore.kernel.org/all/20250602041118.GA2675383@ZenIV/?

Also done.

Well, the script part is, it's still doing the test-build and I'll
have to make a commit message etc.

              Linus
