Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA77270EC2
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 20:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740689877; cv=none; b=LJMhVLlAStiyQyE7xt3iQWUbGKuPnfwyGAFVfDnnbqnEGZ/M8cdyOnCxgCAAJLyk5xd9KpUM71ErS4V2K/6bVRPvu/kIMRGMjYQJGvJ4VPUKSbueRU2D58dTAyVm9Y2PlS3Qgscy+rq5pA8GelNaASZV6Eamq+TPNajER4FYrvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740689877; c=relaxed/simple;
	bh=gluXi5xULvfSCmFO6bHH+tGO6TqITSnpduH9eMYOsUM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CsYCfIIO4odwstsoDqnNuBgHuKQyu0x8hPTFU41zYN/t2Rio2I0kyUJQh2a/m7aa6IxkJXkJp9DoSFHUYZUrDnvVfMOJgz+fxxl8hfq4u7epFHO5gNalruuXX978ls+XnI5/0VLAmAecSIXjOS97qM9liIagnqmI20gqZ1U6zro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yk4QDm37; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yk4QDm37"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-abbec6a0bfeso216446766b.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 12:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740689873; x=1741294673; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJveyoIEMTCh14ljLF9QNtY0D/cKkIOCAKuSFjWQyQU=;
        b=Yk4QDm37IoKFV9tJBXLxGIS45Lg0tjq1WB9guLI02AVdR+uU5xWLCz7eZwJ/CR0AIT
         1DBdJi1vijinLVhRSFCjNjMDtJNXAg/UB4/I7LOwEmNmaWB6ANsGGc2YAjTH9CxL0aih
         bkMxJ4Kh3nnYqvJPVByTJy1ysSi562c2hzlwISLhRLxst45GVfodZmGjqwDz1vaM1bhL
         baykfu8kK1S6ucg8/6v2IwBgJMtOnwXilrhbOUJTrKaeFWjkXFm6r8EO7/GAmbwnRzAZ
         vIr5kEQYRwOhTpYEkoM9HMjW9rFSdLmsgkrFECdR4SxmnGxrBSycQvAkZTXM5svLGBDp
         DXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740689874; x=1741294674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VJveyoIEMTCh14ljLF9QNtY0D/cKkIOCAKuSFjWQyQU=;
        b=KhYksb/osHA/FgqG2PRs9EXUvmFXURv77bBG5pHX5UILZJoigCHE+x9IKXmZPHA1xP
         GfUGVD+4w9yoB8L56Mbv5e33NMXvUlFMKocR7Zl7HTDMMAtcbewRUBXSoUTrGCR5DUl9
         jEbgLxqPXNqkxV67XlbHt63ysBl3mcwqXRWEjiXHQLbRz+GUFx1dJwEdDBt4C38AdU+b
         O2127hQJl5l+ccyM5hCTNkxNOOTD6Bdq+yIhn2meYhJGW+lNV2DvliV7Pa0ffpTnEsJt
         K+vCNpy51i6ULRjtxCIYlLGcJklcp5x7LAK3zWMi1rA2iUVTubG/m4dnJ7h/A6nXCbEI
         QIoQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6GGBj6cEuD2XhxEPZyAXR+awC801N5NIQ9rhvU835fFDtsD/k5bLWQtkctm3hGqoBVZjMzH3ZkJN4UMM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxivRgMeCdMQGDsBuoLV9R7AjzzNUDjV6itwRtGa52xbQOuGJcB
	r4XLbAPUhDQjXRlKxs5OhuqTWiJSjuiffnbMMN/UFSQzzzSL6njWWkx/23auZN+AKKgC9c6J3M2
	qTMtF8djPywOiAKXHNoNIf+zTdDtEFKmdldw=
X-Gm-Gg: ASbGncsGykxD9SxZNAt/Cc3CXz031/bH2nNpQvpwHPR5Blp69/IjUbKuF230CRKVO7j
	UtVYCoRpxffMMJ+iK3TYVhZrqau1X9IuRrbPG1G1+MS7Fn/MEfNthS+xSQoWvyF/Zjp5kOIBZAS
	jYxwto
X-Google-Smtp-Source: AGHT+IE9iCZk4QUBD23F1Zo14MgZCt7ts5AldRQifiXQN5G9EbVneoxaBJ6AVE8QPXPRd/nmSnWTsNZQXx3ANeOOKU0=
X-Received: by 2002:a17:906:6a13:b0:abe:c849:7aa7 with SMTP id
 a640c23a62f3a-abf265cee71mr95608566b.41.1740689873533; Thu, 27 Feb 2025
 12:57:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com>
 <d20da175-2102-4ac0-bf91-0ab8f6b6b317@intel.com>
In-Reply-To: <d20da175-2102-4ac0-bf91-0ab8f6b6b317@intel.com>
From: Bill Wendling <morbo@google.com>
Date: Thu, 27 Feb 2025 12:57:37 -0800
X-Gm-Features: AQ5f1JrXKNJ9dmAYpGPhTl0lhC69TTiwaOh5i19eVrAfWoRfJbsOGd1OSppC628
Message-ID: <CAGG=3QX-msHuRffAtNCBoqYo=15Z--5RXbPbJ=Tzkb+C9zNSaw@mail.gmail.com>
Subject: Re: [PATCH] x86/crc32: use builtins to improve code generation
To: Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Eric Biggers <ebiggers@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Justin Stitt <justinstitt@google.com>, 
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, 
	clang-built-linux <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2025 at 8:26=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
> On 2/26/25 22:12, Bill Wendling wrote:
> >  #ifdef CONFIG_X86_64
> > -#define CRC32_INST "crc32q %1, %q0"
> > +#define CRC32_INST __builtin_ia32_crc32di
> >  #else
> > -#define CRC32_INST "crc32l %1, %0"
> > +#define CRC32_INST __builtin_ia32_crc32si
> >  #endif
> >
> >  /*
> > @@ -78,10 +78,10 @@ u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len=
)
> >
> >         for (num_longs =3D len / sizeof(unsigned long);
> >              num_longs !=3D 0; num_longs--, p +=3D sizeof(unsigned long=
))
> > -               asm(CRC32_INST : "+r" (crc) : "rm" (*(unsigned long *)p=
));
> > +               crc =3D CRC32_INST(crc,  *(unsigned long *)p);
>
> Could we get rid of the macros, please?
>
> unsigned long crc32_ul(unsigned long crc, unsigned long data)
> {
>         if (IS_DEFINED(CONFIG_X86_64))
>                 return __builtin_ia32_crc32di(crc, data)
>         else
>                 return __builtin_ia32_crc32si(crc, data)
> }
>
> I guess it could also do some check like:
>
>         if (sizeof(int) =3D=3D sizeof(long))
>
> instead of CONFIG_X86_64, but the CONFIG_X86_64 will make it more
> obvious when someone comes through to rip out 32-bit support some day.

I vastly prefer the first way if made "static __always_inline".

-bw
