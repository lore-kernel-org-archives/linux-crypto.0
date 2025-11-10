Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562C5274B51
	for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 15:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789910; cv=none; b=TFzC/y7no6tHIqRQL8kVNMCxlQHT6x7sMQunQ8iYvEnbHCWB8CVfdA4dd9ve0WDSYqmAlyA5TMGkuyY7kG1GXVQZo5zHrv9QnD/6J62a5QBeNwsDuw0D7zf0NleK7AvIcBBxOw2rgGHr8+BSVvE9SV9QVyKJLo1ofKSI7jVU0Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789910; c=relaxed/simple;
	bh=GSFlX0y3gsnIwhRYANOlx9NAjCA/sGqwGHm+2KMpqBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kiJP/frEhZiV8zpLCYVoNhZlhX0DzDnpZCY+pjZBz6qAYj9U5F1A+x+kEzzl1DCw1TUhpflTGyG6dHzDIJRLasNk9a3Rtk9jfSzW7FXy/9rENIx8igPBdaIwf1x+Dd8T+vIzIw5sIWQ8g/CFfLCX+YRU5vKcY7RKTRBCIShONs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VVpo+GOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VVpo+GOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58FCC4AF09
	for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 15:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762789909;
	bh=GSFlX0y3gsnIwhRYANOlx9NAjCA/sGqwGHm+2KMpqBY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VVpo+GOYqrcRwErJq+EY6x/R+wfzxftEcuN/IrjlQG/QMzkDpN0VrssvggLGv2Leg
	 gsyc/OyQrE2utGXFZ30DSwFqII9DEVZzVYMXpuWrbLqUjl4znBhT7+kvcaM/eVgGMh
	 byIxNH+3ae3fkR2RySpRfqamwmqAENZdHeehqVzYl8CImJTZXVQlF6KDCfZmaOIsz+
	 S5Iv6HY/Pmnq75vCYxNbj4WhFj287voWG6RF1fe2SuD8azr0ZSJxG48kAaxDuvLEpR
	 pcspZBUePYji66DtPKAdATp8p5PwZ03QRTqZ+laXx0H1FOfg4zTJ7rhCShYxlNV0E6
	 WGtWyzNnceHYw==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-592f7e50da2so3860507e87.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 07:51:49 -0800 (PST)
X-Gm-Message-State: AOJu0Ywoo4sz/m/staxCKmhEa1aFEOp0ahqXvDsX3WcUdl2S0wDXI5a4
	HR5H0XgIQ6V8eXNiqIhqM2Gd88Dec2Mk2DDG2QCxawfJVd+wWx6Q3JAQojFkco0ktKVBLTgzcZU
	5nq4EeYCwzTJGfjtTU3ISc6dIzN/88V8=
X-Google-Smtp-Source: AGHT+IFXuPtKwkkkVh2oaEjkAj6BoMkJvY6oWI0baW4Ym5w1O2+M/t+LwpzAkaGKMejiWXgBe1nKuDFew8RPK+mVPWM=
X-Received: by 2002:a05:6512:1321:b0:592:fc99:5a40 with SMTP id
 2adb3069b0e04-59459992b04mr3246687e87.6.1762789908213; Mon, 10 Nov 2025
 07:51:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109234726.638437-1-ebiggers@kernel.org>
In-Reply-To: <20251109234726.638437-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 10 Nov 2025 16:51:36 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEve+1uPcdECLeyD_N-prXvbe7jhOYoNO66S1eaxg-JNg@mail.gmail.com>
X-Gm-Features: AWmQ_bkZy1tCqLQPs6sUKods1yGx8M4ndxZup1PcnhLiXuTBiAPxNGcqnJd6tS4
Message-ID: <CAMj1kXEve+1uPcdECLeyD_N-prXvbe7jhOYoNO66S1eaxg-JNg@mail.gmail.com>
Subject: Re: [PATCH 0/9] POLYVAL library
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 10 Nov 2025 at 00:49, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series is targeting libcrypto-next.  It can also be retrieved from:
>
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git polyval-lib-v1
>
> This series migrates the POLYVAL code to lib/crypto/.  It turns out that
> just like Poly1305, the library is a much better fit for it.
>
> This series also replaces the generic implementation of POLYVAL with a
> much better one.
>
> Notably, this series improves the performance of HCTR2, since it
> eliminates unnecessary overhead that was being incurred by accessing
> POLYVAL via the crypto_shash API.  I see a 45% increase in throughput
> with 64-byte messages, 53% with 128-byte, or 6% with 4096-byte.
>
> It also eliminates the need to explicitly enable the optimized POLYVAL
> code, as it's now enabled automatically when HCTR2 support is enabled.
>
> Eric Biggers (9):
>   crypto: polyval - Rename conflicting functions
>   lib/crypto: polyval: Add POLYVAL library
>   lib/crypto: tests: Add KUnit tests for POLYVAL
>   lib/crypto: arm64/polyval: Migrate optimized code into library
>   lib/crypto: x86/polyval: Migrate optimized code into library
>   crypto: hctr2 - Convert to use POLYVAL library
>   crypto: polyval - Remove the polyval crypto_shash
>   crypto: testmgr - Remove polyval tests
>   fscrypt: Drop obsolete recommendation to enable optimized POLYVAL
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
