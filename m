Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF162FBFFB;
	Fri,  4 Jul 2025 13:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751635593; cv=none; b=avrB5E6AXuHD7KSF+UsTqfQTxHkTQHdCq2KXoTKikAka00IM+7j5bQHpKg66aUwJr6AzXbKeAvDNpFhiT8JGJDStxIk5iVFrSoBtjxMknxmx3L6aIYPGJANFNJGWvp7gYxzFxnJNWIwU50RO72MnZEUmhTMXRNfTvD7mQI9Rgq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751635593; c=relaxed/simple;
	bh=kyUyzRPmMlTZg3dwhgl4ymERkrT4NxFWJPVtToPGm/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tT49Fxlt/urpwYuAQpdLEu9VpD6ud/TL5xHRSRosWvSj68O/FYIQVlxgFF205X2gVCpPGufw+exeeQCgNFcweAKf9zDbJXiA+h/gMk3ggUZePrWc47E6HMfPpChDNqGFfeT1+1TxE2n4PSL+PFInIdpyMqY9eCO4x/wtER9Yzcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ktFG89Ww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ktFG89Ww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB9EC4CEEB;
	Fri,  4 Jul 2025 13:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751635593;
	bh=kyUyzRPmMlTZg3dwhgl4ymERkrT4NxFWJPVtToPGm/4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ktFG89WwphsC6dzTTdSqf0q8HemxQz8titMQrHuiuVffn1K/DR1iPHHJYd5i+FSuE
	 IrFQ1J9vgBK0BbrZW8uxBfMHy6RJ2hCypDeAuXCYt1SuU9BJ8nqwEvRl2uHwNm1j7r
	 Od+aFCJeFhmBS32kQ0UtGxSZ2bFJWUB2DM8q5+JwpdM1jtpP+HBhOKT9P/dNmGDjKa
	 Ffp0PkYRglZg+6MK6fRw1fBSnPaAJtPoS9onCdaJySeDbLxXM6bItSSGjURMmc7ZHX
	 xGC5nfKWkIej2rtzj0xq6lyRGPnJLlP3T0p2k2So1ALOxVdcJM74ZOLzVV0tlGh5H6
	 a41MFap/D0TZQ==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-32b5226e6beso9173661fa.2;
        Fri, 04 Jul 2025 06:26:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXTo6EI+OIQ0r+P8MAyq8DJhf3OaNtxkSkaEBDIDh74HgQXQIqUhIHMwWxQ14WIn5aTX2WOLwJEuxdeDeQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5dLLnjGVScD0j9shLXua6i5eO8OwFiIBu1of5AbmZYYc4vTzA
	o4hcRoIAnKJ+SZdjymwRtwvQbwaEgfIXelaJwWJKDgDR6I0C2hKBPh1q4Yzs8DJP1rg/DZZDG9P
	jWkn/r399w29ibFedM2goXxJ3SvbaNxo=
X-Google-Smtp-Source: AGHT+IGBsqL3IhV3+I2vp36pAaiPTf+MiBU6Aq7//X/haPqRhPREvOBisg8DPFAiqakPWcQWAspygqlsQ0FezDh+Edc=
X-Received: by 2002:a05:651c:54a:b0:32a:864a:46eb with SMTP id
 38308e7fff4ca-32efb0b23bamr7483541fa.0.1751635591767; Fri, 04 Jul 2025
 06:26:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250704023958.73274-1-ebiggers@kernel.org>
In-Reply-To: <20250704023958.73274-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 4 Jul 2025 15:26:20 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEJ-WBuxj99fXaNU76chVhcXU1bc6X+CP7ogLCSQ2Nz8w@mail.gmail.com>
X-Gm-Features: Ac12FXyFinlhxao-NhpgSrPuNKOlPVYvOG9lQGG-HRMkgXLt0s5YrQcO-YgGvaQ
Message-ID: <CAMj1kXEJ-WBuxj99fXaNU76chVhcXU1bc6X+CP7ogLCSQ2Nz8w@mail.gmail.com>
Subject: Re: [PATCH 0/2] Small cleanups for x86 SHA-256
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 4 Jul 2025 at 04:42, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Two small cleanups for the x86 SHA-256 code.  Applies to libcrypto-next.
>
> Eric Biggers (2):
>   lib/crypto: x86/sha256: Move static_call above kernel-mode FPU section
>   lib/crypto: x86/sha256: Remove unnecessary checks for nblocks==0
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

>  lib/crypto/x86/sha256-avx-asm.S   |  6 ----
>  lib/crypto/x86/sha256-avx2-asm.S  |  4 ---
>  lib/crypto/x86/sha256-ni-asm.S    |  5 ----
>  lib/crypto/x86/sha256-ssse3-asm.S |  5 ----
>  lib/crypto/x86/sha256.h           | 48 ++++++++++++++++---------------
>  5 files changed, 25 insertions(+), 43 deletions(-)
>
>
> base-commit: 5ecd15f4949fd36037725bd719b7d3f866291e6c
> --
> 2.50.0
>
