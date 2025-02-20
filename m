Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60C7212B17
	for <linux-crypto@vger.kernel.org>; Thu, 20 Feb 2025 16:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740070065; cv=none; b=mVkHR1kJ9NI5Difbb15P3Q6dSjxaE0amW0a1oFdSv51ydVsfywBx3sAnJEp9I24vKuv+pkmVQQ8TIkz3Mt70cgt3zvXEP3xx3YvtLH+CP68V+aOfSuBvz9dUc+W6Lu9BGp+pNNREHbFmlrHB0jXEvtJYcWj+hD1SoNG2sPRChu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740070065; c=relaxed/simple;
	bh=07JJww02mJEeGAIuugM++K4ebk2f0Zd1D+gq+CAzgrw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oB1P08F2QqnFgrotbt9Jiv9mSFz7VlOYrQFGh9G+F5/ZAl830bZ4hJ1HLjo7mqrej/VL8O0r22vRTOzMO5cg4c0T0leJ7ZhRbhDvjl0w5CAQtkYnZ0VGXIVBlwM1r209pmCgi13QOjpIiKzMTTD7VSUs0RFpMdkHi0rKbWYQguk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NtgqodyM; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NtgqodyM"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-abb79af88afso230591266b.1
        for <linux-crypto@vger.kernel.org>; Thu, 20 Feb 2025 08:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740070061; x=1740674861; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XMCL0K+C4GnoACxiUHOKxAWwwUOoQfv8+sE0BWNTm14=;
        b=NtgqodyMEgtiiI68uGzkHKoibqil6IMmY3XQ5cackqnjOxGewdVR2v6F/l/Rd7tI42
         J59sGfa6dM/Lefk3WbzLChH7Hex6MxgwKeZpaVesuMKmN48dT9wS3UI4l86F3R9Y/hlU
         Zuzo5P57FRHQEptWwP+I3Sp42ZU9rpcVz1ceXbIS1de+3ZVeYxmNJDQNGglsgozNz2jK
         JWyyb2Ma6F73s/y135qNmlp9ci+j0B2HgNuLkaZPaQCM7GmRICMDcWGmJ5v+p9Aram0X
         J9YxNpc3pefG/CBXAqam+t6YgXFk5LOAyCKwd9GIi/ZaB1efANDIO1puy1LXDYZUvoU0
         yDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740070061; x=1740674861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XMCL0K+C4GnoACxiUHOKxAWwwUOoQfv8+sE0BWNTm14=;
        b=JFa02mjpA7SKORfZsAT4MWPmLqHbUPMDY/Q9sPfb/b7wTgCZ3qehJ1dvwobYxDQtgi
         Py/Epe7eUQoMuy866kOWlkk+A0g7GDjG3Qvh6oSKFojBYmh5Y+f9KjuUBtqhnL0fzWDY
         oFbxyiIWoB3xr3Ysg4ymntoNnGrzb4WGeXmq/YXIoszz/EMfk1EQqlrIT9Z4PP9g8DGo
         l2ywDokOTuFgn5PEtnZUEhp3+Wruye9gNVxP6RjH62IZfCgPiIma/Sz8aJOCnfvADnlh
         uZck/liPN3diPlqIcWRNqH/2q+dx28UEFXXSpF2hpfotnSculNIe7SRqy2w0jiK1Itaq
         9ywg==
X-Forwarded-Encrypted: i=1; AJvYcCU1oLzqKrSjmbzfdEg0nLH/xL/WadKdOEmMQpuu9PKDu5DAnKvlK/xEq+ICgKknXFW3eN1qHzFdZmKmmNw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRkRFx7+ZD4xfbjWonz3RO2pORTDFkhQRe6mBBbipCDwfPQTrb
	mkDwcC0Cbe2IS9FYMRASJMkfGjESxDMGARKLg+A1OLX7tp4Dnt2bE4Ln/NJL59xtwbWRUDdZhuo
	jskymQ8CwI/RPn614N07q0JBR/y6BBM6tc1bg
X-Gm-Gg: ASbGncsEU12Vi7KUrLdHFH/2hGGKD8ODtJVOXTlaouaW9w1tRuPrGUaaTZ7Sc+OSVwq
	3cmaDolbJHIuHm0E8XDjekA8ucLylGoWtgpJMuknFuyDIJCHsIc9nKdNkOmxU5R7lPm+qtWyH
X-Google-Smtp-Source: AGHT+IFUN190VqKAbunKFBAi3FWBdH/R347wkO7ytCt3scT9na49h+zVGgXkcRMQmFGqWpBuREc1IPIa560YC5Jlbbg=
X-Received: by 2002:a17:907:7ea0:b0:ab7:d361:11b4 with SMTP id
 a640c23a62f3a-abc099b7f3fmr3875566b.7.1740070061123; Thu, 20 Feb 2025
 08:47:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1739997129.git.ashish.kalra@amd.com> <e13263246be91e4e0073b4c81d4d9e2fc41a6e1d.1739997129.git.ashish.kalra@amd.com>
In-Reply-To: <e13263246be91e4e0073b4c81d4d9e2fc41a6e1d.1739997129.git.ashish.kalra@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Thu, 20 Feb 2025 08:47:28 -0800
X-Gm-Features: AWEUYZlhHlxBHBWrZcmEspkPqwgF6rKQ9OpK2K5xOYbvc-va1cUZOfhJoJDPwGc
Message-ID: <CAAH4kHZsC68+QPC+y-pycM+HfsLF-f_AuW8eZm-Dqqf5meFj+w@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] crypto: ccp: Reset TMR size at SNP Shutdown
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, michael.roth@amd.com, nikunj@amd.com, 
	ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, 
	aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2025 at 12:53=E2=80=AFPM Ashish Kalra <Ashish.Kalra@amd.com=
> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB sized,
> ensure that TMR size is reset back to default when SNP is shutdown as
> SNP initialization and shutdown as part of some SNP ioctls may leave
> TMR size modified and cause subsequent SEV only initialization to fail.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Acked-by: Dionna Glaze <dionnaglaze@google.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index b06f43eb18f7..be8a84ce24c7 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1751,6 +1751,9 @@ static int __sev_snp_shutdown_locked(int *error, bo=
ol panic)
>         sev->snp_initialized =3D false;
>         dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>
> +       /* Reset TMR size back to default */
> +       sev_es_tmr_size =3D SEV_TMR_SIZE;
> +
>         return ret;
>  }
>
> --
> 2.34.1
>


--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)
