Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09655200132
	for <linux-crypto@vger.kernel.org>; Mon, 11 Aug 2025 07:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754896267; cv=none; b=rf89sSUMW7gSoC9IOOC21U1hTYPwfRvowxQeX92qfIWzQs5pA661NQWSyN310bWx6PI9qNwtPPyzLjP3Lf5TiVFQuj90jsVtOBST+JDx81ihd+4/WgYLAEin74usKsLaBZyE/X8V8AWDAGD9IVEk6WIFDl+mEGd2u5Zpz9QNBPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754896267; c=relaxed/simple;
	bh=tB/gqdCF6EzsFjXXwaRDV/pGeOQa0F5FLdXW4OQTyEc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jq/rdyvsAihhpDYzdoVG31tLDSL1C98qsh3A8Gldd27gLuiWKWHqIBGsERl4ffK4hjYe9H1O2QFjTqcVvUyvhNACIxNtz/c4eYgjXeFQcnl4rcFTcIMSM8gBfeVH5cVfiefD2S9ChXPHw8TkjLxbkgP+6VdzaEQuGpTmsbW4Dvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aiGG4bCR; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aiGG4bCR"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6154d14d6f6so4701095a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 11 Aug 2025 00:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1754896263; x=1755501063; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+tkggMO6AT5LolMfVDkxblD5g/qWfLNlR97dm1yJTPs=;
        b=aiGG4bCRN8uTntvJY8QLE+UdquE8Wr93l0CqtGxTOtBCux5AAyxfsqT7JMw3np+Sf/
         43x6Klh3weHz4Ut3Zch2DCWRI8naxLUhduRI+bror4NONOPfPuQYbPvBeRZkA+Bvwby0
         9ZzxmBxtUeSo1dH8l8KCjDc2yCojJxxHdv92g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754896263; x=1755501063;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+tkggMO6AT5LolMfVDkxblD5g/qWfLNlR97dm1yJTPs=;
        b=s50HL/z6YEyVA9a24DhlxzcHh+aSeQWyLim49Lx2aWr1nffAqqyP5RgVRh39S/Yt5R
         Kop6Iuapneonn4pPMMGKfYXQLpgT8m+G7XM8WNi6ueDSYBzIVyVCjGbbdb1WHsdRd6Vq
         QmEYhVsrA45LoAMsOL/rzdm8LWfE5YaIc4Erjbf+hpvLCM6ObsyD7OmIK/8YAPL8ukYO
         ID9ZrNk31pSNCv6giDCa1frB35gTTFMYZ9meicXT3RCIeKRszFRH4m2EvvCCaRBXPFC5
         FEgidOA2MHTPj93s2wPjJm43OfEUHN+U8TIzllSt+Y+/aUdp1gMolhnaJZnmnwt5pdIz
         oVBg==
X-Forwarded-Encrypted: i=1; AJvYcCWaKEBv34EBah2l0uTnKLXr091qc5KmW9esj2jzUjzLSExxhMfNpGQTz7CxLuDQMqJSympOU2HPzhGLb/k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPV8CfPg2JBhxyPB7Ae1QpWu5Qwj3ZB9d8k4lecGjy2Grr0wgH
	ZwDhUqCmvGdPKWZJl3IDItu1uKJfPBcOKQ/+8z+g/c4iQyjrsU8I8qXtjERUk3IEEdGmvdDwtmn
	/+I66dOIOAw==
X-Gm-Gg: ASbGncsJPJgsY7rwMVzMEqhxtmr66rSeYURM1KD+/3zsEeeSsQtCmMTvvCHYvsEq53S
	3OqNp18b/6L4Kha5IE9VFjpuEWTjaxcMqEIolSRF7c7AQ7B0+Gts8m2+SFYUKOz3nNPcKPljDOy
	hYCtUP7SA6sZjgBT8UpVUai9obRsxJahQx5aV1Kw/cYSPvXGVANVNVr5JlLjMJ1S73+rnbrFDKu
	+7hTw6WkMWde2l05g4aL4T/K3Z/grj8q7Vul+LjHVg4VWJoXdtCguUG31QquKIStzlapatbDqbF
	4uZKB4LLNl0N8bo++Cl+EkPwAvMKQnTngYKMDXByCF1Wf/CDu2QTo7Ue2N0ku/IiGiCvAC55lND
	yZK9rEfS8jdSaGEfkvJ0sg34+5G7b+EWGdgoEwWWOspwtgULKP1/ix0SzaUZQVqQubDmvCLv4qy
	5gkm9MFwk=
X-Google-Smtp-Source: AGHT+IH2sYWjau6ISXMXvsCb8JwV3mf7993Sac7uSAri0xHVhCNQp491qTW6XJ2rlRDIsF7D9fuQSQ==
X-Received: by 2002:a05:6402:4308:b0:617:e75d:3d04 with SMTP id 4fb4d7f45d1cf-617e75d436fmr10439434a12.15.1754896263098;
        Mon, 11 Aug 2025 00:11:03 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-617f648789dsm4526757a12.53.2025.08.11.00.11.01
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 00:11:01 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-615d1865b2dso5940890a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 11 Aug 2025 00:11:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVq4mrZfKTgMCMWwJ5/wb7bONE6p9CDG3a6bhEf/h/i2MgQFhIUUN39tN4GBVniT1h/m+oQbV078wTsFG8=@vger.kernel.org
X-Received: by 2002:a05:6402:2106:b0:617:b28c:e134 with SMTP id
 4fb4d7f45d1cf-617e288cb4cmr9911954a12.0.1754896261462; Mon, 11 Aug 2025
 00:11:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aJWOH9GgXhoJsHp6@gondor.apana.org.au> <CAHk-=wgE=tX+Bv5y0nWwLKLjrmUTx4NrMs4Qx84Y78YpNqFGBA@mail.gmail.com>
 <72186af9-50c4-461a-bf61-f659935106cc@oracle.com> <CAHk-=wjn5AtuNixX36qDGWumG4LiSDuuqfbaGH2RZu2ThXzV-A@mail.gmail.com>
 <aJl1EIoSHnZRIQNO@gondor.apana.org.au>
In-Reply-To: <aJl1EIoSHnZRIQNO@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Aug 2025 10:10:44 +0300
X-Gmail-Original-Message-ID: <CAHk-=wg1okLMc41jaxS+WRXigw7Fu+OUc6QsnL+BbvYAGTdZYA@mail.gmail.com>
X-Gm-Features: Ac12FXxbcSB6uQKYwcexAGQP5Eo2dNnigj0KMH9nSHSa5SpTRmBr-egHpRbH9DM
Message-ID: <CAHk-=wg1okLMc41jaxS+WRXigw7Fu+OUc6QsnL+BbvYAGTdZYA@mail.gmail.com>
Subject: Re: [PATCH] crypto: hash - Make HASH_MAX_DESCSIZE a bit more obvious
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Vegard Nossum <vegard.nossum@oracle.com>, "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 11 Aug 2025 at 07:44, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> The patch below should make the constant a bit more obvious.

Indeed.

It would be good to maybe minimize the on-stack max-sized allocations,
but that's a separate issue. Several hundred bytes is a noticeable
part of the stack, and it's not always clear that it's a shallow stack
with not a lot else going on..

(I just randomly picked the btrfs csum hash to look at, which can
apparently be one of crc32c / xxhash64 / sha256 or blake2b, and which
is then used at bio submission time, and I wouldn't be surprised if it
probably has a pretty deep stack at that point already).

Oh well.

          Linus
