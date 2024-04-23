Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D01E576
	for <linux-crypto@vger.kernel.org>; Tue, 23 Apr 2024 11:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713870739; cv=none; b=fmOdGi2CE7cf8qxTaZcG8HRIKRh7OL8e1g17Uz5iNYjcQzf4DSJa/mcyJ2KHMSgatSHVB6TjMgra4TygiNL4N81TSXIwLHzfrzFfC67Vn96agtc8+H1yp2qESUL6Syi5AZCU/jl5vSGbOVkkiIU68nLPH0di03RgDKHgbywh6To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713870739; c=relaxed/simple;
	bh=kzjLAYwrFgVgyMPQ3WDVJlSsahRaZyHUh1KL7phHh7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hZwD7v47jw7vZVWftoUtpul1CzeKxc46UxmB+lZgSxbEmPQR0xXzmBy7dngByR2M982oV6AZnqoO/iBhO52SWaf/Jstq8UKd2AkSzGbvyBu2Wge728Kzddsa4wj0bLN/Nr5kTlv0kZKgJIQ+k02MQ7g60u1laamu2Ghv4bxZ4PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Cb0mcFO3; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Cb0mcFO3"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-61b6025c473so22628277b3.2
        for <linux-crypto@vger.kernel.org>; Tue, 23 Apr 2024 04:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1713870736; x=1714475536; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dFqjZC+981DkSxcZCXPB84S2G8dBo9db4D+EwMuc0OA=;
        b=Cb0mcFO38U+zhd80gQcmyaayarxOzIlttsg029PMmlPeig1qY/5JEJfLFm543O3fV1
         D35UqznncxV21x+qR1TLwxVpt5C2azFhR1zktaATnqUYagzbnZIYKwSxDuqfGDvGGNGF
         gX2dn/A+0O/xbjKZLBeEGdq5BTA+RbEjoaBho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713870736; x=1714475536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dFqjZC+981DkSxcZCXPB84S2G8dBo9db4D+EwMuc0OA=;
        b=ZumFg6ccMv2VqYo8bHUfiv05gonjCUFjh7drfKN9KskFUGDtyoA2qIa+iZrAnBKbCt
         FNkOobmfrbOXmPPTbUbF6s74heMo07zygnIdGWzdb91YGkRucRxyhWU37H9GrT/2JPEd
         rPEPCHaD+VUf4xHQ9C7iTVnZbduEVRgNJDsgQYJ3e30uGVfWxvjrlPFPmogp26IHWdYO
         ChoeOfHCpeq6LfKBRgN28xgMu3HAcZNM63IlNVyhBZKaXf27ftKHkVYP9fAlVjBWkYKC
         SH5nNfOmv5oWawUT5MEpIvoJGFxz3kFTpBO5I3589GDWvlVVyaUfahOPWqo9qLyIcK+P
         nHeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVl9qB3mS4uIYvoaDspU7jsAlqLyStzXU7ITmMdwzvUxzd+ODuKi5SjWGgcirW6tbrqltweFqgaFzzQmtzsY/P1pIeN+JUt3oCl48Uj
X-Gm-Message-State: AOJu0Yxaf4dI6hNN9uJKwKn8yAui1bgpGhEEzU+128mDXbRxlfWSp3bx
	oggMgAulqEUwy5fQCNxYpdmRNiinBCBZ9om6o2cFTVahrUgcnxOSqzbF1X2OTft3ugppB5K6cR5
	ei28Q9P6ZD+zzg1BIUsUMVcrdui45YlcHdz5mtQ==
X-Google-Smtp-Source: AGHT+IGB+v4SzR0r2Zrz1d2fCu7rR+lmddUKRc4MetYRPTooHdXaOBrM+IKvezKiniOs4G7L3ID6fdQyle3v0PKhpIg=
X-Received: by 2002:a05:690c:64c2:b0:61b:6757:a3df with SMTP id
 ht2-20020a05690c64c200b0061b6757a3dfmr6220432ywb.33.1713870736685; Tue, 23
 Apr 2024 04:12:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240412035342.1233930-1-pavitrakumarm@vayavyalabs.com>
 <20240412035342.1233930-2-pavitrakumarm@vayavyalabs.com> <51a5305d-04d2-4c6b-8ea3-0edc6e10c188@linux.microsoft.com>
 <CALxtO0=UT=KDY+WzZcdVj6nwPfcsmQVTCpmRGx65_SZvh91eqQ@mail.gmail.com> <5f3af250-da94-410f-858e-822b974b14bf@linux.microsoft.com>
In-Reply-To: <5f3af250-da94-410f-858e-822b974b14bf@linux.microsoft.com>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Tue, 23 Apr 2024 16:42:05 +0530
Message-ID: <CALxtO0moQmdki44w9j1B-41925YCQ3-1mrbbGcoOXroKMaVsYw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] Add SPAcc driver to Linux kernel
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com, 
	bhoomikak@vayavyalabs.com, shwetar <shwetar@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Easwar,
   We have broken the main driver patch into 4 patches as shown below

  LOC    PATCH
  4979 - 0001-Add-SPAcc-Skcipher-support.patch
  1470 - 0002-Enable-SPAcc-AUTODETECT.patch
  1283 - 0003-Add-SPAcc-ahash-support.patch
  1333 - 0004-Add-SPAcc-aead-support.patch

   138 - 0005-Add-SPAcc-Kconfig-and-Makefile.patch
    33  - 0006-Add-SPAcc-node-zynqmp-dts.patch
    60  - 0007-Enable-Driver-compilation-in-crypto-Kconfig-and-Make.patch

  I have NOT broken the first patch into a "core" and a "skcipher"
patch because the core patch
  will throw warnings for "Functions defined but not used" if applied
standalone during kernel CI/CD.
  No compilation errors, so nothing is going to break; but there will
be warnings.

  Core patch provides the infrastructure that cipher, hash and aead modules=
 use.
  I will check with the kernel CI/CD team regarding this but do let me
know if you have any
  details related to this.

  If thats not a problem for kernel CI/CD, i.e. if the kernel CI/CD is
run only after all patches
  are applied in order, then I can break up the first patch further
into two. So the core patch
  will mostly be around 4k Lines of Code.

  Do let me know.

Warm regards,
PK

On Thu, Apr 18, 2024 at 10:43=E2=80=AFPM Easwar Hariharan
<eahariha@linux.microsoft.com> wrote:
>
> On 4/17/2024 8:54 PM, Pavitrakumar Managutte wrote:
> > Hi Easwar,
> >    The driver has legacy code which was taking time in splitting, so
> > pushed the v2
> > patch without splitting. I am splitting AEAD, Hash and Cipher module co=
de, which
> > would be easier to review instead of a single 9k loc patch.
> >
> > I do appreciate your valuable time and feedback on the patches.
> >
> > Warm regards,
> > PK
> >
>
> Thanks, I'll wait for that v3 to continue review.
>
> - Easwar
>
