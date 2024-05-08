Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2D971B24;
	Wed,  8 May 2024 09:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715158899; cv=none; b=eVrFA4vbdTeDqFuQ7jubJ88FnrLwzcNFN3ZAqvx5zOboQcDIHh4bxmqxCVW9HSQ3ght6et8H1zT4X4AaZwS3dCykiQsSFalOpzqRrOtpc4ZjMa3i1zf7VY+CvCnGafZP3HQ9W5OYZunqpQtTrqYAANCc+Ji0WUBw3/DRKeA7KP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715158899; c=relaxed/simple;
	bh=2+NkL7/xFV8fjHBWJGNNByOB3Pm5bJPK0iJ7GOonRZg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LT8P7e0NDpzqVhHCgjjudWFKmOdMtyjtqpOWrZs8ViK6+rgmAK+vumkkfP2iL/mwPZ+TFDoOXOtvi0H+4HAB/AlqoCSjSwoKMEa7BerQ7Rb1GSJAWdo2oePxvINWRQFB56XquPw7FNtG0v7dyijvdQHhTUEBZK0Ay3Wlp7vX0bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d8Hshsn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d8Hshsn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D552BC113CC;
	Wed,  8 May 2024 09:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715158898;
	bh=2+NkL7/xFV8fjHBWJGNNByOB3Pm5bJPK0iJ7GOonRZg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=d8Hshsn0aOE1yUfO+V6rDvKuLWxBi6AYvqq8FQRYmIr6SI7O5akU2NYjNk4xO7wbV
	 sOjXuxToraQJlGib4S8zKhQq4YikRw1OU9KFY8GlnogaLxLX2SPNUh7dBlL7ocWqFL
	 RGwJLB6TkUcIZ1Ol0s2ZCVbTZhQ8dXzvSDdRuqIwxr4HOlZQ5q8dL8fV+vqGh1laO9
	 2TLBFwuacXIB18x9x6B7kNw6+TmtVwRLaSKyCA00QESBuf86wEumI6fy5ugFdgmSQp
	 8mWHhdiheblyfykQxZc4M0eXYZylXl918RYbIK3R3XDPb+Rhh8KNlUhHZOpzcGnmbF
	 FxsgjbG9gZctw==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-51f1b378ca5so6866651e87.1;
        Wed, 08 May 2024 02:01:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV/TcVSFtbHaT8f+bJm2ebVt8q3hu0tP8yuKfxFcUcph4eaPcn0z+rP6QaPCjO7C7ZjrkV0G1GTrhw4VSUe5H3kY+OwGu1VbatqLM3a
X-Gm-Message-State: AOJu0YwebXoMmi32MgZ02vFyMvggknCPOtkBlvbdv2Pqyzo6zGD6zCOh
	dG/dRzNL6Xdy7ECHhOoXeRUTLDykTp1nnyf51zZQabBrqrBAtQ1gCZ+OKThTKi8jRvpvuuF83zj
	Rl50c2n6BZCi9pbemPBJvTBmEOyI=
X-Google-Smtp-Source: AGHT+IF5DbO+GqCsyJ09mGRZTux66fFOe1L/vNw5oAAYvZGX3dQ4vaVNGvk1IT309mpyVP8oqGarFJoMgvjohgcR8rU=
X-Received: by 2002:a05:6512:202c:b0:51f:3e0c:ace3 with SMTP id
 2adb3069b0e04-5217c5670cdmr1520132e87.16.1715158897192; Wed, 08 May 2024
 02:01:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240508071734.199462-1-ebiggers@kernel.org>
In-Reply-To: <20240508071734.199462-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 8 May 2024 11:01:25 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHnBA5qeyHa-b6w+cw5-iomA=3drk7yGGzp-gc_-4uKig@mail.gmail.com>
Message-ID: <CAMj1kXHnBA5qeyHa-b6w+cw5-iomA=3drk7yGGzp-gc_-4uKig@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/aes-gcm - add VAES and AVX512 / AVX10
 optimized AES-GCM
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 8 May 2024 at 09:22, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add implementations of AES-GCM for x86_64 CPUs that support VAES (vector
> AES), VPCLMULQDQ (vector carryless multiplication), and either AVX512 or
> AVX10.  There are two implementations, sharing most source code: one
> using 256-bit vectors and one using 512-bit vectors.
>
> I wrote the new AES-GCM assembly code from scratch, focusing on
> performance, code size (both source and binary), and documenting the
> source.  The new assembly file aes-gcm-avx10-x86_64.S is about 1200
> lines including extensive comments, and it generates less than 8 KB of
> binary code.  This includes both 256-bit and 512-bit vector code; note
> that only one is used at runtime.  The main loop does 4 vectors at a
> time, with the AES and GHASH instructions interleaved.  Any remainder is
> handled using a simple 1 vector at a time loop, with masking.
>

This looks very good! The code is well structured and due to the
comments, it is reasonably easy to follow for someone familiar with
the underlying math.

I also strongly prefer a parameterized implementation that assembles
to a minimal object code size over the other proposed implementations,
where there may be a slight marginal performance gain due to the use
of different code paths for different input sizes, but this tends to
be beneficial mostly for benchmarks and not for real-world use cases.

...
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Tested-by: Ard Biesheuvel <ardb@kernel.org> # Tiger Lake
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

Some nits below.


> ---
>  arch/x86/crypto/Kconfig                |    1 +
>  arch/x86/crypto/Makefile               |    3 +
>  arch/x86/crypto/aes-gcm-avx10-x86_64.S | 1201 ++++++++++++++++++++++++
>  arch/x86/crypto/aesni-intel_glue.c     |  515 +++++++++-
>  4 files changed, 1706 insertions(+), 14 deletions(-)
>  create mode 100644 arch/x86/crypto/aes-gcm-avx10-x86_64.S
>
...
> diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> index 5b25d2a58aeb..e4dec49023af 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -1212,17 +1212,481 @@ static struct simd_skcipher_alg *aes_xts_simdalg_##suffix
>  DEFINE_XTS_ALG(aesni_avx, "xts-aes-aesni-avx", 500);
>  #if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
>  DEFINE_XTS_ALG(vaes_avx2, "xts-aes-vaes-avx2", 600);
>  DEFINE_XTS_ALG(vaes_avx10_256, "xts-aes-vaes-avx10_256", 700);
>  DEFINE_XTS_ALG(vaes_avx10_512, "xts-aes-vaes-avx10_512", 800);
> -#endif
> +
> +#define NUM_KEY_POWERS         16 /* excludes zero padding */
> +#define FULL_NUM_KEY_POWERS    (NUM_KEY_POWERS + 3) /* includes zero padding */
> +
> +struct aes_gcm_key_avx10 {
> +       struct crypto_aes_ctx aes_key AESNI_ALIGN_ATTR;
> +       u32 rfc4106_nonce AESNI_ALIGN_ATTR;

Is the alignment needed here?

> +       u8 ghash_key_powers[FULL_NUM_KEY_POWERS][16] AESNI_ALIGN_ATTR;
> +};
> +
> +asmlinkage void
> +aes_gcm_precompute_vaes_avx10_256(struct aes_gcm_key_avx10 *key);
> +asmlinkage void
> +aes_gcm_precompute_vaes_avx10_512(struct aes_gcm_key_avx10 *key);
> +
> +asmlinkage void
> +aes_gcm_aad_update_vaes_avx10(const struct aes_gcm_key_avx10 *key,
> +                             u8 ghash_acc[16], const u8 *aad, int aadlen);
> +
> +asmlinkage void
> +aes_gcm_enc_update_vaes_avx10_256(const struct aes_gcm_key_avx10 *key,
> +                                 const u32 le_ctr[4], u8 ghash_acc[16],
> +                                 const u8 *src, u8 *dst, int datalen);
> +asmlinkage void
> +aes_gcm_enc_update_vaes_avx10_512(const struct aes_gcm_key_avx10 *key,
> +                                 const u32 le_ctr[4], u8 ghash_acc[16],
> +                                 const u8 *src, u8 *dst, int datalen);
> +
> +asmlinkage void
> +aes_gcm_dec_update_vaes_avx10_256(const struct aes_gcm_key_avx10 *key,
> +                                 const u32 le_ctr[4], u8 ghash_acc[16],
> +                                 const u8 *src, u8 *dst, int datalen);
> +asmlinkage void
> +aes_gcm_dec_update_vaes_avx10_512(const struct aes_gcm_key_avx10 *key,
> +                                 const u32 le_ctr[4], u8 ghash_acc[16],
> +                                 const u8 *src, u8 *dst, int datalen);
> +
> +asmlinkage void
> +aes_gcm_enc_final_vaes_avx10(const struct aes_gcm_key_avx10 *key,
> +                            const u32 le_ctr[4], const u8 ghash_acc[16],
> +                            u64 total_aadlen, u64 total_datalen,
> +                            u8 *tag, int taglen);
> +asmlinkage bool
> +aes_gcm_dec_final_vaes_avx10(const struct aes_gcm_key_avx10 *key,
> +                            const u32 le_ctr[4], const u8 ghash_acc[16],
> +                            u64 total_aadlen, u64 total_datalen,
> +                            const u8 *tag, int taglen);
> +
> +static int gcm_setkey_vaes_avx10(struct crypto_aead *tfm, const u8 *raw_key,
> +                                unsigned int keylen, bool vl256)
> +{
> +       struct aes_gcm_key_avx10 *key = aes_align_addr(crypto_aead_ctx(tfm));
> +       int err;
> +
> +       /* The assembly code assumes the following offsets. */
> +       BUILD_BUG_ON(offsetof(typeof(*key), aes_key.key_enc) != 0);
> +       BUILD_BUG_ON(offsetof(typeof(*key), aes_key.key_length) != 480);
> +       BUILD_BUG_ON(offsetof(typeof(*key), ghash_key_powers) != 512);
> +
> +       if (likely(crypto_simd_usable())) {

Is it really necessary to have 3 different code paths here? If so,
could you add a comment why?

> +               err = aes_check_keylen(keylen);
> +               if (err)
> +                       return err;
> +               kernel_fpu_begin();
> +               aesni_set_key(&key->aes_key, raw_key, keylen);
> +               if (vl256)
> +                       aes_gcm_precompute_vaes_avx10_256(key);
> +               else
> +                       aes_gcm_precompute_vaes_avx10_512(key);
> +               kernel_fpu_end();
> +       } else {
> +               static const u8 x_to_the_minus1[16] __aligned(__alignof__(be128)) = {
> +                       [0] = 0xc2, [15] = 1
> +               };
> +               be128 h1 = {};
> +               be128 h;
> +               int i;
> +
> +               err = aes_expandkey(&key->aes_key, raw_key, keylen);
> +               if (err)
> +                       return err;
> +               /*
> +                * Emulate the aes_gcm_precompute assembly function in portable
> +                * C code: Encrypt the all-zeroes block to get the hash key H^1,
> +                * zeroize the padding at the end of ghash_key_powers, and store
> +                * H^1 * x^-1 through H^NUM_KEY_POWERS * x^-1, byte-reversed.
> +                */
> +               aes_encrypt(&key->aes_key, (u8 *)&h1, (u8 *)&h1);
> +               memset(key->ghash_key_powers, 0, sizeof(key->ghash_key_powers));
> +               h = h1;
> +               gf128mul_lle(&h, (const be128 *)x_to_the_minus1);
> +               for (i = NUM_KEY_POWERS - 1; i >= 0; i--) {
> +                       put_unaligned_be64(h.a, &key->ghash_key_powers[i][8]);
> +                       put_unaligned_be64(h.b, &key->ghash_key_powers[i][0]);
> +                       gf128mul_lle(&h, &h1);
> +               }
> +       }
> +       return 0;
> +}
> +
