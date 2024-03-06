Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F00D502
	for <linux-crypto@vger.kernel.org>; Wed,  6 Mar 2024 05:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709701680; cv=none; b=lYr9yGJtcChJGBNIypzvtgCzvl573rgXqLL+LLMv5gieX0cBkKVpEWzdSPqsh8m2cBv2kqSa0lgE/4ZDZ27mxE+6gxh68ZDJXf67ZeVIlIkn3aCW1Q9M+isAY87jfB9+C0Xb5vX43ujintPp3lxlTh/0NG6UY3lgWpEZIU0dI18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709701680; c=relaxed/simple;
	bh=r+zT98/a7a5IjiIpyGSoFrn+MxiHDScpGovSNi8Pr9I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jv6JJ+e/jO8CLnwD6g427A6CfWzrRV7UHpBYZ8L/dapqTGvEi3aWwwKYrS3boLq2ME3osO7JONZe4AImsUtr7ouVlV3FAXdibFfq8tr73FEa++Gl0m0WBgY7lldtz8/OUMsMMzJ/j628wZ27GSwhtqFkxdxsgbum55pdqzyxWl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=LitM7iAY; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="LitM7iAY"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-608959cfcbfso16458337b3.3
        for <linux-crypto@vger.kernel.org>; Tue, 05 Mar 2024 21:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1709701677; x=1710306477; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6Nj4qFMhJMtmm6/A9xVgyvn0Lug35+w7j8NmN5QGwY=;
        b=LitM7iAYEWSoNrgYZQAKQ5pJP3IQGyKnkPcYc6/I8yIxC7pyiyCGTzRIUHVAehamim
         6XnM85k6wDGaEdK1twsJ/E8LQOw9TYu3joG7SmydvN9I9eTxhaFWxN2IWU11dzV8g4iT
         uSMvHsG85UvlORPxJpnWfu5he3lUhQQr5Qcls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709701677; x=1710306477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I6Nj4qFMhJMtmm6/A9xVgyvn0Lug35+w7j8NmN5QGwY=;
        b=Pm2+ftmtDmTOMRp8zDe0brVLRsaAfTT4VlC5sgEAXRLb7BqFT5dOCn3NJ2Dgc3akeZ
         0y1s8tN1rBCu7qLQmuAgkj6tEyKH3oiiO/kfY/3dlJcTFgmOiC5fZYbCHUfv0V2VNkL/
         l+GEwjAxsHRak19XHx8YuOdfgt6tcK8dTXGRwcSLgwPxEJaQC9HQRJTyIL8kEvO4gO6D
         UPZw2CKl6v/iH5P2IddaNaD9Knm9h2HQlRbDDVSDhwXozq57TqEhOqcKHBLzErTE2BM+
         zoPoGT1nXmP2ADputSosnS2zlgi/4BiiPRyhn4zrmI5vnZ2FaukxpT6HxGoxkcCzNQSb
         oY2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUfY1sOfTy46O7suiHkyD9AOe576i5De0FRYVsYvDjCYxeEg/FLSR0VmPjKZJVwQdewovy7ZBJ1hrgjg4IPcfcU9GxAihIe23A/rQxJ
X-Gm-Message-State: AOJu0Yyn35phXO5kDJAdPSk5ZfayTsC6j+cJ+sFsTRe40J+Lu0I21kJ8
	SR7YB8tysaDYuuPZxh5SRzO+AfL1TbfIj0ImE4vptBJTccpz3mSa8QQqUaCncZyraFMezJvIDMp
	wA3E3efVNN+APKZP/LZxiFAiegZVQ/pkufbPznw==
X-Google-Smtp-Source: AGHT+IGOWRR1l7TlH2Ox7RAt+LWTKoyBTvTvsQNVcZvBasrBWLg+mGrVd41DncN2PhPTprKTiXWDBWmMg4EGe2egT1E=
X-Received: by 2002:a0d:e647:0:b0:604:9c75:626f with SMTP id
 p68-20020a0de647000000b006049c75626fmr13126114ywe.46.1709701677705; Tue, 05
 Mar 2024 21:07:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>
 <20240305211318.GA1202@sol.localdomain> <CALxtO0kp+vDstePYkq3AYSD-h6LRt1HvRm4HdW-OtTQm5ipqkw@mail.gmail.com>
 <20240306040052.GB68962@sol.localdomain>
In-Reply-To: <20240306040052.GB68962@sol.localdomain>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Wed, 6 Mar 2024 10:37:46 +0530
Message-ID: <CALxtO0mbpORm_ZqLNbJxPQqDJyhi52Pka3PwGi=i-GEsJtx2qg@mail.gmail.com>
Subject: Re: [PATCH 0/4] Add spacc crypto driver support
To: Eric Biggers <ebiggers@kernel.org>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sure Eric,
   I will remove them from the driver, clean up all the build errors and
   submit v1 of this patchset.

- PK


On Wed, Mar 6, 2024 at 9:30=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Wed, Mar 06, 2024 at 09:16:31AM +0530, Pavitrakumar Managutte wrote:
> > > Algorithms that don't have a generic implementation shouldn't be incl=
uded.
> > >
> > Hi Eric,
> >   Yes we have tested this with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy
> >
> >   Also is it fine if those additional algos stay inside that disabled
> > CONFIG. SPAcc hardware
> >   does support those algos.
> >
> > - PK
> >
>
> If you provide an option to build them into the driver, that still counts=
 as
> them being there.  I think they should just be left out entirely for now.
>
> - Eric
