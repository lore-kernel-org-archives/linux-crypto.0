Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB0814F12D;
	Mon,  9 Dec 2024 10:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733739750; cv=none; b=JRqoLbfyf25yEXNJbs9b85cpQG625WOkrrMU2KlMFQiTlPWco5zPs7/EQP8g5IgAvjQB0ZayqcjALjBCO7pSFU00Kr2/ZKEbtZ7Ty3/Kds8h1PrjkjNTlNCwWk7zLLpzxrgepIzCgt+AQwiOM2esD3GDEejjxswO14qAftluZh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733739750; c=relaxed/simple;
	bh=22nxoMKIS4nBsQAMbnBfE7/P29io2si+j1rmNgZHQZA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pYUc3VXdq6tZgu8LTKBZcd8DjpyhubhxClKbZNc+fHWsVcWFaYg0JDs57Nhu5DufoQDimULNp85739Uv8Rxl4d2blcQo7nD0cFW4Kfh+ZBiSsL6+M4CTvK8DoxsU4kiSclnc8Dowd4sVtxl8PT//qe9wBoMJ7XKRXCwkET0guZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CC/VpXkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CC/VpXkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48502C4CED1;
	Mon,  9 Dec 2024 10:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733739750;
	bh=22nxoMKIS4nBsQAMbnBfE7/P29io2si+j1rmNgZHQZA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CC/VpXkLAbwk+hbgEsMt2944Dv7YIgoIHLCDr29oGcj6oUelUg781rDQKoZZQJHRu
	 JxL+H1rruNSrLz7iG26GPN+xOtjuBrzcufUdCno+7idQNgWqiqgwYRguKSaIftoaB/
	 2zEsYk6JBnkVQmllPmtThfuxKG0nfoWmct+qdDoWlCkcLNbUpiuYTQglWRHlawIaDn
	 II1SvPOKrenPPueseMmN3UtupVK6F67BmJnos+OF7oVUiI08TiFH7UwZtR/4lOO+NJ
	 DRa9Xeg/yrMgfOcBH00Ncti07Ozj1+SzJzjif8qWEHsLyEaPXj2Z2A3idHSoNrjtYp
	 ZpTafz05GAj6Q==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-540215984f0so434596e87.1;
        Mon, 09 Dec 2024 02:22:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWphI+ed47LFTXC9JgCRDZampeovGEVwy9J3Y1FkrN52D18WAH7R6EpuyZOgz3cuwOBtruyti2fblDwYHc=@vger.kernel.org, AJvYcCXRK/Oqb9VvLWFEnKm8i47otUb98hxVo76JvcIhIih20mtiFhA3mgSfRWhh2zLYJVMAIhU/IJK0jLJ27A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyuHm4Xd8bDDNAwkLE9IhFC89obzcpzjrUFLdFLfEI7hx6Mzl1H
	fwckrn9VrQbUMbblG3zXMOjYtn1di1lOgvVlOgB4oLyo250o14pDsjJiZDZnFei9dbacJU4Pvec
	qdAoYckYcw5CY6UYlsHeoREeRvmA=
X-Google-Smtp-Source: AGHT+IGFssUIpp1+A41u1YqFPwvNyIYFStMPw58ruyP0rtnXTDWH0dwiUB/fKF6HcwS0f3nXCgmnFxMLELm2+C/9rm0=
X-Received: by 2002:a05:6512:1381:b0:540:1ea7:44db with SMTP id
 2adb3069b0e04-5401ea7459dmr1337671e87.4.1733739748677; Mon, 09 Dec 2024
 02:22:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241207190503.53440-1-ebiggers@kernel.org>
In-Reply-To: <20241207190503.53440-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 9 Dec 2024 11:22:17 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEd2Qz=rqcjqCCQhRP3dn2y+irnLXpj1uNwed167PewUg@mail.gmail.com>
Message-ID: <CAMj1kXEd2Qz=rqcjqCCQhRP3dn2y+irnLXpj1uNwed167PewUg@mail.gmail.com>
Subject: Re: [PATCH 0/2] crypto: remove physical address support in skcipher_walk
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 7 Dec 2024 at 20:05, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series removes the unnecessary physical address support in
> skcipher_walk and the single obsolete driver that was using it.
>
> Eric Biggers (2):
>   crypto: drivers - remove Niagara2 SPU driver
>   crypto: skcipher - remove support for physical address walks
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

>  crypto/skcipher.c                  |  187 +--
>  drivers/crypto/Kconfig             |   17 -
>  drivers/crypto/Makefile            |    2 -
>  drivers/crypto/n2_asm.S            |   96 --
>  drivers/crypto/n2_core.c           | 2168 ----------------------------
>  drivers/crypto/n2_core.h           |  232 ---
>  include/crypto/internal/skcipher.h |   12 -
>  7 files changed, 26 insertions(+), 2688 deletions(-)
>  delete mode 100644 drivers/crypto/n2_asm.S
>  delete mode 100644 drivers/crypto/n2_core.c
>  delete mode 100644 drivers/crypto/n2_core.h
>
>
> base-commit: b5f217084ab3ddd4bdd03cd437f8e3b7e2d1f5b6
> --
> 2.47.1
>
>
