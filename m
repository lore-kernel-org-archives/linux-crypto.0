Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B421A264A;
	Thu, 17 Apr 2025 07:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744876683; cv=none; b=ibOZEzoEkt7sODt208YeCMM/mAkrEqd9rDU4mpuefsBgwSnbvVagD2rZ3Dcfihpy0zQaTP5g6E4Dho7bnPHS/HSKMu/sb5DF5BfmvfTk37No+it5h1KZ4j+dX+DKjmv/fWQZA8mV2PPjN3S6hp9HpeDMbuiisgtC9f14mchNFEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744876683; c=relaxed/simple;
	bh=Js9PnPh53l/RPMmQHOE+NlNbkf8vxe/CykSrXM0XUvI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xgz2MAdCGiSn9GFloaKEN3FRoOZ4R+qpkjMSaVBp9bKns5M9h9D4vq+cuwyPzjU3xrIrzIf/GLJ9EV6BgUNhHajysJcMBC5uZDFNoxfEGpZ6pYVeV+30pr3JoAy1O1cPG0pFnNqpDlkJ+2dYamIMslKE24YvDYInA3iujrnC3HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dl8W6d1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dl8W6d1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1B8C4CEED;
	Thu, 17 Apr 2025 07:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744876682;
	bh=Js9PnPh53l/RPMmQHOE+NlNbkf8vxe/CykSrXM0XUvI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dl8W6d1OQwhWGF25I4N4e6NJW72zHAeiYIqcjLe2tToWXg1OKEnqDpfvAEsg2dAu8
	 fDAxoFvmrqNyKeZZZStUPGUBkOJ3Z94enWTerGPEMd1L1pKmllqe3XdCNPMsVHMfqG
	 jVEBBwHfOqWOn+WA5kSKNMTfWyJOipzAUK5Ah/LJmoTqKceDZ/qFboE+NiAUqSsKk4
	 SnfSxuyUH/pUEjW+vHz/DQrXrMZknUriuIn1WpafWTo7uqvBwX//cIriR8KY78bylH
	 F6yXL52XDD2jOoVhGyOXVZF//eDi0zjboVNXg2FhcQE4HxgkQAsSXqbFvmBFnM6mnN
	 dfl8GuLta+Rrg==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-54963160818so575449e87.2;
        Thu, 17 Apr 2025 00:58:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVExhFkcVUtDKt7oK/8H6Ue3y7c7YatMNeT0n2C2vMzQQYyHnVm2e9lmnj1chBtEqz02joMh5n247PsUxI=@vger.kernel.org, AJvYcCWCGMQQ7pygBLPWN/SdBOQ1v3t+L96Z8MkvCVgrvk1NLhMw7yoo0ltqqw/A85jCeLAV6vEOGGAjDqN5tnMy@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8GpebpTu6koNw+50hTY0+7WXS5UrmgARgQ0CgExYpKWjf5Ovp
	kkz7/UZV+8AsUtHGqdWLnJeaul5Xus3vWtcnlcokKsZUKCNkY9tMwJSzJH9qZ7eJYzOm9WHqe6p
	wgsxeSWTeDNckBolZzcJvf3zcfoU=
X-Google-Smtp-Source: AGHT+IH+UGf3TCV/ileu1EuOqc6i/WlofQ6d6d2XoOO/gySbI9Xvr1O2nr7dG2avGasJMuGSvjsQhU5N69R4KoqhLdg=
X-Received: by 2002:a05:6512:3c87:b0:54a:cc11:9cc6 with SMTP id
 2adb3069b0e04-54d64a99ffcmr1827489e87.19.1744876681141; Thu, 17 Apr 2025
 00:58:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417064940.68469-1-dqfext@gmail.com> <CAMj1kXFPAVXOtPoETKvHB49kjZUPYrsAqsJwdL7p5Cu4xk75Rg@mail.gmail.com>
 <CALW65jY=LnVBYoKPOQnSKgGSA0brKzmo0vqoRDcqF_=jofLAng@mail.gmail.com>
In-Reply-To: <CALW65jY=LnVBYoKPOQnSKgGSA0brKzmo0vqoRDcqF_=jofLAng@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 17 Apr 2025 09:57:49 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH-u7hiKGQfgYHj_16V4ATN_aHmA_wkvMSyLh+E3+QaAA@mail.gmail.com>
X-Gm-Features: ATxdqUFMmNbL_QaqhzIxzv2O_oKF8Akp0R3BbKtNgh9uwgL4T2xnWwluVDekAc8
Message-ID: <CAMj1kXH-u7hiKGQfgYHj_16V4ATN_aHmA_wkvMSyLh+E3+QaAA@mail.gmail.com>
Subject: Re: [RFC PATCH] crypto: riscv: scalar accelerated GHASH
To: Qingfang Deng <dqfext@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, linux-crypto@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>, 
	Heiko Stuebner <heiko.stuebner@vrull.eu>, Qingfang Deng <qingfang.deng@siflower.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Apr 2025 at 09:25, Qingfang Deng <dqfext@gmail.com> wrote:
>
> Hi Ard,
>
> On Thu, Apr 17, 2025 at 2:58=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> =
wrote:
> >
> > (cc Eric)
> >
> > On Thu, 17 Apr 2025 at 08:49, Qingfang Deng <dqfext@gmail.com> wrote:
> > >
> > > From: Qingfang Deng <qingfang.deng@siflower.com.cn>
> > >
> > > Add a scalar implementation of GHASH for RISC-V using the Zbc (carry-=
less
> > > multiplication) and Zbb (bit-manipulation) extensions. This implement=
ation
> > > is adapted from OpenSSL but rewritten in plain C for clarity.
> > >
> > > Unlike the OpenSSL one that rely on bit-reflection of the data, this
> > > version uses a pre-computed (reflected and multiplied) key, inspired =
by
> > > the approach used in Intel's CLMUL driver, to avoid reflections durin=
g
> > > runtime.
> > >
> > > Signed-off-by: Qingfang Deng <qingfang.deng@siflower.com.cn>
> >
> > What is the use case for this? AIUI, the scalar AES instructions were
> > never implemented by anyone, so how do you expect this to be used in
> > practice?
>
> The use case _is_ AES-GCM, as you mentioned. Without this, computing
> GHASH can take a considerable amount of CPU time (monitored by perf).
>

I see. But do you have a particular configuration in mind? Does it
have scalar AES too? I looked into that a while ago but I was told
that nobody actually incorporates that. So what about these
extensions? Are they commonly implemented?

[0] https://web.git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/=
?h=3Driscv-scalar-aes

> > ...
> > > +static __always_inline __uint128_t get_unaligned_be128(const u8 *p)
> > > +{
> > > +       __uint128_t val;
> > > +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> >
> > CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS means that get_unaligned_xxx()
> > helpers are cheap. Casting a void* to an aligned type is still UB as
> > per the C standard.
>
> Technically an unaligned access is UB but this pattern is widely used
> in networking code.
>

Of course. But that is no reason to keep doing it.

> >
> > So better to drop the #ifdef entirely, and just use the
> > get_unaligned_be64() helpers for both cases.
>
> Currently those helpers won't generate rev8 instructions, even if
> HAVE_EFFICIENT_UNALIGNED_ACCESS and RISCV_ISA_ZBB is set, so I have to
> implement my own version of this to reduce the number of instructions,
> and to align with the original OpenSSL implementation.
>

So fix the helpers.
