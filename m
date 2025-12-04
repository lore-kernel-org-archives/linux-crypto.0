Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7339B26C39E
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 15:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764862497; cv=none; b=q1AjJ2vuBYd2nJz+ygrPBjl9VaT3iw9dJqGmjpaWCRq6yK8yNzAb9iOX6EbO6ot57M59iCq2v8O96v5jK+Qs+9GtsTumE88aur2g8iXcuOExoC/ChKKbFuxVYPJaEAjN8fm37UO7K0afYXPaovpxiOFE3BOcdjbyinrhSpvOO3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764862497; c=relaxed/simple;
	bh=G52wAaQsJpBzbRSlGJ+JRlnvopv8+9HkybJuziiObfU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yl7JPPtgLW5e1OlU6IA9c55oaVY0lyldhgirxxmNQRLppletnSN3Y33Wm1BeRWixqDq+7sl3Jv7MbsXaFMKMZm03SbQ4AAyiRef1HuKoDa0twH/gQGNpjHuj4bAxJGHiPusBGdKdqj6fvfRWdLPQLBNiPzvmhHjh/WGxxqz+5VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VWqNzLoX; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VWqNzLoX"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b735e278fa1so195236966b.0
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 07:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764862494; x=1765467294; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G52wAaQsJpBzbRSlGJ+JRlnvopv8+9HkybJuziiObfU=;
        b=VWqNzLoXCN6npFMtYc+aq9z1Hr/PrZukSi0mJEOW7EoQzK4cO+0n5cd0flyVNmkLiW
         koX7R4pAA7t4mtimbqUdL5hvJQRnK0BFLCEZEIXjLXFT4MxQBkqcidgsnSrlEthWPUgG
         C2PQ+thaWdWaUvTNdElNxd7+HHYH1XD7tUjOCYO44B8jrbeuW0FVvB8RoKJ43WBSHaju
         XXje9qni0pB6MWCLj9Vwv+C6Sm89z3aYVJoevLsyGgLdfx3CkLfKu1Fh/imv2kci4SYA
         dYfVGBNfdJVW855I3I9rAXBzEwssDqWzePAva4kc3/kEhnQHpWQJxBJ3Jprh/B4YNghR
         8BOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764862494; x=1765467294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G52wAaQsJpBzbRSlGJ+JRlnvopv8+9HkybJuziiObfU=;
        b=tcw3o0zxOVsGjK/mG4Cx3i+WwEEs1pN2e3oHG5ITDxnNYX/If+i02qHUlvrJRBas/r
         zTAJkE8l3IixY6/KGYGtHBcJEg8wgUG9eRDL4KS+Y5B55o2w/Llm5IutI8jGMT9up+JM
         yNF9CUjtnkkgytQ3EBTNSFJf+/B+05VU1y98PqDXWeyc10d9+lKtRn/XMBZXIs0vRIBR
         iH/RhVbx+g/LF78s5rKCz0krK2oS/A6ogdrh4106cUd7EfUkB7Pd7s5DxRqnqOH8tczL
         fa6kXt3TZhYt9Ib60wM9y1AIt5k/7uoktTMFEdYomuwXVBYP9Rajleaebq3Mfg+eCVCq
         DkTA==
X-Forwarded-Encrypted: i=1; AJvYcCUHHr3eaak1Ru2rNTHBJqZXmvJTB3K4eLorg4OkpwppjJPcVqvhd5qXHXi2X1XZ/mYpTS2QlXPncnSWefc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7qFC4S1mM7ix/Qoetp+KmBkl+B9+6im1RyAFOxve6x8wR8Xvg
	2jIwwEwDhfs7tP/C1QkCrdS/0C6OG5o33ikKBKEpZQU7tqwzQX7Ngf1pcfwCAhmd4MHTCSnd5ub
	Vetgwu8dtVAcJNBFz046IGsjzREhg9Z8=
X-Gm-Gg: ASbGncuHpWPYlQUkIcpbVPuHNexWbSsA8O/AkA2Nomy1tK1sUXJOyxUK3u3hOdx/sLY
	Zoxy6gAcPY3jer+P7WcBJjSs2QNlIb7deFkvGNNfJOTAbg4C08/R2xpGTX2BkW2OOQaa6ubQABG
	BsWQH5dZGkunmsdRBEeEyp5WOA+Hb5Ch8LKMz9TaFK9V/7oPQ2GjUd1FHeIFl5pS+8cCEjB/CGY
	41/ty6UipY95TI2XcYeF9CfxFK6ezAkapx0+/jXEJRTqaqXO98LF+xs41HvBrPrGlFLUJ5Agj5e
	q6auagR0fas9QT/eKraK9DrBhvd6jIjo4Wjc5Ex9JrC/BjwBifcdFAvMD819GSSpn2iR5PI=
X-Google-Smtp-Source: AGHT+IGW3DWHy09Os7hXHDrLOqPaftsD1+Uh24TUc5aiHNOpRRiFXjY3AiA/pjALEjSN+EtASYVxxi4DSDrDRJ0tJyQ=
X-Received: by 2002:a17:907:3d11:b0:b73:5db4:4ffc with SMTP id
 a640c23a62f3a-b79ec6eafe4mr430825866b.54.1764862493337; Thu, 04 Dec 2025
 07:34:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com> <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
 <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com>
In-Reply-To: <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 4 Dec 2025 17:34:17 +0200
X-Gm-Features: AWmQ_blNq2tKsiaeXqmusYzQlrYj54gbJfHS_HnTcSjJWKKhY3CPArHyaMfz3CM
Message-ID: <CAHp75VfsD5Yj1_JcXS5gxnN3XpLjuA7nKTZMmMHB_q-qD2E8SA@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Marco Elver <elver@google.com>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, shuah@kernel.org, sj@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 5:33=E2=80=AFPM Marco Elver <elver@google.com> wrote=
:
> On Thu, 4 Dec 2025 at 16:26, Andy Shevchenko <andy.shevchenko@gmail.com> =
wrote:

[..]

> > > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > > Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> >
> > I believe one of two SoBs is enough.
>
> Per my interpretation of
> https://docs.kernel.org/process/submitting-patches.html#developer-s-certi=
ficate-of-origin-1-1
> it's required where the affiliation/identity of the author has
> changed; it's as if another developer picked up the series and
> continues improving it.

Since the original address does not exist, the Originally-by: or free
text in the commit message / cover letter should be enough.

--=20
With Best Regards,
Andy Shevchenko
