Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44572A937;
	Thu, 17 Apr 2025 07:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744875915; cv=none; b=m1Z9nXKl3i9AYYwgiidjHkWrBy+EJosCAVfcnRYqnCdfGSHH/ygdadfJlU1x11jY/LcIwjQCJ2XmsLwegw6/yQAGC35LKdFJzqWwGf6kYLrzsJVChgctgXBUaIvImHVtbJZFVzujG7GTMfIf0EVmvE0NIu+9imewwTZSjUcxHUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744875915; c=relaxed/simple;
	bh=Vkng84A1VO7UZA2qLJswMZFcaLIzTAdafSby743weXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=khlFELxhPSvq7EFBtcXDlPQqF3yVriAv32w3V86UMKsk/muUZ3OUXP0BQkHsGL92QOal9kY2EgcJmMdKe5FfVXFX1pLxO31Udo8FWSga3pCbxC7AE9Q/lR0L7kvUSYFEIeZI6gP0vzgrW8PrhHCyv61Ikaia3d6rO2ESITAU8Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XXditUeo; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XXditUeo"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e589c258663so460522276.1;
        Thu, 17 Apr 2025 00:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744875913; x=1745480713; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mcssgBbbVj+a/uBXXE9RC1cUGNGu+ygdY+cVqccmccM=;
        b=XXditUeoyk7dipu+sb8he/ySrTaDQAj8ujg8Uy+FNJ8dWc/sUWE4lAtrVOVIL6pbaN
         aDxXShdQzQtr8cY6SxRzB5FOa34QYmQSu6j76XW6eVlHNhe0iFgzMKpvyAmELFsUFuxw
         RozhFq4lenJJctcSi8tix/60dHhbdGtMOx59/Vcg2KsY7tlbBuhsomba/UYQ3EYdyI6t
         VUP80EjJ/tRRAjbxq/q8UOdn2QBA0N7DQgJEf6wlSDctK7V+ogp9NuB3awmIjpvq6jKE
         MJ+zCr8VqUwtWaK6V1dWUmpvEwliSiejVmB58kICpBJCTYgag7DSkmiY2vB2yrcxNIMY
         fAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744875913; x=1745480713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mcssgBbbVj+a/uBXXE9RC1cUGNGu+ygdY+cVqccmccM=;
        b=IvpAkgj0oWwgEkD72qIBIccxWCR8DIb0xQby3A52OzAcfvWF3cz8fUKtdkWyPLgMLq
         IxUrUN5MJzDyPyWecrcn4sx/jNTCxhsRm6H2QrBnCQtvuomozXSFSME+z+XH/i9wLiIM
         gMinzJjTGkT+SxW++rYzQswvpoGwHJFzGo+KzQC7tVboNA2Jyq+XQUqGk8S77RezZ3iR
         oeYlrJWPBR5Zqd3xTOISjvN39WdHQDkCRZzMb6IN08x9DgFtJCpwA2SgDfCLvKk6b2+u
         s+DmP871FJ0YaQp2eLukkLGqVjMzxhFc1AM1bKFx+VBgGWtnQ/FP6IU9kNgQbtEoBhCy
         OWjg==
X-Forwarded-Encrypted: i=1; AJvYcCU7dmY3XE0jQu0+1AwNbv3LTY9zIhFPfoTYivKPY4LlBig3SrlZusj8kFeV9yltwY+ej0I2+N9ZKF7Teng=@vger.kernel.org, AJvYcCUw00xAWDJ/8+JCVPC/HM9/iU5ysGoz7Bzo4ieq1OIpLe1AKYlom8g7Ly4P2fImg7WXBvyhx/LFamWORdTe@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2RHTE6GFtQYxvTDzkNarrFVqO3RuzraUeEPpH0dZzyrG9Yam4
	/VL0j2ndeMwIr7e76ERzTNmtBxwOvvz4oX7H2r/wDF/RYGU3hcRJnlCCBHTFs+0iTA4wKAw6xtY
	zXEuaX9rtieMUgXbsKM/8TXor1E8=
X-Gm-Gg: ASbGncsfb28jiQWi0prw+fb0S5IVRN03jNCbhAV1VldK+O+G2l2rFk7eMCjkGqcOCoz
	Fp9xS07wL3+BEbITHkQRxLeQdwom84AO1tEx++OmK945H69dLYLV9JvKmT7DGO4wPhdRXRnIbQc
	9CQnslKoMz6Xk7INEFE+9i4mJAc7k82WJQg1lPCA==
X-Google-Smtp-Source: AGHT+IGAR6lg2fMrbxA05CvZYcwcoxr2wuX/4XKhCG2jkWZV60uluWoRnjmCRD/x3C4szfiM33Qvp74JQs4FBRcBiiE=
X-Received: by 2002:a05:6902:10c4:b0:e6e:b3d:6f87 with SMTP id
 3f1490d57ef6-e7275f2995bmr6717565276.40.1744875913212; Thu, 17 Apr 2025
 00:45:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417064940.68469-1-dqfext@gmail.com> <CAMj1kXFPAVXOtPoETKvHB49kjZUPYrsAqsJwdL7p5Cu4xk75Rg@mail.gmail.com>
 <CALW65jY=LnVBYoKPOQnSKgGSA0brKzmo0vqoRDcqF_=jofLAng@mail.gmail.com> <CAH8yC8=9u42jK0-FrHOXvWDM-Z3jUKSSSFznTMVWUiPAgCFcTA@mail.gmail.com>
In-Reply-To: <CAH8yC8=9u42jK0-FrHOXvWDM-Z3jUKSSSFznTMVWUiPAgCFcTA@mail.gmail.com>
From: Qingfang Deng <dqfext@gmail.com>
Date: Thu, 17 Apr 2025 15:45:03 +0800
X-Gm-Features: ATxdqUH8LtN62wtWOBNCijYJvfLyDx2fGZykb1xFl1cR53g-9tp1DwUwsjdUDSI
Message-ID: <CALW65jZvieqvHei31Ufikz4SVEGvDZwGyLGf=9Myqw1hS9m-sg@mail.gmail.com>
Subject: Re: [RFC PATCH] crypto: riscv: scalar accelerated GHASH
To: noloader@gmail.com
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, linux-crypto@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>, 
	Qingfang Deng <qingfang.deng@siflower.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jeffrey,

On Thu, Apr 17, 2025 at 3:40=E2=80=AFPM Jeffrey Walton <noloader@gmail.com>=
 wrote:
>
> On Thu, Apr 17, 2025 at 3:25=E2=80=AFAM Qingfang Deng <dqfext@gmail.com> =
wrote:
> >
> > Hi Ard,
> >
> > On Thu, Apr 17, 2025 at 2:58=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org=
> wrote:
> > > [...]
> > >
> > > Also, do you need to test for int128 support? Or is that guaranteed
> > > for all compilers that are supported by the RISC-V port?
> >
> > I believe int128 support is available for all 64-bit targets.
>
> You can verify the compiler supports int128 with the following macro:
>
>     #if (__SIZEOF_INT128__ >=3D 16)
>     ...
>     #endif
>
> Also see <https://gcc.gnu.org/pipermail/gcc-help/2015-August/124862.html>=
.

There is a Kconfig symbol ARCH_SUPPORTS_INT128. I may switch to that.

>
> Jeff
