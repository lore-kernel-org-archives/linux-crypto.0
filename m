Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139F527F754;
	Fri, 29 Aug 2025 16:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756485471; cv=none; b=f45WHxheZwq2J/9H5VxCOAu6pGKPRhG6TAbdbzS8L9X9SZO4+Yjoadsiu0z3vwHhJmFXUNiwAjRXbaBnpWLhJcR00v5RvqIa4fgo/DAHHjWR1/OAQF9pmc31zVtHm4AI2ZD0CHsv3yZ+eBBMPfTySNv3x0T2SteIKXpm/ZtXicA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756485471; c=relaxed/simple;
	bh=fiQj3uu5qngcYi46mmPDjoITF7Gt3V5Fs4N0MfKDFtc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vx8b0VlagA10lo0F4ATAx8xlFMqguK5KkG0QSvLhTvkVAJH9ApU3sve17TAaOh42Jhj4UaHuCLP5/J6qC/a5ubjx8zTCEfEk4f1cgudeQuURDa3B4GYN8UTjNfzciLP/mAuK/4nD647FRjOtwO8qbA4Qv5XF5OhXG2tRFYsOeZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h52r/ull; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h52r/ull"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12E3C4CEF5;
	Fri, 29 Aug 2025 16:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756485470;
	bh=fiQj3uu5qngcYi46mmPDjoITF7Gt3V5Fs4N0MfKDFtc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=h52r/ulljkiYJSMK7XBsmmx/2QiBhdt4PCSXJ+LwR2yHL2KfLEFAGkJmiTMbGTtpZ
	 GKAgApxjMsOaI3uME9WkEyZ4AikThQzqV8jBOk7XkKN3HhZB9vzVwyUeDdWxEyPILm
	 PP3ak0uCyntjz7fa9b8bV0PjbOoEBu0dCGtg+Iv2HLcwssKB6E+vl3F9GesAnTtieN
	 iEdZriDCXxfIJaEyAV/jUn+4OL7/1pmxLa86h1kWq8uwXR3P1JEf7FZblSAhZZayKI
	 zFlp8cO3/JRyjJDh6xKaUYmsnGmW3/pkplv4aWyt3pM/8O7R0xa/lWjwA3jZYi9dfI
	 RTTaU+JWWZ2SA==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55f4bc9bc93so1934885e87.3;
        Fri, 29 Aug 2025 09:37:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW9uxPu4tszMrpkTh729HX7rc2DpLHN529p6GoxJBAINRJdkGRxUgvZbqjv9wy6A8UjapJ+efadnzhtkEU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMo9y2D14vbSs7Isn+vJK1aitKSfzhHHz0zCyyKrQQzUITy4jY
	FzQ17fcOh4YfjqzRrsaJGn1zXpX+36B60ZNizjz9N6mNQwimAsY3xKmnWGLviolnw1DWKWMdVtS
	uTrZr6+4W2/XuGfV2BgIt+tns1eM/sFc=
X-Google-Smtp-Source: AGHT+IGASJCP/xFodrz/Fa9AjwsrrzHLMiL29p4vUyw4mzQBfOk9KwY2Yi8ywguFIbG4etYvoUMGLoWiu2qvLGDzrBM=
X-Received: by 2002:a05:6512:304b:b0:55f:3e8f:ac0b with SMTP id
 2adb3069b0e04-55f3e8fb025mr6445063e87.6.1756485468968; Fri, 29 Aug 2025
 09:37:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250829152513.92459-1-ebiggers@kernel.org>
In-Reply-To: <20250829152513.92459-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 29 Aug 2025 18:37:37 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH0N4tBOVupP27UADDrPy4_0WTXX6ihr8X6LfbhjE3F3w@mail.gmail.com>
X-Gm-Features: Ac12FXxWcprNszC_x2jB4UeYCch8Y0qrkFs5mIDQU9brPhw8YWIKfVp-NAk3GKs
Message-ID: <CAMj1kXH0N4tBOVupP27UADDrPy4_0WTXX6ihr8X6LfbhjE3F3w@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Consolidate Poly1305 code and add RISC-V optimization
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Zhihang Shao <zhihang.shao.iscas@gmail.com>, Andy Polyakov <appro@cryptogams.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 29 Aug 2025 at 17:26, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series is targeting libcrypto-next.  It can also be retrieved from:
>
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git poly1305-v3
>
> This series simplifies and optimizes the organization of the Poly1305
> code by consolidating it into a single module.  This follows the example
> of SHA-1, SHA-256, SHA-512, CRC32, etc.
>
> Since the RISC-V Poly1305 patch has had a moving target, I also rebased
> it on top of this series and included it as patch 3.
>
> Changed in v3:
> - Added mips/poly1305-core.S and riscv/poly1305-core.S to 'targets'.
>   This fixed a bug where the perlasm build step was always running.
>
> Changed in v2:
> - Added missing 'FORCE' to the make rules for mips/poly1305-core.S
>   and riscv/poly1305-core.S.
>
> Eric Biggers (2):
>   lib/crypto: poly1305: Remove unused function
>     poly1305_is_arch_optimized()
>   lib/crypto: poly1305: Consolidate into single module
>
> Zhihang Shao (1):
>   lib/crypto: riscv/poly1305: Import OpenSSL/CRYPTOGAMS implementation
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
