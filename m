Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79832DC76C
	for <linux-crypto@vger.kernel.org>; Tue, 25 Nov 2025 10:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764065435; cv=none; b=dywYoO4OUBQrFSsM4AOlxKRvDlaF2f6gOQUOAsLVMoVj+Xz6T9k9Sa9a+QYidRdLMolRNpWSv4Z3sjozk8ATd1OT3hDRb5INEuBhGXkvWuXwj8oja8JpBhhD1hpPdVjulTMGj54JOUqpFnMX7iGHm43LfF8D8a6ySSvuBJAgt5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764065435; c=relaxed/simple;
	bh=xrTIXClxXhCfJ28KXDtYmccizc1PI2Sren1VLiZ82WM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s3RqOzmspzTTB6e9v6Fr/+d2+eKcE7YZK5CE8QMNvNI1pw7abnmPu+H/Td/1f0ev5drTBZlJDLcJqgVmjJM1+G6r+3fZ75lBzc54NHwvAEfN9zN1bsuGDmcWvT47RYmyb4T3qHTkXbvEG31ZgClMBuOx9ZBQhcrUibZRWdM0O54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=QWXQs0BP; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="QWXQs0BP"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5958931c9c7so6650503e87.2
        for <linux-crypto@vger.kernel.org>; Tue, 25 Nov 2025 02:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1764065431; x=1764670231; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CoaJM3tbP6s0WEBHNB87IlUePi5s/wLQQ5WO7asb+Os=;
        b=QWXQs0BPpp1xVA5x5sw4CPgqFWYLuAq6OGtktZmgDyNDV6G6fBXrGWFDQMFzL+lT5O
         xhaD07z+Y4KNFkwI1OFeX0wPHhX3gIRM3wX8lsN1NNy7vkAQTFJQP/LeRFfH0vkqfrZn
         vAdQOUR1PZJtVlr5JwtEWBax/ZYfAz0k7sX0sk4qHhWKZDCIvwGhi2JC+wEQYn944/lk
         RES42lhFIgpib5mXymsLDNDDquXO3k7/+JXtp8oGqd/gzQWNFKaxoz27FYeT+CeSfK/H
         YelYyQsmmQ+IP1iRCsfZnxRtDZxfFCeQmt5Eg/dPGHnVZ3idmWHmFpGPgHJg4Y5AoghY
         AKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764065431; x=1764670231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CoaJM3tbP6s0WEBHNB87IlUePi5s/wLQQ5WO7asb+Os=;
        b=mtab/3rAUvxF9Z6DPPNO22Ib4HwRReMYq9nC7jY9ty+jdArLi0cebJ4Ov52GPe3b0F
         nCtgGBmq0E4WEziCpW2O6qg7ZEoCE8sm/TwK0N+pcaZKTGp9gn2X53csZ2qwkHyylR55
         WesZgUMznlsa6bmBk121O7T0ZJJFTR6QvFwDH4b3L7yy7cABPPTj0TxjtiXAUiQsB9Fn
         0BGR+DQD8GAfUxjfkv5yT9Jq4lSHDJylWoHf2QvehfCo7he6Oz/mNtyvEwN+VFagA5ck
         0ezy69fZWRv8EbLtJiMLVb14ke7MTIzdiWYfSQdc5QZ9EkjbOoKKb4R7uCVN/LS6bdgJ
         R3Yw==
X-Forwarded-Encrypted: i=1; AJvYcCU3Q3Mjin86QusJGb7FfAEU1YCfdzCwO9RCSzL7FuNphH2368HmlgKOcf7kHIUdR6kQjPh3Bv97WJiMXME=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMUvmJBvkG9NJla/7PlY2ce1J5JoGoPBrChCPdOPykOtmvG+zv
	4jCmQBL363zDYShlhZ1/wS8r/B/IPcx4I2qqztSPCI4UCBnvHuHym9e9akM2x9nv1pCL/1Pqlh8
	lEhRO2+CynrdEjuOTMllN7P/SthEpsZNRp2riaFAlXg==
X-Gm-Gg: ASbGncufzpXtnj/EObJLC9tVIF87PelONe1QCfdESn99Db9LAl7Kbr7DZg5BZAJ5RTS
	nJU07DKUtBMK1SHDI+Tq6haMeV8qqnW72pAT5GgUNh/gSKiDj9tHY1apYwtQgBWBTCBadqxzmYi
	Q1m2rqcSOCvuy7/UAEZCtBL710UBtj3QRjZM6aBPVJDPfaxBzVBx3ASLsew1kjf/F130OjKhnii
	lzrPRSzx1ntKxZgnwYug5JTCVQl3bcBd56llaS/G4+ciw5fT999Jvf+KwPoXdcwLdqohyYVRDW/
	NzHPjpXPD4Dk
X-Google-Smtp-Source: AGHT+IFvSGCTLekIhr+vTYlBkAUyih+Shu03vLozC1zL2Y/ubyb161xSSgTppX7gvmMsmnA2cdjWMijm+7drjmcnv7w=
X-Received: by 2002:a05:6512:3d87:b0:57d:6fca:f208 with SMTP id
 2adb3069b0e04-596b5298c92mr989113e87.45.1764065430967; Tue, 25 Nov 2025
 02:10:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117145606.2155773-1-dhowells@redhat.com> <20251117145606.2155773-3-dhowells@redhat.com>
 <20251117171003.GC1584@sol>
In-Reply-To: <20251117171003.GC1584@sol>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Tue, 25 Nov 2025 10:10:18 +0000
X-Gm-Features: AWmQ_bkMV41j6i3d0klYOD3P3cdE9Dv5lpAQaEMNsXklzABWM8NTcersdE3Dzog
Message-ID: <CALrw=nG6X5Opjb1H4VVzCNpJ4QtmHUK3nQ1XQ5GKMvnE9NnZsQ@mail.gmail.com>
Subject: Re: [PATCH v9 2/9] crypto: Add ML-DSA/Dilithium verify support
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>, Stephan Mueller <smueller@chronox.de>, 
	Lukas Wunner <lukas@wunner.de>, linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, Nov 17, 2025 at 5:11=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Mon, Nov 17, 2025 at 02:55:51PM +0000, David Howells wrote:
> >  lib/crypto/Kconfig                            |   1 +
> >  lib/crypto/Makefile                           |   2 +
> >  lib/crypto/mldsa/Kconfig                      |  29 ++
> >  lib/crypto/mldsa/Makefile                     |  20 +
> >  lib/crypto/mldsa/crypto_mldsa_44.c            | 166 ++++++++
> >  lib/crypto/mldsa/crypto_mldsa_65.c            | 166 ++++++++
> >  lib/crypto/mldsa/crypto_mldsa_87.c            | 166 ++++++++
> >  lib/crypto/mldsa/dilithium.h                  | 304 ++++++++++++++
> >  lib/crypto/mldsa/dilithium_44.c               |  33 ++
> >  lib/crypto/mldsa/dilithium_44.h               | 291 ++++++++++++++
> >  lib/crypto/mldsa/dilithium_65.c               |  33 ++
> >  lib/crypto/mldsa/dilithium_65.h               | 291 ++++++++++++++
> >  lib/crypto/mldsa/dilithium_87.c               |  33 ++
> >  lib/crypto/mldsa/dilithium_87.h               | 291 ++++++++++++++
> >  lib/crypto/mldsa/dilithium_common.c           | 117 ++++++
> >  lib/crypto/mldsa/dilithium_debug.h            |  49 +++
> >  lib/crypto/mldsa/dilithium_ntt.c              |  89 +++++
> >  lib/crypto/mldsa/dilithium_ntt.h              |  35 ++
> >  lib/crypto/mldsa/dilithium_pack.h             | 119 ++++++
> >  lib/crypto/mldsa/dilithium_poly.c             | 377 ++++++++++++++++++
> >  lib/crypto/mldsa/dilithium_poly.h             | 181 +++++++++
> >  lib/crypto/mldsa/dilithium_poly_c.h           | 141 +++++++
> >  lib/crypto/mldsa/dilithium_poly_common.h      |  35 ++
> >  lib/crypto/mldsa/dilithium_polyvec.h          | 343 ++++++++++++++++
> >  lib/crypto/mldsa/dilithium_polyvec_c.h        |  81 ++++
> >  lib/crypto/mldsa/dilithium_reduce.h           |  85 ++++
> >  lib/crypto/mldsa/dilithium_rounding.c         | 128 ++++++
> >  lib/crypto/mldsa/dilithium_service_helpers.h  |  99 +++++
> >  lib/crypto/mldsa/dilithium_signature_c.c      | 279 +++++++++++++
> >  lib/crypto/mldsa/dilithium_signature_c.h      |  37 ++
> >  lib/crypto/mldsa/dilithium_signature_impl.h   | 370 +++++++++++++++++
> >  lib/crypto/mldsa/dilithium_type.h             | 108 +++++
> >  lib/crypto/mldsa/dilithium_zetas.c            |  68 ++++
> >  .../mldsa/signature_domain_separation.c       | 204 ++++++++++
> >  .../mldsa/signature_domain_separation.h       |  30 ++
> >  35 files changed, 4801 insertions(+)
>
> Over the past week I've been starting to review this massive addition.
>
> I don't think this is on the right track.  This implementation is really
> messy, with lots of unused functionality and unnecessary abstractions,
> and code that doesn't follow kernel conventions.
>
> In comparison, BoringSSL has an entire implementation of ML-DSA,
> *including key generation and signing*, in a bit over 3000 lines in one
> file.  But about half of that code is specific to key generation or
> signing, which the kernel doesn't need, so in principle
> verification-only shouldn't be much more than a thousand.  I find it to
> be much easier to understand than leancrypto as well.
>
> Historically we've had a lot of problems with people integrating code
> from external sources into the kernel, like mpi, with properly "owning"
> it because they feel like it's not their code and someone else is
> responsible.  I feel like that's going to be a big problem here.
>
> I think we can do better here and put together a smaller implementation
> for the kernel that we'll actually be able to maintain.

I was thinking about this lately for some time - even put forward a
small discussion proposal for upcoming Plumbers (which wasn't accepted
unfortunately). Should we consider somehow safely "outsourcing" at
least some (asymmetric - potentially slow anyway) crypto
implementations to userspace? Something similar to
request_module/request_firmware/request_key usermode helpers or an
io_uring interface or a crypto socket? This way we can bring any
well-maintained crypto library (and even multiple ones) to the kernel:
  * it can have any software license
  * can be written in any programming language
  * can use architecture vector instructions more easily
  * can have any certifications out of the box (looking at you - FIPS)
  * distros would have the ability to plug their own
  * maybe it can even do private key crypto (which I personally would
really like more support of and it would be acceptable to Herbert)

Given the past experience of RSA and mpi - it is not that difficult to
port something to the kernel, but quite hard to maintain it over time
in a secure manner. With a userspace approach the kernel can
piggy-back on proven vendors like any other piece of open source
software out there.

I understand that there probably still be a need for some in-kernel
crypto, so the proposal here is not to fully replace things, but
rather complement the current offerings with an interface, which could
enable faster adoption of newer (and more secure versions of existing)
crypto algorithms.

> - Eric

Ignat
