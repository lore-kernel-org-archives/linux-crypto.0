Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9A52367A8;
	Sun, 13 Apr 2025 07:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744530370; cv=none; b=jaYm0WnSNO6RITnkcCrHQTOut+gBjHAtb1f7Yzg/JCW920mPX/L/T3Gqi/KrltGcgQqwPqY9gRmiVT7JdpXg8VMxZX1EsiJj0XeitaGGh7ROCa8JX9lolwj7tve2KuZmY1DmpEw6KzRVdp+wSa9N2AOfKNxxPQ66G/tiWzU8g7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744530370; c=relaxed/simple;
	bh=bDSu5/EVHFrCNsSIo9MPis9K1+uBYhIFfq4Okm82ftE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sy72Eb6uEBnihFbaH7hFz+dd/YIbHJaDLBOJiRc0FuhA0n6NV1jojKstF1yoWodSRb1Yzfdu/277ActiDIVTxjJjiSNl+yp/7JXahZCdpBTm9nwNrf97fSDjmvPp7fJXyGjffTt+hNH3OjsbXgRhck9ORCW+th8722uGTX27zZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=knVzK4+6; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knVzK4+6"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6e8ec399427so28062186d6.2;
        Sun, 13 Apr 2025 00:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744530368; x=1745135168; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bDSu5/EVHFrCNsSIo9MPis9K1+uBYhIFfq4Okm82ftE=;
        b=knVzK4+64xTpzl7x3svHgfHYOV3i8wEeQO5x8ElkngyB9RBYkmEohkJpxEBbhHTDQc
         Q8lX8ghS1tjMHKvR257Ndq6QUnrGjB+Wy34JswDBS584ydn8sR5Kjfan+PNMEzvDYAlq
         /yv2BlzY99TrPBq9Fet7BN+2By/zv+K5Wv6AK6ACHB35joIYPRyMTvfcTHaYViDrEPTg
         Y2VZcFSX3XN8oD1qrvfufnujQI3SqzQkUb4Rv2IrR+KI82fiFFhRibeXdDQff4jnxSP3
         /IZnoaL/slf2E4zUe8/FEyGpgbvagM01rTgyo0rUScn4M3Ji1+Y+5/R68HExVmgcWypI
         UsXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744530368; x=1745135168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bDSu5/EVHFrCNsSIo9MPis9K1+uBYhIFfq4Okm82ftE=;
        b=Wbimv13B1fuuSwXa3dQeTXfERAIur12dDxcKDh/xeufcdH/0Am5bYF7XIW9MJUEq4q
         s8EyQ0Z90/kOs4xwE6UW3596PHR/cHjm5sSQuyWpGftE5tTJnWsgVvs1CMG28UjcPLKN
         BiRh4U5aosflrfBmTRpmxpxyc70IkX1VRjagUoeRT6OxFm/d00qSkqRfxEwxy5qrWG3T
         fpsxNHCQ6uj9YrzjFFnSLX8e8GaUZolyiFAYDRa0xRIbL5/Kenk35mHfIUtZFCBR6NUS
         TJr+sj/q0Jq0HJbYuEcjI06pqK6VSh8MBUbV4JJ0Ao1rIO6LctmXbaKwj8QYBHaQDUpr
         jXSQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3k/Cngi/uzSdd6bCHgnOWi48DDER3gnUsbmtFIRKiwnP73R8J86Qq8sIOvoON+xNryIYumr+CfvCZNPQ=@vger.kernel.org, AJvYcCUPVJvZl5tEs1soN4tziwWpkXp+FYMIXMt7FRsEB+djQFLy7qD53jln10fL3jHw6SUzZqJQxYph8BIqWKMI@vger.kernel.org
X-Gm-Message-State: AOJu0YzFWdrHsZA2peXnFZ5rnQGqKoyG+sfZzHdGLoZEpwp2dD/JgG0E
	yBfTtLnsFRL3yRaSckO7nYwaHPpT9gIbq1ZNeKw+XprolTCMnCnOAkck9MfY0KhursHPXsAXf2K
	LbHHZMFa6txSEEglK5lGcDSeONJA=
X-Gm-Gg: ASbGncts3s/MwR/+/DyUgke3vhZ+sYvHkaGQM3BVbRUAQJ0vd1Epj2FLrsP2bLPgRtA
	v8wZBgm26D7o4ctYxM43kE6yHG0BE9dhYthYcuoYGze5hdRqzPjkCnLIz5dqE3G2AIjVxMlObAL
	WnYEXqyi2NuSYC/hLhyiMU47VSC7t2FErQ3iAIXZ4Yx0nkNn6J
X-Google-Smtp-Source: AGHT+IE2ltyuOxfGOryXdaLo+W43seZVcMMz3+9+li7smTXP3KjLa9lJvabIEPh7RW1u+VRnSNyF0yWPYUQYYsnOyvY=
X-Received: by 2002:a05:6214:496:b0:6ea:d604:9e59 with SMTP id
 6a1803df08f44-6f230caf43fmr148715986d6.9.1744530367915; Sun, 13 Apr 2025
 00:46:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3727de04-7993-4b81-80c0-adb40b847307@web.de> <20250409133610.59d42bec@donnerap.manchester.arm.com>
 <e10ecbe1-d8c3-444d-92cb-647a1c54675f@web.de>
In-Reply-To: <e10ecbe1-d8c3-444d-92cb-647a1c54675f@web.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 13 Apr 2025 17:45:56 +1000
X-Gm-Features: ATxdqUGCfzpcdhEUWjj5b9x98mojrheGEprGdWhLMUFri6RCu-8lKdWby7ULwLo
Message-ID: <CAGRGNgUV6Dq6ZR9bcgomzj1PMQj4vLq9qJCy0dxVd0vQoPWYXA@mail.gmail.com>
Subject: Re: crypto: sun8i-ce-hash - Refine exception handling in sun8i_ce_hash_run()
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Andre Przywara <andre.przywara@arm.com>, Ovidiu Panait <ovidiu.panait.oss@gmail.com>, 
	linux-sunxi@lists.linux.dev, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Chen-Yu Tsai <wens@csie.org>, 
	Corentin Labbe <clabbe.montjoie@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
	Samuel Holland <samuel@sholland.org>, LKML <linux-kernel@vger.kernel.org>, 
	Julia Lawall <julia.lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Markus,

On Wed, Apr 9, 2025 at 10:47=E2=80=AFPM Markus Elfring <Markus.Elfring@web.=
de> wrote:
>
> >> Two if branches contained duplicate source code.
> >> Thus avoid the specification of repeated error code assignments by usi=
ng
> >> additional labels instead.
> =E2=80=A6
> > Now there is one rather opaque label it goes to, so a reader doesn't se=
e
> > the error code immediately. And it really just saves one line per case
> > here. =E2=80=A6
> I imagine that such a code refinement can occasionally matter.

Just because you imagine that such a code refinement might matter,
doesn't mean it's actually useful.

1. this is making the code significantly less readable to save 1 line.
2. gotos into control blocks are weird at best and problematic and
confusing at worst. There's a reason why nobody writes code like this.
3. this sort of tail merging is something a compiler would apply
automatically when optimising for size and it can do a much better job
of this than you can.

I note that you said you did this using the Coccinelle software. Is
the semantic patch something you're trying to get upstream at part of
coccicheck? If so, could you please get that semantic patch merged
before posting these patches?

Thanks,

--=20
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
