Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FBB245B0B;
	Fri, 14 Feb 2025 10:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739530263; cv=none; b=ukrsRa3rtFdSmfweaNN06X8pXA7NJ20tnJKXiQZkEozLO2nN4MF1pnYGAvHtxOHEsciz0hyeQR1r9KG878vxOpLMTCw+PtRhYIAcDSAPEXKcFk5e4+cPtHAaaSG1Z2WWK4HyuySkTilRvqP9zaGPKMo6oIvWJYTlyxUBrRPveiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739530263; c=relaxed/simple;
	bh=6Jn8hY/sj0Vyp9Oc8m9BXlUSR+CXepQ6Dz6GoxyvGmM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YMJlFOA8HZ/KJ4J/qgaj4BaCP7e7nIU56JM9GM7HfAgPOC24kwsIPrfFa0xYCbsWDDwVvSSVNnt1fT0PzEHxKE0ECnC0FIPSco449J0OrJANXgB3A60HdjtlLvpERDxrKPLVyeQ0/zcqHWaH/HZd73f5esI4e5tAuFUeiWDiQ5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VRsIYOrX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VRsIYOrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C27EC4CEDF;
	Fri, 14 Feb 2025 10:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739530262;
	bh=6Jn8hY/sj0Vyp9Oc8m9BXlUSR+CXepQ6Dz6GoxyvGmM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VRsIYOrXB4NBmaHnCnh1uRaIbgK1hXsNVaNz80MfbnD6MVpllwkX+Ak12MXoDJHcV
	 ys6MmQ9o2cpS8i3Vi7Bu3Lc0qaPCyUl/+Wehmwb+DWyODTsnbbG70xkXTu09G85ek6
	 oKOzzzEfsyiggpI64zaVrWPSzL7j2WgI8P+RDQH0vdoZuqQ/SL8X7IFVD98QPIX2up
	 Yymer9b//q1dKe/m4zomdwTDoM8rJOr3/EgutNtanp1n1AQiwty6iUdSBdjPo2XY+M
	 CQ0VKj0yNlCs2PAom9g9m52G7jyDnzJIpE1f6SMrCUf09pyfQt2/ehewrWeFXSS//H
	 GhfM6r7edJq/w==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-543e49a10f5so2015147e87.1;
        Fri, 14 Feb 2025 02:51:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUjSLQE5g84o/XvpuGjKIMXRjs3AGrG72dSftBGtZjHKVWkZTEDYX0/IbuJbichzRuAcqMFU7634QQBeARv@vger.kernel.org, AJvYcCUsdSNcKZq+PVIX+9FsZqtU1ovxdK7JxjvT2xyV5yHmTP6PiQjnADJeIssu72modoze9RXEYOwC@vger.kernel.org, AJvYcCWTfDP18vF+23BTbuCFp4V/84x1fE26w5LwEtnxROSQA6AjPdd8t9KDRI42XPqMZKbF9trBMboideJtK/A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrfytJiiN+4YBKs4ilfa7nt5U+/lPAhZRaKAy/f+VUimZ0NpgZ
	3OrY3e3qydDt6945VXOsGS+huAHI/BtK3SWvROdCtXlmYATCDyf60zjt147jmMERtMqJhRvsqpa
	Df9vYGiX7vT7GEq2HaUwQBzgCXkc=
X-Google-Smtp-Source: AGHT+IE51G43p8pR1toPTVSYBg68ovY9ZnGfaoNwwqJs6GgOaOCJnB/+CJEzpaQ+RZJoWPf4T1kKfJId9pTwob2I0YE=
X-Received: by 2002:a05:6512:1155:b0:545:296e:ac28 with SMTP id
 2adb3069b0e04-545296eaef4mr578053e87.24.1739530260860; Fri, 14 Feb 2025
 02:51:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212154718.44255-1-ebiggers@kernel.org> <Z61yZjslWKmDGE_t@gondor.apana.org.au>
 <20250213063304.GA11664@sol.localdomain> <Z66uH_aeKc7ubONg@gondor.apana.org.au>
 <20250214033518.GA2771@sol.localdomain> <Z669mxPsSpej6K6K@gondor.apana.org.au>
In-Reply-To: <Z669mxPsSpej6K6K@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 14 Feb 2025 11:50:49 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHS+BaLnUSQf9uiTvXhSee=+8W1B-DY5MFHTxgpe1iMyg@mail.gmail.com>
X-Gm-Features: AWEUYZk9BVG_mnviM5EBJUUBfeH7CmJgTUXwh6dulpUSYK22Lsgwd5629FUH9e4
Message-ID: <CAMj1kXHS+BaLnUSQf9uiTvXhSee=+8W1B-DY5MFHTxgpe1iMyg@mail.gmail.com>
Subject: Re: [PATCH v8 0/7] Optimize dm-verity and fsverity using multibuffer hashing
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, fsverity@lists.linux.dev, 
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 14 Feb 2025 at 04:51, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Feb 13, 2025 at 07:35:18PM -0800, Eric Biggers wrote:
> >
> > It absolutely is designed for an obsolete form of hardware offload.  Have you
> > ever tried actually using it?  Here's how to hash a buffer of data with shash:
> >
> >       return crypto_shash_tfm_digest(tfm, data, size, out)
> >
> > ... and here's how to do it with the SHA-256 library, for what it's worth:
> >
> >       sha256(data, size, out)
> >
> > and here's how to do it with ahash:
>
> Try the new virt ahash interface, and we could easily put the
> request object on the stack for sync algorithms:
>
>         SYNC_AHASH_REQUEST_ON_STACK(req, alg);
>
>         ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
>         ahash_request_set_virt(req, data, out, size);
>
>         return crypto_ahash_digest(req);
>

Whatever happened to not adding infrastructure to the kernel without a user?

You keep saying how great this will all work for hypothetical cases,
and from any other contributor, we would expect to see working code
that demonstrates the advantages of the approach.

But it seems you have no interest in actually writing this networking
code, and nor has anybody else, as far as I can tell, which makes your
claims rather dubious.

IOW, even if all your claims are correct, it really makes no
difference when nobody can be bothered to take advantage of it, and we
should just go with Eric's working code.
