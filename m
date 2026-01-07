Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC0431619D
	for <linux-crypto@vger.kernel.org>; Wed,  7 Jan 2026 14:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767794403; cv=none; b=N4dY5p1Pf+9tFiqMyfQ8lc/tXxT5/Zt063Z7QMomLu1l8wxJNUnekt9bO41TY2wsz291SAXoLXt26YKbYJ2TE6j260PNgYQuni8opEqSXAxpgbDo/68WfFMoU0aBGEMywvg3dWUNaTFTKwfaskhjL49TdLsFVOPHrjTi7CJmIVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767794403; c=relaxed/simple;
	bh=TrNOZ6HpS6QFZtTMyoW+Wf0WTeQJHYUhQM0CiAPXgec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YYs4ocE+Ick6nK8vjtc14yO8MC8VO5CAAbu/+4lp1Ek/ptZ37qbTrUqE9y8YMJqgz0vh2rJ3DiZoBTtRTIQl//LHJC0u66I6V9y1sJruiK/YRZ/g2uj4njjG41uZiYvq5MI/S3SVyjOwe0+l7jVhT7mysWy72ezdFlY9IK0304k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=f+VOfcMf; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="f+VOfcMf"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5959187c5a9so1953905e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 07 Jan 2026 06:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1767794400; x=1768399200; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6nLSyDph51skBA6xT8p5KzKOmafgGpX1ihcuW8dmXLk=;
        b=f+VOfcMfdCYhA4DRixHaJ/P15g3Y+KhLXx9aXPu0cr+N4b534DUGr09Z6gKLXdsC5B
         0a+2vyO6aiy6w7zEhFDc0jAc5KHerMNeIxmiO3cMvitGWz0ddPyOf9wBZdLcDYCXJeg8
         YS9buXZxlF5Kplxxt7bOQBeQTqkKc3hZWLV8SAlVfER7s1uAPT1Yo3ox/ewtnML7nrvd
         gzV8K7W4n91mw9VXj/1YB5y9oLjE2ZkG2t0kZWaYCnMa5JlPYcTNhL9IyYQwRk9bLiBP
         dCxJEtBUE2gfz9djpE/USDBD/9BGEMZDwTCuSOUVrYuFX8/l7D6IMhgmFQN49ukvMD3x
         +BwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767794400; x=1768399200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6nLSyDph51skBA6xT8p5KzKOmafgGpX1ihcuW8dmXLk=;
        b=HaTW8k9ewcxaw+80Qtyz0QTeGM9d5Uq2ScpH5CwNHT0h+Lr9/jc4KvGn846FVxdf+R
         w663PKwC31QBK0f3dHg80JeHNXDZsNxbK2ma2ttuxEWOv+G4e//rcSv0438dLrYjGtEZ
         FDQ9VPw6Fbcg77AkfvrSAS447yehIuN4Ux0tbHPHzTSNt+XmYGX40bsCKSiEEcxIlzEk
         6q+jt574xpom7jtDUhmvT9mOVNLnPqNuMu32cgNweOpxwHQxhr4vmcm5blefErW2/roz
         MQCutrD/GV9LGXEntwERxIW/GXylICpenWt4MyXhtGoCejlkvpBvcw0JuCurRrfbf3fd
         HYlw==
X-Forwarded-Encrypted: i=1; AJvYcCV8qDaHZyTZafpZBjD3w84e3fRUvz1UqHbT4MczSaw8H2iNvdIsC4yvPOBgqrJlZf3tcElWSPl2sTX/fY4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJW5XxFc50sUt6pUiHSG/qB48FU+XMVnXDCGR2R19+cf8xAyU9
	Fb0FMx3mHQLiQZgznCuXwqjY3m3Nch13DT0XLilVHQsbxT1gOmPpo/3m6TuuJqCUHZkRA1wYBkW
	BlWnPijjehVKCk0qpzFMNoO5vpwdG4aU9OAmlyLKIkQ==
X-Gm-Gg: AY/fxX5MKOZ9RFlkQEtKs2u83PU86Dng2gBnRCYILBugux3UREeClnDUpSGyk8QU9R2
	nMZksdUyWmwzcDoUHapjnVVt6+A+wEkzh8hMGZg5xeNO1xlGvT0iB655B4GmU6q0JNPSkw95VP9
	Ax0iPyn8bOsyqzZXE2/c33cttnWZf7a46t227o1pFx4RpaQSt0/ZR1cwrLDVLmBMVJMaSrSysfZ
	3vMK1+AvJjkueslQi+3gBazGIgeI1LGmkPKASIVAOuQf+YhasyXQYGnp3Viom57nYCVy+I+K0cg
	/iZZnZlbzIhWbA==
X-Google-Smtp-Source: AGHT+IEHYfi0dlZf2YFiZv8lqVOnOsYUzA5eTbLyIL6UM3u5CJcQUUMyunitfw+FxpRXUzE0Q5OSUPDvSRXxOsia/QM=
X-Received: by 2002:a05:6512:39cf:b0:59a:1bdf:c437 with SMTP id
 2adb3069b0e04-59b6ef094bdmr951885e87.11.1767794399867; Wed, 07 Jan 2026
 05:59:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260105152145.1801972-1-dhowells@redhat.com> <20260105152145.1801972-3-dhowells@redhat.com>
 <CALrw=nFj9OEsREJ8Kxox3U6N8y=e00ZawxEkCPOb5-6_k=7+nQ@mail.gmail.com> <2366240.1767794004@warthog.procyon.org.uk>
In-Reply-To: <2366240.1767794004@warthog.procyon.org.uk>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Wed, 7 Jan 2026 13:59:48 +0000
X-Gm-Features: AQt7F2plMc4I4NtJi5fV1xvI4Yfd3PKBoxKSGD1WG5sCKDWXR-Ox669ezz_yn9M
Message-ID: <CALrw=nEmPVNRvno2=48d5k+txRv=CKKezsKt5YunoKHUaNhGmQ@mail.gmail.com>
Subject: Re: [PATCH v11 2/8] pkcs7: Allow the signing algo to calculate the
 digest itself
To: David Howells <dhowells@redhat.com>
Cc: Lukas Wunner <lukas@wunner.de>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>, Stephan Mueller <smueller@chronox.de>, 
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 1:53=E2=80=AFPM David Howells <dhowells@redhat.com> =
wrote:
>
> Ignat Korchagin <ignat@cloudflare.com> wrote:
>
> > > +                       ret =3D -ENOMEM;
> > > +                       sig->digest =3D kmalloc(umax(sinfo->authattrs=
_len, sig->digest_size),
> > > +                                             GFP_KERNEL);
> >
> > Can we refactor this so we allocate the right size from the start.
>
> The problem is that we don't know the right size until we've tried parsin=
g it.
>
> > Alternatively, should we just unconditionally use this approach
> > "overallocating" some times?
>
> In some ways, what I'd rather do is push the hash calculation down into t=
he
> crypto/ layer for all public key algos.

Probably better indeed

> Also, we probably don't actually need to copy the authattrs, just retain =
a
> pointer into the source buffer and the length since we don't intend to ke=
ep
> the digest around beyond the verification procedure.  So I might be able =
to
> get away with just a flag saying I don't need to free it.
>
> However, there's an intermediate hash if there are authattrs, so I will n=
eed
> to store that somewhere - though that could be allocated on demand.
>
> David
>

Ignat
