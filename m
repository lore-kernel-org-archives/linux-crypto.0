Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BCF30FC3D
	for <linux-crypto@vger.kernel.org>; Wed, 10 Sep 2025 18:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527629; cv=none; b=sTNcIOTBdhhxoaZJ4jS/pEn1f//JD/vhL+VVRhKQYVcXU+W7XQnHt3f+vl0BgQ+OtC59qZOTFyiZo536V04J4yPB71E9uGxpCnP/dtyjDALULRRpsMBRSdEKkAqoZwQyCDVQgTiWs+Aw0ZO/WcLsul+2Fzme8Q+FgmCSwJ+6630=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527629; c=relaxed/simple;
	bh=cIbwctSJfT99Cq2+n4aveUZUbtagwWAT91PLR5ehZqQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SgroYC44F9jk18qZRQRlGji6Qe1e7/EN6fiFb05TshB5rn5RyJdn2aTxVFus9/1+WlXWELN1oTRB+au4eDUOXJuLBZEYjKbsd/YHyvs3w/5KYtwSLkk2KYylA7AxYrlIRqmywzcOz3fAib6pZgELg1B0tGr69AZRMi44gXqR8yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KtVywVRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KtVywVRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3661DC4CEF0
	for <linux-crypto@vger.kernel.org>; Wed, 10 Sep 2025 18:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757527629;
	bh=cIbwctSJfT99Cq2+n4aveUZUbtagwWAT91PLR5ehZqQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KtVywVRSHXQlziZxuY5FyagmrxIEkI+04T1qajkMmTFFWZa1AEwkThBXnEuxujUjF
	 8Eu1daQJCkradPMFolFRDbHAbkLhGhi2wUzt2qtMAGqbicKLopgYZYx2ubgsjD1Cih
	 eEYcxMSAeJb2na61BNldSNnP1k7YUbMKoZAwg88b0nA/VsigrLBo26TsIAXwVsD7wu
	 xxnWDH8G1JNnOXlKgnO5z/96w2zgCqQ3hj0Y+XfhN0kP0TsIndNnjWtU5gb0M89IB7
	 51wmc6MiUnfP51SgU/CHKLNBJ2i0Jiasf2xfrx3BwAZY2c6HKy9bFzOHSi11d/OGSy
	 vFcQs/giWUr2A==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-33730e1cda7so65358881fa.3
        for <linux-crypto@vger.kernel.org>; Wed, 10 Sep 2025 11:07:09 -0700 (PDT)
X-Gm-Message-State: AOJu0YxkidZaj+VW2CR9aFGhOLkXLHI2E7QoGrLEs9xeJOgR5A+Ux+TX
	09mvbVRS97snkVQd6TNxRsVQGBCU0S9IP7mV6p38IWTDak/8n63xe3N8CD0NX/KqC+AkeZ1UrWu
	RPPYjWX7CPWTnO3WJs+miQs7bsQ4w/to=
X-Google-Smtp-Source: AGHT+IHdTkLkZuoNfpN7V1ggtjfQwJwdDYEJZA0njYUunjF9mvsn9P/subhzLpQwCDwPO1WtGamKFAi40PeZPGEiVRY=
X-Received: by 2002:a05:651c:208e:b0:338:53d:3518 with SMTP id
 38308e7fff4ca-33b58cc0944mr33835321fa.39.1757527627519; Wed, 10 Sep 2025
 11:07:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1757392363.git.herbert@gondor.apana.org.au> <45f65a569f76a7212057f65ca800206d8f76b2e1.1757392363.git.herbert@gondor.apana.org.au>
In-Reply-To: <45f65a569f76a7212057f65ca800206d8f76b2e1.1757392363.git.herbert@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 10 Sep 2025 20:06:56 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG1ES-vvUWfJz9Kefp84vCDcT+H0=RP5a8tRq5nrhddmg@mail.gmail.com>
X-Gm-Features: Ac12FXxfncSDw6BNlfbqbOSjahzO8h3gGGvPf9GmpRrrzj8WLLVEUlNm44giz3U
Message-ID: <CAMj1kXG1ES-vvUWfJz9Kefp84vCDcT+H0=RP5a8tRq5nrhddmg@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: ahash - Allow async stack requests when specified
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 9 Sept 2025 at 07:01, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> As it stands stack requests are forbidden for async algorithms
> because of the inability to perform DMA on stack memory.
>

That is not the only reason.

> However, some async algorithms do not perform DMA and are able
> to handle stack requests.  Allow such uses by addnig a new type
> bit CRYPTO_AHASH_ALG_STACK_REQ.  When it is set on the algorithm
> stack requests will be allowed even if the algorithm is asynchronous.
>

If the algorithm is asynchronous, it may return -EINPROGRESS to the
caller, and proceed to access the request structure after that. So
this only works if the caller waits on the completion, and does not
return (and release its stack frame) before the request is completed.

This makes this feature rather limited in usefulness imo - truly async
hashes are only performant (if they ever are) if many requests can be
in flight at the same time, and using stack requests makes that
impossible.


> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/ahash.c                 | 22 ++++++++++++++++++----
>  include/crypto/internal/hash.h |  3 +++
>  2 files changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index a227793d2c5b..5ea72eb2ea91 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -49,6 +49,20 @@ static inline bool crypto_ahash_need_fallback(struct crypto_ahash *tfm)
>                CRYPTO_ALG_NEED_FALLBACK;
>  }
>
> +static inline bool crypto_ahash_stack_req_ok(struct ahash_request *req)
> +{
> +       struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +
> +       if (!ahash_req_on_stack(req))
> +               return true;
> +
> +       if (!ahash_is_async(tfm))
> +               return true;
> +
> +       return crypto_ahash_alg(tfm)->halg.base.cra_flags &
> +              CRYPTO_AHASH_ALG_STACK_REQ;
> +}
> +
>  static inline void ahash_op_done(void *data, int err,
>                                  int (*finish)(struct ahash_request *, int))
>  {
> @@ -376,7 +390,7 @@ int crypto_ahash_init(struct ahash_request *req)
>                 return crypto_shash_init(prepare_shash_desc(req, tfm));
>         if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
>                 return -ENOKEY;
> -       if (ahash_req_on_stack(req) && ahash_is_async(tfm))
> +       if (crypto_ahash_stack_req_ok(req))
>                 return -EAGAIN;
>         if (crypto_ahash_block_only(tfm)) {
>                 u8 *buf = ahash_request_ctx(req);
> @@ -451,7 +465,7 @@ int crypto_ahash_update(struct ahash_request *req)
>
>         if (likely(tfm->using_shash))
>                 return shash_ahash_update(req, ahash_request_ctx(req));
> -       if (ahash_req_on_stack(req) && ahash_is_async(tfm))
> +       if (crypto_ahash_stack_req_ok(req))
>                 return -EAGAIN;
>         if (!crypto_ahash_block_only(tfm))
>                 return ahash_do_req_chain(req, &crypto_ahash_alg(tfm)->update);
> @@ -531,7 +545,7 @@ int crypto_ahash_finup(struct ahash_request *req)
>
>         if (likely(tfm->using_shash))
>                 return shash_ahash_finup(req, ahash_request_ctx(req));
> -       if (ahash_req_on_stack(req) && ahash_is_async(tfm))
> +       if (crypto_ahash_stack_req_ok(req))
>                 return -EAGAIN;
>         if (!crypto_ahash_alg(tfm)->finup)
>                 return ahash_def_finup(req);
> @@ -569,7 +583,7 @@ int crypto_ahash_digest(struct ahash_request *req)
>
>         if (likely(tfm->using_shash))
>                 return shash_ahash_digest(req, prepare_shash_desc(req, tfm));
> -       if (ahash_req_on_stack(req) && ahash_is_async(tfm))
> +       if (crypto_ahash_stack_req_ok(req))
>                 return -EAGAIN;
>         if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
>                 return -ENOKEY;
> diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
> index 6ec5f2f37ccb..79899d36032b 100644
> --- a/include/crypto/internal/hash.h
> +++ b/include/crypto/internal/hash.h
> @@ -23,6 +23,9 @@
>  /* This bit is set by the Crypto API if export_core is not supported. */
>  #define CRYPTO_AHASH_ALG_NO_EXPORT_CORE        0x08000000
>
> +/* This bit is set by the Crypto API if stack requests are supported. */
> +#define CRYPTO_AHASH_ALG_STACK_REQ     0x10000000
> +
>  #define HASH_FBREQ_ON_STACK(name, req) \
>          char __##name##_req[sizeof(struct ahash_request) + \
>                              MAX_SYNC_HASH_REQSIZE] CRYPTO_MINALIGN_ATTR; \
> --
> 2.39.5
>
>
