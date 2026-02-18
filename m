Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5106833439F
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 09:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771405595; cv=pass; b=QcUzV3S9C8iYHLRi9Rdm0B/TO06BPYXHgOuqrfgk3WWtCdwye4fC83BLocKDAWf/dzzB0ffT3wca7qObOiJBrcJnGp0DpvuThIoZYBI3MOwYvfJpAKbzDywoGjGkQ/sYXJbufoepXxYL+W3d7Q0O0+wQtK/8zSKFLkaR5u5c4bs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771405595; c=relaxed/simple;
	bh=KPMiyYIq3BwMPpRCHaXbSFtPeLyckERuuZPEEvFeVEw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZUT/C9+pjho3TDKvI6ISxk2tI+q7/H+kR0mQmutMca7rv6DMFIA77ZIBIJltY7ZD6cpDu122guAbwq9PaCvpmlRPYT/SuFlXYWzPNQz7I5OkfVGaUl3K4D5g+8UjvC4jbKd27RFX0v+YvQ0NqmVar2BxBv46IwrdGnd8Dg9buLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=d65ss2UJ; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="d65ss2UJ"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59e5c540b9cso4617992e87.0
        for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 01:06:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771405592; cv=none;
        d=google.com; s=arc-20240605;
        b=Rle1Uo1DOgg9239OOdDbgB3MiqYPTDWmFr7O88sKaubYAlH1Lra42vTiHCXEOIUxA1
         1xkKLP3lio+LcdHmyTqHsRiw/YUBEcQCXjMk84QR47e3FV7vGT4uNIey1lRPPRSpYu3H
         19zt4Fw6PlCBjFS68YDxHWnXH6d+agM7qdlv14Ck2yWwwPmbv8gFGc/XS5NvmWEbU034
         XRSs4+pmIL0q6ar4dfE0fNF0mPYMp+Hx+1SMSsvXSlqhG5Qc0ZokWIhXKS+pKkzJrS9e
         6eThtzexSxal4cWZ85YF4/0oKXpxu3QfFoCEr2amXo9yTbE59NAM6NWZMRxCHRxoUIjv
         cnSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yVu/msihUb5+XCyfk0dAFqyq/soznOqDjC40UBhVxPI=;
        fh=6rNnmyP5grBCg/fJLzvc3Fh6qP6YLvEJe3KYqHYe2zs=;
        b=OF+AY3VfndIEqitEIFZIYxQh9xzh/SPkgew/i1F50YFJPzlLbO/kLYGiVLAsVLvKnH
         58D095zJPw57MBzZyJ+Gg1f6qz+toYvYO7Jza04pI8kMBygVRQIXORbnd24AU7PMh+Xu
         dkHxIVFScrMOREMslgUtr7lAdonWh7zrm07xHizrTsiPdmx6Kh6Irwo/npck3JQ9aLxr
         NgLIil2Y8E2jmnwX9IETe3I7kWMoz0pvf2MK2Tkqms/vAprHrK2sqXe9EAAKTLiNoDF3
         xtsrttq4U3s3Nm+VfwyAlYtuQAj7Ngpq0qPCZbBcxSNaHWLcFcH924v8CrEm8Q3+6rlK
         vkGQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1771405592; x=1772010392; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yVu/msihUb5+XCyfk0dAFqyq/soznOqDjC40UBhVxPI=;
        b=d65ss2UJochS+y8tbyZWuqQ+e5UtiJRuUTKrmMSKcjvRjJyBxt3TvA7Fl4Pzm0BMJN
         H0GRhPuzOtKyS2pdRubTdjnboLKhacWy8giHh2oxyXayCRHiUg5rJ9Y4nAxwU8+pzSTP
         Lmn/JV24D3GpwRGf1sOOMQUdZqbiMKi48mlFVyDS1J68CHlDPfhWdZA4nJKFvIg6qyYV
         478bdBPvXqUOKy2VetOCNoj4d0FRe1wtIS+aHgpDUfHaGqV6bWuVptA2vKNBHYHe+Aql
         WmF+ZYWpcq4OU25DOtTOfBC3iZ7PrTCP1UGMPlkdadzVJvxGyENAgm+aoFRG+8RZ93TW
         FOOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771405592; x=1772010392;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yVu/msihUb5+XCyfk0dAFqyq/soznOqDjC40UBhVxPI=;
        b=xC42C+/IbOXiyLZPD9ZezdvHKnBTsNF98IxdAP/P9TD2L8K+wQI9rwuzU01oyp+ucE
         QysiM8j2zd5S1DJoZJLv2110RP+ISEdYC3eoylCZNry49g4qtv3X6khVw8KM8OqeyecQ
         ylYa6mBzUYPsdcHsltD01ch8iVoMGGvBwOHcX6j59t+SXTHC+3R9Za0f3rYgy0cZaQ7H
         rHs+56UDugzysYhcmxcl2FpBJcNOnXq9jBMFewVaK63jA6MZ7/hweXt9DNWWwPiy1FxB
         dM8hLe6QLCb0atDBc5Q86tffCr4rQRNFaLhBm07xqDtdQtgmeaNYX+tkJHG7X88rpG0x
         S7fA==
X-Forwarded-Encrypted: i=1; AJvYcCU8S3oYGMN3jDnxArPYKFwT3SYJO/vzzjOANqK53xhStOkNlKmHD+i7GF842oGTWzO/TgGTzKfH84zxdsg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrWGyltVmEYX+LZ0+vD2K/OfEW/OdfAb8/IExtFfy5zqhOxucF
	qKtFVBeZ6TP7OuPe2V9ITruTMjvnl2YICz1uEGAWSuTtr3gPSRPE8aQ/7X8ySTfyyZEY73bdEEN
	eexcfMrD7Enull0yl1rUmgXIurqPjgHlhXwVJNHTz1Q==
X-Gm-Gg: AZuq6aJPmEFqL4yyiiICAdRO8lUBRfeFUcQm6KmsAxUDvpnljxblIOTljDWxadV9uv+
	oniaj8TQ/eTIzxYhU96pHcPxcYjQIifWGPXrN/qHqTZXOQZES0Kle+0V7o/RYXfbhmMPSNfyD1D
	9ZoMha8fTOU71NtXxGYs4FLKMK9ZQRus9WKe5nyZlXOH4g+0Ct9jSONSFmlbkid9CuPZl57a2rR
	8+XnQNQq5/55MAMY5fLZCpdoh0U3+9TvQQ9ZnuE98lFK/olPo067oaOxyWfIlH1Gzz1Zin6dbc8
	XdyXuGVe
X-Received: by 2002:a05:6512:3d26:b0:59d:fd1d:ddff with SMTP id
 2adb3069b0e04-59f83bcabfemr417437e87.45.1771405592282; Wed, 18 Feb 2026
 01:06:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212103915.2375576-1-martin.kepplinger-novakovic@ginzinger.com>
 <CALrw=nFiAfpFYWVZzpLZdrT=Vgn2X8mehgEm9J=yxT3K+X8CcQ@mail.gmail.com> <cb282f9dccb3cea74b99f431bfba8753b9efc114.camel@ginzinger.com>
In-Reply-To: <cb282f9dccb3cea74b99f431bfba8753b9efc114.camel@ginzinger.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Wed, 18 Feb 2026 10:06:21 +0100
X-Gm-Features: AaiRm50xo9rXc8rpw0TZ__Mpuay2z5COYGDUFrfkPTzd2SrVTEM3KPLJPgZvqTM
Message-ID: <CALrw=nFCizuZ3Cko3LnAGb8A=4KB+=HdgoZDjqPgU=ssAK0hJg@mail.gmail.com>
Subject: Re: [PATCH] crypto: rsa: add debug message if leading zero byte is missing
To: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>
Cc: "ebiggers@google.com" <ebiggers@google.com>, "lukas@wunner.de" <lukas@wunner.de>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 18, 2026 at 9:36=E2=80=AFAM Kepplinger-Novakovic Martin
<Martin.Kepplinger-Novakovic@ginzinger.com> wrote:
>
> Am Donnerstag, dem 12.02.2026 um 11:15 +0000 schrieb Ignat Korchagin:
> > Hi,
> >
> > On Thu, Feb 12, 2026 at 10:39=E2=80=AFAM Martin Kepplinger-Novakovic
> > <martin.kepplinger-novakovic@ginzinger.com> wrote:
> > >
> > > When debugging RSA certificate validation it can be valuable to see
> > > why the RSA verify() callback returns -EINVAL.
> >
> > Not sure if this would be some kind of an information leak (depending
> > on a subsystem using RSA). Also what makes this case so special?
> > Should we then annotate every other validation check in the code?
> >
> > > Signed-off-by: Martin Kepplinger-Novakovic
> > > <martin.kepplinger-novakovic@ginzinger.com>
> > > ---
> > >
> > > hi,
> > >
> > > my real issue is: When using a certificate based on an RSA-key,
> > > I sometimes see signature-verify errors and (via dm-verity)
> > > rootfs signature-verify errors, all triggered by "no leading 0
> > > byte".
> > >
> > > key/cert generation:
> > > openssl req -x509 -newkey rsa:4096 -keyout ca_key.pem -out ca.pem -
> > > nodes -days 365 -set_serial 01 -subj /CN=3Dginzinger.com
> > > and simply used as trusted built-in key and rootfs hash sign
> > > appended
> > > to rootfs (squashfs).
> > >
> > > I'm on imx6ul. The thing is: Using the same certificate/key, works
> > > on
> > > old v5.4-based kernels, up to v6.6!
> > >
> > > Starting with commit 2f1f34c1bf7b309 ("crypto: ahash - optimize
> > > performance
> > > when wrapping shash") it starts to break. it is not a commit on
> > > it's own I
> > > can revert and move on.
> > >
> > > What happended since v6.6 ? On v6.7 I see
> > > [    2.978722] caam_jr 2142000.jr: 40000013: DECO: desc idx 0:
> > > Header Error. Invalid length or parity, or certain other problems.
> > >
> > > and later the above -EINVAL from the RSA verify callback, where I
> > > add
> > > the debug printing I see.
> > >
> > > What's the deal with this "leading 0 byte"?
> >
> > See RFC 2313, p 8.1
>
> hi Ignat,
>
> thanks for your time, the problem is *sometimes* rsa verify fails.
> there seems to be a race condition:

Can you clarify the failure case a bit? Is this the same signature
that fails? (That is, you just verify a fixed signature in a loop) Or
are these different signatures? (some reliably verify and some
reliably fail)

> in the failure-case after crypto_akcipher_encrypt() and
> crypto_wait_req() the *same* data as before is still at out_buf! that
> has not yet been written to.
>
> It's not that obvious to be yet because msleep(1000) doesn't change
> much and 00, 01, ff, ff... is *still* not yet written to out_buf!
>
> is there a reason why crypto_akcipher_sync_{en,de}crypt() is not used?
> Can you imagine what could go wrong here?
>
> *maybe* commit 1e562deacecca1f1bec7d23da526904a1e87525e that did a lot
> of things in parallel (in order to keep functionality similar) got
> something wrong?
>
> sidenote: when I use an elliptic curve key instead of rsa, everything
> works.
>
> also, the auto-free for child_req looks a bit dangerous when using
> out_buf, but ok :)
>
> maybe this rings a bell, I'll keep debugging,
>
>                             martin
>
>
> >
> > >
> > > thank you!
> > >
> > >                                     martin
> > >
> > >
> > >
> > >  crypto/rsa-pkcs1pad.c | 5 +++--
> > >  crypto/rsassa-pkcs1.c | 5 +++--
> > >  2 files changed, 6 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
> > > index 50bdb18e7b483..65a4821e9758b 100644
> > > --- a/crypto/rsa-pkcs1pad.c
> > > +++ b/crypto/rsa-pkcs1pad.c
> > > @@ -191,9 +191,10 @@ static int pkcs1pad_decrypt_complete(struct
> > > akcipher_request *req, int err)
> > >
> > >         out_buf =3D req_ctx->out_buf;
> > >         if (dst_len =3D=3D ctx->key_size) {
> > > -               if (out_buf[0] !=3D 0x00)
> > > -                       /* Decrypted value had no leading 0 byte */
> > > +               if (out_buf[0] !=3D 0x00) {
> > > +                       pr_debug("Decrypted value had no leading 0
> > > byte\n");
> > >                         goto done;
> > > +               }
> > >
> > >                 dst_len--;
> > >                 out_buf++;
> > > diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
> > > index 94fa5e9600e79..22919728ea1c8 100644
> > > --- a/crypto/rsassa-pkcs1.c
> > > +++ b/crypto/rsassa-pkcs1.c
> > > @@ -263,9 +263,10 @@ static int rsassa_pkcs1_verify(struct
> > > crypto_sig *tfm,
> > >                 return -EINVAL;
> > >
> > >         if (dst_len =3D=3D ctx->key_size) {
> > > -               if (out_buf[0] !=3D 0x00)
> > > -                       /* Encrypted value had no leading 0 byte */
> > > +               if (out_buf[0] !=3D 0x00) {
> > > +                       pr_debug("Encrypted value had no leading 0
> > > byte\n");
> > >                         return -EINVAL;
> > > +               }
> > >
> > >                 dst_len--;
> > >                 out_buf++;
> > > --
> > > 2.47.3
> > >
> >
> > Ignat
