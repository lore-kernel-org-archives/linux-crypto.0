Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B331D63DA
	for <linux-crypto@vger.kernel.org>; Sat, 29 Mar 2025 18:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743274359; cv=none; b=py0cv1xYzDZCsXUbwakH4jMTgLfYm/b+TbrOSBPcqGA5WfbWOBcjSF75Q1A8XmWBzPAHAjauRF0nc6fUKdWLmxH5b3BkqDLqmiuR6TF0Q+5hWdZI+9VtC4X6MDulRsp9PdlxofuxILJHVGx2mCVDZZmNth/KZEnK53hTRdJgLNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743274359; c=relaxed/simple;
	bh=wIQzIZgH3WeVOOSe4apoCqE2KGja3fV/2QqK9w9GFyU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UT/JVgnx/eYlM7wCnih1/Vw7wZVXxUregNzmqPJmjhBez2KbApM1aiWKEdlmhRo2N873jo3RDcViX1fY3h07ynAulC3buNtkaRXhIDMSC7bGAW9Xs5LRa9uMViQ3UH6carId2EemykJyTOVodOOhtGr71pHWSQV/5OMD68nxM1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TE7c8pcA; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TE7c8pcA"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5edc07c777eso2666614a12.3
        for <linux-crypto@vger.kernel.org>; Sat, 29 Mar 2025 11:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1743274355; x=1743879155; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=act5dliCYf1Xte3jD8zN9vIyZot+EgA+rw0oWDLbeUA=;
        b=TE7c8pcAXo2akEqb3W0nJJeoZBujTMXC1tc6N43Tk/LYJBUJ9X6/3ckeY0xL+jPXcn
         zfSqA+L8gr/VBVUuto1RuoGXJ41eK7X9A7Dye/gJkeTLmF4aFtcs9D1clIHPwB794RZW
         4aklMa2+a7eBneFgl24J/9D8WfsI0Ef+AdyaQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743274355; x=1743879155;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=act5dliCYf1Xte3jD8zN9vIyZot+EgA+rw0oWDLbeUA=;
        b=JAnvVVpPNvIEP+yzLQ47DytzQB1tN5fQMZ92BDIso/PmaC8/c075dJykws+b+uwvdu
         UClFFkWr6URWJ7tmJiHYVbptVBSd9fL2MlarevNj4jhx9bU3A9jTscp8A9jLx/cZfRrL
         gTF5iU4oSva53LPytFmxc6oqj9fbUp+li68DRG7hRsGBS1xdLFBiGPv5fcyg4B1k9o43
         3bTzRebfmN4H8/hQgOOkTlAp7txH+fSvRGoaQUzDOVSdSdc9BF3TfaS0Pb8NdgQZGkDu
         AKJx4+xZMuhWVL5QnzOSPgkrrqte+6wa9MLi4nBLq8duyduxc3EO2SLSu6HsJNC/7xB3
         9w9A==
X-Forwarded-Encrypted: i=1; AJvYcCX71u6dN502uDdjTbU14In9aHLtcmz0KUq3YS9VHB2qovom3mos+y1yg12HL7hhazGm8cBxNqrLPfmrHAw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYNKjBBVXmm3Yy+kOF/YmWZJjNuSo6XtN/YqrOZNO8TzXCyrr/
	2jZg+OFeyHQDHphsmbP/S/uPQQi/0OfX7rhXlGiQISDBpvwBpbWU3jf6i1ZJkQNJrs/hSUUWX5k
	ceJM=
X-Gm-Gg: ASbGncuvx3UGWpWWU9SM+n5IdHfRXDUqfXGCd0BqIDgx+PByXwkcrRqyMTUeqDYAZ3Z
	L0zcDqNmonOLATDYlD15fLL6hLoF8D63hvZWnDeDQuc1mbYNTG1uXWHIL+i6naj4SZHUajmxHOg
	zjD4khivUmaqNFa21irfMuo4Zh0DXlYeZQ7TboooIUNkcnOxAQXLl9kOaZaz+lc8PDegfrWMw2y
	SX4y22rcPJrLyxhKfFFhB3YGFIF5sIo7VvETMc+jf0szUMSobJIQeywy7ZeUwbtEk8NtagaCV9y
	6Uflk2iy/B00dH9DIrNNiIsca+ctVybSRGdBdsaiXYbsXsXz6HU3nvppbtBRFhgysfMdoaNHK1E
	N466cqHkX4eazK0znt8E=
X-Google-Smtp-Source: AGHT+IExzfKBZroZUBqEjngXEr5EJFsYGF0F0kCMzfo5HiQiE6VsVvCfL05WeNAb77VJWbjbtIe2/A==
X-Received: by 2002:a05:6402:51ca:b0:5e5:4807:5441 with SMTP id 4fb4d7f45d1cf-5edfdd16b01mr3420321a12.30.1743274355130;
        Sat, 29 Mar 2025 11:52:35 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edc17b2ea0sm3284467a12.53.2025.03.29.11.52.33
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Mar 2025 11:52:34 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ac41514a734so535347266b.2
        for <linux-crypto@vger.kernel.org>; Sat, 29 Mar 2025 11:52:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX3LM03nUrYheYz6xgXO+fxRIAqYawk+LBi+SEyyLkbhVJ778ZuwizMkafIIBH8c6Mnnp0f0Q3dSCd+dXg=@vger.kernel.org
X-Received: by 2002:a17:907:1b27:b0:ac2:49de:3969 with SMTP id
 a640c23a62f3a-ac738ba8dc9mr254702466b.47.1743274353618; Sat, 29 Mar 2025
 11:52:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZpkdZopjF9/9/Njx@gondor.apana.org.au> <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au> <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au> <20250325152541.GA1661@sol.localdomain>
 <CAHk-=whoeJQqyn73_CQVVhMXjb7-C_atv2m6s_Ssw7Ln9KfpTg@mail.gmail.com>
 <20250329180631.GA4018@sol.localdomain> <CAHk-=wi5Ebhdt=au6ymV--B24Vt95Y3hhBUG941SAZ-bQB7-zA@mail.gmail.com>
 <CAHk-=wiA0ioL0fonntfEXtxZ7BQuodAUsxaJ_VKdxPrnKx+DAg@mail.gmail.com> <20250329183820.GB4018@sol.localdomain>
In-Reply-To: <20250329183820.GB4018@sol.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 29 Mar 2025 11:52:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgp-fOSsZsYrbyzqCAfEvrt5jQs1jL-97Wc4seMNTUyng@mail.gmail.com>
X-Gm-Features: AQ5f1JrM_HFkzUSwzDgwQhKmnl8eHsLngYM7ql_facXoYoScNqXR7VePFMkP0dk
Message-ID: <CAHk-=wgp-fOSsZsYrbyzqCAfEvrt5jQs1jL-97Wc4seMNTUyng@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Update for 6.15
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 29 Mar 2025 at 11:38, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Yes.  Those cases were just a single algorithm, though, so of course the library
> was simpler.

Yeah, I realize.  It's the extreme case of "using the generic crypto
infrastructure is just silly to the point of being stupid".

I just think that there's a continuum of that situation.

There are cases where you *obviously* want to use the crypto
infrastructure, because you really have lots of different users, and
you actually need the flexibility (and in the extreme case you do have
the whole external async crypto engine case even if I can't for the
life of me see the point).

And there are the cases where it's just stupid to do it, because you
have one single hash you are doing and the flexibility is only pure
pointless overhead and it makes the code bigger, slower, and harder to
understand.

But I think then there are the middle grounds.

The cases where you may well just say "this is the common case that I
want to optimize for, and I know it's more efficient if I just do two
blocks in parallel and I'll do that case directly, and fall back to
the generic code for any odd cases".

               Linus
