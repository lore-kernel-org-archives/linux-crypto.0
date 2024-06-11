Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558751D556;
	Tue, 11 Jun 2024 15:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718120774; cv=none; b=stDc71qM3NDJvg1C+sLMr9A+vT0LNETqNh/9fmxgmzgH/aDRHPEWhLCTrVThKWGwC535L/+kdh9YbXQHGSz1iUCEGXVRrFdz85JxhNzQpFWRMUwsKuQeT4NhjEvp3yo2hCBUbJBFV6avpHmDXk2JfrEGmkv3TOvksdxcvneC+eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718120774; c=relaxed/simple;
	bh=nHYZzSrwzVkx0XliBhDrKJIYP1BW1UKKqywssutXd94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n89taPUzsd1hSfcwRIFKcwsGm4FoxM/U70AM09ndMmO9EQjqyjXTfz5OurIWDuWuKw1GxmdCTZPujQAo6YCcCMyJUAcBLyANXeEqlb4pyh6UOERuh+IbWacDOrKfAA8kbwpJUHK8pwEAEQIqBC9MZKW3XLLnf2Zlo5n5MUAYxCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tGI2imw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tGI2imw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDE6C4AF51;
	Tue, 11 Jun 2024 15:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718120774;
	bh=nHYZzSrwzVkx0XliBhDrKJIYP1BW1UKKqywssutXd94=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tGI2imw8BDj+4k5dMama34vbhkrYM0hGn4oC1oHp4XumdIdItvvkhqcFZplFhkcjj
	 lW+MyDYu7kt5NuZZ70y6eBB8X7Gj2Yy9hWXiwV9FlqY5kGjJHD49BLgVpSPVFjbpHy
	 409FQPq2vZTFrozUQHMF82QpNoLD1gcXFnOU4uFLRiu796ebSz9nAmzHxLaXWBYeFF
	 DR6Exu9ucdogcjynNguLN0fhZSxn7RZr6IMcJDsU8tcyS1Ts2CjrddxlCgVjZLrvrX
	 QvGh8yKb6zQhhYBb8ykzyGNe/MNPN0/NjMJYYoZxLowDD9588PKFd0SgNuQI/EMXLy
	 vkT0VsPMF7i4A==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-52bbdc237f0so1643808e87.0;
        Tue, 11 Jun 2024 08:46:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVfm6CRKN9WZK1K5hopKiEANaz92T4sm25HJbOPgQ1NDgQFbVYaqFJ7anwZ0qp5P2208VqcS4eQ1PisEPZLvMEwe/eP120MMyfW4jA+Ucrv3Fr/W3d7Ca7eeh08at40RcB8DKto
X-Gm-Message-State: AOJu0Yzkn22mPnnab4kyOluri+9BNnZhb5qHa2XuVgfnMh/TrfAY0Kic
	30pK5NE8+FF9sfOuZt75mWcFRy5ZC171Z5BhM4Ldncc0ub7A+5mYBbl6NmyuxU0Bh0oLuXwyzo7
	QX5p6YFhu8nypf1sCIF8mhF1F+Lo=
X-Google-Smtp-Source: AGHT+IFNi8O7iGLGeMHQZ0NNyUR4jvtAz8icvQz3DDdQ33zLN72EpnmHYm0Y4njGv0rD+XUtdpM8PO1XuOoDfgzKsz0=
X-Received: by 2002:a05:6512:3241:b0:52c:885a:f17 with SMTP id
 2adb3069b0e04-52c885a0fc9mr5168902e87.31.1718120772312; Tue, 11 Jun 2024
 08:46:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZmEYJQFHQRFKC5JM@gondor.apana.org.au> <20240606052801.GA324380@sol.localdomain>
 <ZmFL-AXZ8lphOCUC@gondor.apana.org.au> <CAMj1kXHLt6v03qkpKfwbN34oyeeCnJb=tpG4GvTn6E1cJQRTOw@mail.gmail.com>
 <ZmFmiWZAposV5N1O@gondor.apana.org.au> <CAMj1kXFt_E9ghN7GfpYHR4-yaLsz_J-D1Nc3XsVqUamZ6yXHGQ@mail.gmail.com>
 <ZmFucW37DI6P6iYL@gondor.apana.org.au> <CAMj1kXEpw5b3Rpfe+sRKbQQqVfgWjO_GsGd-EyFvB4_8Bk8T0Q@mail.gmail.com>
 <ZmF-JHxCfMRuR05G@gondor.apana.org.au> <20240610164258.GA3269@sol.localdomain>
 <Zmhrh1nodUE-O6Jj@gondor.apana.org.au>
In-Reply-To: <Zmhrh1nodUE-O6Jj@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 11 Jun 2024 17:46:01 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEwmHqKbde4_erjmdi=+nO13Qwu3nSbkU_77C3xcjxAjQ@mail.gmail.com>
Message-ID: <CAMj1kXEwmHqKbde4_erjmdi=+nO13Qwu3nSbkU_77C3xcjxAjQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using multibuffer hashing
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, Steffen Klassert <steffen.klassert@secunet.com>, 
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org, 
	fsverity@lists.linux.dev, dm-devel@lists.linux.dev, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sami Tolvanen <samitolvanen@google.com>, 
	Bart Van Assche <bvanassche@acm.org>, Tim Chen <tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 11 Jun 2024 at 17:21, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Jun 10, 2024 at 09:42:58AM -0700, Eric Biggers wrote:
> >
> > I understand that you think the ahash based API would make it easier to add
> > multibuffer support to "authenc(hmac(sha256),cbc(aes))" for IPsec, which seems
> > to be a very important use case for you (though it isn't relevant to nearly as
> > many systems as dm-verity and fsverity are).  Regardless, the reality is that it
> > would be much more difficult to take advantage of multibuffer crypto in the
> > IPsec authenc use case than in dm-verity and fsverity.  authenc uses multiple
> > underlying algorithms, AES-CBC and HMAC-SHA256, that would both have to use
> > multibuffer crypto in order to see a significant benefit, seeing as even if the
> > SHA-256 support could be wired up through HMAC-SHA256, encryption would be
> > bottlenecked on AES-CBC, especially on Intel CPUs.  It also looks like the IPsec
> > code would need a lot of updates to support multibuffer crypto.
>
> The linked-request thing feeds nicely into networking.  In fact
> that's where I got the idea of linking them from.  In networking
> a large GSO (currently limited to 64K but theoretically we could
> make it unlimited) packet is automatically split up into a linked
> list of MTU-sized skb's.
>
> Therefore if we switched to a linked-list API networking could
> give us the buffers with minimal changes.
>
> BTW, I found an old Intel paper that claims through their multi-
> buffer strategy they were able to make AES-CBC-XCBC beat AES-GCM.
> I wonder if we could still replicate this today:
>
> https://github.com/intel/intel-ipsec-mb/wiki/doc/fast-multi-buffer-ipsec-implementations-ia-processors-paper.pdf
>

This looks like the whitepaper that describes the buggy multibuffer
code that we ripped out.

> > Ultimately, I need to have dm-verity and fsverity be properly optimized in the
> > downstreams that are most relevant to me.  If you're not going to allow the
> > upstream crypto API to provide the needed functionality in a reasonable way,
> > then I'll need to shift my focus to getting this patchset into downstream
> > kernels such as Android and Chrome OS instead.
>
> I totally understand that this is your priority.  But please give
> me some time to see if we can devise something that works for both
> scenarios.
>

The issue here is that the CPU based multibuffer approach has rather
tight constraints in terms of input length and the shared prefix, and
so designing a more generic API based on ahash doesn't help at all.
The intel multibuffer code went off into the weeds entirely attempting
to apply this parallel scheme to arbitrary combinations of inputs, so
this is something we know we should avoid.
