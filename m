Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51762222580;
	Fri, 22 Aug 2025 08:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755850566; cv=none; b=FU0TeEizz5qy1B8wAgMRWpdOzdVTYqvv9wNvq8/wfxQv8m1u6zE2UZAP1S2u7gmW8lZgBaN5UQ4p6mk3mVRO3vl184ih8Tugxx3eTHYP5TJFB6d5+uSU4Pa73gPGplrgaVkGdn5UQCnNg6SG/0AjyaD4vzNvBk03Ot3DwS6JbDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755850566; c=relaxed/simple;
	bh=YVeh8OFS3+/IlZrjuSBDy6MWR0SMYXgiYrxYee0SPuc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iNKNQBiiSoWnxiyvuDsCmwVUMyKVhXFw+8HGkGRwhnpBnY1+mNcSyv/39OvBt4fUyGY+58Xj9Sulijt6hFzH0jzyLoaH0wnn1dGRVCU716ilJIk7/yuZcwJXEjoSggWVz7BNUa4dAsBGM0sD4mn80cLwvX6ixfy2QI2Kdpw5kj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f9izoHwo; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f9izoHwo"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-244581c3b43so17467305ad.2;
        Fri, 22 Aug 2025 01:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755850564; x=1756455364; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVeh8OFS3+/IlZrjuSBDy6MWR0SMYXgiYrxYee0SPuc=;
        b=f9izoHwoATqPAclHEW+SDq1PPnSCSPhFVf8UZOzkmC7OhDtZHEqzWBbUF1VXiNTwV6
         +Vqf0pPylE7n5SF3ow1APQRHnPG0irSR7s53ENtGEJfxT+Ph6jKo1sE81zjLfPyTy2XH
         2u+ilPhhBs2/2AvQkqDy0RA05tkwf+5MCo0vm0jyBCBpBvHJdSkwm+ra27mkcYXV3ygf
         OCCKU3loL+SNaNL/DhHmHS1EHhTOGhJAbbXjgGpLi1w4iqWqv6QWpBM1lFnrb0vlzAGU
         ZtZcHSp5VqegEvRe7U5J1s8jkpFNkgUsTXMyvr6QhMw68NKCqiPMscwyNfqJGLZmPM2Z
         pGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755850564; x=1756455364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YVeh8OFS3+/IlZrjuSBDy6MWR0SMYXgiYrxYee0SPuc=;
        b=YdbeL8+gIkO5hbztIxwVuv3epEe7pLtzGAIzu/Xf7iFY7+ZYFqJP2Qlgpgd+lTqgDH
         rNxojky6f39B3TPt0l8fTcAzrVmvvkhNmAnvr8aMPR4lmbCDBMlhBirRQTLquzXGGuG4
         NqYV2HQKfBGUgxlgcv6PM+TvdiDU4nlyGMB2ksiISyDyRiJdBvL0V9QmPxCghpCA53X/
         yNSMnVKYz++hPpoJhuVFR1ybw06mGLD2ZWSH5bxy9HJq143dk87aytEQXEKE6HA276wX
         CmTPmGYkj0DlvqydKAFZq0sVc+xuAbYuMw/7UDGQ353P7Z1HdyEvBoRIf3hqoOcw/KX0
         0HKA==
X-Forwarded-Encrypted: i=1; AJvYcCVJc8V3wUNmr3DUgYkbsRgPXcVP9Za4M0l8FCrWKi+s7Ip3S0rJGyppT2mYlHfmhPLZuffuPzPpeV3/B68=@vger.kernel.org, AJvYcCXsz5vCwOnM+Ij4auPg7Lp4Uxqg/RBMtKUAGMszNGbE4XJuEfKD4ViZavQy1oAkjSHdqBg2u+6UfTpOmpl8@vger.kernel.org
X-Gm-Message-State: AOJu0YzQUtA/Rg7x+LUK801sRoC1NQl3NbziA3m6Lyr/1XOrvuvq9PKb
	M73ML9jq/Z8c2CZMnowe3RnGnl0y6nlgrfb6mXlDZtcLRnCcQw4ixUci+CmuXxUshL5SeUQ7Gb/
	dEeIbtNfrDFhvLaOVwgHjrkKvMjfavTA=
X-Gm-Gg: ASbGncsS7OuRCSuBLnqvnBVP1wKoYPtOVQ8arG9zNCzpZCxg6UAc7hXuG+cc11vz8CV
	g5+KX+RFegMB0XJ5EebJA3s46dS5ullp30521zHf7f2x5LJeTa01z4cicLEcg3SQqkxbqmGuyU2
	YuQGBtrRLnmZf0qYAlyO+7/kD1PPVekM3XkBPYj6BBKFOIPmYRZ5+cOpo+6pfgn58TMlgy1alWu
	mpF5S3Wi5I7D2dI/X8vTxT6qBeCy90P3ZK+
X-Google-Smtp-Source: AGHT+IEOJXf+AeVA8GJXSwtIVDCbutsD9QgyfyAJ5PaMZOWfwJZDQTuqMWKOpwuzJZN4EkQir8nz/hEMiI5zBLDIKNU=
X-Received: by 2002:a17:902:ea01:b0:245:f5b8:87ab with SMTP id
 d9443c01a7336-2462edd7d9dmr29942155ad.3.1755850564406; Fri, 22 Aug 2025
 01:16:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
 <20250813133812.926145-7-ethan.w.s.graham@gmail.com> <CANpmjNMXnXf879XZc-skhbv17sjppwzr0VGYPrrWokCejfOT1A@mail.gmail.com>
 <CALrw=nFKv9ORN=w26UZB1qEi904DP1V5oqDsQv7mt8QGVhPW1A@mail.gmail.com>
 <20250815011744.GB1302@sol> <CALrw=nHcpDNwOV6ROGsXq8TtaPNGC4kGf_5YDTfVs2U1+wjRhg@mail.gmail.com>
 <CANpmjNOdq9iwuS9u6NhCrZ+AsM+_pAfZXZsTmpXMPacjRjV80g@mail.gmail.com>
In-Reply-To: <CANpmjNOdq9iwuS9u6NhCrZ+AsM+_pAfZXZsTmpXMPacjRjV80g@mail.gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Fri, 22 Aug 2025 10:15:51 +0200
X-Gm-Features: Ac12FXwnoEYMnSaKSxMxoYPh7b4TsxXD4qJ__w-NoWUUMjPmRTgOxfHSPEf4r3U
Message-ID: <CANgxf6xCYE4dQQ9=UDotB351wxs46=ZUhWz4zfrROH5nNsSBRg@mail.gmail.com>
Subject: Re: [PATCH v1 RFC 6/6] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Marco Elver <elver@google.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>, Eric Biggers <ebiggers@kernel.org>, ethangraham@google.com, 
	glider@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, rmoar@google.com, 
	shuah@kernel.org, tarasmadan@google.com, kasan-dev@googlegroups.com, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 12:08=E2=80=AFPM Marco Elver <elver@google.com> wro=
te:
> For example something like:
> For subsystem foo.c, define a KFuzzTest in foo_kfuzz.c, and then in
> the Makfile add "obj-$(CONFIG_KFUZZTEST) +=3D foo_kfuzz.o".

I agree that fuzz targets should only be built if CONFIG_KFUZZTEST is
enabled. Building a separate foo_kfuzz.o is probably ideal, but will
need to think about how to cleanly handle static functions.

> Alternatively, to test internal static functions, place the KFuzzTest
> harness in a file foo_kfuzz.h, and include at the bottom of foo.c.
>
> Alex, Ethan, and KUnit folks: What's your preference?

I think placing fuzz targets in separate files is a step in the right
direction. Including a foo_kfuzz.h file inside of the source does still
pollute the file to some extent but certainly less than having one or
more KFuzzTest targets defined alongside the code.
