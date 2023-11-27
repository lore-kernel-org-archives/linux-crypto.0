Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="ag7MrEnE"
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA37110
	for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 18:14:33 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6c398717726so2920538b3a.2
        for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 18:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701051273; x=1701656073; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qQuCTKkjoab2EfyY20C3fybDK6Ql2G05fa9QjwE7uds=;
        b=ag7MrEnEez3mjHPzhmWO7eP5KpzOrOq8iR7X7TlOKpQ09p/TFNsC3a+9thyah0Dffw
         ICI6SOOyga/rXyUoM6Mvb7StVcKBS+8ia+4EkPVW/NgoSIO5QVW4gsvNC8wILMrJSj9s
         cSXyE/Ckgyz4DjiTa7USt/ou67dxNYFz1y4BHylxS0yD+LKWDRczNgs5cvsRXdd4uu9q
         OWmGwO5XD1Og+/UgFSaZ5ce1+KhAk+sEoLO53b0Ps7X95vaOou1ioo1ABNLITOnG7XbN
         nsXDsE/8ElW172x7/DqodrE4ZZvq0eEVSpHcCcTjOzonIO52tQvsBCgdFzPE5qsaQotn
         HQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701051273; x=1701656073;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qQuCTKkjoab2EfyY20C3fybDK6Ql2G05fa9QjwE7uds=;
        b=qHD2JBJiO/460XvmvLzavBozrr0LIOBYWNkOydl8iezpqYNX0DBxw66yNaEK1oZ8tc
         6voPkm+ayewUIkKx3ULGmAGcUcZNHOguaItg/HtQtIrwnYHGMbfFiWINNrGGz0Qry6vf
         nojWZGZnczdyOTdABIaXSedhId+seyiEFwKFLSAMengf6IfkRqKyMeJKGbpAf0hTqQ6f
         gYp0Bbw039RwYOjAZcA4nwLW8tN7BYAL3Tnc9RBtj5bC27wxwR+TvNV4UjL9HXBcKUjH
         y4pt5bTGj9O7HblP3hvKcKBovkDBSrlQ7mnF2ngfUadVga9i+XwuIqA06u1Q4nYycYl6
         GoFw==
X-Gm-Message-State: AOJu0YyGPZg/MJ/q+BRuE8HuWq8/I522kv/EMyhYGFn5EswVSo7kK88t
	HtDtZ3BRY3rTl57yR/XqT94ThQ==
X-Google-Smtp-Source: AGHT+IGCytZMxu7H10W/RpstzoB24pSc/2pOM0mtxh/XBOupAfkyHHRrNPwHxAWsSzb0+rVLqYYqmg==
X-Received: by 2002:a05:6a20:8403:b0:18b:a011:f955 with SMTP id c3-20020a056a20840300b0018ba011f955mr10693520pzd.60.1701051273409;
        Sun, 26 Nov 2023 18:14:33 -0800 (PST)
Received: from ?IPv6:2402:7500:4ce:95c7:2856:b238:775:b338? ([2402:7500:4ce:95c7:2856:b238:775:b338])
        by smtp.gmail.com with ESMTPSA id q16-20020a63cc50000000b0059b782e8541sm6831644pgi.28.2023.11.26.18.14.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Nov 2023 18:14:32 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH 12/12] RISC-V: crypto: add Zvkb accelerated ChaCha20
 implementation
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231122012933.GG2172@sol.localdomain>
Date: Mon, 27 Nov 2023 10:14:27 +0800
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 palmer@dabbelt.com,
 Albert Ou <aou@eecs.berkeley.edu>,
 herbert@gondor.apana.org.au,
 davem@davemloft.net,
 andy.chiu@sifive.com,
 greentime.hu@sifive.com,
 conor.dooley@microchip.com,
 guoren@kernel.org,
 bjorn@rivosinc.com,
 heiko@sntech.de,
 ardb@kernel.org,
 phoebe.chen@sifive.com,
 hongrong.hsu@sifive.com,
 linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <69B2D415-3626-4D6C-B559-0724EC1CD853@sifive.com>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-13-jerry.shih@sifive.com>
 <20231122012933.GG2172@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 22, 2023, at 09:29, Eric Biggers <ebiggers@kernel.org> wrote:
> On Thu, Oct 26, 2023 at 02:36:44AM +0800, Jerry Shih wrote:
>> diff --git a/arch/riscv/crypto/chacha-riscv64-glue.c =
b/arch/riscv/crypto/chacha-riscv64-glue.c
>> new file mode 100644
>> index 000000000000..72011949f705
>> --- /dev/null
>> +++ b/arch/riscv/crypto/chacha-riscv64-glue.c
>> @@ -0,0 +1,120 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Port of the OpenSSL ChaCha20 implementation for RISC-V 64
>> + *
>> + * Copyright (C) 2023 SiFive, Inc.
>> + * Author: Jerry Shih <jerry.shih@sifive.com>
>> + */
>> +
>> +#include <asm/simd.h>
>> +#include <asm/vector.h>
>> +#include <crypto/internal/chacha.h>
>> +#include <crypto/internal/simd.h>
>> +#include <crypto/internal/skcipher.h>
>> +#include <linux/crypto.h>
>> +#include <linux/module.h>
>> +#include <linux/types.h>
>> +
>> +#define CHACHA_BLOCK_VALID_SIZE_MASK (~(CHACHA_BLOCK_SIZE - 1))
>> +#define CHACHA_BLOCK_REMAINING_SIZE_MASK (CHACHA_BLOCK_SIZE - 1)
>> +#define CHACHA_KEY_OFFSET 4
>> +#define CHACHA_IV_OFFSET 12
>> +
>> +/* chacha20 using zvkb vector crypto extension */
>> +void ChaCha20_ctr32_zvkb(u8 *out, const u8 *input, size_t len, const =
u32 *key,
>> +			 const u32 *counter);
>> +
>> +static int chacha20_encrypt(struct skcipher_request *req)
>> +{
>> +	u32 state[CHACHA_STATE_WORDS];
>=20
> This function doesn't need to create the whole state matrix on the =
stack, since
> the underlying assembly function takes as input the key and counter, =
not the
> state matrix.  I recommend something like the following:
>=20
> diff --git a/arch/riscv/crypto/chacha-riscv64-glue.c =
b/arch/riscv/crypto/chacha-riscv64-glue.c
> index df185d0663fcc..216b4cd9d1e01 100644
> --- a/arch/riscv/crypto/chacha-riscv64-glue.c
> +++ b/arch/riscv/crypto/chacha-riscv64-glue.c
> @@ -16,45 +16,42 @@
> #include <linux/module.h>
> #include <linux/types.h>
>=20
> -#define CHACHA_KEY_OFFSET 4
> -#define CHACHA_IV_OFFSET 12
> -
> /* chacha20 using zvkb vector crypto extension */
> asmlinkage void ChaCha20_ctr32_zvkb(u8 *out, const u8 *input, size_t =
len,
> 				    const u32 *key, const u32 *counter);
>=20
> static int chacha20_encrypt(struct skcipher_request *req)
> {
> -	u32 state[CHACHA_STATE_WORDS];
> 	u8 block_buffer[CHACHA_BLOCK_SIZE];
> 	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
> 	const struct chacha_ctx *ctx =3D crypto_skcipher_ctx(tfm);
> 	struct skcipher_walk walk;
> 	unsigned int nbytes;
> 	unsigned int tail_bytes;
> +	u32 iv[4];
> 	int err;
>=20
> -	chacha_init_generic(state, ctx->key, req->iv);
> +	iv[0] =3D get_unaligned_le32(req->iv);
> +	iv[1] =3D get_unaligned_le32(req->iv + 4);
> +	iv[2] =3D get_unaligned_le32(req->iv + 8);
> +	iv[3] =3D get_unaligned_le32(req->iv + 12);
>=20
> 	err =3D skcipher_walk_virt(&walk, req, false);
> 	while (walk.nbytes) {
> -		nbytes =3D walk.nbytes & (~(CHACHA_BLOCK_SIZE - 1));
> +		nbytes =3D walk.nbytes & ~(CHACHA_BLOCK_SIZE - 1);
> 		tail_bytes =3D walk.nbytes & (CHACHA_BLOCK_SIZE - 1);
> 		kernel_vector_begin();
> 		if (nbytes) {
> 			ChaCha20_ctr32_zvkb(walk.dst.virt.addr,
> 					    walk.src.virt.addr, nbytes,
> -					    state + CHACHA_KEY_OFFSET,
> -					    state + CHACHA_IV_OFFSET);
> -			state[CHACHA_IV_OFFSET] +=3D nbytes / =
CHACHA_BLOCK_SIZE;
> +					    ctx->key, iv);
> +			iv[0] +=3D nbytes / CHACHA_BLOCK_SIZE;
> 		}
> 		if (walk.nbytes =3D=3D walk.total && tail_bytes > 0) {
> 			memcpy(block_buffer, walk.src.virt.addr + =
nbytes,
> 			       tail_bytes);
> 			ChaCha20_ctr32_zvkb(block_buffer, block_buffer,
> -					    CHACHA_BLOCK_SIZE,
> -					    state + CHACHA_KEY_OFFSET,
> -					    state + CHACHA_IV_OFFSET);
> +					    CHACHA_BLOCK_SIZE, ctx->key, =
iv);
> 			memcpy(walk.dst.virt.addr + nbytes, =
block_buffer,
> 			       tail_bytes);
> 			tail_bytes =3D 0;

Fixed.
We will only use the iv instead of the full chacha state matrix.

