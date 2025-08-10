Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F05D1BDCF
	for <linux-crypto@vger.kernel.org>; Sun, 10 Aug 2025 04:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754801538; cv=none; b=uvmQsKa7f5fHeOKFcA6cl4ICLqnlkQHJr4pt5mNVul7yTVMmX0KV6EY3JpsBNAYGqn3g+26UthFliQiYUXWl2VZBOPRNYuSiEX8fkOA7PMxqutfrEd619/GYjlcuxcih12uBCS3QcKWydVntEphcTf1FAzWcSP08MKCh1Natb9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754801538; c=relaxed/simple;
	bh=QpYrr5zdwL4EQJjR8CXyru7YDcS9YlE8WhSGCct7Gdg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JtTPdHwwaVpeHacqPvn/JM4/RybwyXDLcjoAj85NaP0CDN4M5SfQMfx0VBhsRZnPMlaSIym8cf8xRhikGRYI26QD6hlaVSVaCu2BaPcup4XkSenhkNdMFZQ6LKAURU3PLobiao8sT368bQLjUIDt2rgQ/ivOydbNRaUHNcp4c+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JM2tldaL; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JM2tldaL"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-af66d49daffso574619566b.1
        for <linux-crypto@vger.kernel.org>; Sat, 09 Aug 2025 21:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1754801534; x=1755406334; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DIOvpfcvfL+aB8v7AdDV+E3Zb8xwZqXo/sST33XUOtA=;
        b=JM2tldaLWs8QLoU1fDkbpAoGdgIQte0tWo9yubBNV+ajPKaJUR7XCUzHMGOTZI1T2M
         wTAaEW707Tv15E3GSYxQpEL1rN3bv2QO5XnCJz2uhnFGt0813K2BW2TXB7F1n1GWTkMn
         mW0k+hSze/Mi/BrFPQDX7R4iU8hfeG04rjQx8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754801534; x=1755406334;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DIOvpfcvfL+aB8v7AdDV+E3Zb8xwZqXo/sST33XUOtA=;
        b=ustNvy2k1aQXHzpT4CG8UfCux9oYMULLv9PHG/5Wcn0MdiCUIL28Jk+6bQEmVFhUoG
         JTzUD3lRkswPsqnRMVQ+CkJtMQ+3H2e2WYbSGLAtXvpkrg/x6qInZvO5PNNuoqJ72AlP
         XnTqfRQ7AyEU5YcV/s7hocQF2PUe/+csOHQj7YlUE07vkM2bB/hsAZDME4l31qcUhdJ0
         M5RYK8JKq9kiLfKf3NV/Kim7cw5iF8s9mFR31Vamyg1fq3Wqj9ba5466FPjxAGLGFFnj
         aMSwDUxyfO7eAwFt+8P2vQvwbnqEE7vQKZbxs6kZFybePzoL6wW4GwHnWjgHGABCEJ53
         7UYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUovDt/0+B+uZjii+VNPU4n20+UJa7Nzl2eEy537XdZmpy7QSw5W07Rw0fHAGAKbZex/7NV06jGGlBU0U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3OzAiDsqpmqaXZhKVa8zojFO6eRqQPzhw25YVjiZfhuu66la9
	IAcR2xwHbCHk2nnNM+PAt8iuOpoAOXLyJDETT2CUYF5ryATX0DgT2frlAfH1YcK6boE37pGWQKP
	9BYvDb3diAQ==
X-Gm-Gg: ASbGncvDqDfhsloLZJjcqKHrABxzVGVbWStcuk5n1LMfuVtWSPncuX88ozd2v2kD0Gs
	fUGOe6LKsqq3KTFbokYo130ZZKe0CzVsDYLgrCksiScEVEhEK7+DtqEke0Yo6AaWfpLyQWiBE9M
	oZXGqPw7ZMCejdeaiwyXHw1rFflid7Ysd7l0Ni0fouMCh3jAL73+NFSfmwZYxjkwZ7uY5pAR3ka
	tgFKIFQSZyRmPr/UxCyQPKXqIYSCbRjx3DYjM+hEdzZ15DDhz0BmiK5jLmwQw10Xvv5E38FryGd
	+TsBwS8ZssBo1lPr5fQgfkG68wURik3T19H86/ZVeUGqv0KmPn10xfA3QHedk+mUdtJvLRDPfTz
	vbwfoLEEOaBIrgjYe9y+fCSVj/SUbU8QPAo7UMpJHPAq9+ocsAiNcdrb5vku2KriACabqsEHr
X-Google-Smtp-Source: AGHT+IE9qw3MbhwdIZXI1Xx6VdMieQe+4LZj26KxN6xWgna/n0YqCcssYAwEFp5J95LXKba+BlLOhQ==
X-Received: by 2002:a17:907:3d0f:b0:ae6:a8c1:c633 with SMTP id a640c23a62f3a-af9c64f9025mr734428866b.34.1754801534503;
        Sat, 09 Aug 2025 21:52:14 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a078cbasm1784922666b.5.2025.08.09.21.52.13
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Aug 2025 21:52:13 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-61521cd7be2so4649099a12.3
        for <linux-crypto@vger.kernel.org>; Sat, 09 Aug 2025 21:52:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV6sbJ+wSDVPQnM/FgCBN+tv7WJQB98XE6BwMIm65K6VI6EfM8Ft9n2Y0jroXYOSD+XAEg8OwQiw0tV2XY=@vger.kernel.org
X-Received: by 2002:a05:6402:34c8:b0:618:1cc6:af45 with SMTP id
 4fb4d7f45d1cf-6181cc6b72fmr1142596a12.0.1754801533357; Sat, 09 Aug 2025
 21:52:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aJWOH9GgXhoJsHp6@gondor.apana.org.au> <CAHk-=wgE=tX+Bv5y0nWwLKLjrmUTx4NrMs4Qx84Y78YpNqFGBA@mail.gmail.com>
 <72186af9-50c4-461a-bf61-f659935106cc@oracle.com>
In-Reply-To: <72186af9-50c4-461a-bf61-f659935106cc@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 10 Aug 2025 07:51:56 +0300
X-Gmail-Original-Message-ID: <CAHk-=wjn5AtuNixX36qDGWumG4LiSDuuqfbaGH2RZu2ThXzV-A@mail.gmail.com>
X-Gm-Features: Ac12FXyrsiG5csXTsT8XML7TTrnPvAVkGUcnHQ2aFJ6MSlHxgwl1oOGUIedHDGs
Message-ID: <CAHk-=wjn5AtuNixX36qDGWumG4LiSDuuqfbaGH2RZu2ThXzV-A@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Fixes for 6.17
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 9 Aug 2025 at 21:22, Vegard Nossum <vegard.nossum@oracle.com> wrote:
>
> The actual explanation is given in the email here:

Yeah, that should have been in the commit message somewhere.

And honestly, it should have been in the code too. Having very random
constants in header files with no explanation for them is not great.

> This is an anti-pattern of the crypto code that AFAICT ultimately stems
> from the removal of VLAs:

I'd say that it stems from using random sizes with no logic and the
VLAs were just the *previous* problem case of the same issue.

> As a minimal future-proofing fix, maybe we could add something like
>
> BUILD_BUG_ON(sizeof(struct md5_state) <= HASH_MAX_DESCSIZE);
>
> to every hashing algorithm, and/or a dynamic check in the crypto API
> (completely untested):

The dynamic check may be the right thing to do regardless, but when
fixing outright bugs, at least document what went wrong and why. Not
just "360 was too small for X, so it is now 361".

                Linus
