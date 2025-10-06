Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DDB1B0437
	for <linux-crypto@vger.kernel.org>; Mon,  6 Oct 2025 16:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759767581; cv=none; b=ruka4d8SMpaAIIpHitqFlgfLeOcULz5XSP4IY/qkv4qZ+fHAUj1iiBtaJhjMgTyyyFIQDNTeBVON03SRba4hDy+xxI4akYq7cfYF6rLpJB+08tl8H40l12A6Tc4fwO0KP9xADGEhOWuGFiPDNYAAGNgNyvps0Jsuh3bWMuhabAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759767581; c=relaxed/simple;
	bh=ilQLZBd6Iw562q61xBjSjhOvv2dstXz6kwD00scDbX0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=btgYzuzZx6ds1qPgkp2st2zD5n+RxxxE5e9QEX4ocpSCL8t/6FwUBpNDzVGfXI6faFumm5ZV552otlGeaf4x7iPbHdIDP6DIHvdPTR/gZ+kL2AX/+tsaL/TzsBPMab9+Uf6g+Qc0+1Amz0i+mIPf+myU3uYuqRHq2pIKQUE4ScI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IAKNNIuc; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IAKNNIuc"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-637a2543127so9268606a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2025 09:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759767577; x=1760372377; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TTyUjRqJNWM7omsm7yhQtvnjFIwOU00+n+cJwl4in/w=;
        b=IAKNNIuc+CyJlpRQIy5PwydUgF99LqoGCgiFaxaJ3KD3PhMi9rqdqooaTyzfFpzlFF
         JJn5PiFEyR2VVrK46MtPkacV9jRsz4Z0uYgLO7dnzBi/IGK2pgdgriRGgHmBvRPfT2EY
         kFStkYlp0ky7/C2kdonB8wbze4xWjImvIsY6E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759767578; x=1760372378;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TTyUjRqJNWM7omsm7yhQtvnjFIwOU00+n+cJwl4in/w=;
        b=dTFh4tvxJihKK7wk+kNTrER8o7kzHprZm05TFsYkhIfBKxMj7x1cCY8IJ7SMqiuczx
         E5H8c75Aoc98jlG7L4aSkH/UatF6O0lOKA+iYey8jmKimLPnfTW3yJjHBnf+JcoQfTuN
         b0IweUlHtG19cQxTJU+ogCWGCg5ibq3A0m6ZdohBR5pavOdgXcnTP/+/7h7PiQ2mBH+U
         4HvldCUH+X6xRUoz3KLfL8FBQ9KL+N8+ezpV5Q8gqLWGBgieQclvwS1mnztIKLNNcbkt
         p5mlTx9VeU9nfKBQ4N4qKTi4gOc7uprRbvzeml0yH+gPlaIChA+ghJRB9IBKKmGe/IgH
         gO2g==
X-Forwarded-Encrypted: i=1; AJvYcCVfMPmQlG3iPBkX87zYVB6S+Gzq37ww6n27Qchmf/o4YXrLLqfvHB757ONDKGQ9A0dcm0NKAbV5bNeH/QA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiepYXqnX1uc7XrqI8IRM3QXrCTgZ7N0mo6wkT9zQW3BDzOQQU
	2K1WZYRi+Z7nF6xlDvMTJVpSMHja0nJaVyF5D1CpOmqiotyeOVrkw5Gj4NdjPgKGUVDCwtGC2CU
	2F2NlQI0=
X-Gm-Gg: ASbGncuyIaQJNNEinv+8zzC1Q4rrs3gQJtVR4Yo94/dbXjLoVXQBsppvrOvc0Qbb9i5
	iauOhiHyyohREAyncvG09KuqM3glc0nGemFHClpHMM3U615mNegZGcRimKSX/TgThXoBobV03AT
	xNTITPBih1D6RVfD4QX4jtuqY1jhfvNfZFzY2sY7Z0rd4plAbMif3ThIKuQQ/kbKoHpygwyLaIF
	xMN1RN7TiOWUzq5uSN8wGvMxRNffUm8gOz+YRD2+p6VB592nQE7OUJcdSZIzsi0y1qtlPAh8n+C
	N8JT4bcGXBNr+5cGmC6t3eQR4ij0nAfzd/tAdmUvCIPXvPAfek5XltqbJ81Sp+bjV/nYfJFOdO8
	A4VcTYFDSkonWykSDLr21I6oGTQbbBQzWLTY7O03my9KxiW3H+rnl4kKl1C21dK9mppmBl4BX9+
	jRt1MQbQTkGZV+Zuxy+8Tfi++cfnV9NNoXXZRplB9MsA==
X-Google-Smtp-Source: AGHT+IHoQ/KPnFS/SSUqakAFgBEV1oWoEIDGXm67olkHVL80DxXYuKx/EGfK84bz+uiCGJAVEjRXIQ==
X-Received: by 2002:a17:906:6a0f:b0:b41:4e72:30a0 with SMTP id a640c23a62f3a-b49c3f6401bmr1690078966b.56.1759767576500;
        Mon, 06 Oct 2025 09:19:36 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b48652a9f5dsm1162735266b.11.2025.10.06.09.19.35
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 09:19:35 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b3ee18913c0so803062466b.3
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2025 09:19:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVm11EsZXbD8c2qLcYhWn36BVGkHiQ9mS23gMd+LMl1Xm2xDbOGyDvJ3Az7woZOG0b0uHy86rX5/3uiHb0=@vger.kernel.org
X-Received: by 2002:a17:907:96a9:b0:b46:1db9:cb76 with SMTP id
 a640c23a62f3a-b49c3350413mr1708289066b.39.1759767575015; Mon, 06 Oct 2025
 09:19:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aIirh_7k4SWzE-bF@gondor.apana.org.au> <05b7ef65-37bb-4391-9ec9-c382d51bae4d@kernel.org>
 <aN5GO1YLO_yXbMNH@gondor.apana.org.au> <562363e8-ea90-4458-9f97-1b1cb433c863@kernel.org>
 <8bb5a196-7d55-4bdb-b890-709f918abad0@kernel.org> <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>
 <f31dbb22-0add-481c-aee0-e337a7731f8e@oracle.com> <20251002172310.GC1697@sol> <2981dc1d-287f-44fc-9f6f-a9357fb62dbf@oracle.com>
In-Reply-To: <2981dc1d-287f-44fc-9f6f-a9357fb62dbf@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Oct 2025 09:19:18 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjcXn+uPu8h554YFyZqfkoF=K4+tFFtXHsWNzqftShdbQ@mail.gmail.com>
X-Gm-Features: AS18NWDoHsGA-jRDtJnK1_zO_N3TBkB3duq0d2_Pl_53b0GJS8ieGMah2y3ZACw
Message-ID: <CAHk-=wjcXn+uPu8h554YFyZqfkoF=K4+tFFtXHsWNzqftShdbQ@mail.gmail.com>
Subject: Re: 6.17 crashes in ipv6 code when booted fips=1 [was: [GIT PULL]
 Crypto Update for 6.17]
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, netdev@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, "nstange@suse.de" <nstange@suse.de>, 
	"Wang, Jay" <wanjay@amazon.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 6 Oct 2025 at 04:53, Vegard Nossum <vegard.nossum@oracle.com> wrote:
>
> I'm pretty sure the use of SHA-1/HMAC inside IPv6 segment routing counts
> as a "security function" (as it is used for message authentication) and
> thus should be subject to FIPS requirements when booting with fips=1.

I think the other way of writing that is "fips=1 is and will remain
irrelevant in the real world as long as it's that black-and-white".

             Linus
