Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6347E352C5F
	for <linux-crypto@vger.kernel.org>; Thu,  8 Jan 2026 11:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767871109; cv=none; b=Lic1FEtXn+tOCCR9z0L3i6jnwsjV4RuuTbfaGeRCTRs7420CCuMLtVpKKi3pJYmld1Do/sgmtOpZv+Xx6YXVrXCxnekbCZCPzj2uCaYiXrK6tNKyXDrq/6nYZ9Ec/kbzfKgsRRKg7GXDo8yX8lFl/t6Z7qvwFDEbneArHr4zkXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767871109; c=relaxed/simple;
	bh=VpDKvPaUx6cNZ4vYu7itFP8eZbOdqv/lfWhWVNX9fIs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TuEc7uB8LNPOyn9Q9ZLkCYcnjW6z0cEZbllA4coMVW6ujmgqH6mIJLyUIH+MWkrMCYxaYi9XG9nMDK/43w8O49uEdtLLWFnn0Y5SIr2y/u6WWUDSUjtSZIWOYIy6wjKrj0WFYW/Gik69U13zpDEm/SzHkkmD7P4SjrqhAzE+o8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKrFN2xD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKrFN2xD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98531C19422
	for <linux-crypto@vger.kernel.org>; Thu,  8 Jan 2026 11:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767871108;
	bh=VpDKvPaUx6cNZ4vYu7itFP8eZbOdqv/lfWhWVNX9fIs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FKrFN2xD2ADoANZ95fpEAwuMc7tCXesfeWHPmH04OC7rEd2MZQW2jT/xb2KR8zLgw
	 0tm2GeyG6lnEEoQGOH2RjPfP0TnprZLL7YkO3PtGW/GtelIsuselBcb4O01F+uE8gj
	 hYg3pWpa/Swf9xlmEN1Ix6o2DvG2BSqwG8LYKxeC2NU75vrXqJNkDp0+7jVZpxM2UD
	 1GWiNDkDln0/kfnIuXxrZ29WwD7NVyhv0FbJXvNitrIgepOPKFJ3VzGzdvDjGkQcB5
	 cLqi578mGu24fQpK3Z0PL/YKoewQ5tcmIoKsJ3uO27jt3/zPGxNVdE80vgFUgz59vH
	 Ve1mTUk8LeN5g==
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a0bae9aca3so23051185ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 08 Jan 2026 03:18:28 -0800 (PST)
X-Gm-Message-State: AOJu0YzzO1y4+4ZC75KlW8Cj0sYfwOQfmiwuYqleb3cPUd0poD5I/c3r
	dDp4v7kStJHhlb2Aqst/pKazt2dtfFGWJ20jUqPLIvsHTH7gNE+yCz9Y7gjRkky2oeLjNqasjKs
	mhSLcPZujK6HXeQDGYMVLxbAua/mlePU=
X-Google-Smtp-Source: AGHT+IF1qiNf1y52mI5Zwar63TQL83t5OGZvo+C+hx6OKT6cTCR8dn+q3XVA2VQufc3U10kFhcBPlIyNYQSkqkyZ12U=
X-Received: by 2002:a17:902:f54f:b0:298:29e0:5f32 with SMTP id
 d9443c01a7336-2a3ee451ec2mr52902105ad.15.1767871108173; Thu, 08 Jan 2026
 03:18:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107052023.174620-1-ebiggers@kernel.org>
In-Reply-To: <20260107052023.174620-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 8 Jan 2026 12:18:16 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEXyDN+uZHuNKQ9YuaezHeQhp8+Hsu1n67zLk9MSv+L4g@mail.gmail.com>
X-Gm-Features: AQt7F2o2V2O1M9W2awFPviAiDkbkrja1Wr6gBaYYf5jNLofZorvceIO4r_TtIS8
Message-ID: <CAMj1kXEXyDN+uZHuNKQ9YuaezHeQhp8+Hsu1n67zLk9MSv+L4g@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: aes: Fix missing MMU protection for AES S-box
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org, 
	Qingfang Deng <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Jan 2026 at 06:22, Eric Biggers <ebiggers@kernel.org> wrote:
>
> __cacheline_aligned puts the data in the ".data..cacheline_aligned"
> section, which isn't marked read-only i.e. it doesn't receive MMU
> protection.  Replace it with ____cacheline_aligned which does the right
> thing and just aligns the data while keeping it in ".rodata".
>
> Fixes: b5e0b032b6c3 ("crypto: aes - add generic time invariant AES cipher")
> Cc: stable@vger.kernel.org
> Reported-by: Qingfang Deng <dqfext@gmail.com>
> Closes: https://lore.kernel.org/r/20260105074712.498-1-dqfext@gmail.com/
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting libcrypto-fixes
>
>  lib/crypto/aes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Oops

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
> index b57fda3460f1..102aaa76bc8d 100644
> --- a/lib/crypto/aes.c
> +++ b/lib/crypto/aes.c
> @@ -11,11 +11,11 @@
>
>  /*
>   * Emit the sbox as volatile const to prevent the compiler from doing
>   * constant folding on sbox references involving fixed indexes.
>   */
> -static volatile const u8 __cacheline_aligned aes_sbox[] = {
> +static volatile const u8 ____cacheline_aligned aes_sbox[] = {
>         0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
>         0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
>         0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0,
>         0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
>         0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc,
> @@ -46,11 +46,11 @@ static volatile const u8 __cacheline_aligned aes_sbox[] = {
>         0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
>         0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68,
>         0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16,
>  };
>
> -static volatile const u8 __cacheline_aligned aes_inv_sbox[] = {
> +static volatile const u8 ____cacheline_aligned aes_inv_sbox[] = {
>         0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38,
>         0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
>         0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87,
>         0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb,
>         0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d,
>
> base-commit: fdfa4339e805276a458a5df9d6caf0b43ad4c439
> --
> 2.52.0
>
