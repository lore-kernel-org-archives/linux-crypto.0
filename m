Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDE95B692
	for <linux-crypto@vger.kernel.org>; Sat, 10 Feb 2024 15:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707578734; cv=none; b=A5endzEd5qqpkkUvMJVgk2MwG0Kq7yFptv/Fpmh0ClGI5iy8klmHjSJlEq9iAHunfVlOjzmGk8hujH1WD3dfqB9Uk5buEmrFA36Y0ZReUgyeac9YuNJ69cAoiaMQkXStxN6KXXY54Xy+4KFf3rFon0vFIVdt5VZfeQGBdEXpmbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707578734; c=relaxed/simple;
	bh=ZVoslugSGMhMVUD18y4BcRNe+EEdIzOmrHzcC8imdcs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=sr35MfV7rinIP9qZl3p0v3dfgKd00XCz1pcjatciumSTooIXjGrugO4O+udri3D6pmeJZwCQqauG0dnrTR+Y6dhUJJhM1XaELLJSKpQTUC0Gcw+NZJufqt3cLqT/EoGpc34EWlKWF+1JGmTsNzTGQeca1m5/sPjjW9Vup5Ece1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=RkXON8je; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="RkXON8je"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d7431e702dso17800425ad.1
        for <linux-crypto@vger.kernel.org>; Sat, 10 Feb 2024 07:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1707578732; x=1708183532; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zlEfppOFDKm/ps4r+9qSEREyPWdjHVQY01GkaqhYUUk=;
        b=RkXON8jemDJc99tr2oHEkPcfBYH696X+iZmLsALmaN20O6EwQVEQWMeC4pnz6L53Qo
         9QMMfhBuKVxREt328aHz3lfhvkpJwdGVyBLb+c1utT/mcBJEN+3rI2CAMLa1jaGA37qU
         PHwdGsWnZXXDHCC9GIw2dN56YIENojydbGKH+vbAuqfKovRNJECaro/r7Y7xlE7UeVF2
         ueTu4EhqERfT8YWs47hRoHp6je4ei+EvoQd2meKMWsusKJ7qHFE4SOiBbaQ4TbJghlcG
         7DNLQcOuS2+dSovLynpV7ATyz0w1Kn268DhIjWRv/j3UVHGNyV918wbANoCzj0KAnCXu
         Hayw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707578732; x=1708183532;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zlEfppOFDKm/ps4r+9qSEREyPWdjHVQY01GkaqhYUUk=;
        b=BhruYdjnjCju03a9xWTje5QrmCLGteS+8yBHYIbWwUnnL6sn5n5ZM8+GPbcNvMjIOy
         nhHzxT9dZUZryOGNaRnvBFdHL5zMAupyTKhC1qDguO6vzeT7q3kGuMmhqQPeQoSDhXyQ
         rg//iRTzgcs9/DSh3wF1Y97lOivqkKRdVSLukL5SLvTwYH+ovD8aGbPCChwclVjAwLQK
         6dW6QnXqbQOHUtkRYtKpF6hdgEQ78PoT/1HZwHl2MaSOHxhWZICrXwHSZZw1j2U2oWVI
         C/DlkbgJO92qjN7K9Jj3GgIzlr4YP8cnHpJRizg3Ng1Uo2imMG5n4YcWiyKIRM3UdNQH
         foYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaKzwXXYqYXJGpzn6TorIbBxYpsy4g8ymq4dnSymjgB2wCbkZoDc6AkowgmVG5X2jiAcCc7lIjqCeKbYBx+SJ7Rzo7wTyBbRDciwVR
X-Gm-Message-State: AOJu0Yx166YbH6V8IlYf9KgIgeuYIKXR86DDdrdnwhrdIZT2TeDokBtE
	GwXsqe6y8nE1vGzKv7orLspQOz4qby9+4i0YENY1fKauq+L9gdVdO1DkOnhVG2E=
X-Google-Smtp-Source: AGHT+IHHJAdhfjj7JqBp9ra8No8Slk0aKWukt6ixBwWc0Y8yC6NlQl6qyqfgwIYeixkLe/3fdE0YwQ==
X-Received: by 2002:a17:903:246:b0:1d8:e4b8:95d6 with SMTP id j6-20020a170903024600b001d8e4b895d6mr2403272plh.27.1707578732216;
        Sat, 10 Feb 2024 07:25:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCViMKCSm4GQ+Nyv4rH8MvySBgoBa9MijGWRQk21Y7FDsRt20JvMXK7RMNnqR6RfWEluMxVI8up0CBcFbub81M1lVCv03wsd+liPjQHeKHJNbmRFkkgM0dGahQjdF6ZfOaOdxy1pguMkG/RSISqrHxSGPv5MfrP3YwieobvVlUHmFDQFAlD9uFyDl9/qY1Lbxxv9V6pYE6PXALf4u2q1/WssJrrOZmL2nrQK8ZMsbbc980rupySVBzshmauxMw==
Received: from ?IPv6:2402:7500:5dc:b102:45ed:2306:e8a6:d144? ([2402:7500:5dc:b102:45ed:2306:e8a6:d144])
        by smtp.gmail.com with ESMTPSA id kp15-20020a170903280f00b001d90fe6da6esm3172756plb.305.2024.02.10.07.25.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Feb 2024 07:25:31 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH riscv/for-next] crypto: riscv - parallelize AES-CBC
 decryption
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20240208060851.154129-1-ebiggers@kernel.org>
Date: Sat, 10 Feb 2024 23:25:27 +0800
Cc: linux-riscv@lists.infradead.org,
 Palmer Dabbelt <palmer@dabbelt.com>,
 linux-crypto@vger.kernel.org,
 =?utf-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>,
 Heiko Stuebner <heiko@sntech.de>,
 Phoebe Chen <phoebe.chen@sifive.com>,
 Andy Chiu <andy.chiu@sifive.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <04703246-6EF6-4B54-B8F1-96EDEC2FBA6B@sifive.com>
References: <20240208060851.154129-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Feb 8, 2024, at 14:08, Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> Since CBC decryption is parallelizable, make the RISC-V implementation
> of AES-CBC decryption process multiple blocks at a time, instead of
> processing the blocks one by one.  This should improve performance.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/riscv/crypto/aes-riscv64-zvkned.S | 24 +++++++++++++++---------
> 1 file changed, 15 insertions(+), 9 deletions(-)
>=20
> diff --git a/arch/riscv/crypto/aes-riscv64-zvkned.S =
b/arch/riscv/crypto/aes-riscv64-zvkned.S
> index 78d4e1186c074..43541aad6386c 100644
> --- a/arch/riscv/crypto/aes-riscv64-zvkned.S
> +++ b/arch/riscv/crypto/aes-riscv64-zvkned.S
> @@ -132,33 +132,39 @@ SYM_FUNC_END(aes_ecb_decrypt_zvkned)
> 	addi		INP, INP, 16
> 	addi		OUTP, OUTP, 16
> 	addi		LEN, LEN, -16
> 	bnez		LEN, 1b
>=20
> 	vse32.v		v16, (IVP)	// Store next IV
> 	ret
> .endm
>=20
> .macro	aes_cbc_decrypt	keylen
> +	srli		LEN, LEN, 2	// Convert LEN from bytes to =
words
> 	vle32.v		v16, (IVP)	// Load IV
> 1:
> -	vle32.v		v17, (INP)	// Load ciphertext block
> -	vmv.v.v		v18, v17	// Save ciphertext block
> -	aes_decrypt	v17, \keylen	// Decrypt
> -	vxor.vv		v17, v17, v16	// XOR with IV or prev =
ciphertext block
> -	vse32.v		v17, (OUTP)	// Store plaintext block
> -	vmv.v.v		v16, v18	// Next "IV" is prev ciphertext =
block
> -	addi		INP, INP, 16
> -	addi		OUTP, OUTP, 16
> -	addi		LEN, LEN, -16
> +	vsetvli		t0, LEN, e32, m4, ta, ma
> +	vle32.v		v20, (INP)	// Load ciphertext blocks
> +	vslideup.vi	v16, v20, 4	// Setup prev ciphertext blocks
> +	addi		t1, t0, -4
> +	vslidedown.vx	v24, v20, t1	// Save last ciphertext block

Do we need to setup the `e32, len=3Dt0` for next IV?
I think we only need 128bit IV (with VL=3D4).

> +	aes_decrypt	v20, \keylen	// Decrypt the blocks
> +	vxor.vv		v20, v20, v16	// XOR with prev ciphertext =
blocks
> +	vse32.v		v20, (OUTP)	// Store plaintext blocks
> +	vmv.v.v		v16, v24	// Next "IV" is last ciphertext =
block

Same VL issue here.

> +	slli		t1, t0, 2	// Words to bytes
> +	add		INP, INP, t1
> +	add		OUTP, OUTP, t1
> +	sub		LEN, LEN, t0
> 	bnez		LEN, 1b
>=20
> +	vsetivli	zero, 4, e32, m1, ta, ma
> 	vse32.v		v16, (IVP)	// Store next IV
> 	ret
> .endm
>=20
> // void aes_cbc_encrypt_zvkned(const struct crypto_aes_ctx *key,
> //			       const u8 *in, u8 *out, size_t len, u8 =
iv[16]);
> //
> // |len| must be nonzero and a multiple of 16 (AES_BLOCK_SIZE).
> SYM_FUNC_START(aes_cbc_encrypt_zvkned)
> 	aes_begin	KEYP, 128f, 192f
>=20
> base-commit: cb4ede926134a65bc3bf90ed58dace8451d7e759
> --=20
> 2.43.0
>=20

