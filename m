Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E7A2BEC2E
	for <linux-crypto@vger.kernel.org>; Sat, 20 Sep 2025 10:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758365658; cv=none; b=IgpwidJoI6mw4GcvjbtoXXyuQD581X/Iog+M5lyYDXzW7uMk8JWR85oGpgWLkk3CzSC9tDhOeTGAXzAvB+QadmB7W9sr03kdbv4xSlKGgncuqGdw6Ak0Vgn8qGXPnMAUon7L5PowCYCbiQk3Fj5rdjY/ugONB7wo7cIo1JvaaCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758365658; c=relaxed/simple;
	bh=MSGL0ufEVyya6PLyk+2yVbOs7rDZeR25O3ikgftKaf4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WeuLRR8QKKiqvmWh0mJgH+WOoGua/YcPnuN8BSKyY6TmTM0vxIOQ2R398i6Hf6KxxUWzn2qWrYGqAkahRsuZd+i6bxtHgaWm/NkDwHzjDsbCem0qCNO62MoP87kTeevJVxmih/8OVdLciSK8QTb9WICfZJWOeW2aC1DfTXPIQ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YeUEkPd0; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YeUEkPd0"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b046f6fb230so534428666b.1
        for <linux-crypto@vger.kernel.org>; Sat, 20 Sep 2025 03:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758365655; x=1758970455; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SHE/5/T0iACb/l6eEELV1mJgr9I92jnyUNEPbB0q1ns=;
        b=YeUEkPd0hX7gE+J85NkFoNAdkmnsKVSeChBt1Z5caLk3OHkVeK5uy8TbG+4jMjhGGV
         OqgsaSoLrBWVTQMZyfwc1JVJoLCCoh3Tj8qkJGikEkiVbmuRRwo38uSzYFTUsD40ViSo
         eovDftEP7ZgG+er70NQa9fqmzFfElpN7hcEawH8TtrL6puIZ2Oq+PNEKq8NsaRcECzqi
         mLNUFWzMEm5pScDx2Dt8a7fuIH4sDOHaQbPRyospxYfHaqBtKv0G1OE0G3eYNiJtKTA6
         t9FuZNsH5Zws5sx1+C1huxMXgsD/w5yDKnUCDxNI0o34ZX8MY6vLLxpNTGg0gDdZivU5
         67RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758365655; x=1758970455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SHE/5/T0iACb/l6eEELV1mJgr9I92jnyUNEPbB0q1ns=;
        b=j49HOF4pffTVpfvnP2ihG76X+GBHafuO38PRsuSjIW/+s6v9B/Khg9TSv2J0FI4Lj2
         emUCBL05F7bqjCmNOzU/w6+hBQkMJ+GsLru/zPV/CsKQc/AdzBcRVavvsTiNsBbem2eW
         QgAMh1zodvab5Kp+AvaG596mxpsVEkGNG8sdLPL/LKwIb8CKcGJNDPO/XGi6UfPehY7R
         9cUkRsLSxHejfShbEmxfkbrWDXZk0GsFugkOTE6ZSDhg8ZJBHTIxyeRDXtxJDekrYy9D
         Hz+flepolcCwLP4eXMw3pQSzWpW/62KK7h7WMRFgVxGjTIxxjv014EJLNTQNykztRoB4
         u3Eg==
X-Forwarded-Encrypted: i=1; AJvYcCUn3Qb0yTXQvdNzBfsZc6aDm/4+KS9YqQK7o14/C9m2bfTu8IIDtz2xqsHIeY6GrZP0O1vmswD4t7WWjrg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8LGNihmq+lHbUyIvfm0O2IMZryNsBNL65oDD/wp/y3xR4mFYN
	ExS4C1rR5MVzexCbt1/zQZDCEVe6ID5OME414tIFrpL5sx6CtYmVCBij+XeuEPismeK56c5H5h6
	RN2Clg9a0tZhvgfMoffLr6icY/0VJlGQ=
X-Gm-Gg: ASbGncuXqOsHAxcuYxwX0QDhh+cP1L9+PS11ksL9BPCjfKm7P03ZyO43DlNw+lBTgOj
	5tL+ksZ/E+GhkUhrVT5Lzw/YDWar4mi44v4I5hn3Cy3NW1I+svuQJz735IpyBsFJ17RlGHL635B
	o7bB8IOOorlHGRRYz1r5sZF1QXZRb73ZDmkVXi4p9jZKJKmOWSmRYA5bfqhw0JWnrqM2Gm+aBmY
	2XyqrE=
X-Google-Smtp-Source: AGHT+IGfr30EQw906zNu1yy6601ap33zZGnK5nPnqrLlo4963KREDwt7ZGpP76S+LfDfmQjk0YyGSf5iFcJLL0/Cwgg=
X-Received: by 2002:a17:906:fe49:b0:b04:5888:7a7d with SMTP id
 a640c23a62f3a-b1fac7bfd56mr1024511066b.22.1758365654928; Sat, 20 Sep 2025
 03:54:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 20 Sep 2025 13:53:38 +0300
X-Gm-Features: AS18NWDpSLAbdVwTREnAeu_jIcCkH8hhst__Nu2pxxOR47JsAXWXDyIhGWC1eV8
Message-ID: <CAHp75VdyZudJkskL0E9DEzYXgFeUwCBEwXEVUMuKSx0R9NUxmQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, elver@google.com, herbert@gondor.apana.org.au, 
	ignat@cloudflare.com, jack@suse.cz, jannh@google.com, 
	johannes@sipsolutions.net, kasan-dev@googlegroups.com, kees@kernel.org, 
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de, 
	rmoar@google.com, shuah@kernel.org, sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 5:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add a KFuzzTest fuzzer for the parse_xy() function, located in a new
> file under /drivers/auxdisplay/tests.
>
> To validate the correctness and effectiveness of this KFuzzTest target,
> a bug was injected into parse_xy() like so:
>
> drivers/auxdisplay/charlcd.c:179
> - s =3D p;
> + s =3D p + 1;
>
> Although a simple off-by-one bug, it requires a specific input sequence
> in order to trigger it, thus demonstrating the power of pairing
> KFuzzTest with a coverage-guided fuzzer like syzkaller.

...

> --- a/drivers/auxdisplay/charlcd.c
> +++ b/drivers/auxdisplay/charlcd.c
> @@ -682,3 +682,11 @@ EXPORT_SYMBOL_GPL(charlcd_unregister);
>
>  MODULE_DESCRIPTION("Character LCD core support");
>  MODULE_LICENSE("GPL");
> +
> +/*
> + * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file to en=
sure
> + * that KFuzzTest targets are built.
> + */
> +#ifdef CONFIG_KFUZZTEST
> +#include "tests/charlcd_kfuzz.c"
> +#endif /* CONFIG_KFUZZTEST */

No, NAK. We don't want to see these in each and every module. Please,
make sure that nothing, except maybe Kconfig, is modified in this
folder (yet, you may add a _separate_ test module, as you already have
done in this patch).

--=20
With Best Regards,
Andy Shevchenko
