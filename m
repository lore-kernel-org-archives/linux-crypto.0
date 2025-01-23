Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2532524B4
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jan 2025 04:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737605610; cv=none; b=rQflNu0ijVnYqMyquT6SuAl5y5cqFr+WEiQ0PQ2BtsSF9crH0hRgsrN85+ZzOgPyA4gteDPwbXhxdXv5Y2filFnPkZScLYAZkEO34bKUkv71cLsy4l9T3jawnKSsmA+AOqUFgUwJrfiPT1gTefUKVhKE5tTL2kOMH0LOPnKa8u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737605610; c=relaxed/simple;
	bh=fvbab/Y1DJ3skY4xfBKt1LzeYtt9aMVNnhuJiBXsunM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AfsKQDTPd47zOUPeBaPr4HnaZ6kusGk4Scz8Y2qrsuVZSUZn6g3x06Zusnz+ZmNbm53absJz3J983ul4c/9JQ+knoToDViGEoFYBxTd0hz3VYYfx4u/kixEJlQnpjJ/+BsnRZ66AecnVm2M1EPw1Jjpqr787D0rWrPUoAIxrfJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bDlt8H35; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bDlt8H35"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5dc0522475eso1076614a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jan 2025 20:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737605607; x=1738210407; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MMZLEyc7j2uvIpYffrxgkN/vxC8rXCn0s3pN39aZqxM=;
        b=bDlt8H359KPbLuMBL6bCchiJ0POUrZorQCESXof1YilSKVMBFDddkbj3157+tGBfI8
         k1JJ1g9IlQ6Xkbc+d8XVfEBD/xgSfLYwRxKyAyWAMWMAV0v8Cgh25PSYj4JLE/VaHvxP
         wajg6poQuurL2v6tj0r6QGvHUlvun9gHbuv2k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737605607; x=1738210407;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MMZLEyc7j2uvIpYffrxgkN/vxC8rXCn0s3pN39aZqxM=;
        b=TmAvBK1yHC+o//wEj4w74JNuZfFBz/WHfkhMh63nh1uK3YBkcz9MuBDnKaypQNsNhF
         +XRsL+s32J50iybj4VxhDrFr0chCZ5YZbRdN0ar1toHULONirU9zdIalBs4h9FlZgGrC
         HoXzG4FAIxDy19RL/VyqE93v5XGGGfp/m5N9TQHdzlGs7v++KhUV44p2RdWy3nxH49qN
         mZwIe7oy43ph/GhWAWkcdhA17WCLtC/4Xu3PFm7seMtuEAovZdPtWhuXcM/eqd7ReMtX
         mTN8TzDr331fcldrfOxw0OIEKnBzSJ2Cd6KRUYULQIAHacU4G2q2jgVG4AX8//cOPmb8
         wYOQ==
X-Gm-Message-State: AOJu0YydaVqdmI3HHBro/u6vO8yOJUmt8V5XbdpDYhF3nZ41cteOZ9x8
	rw9iDDhx4gCWAgk5l7fHItsrSOinRxSIeNQdMvkmfO5K8ebp19MWLEONuCEOItPda7EHDyR29QR
	qeuI=
X-Gm-Gg: ASbGncv3w2POrsCRVkiVWoIhzndtP0OMdXUxZ2+0it4ATvluoYKzJhM2cBf9SWXL1K0
	CQ5a+LOicSkvdGo79kt2pbsJYTYh1xxMGDBnZcGuMgeBwz1cziIQ1AOTZgk773l68Ay4mru+e5Z
	isBjsfv9DwlOqc3Eps+aG7KJ5FFJkLGsdHgH6hRxApQC3hTbyWFp3B+6I64sxDvEIeJInAYPAAd
	Fx62IE9owJh050hz34AHcqDB14aPAsCQmJ0qoKLL2tw340xSf/Uq46QSnbzvxJs3D3sR5lIY/gI
	nfXWkQEZ6UaKwi7E78MaabiTBT0XH2f6Ruom4vaIj/r2d0eVEhrDOpY=
X-Google-Smtp-Source: AGHT+IFRjvJB7gJCXzEMDUkJ8LEakNojQhng3S3qiWFgZl6k9qf6jNpaYL/9+rJczwyexm0OHgrxQg==
X-Received: by 2002:a05:6402:2548:b0:5d3:e79b:3b4c with SMTP id 4fb4d7f45d1cf-5db7db2bfebmr23300434a12.31.1737605606841;
        Wed, 22 Jan 2025 20:13:26 -0800 (PST)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5db73683d47sm9443261a12.41.2025.01.22.20.13.24
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 20:13:25 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d7e3f1fdafso1028308a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jan 2025 20:13:24 -0800 (PST)
X-Received: by 2002:a17:907:3606:b0:ab3:60eb:f858 with SMTP id
 a640c23a62f3a-ab38b381338mr2171668566b.38.1737605603693; Wed, 22 Jan 2025
 20:13:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250119225118.GA15398@sol.localdomain>
In-Reply-To: <20250119225118.GA15398@sol.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Jan 2025 20:13:07 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
X-Gm-Features: AbW1kvbJ6t8qRO171U9Mn2c13gQ1bhzM2obm6NFs4HuRiGtttfJch6ripRpSkLs
Message-ID: <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Theodore Ts'o" <tytso@mit.edu>, Vinicius Peixoto <vpeixoto@lkcamp.dev>, WangYuli <wangyuli@uniontech.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, 19 Jan 2025 at 14:51, Eric Biggers <ebiggers@kernel.org> wrote:
>
> - Reorganize the architecture-optimized CRC32 and CRC-T10DIF code to be
>   directly accessible via the library API, instead of requiring the
>   crypto API.  This is much simpler and more efficient.

I'm not a fan of the crazy crypto interfaces for simple hashes that
only complicate and slow things down, so I'm all in favor of this and
have pulled it.

HOWEVER.

I'm also very much not a fan of asking users pointless questions.

What does this patch-set ask users idiotic questions like

  CRC-T10DIF implementation
  > 1. Architecture-optimized (CRC_T10DIF_IMPL_ARCH) (NEW)
    2. Generic implementation (CRC_T10DIF_IMPL_GENERIC) (NEW)

and

  CRC32 implementation
  > 1. Arch-optimized, with fallback to slice-by-8
(CRC32_IMPL_ARCH_PLUS_SLICEBY8) (NEW)
    2. Arch-optimized, with fallback to slice-by-1
(CRC32_IMPL_ARCH_PLUS_SLICEBY1) (NEW)
    3. Slice by 8 bytes (CRC32_IMPL_SLICEBY8) (NEW)
    4. Slice by 4 bytes (CRC32_IMPL_SLICEBY4) (NEW)
    5. Slice by 1 byte (Sarwate's algorithm) (CRC32_IMPL_SLICEBY1) (NEW)
    6. Classic Algorithm (one bit at a time) (CRC32_IMPL_BIT) (NEW)

because *nobody* wants to see that completely pointless noise.

Pick the best one. Don't ask the user to pick the best one.

If you have some really strong argument for why users need to be able
to override the sane choice, make the question it at *least* depend on
EXPERT.

And honestly, I don't see how there could possibly ever be any point.
If there is an arch-optimized version, just use it.

And if the "optimized" version is crap and worse than some generic
one, it just needs to be removed.

None of this "make the user make the choice because kernel developers
can't deal with the responsibility of just saying what is best".

             Linus
