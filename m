Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE926CDCE;
	Mon,  6 May 2024 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714992760; cv=none; b=uao3CLrRM5kvuSMwkRDHy4J9NUU3ws6QLX7M+mnTIGsQFIQxHIbpSrMEHzYHBQb0WGBIMvb0uFmlUmidriU4Q4qn/tKtFI9Z2KCLWsz0x5JOY/AVZKUpFWC0mjXTxJLaUeRGacRJzjoABNEnhi0IJozHHKnOX5Mni2qHxOTQvgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714992760; c=relaxed/simple;
	bh=L/Bd3q6eTepzXgQ0D27Ry0hoHj0qIM9aI1K4rmUNhZg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XmZDPBKPJeVk4Ew4mJNNvdfxLFWOpsLGKmNY7n72iagaSP1O59rQGSeyVWYnYZX+w4A/gxTQlRjLS/O4gym9ksbT9sDHj6t4Gps14TXQmHBS/gdtn8WCqs2qMkdrjC8lxlnfsKIusT7v+8myZ7O9JT87Fgs+TEUElCiLRVxA+7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HiTulb8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HiTulb8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081A8C4AF63;
	Mon,  6 May 2024 10:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714992760;
	bh=L/Bd3q6eTepzXgQ0D27Ry0hoHj0qIM9aI1K4rmUNhZg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HiTulb8YHqPEHgSuhzh30sJw3+5xP52y7PFoySaXQWm5h9a/gXDzzE/ue2/02pkAI
	 +EDVqp6sg4Ma13HdJYN71JTPoSWKSOQabKpcdz+BdhNU7B1asMIMl9g5u2qBd5uCxI
	 fRe/UejX/H8+7G8pZkytKPQab/+T/wpTwEmLYy2YPuu/smvIcdcidHybqLXi23Gsoq
	 srAo6OExQJujrz4M8bLGRQsWnuQ8iQtG/k3Tm1/RqQZ51f/+g9jq7CMCvHOizyzaaJ
	 FMNUR5IZGHrrfXi1H/zh8wUqCkBbZvK7ysP5fEQlYeQgwGlZRg4me5+U2oW6z14Acs
	 dolJDaoeaoeSg==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-51f74fa2a82so1922080e87.0;
        Mon, 06 May 2024 03:52:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV0v0S74zC1YJK48qbnHKafMn8jchziReYIZFk+LDp69Kn7FdygurNQCjmGAKkm4M2uWy0he5Ivqb7fes4xyMZw1I0Nt4Ybg7aItcJrrXRwW10MmHw3B9macefL33iejmzQ0uuMUb13ltj9
X-Gm-Message-State: AOJu0Yxfvx/OvnU4+EKWgWRZDmRda3hvcORcOCTE0oDl0OautA28NE+W
	MyzVopLAOiwseV5gseEyNTjtTlP8tSsJxM/W7sOcV6hwraCGKBKMFJkGBsHFMJCMTv438ap6csC
	3ySJ4cGvGB2EmE61Rl0I3X4aWTqw=
X-Google-Smtp-Source: AGHT+IFgdQU2oYFSHh3p+jtS33brfFRw4mJpIvibcOn/cEo/57v/+GpceHEL0SUahcMcIZZ4kM9OP+2CNOnWFiu7hMw=
X-Received: by 2002:ac2:4c9b:0:b0:518:c69b:3a04 with SMTP id
 d27-20020ac24c9b000000b00518c69b3a04mr6170509lfl.0.1714992758356; Mon, 06 May
 2024 03:52:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000dcd2ae06178bccb0@google.com> <CANp29Y5k1S5ETBibTzWv7y6jiKevOhMYg0LYqM+PGvuFYiM14A@mail.gmail.com>
 <yyxz7mm542wyswp7o6t7oagqq543scntvvtrvros3iqvfjewb2@3ksyadymtnrn>
In-Reply-To: <yyxz7mm542wyswp7o6t7oagqq543scntvvtrvros3iqvfjewb2@3ksyadymtnrn>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 6 May 2024 12:52:27 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGFHBCG+aX3XSEXZh_ZYQ0dSVBAW6cCqkqmw+tB5bLeow@mail.gmail.com>
Message-ID: <CAMj1kXGFHBCG+aX3XSEXZh_ZYQ0dSVBAW6cCqkqmw+tB5bLeow@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in skcipher_walk_virt
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Aleksandr Nogikh <nogikh@google.com>, 
	syzbot <syzbot+97b4444a5bd7bf30b3a8@syzkaller.appspotmail.com>, davem@davemloft.net, 
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Sat, 4 May 2024 at 19:21, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> This is odd - it seems to be req->base.flags that's uninitialized, and I
> can't find the code that's supposed to be initializing it - but bcachefs
> usage seems to be the same as all the other uses I'm looking at; if it
> is req->base.flags then other code must be buggy as well?
>

You seem to be missing a call to

skcipher_request_set_callback()

which initializes some (irrelevant in this case) async related fields
but also the flags field.
