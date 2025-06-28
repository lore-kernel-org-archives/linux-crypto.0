Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D75012EBE7
	for <linux-crypto@vger.kernel.org>; Sat, 28 Jun 2025 00:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751072067; cv=none; b=qSLlnw+p8qem2bacJe4fga70QkZd5awbTiWkcOc+v+FhBezFQ+ksd60cxVpwy/af2IY0ciVEbpLXoX3C8LDBUsFt5FPOalL1CvnF/A25mQrpwtv0qsh9+TNi0hwjFFj5zD3oq1hQu6C/XoIeiX1sz9QFgg2Y2OX+2k2sPwxFC14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751072067; c=relaxed/simple;
	bh=ihYX4jbLlsAgBR3K1G2zHtsDTgFanHhsNpPguZ5DU08=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B1LelqDum/GjtNJra4nKpWUG790A0qWfNCs76VSEkCVDVNPfSsMW6qljICu/ZdTardnlKPFFLTuZy6i7WCGHQn818lxFhBWA3z54C8bzcirBW6HIN0+fOJ4XetdVf2o92Af62bXV76/W+S8rsEtT9Zgsgxds56w+zX0oJdeHmoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GvXc/8FX; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GvXc/8FX"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ae0df6f5758so61016566b.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Jun 2025 17:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1751072063; x=1751676863; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fcxR9gUNpKu3U1/BnKj88yEF6VAeOQF6FO4D5ZntrgM=;
        b=GvXc/8FXL+XonKfKnuwr9mwbgXc/opoPe6OKE3c1SaPsWagl8aMYweHosUW2XjtX9O
         4uf/As0hvK5yGEM1x9bxPVYr1eTYge1M2ZLPVktCxySFFvruBP0bAC0z1q5bArRsC5o8
         W/pMxJ2uIcywwtn+zRCbJEbS/kA3B7xZfVpBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751072063; x=1751676863;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fcxR9gUNpKu3U1/BnKj88yEF6VAeOQF6FO4D5ZntrgM=;
        b=GJJgeiXNMk4885IIXSZ+mH0Im0TmXRsKrRq7GkYIe18PB6ij6yOQu+BwTEc79ce7Dt
         qL4xAA61aIaXITNBo5HATCuOI5WEEMvIUFIEABkB9kZ+bw8ZAKVRQmoG+vCZ1QKBhY7y
         AmWIUNfUfEzpVkJB4E8lJ93/FSoFtzfW4Pa/BwAhiTh+rpjPSMXOIky1h1GDusnp55N9
         GXRoc9aP1Ofk5V4vPkok3T5t4WjnaRnTgDuV5kWi/a9u0FL0sL4u0w76WrsqwO9oU3DW
         8iJ4i4F8a4okO8idL1l1l3mcMbGrvag62f8YZyyFAVlfOIi237mwQzpJAg4Ue9mRAfxD
         SmHg==
X-Gm-Message-State: AOJu0Yw9B57yN4vIbeYsHe0SmjZ8wSo04YGC98mFtwdVV71D+cw/FYIX
	9E9iHhYIG81mrMds3YQIFJbX+jNFF4L3KtKILxMtgcNid6kKSE8osmNpuozCAKt2ZZY/yiq5aW4
	hX2SJTj4Wcg==
X-Gm-Gg: ASbGncuzQFRMg2Q2TOeMKUspErkz6k2CGiS4MytnkEUK5c017R0rBIiVJkKJi5o7tZv
	mgei9fy3H8Uv8weuzmA4o6jwECkKNqD+eguGJc9gDrMDlMCa181tuiU9+nvvV0YJkwBONxMg8n6
	R+VVCs9UfTCQ2Lg0LUrx8U/qBsVXZ3LlHGrbFfiN4U28Qzks6uLuietBC3BHp1KVqtNBATsMggM
	n2CdladQ2eH/NfYF7qyWoKnJPi13T/KP36Rl53WsSPcW6rPKwejghmD2vgkgJaty88IFCc7gAiS
	UI/bwHs86cLtlNS9ZieJpKHLjsNAN0zl32vmPhmoqcqWgg4ubg+QOPlrQbFRHGrzCCqc/WBpn3P
	W4qClxZfLzzKK1Q+e9daob947pNxjbXTaUwof
X-Google-Smtp-Source: AGHT+IFf5faafVL+Hp0nohunmTUocWq/+3BhNii5slwgdIb9103zdwz+I20UQCUynt9V12XWb1fDaw==
X-Received: by 2002:a17:906:4784:b0:ade:3dc4:e67f with SMTP id a640c23a62f3a-ae34fd18512mr435176866b.9.1751072063525;
        Fri, 27 Jun 2025 17:54:23 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353ca20f3sm218117566b.175.2025.06.27.17.54.22
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jun 2025 17:54:22 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-608acb0a27fso592418a12.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Jun 2025 17:54:22 -0700 (PDT)
X-Received: by 2002:a05:6402:51cb:b0:60c:4a96:423a with SMTP id
 4fb4d7f45d1cf-60c88e7308cmr4952711a12.18.1751072062068; Fri, 27 Jun 2025
 17:54:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250627181428.GA1234@sol>
In-Reply-To: <20250627181428.GA1234@sol>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Jun 2025 17:54:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiT=UUcgCVVo5ui_2Xb9fdg4JrPK=ZqpPxDhCgq9vynDg@mail.gmail.com>
X-Gm-Features: Ac12FXySqvJ1tGZd6uU7BKMl--GPFvTk66FXlw4mrxXnAGnE6PjcTh6U-u4Ld08
Message-ID: <CAHk-=wiT=UUcgCVVo5ui_2Xb9fdg4JrPK=ZqpPxDhCgq9vynDg@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto library fix for v6.16-rc4
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Fri, 27 Jun 2025 at 11:15, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Fix a regression where the purgatory code sometimes fails to build.

Hmm. This is obviously a fine and simple fix, but at the same time it
smells to me that the underlying problem here is  that the purgatory
code is just too damn fragile, and is being very incestuous with the
sha2 code.

The purgatory code tends to be really special in so many other ways
too (if you care, just look at how it plays games with compiler flags
because it also doesn't want tracing code etc).

And when it comes to the crypto code, it plays games with just
re-building the sha256.c file inside the purgatory directory, and is
just generallyt being pretty hacky.

Anyway, I've pulled this because as long as it fixes the issue and you
are ok with dealing with this crazy code I think it's all good.

But I also get the feeling that this should be very much seen as a
purgatory code problem, not a crypto library problem.

We seem to have the same hacks for risc-v, s390 and x86, and I wonder
if the safe thing to do long-term from a maintenance sanity standpoint
would be to just make the purgatory code hackery use the generic
sha256 implementation.

I say that purely as a "maybe it's not a good idea to mix the crazy
purgatory code with the special arch-specific optimized code that may
need special infrastructure".

The fact that the x86 sha256 routines do that whole irq_fpu_usable()
thing etc is a symptom of that kind of "the architecture code is
special".

But as long as you are fine with maintaining that arch-optimized code
knowing that it gets (mis-)used by the strange purgatory code, I
certainly don't mind the status quo with that one-liner fix.

So I guess this email is just me saying "if this keeps triggering
problems, just make the purgatory code use the slow generic routines".

Because it's not necessarily worth the pain to support arch-optimized
versions for that case.

If there is pain, that is.

                    Linus
