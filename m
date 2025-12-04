Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAEF2D8DA8
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 17:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764868244; cv=none; b=l+4YydWBSekc3rU5ydGgBrrRV9N5gZq1OZ0YNI9d/+F3UJG3iDitwbjRd5SixtLvODK+omfFjewv1909tZrRF3xAYSV/TMeCMvt+El0JEkey/RBDWV8+C9b8evpx38OGbWLmnCX2r0aRUXns3FAz8ft3I2ei0BIfBojh+mNypE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764868244; c=relaxed/simple;
	bh=Luu0dLPCGlCn7g8rOb8w3AI39PT79ZYzQ5Pim7OffGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YdoCZoeXxJ1aREm/ZPw7RlwdVwRI8aBvj37nYlDZv/2t1sl+JfgMcRNRztbbfKn+L45nTNtxs/BmpDHVQtyKZiRIR0m13h98X310YZm8m3vqsPBzeIjwUe3fOFpu8twuYBMnKBdfnPGfELo+b1GgHzZDOO2RdZH0r9nd1eiO+h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dEhsPLea; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dEhsPLea"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b739ef3f739so195895766b.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 09:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764868240; x=1765473040; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Luu0dLPCGlCn7g8rOb8w3AI39PT79ZYzQ5Pim7OffGo=;
        b=dEhsPLeaxY3zdt6Dx1ZDPvbuUTkEE5jL+UH5JNb9cKejUUVAwwBVqcI2Ncv4n326NA
         V83oAl83X0+mUMLTMZLeNXjhyzEmeE2JPLcFcKx9/V6XxG+ARfUdfA5IaT0+why4W3n7
         WT/RHKbDTSBzmXj8gtTI1JiIQ722SNlfK6inzjgfvjH5DLRx7MoffJhldayD+nVKB0Zx
         LB2SXVSzCr6BA5V6VtKb5r2KmSJ/YeaZ4ifvp08fBlE/Ee4f7I8i5Tw5ww6Xiu5TEWtN
         LJqlnp5x9aswQJQP30+lFf5kbSnqgj5Wjn0vbAi6NijoB3snlunlSsK7wLkbEI7mPZVN
         gZ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764868240; x=1765473040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Luu0dLPCGlCn7g8rOb8w3AI39PT79ZYzQ5Pim7OffGo=;
        b=Vag3o0AGRNQaPOzwzeKXCuYojradF8yszoCrA5LZQttdb8U9PIdAFdcNkwkxS9BcoY
         Dd5ugVcFEN7hAhuZgR26kSYLU24XE+mlCnfmCHCnkslrQqLkEoAfTp71OvixMIBtPrrC
         eZ411w6ItW0tkJXUFRDNBaHqqS10lmFWsr5/bI1UKFRYHqUbXyQDJFbcyvOphe1JJW+n
         UcSspPcXG9HZQ47U3g+v7O7n6cN9rbgGmgdRfYeK5Fb8Ss4ZxB5sBG659Z+fSX6bOEX4
         Slgcbl44c7sXVgOUESMRZIoRALe/lQDTCF1/fklkwzNbg+hC7iYE/+uY1C7znUolvtHB
         2hWQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1P7EYBrEDbk2vVlzLSVn1SWsY6QpkD3duwtiIz2LBe/CFeYfHl9djq3Cw2loarEqIz28yVF5NI9CM67k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPbieBqhYC9Vx4pNlBs8z5xrWzIpc/NDDhAfP/H1GEJq27Ntez
	IaIWPdcb7VZNMWcH2S3HzzZ+802Z8tYRLjKwwO7H6mJ+0HY4Yubp++HvMz27bfxBon0cad7/dEM
	K4Fvb4InjtS6nhxgOgIRC6Mkxplm3wfU=
X-Gm-Gg: ASbGncsCdtS/WOz8Na87bnmknQ00YXX+3Uia+UrFQy77Xt/lVrfaU9BmUWHe64oa0+6
	1iv9aoBiTk15fxm19bkNS76Oso5mQPsLFnkO2ZOf0tTgPZxXotzTLuNgzHiGBRCPut5F/3uII8W
	FmmkLeALzDtLKhQJjL1/aO4ANtLpirTGhOoyuiIfGdGogz2ZeiwJ/ALJOrgh8f06EiGCeGAvpME
	UAQdgk+EOEQ4ZEy0HQdw/O2dbO3VGXDrYsk06epGIjOL32EFc2KptpeGmd9Y5Z3IUaUTymVi625
	kbs6WksRGLJe5lG40uwhAPlS5VVjoP4DktAbRC8DJXG1GFzhQMzLvTVAd/PmwjBe6vaVQXU=
X-Google-Smtp-Source: AGHT+IEYKHVXa85Li2pElk6yFv5g6STpHzlef/8H62UofABcN9oQ3Wj+xk/v4+/gcktKR5nlyxnkhnAfTauuSY9u0Fc=
X-Received: by 2002:a17:907:7f12:b0:b73:4aa5:35e5 with SMTP id
 a640c23a62f3a-b79ec3f09c1mr410215466b.7.1764868239255; Thu, 04 Dec 2025
 09:10:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com> <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
 <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com>
 <CAHp75VfsD5Yj1_JcXS5gxnN3XpLjuA7nKTZMmMHB_q-qD2E8SA@mail.gmail.com> <CANpmjNOKBw9qN4zwLzCsOkZUBegzU0eRTBmbt1z3WFvXOP+6ew@mail.gmail.com>
In-Reply-To: <CANpmjNOKBw9qN4zwLzCsOkZUBegzU0eRTBmbt1z3WFvXOP+6ew@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 4 Dec 2025 19:10:03 +0200
X-Gm-Features: AWmQ_bmM6LnwCv_8DkzClBvkpIFbzUw_4DvWZVBU7sLi5C0dPTkjJPGuyU2cHmI
Message-ID: <CAHp75Vd9VOH2zHFmoU5rrQCRqJSBG2UDCfKgvOR6hwavDVqHeQ@mail.gmail.com>
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

On Thu, Dec 4, 2025 at 5:36=E2=80=AFPM Marco Elver <elver@google.com> wrote=
:
> On Thu, 4 Dec 2025 at 16:34, Andy Shevchenko <andy.shevchenko@gmail.com> =
wrote:
> > On Thu, Dec 4, 2025 at 5:33=E2=80=AFPM Marco Elver <elver@google.com> w=
rote:
> > > On Thu, 4 Dec 2025 at 16:26, Andy Shevchenko <andy.shevchenko@gmail.c=
om> wrote:

[..]

> > > > > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > > > > Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> > > >
> > > > I believe one of two SoBs is enough.
> > >
> > > Per my interpretation of
> > > https://docs.kernel.org/process/submitting-patches.html#developer-s-c=
ertificate-of-origin-1-1
> > > it's required where the affiliation/identity of the author has
> > > changed; it's as if another developer picked up the series and
> > > continues improving it.
> >
> > Since the original address does not exist, the Originally-by: or free
> > text in the commit message / cover letter should be enough.
>
> The original copyright still applies, and the SOB captures that.

The problem is that you put a non-existing person there. Make sure
emails are not bouncing and I will not object (however, I just saw
Greg's reply).

--=20
With Best Regards,
Andy Shevchenko
