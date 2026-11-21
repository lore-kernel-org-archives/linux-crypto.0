Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795290796;
	b=D/dGWnNiUHiwL4DI1oxjZnofcn3Dpto7hjiOEOVcggF/HVkyUKyE7S9jzmmgU+8VyQe+
	 u+TZGqn2XkpbrHjYieLI6ldHBrDLgLUM/bxa9EV5vocOK+exZBgR/MBvDuEL8nFK2+OoT
	 IF1SzpiHX9VfITKQrGvv7I8FtUq3G5yxStAxvBejscEzkdFOmKaBOYAGVxmmNSDkcBL9B
	 m7X4kUKP4TkWNY0PoACDMyg1wT+XK5xhAISo4KgNRMdMhH5A1FxtpG3szeDVZrnsP50q2
	 8hbUYT5iSjaegkemnepHV5/ZH2dQqmyIkiqadRzdg5m6zx2DvO1gkkJUUROl+LGPm0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795290796;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=DXYBYDPxHVts5G5F8eJXofNOmEqiLThdpJ2yx8olKaY=;
	b=gRBy+BwF+BkhgB8ur6KoI7XkVTnTKfjHP0Q8laMhUualnd+mHspXvmVKKrMmfT/LroYO
	 IN5epMzdv7f/UZJf/t6imw5D/ElOVBN1XIJ0Tuh9HH9bPUmN65vVtAXnqw/oex2PUIf3S
	 imyyCQn+pemfbz3+uE7oH9xth+NvZ8QMcgVbf5VasDoVa/tWc9cgfWzjCOESIzgZg9PWN
	 2JnJld7IPCDGaB+/bW7aOEnJcju+fhMtTJUCmH0WkTUrSfRhItu1O51krl1IbEEOOqcFv
	 +K8KIPHqjbypHlVi0dFftl+49FaDa4CB4T4JJhUaEHJJMLYKgeU9M0hPQQpQv3ULnPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zddi1iH9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261A3606A320
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 19:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zddi1iH9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BA71F000C0;
	Sat, 21 Nov 2026 19:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795290795;
	bh=DXYBYDPxHVts5G5F8eJXofNOmEqiLThdpJ2yx8olKaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zddi1iH95ENqc3rBfsc8PLGXhNwvitEBBTF6CQQq6bel1c/l9vGihcK6Hnc1bq6Gk
	 FKFO8VoIIgb5RZVqDe1QWY8/Bo/bdLTZ/TrwmlAJOnTO5WqGK5SVH/lRMJ/nOEGapL
	 QRHoJJBZwp77EjSneUR7KbOdXdGswHOKOJRKKHxS6uHp4tQMZMK2JDPwi2NQzeEIHl
	 CVC3sH7JX0L8gwzRAnsGr5r1pR7x6u/Yi8kyLstPzaPsLEySIld08EZqudS0ztOWeh
	 b1Y1zde1dfSnut7WIq275IDOWIhUyHV/TWM4GtirFxGLSTD9kI69V9QeDxchH100u9
	 iFv08EpN9HPOA==
Date: Sat, 21 Nov 2026 11:53:14 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/7] lib/crypto: KUnit tests for unauthenticated AES modes
Message-ID: <20261121195314.GE1975@quark>
References: <20261116062849.1071038-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116062849.1071038-1-ebiggers@kernel.org>

On Sun, Nov 15, 2026 at 10:28:42PM -0800, Eric Biggers wrote:
> This series applies to libcrypto-next.  It can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git aes-kunit-v1
> 
> This series adds comprehensive KUnit test suites for the remaining AES
> modes that got new library APIs in v7.3: AES-ECB, AES-CBC, AES-CBC-CTS,
> AES-CTR, AES-XCTR, and AES-XTS.
> 
> Most of the test code is placed in a common header file, like it is in
> many of the existing tests.
> 
> Eric Biggers (7):
>   lib/crypto: tests: Add skcipher-test-template.h and
>     gen-skcipher-testvecs.py
>   lib/crypto: tests: Add KUnit test suite for AES-ECB
>   lib/crypto: tests: Add KUnit test suite for AES-CBC
>   lib/crypto: tests: Add KUnit test suite for AES-CBC-CTS
>   lib/crypto: tests: Add KUnit test suite for AES-CTR
>   lib/crypto: tests: Add KUnit test suite for AES-XCTR
>   lib/crypto: tests: Add KUnit test suite for AES-XTS
> 
>  lib/crypto/.kunitconfig                   |    4 +
>  lib/crypto/tests/Kconfig                  |   36 +
>  lib/crypto/tests/Makefile                 |    4 +
>  lib/crypto/tests/aead-test-template.h     |   67 +-
>  lib/crypto/tests/aes_cbc_cts_kunit.c      |  239 ++++
>  lib/crypto/tests/aes_cbc_kunit.c          |  137 +++
>  lib/crypto/tests/aes_ctr_kunit.c          |  196 ++++
>  lib/crypto/tests/aes_ecb_kunit.c          |  227 ++++
>  lib/crypto/tests/aes_xctr_kunit.c         |  149 +++
>  lib/crypto/tests/aes_xts_kunit.c          |  365 ++++++
>  lib/crypto/tests/skcipher-test-template.h | 1241 +++++++++++++++++++++
>  lib/crypto/tests/sp800-38a-data.h         |   36 +
>  lib/crypto/tests/test-utils.h             |   25 +
>  scripts/crypto/gen-skcipher-testvecs.py   |  167 +++
>  14 files changed, 2846 insertions(+), 47 deletions(-)
>  create mode 100644 lib/crypto/tests/aes_cbc_cts_kunit.c
>  create mode 100644 lib/crypto/tests/aes_cbc_kunit.c
>  create mode 100644 lib/crypto/tests/aes_ctr_kunit.c
>  create mode 100644 lib/crypto/tests/aes_ecb_kunit.c
>  create mode 100644 lib/crypto/tests/aes_xctr_kunit.c
>  create mode 100644 lib/crypto/tests/aes_xts_kunit.c
>  create mode 100644 lib/crypto/tests/skcipher-test-template.h
>  create mode 100644 lib/crypto/tests/sp800-38a-data.h
>  create mode 100755 scripts/crypto/gen-skcipher-testvecs.py

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
