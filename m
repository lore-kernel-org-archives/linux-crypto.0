Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966EA1B87CF;
	Tue, 18 Feb 2025 07:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739864531; cv=none; b=qZsF9SM1iF1KhGpMUwoyGJE36H8TuX2CHfACmbWes3A26km18+6ufUNHMTIHpeykpLfz1aP1QVlpSYWYMBCYb/WGkB9VXwYKtYP0/mj7x5BiodQvf3VvjWj/IVXbGGmdJS3dmtZgEiBrdW1MZ6yu7N75asCVDBx0KGvmALVa7bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739864531; c=relaxed/simple;
	bh=IvK/YZdxhIzz+WQDui+6ei6dQMpDPKxU2syoofLtyUI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g4XjQcqEsj84+HAhD96xp+8ONUgGBf2TD+cGM8o56Z4aT8nGJgAvQPJmXFsPKUtOnPRl17ja1pr0s/R52FJvMhzbaCe798q1YH90GM5Sjr7pn28Dpd9zZ6WJFtxYFlL7jajybP//yK+lFIVkh5SeL8LXuRydWKOcJYGduvFBltc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gthhYI9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gthhYI9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18009C4CEE6;
	Tue, 18 Feb 2025 07:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739864531;
	bh=IvK/YZdxhIzz+WQDui+6ei6dQMpDPKxU2syoofLtyUI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gthhYI9H3TZNlItYwrKDSFuBdEkiKZrIrU49lRCIALScYrla7kqdufoYgJbGesW/s
	 ZfqxxSTLbGj+8Qi02jw6wsu7IjVEgz+bO00kvW3TUsL0f4tzjbMOd/9uV2HfiIurGn
	 9m47eoooc9igVM7Kr/FL6sr3en6A29okd0rLtNhhTWvF/CB0QtRNolG7vflfcsD6xz
	 5Y/qo9rK8O3PiqfxmhGwBv3+ZcwBzQrmF1rOAzJKp2/QmhVDrqXUJv1jdVM5dlk+on
	 Cu6aRVRbEFTEck7PdHrsS7uMdIMjjN8PGkfUTeir2LhQ/k8qQ00Esd9LqRLeaDttod
	 NGahJwRUtODMg==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5452c29bacfso4304621e87.3;
        Mon, 17 Feb 2025 23:42:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVX9TsriKvcfn4hVZI1VloDV3FC7mHZvLakwigpi2n9w8OI1BlQGRCm6AMI+1847VlTSt9vqsIK@vger.kernel.org, AJvYcCVnJrG/D+MDFf7oVd0UMa4I7q2uY6egkVmfQaqxd71rCKtgPlZg2dNkjaLwVGw5Z3X8T87keoNqaNuEx5M=@vger.kernel.org, AJvYcCWn5LnzDlCdlTcw3lAXzq272gO0eYkBBBCkEC9O7UbXd0mqsdM3IjACABcZM/k4jBWeAzrUdHcE4Y/6rsIG@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb+U4C5xFyWpzIl6PFTcTIefpXtdAitYUf47102VwcCu1dPQ8L
	WW0ATvXusUuzshplXhiRosMB94kuI5Q5fXkFiutw3kN8jZvZBAcYDpwCC3kxpTTH+bC7ds+alQ5
	tcWTzZSXSnGVLzmara5lmTrjuCyE=
X-Google-Smtp-Source: AGHT+IHcwsPEwQwvSNlp7+txo1ExLwL6bb64NekXlJS4T9EnBQWu9yYoLt2pG9NrnPvUbCr2H8go8Lh60C6VvcSVOhE=
X-Received: by 2002:a05:6512:2342:b0:545:60b:f394 with SMTP id
 2adb3069b0e04-5452fe27255mr4337762e87.4.1739864529480; Mon, 17 Feb 2025
 23:42:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212154718.44255-1-ebiggers@kernel.org> <Z61yZjslWKmDGE_t@gondor.apana.org.au>
 <20250213063304.GA11664@sol.localdomain> <20250215090412.46937c11@kernel.org>
 <Z7FM9rhEA7n476EJ@gondor.apana.org.au> <20250217094032.3cbe64c7@kernel.org> <Z7QBuIvr4Asiezgc@gondor.apana.org.au>
In-Reply-To: <Z7QBuIvr4Asiezgc@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 18 Feb 2025 08:41:57 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFe2f0cCYznorrO-wJyh-qxJP5z-HdR9rbQiuMKC5u6qw@mail.gmail.com>
X-Gm-Features: AWEUYZnpo_Rxk-ow416mB2XJK3Qj-eZIWTL3GmEexif4qB9L-kVkI7AOouI7sOg
Message-ID: <CAMj1kXFe2f0cCYznorrO-wJyh-qxJP5z-HdR9rbQiuMKC5u6qw@mail.gmail.com>
Subject: Re: [PATCH v8 0/7] Optimize dm-verity and fsverity using multibuffer hashing
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jakub Kicinski <kuba@kernel.org>, Eric Biggers <ebiggers@kernel.org>, fsverity@lists.linux.dev, 
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 18 Feb 2025 at 04:43, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Feb 17, 2025 at 09:40:32AM -0800, Jakub Kicinski wrote:
> >
> > Yes, that's true for tunnels and for IPsec.
> > TLS does crypto in sendmsg/recvmsg, process context.
>
> OK that's good to know.  So whether SIMD is always allowed or
> not won't impact TLS at least.
>

And for IPsec, I'd assume that the cryptd fallback is only needed when
TX and RX are competing for the same CPU.

So for modern systems, I don't think the SIMD helper does anything
useful, and we should just remove it, especially if we can relax the
softirq/preemption rules for kernel SIMD on x86 like I did for arm64.
