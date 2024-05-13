Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AE92C1A9
	for <linux-crypto@vger.kernel.org>; Mon, 13 May 2024 22:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715638394; cv=none; b=PoHGZMU34vBXAc1VqkP03licEXTQjjDkMi7F8korGCBk20Ut/HT5dXMWIAM4awYoyn3NIOOxe1tq7yO+B5F4hrB2k/yeQVSKUR4LHObtkSPobJ/KYgnH8ZyPYgzDl+3hnSaf0elgrejX5UTT2tuBHTsA7Y/dGJd7Sxc4AXpd/1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715638394; c=relaxed/simple;
	bh=kd7mGogZ8Fm6S2jihTGjWVAjQyjfhfYYNYzr2e886ck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ucOUC++ODyKvuexPGuz80z0bxVHyUB6SDh79DV44fMz5h4J1RzTWsqtOSPhJGplH3W4r803sS7NozpwHKK5XQ/2cnDXIrDOCTBxqLMLq3IlU+NuWAH0Bci/cBf70UHbFKpQ5igdcvtUBhC+6JmVsxxB/Fr6N5RnnrO2iMmaJlK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FuEd38Yl; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FuEd38Yl"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a59a934ad50so1155585766b.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 May 2024 15:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1715638391; x=1716243191; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ps+jWjBcJqtAnfvkCrJQhLLxq6+xUCZXu8MlaxS7yCo=;
        b=FuEd38Yl+T9l+EPYhb+5aWa/9EZG9pv2mHpqvHJ9WAzDqsspyGdF8+TehMhERzi6OV
         OFgrDUsagks92fQ718MNtg38+N1TTygyk0j2qu2xN6w20MtaDPdiRheIpkYHVA28V5I8
         VjRWjogTt+pka6Pi4pP86pncBCBKrFM9HkEnk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715638391; x=1716243191;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ps+jWjBcJqtAnfvkCrJQhLLxq6+xUCZXu8MlaxS7yCo=;
        b=Snnc5tfcEs7BytcQiyoWXR0Zb07VL9I0DOpdPP8DBVlqs8KtgHHtPiWPTMRnjCRM9D
         PuQNtTqG9O+3pKBYRxSeGhfd0CGWTqDwzWUUFKRTKVGm4eofCiBUwtA9XKG+6MSlGtTA
         cBDi5iFKbQT6xaGPMWj1MtlXTwx0VCHYLPmOTjxFtKhXM5pYVMTLj6BCGh12qkYZRvJF
         YJr9tzAyNSy85vwTU7Hqra2jsh8irRtPPAZP13mbpSiIqCUs5xd6KCwc4ZlA7LXf9FXk
         znx/aV3IGYjemddtbJ4kBEr5FsenV/WV+DxpgO//HTJuDQAKG5qqHagYIJD+HzaVnH5+
         /RcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVClfRl7GVK9aLO3l/JwA9lPRe4SBbJ7x9pzDzR4MK8EievUcK7PEyGXYgJuBgTkbW1a6RjkfzQHTaDvpg6659ChgnCTPhRNZwT5/z/
X-Gm-Message-State: AOJu0YwrP5BlD4gHjozzcm+NFuekjHQA+tj5vkUZgbHAPJkMRA5kOxv2
	yQrn171vy4fdFeLjj8qfujNA2fSg8NjGSeXRa1ivAxTixbsB7Us1SXqs+PjiR5Wwz9hogbHEd+u
	m0gAUtQ==
X-Google-Smtp-Source: AGHT+IErp4LLlwKtrwvkRFEja1lX2Aymj+yswO9eID2TZ22Ehr9Fi0K/P7/6KF6FlCCLmuFaup5cPQ==
X-Received: by 2002:a50:870d:0:b0:56d:fca5:4245 with SMTP id 4fb4d7f45d1cf-5734d5c0f47mr7382707a12.10.1715638391009;
        Mon, 13 May 2024 15:13:11 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5733becfde7sm6725665a12.48.2024.05.13.15.13.10
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 May 2024 15:13:10 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a59a9d66a51so1140180366b.2
        for <linux-crypto@vger.kernel.org>; Mon, 13 May 2024 15:13:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXdWDz72NkQ3un2IPL9H4GBGHM0VBkTrON1S44aMgzW6H+v16e+6OqHr8OufE4XO8gAbV8MYyQQcxOAjvsJd5TExBvsFJpXoy3rpyPI
X-Received: by 2002:a17:906:aa4d:b0:a59:c23d:85d8 with SMTP id
 a640c23a62f3a-a5a2d6653f4mr737764966b.51.1715638390051; Mon, 13 May 2024
 15:13:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Yui+kNeY+Qg4fKVl@gondor.apana.org.au> <Yzv0wXi4Uu2WND37@gondor.apana.org.au>
 <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au> <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au> <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au> <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au> <ZfO6zKtvp2jSO4vF@gondor.apana.org.au> <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
In-Reply-To: <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 May 2024 15:12:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjmwmWv3sDCNq8c4VHWZUtZH72tDqR=TcgfpxTegL=aZw@mail.gmail.com>
Message-ID: <CAHk-=wjmwmWv3sDCNq8c4VHWZUtZH72tDqR=TcgfpxTegL=aZw@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Update for 6.10
To: Herbert Xu <herbert@gondor.apana.org.au>, Lukas Wunner <lukas@wunner.de>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 12 May 2024 at 20:50, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Lukas Wunner (1):
>       X.509: Introduce scope-based x509_certificate allocation

I absolutely hate how this commit tries to remove one single compare
instruction by introducing a *very* dangerous hack.

The whole 'assume()' thing will generate actively wrong code if that
assumption conditional doesn't hold, to the point of being completely
impossible to debug.

Having random kernel code add random "assume()" lines is absolutely
not what we should do. Particularly not in some random code sequence
where it absolutely does not matter ONE WHIT.

Now, I've pulled this, but I killed that  "assume()" hackery in my merge.

Because there is no way we will ever encourage random code to make
these kinds of patterns, and I most definitely do not want anybody
else to try to copy that horrendous thing.

Yes, yes, we have "unreachable()" in other places, and yes, you can
make compilers generate garbage by using that incorrectly. But they
should be about obvious code warning issues, not about "let's save one
conditional instruction".

Now, if somebody really *really* cares about that one extraneous
conditional, particularly if it shows up in some more important place
than some random certificate parsing routine where is most definitely
is not in the least critical, there are better models for this
optimization.

Maybe somebody can teach the kernel build in *general* that
"kmalloc()" and friends never return an error pointer, only NULL or
success? That would not necessarily be a bad idea if the scope-based
cleanup otherwise causes issues.

But this kind of hacky "one random piece of kernel code uses a very
dangerous pattern to state that some *other* piece of kernel code has
particular return patterns" - that is not at all acceptable.

Put another way: it would probably be ok if the SLAB people added some
"this function cannot return error codes" annotation on their core
declaration and it fixed an issue in _general_.

But it is *not* ok if random kernel code starts randomly asserting the
same thing.

Quod licet Iovi, non licet bovi.

                 Linus
