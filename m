Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD9E2063F3;
	Wed,  5 Mar 2025 10:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741169450; cv=none; b=F4KjqKgznYnqCmS/XXIo6jm/3heVXZmBzoNLLVJP22B/BxY3pPxIgHnIOQb2KwKQv9vWSAg8vzTNPShIOnwTw+TcS1agG6AusiraWqWN89WTbaSG5ipUZ1XXOlNvUG0Bnmz2lmzrGdCZwGXdHP9MqvqElDZ5Tmt+oEcyTKJoyg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741169450; c=relaxed/simple;
	bh=llg0domLWIKPFm2rb3BZir48nLFe6AvnxeCjrY+USvs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WgfTCvd3ohTdnRw3ply+zcygiVo/sbPy2Nt9my2VhgQ4BDe37fCeSgbEnxw1MTU7tJBhtQ6NfmSa7f0NNK0Lybib1gYn9nWc5+SCq6vHLeqsfQQ98dG/Yg2NJ2BDbYjJf9JFmqep/xyo9NwbJxSvkyyFSrHR9YvlL4EgWYRzB7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f4u7LmwU; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f4u7LmwU"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-30bbc83fc35so6757531fa.0;
        Wed, 05 Mar 2025 02:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741169447; x=1741774247; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k6sJPgBFhipyGWeJK1GttBGiwRcJZd7KKopxjGpBJHY=;
        b=f4u7LmwU/e69q6neZRFGqAyNqJhKpq8wp06EQvGmwUYZsWYuEX7DJ3jM1mE+1ytnPV
         ZiwbEeBRBQ+NKCKpOljw4GAASN+8S5eHuBC5TGEJ66OAYfZDw6mvEW4OPPmAgFRW8PEZ
         4McbFB1ILKOm6XHQVbMyaP0TTHVX7n5TV0CNqICmJ4qxpkDeIwL3EHC2RPNMLWg3F7cP
         ycZraJ76E36uzJadaWbsonrbCd0p/edEkrK7z1FGTaHrgrdGZ8JYr0ZIn5EbLdvmWUdL
         zxIAaqYTvxrT9is2X+u7WDCwmtHr2raigr6dvi9o9K2QtOQ9FhstPKnIESDGsxE92/dh
         E21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741169447; x=1741774247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k6sJPgBFhipyGWeJK1GttBGiwRcJZd7KKopxjGpBJHY=;
        b=rrEsPmYL2oVg8A2dro212P89Q6puaXtuVsH36CewgdOL098AgIAaFmSAgkY1SLX7FG
         VvigqaUfGY0ZhkyioqqGgd47nT6Hxt5vx2Nj5Xxkpo8jRpnY7hl5wCv3A22LO3IEIE1O
         ZB7hLA7deSmlhueqicr5t6k7YOcRoEvVBKnwm97kh7h86gAXU+LrlhZxjvWR2vvKIJMn
         aYqGFS4Vy9lYEGsPmQaxb/77C9JuD1/pIQaAiy9Bop+jESyr0b/ZUNFDmT/Dnvbp7bE7
         lSXAL9W7XdG9bJUujVKaPXWas22mCvsK+BY09h59rYbkTmLmKv2X/I1bPWmcRPJAdOXb
         abkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQvkuLtu63PKpI4HrOIz7N48yxMfHnEV4ih1tQqbqpeUZCIigX30rRmwHtNQqrNmOdmPJrC4JUAuhciRk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5iIroRRsnMk3ltiAcjk2c7PtGvdtodmWfKS+dn1fx4OVG/vcD
	1h4uc2Fy9YGsK4nsf+qXvxonvDur+DPIPWVnFQZztoqbgDY21lJb61Rz3RwqvzpXEel65DP7n07
	MfWw4lIBoCfT6vvQ3Bsd9kBLT6BQ=
X-Gm-Gg: ASbGncvZbdmums+J60g7Xj6ifApgdaXMUE7hYaPf+yfMz/ERRQok115xYKobfZAxtDm
	4F4M6Jq0AekWCISId2G2KRul9JPBw0nzp79TZ3fk81n396cEhqYwPLZH9jBmfh5dyHVRmhCUQBf
	OosJp97c1eo6pWqQKtalorXG4iVA==
X-Google-Smtp-Source: AGHT+IEURqWpoFonECBt8ISCyOLd+8RPbOZV7uLgtcPcEzt6+VvkWezBr6q5FXj/MkUUIbpTM4yfNKzX8SLCGwJcBkA=
X-Received: by 2002:a05:651c:2207:b0:30b:c3ce:ea51 with SMTP id
 38308e7fff4ca-30bd7cd5c0cmr6897361fa.15.1741169446164; Wed, 05 Mar 2025
 02:10:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250304213216.108925-1-ebiggers@kernel.org>
In-Reply-To: <20250304213216.108925-1-ebiggers@kernel.org>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Wed, 5 Mar 2025 11:10:40 +0100
X-Gm-Features: AQ5f1JoL3EYBkezeivq6kAevMSsSR0Ei1buWNTADmjgUBeYw4D_is9BtgZdT5AU
Message-ID: <CAFULd4Y8=zov8Yov3n4rhwT7JO0YxaEQJ56hq1Hd7TB=yQjWQw@mail.gmail.com>
Subject: Re: [PATCH] x86/crc32: optimize tail handling for crc32c short inputs
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, Bill Wendling <morbo@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Justin Stitt <justinstitt@google.com>, 
	David Laight <david.laight.linux@gmail.com>, linux-crypto@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 5, 2025 at 10:26=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> For handling the 0 <=3D len < sizeof(unsigned long) bytes left at the end=
,
> do a 4-2-1 step-down instead of a byte-at-a-time loop.  This allows
> taking advantage of wider CRC instructions.  Note that crc32c-3way.S
> already uses this same optimization too.
>
> crc_kunit shows an improvement of about 25% for len=3D127.
>
> Suggested-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

LGTM.

Acked-by: Uros Bizjak <ubizjak@gmail.com>

Thanks,
Uros.

> ---
>
> This applies to
> https://web.git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/lo=
g/?h=3Dcrc-next
>
>  arch/x86/lib/crc32-glue.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/lib/crc32-glue.c b/arch/x86/lib/crc32-glue.c
> index 4b4721176799a..e3f93b17ac3f1 100644
> --- a/arch/x86/lib/crc32-glue.c
> +++ b/arch/x86/lib/crc32-glue.c
> @@ -55,11 +55,19 @@ u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
>
>         for (num_longs =3D len / sizeof(unsigned long);
>              num_longs !=3D 0; num_longs--, p +=3D sizeof(unsigned long))
>                 asm(CRC32_INST : "+r" (crc) : ASM_INPUT_RM (*(unsigned lo=
ng *)p));
>
> -       for (len %=3D sizeof(unsigned long); len; len--, p++)
> +       if (sizeof(unsigned long) > 4 && (len & 4)) {
> +               asm("crc32l %1, %0" : "+r" (crc) : ASM_INPUT_RM (*(u32 *)=
p));
> +               p +=3D 4;
> +       }
> +       if (len & 2) {
> +               asm("crc32w %1, %0" : "+r" (crc) : ASM_INPUT_RM (*(u16 *)=
p));
> +               p +=3D 2;
> +       }
> +       if (len & 1)
>                 asm("crc32b %1, %0" : "+r" (crc) : ASM_INPUT_RM (*p));
>
>         return crc;
>  }
>  EXPORT_SYMBOL(crc32c_arch);
>
> base-commit: 13f3d13d88b5dcba104a204fcbee61c75f8407d0
> --
> 2.48.1
>
