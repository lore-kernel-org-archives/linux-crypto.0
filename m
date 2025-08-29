Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6C7321F35;
	Fri, 29 Aug 2025 16:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756485441; cv=none; b=hloG11uuP/Iyh3EsYCiYbDA+R/Hn1pDD8NDto427bw3vdkxlUGdTPa7JAqjspROtD5KOjKwdWqXmZKkya+cCzl7U0OJO2xH48+jpTmojqRLUUZGkNHG24O+4/DUluqSGi0wikKKnx2/6Es4rlTTeDZQIeGOZfcDIWJ/wsXt0o1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756485441; c=relaxed/simple;
	bh=laVidNR8SlBiEWwgorpzwfMHHcaTnsLCWPojvEXAxJY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mWqy0QYk0lvRSvMy6OV4pXx+/A/9Bf9t+QC7VFsZrIDjEHMBMd7DsbqNy4WEYwM3G/4NM9djFzCT85XSgKchXabwU9Qn97VsWdFcOx2OBdvO1X0MRkRNSxUc2moN1bHRgS6qLSqwFhtkoLrkv56HKSt0zfWksIVRmJVfv5BSP2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g8C/kudv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8C/kudv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C637C4CEF5;
	Fri, 29 Aug 2025 16:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756485439;
	bh=laVidNR8SlBiEWwgorpzwfMHHcaTnsLCWPojvEXAxJY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=g8C/kudvMHddibHLfm5Tvj/VmdEEUVKlXtNIHUNvtQv5oNa5go0ExIjmPVe8RKLHD
	 n1pJLCqWe6p+F36uRw5ysGHx6gf4Qa3C4MPOPZ6E/spNmvfdsWkCCs9uZXG4hGxj7C
	 hMQss6wQ4GnP753SRQQ4ULhsioVbkKXIUiTD762t9vbuzn8C1UCiAFZPMuHpMkVnjc
	 bZZeG2W25beDAL//BiBu/Jg0Vc7Gy33fSW/o91udvucM/eK6Nm6JsvlnmEY9o9Y4pc
	 gkwHmCnsVlaOuNMweikKouaupGvsg8EMTidg5NjPou/w4YOn+nS4IOZLisrcoqgtXz
	 c4+Z+TEziVQyQ==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55f6ad5146eso508230e87.0;
        Fri, 29 Aug 2025 09:37:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX5QQqhDSR3VVCswDyn7Mv30BMG72L0U8C+CMM1D6ySmtd6Wu13OC2zwVlEjtl6Xa/kpdeQKC7CB5/iEBk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZzxDmCNTDHYGeFZRK8jwA5ffVYMArrPY0wDslTYWO9H4ZQs/E
	NIpcjFextMMvJsvv/mo3U+p4qXvmIW14xG1IaKuh5VLzJyY05NBVtSmd15+AwE1s+9f9mhR1lpW
	AnB0HKWADxiu51nOb/0XInqabxogtVWk=
X-Google-Smtp-Source: AGHT+IF28aBpTecVgGsMjqyVUkBEoOmUAwHkrCd3i405RClXUM/JVBvF8LbtpIXrA7hauzs5l7yCbFeiR2vWbJ+LfOc=
X-Received: by 2002:a05:6512:2284:b0:55a:4fd2:2908 with SMTP id
 2adb3069b0e04-55f0cd46a07mr6768176e87.25.1756485437374; Fri, 29 Aug 2025
 09:37:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250827151131.27733-1-ebiggers@kernel.org>
In-Reply-To: <20250827151131.27733-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 29 Aug 2025 18:37:05 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEwK0znXcR=rp=r0cw+JjBM1i7=mK=u6-=RSB=4dsnHzw@mail.gmail.com>
X-Gm-Features: Ac12FXzxmMtdYZy3o3WZKlR4MJPzQQTe0eVtWk9Bz00LfYOQ1SwsUwZqQVEDOY0
Message-ID: <CAMj1kXEwK0znXcR=rp=r0cw+JjBM1i7=mK=u6-=RSB=4dsnHzw@mail.gmail.com>
Subject: Re: [PATCH 00/12] ChaCha and BLAKE2s cleanups
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, x86@kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 27 Aug 2025 at 17:14, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series is targeting libcrypto-next.  It can also be retrieved from:
>
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git chacha-blake2s-v1
>
> This series consolidates how the ChaCha and BLAKE2s code is organized.
> This is essentially the same change that I made to the other algorithms,
> so this should be fairly boring by now.
>
> These algorithms were the last two users of
> lib/crypto/$(SRCARCH)/{Makefile,Kconfig}.  So this series removes all
> those files, finishing the transition to the centralized build process
> (at least for the algorithms supported by lib/crypto/ so far).
>
> This series also makes the arch-optimized BLAKE2s code start being
> enabled by default, again following the pattern of the other algorithms.
>
> Finally, it adds a KUnit test suite for BLAKE2s and deletes the older
> blake2s-selftest.
>
> Eric Biggers (12):
>   arm: configs: Remove obsolete assignments to CRYPTO_CHACHA20_NEON
>   crypto: chacha - register only "-lib" drivers
>   lib/crypto: chacha: Remove unused function chacha_is_arch_optimized()
>   lib/crypto: chacha: Rename chacha.c to chacha-block-generic.c
>   lib/crypto: chacha: Rename libchacha.c to chacha.c
>   lib/crypto: chacha: Consolidate into single module
>   lib/crypto: x86/blake2s: Reduce size of BLAKE2S_SIGMA2
>   lib/crypto: blake2s: Remove obsolete self-test
>   lib/crypto: blake2s: Always enable arch-optimized BLAKE2s code
>   lib/crypto: blake2s: Move generic code into blake2s.c
>   lib/crypto: blake2s: Consolidate into single C translation unit
>   lib/crypto: tests: Add KUnit tests for BLAKE2s
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
