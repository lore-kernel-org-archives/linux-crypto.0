Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A4F238C15;
	Tue,  8 Jul 2025 03:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751944972; cv=none; b=sahQyTv2EAZBbwTxF9HQWtdQ/pdyT3xy76CY6SNyF2O/cwcEsp1/9EyaiZLqqN54u1xLXpQsHtyoyXFFcaTbFX2gDDAO3BYt+8VDiPiQZLGQth/UCTPXdgKcfAACsD8D49tLzL71Js+V935UXLErSatY72FRsiHcHnux63xakRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751944972; c=relaxed/simple;
	bh=9H4IIccotUnEJ0jLpuuFE179dM/I/HHnNlZqvuVjozo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E2BdO87UVOZWmKkwjnF1dY9JpR/aC/fX5gcYxbsHTbSfzupv+0etVQ4Jfl38H7mkCZ+QHdG4H2fq+NYlWanOcDQG3DQZKGJ5iJMUxqH7P//Y8Bd2k0LVQyPJ4c65WbO4nyc1kxHikJ0wz3OcI2msEZ+M0v4Kt4JlBM1LvIJJqzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y9SAxK/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y9SAxK/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E33AC4CEE3;
	Tue,  8 Jul 2025 03:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751944972;
	bh=9H4IIccotUnEJ0jLpuuFE179dM/I/HHnNlZqvuVjozo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Y9SAxK/o4nH3WLJahoqUNxkDso+50RGGUdfWNGpHS7/7sKijjFC3ZMZkzbta24aai
	 nwCoisz6CwEudnSSdHdAhxoZorLb5tDQkAeT/7VZInHEvyXvPi2pWxLfvfgB6bXfe2
	 1jClM/ChUpdm70A7DSJ9NIzHaR3HY2E4Tlfkxug1zUxX7LV/qGfX68kcZuTvPEvSJ6
	 phIHqTD2Ydjjtz3Fuf1b2Jm2jHz5d3YvU16Dcq3T/Tq40/2F70YB0a2zR86ibhX5CU
	 pivzalF+Mp42j35ELtw2BpzPRjEa3h+wnwr7HWMYcZkkDfyfm/Vc+bct9ncHW9uElv
	 H8nQ9ZWfo6Fbw==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-553b5165cf5so4617400e87.0;
        Mon, 07 Jul 2025 20:22:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUuJTumYosaZh1sM7o6+4afvInZExBrRTCK8egHkvCYQuqQmomI7FL2xlmvynO9HTeAPbUx1NM/Cy0qhtk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4dQT0IK+u255hHL93Qh5xdq1vRnQOJGjJvuW+BDJgOAJM/AK9
	b1TnmaupqcFQQa4YfhuooouQKHEy/fc4CxsQeuicTTvIXzuI/dkUoch1hFzsEh7A0obzUnzYENR
	OPWo29byaM3hM7hXZZvlOUV919Ww6o1U=
X-Google-Smtp-Source: AGHT+IHfwjnhQDW4vHFZN+V9yZXUSxBn4uEviRCQeobt6aIgg+7vXB3BHniEBK2OzJBTx7v4sCsH4uyRP7lFFAZ9ptY=
X-Received: by 2002:ac2:568a:0:b0:553:acbf:e003 with SMTP id
 2adb3069b0e04-557f8304874mr371133e87.13.1751944970584; Mon, 07 Jul 2025
 20:22:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250706231100.176113-1-ebiggers@kernel.org>
In-Reply-To: <20250706231100.176113-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 8 Jul 2025 13:22:39 +1000
X-Gmail-Original-Message-ID: <CAMj1kXEdeeuceNXpoFjjwH_SnhEYm-sgZtFuA-bOy=5zYjkx4g@mail.gmail.com>
X-Gm-Features: Ac12FXxVJEAkPh9C9EkTUxMjafGC2WjYO85Or9sKH7pRffl1eXeWxZ7xJ2FdfZI
Message-ID: <CAMj1kXEdeeuceNXpoFjjwH_SnhEYm-sgZtFuA-bOy=5zYjkx4g@mail.gmail.com>
Subject: Re: [PATCH 0/5] lib/crypto: Poly1305 fixes
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, linux-arm-kernel@lists.infradead.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Jul 2025 at 09:11, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series is also available at:
>
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git poly1305-fixes
>
> This series fixes the arm, arm64, and x86 Poly1305 functions to not
> corrupt random tasks' registers when called in the "wrong" context.  It
> also fixes a performance regression on x86 with short messages.
>
> This series is needed for my upcoming poly1305_kunit test to pass.
>
> Eric Biggers (5):
>   lib/crypto: arm/poly1305: Remove unneeded empty weak function
>   lib/crypto: arm/poly1305: Fix register corruption in no-SIMD contexts
>   lib/crypto: arm64/poly1305: Fix register corruption in no-SIMD
>     contexts
>   lib/crypto: x86/poly1305: Fix register corruption in no-SIMD contexts
>   lib/crypto: x86/poly1305: Fix performance regression on short messages
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

>  lib/crypto/arm/poly1305-glue.c   |  8 ++----
>  lib/crypto/arm64/poly1305-glue.c |  3 +-
>  lib/crypto/x86/poly1305_glue.c   | 48 +++++++++++++++++++++++++++++++-
>  3 files changed, 51 insertions(+), 8 deletions(-)
>
>
> base-commit: f1da28dfadd26ef95bbd0b1ddf066e7ffe1505ff
> --
> 2.50.0
>
