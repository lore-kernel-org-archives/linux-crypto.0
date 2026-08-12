Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B5D330D35
	for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 18:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786560855; cv=pass; b=lkVnI3383dyyF70KkI6hCj1mQ5XCLANfn5VlGaTLuZheDhd8ExjnJJDbxzZAoSELIzZuZS0ZC8/AqMWHStwO/jKvdxviTpVOTM/Gw2uuK+6saI80Z5NA6JNxYC7AhwgcLCItXnp2gOKMYgVV+dQnBNvYth7YO77qD/wku4NFM6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786560855; c=relaxed/simple;
	bh=wKe/ounIw36C7vpZFRC8NEe6E86hGEr+Lp3BJ3SH6rE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bolijn7oo0rm3Lo5XOS7AUA25gTgnJEP+zK8lgOQJpt8aIf2Xp4wdDzkhYn8BC+RZicBJrk8StmrMi6IrOZLZIMGUragV0co57oJ+Hb0xnW3X89YGgfnbeuYy6KD1GFL2d+01c7nV6+EjA8EsGTEQYH3kE/c7LCnBsdjDz/mlcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IZTEeF4+; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZTEeF4+"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2020421077so228858366b.3
        for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 11:54:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786560852; cv=none;
        d=google.com; s=arc-20260327;
        b=hJO12bG9nqNOHuj7XM9CNhco9S+Ezqibc+3p0gIHcrthaqnYZgSHw1d934MlqBPB3w
         xD6Pg5MeqWkrYqCPxtL3R+Ezcw+U9R/nTyB80jkQlSjk/vagRYZFnCRsg4yvnMyLCaP7
         xYcwJiNi8IPQHI1Hkh16/5JTV9PmTbbymlF4q+vdDVCdn5iOvQfWPCWiu79sCtzDbI8K
         +g0H7LbfnDJegiehocK5jZtvT8V2K14xFMWfj06J6uNdM7Hh2bJnTnR3645DogoIKbU9
         AZSeZ6n2rvwo8yek+hEhvgTSUwz6gnFiGA4MF8zn5P90d/uMj3PdEGKCfNUCTqa1XlwP
         f5TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ElZ2UBBJ4U1f6+x+yCpZR5zYHXMjD/lASAFoEicNL6c=;
        fh=R8+v4cgbtF3nftSSQStD1fclUw3Eg7fmers2ERFRnJk=;
        b=TUvLtOAUNMYv96OpBPsbU8/jNIHVs6NyHBHbVDEK+LhVdByyN82eJodpoumRCCW3mq
         MLU8SS5LuDBmhDcoYn9Lxdx4eL/L4T3Ab/lIst6ZFkUYvNpYPvBfe/2TPz6b4NK6RRV1
         rz8G3XvcaxYQtxjFleDa1wqXerQyg2NduXltYEpqc0ZYQjI+y2vcoMPnj9c80a1nB55I
         UasKjmzL7gHZXNCE01oC/10CHnG0/6S5qfMIknBc6ihDvzqIOL7IP0VGFO8ng74/mOPU
         M64b/hy4urLxaTrM/QPiJuD1d48Qqcsnp8DfxUDO0gF3z1FbnulCunxQcG9kyC3pdvKH
         2kjw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786560852; x=1787165652; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ElZ2UBBJ4U1f6+x+yCpZR5zYHXMjD/lASAFoEicNL6c=;
        b=IZTEeF4+4rcV3AgiC4VB2tJKI1qqI97KReu56q/f50TCxdFuhiChrJ1ZKBB+zAhIJx
         2M524Pqn9sGrCqLFGRbiQgp6it0latWbbxoGutIhoQN8tl5qeLk1vl+80aBZfto+fpTZ
         2WyOnF19eDk5BTpUu70+lptfDa6Q2jNsgsaNqZe+Lj8ajvT4mVXG5g5kKGcLiM8d+Itv
         y9A8oxlOpHuddx/nLyQeQDuAdHrhpG6Enkd2gPqTFKWZLKg1DBrynwfk2F5HyGVEfBxW
         1ufgP7Nj1WUEKcazW+evDps971v64ZwKlm+wgyAL34leMb4BZKE6KQUIG+M64vHZkwcu
         v6RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786560852; x=1787165652;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ElZ2UBBJ4U1f6+x+yCpZR5zYHXMjD/lASAFoEicNL6c=;
        b=iBPCBlLpvTzJUzWv5JqAkC4izZHhpDIgaXIeRFcKAYo0+f5cNGtKXb2ygd8jJg/pLE
         drbfATrmiy+/HPv5k7k7AhUV8ZaNM7NLB0GEyfBM24iOSomYYwQajaqgGNMX9pXnZMpp
         eI9H7NwZDZsuvpT7LNpfB+gZAm5h535k4QOuCk6jjS8LWx3nJ7pRt/yqyud/+QGT3tOn
         6OKBnpAjUkfB6AZ80D5sctHSp080wrmxX6BwvvbfekR9A428CXZHJdbOXvpVuO4N7t01
         iGd4cWRV5hAueFemCeXgYKiNotoxXAo6XjIKsCMCtZXFzUYea1yl89NFdQ6Ej6/LAzJz
         ZjmA==
X-Gm-Message-State: AOJu0YxxaK5DkVPkM5Z8NOoYsSJ7KiQyPcYR0xkaIjtTTzhWCqea1pD/
	uVXqwv9oWI5p/EbXlsOGdeRDCwMxZHcpLBe9qz++hNS7OvtvQuscWSVETMS4WpsuBrF/buQUnju
	5oc2nvZ8HO7CBYKhTOtleX8ECdM6lyj4=
X-Gm-Gg: AR+sD11JKuRaxzzItG8/zAJKKXnYi9A8t5JE/aUL5Lq2XFMIpxvpSY63Dh69MdyrXI5
	QEZPj5lOy8nBAT/VBc68bB1phYFR5kYhnent503VpTh0pSAPh47EcRM817pFaPSmM8A0/Lpz11x
	Xh22YuqpOLaSSK0mFGyme59WSamUsh96DMquZLHaiBWeqmQDmue+wqK4wEMPfj2AIbM7Asak+LR
	1eKNdqCpPWZmg6stCrXshHaUtMO2G2GRfGelQUPqfXeIMM++aPAH9n41UqRnBi56WsX2eXAMEgH
	9KHt/ldCQSDiq9sg3kxnPPhGRUBYjS6uN/W1parnsZr0Rq7ayoDhQfOCcX11xbn3ufkHjSz6GAH
	7ga/uc8u7hBIupK6medziBp3P8zx+GZMQYym5V9I/psio1k/QzVy4+6vC9CYNoiYN5e672GZJ/j
	hfiaUE225u9Tes9DZDIME/aETJmfOzGT3waaI82ibbKKoe5RA41edmhtQ=
X-Received: by 2002:a17:906:f5a8:b0:c1f:e9d3:a3f0 with SMTP id
 a640c23a62f3a-c2108ee26admr14713466b.7.1786560851751; Wed, 12 Aug 2026
 11:54:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730231603.1169539-1-rosenp@gmail.com> <anmHccSuAF5apZr2@gondor.apana.org.au>
In-Reply-To: <anmHccSuAF5apZr2@gondor.apana.org.au>
From: Rosen Penev <rosenp@gmail.com>
Date: Wed, 12 Aug 2026 11:54:00 -0700
X-Gm-Features: AUfX_mzfoY8vxUjL7PGZzTkko4g1vwIEkBcOSRUR6gbHXHDqnAuHl3MtG3oy1FU
Message-ID: <CAKxU2N9rmMAvnWLc1y7vGL4-md3kF4Bom_qnKEoHZE_k+xDvkw@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam/jr: fix use-after-free in interrupt handler teardown
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
	Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, 
	"David S. Miller" <davem@davemloft.net>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 10, 2026 at 1:10=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Thu, Jul 30, 2026 at 04:16:03PM -0700, Rosen Penev wrote:
> > caam_jr_shutdown() currently calls tasklet_kill() without freeing the
> > IRQ first, creating a window where the interrupt handler can fire and
> > schedule the tasklet after it has been killed.  Move from
> > devm_request_irq() to request_irq()/free_irq() so that the IRQ is
> > explicitly freed in caam_jr_shutdown() before the tasklet is killed.
> >
> > As part of this change, pass jrp directly as the dev_id cookie to
> > request_irq() instead of the device pointer.  This lets the interrupt
> > handler obtain jrp directly from the cookie, eliminating the
> > dev_get_drvdata() call in the hot path.
> >
> > Two related fixes:
> > - Use jrp->dev instead of the now-undefined dev local in the handler's
> >   error path.
> > - Set jrpriv->dev before calling caam_jr_init() so that jrp->dev is
> >   valid before the IRQ is registered and the handler can run.
> >
> > Assisted-by: opencode:big-pickle
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >  drivers/crypto/caam/jr.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
>
> I think we should fix the general problem of hardware removal
> in the middle of a crypto operation first before attempting these
> fixes.
>
> The driver needs to be modified so that it can fail gracefully
> if the hardware is forcefully unbound while a crypto op is ongoing.
That's a much bigger change than this one, which I cannot test.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
