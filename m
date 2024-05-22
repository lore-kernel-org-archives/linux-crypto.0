Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A51814901E
	for <linux-crypto@vger.kernel.org>; Wed, 22 May 2024 22:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716418424; cv=none; b=klsMkH+NDHgvl+b5WHdFZ35sUjgUajzuGf0M44FK0WgibsswNfDvRF1CAS3Cr1z4tqsAablRbTtkM1r1xzF01d9qbcoFgko0JBjL4mKyZjhJKT8b4J5JjWQKCOJNjI6i3NRqOL/NOMlEo4f2rx/gMUT+9xf2LvDJJGOOOYT0RO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716418424; c=relaxed/simple;
	bh=s+AFZiWYdfo9LHxXiFDhhaTaz5In1NnrT6e/kTcTOec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A793TuUOnylTDdutjFmLJVf6sGxCnbhXZh/azWnfxcf+e+NJ81HWWBSBiTvOlzsnVY5Tg038kFyUmQjbeDmgevIdXDV3EVUGLp0ET7bSM16AK7h3qSCcOJ1U6+/tTUcyBReg+JPcqBygWB633g1ERH2eqsW5IXYV80D6/dL8gIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TLct8/br; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TLct8/br"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a59cc765c29so147143266b.3
        for <linux-crypto@vger.kernel.org>; Wed, 22 May 2024 15:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1716418421; x=1717023221; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5pQI3o2sJHQ9VDDihE2wM0f+XoWWITjrXXHCRcKXU50=;
        b=TLct8/brfZdjqNLgRvxC3MDlmayHtFrgF3KOIw6a6mYV5omeGAMCnHs95OIPS+J1LJ
         2j/Ed8UaBGMrjPMlqB8J3NbBmJolZ6oZ7TWyFe82AFMRPBgf5oG4h6hMgTG2OlmlTD+L
         0HIdcY0sr20y+ME3CtXxViJgMPmoBprD3eQDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716418421; x=1717023221;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5pQI3o2sJHQ9VDDihE2wM0f+XoWWITjrXXHCRcKXU50=;
        b=oZZ4PtXQiwVqik853BVF82HQQ3d40mv2YMTfZjgXqWbVF52R7sWZOcYOD65mshnAun
         3ez+hsPHWnR+L3KfFyk0jP4935bWW4j4G35LGNOeNPL10q9utdJY1/18i/s4RpU8h6Ry
         jzzgmtLTMDCyQllHg0k4PU/A+F1YUZqjjIZ2OPIKHOsMz+ihbT85s4QOp9XYzSzdlbuN
         H9GfYp9VTQfdyemQmwqimA4o5NviWv++ob/kBS2guhZGlfUsEvhiLOWbb3YqVbQbN2Qg
         M/DL1ycUQftLTKqMq3I9e7dl+pdlOu+jmgToy4dSTk2RTnCfOZVJegakr9dx0v7R0rWp
         SRAA==
X-Forwarded-Encrypted: i=1; AJvYcCVyHKh0vj2ZOv+Cnd+ooQ0kAus3DJF++ycPSe4kdEBYgoB9roaYW/220t2jtqON/dU4u1Ov20gsp8TzF1f8kQO2T013WYT/Xn64ISNn
X-Gm-Message-State: AOJu0YxKJFWE8O93c7mPmFtD5nwD3bcFeAc7aHUHwwim37mQ6vatAt3j
	IX3W8VEV1MZmHf0/OST0ajaAdyO4pwvkw5/9U7yXs0jKroMW56UyFVC5nQ4gTbj07ZUBYmClcee
	buktcTA==
X-Google-Smtp-Source: AGHT+IGkV/ebRvRRZen3yAf5rxsbvR1nk1kTF4wLbf8XpWSffzz74rd9r99s+PlWFVQGCgY7C+jpDg==
X-Received: by 2002:a17:907:7858:b0:a5a:5b8b:d14 with SMTP id a640c23a62f3a-a62280a0eb9mr211224066b.40.1716418421310;
        Wed, 22 May 2024 15:53:41 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17b01602sm1854152666b.147.2024.05.22.15.53.39
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 May 2024 15:53:39 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a5a5cb0e6b7so1081361066b.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 May 2024 15:53:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXlpC0MI+ZWq7XR2BE8F37/TfBdIUc1tJJZPa9DUIt0O+ZxoSN0+bVGiCd/TRtHlKg5Y9aYwOaBKZGecNpwJSl83uNzXA4vZeCJ5+YR
X-Received: by 2002:a17:906:6945:b0:a5c:df23:c9c6 with SMTP id
 a640c23a62f3a-a62281673cemr222082266b.47.1716418419345; Wed, 22 May 2024
 15:53:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0d260c2f7a9f67ec8bd2305919636678d06000d1.camel@HansenPartnership.com>
 <CAMj1kXFE_R_x10BVkU+8vrMz0RHiX0+rz-ZL+w08FH2CLQHZXA@mail.gmail.com>
 <66ec985f3ee229135bf748f1b0874d5367a74d7f.camel@HansenPartnership.com>
 <dfb0d930-7cbe-46c5-be19-d132b4906ecf@notapiano> <D1C2NPOBHAHK.20O4IME8OK1FH@kernel.org>
 <20240518043115.GA53815@sol.localdomain> <ZkhS1zrobNwAuANI@gondor.apana.org.au>
 <00bcfa65-384d-46ae-ab8b-30f12487928b@notapiano> <ZkwMnrTR_CbXcjWe@gondor.apana.org.au>
 <07512097-8198-4a84-b166-ef9809c2913b@notapiano> <Zk2Eso--FVsZ5AF3@gondor.apana.org.au>
In-Reply-To: <Zk2Eso--FVsZ5AF3@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 May 2024 15:53:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi7vwgzD4hdBzMrt1u3L2JyoctB91B7NLq-kVHrYXoTGA@mail.gmail.com>
Message-ID: <CAHk-=wi7vwgzD4hdBzMrt1u3L2JyoctB91B7NLq-kVHrYXoTGA@mail.gmail.com>
Subject: Re: [v3 PATCH] hwrng: core - Remove add_early_randomness
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?B?TsOtY29sYXMgRi4gUi4gQS4gUHJhZG8=?= <nfraprado@collabora.com>, 
	Eric Biggers <ebiggers@kernel.org>, Jarkko Sakkinen <jarkko@kernel.org>, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-integrity@vger.kernel.org, 
	keyrings@vger.kernel.org, regressions@lists.linux.dev, kernel@collabora.com, 
	Tejun Heo <tj@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 21 May 2024 at 22:38, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> In this particular configuration, the deadlock doesn't exist because
> the warning triggered at a point before modules were even available.
> However, the deadlock can be real because any module loaded would
> invoke async_synchronize_full.

I think this crapectomy is good regardless of any deadlock - the
"register this driver" should not just blindly call back into the
driver.

That said, looking at the code in question, there are other oddities
going on. Even the "we found a favorite new rng" case looks rather
strange. The thread we use - nice and asynchronous - seems to sleep
only if the randomness source is emptied.

What if you have a really good source of hw randomness? That looks
like a busy loop to me, but hopefully I'm missing something obvious.

So I think this hw_random code has other serious issues, and I get the
feeling there might be more code that needs looking at..

              Linus
