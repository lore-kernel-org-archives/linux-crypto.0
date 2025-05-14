Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE03140E34
	for <linux-crypto@vger.kernel.org>; Wed, 14 May 2025 21:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747259885; cv=none; b=iXDgPGFAEiOUcT2NzxaEiE/Mu5s4/hLp6iNqVR3C57pF66f+owFwerCgqQ3mOR4vO1eijwFw8lcNIpoa6C56QsoMDDq653FehrNN1RdSSy7clxGHkJTBIcMwVuEd7GHvv9RsFKXXLYNmyF/Yvek6rF4/FD0qutPQFREPF3TbDk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747259885; c=relaxed/simple;
	bh=Y0k6zt80v/NzClDM2+/2DtplJHKsCdpnYYoaTVipjNQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BrAQ+54RaBNYUhBUUedD7GCBtFrVf5Nyyc7b8wzN8LMYmNqiZQiQYIdnuP1VuR9XwR4vO9ovuAU2E2wQtNGbo1YomHnzgxPTyt1d9JvBzJwQL7xueSpe/3YNhvbMfPwMWXcnIVrMLdOf+6/kzPtapTxjBc9DDSYPXESyo0FIIns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=AEKEmHW/; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="AEKEmHW/"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e7b391ba6a1so316366276.2
        for <linux-crypto@vger.kernel.org>; Wed, 14 May 2025 14:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1747259882; x=1747864682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cd3hwDzjEL8BVjWNpHIodN9KpUcVouQgmKQ6Ucvmu/M=;
        b=AEKEmHW/hvVLg8mQhMbspM92G5vZsiXE2KKqSDJYtAaspXQjrZS5ookhCyd+BNxw0i
         81kB/zOp9jd+l1nyeYTAJWcm7Tdywu7S75Z87Ude0CYOYjBh4++0nr7mMoVzvPDiiuWe
         jlV+3f901xMQqMOwnD7+KYrGNxU7+BL/Ysq0SkaMWArSp2shAYjs5tvinsasfZY57AL6
         ZvM2jtvD4dD5dcEVYYpfzii5xw1ykjuYlyRVmlmsqbimg/UWpwp/0HRTpnvW4qFV8/hi
         xStttFqJZfHfAyM5jonl4PlRRiQ/dGPPDT091ocHdj7j97/WWcokhZgMuTN4USrm2WiJ
         TiJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747259882; x=1747864682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cd3hwDzjEL8BVjWNpHIodN9KpUcVouQgmKQ6Ucvmu/M=;
        b=vBMXsPaOP5TGkw+jR2CBlR3i6PxcPJR4mFnuoak+pMfAQm4UU7m2u+rxHkxRX1qVa1
         p0UcW/2jdScMQNWt8cWflNjDXO8Yg3bB+2vx74nHF8ARK9vZE6NfvYDyCz+JodOEtZIZ
         uILryfJa/xGRK0AnH+FI9uqwUdXYDGx+WewELOB2eNc/3zI3WWiJkE8evo6K1MpZPuN9
         53gbmEcEBhOVGCrkJmS+F439SxIlB4VcLVk27Jqn/Z5bexoAnmpY5dlszToZJotnBZsd
         uCJTxupZiJjKBHc5PuErFvL4RcBEzRvSpFgvbJBdBmVLVAGaRw7N0I1cBNiQ9mfInsW/
         prig==
X-Forwarded-Encrypted: i=1; AJvYcCUrguQ8rBp4G4gyc3HjFJ67/X9ykSsjnu2aKbFUzhLntmJ5NNF+8Z/lFDSlm/1iHJthzDrAU8Oz3RLAxPQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8q6wBRSEj61xbr6fQJ86/fX3syrE/sMIHx0a1mj5EFAN8NVPN
	Q3gVVumT25MebT2kQCz2m6onOLi+zHo2j8W+qOLHr76nSXNlgMgac9wO0YbZN3SkgLfoXnabNG+
	7k7upVCEwCRZzWPJuw7ifwe1mDU9wXYEPtxsx
X-Gm-Gg: ASbGncuX5Ouw4Z7bdsruVz7kbLdtNnRXLunHTPnBzWUmZyHIE0ABoXk2hZOSHz48uvd
	koBFUDEUEAZHVZlN5xLJYSyRxYQanVXPO65WjFHto2ANnfiH0Ag0EmLWOqtyvtiYM5GMx1kXKPk
	UH/8TJZeFZPgVATk7Bv3y6oYUlkiHcHVyqouWLNfvCssE=
X-Google-Smtp-Source: AGHT+IHAu8/NGifUGGvqy1muRemXjrNd0svPOPeQFyYnJTSpuDaE7BUNisyhGtBUb1e5c878a+beHwpBV6XXMuiK0sc=
X-Received: by 2002:a05:6902:114e:b0:e76:8058:a065 with SMTP id
 3f1490d57ef6-e7b3d4ba991mr6148542276.6.1747259882613; Wed, 14 May 2025
 14:58:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428190430.850240-1-ebiggers@kernel.org> <20250514042147.GA2073@sol>
In-Reply-To: <20250514042147.GA2073@sol>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 14 May 2025 17:57:52 -0400
X-Gm-Features: AX0GCFu-8Aa284A3Wv4qgq0Bn3X2NviBEUYoaX5YYoj-p-8WsCK_D4vIgnJJLjo
Message-ID: <CAHC9VhRL=Jsx8B1s-3qmVOXuRuRF2hTOi3uEnRiWra+7oQJvrg@mail.gmail.com>
Subject: Re: [PATCH] apparmor: use SHA-256 library API instead of crypto_shash API
To: Eric Biggers <ebiggers@kernel.org>
Cc: John Johansen <john.johansen@canonical.com>, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2025 at 12:22=E2=80=AFAM Eric Biggers <ebiggers@kernel.org>=
 wrote:
> On Mon, Apr 28, 2025 at 12:04:30PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > This user of SHA-256 does not support any other algorithm, so the
> > crypto_shash abstraction provides no value.  Just use the SHA-256
> > library API instead, which is much simpler and easier to use.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >
> > This patch is targeting the apparmor tree for 6.16.
> >
> >  security/apparmor/Kconfig  |  3 +-
> >  security/apparmor/crypto.c | 85 ++++++--------------------------------
> >  2 files changed, 13 insertions(+), 75 deletions(-)
>
> Any interest in taking this patch through the apparmor or security trees?

Something like this would need to go through the AppArmor tree.  As a
FYI, the AppArmor devs are fairly busy at the moment so it may take a
bit for them to get around to this.

--=20
paul-moore.com
