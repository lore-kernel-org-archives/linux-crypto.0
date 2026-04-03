Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9136E26ED46
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 05:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775193375; cv=pass; b=db2RH9f5jp3yeFPxpsIkPrB/KyHY113CwQX31cwySW6Abs+qnqC/c6xiYrGe000K5KQcTVd5MzWXtsrbDu5ve12wCkMSm1sWziUpL3jS5mUmpJj3LS25B3ti/+micFn+9PZxSDRISt68nToyGs4sj9Qz2bZG6w85FiTf5ihG/bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775193375; c=relaxed/simple;
	bh=edd8CrUDY+4/KvhRYFnFP0Rc42SMIhnyq2/4fdewGm8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WTZH6nCNybfUZ+ObYreJdN4lROPwwSgb5Ce08abtQLxzxEivixyPwbLOTSA9HzONUVJm/0G6mq1SF1Vt9M6k8hVNzSnY2CNP3IkVrTWDxvD75RmhEP4lysLXes468lj+pZHi2o22ZjNIaqWMG96NQBChd6qSVSmnYFMYyZCPG90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=theori.io; spf=pass smtp.mailfrom=theori.io; dkim=pass (1024-bit key) header.d=theori.io header.i=@theori.io header.b=JpeBfW6q; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=theori.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=theori.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=theori.io header.i=@theori.io header.b="JpeBfW6q"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43b8e8e7432so1294345f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 02 Apr 2026 22:16:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775193373; cv=none;
        d=google.com; s=arc-20240605;
        b=d8Jjix3IY7lSnQVeQ90n4NbzobbibK53n1epMVoSNzkuwRu4RR3oXJ5Ur/0j59ai+T
         ssRn20OWwGJMcgIv0mFjF7SNH8qDd4UkTbHWaxWYF8vfiR3sGpOff7ZCq1ZDqkSErdND
         Kl0hVImfHcLaMcB6bTFPx/Cli82x8EZtxw26HiYvS4vo/3CvfXa/mSXkh8d6m0dAwxGG
         kk6nGQShnNwYB7BsqeY4eIGXOsZtbQJxhsib0NXI66ymYhGFpMWinKeL1vKng63imb4H
         jPi3wphFjw/MH8eEIzsfu+t+nWvkNOKNxOeYEPEcw+R6ctjmzROE0clcHwGDMp4OFANf
         CnLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JTAsfHVHzBo/QjI2xlhaCA0ir3VnZNWCJ4AL0iv0jSU=;
        fh=5NrMv9mtW1OmH1vGgLGo4st5nuutcYrzFScqlg6A3Co=;
        b=in/+zXdqaKYXM0/aJe5EjAPJOlgOFnV8nRSTg+p5lv93tiiQvgKa0VEX2NnSlwiWE1
         GFUWhfEcu8GKGzemSuLHpGKqr0nVFUxzR5drsQ+b2MWhyPo1MLrS9csA2GnzfbPiPlB5
         q1Y0RVgd4LenBPye0qxXuLxPtEzsgF2J2PoY1GFyfX4BhUI1PHTbG9DXGjpHKa4XpdBZ
         9U58peI28pvDkOjCuOyUNrs4ko01K+C+4Bv5hUwpNjTFEM6/ZeBZKQMNC86S3LOVMim5
         X7jdY8QQGIOPOtz6cMvTBTqyl5pi3NvKaql6ts6je2e5ko4735ukkAqPlGoJ7OHE64Qz
         nfCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google; t=1775193373; x=1775798173; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JTAsfHVHzBo/QjI2xlhaCA0ir3VnZNWCJ4AL0iv0jSU=;
        b=JpeBfW6qwgt/OTFGg3R0AwuVcLDYlII6Dx4jOHKJU1A4gXR7lqXkXF1EJuq2oIlbsx
         VPtwzwwu1cSiTxUSNxlIPL1epISBd+uleOXrFwOipS1ADO6rHFJJTWyOIdXraRs1uis7
         nZOsX71se2XQ1ig+LrAJna1lkplkpAcvS4VuI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775193373; x=1775798173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JTAsfHVHzBo/QjI2xlhaCA0ir3VnZNWCJ4AL0iv0jSU=;
        b=W3WsWmftVO9vKRGhYsYZcaN6AeZm3kAInxLIqZgYDn1gr2w3f4fUWHpS3XBmMbzI+r
         G+GHJ8uFvNTI/HGsL2xTxDoxs7Ib4HSIRElTf6BL++NCmsYX25F+HsXvLs5hcz7VsCY0
         RKP6Lb2twQ0P7eecihQjUCZQLm1kT81XK2OeV9+Y+ezB2b8FNH+URv+gco+D21LSw+5Y
         NR6q+5POQ/htkOM2rIO9s0WNw4CcuhF76AdAYO9Gf6/5uFLWwdchThNcv+o3sdvKviei
         vklKSgJI5U5vknbyFlWLJ2JBITXY6s59vQ/aaGBdY5ucXxcAKBWKJaxkR/qdeKn+LdCL
         1xcg==
X-Gm-Message-State: AOJu0Yx1/LnLrHrYQhXg1UXxzwZsII/WA++WUcRHuASfGWrByfMWCUrl
	Ny2B8k8ygukVBsd52+JIqbqJYUV/UMpyQekjzINphvLQeUz3cRnbnZsoyFVJFjK7uaC8ylpuyOq
	hTmrW1gmRCbUeGjFIvxeM2ha6ICJixqFAgZduTAQqqg==
X-Gm-Gg: AeBDieuAxcDB5mJh2CAgpCkJdaJIo67NQKqNzYdHfFxnui3b24LN/nrG2eZA8ryllGK
	sB+ltPUAL0QiP2FzjEcdMo0eTzEmfyPh4cQea2jajKVjDD8GL68pk39dk6zzn1gn/JUBjvXy65A
	wUuz6CCnZ7pqcZJ9VUlNuK+lMpQERO148cpLdH2D1hx16q2MWm4Fggsc1J0Wufeq/O0C4L1o/V0
	jOs5LkfnRc1owQNZpE8tya6uKhbU0djT450eq6azN41ks63DrR4Tmq+ddq0ZHbirLJ8bhKO3QG8
	yRAfImY=
X-Received: by 2002:a5d:5f86:0:b0:43d:1c21:ead5 with SMTP id
 ffacd0b85a97d-43d292a9591mr2428490f8f.22.1775193372860; Thu, 02 Apr 2026
 22:16:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <acOpDrnN3cVfiASk@gondor.apana.org.au> <CAH-2XvLZD_-CVQT0omao2+GrdQt1Loq+oo4X6q=0NUAeUk==1w@mail.gmail.com>
 <acTSfLPWDGTaGIf7@gondor.apana.org.au> <CAH-2XvLaZR+Ee+q35wXexKEh3AE7R0w1AGC__kV9To_6sLMdhQ@mail.gmail.com>
 <CAH-2XvJFuwsOgOXap17vEWsX9v9=g1EKxh-fA+ZF=QM2wtEkpg@mail.gmail.com>
In-Reply-To: <CAH-2XvJFuwsOgOXap17vEWsX9v9=g1EKxh-fA+ZF=QM2wtEkpg@mail.gmail.com>
From: Taeyang Lee <0wn@theori.io>
Date: Fri, 3 Apr 2026 14:15:36 +0900
X-Gm-Features: AQROBzAFDoFBujbD2tpp-8UCZx1dztnQIIE0jMko1IdQcFQcbRmqKuhDzYkU13I
Message-ID: <CAH-2XvLSrrT7cPw8A+tDBdhX3N7bpOjtM_A=2xgHcegjq828WQ@mail.gmail.com>
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

I just noticed the patches were merged a few hours ago, so please ignore
my previous message.

Thanks,
Taeyang

On Fri, Apr 3, 2026 at 1:49=E2=80=AFPM Taeyang Lee <0wn@theori.io> wrote:
>
> Hello,
>
> I've reviewed the proposed patches, including the latest version, and
> they look good to me from my side.
>
> Do you have an estimate for when they might be committed?
>
> Thanks,
> Taeyang
>
> On Fri, Mar 27, 2026 at 2:43=E2=80=AFAM Taeyang Lee <0wn@theori.io> wrote=
:
> >
> > On Thu, Mar 26, 2026 at 3:30=E2=80=AFPM Herbert Xu <herbert@gondor.apan=
a.org.au> wrote:
> > >
> > > On Thu, Mar 26, 2026 at 02:59:24AM +0900, Taeyang Lee wrote:
> > > >
> > > > I don't think checking only `src !=3D dst` is sufficient for the is=
sue I
> > > > reported.
> > > >
> > > > In the AF_ALG AEAD decrypt path, the child AEAD request is intentio=
nally
> > > > set up to look in-place: `req->src =3D=3D req->dst` on the RX SGL h=
ead, and
> > > > the TX-backed authentication-tag pages are then chained behind that=
 RX
> > > > SGL. So from authencesn's point of view this still takes the `src =
=3D=3D dst`
> > > > path, while `dst[assoclen + cryptlen]` can still resolve to TX-back=
ed
> > > > pages, including splice()/MSG_SPLICE_PAGES-backed page-cache pages.
> > >
> > > Right, that's a separate bug.  algif_aead should not attach a
> > > read-only mapping to the dst SG list, which will be written to.
> >
> > Agreed.
> >
> > By removing the RX/TX tag-page chaining and turning the child request i=
nto
> > a genuine out-of-place AEAD request, this looks like it closes the AF_A=
LG
> > page-cache exposure path.
> >
> > With that in place, I think the security impact I reported should be
> > addressed, even though the authencesn-side use of req->dst as temporary
> > scratch storage during ESN rearrangement would still remain as separate
> > cleanup for now.
> >
> > Thanks.
> >
> > --
> > ___
> >
> > Taeyang Lee, Security Researcher
> > Theori, Inc. / Xint Code
> > Website. www.theori.io / xint.io
> > Email. 0wn@theori.io
>
>
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
