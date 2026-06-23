Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F27346AE8
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 18:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240688; cv=pass; b=KgXaWwzxJC0lY0oL9SidMHPgK+UBn/N1WtIsH5EygIACNkOh/N76YnPAu83qjhrmFpEet2uajcUg1m1KiDCf4Vg0lzza9hx2iFbJFtRJHcENnMltZBx04rKhP4396xtE2bMHNuLxAWisVLH+UIPyGLRQGYbg/qaNYqWpRoyHnhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240688; c=relaxed/simple;
	bh=Efr1OooVVeTRTisiJfG3vsg/+MXEtgRrVmeiLqYtGck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sFDGGZQwzMdG2Wv0I5RG6u125moPguuNZMl0A93cg43fXLrxZE29ToSNviA8IuIs0ckZK5egZJVy5EfEX/7GBzzTbueZBWK7bW6E70JBiKbjrQlGVOCY6Nq3R9xm1cklDPMeE0PvaoB90xSVL3jFFzZisjTg6mPGD1yxCPkdw9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VKg1qICd; arc=pass smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VKg1qICd"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6611689dc10so183857d50.1
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 11:51:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782240686; cv=none;
        d=google.com; s=arc-20240605;
        b=hNah65USrbD57H3dczw0iWLIrJaFd/wxgM5Tm4KZu4t0Fme1wTfbopeThqivJiw7v0
         E7ePfKUEartUNzteR179edxiON8T0JtXvduD9HXE2Ag+gY+FHiIJTNXpB6q0zPnCQT0N
         8/vhmqQbFI8qb6am7EW/i5Y8fNomtid7arpaFSQQpQw+Z08VqhHSGOsMUtSA9eYh/zep
         WEN4z4V8n4gKF2NfGAk0uDoPsAyt0j/nadn7UWmAOFqNFsozVM31RCLA9RxjeU89/EkX
         oLOEeek8tZtFPVDN0fdRmcJFOIwEkyonZwlMkUM+w0/TM7AcHAoydEoDjDaLmlOrjTV7
         TH2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QGHdQke52quudoElH5DIY+sbZKk9j5FB05lJCBdajHM=;
        fh=oQPyVsOfiflImFtc3HupBs+Qdh4bh24JxOAgZ5D/+F0=;
        b=exS1LdFCGW2xuSJPtNZFgWl/aij5fKWNoLObyyddzIgttO7K3TZfTSudF6WtC0n9zJ
         pmfAjBqB8VLCiMDLMF/aKaKgqdaH8ggVjdPsyMvIxZmch7Wg+Uppp8wEHkwk45F0gdc4
         JHZxU7NjvFsT6kiItk7ECd0H6v4duPQYGClXkqfT8YeqPlX++MYu5ArIc1k1ZgsAgc7/
         8t69FjNN6LezQSYgbs0WqLkKq1qGR/QKrieCNz86Lzg9dMpwSIa8GfKmhVVb5tnaIHJm
         b1qOJvI1rCMIK+oStH6RwJUzYYzLNFXQ3mLw29KTQ7QPnXPwZQ4bqg4qnZtKJJr7ilIw
         caHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782240686; x=1782845486; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QGHdQke52quudoElH5DIY+sbZKk9j5FB05lJCBdajHM=;
        b=VKg1qICdpjOxcsGBBOa4HZh/J0a1Gkb0EZzxvAidRzTC9Dgp3FVJETu+voTIFXZxS9
         UYFdLjMqUKDF0mxBrllAHICDgZD+qQSKxnSxU9nkMI+B/Hj3biuRvkqYLxfxBOmEFxsu
         Freiwsq4CyIepsrOIqLrOgA3rbH6vsfofjT1UFSLlkucOdTkw9LaTqURfGeZtbNV+WcJ
         ZCEVFbQktuN1ovYuqx4WIcWMn6WFtRBznePqU8AhkFJtqZ38FY3fPJJGTqE6+8tqtsQD
         TAw/ScKHLKE81rwrUg3cUbxtLBu60RT20g7JqkAs9dZa+SzGX0pB98TwZMYP37yMrdB+
         tcsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782240686; x=1782845486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QGHdQke52quudoElH5DIY+sbZKk9j5FB05lJCBdajHM=;
        b=bvwgRDozqsmo1twtDoj+sX2Pg0X9zdj0Xt+3fEc4FGL6xGF2rSJKPFp8ysxZQd4/zq
         ionJ7/NhrrWWyd9/OxxLDiW45BuKI4ZtTnvryIJmGSAaFsNNJf6GLYDfhpdioaDNhhIe
         YKPLs/veAeNcgvqVTaOmaiKCRQDeEzsFanpz378Jb9q2GyYNO7xEM4iw16Yr6oOOSoqG
         BAa9oJ8zomw2NrDJPmFErwSR2vm5k9JFKL1b7dc3WzvgkJ8nEQUxQZxLIIXBfmqp7zxn
         fdq2bXZPmNBpsjZ5Ejs7j9M6R0UMacHc7HZuECvHeYqBrVme/gG+TM9/fc2DyOd+9odG
         WKcg==
X-Gm-Message-State: AOJu0Yw3sO83A5o7cNGGIIRxcHlYVLQ2YZfRLCjvXZnF2XTQuuiRWGvd
	yJudZfvT7PSKd7wLIcym9Ys2HR+wrArlUDXymzhiJXNQoTn/BcYL+oJSfOpnhN7JA6ZnkNodt9d
	bF5pXp+GEo1uX172rX6HJf0GyGEbwvgo=
X-Gm-Gg: AfdE7cnZhjR+ceo4I0fHMdi5DKNsQLhjQ1/vQoXKCeNI1+vOiJot2pBkfeAHXyH2/i9
	8w2C72iILlK7ZTw/UUXkN1RXn8dImHj/fC/kXZc0904w3vvIn1b4d71+3cEewNR7q595cQQNaeM
	38K4uM0VyVSXiJUEwxvgEpWFRm2FCJqbCFLrTLk44JUoNhk1XPLnGrJWsdcSUMHnOWA6o+lfru0
	HEj++bWyXos67etCcwiqNakaLRt/9m/1UEiCUycSq4KOZGdxJ5uBC61yLa5Ynp55/1VtQEjA3XG
	z1UGl9Z1ihTaU/hPXswdRDWUt5SnhDHXLKyANWbI3dvBVwLAHSVBXJAzvU8=
X-Received: by 2002:a05:690e:e87:b0:662:f2d1:f27 with SMTP id
 956f58d0204a3-66359ece524mr3827196d50.27.1782240686326; Tue, 23 Jun 2026
 11:51:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260622234803.6982-1-ebiggers@kernel.org> <CABBYNZ+QLvkYkn_EcBZ4+GopyhKqJLcfCoABYcw1VamavbSvhg@mail.gmail.com>
 <20260623165208.GB1793@sol> <20260623180502.GC1850517@google.com>
In-Reply-To: <20260623180502.GC1850517@google.com>
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date: Tue, 23 Jun 2026 14:51:13 -0400
X-Gm-Features: AVVi8CfbI5Vx_0h2Ev3jl-1KL9OujVxy8AaPvUK9sScHwsY8ABVyPNIyPnDwcl8
Message-ID: <CABBYNZKdd2-S9C1z0vtUB5yMVTWxLHi+Ta0_aUrahDYAq5rpxg@mail.gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev, 
	linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>, 
	Demi Marie Obenour <demiobenour@gmail.com>, Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Tue, Jun 23, 2026 at 2:05=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Tue, Jun 23, 2026 at 09:52:08AM -0700, Eric Biggers wrote:
> > On Tue, Jun 23, 2026 at 11:04:14AM -0400, Luiz Augusto von Dentz wrote:
> > > > +=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > +0    AF_ALG is unrestricted.
> > > > +
> > > > +1    AF_ALG is supported with a limited list of algorithms. The li=
st
> > > > +     is designed for compatibility with known users such as iwd an=
d
> > > > +     bluez that haven't yet been fixed to use userspace crypto cod=
e.
> > >
> > > Is the expectation that we go shopping for userspace crypto here?
> >
> > Yes, same as what 99% of userspace already does.  Probably you'll just
> > want to link to OpenSSL, but it could be something else if you want.
> >
> > - Eric
>
> By the way you do know that bluez already has a local implementation of
> ECDH, right?  See src/shared/ecc.c.

It's never been audited; it's only used for hardware emulation, I
didn't even remember we had that thingy. What we really use is
src/shared/crypto.c, and I'm not looking forward to having it changed.
With something like Zephyr, changing crypto libraries every so often
just because one didn't fit on a platform wasn't a great experience,
and that is a much bigger project. In the end it seems they are using
a forked mbedtls:

https://github.com/zephyrproject-rtos/mbedtls

I'm quite sure whatever choice we make will be the wrong choice for
someone. Then someone will have the brilliant idea to add some sort of
backend support to let everyone plug in their preferred crypto
library, possibly adding even more code to audit.

> - Eric



--=20
Luiz Augusto von Dentz
