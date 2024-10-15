Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C022296F8
	for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2024 12:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996113; cv=none; b=fJ+x1TFwCtenBLkLUtQqyf5RklRxvkQipsXKg2xuyNS/jv1Tj62I2zAoB23Ca+XUeNJo/zNrNX91aifKnusR15mW2AsPx7jGjafDcY5mdaIRRiEfoDkcLSDN+EJTIlmZXbAe/KC5RxuKKjXNQLqk9Tn0JI5YDelKcaRY37eqzII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996113; c=relaxed/simple;
	bh=OfviBuLM5yc+5zz4NTiiocvo4IZnn7Fq2wWEKSe8Wt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LWfWIjbRIImOD0E33pXL4nHxdVAHln9iVZ6Ypnpf5dJvoI6v8m9uwYwUjGbGayjzH5QazeTBL0b4YZ1k60ZIx24WzMyOWxWct4iNVkSJ5jN7/BByAK9DuqHamiUYzxkjVALUanRagB0A2NQlWA3FsqXByX5AqgPRFeBQi1Osy/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O+kc0xgr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O+kc0xgr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728996109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=12B52zMIvLi2K16gCWbxFl7NinVJ60oE+hAS5DLVaHE=;
	b=O+kc0xgr1uKWbka1/0DhwNqGnXA8kD+uFrVCmA31P1gGU8cHm1fpnKYVL0MMoHn6tI1F7R
	a3J0Bd6Dm6xJv/9Zhj+O0w65UKLp4mcTquhKxIZX6HwfymOLoQcYsWh72Y+t0vP6fF+Y9d
	cEfk94lmXniLgn2dW7kHmZrAgC4Adb8=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-nxZbGcE0N8apb9SHt8RE8w-1; Tue, 15 Oct 2024 08:41:48 -0400
X-MC-Unique: nxZbGcE0N8apb9SHt8RE8w-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-6818fa37eecso5980259a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2024 05:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728996106; x=1729600906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=12B52zMIvLi2K16gCWbxFl7NinVJ60oE+hAS5DLVaHE=;
        b=TyEPIHPjRqjHPsupRbPfxOM+v48eRhlsao044Wx79CN0aH1Sxk0kZT+Xp+8cKcDrt8
         RWKzyL+KcvkUq6IWBPQ+cbe1elY601W1hkzDhpC1kkNbDDGu47S//JEE0UNAaC05lbKz
         hicscMTKdfSZM5GyjpTfcRr4+Gx5OrqWjs0JUKIWPiuggoSeuCsWlz5sSMlhqKvHPjL/
         yyAFP9PTmuLZWn87fDHVOPZOPgnCqmFe+Z3d3UT7uIzIruqy6H1p28087i0m0M4mvbn7
         +Jm1qLi/2j6LQFD7FtvzYhWEISvV00A06uya8QbmsIMqepNl/HdKSuPIgtj50FEKdiMm
         VXrw==
X-Gm-Message-State: AOJu0Yw3uz1twYputnwkLQith3XUOTMcXXgHwKWnV8rtHtxkOPy1y+/4
	E0xM0TL8JkYweH4A9Tn75ju7IB7qN6k8bBAv5+Nn6RnJvJNS98um0GA4fs17AuLCi3FGoXpjAjU
	vKW15PB2IzTqZ+ESWu0hDKwn+Kc1StSmild/6noDvgz9CND+WJEs0mXfdW6EXx6XJun5Wj78u35
	8K8Ruo5awtycmOB3Zev22L1yHOYGzzwzcNoaKtWkjshr2J
X-Received: by 2002:a05:6a21:3947:b0:1d9:2a8:ce2a with SMTP id adf61e73a8af0-1d902a8d057mr601315637.45.1728996106391;
        Tue, 15 Oct 2024 05:41:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFurt9HvsiPhFwiCmlx1h4NEMdisOa9Jt0B//ynIBB++Xg7UD8RMIpzY6go9YHX1vAxLmhFOXOe3zExMvBK7yA=
X-Received: by 2002:a05:6a21:3947:b0:1d9:2a8:ce2a with SMTP id
 adf61e73a8af0-1d902a8d057mr601295637.45.1728996106028; Tue, 15 Oct 2024
 05:41:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007012430.163606-1-ebiggers@kernel.org> <20241007012430.163606-4-ebiggers@kernel.org>
In-Reply-To: <20241007012430.163606-4-ebiggers@kernel.org>
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Tue, 15 Oct 2024 14:41:34 +0200
Message-ID: <CAFqZXNsoJdJi51CiTxCzsk3Xpt88EeVYDRAzAk8Jgph_DoFKOg@mail.gmail.com>
Subject: Re: [PATCH 03/10] crypto: x86/aegis128 - eliminate some indirect calls
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 7, 2024 at 3:33=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Instead of using a struct of function pointers to decide whether to call
> the encryption or decryption assembly functions, use a conditional
> branch on a bool.  Force-inline the functions to avoid actually
> generating the branch.  This improves performance slightly since
> indirect calls are slow.  Remove the now-unnecessary CFI stubs.

Wouldn't the compiler be able to optimize out the indirect calls
already if you merely force-inline the functions without the other
changes? Then again, it's just a few places that grow the if-else, so
I'm fine with the boolean approach, too.

>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/x86/crypto/aegis128-aesni-asm.S  |  9 ++--
>  arch/x86/crypto/aegis128-aesni-glue.c | 74 +++++++++++++--------------
>  2 files changed, 40 insertions(+), 43 deletions(-)
>
> diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis=
128-aesni-asm.S
> index 2de859173940..1b57558548c7 100644
> --- a/arch/x86/crypto/aegis128-aesni-asm.S
> +++ b/arch/x86/crypto/aegis128-aesni-asm.S
> @@ -5,11 +5,10 @@
>   * Copyright (c) 2017-2018 Ondrej Mosnacek <omosnacek@gmail.com>
>   * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
>   */
>
>  #include <linux/linkage.h>
> -#include <linux/cfi_types.h>
>  #include <asm/frame.h>
>
>  #define STATE0 %xmm0
>  #define STATE1 %xmm1
>  #define STATE2 %xmm2
> @@ -401,11 +400,11 @@ SYM_FUNC_END(crypto_aegis128_aesni_ad)
>
>  /*
>   * void crypto_aegis128_aesni_enc(void *state, unsigned int length,
>   *                                const void *src, void *dst);
>   */
> -SYM_TYPED_FUNC_START(crypto_aegis128_aesni_enc)
> +SYM_FUNC_START(crypto_aegis128_aesni_enc)
>         FRAME_BEGIN
>
>         cmp $0x10, LEN
>         jb .Lenc_out
>
> @@ -498,11 +497,11 @@ SYM_FUNC_END(crypto_aegis128_aesni_enc)
>
>  /*
>   * void crypto_aegis128_aesni_enc_tail(void *state, unsigned int length,
>   *                                     const void *src, void *dst);
>   */
> -SYM_TYPED_FUNC_START(crypto_aegis128_aesni_enc_tail)
> +SYM_FUNC_START(crypto_aegis128_aesni_enc_tail)
>         FRAME_BEGIN
>
>         /* load the state: */
>         movdqu 0x00(STATEP), STATE0
>         movdqu 0x10(STATEP), STATE1
> @@ -555,11 +554,11 @@ SYM_FUNC_END(crypto_aegis128_aesni_enc_tail)
>
>  /*
>   * void crypto_aegis128_aesni_dec(void *state, unsigned int length,
>   *                                const void *src, void *dst);
>   */
> -SYM_TYPED_FUNC_START(crypto_aegis128_aesni_dec)
> +SYM_FUNC_START(crypto_aegis128_aesni_dec)
>         FRAME_BEGIN
>
>         cmp $0x10, LEN
>         jb .Ldec_out
>
> @@ -652,11 +651,11 @@ SYM_FUNC_END(crypto_aegis128_aesni_dec)
>
>  /*
>   * void crypto_aegis128_aesni_dec_tail(void *state, unsigned int length,
>   *                                     const void *src, void *dst);
>   */
> -SYM_TYPED_FUNC_START(crypto_aegis128_aesni_dec_tail)
> +SYM_FUNC_START(crypto_aegis128_aesni_dec_tail)
>         FRAME_BEGIN
>
>         /* load the state: */
>         movdqu 0x00(STATEP), STATE0
>         movdqu 0x10(STATEP), STATE1
> diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegi=
s128-aesni-glue.c
> index 96586470154e..deb39cef0be1 100644
> --- a/arch/x86/crypto/aegis128-aesni-glue.c
> +++ b/arch/x86/crypto/aegis128-aesni-glue.c
> @@ -54,20 +54,10 @@ struct aegis_state {
>
>  struct aegis_ctx {
>         struct aegis_block key;
>  };
>
> -struct aegis_crypt_ops {
> -       int (*skcipher_walk_init)(struct skcipher_walk *walk,
> -                                 struct aead_request *req, bool atomic);
> -
> -       void (*crypt_blocks)(void *state, unsigned int length, const void=
 *src,
> -                            void *dst);
> -       void (*crypt_tail)(void *state, unsigned int length, const void *=
src,
> -                          void *dst);
> -};
> -
>  static void crypto_aegis128_aesni_process_ad(
>                 struct aegis_state *state, struct scatterlist *sg_src,
>                 unsigned int assoclen)
>  {
>         struct scatter_walk walk;
> @@ -112,24 +102,41 @@ static void crypto_aegis128_aesni_process_ad(
>                 memset(buf.bytes + pos, 0, AEGIS128_BLOCK_SIZE - pos);
>                 crypto_aegis128_aesni_ad(state, AEGIS128_BLOCK_SIZE, buf.=
bytes);
>         }
>  }
>
> -static void crypto_aegis128_aesni_process_crypt(
> -               struct aegis_state *state, struct skcipher_walk *walk,
> -               const struct aegis_crypt_ops *ops)
> +static __always_inline void
> +crypto_aegis128_aesni_process_crypt(struct aegis_state *state,
> +                                   struct skcipher_walk *walk, bool enc)
>  {
>         while (walk->nbytes >=3D AEGIS128_BLOCK_SIZE) {
> -               ops->crypt_blocks(state,
> -                                 round_down(walk->nbytes, AEGIS128_BLOCK=
_SIZE),
> -                                 walk->src.virt.addr, walk->dst.virt.add=
r);
> +               if (enc)
> +                       crypto_aegis128_aesni_enc(
> +                                       state,
> +                                       round_down(walk->nbytes,
> +                                                  AEGIS128_BLOCK_SIZE),
> +                                       walk->src.virt.addr,
> +                                       walk->dst.virt.addr);
> +               else
> +                       crypto_aegis128_aesni_dec(
> +                                       state,
> +                                       round_down(walk->nbytes,
> +                                                  AEGIS128_BLOCK_SIZE),
> +                                       walk->src.virt.addr,
> +                                       walk->dst.virt.addr);
>                 skcipher_walk_done(walk, walk->nbytes % AEGIS128_BLOCK_SI=
ZE);
>         }
>
>         if (walk->nbytes) {
> -               ops->crypt_tail(state, walk->nbytes, walk->src.virt.addr,
> -                               walk->dst.virt.addr);
> +               if (enc)
> +                       crypto_aegis128_aesni_enc_tail(state, walk->nbyte=
s,
> +                                                      walk->src.virt.add=
r,
> +                                                      walk->dst.virt.add=
r);
> +               else
> +                       crypto_aegis128_aesni_dec_tail(state, walk->nbyte=
s,
> +                                                      walk->src.virt.add=
r,
> +                                                      walk->dst.virt.add=
r);
>                 skcipher_walk_done(walk, 0);
>         }
>  }
>
>  static struct aegis_ctx *crypto_aegis128_aesni_ctx(struct crypto_aead *a=
ead)
> @@ -160,71 +167,62 @@ static int crypto_aegis128_aesni_setauthsize(struct=
 crypto_aead *tfm,
>         if (authsize < AEGIS128_MIN_AUTH_SIZE)
>                 return -EINVAL;
>         return 0;
>  }
>
> -static void crypto_aegis128_aesni_crypt(struct aead_request *req,
> -                                       struct aegis_block *tag_xor,
> -                                       unsigned int cryptlen,
> -                                       const struct aegis_crypt_ops *ops=
)
> +static __always_inline void
> +crypto_aegis128_aesni_crypt(struct aead_request *req,
> +                           struct aegis_block *tag_xor,
> +                           unsigned int cryptlen, bool enc)
>  {
>         struct crypto_aead *tfm =3D crypto_aead_reqtfm(req);
>         struct aegis_ctx *ctx =3D crypto_aegis128_aesni_ctx(tfm);
>         struct skcipher_walk walk;
>         struct aegis_state state;
>
> -       ops->skcipher_walk_init(&walk, req, true);
> +       if (enc)
> +               skcipher_walk_aead_encrypt(&walk, req, true);
> +       else
> +               skcipher_walk_aead_decrypt(&walk, req, true);
>
>         kernel_fpu_begin();
>
>         crypto_aegis128_aesni_init(&state, ctx->key.bytes, req->iv);
>         crypto_aegis128_aesni_process_ad(&state, req->src, req->assoclen)=
;
> -       crypto_aegis128_aesni_process_crypt(&state, &walk, ops);
> +       crypto_aegis128_aesni_process_crypt(&state, &walk, enc);
>         crypto_aegis128_aesni_final(&state, tag_xor, req->assoclen, crypt=
len);
>
>         kernel_fpu_end();
>  }
>
>  static int crypto_aegis128_aesni_encrypt(struct aead_request *req)
>  {
> -       static const struct aegis_crypt_ops OPS =3D {
> -               .skcipher_walk_init =3D skcipher_walk_aead_encrypt,
> -               .crypt_blocks =3D crypto_aegis128_aesni_enc,
> -               .crypt_tail =3D crypto_aegis128_aesni_enc_tail,
> -       };
> -
>         struct crypto_aead *tfm =3D crypto_aead_reqtfm(req);
>         struct aegis_block tag =3D {};
>         unsigned int authsize =3D crypto_aead_authsize(tfm);
>         unsigned int cryptlen =3D req->cryptlen;
>
> -       crypto_aegis128_aesni_crypt(req, &tag, cryptlen, &OPS);
> +       crypto_aegis128_aesni_crypt(req, &tag, cryptlen, true);
>
>         scatterwalk_map_and_copy(tag.bytes, req->dst,
>                                  req->assoclen + cryptlen, authsize, 1);
>         return 0;
>  }
>
>  static int crypto_aegis128_aesni_decrypt(struct aead_request *req)
>  {
>         static const struct aegis_block zeros =3D {};
>
> -       static const struct aegis_crypt_ops OPS =3D {
> -               .skcipher_walk_init =3D skcipher_walk_aead_decrypt,
> -               .crypt_blocks =3D crypto_aegis128_aesni_dec,
> -               .crypt_tail =3D crypto_aegis128_aesni_dec_tail,
> -       };
> -
>         struct crypto_aead *tfm =3D crypto_aead_reqtfm(req);
>         struct aegis_block tag;
>         unsigned int authsize =3D crypto_aead_authsize(tfm);
>         unsigned int cryptlen =3D req->cryptlen - authsize;
>
>         scatterwalk_map_and_copy(tag.bytes, req->src,
>                                  req->assoclen + cryptlen, authsize, 0);
>
> -       crypto_aegis128_aesni_crypt(req, &tag, cryptlen, &OPS);
> +       crypto_aegis128_aesni_crypt(req, &tag, cryptlen, false);
>
>         return crypto_memneq(tag.bytes, zeros.bytes, authsize) ? -EBADMSG=
 : 0;
>  }
>
>  static struct aead_alg crypto_aegis128_aesni_alg =3D {
> --
> 2.46.2
>


--
Ondrej Mosnacek
Senior Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

