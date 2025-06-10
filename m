Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94D328B4EE;
	Tue, 10 Jun 2025 09:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749548536; cv=none; b=Ql6FWpKc0A4Xtd/TMqAtzg9pSa0AJjJiOPhtxVbvDdBZvY/udVcbi/y4JJRzyxiWE0gPpGcqn548VNATSQihI9WAvG/WnMnm1n24oLxlJ7BltDoZdQQdh1vBBJIMXd7+zDylTbHizPWgcIhQeZhYNkTLkRvqemhdP1UibLVWgeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749548536; c=relaxed/simple;
	bh=/ZxvP0oXkjJy+5u41lz5bv9/pvpCiauZA5c0sjPGHEA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X5kGZLxWdKHXB/M+HmAoOW+iAHHjilsxXDwdKvjzRPYXKeJtZ3iC/EwWA/TomfshL/srOKYeWv8RnC+V49XPJzapdIzKTyLN53maqv1o7s1Li/AIJ5JZYWxbBWuVR2iPs/2r8EgpLsZ9LIUcaUq/AuS+7rLV9Rf55BB4h48YxB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5HVfJNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5HVfJNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55072C4AF09;
	Tue, 10 Jun 2025 09:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749548536;
	bh=/ZxvP0oXkjJy+5u41lz5bv9/pvpCiauZA5c0sjPGHEA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=O5HVfJNHNCSkqVEMce8ASokg8YVj2MdM/GP56FmUql8/tLMqjYA8RMf9PigLKyl4r
	 7mkcCxQlVOabzA65NzJkR6w7dU59KVYJ23SypF6P4aWcQ0y4yA3lKXJ4MfKFx+u6XB
	 5VioVCy5V/el6nOU35ru1yRovIzuBqLuxMqRm1xYwB593aPVTqorGrpD5Y1D67oJeR
	 ugkHTJl+zB+0KshRiD4eLcY/IED7E9cUy55axac2VuacJBfMVc0xBp8Jk41SJwM0K8
	 uFrGaOvQkNOh8SHeB7k+RQG1bp4o5nKJrlyq+As1yvnW98KZfj5JO8obV9/PNQnjZx
	 nxAJbCmqy2fFg==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-553331c3dc7so5141760e87.3;
        Tue, 10 Jun 2025 02:42:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUTrvg1d1ZvjfoSsDNy//zvea4Z6Tc+a/JY3ntntBHkYNnS2SUP24mVCAwQp7uu7z+6GEdwOSapsOju/GU=@vger.kernel.org, AJvYcCWmLzcBWA7zYKy7NiydFJQfydtr6MAyvvZmxzqfyt4UWLb3X/aFhRjFU8K1TmEvb8IXOC2bYWcWmFHmtC+s@vger.kernel.org
X-Gm-Message-State: AOJu0YwicY/Gb3Q6pxHe7cwCnMTzZVcb5IishcIzxIM6c2rs0M/iQCsk
	dVnPakFWgT845DJer1BHuTi7Z2tvkV1oayMzOh4C7j+0oTVxIztfaova3wqcfRc2vdIMxd+evn2
	Q4UK6JR7BpYN4xBA+nNQxYN/ch3/GqDw=
X-Google-Smtp-Source: AGHT+IHFP3Oy85HSzSqRP8n10niIF/0kKGzvaY5viHdHYpXcPjgwjHZOvayjXzEjjBB8lxl6vQPt1zZftvr8IKqwH4I=
X-Received: by 2002:a05:6512:2396:b0:553:34be:26ab with SMTP id
 2adb3069b0e04-55366bdf6d1mr4568686e87.15.1749548534647; Tue, 10 Jun 2025
 02:42:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250610093256.2645686-1-arnd@kernel.org>
In-Reply-To: <20250610093256.2645686-1-arnd@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 10 Jun 2025 11:42:03 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHezfFoea2nV7oAg1=-5PUg2eL=bhv_k8CsCzyuLMiAUA@mail.gmail.com>
X-Gm-Features: AX0GCFvxaVLt4SFdT1LsUqlRO-nSGitqEJWMHYXBOr6h4AzdfUgVIX0DFrWeK_s
Message-ID: <CAMj1kXHezfFoea2nV7oAg1=-5PUg2eL=bhv_k8CsCzyuLMiAUA@mail.gmail.com>
Subject: Re: [PATCH] ARM: crypto: work around gcc-15 warning
To: Arnd Bergmann <arnd@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>, 
	Eric Biggers <ebiggers@google.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Jun 2025 at 11:33, Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> I get a very rare -Wstringop-overread warning with gcc-15 for one function
> in aesbs_ctr_encrypt():
>
> arch/arm/crypto/aes-neonbs-glue.c: In function 'ctr_encrypt':
> arch/arm/crypto/aes-neonbs-glue.c:212:1446: error: '__builtin_memcpy' offset [17, 2147483647] is out of the bounds [0, 16] of object 'buf' with type 'u8[16]' {aka 'unsigned char[16]'} [-Werror=array-bounds=]
>   212 |                         src = dst = memcpy(buf + sizeof(buf) - bytes,
> arch/arm/crypto/aes-neonbs-glue.c: In function 'ctr_encrypt':
> arch/arm/crypto/aes-neonbs-glue.c:218:17: error: 'aesbs_ctr_encrypt' reading 1 byte from a region of size 0 [-Werror=stringop-overread]
>   218 |                 aesbs_ctr_encrypt(dst, src, ctx->rk, ctx->rounds, bytes, walk.iv);
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/arm/crypto/aes-neonbs-glue.c:218:17: note: referencing argument 2 of type 'const u8[0]' {aka 'const unsigned char[]'}
> arch/arm/crypto/aes-neonbs-glue.c:218:17: note: referencing argument 3 of type 'const u8[0]' {aka 'const unsigned char[]'}
> arch/arm/crypto/aes-neonbs-glue.c:218:17: note: referencing argument 6 of type 'u8[0]' {aka 'unsigned char[]'}
> arch/arm/crypto/aes-neonbs-glue.c:36:17: note: in a call to function 'aesbs_ctr_encrypt'
>    36 | asmlinkage void aesbs_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
>
> This could happen in theory if walk.nbytes is larger than INT_MAX and gets
> converted to a negative local variable.
>
> Keep the type unsigned like the orignal nbytes to be sure there is no
> integer overflow.
>
> Fixes: c8bf850e991a ("crypto: arm/aes-neonbs-ctr - deal with non-multiples of AES block size")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/arm/crypto/aes-neonbs-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
> index c60104dc1585..df5afe601e4a 100644
> --- a/arch/arm/crypto/aes-neonbs-glue.c
> +++ b/arch/arm/crypto/aes-neonbs-glue.c
> @@ -206,7 +206,7 @@ static int ctr_encrypt(struct skcipher_request *req)
>         while (walk.nbytes > 0) {
>                 const u8 *src = walk.src.virt.addr;
>                 u8 *dst = walk.dst.virt.addr;
> -               int bytes = walk.nbytes;
> +               unsigned int bytes = walk.nbytes;
>
>                 if (unlikely(bytes < AES_BLOCK_SIZE))
>                         src = dst = memcpy(buf + sizeof(buf) - bytes,
> --
> 2.39.5
>
