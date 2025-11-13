Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43A9331A7A
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 15:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763048121; cv=none; b=W3F++ANaw5aUaLiIATnLtILqQ3QCIznc/069ujp1z84sH8AgiUswGxsmvEVMygC/81AVp/Fu0j+gcAPWjzMP0SNZSrdAm8p9PutDQcxbmpVIUmQIFPDXOuHb5uBI8YqYQVAMR0HeL6/Gt8hgyAGxQhsqgdqP3oVMDllMG8ckZKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763048121; c=relaxed/simple;
	bh=7y97fQ5anqKPljbcJwEjLuD7ZGbwhoE7qAa90lGJPtw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DH+uST+zUkdjTcHyaVHLiOJveKj8HzVVZJYRHOUnTFb9PSRrsEO1TPC3zXbMxmfCo1iV7p1QodUy3HGXCEn3VPM32RgqaXue0vYx3GhX3BZaAcNmowA2hZUz02Rbin+XeZDwGtxZ/8QA0tG4BN6gd/8k/psfYkPBngyrljwTa/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNN3kQT0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNN3kQT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A075AC4CEF5
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 15:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763048120;
	bh=7y97fQ5anqKPljbcJwEjLuD7ZGbwhoE7qAa90lGJPtw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kNN3kQT09Vu1lJHMPXHaFstAWj/37XFx6oSuGdar0db28Wt7PRoeZhZ/Y6Z91H1or
	 JzMN3Z/s8BIwF2N+NI2eJrqxdTa75B1nQm+3JuPGIbrXqPD3+MG2Z4LJcdRCqmbp1+
	 fgCrrni2/GHcu8nnAbbzhZZ5gk3+0qTh4q+ohKuzeS3LTDscvGcjLVK2DsS+WL6jMa
	 luu+52cf40KsPFuSFk7i3fp0r2tuHy/4oFSn2GAFqmGyHaSfnX7ddoXpSyM0/OP6s+
	 v3IWEKymsswBFwDs8zkcjeh+6dViLvI4vAIp2uG5/DmVJTgY/yiR7nMSczIRvi4haP
	 LQScSTfHl7eOw==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-594285c6509so897324e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 07:35:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXIZiKOe8J0B7RT5BEY189kKmv43r7M0lzsLxqAdjoS6c30fWeUP887VNBa3+QPvENEPWjgKW9t4xXnn1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFxGfKA6MMhOV4AhI6UXJ4qra2MBCJkQgRbgY9NYQHu1+SpaNz
	A08ikRqymR5pV6Wyg21OMf24zl4nw3rWeP7vSM63MU0X5oo62n7V0U38mpqLTR6xm2BP9UFDVQh
	AvlCc1uOoc+xsrQpHMEJ4nUb4uehy/sM=
X-Google-Smtp-Source: AGHT+IFSYtlQ0Ik6SQdcIxTxPW7UMALLWKETzooevgZgxo2E3TFUk/0TVwKl+Z8PWkRPVlHulNC7+/9hXtr5ug1/GIY=
X-Received: by 2002:a05:6512:68f:b0:593:f74:9088 with SMTP id
 2adb3069b0e04-59576e2e9b7mr2377457e87.43.1763048118988; Thu, 13 Nov 2025
 07:35:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250929194648.145585-1-ebiggers@kernel.org> <20251112121212.66e15a2d@phoenix>
 <CAMj1kXEM62YLP2oLEA447hCFidTqE0E76XrTO02B373=sa0Jkw@mail.gmail.com> <c4028d3f-69f1-47f2-bd76-f9f5fb432fb7@hogyros.de>
In-Reply-To: <c4028d3f-69f1-47f2-bd76-f9f5fb432fb7@hogyros.de>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 13 Nov 2025 16:35:07 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEF2iQ_EO2kiwqwqGL=br4FjEt=9QF0MXs4ATzLes7uOQ@mail.gmail.com>
X-Gm-Features: AWmQ_bmsczc6-5DSYNKgFaTPCnPO7lGTY1Pd1cuVDihMrI5Rufc5_S7Ihn_wzuw
Message-ID: <CAMj1kXEF2iQ_EO2kiwqwqGL=br4FjEt=9QF0MXs4ATzLes7uOQ@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v2] lib/bpf_legacy: Use userspace SHA-1 code
 instead of AF_ALG
To: Simon Richter <Simon.Richter@hogyros.de>
Cc: Stephen Hemminger <stephen@networkplumber.org>, Eric Biggers <ebiggers@kernel.org>, 
	netdev@vger.kernel.org, bpf@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Nov 2025 at 09:51, Simon Richter <Simon.Richter@hogyros.de> wrote:
>
> Hi,
>
> On 11/13/25 4:25 PM, Ard Biesheuvel wrote:
>
> > Also, I strongly agree with Eric that a syscall interface to perform
> > crypto s/w arithmetic that could easily execute in user space is
> > something that should have never been added, and creates portability
> > concerns for no good reason.
>
> Would it make sense to add crypto (and other transform) operations to
> the vdso, and make the decision whether the syscall is beneficial from
> there, depending on request/batch size (speed vs overhead tradeoff),
> data source/sink and available hardware?
>

No. User space has all the tools it needs to make his determination
itself, and OpenSSL (for example) already supports the 'afalg' engine,
which will use AF_ALG, but transparently fall back to software crypto
if the engine does not support the algorithm in question. So there is
prior art, and therefore no need to complicate the kernel for this.

Note that taking the SHA-1 of a BPF program is guaranteed to be way
below the threshold of being worth the overhead of using a crypto
offload engine, so in the context of this thread, it is kind of a moot
point.

> For example, "gzip -d" pulling data from a file and writing to a file
> will need to transfer the data to userspace first, process it there,
> then transfer it back to kernelspace so it can be written to a file.
>

That is a different matter, and AF_ALG does not really help here at
all. The crypto equivalent of what you describe already exists in
fscrypt, which can transparently encrypt files, making use of
whichever flavor of crypto is available, including inline crypto,
where the h/w accelerator is in the storage controller, and not in a
separate IP block. I'm not a file system expert, but AFAIK, some file
systems already support compression at the file level as well, in
which case h/w offload will be used where available, and the
compressed data never travels to user space.

Similarly, on the networking side, there are things like VPN
acceleration and kTLS, where the crypto offload is combined with the
networking hardware.

Discrete crypto offload hardware is simply not something that has a
lot of good use cases anymore.
