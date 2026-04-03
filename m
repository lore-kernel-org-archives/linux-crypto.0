Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0027081A
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 04:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775191817; cv=pass; b=ZzQSPYYixgqH5zQklVhbw9/JQeYSx4isxVhGWPisghIPKsbzVMJKQI5HUc37XfKmEdQ5l1x3sqdsdtgNLbpi8BcYdM3C+TOofkBMobgCzqsURGkU0a5hYIRE70oBHntc3MPF7QyyxfcJZtvpc0SU0in3FiIV5N5zufWrrXJubQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775191817; c=relaxed/simple;
	bh=3tpfiqKVGuJfvDFy1q00BHEHjoDzP2qgamqVutiTPAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=omqOznVDnVPRO2qjo+RMn3zNm0j1PSrJgJEYSSjJdeD6SGtppz3YJVe1dem/aszSolcn3qripQck6mklIe4pNZipaqsg5sWkd/rieqjYzhzFZKT8kxgF85W5xBIxCuN+yV2qBQyrOXarvo+9AVXzgCV8nCZphbSEQaQsQdY8R94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=theori.io; spf=pass smtp.mailfrom=theori.io; dkim=pass (1024-bit key) header.d=theori.io header.i=@theori.io header.b=SJs07Etw; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=theori.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=theori.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=theori.io header.i=@theori.io header.b="SJs07Etw"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-486fba7ce4cso16355635e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 02 Apr 2026 21:50:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775191815; cv=none;
        d=google.com; s=arc-20240605;
        b=RKw7EVeThbk4NsUI8YL/vDf0ikjsvOh7RQSwT6lkenU8vfCvoIrtD3Eq5OuDB8wzMG
         IDB46V6OEYsqEzMvDVFYfX478iA7ypMZZu3PwmWrfknQ8gir1nXKyothfa7qdElmHCa1
         UkUXapecT1liMtKPKDeZIY0smfTkdxZ2xCExo7ADzGXgqrPaujSWcyuv2cvHpqYxEbQr
         /joDWOQ8KGVYuS1jHBOq6aFncvbVFudv1ZM859J9IuvTT8H8Uqrtcyzic/Adg2GNwz/L
         pgMbCJfmRQZeyL/YTd/eH7tupXCFQ9ATLf1IJgMBbh+sPiDyHIdPpux0FkUiRvkwmROS
         WIcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c/pIjX5YYHYV4pPZXGdCWE1ZrWpDr6sivlyeTnq5a8g=;
        fh=5NrMv9mtW1OmH1vGgLGo4st5nuutcYrzFScqlg6A3Co=;
        b=fB/QL16X+LEZhU0vOFPU95j6BCHyJLUb1IUDSTWOxR8O0yHEhok704QxkzGDCqpOFF
         kyeqlqUYMMvzmwnoML4RAXzrfScgtYOYwjJWYFDgMexHDE3EbD8Xqyo3PREPK9cotUCo
         GfbMtGOvWj3ioSXhWwJKVOOr8fqdJN9MayJUj2m4/P7Djv0vc+SITwlJ2C0BA/AfEAkn
         b27m1Y0Z2EUK+n2kowrmXaiTHOO3U1/vHJEWLnDAuuhY2R1Ifj6qB9LRG8VkRxiBjh1F
         mChMPG8jK1eqspL4oFg6QCJbpJlzqvr7GlJ8UOGF8JTqFgJKEXS2Kp9+aO03yB2g4Lpt
         P6nA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google; t=1775191815; x=1775796615; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c/pIjX5YYHYV4pPZXGdCWE1ZrWpDr6sivlyeTnq5a8g=;
        b=SJs07Etw/pv1vAzyoB1OftvxuUtPGH123n1X8y6i24dcLbau6l77bXv6W1GLmOVbk/
         t0PjV8tfI6DtIHW/MVtkKSWWXjbaKsbaTiDP9BOJaHV4ZeS8rG/AQ7WyW372YK1Wm74R
         OwM9R7YxG1bpzCF3U0q3Y7bwSOpmaiRCrciyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775191815; x=1775796615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c/pIjX5YYHYV4pPZXGdCWE1ZrWpDr6sivlyeTnq5a8g=;
        b=cB+yYlJy0nKKNCQD1s67pbMvg2pjH/2IOkg50O2paF6r7UPYj7qNERgm+KasWHptVI
         x2aRenqhj4A3QOqBntCDjK1rmO/gVT8SabM8Eq5618ZbME9QSeqKobpUpxWz0jcq1giS
         drEz4VNgSXdrtH5Agbt9RSrG08pcC5+4WavWTsZOYWVTLKsG5ifXYhX3U1Dy1XRqkeD5
         k8NGQiF1b83anGRyq+Mny0TUqTw/nxEKAmHrwTDjxmbKI3UTl48weT0Sq6EKPxrbF/F8
         Xgri3n3pUufKfJFiEaHHu1wW8gJIiei0rHOrsP/4AkhF2fKTVmsSq+1pCPtqWL+zUCrP
         4MSA==
X-Gm-Message-State: AOJu0Yzt8tloN0r9hhXxkI9GABGwRBN6lO+zcPmqwJy4BN0eqoqBDGxS
	VCScwNl9krmsV9hj4xofgWy6m2qxpl7nT5aISUwPRMrbDwrhNTo91clwCw+PRW5ztO1ZwETGcBy
	iOyS/S+u4alnfMEbN0LoRAv2j4Ug+GcJuy1+rDMhgng==
X-Gm-Gg: ATEYQzxlvE5lyXpOPfh3PD/a9KLD08O0+3W4Cm8Bqivxn0Xw88Uo2ujVWgch+rAdxAV
	zLe3QdFDMUY7XRjMW3q0fgwFQfqdhZIWLmJH7suutI0K59WVjvGna2Ptawn15ucA5RcwKQgL60M
	Y3L5xtQa3hM/VyUl0l9Zh61FpAntFCFgKRad5qWDAPKo/3ag0jKJkqimZnP+Gba+Hd4UNNKZqGV
	jIhpv4dZ3u55VKBwvEatBCvlL1T+VvZZiNnV3IBy259FV4QpEkkaSwJkb5Vf+goNSqpKDhNNUrx
	xTj6qIE=
X-Received: by 2002:a05:600c:4593:b0:485:3b00:f93b with SMTP id
 5b1f17b1804b1-488997e7b16mr24329915e9.31.1775191814038; Thu, 02 Apr 2026
 21:50:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <acOpDrnN3cVfiASk@gondor.apana.org.au> <CAH-2XvLZD_-CVQT0omao2+GrdQt1Loq+oo4X6q=0NUAeUk==1w@mail.gmail.com>
 <acTSfLPWDGTaGIf7@gondor.apana.org.au> <CAH-2XvLaZR+Ee+q35wXexKEh3AE7R0w1AGC__kV9To_6sLMdhQ@mail.gmail.com>
In-Reply-To: <CAH-2XvLaZR+Ee+q35wXexKEh3AE7R0w1AGC__kV9To_6sLMdhQ@mail.gmail.com>
From: Taeyang Lee <0wn@theori.io>
Date: Fri, 3 Apr 2026 13:49:37 +0900
X-Gm-Features: AQROBzAHUzQX3GfhaB4WIKsrXAruCaKsM5dSmU-j5SXfe3gRWcuHRRkPlkqLdaU
Message-ID: <CAH-2XvJFuwsOgOXap17vEWsX9v9=g1EKxh-fA+ZF=QM2wtEkpg@mail.gmail.com>
Subject: Re: [PATCH] crypto: algif_aead - Revert to operating out-of-place
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Linus Torvalds <torvalds@linuxfoundation.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net, 
	Brian Pak <bpak@theori.io>, Juno Im <juno@theori.io>, Jungwon Lim <setuid0@theori.io>, 
	Tim Becker <tjbecker@theori.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I've reviewed the proposed patches, including the latest version, and
they look good to me from my side.

Do you have an estimate for when they might be committed?

Thanks,
Taeyang

On Fri, Mar 27, 2026 at 2:43=E2=80=AFAM Taeyang Lee <0wn@theori.io> wrote:
>
> On Thu, Mar 26, 2026 at 3:30=E2=80=AFPM Herbert Xu <herbert@gondor.apana.=
org.au> wrote:
> >
> > On Thu, Mar 26, 2026 at 02:59:24AM +0900, Taeyang Lee wrote:
> > >
> > > I don't think checking only `src !=3D dst` is sufficient for the issu=
e I
> > > reported.
> > >
> > > In the AF_ALG AEAD decrypt path, the child AEAD request is intentiona=
lly
> > > set up to look in-place: `req->src =3D=3D req->dst` on the RX SGL hea=
d, and
> > > the TX-backed authentication-tag pages are then chained behind that R=
X
> > > SGL. So from authencesn's point of view this still takes the `src =3D=
=3D dst`
> > > path, while `dst[assoclen + cryptlen]` can still resolve to TX-backed
> > > pages, including splice()/MSG_SPLICE_PAGES-backed page-cache pages.
> >
> > Right, that's a separate bug.  algif_aead should not attach a
> > read-only mapping to the dst SG list, which will be written to.
>
> Agreed.
>
> By removing the RX/TX tag-page chaining and turning the child request int=
o
> a genuine out-of-place AEAD request, this looks like it closes the AF_ALG
> page-cache exposure path.
>
> With that in place, I think the security impact I reported should be
> addressed, even though the authencesn-side use of req->dst as temporary
> scratch storage during ESN rearrangement would still remain as separate
> cleanup for now.
>
> Thanks.
>
> --
> ___
>
> Taeyang Lee, Security Researcher
> Theori, Inc. / Xint Code
> Website. www.theori.io / xint.io
> Email. 0wn@theori.io



--=20
___

Taeyang Lee, Security Researcher
Theori, Inc. / Xint Code
Website. www.theori.io / xint.io
Email. 0wn@theori.io
