Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D50207E03
	for <linux-crypto@vger.kernel.org>; Mon, 16 Dec 2024 18:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734374716; cv=none; b=SR5Xc5adfOeeg3CAQznlOgx5oSRV7nwVsuwyFEsjpYNA4Rl7P3jU3YpEHM+hsVC72iKIIMV2gF23GXEiVCa8TWUM8FomleoxRLksPxHJUWbGI2AIgJJwHaBpsRvZxc3dQj+KECYTcnK+zUqxYpVMhB0JbBL6jQOR2tH25DHQ1Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734374716; c=relaxed/simple;
	bh=wPhuadXVqq3NRot78X0jrmq9xXlKWbFpMlJqSo/gcfg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LwSYTMMySyn3troA2DtCroNbOMZVai1WekzT5y6uK26QYFNCDBabbTODxDD6Q1ebbPTS36DW0IoD/pCBP+7LgiSEK8gGWizUKvJPqahdfLkgoDAZrSrPCS/tVnlpsfRqSUpNDjvQ4Rufc6WeeUNeoJSKKx2WIl/N15bbM1viUnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q8EJBl44; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q8EJBl44"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6ef7640e484so51054357b3.3
        for <linux-crypto@vger.kernel.org>; Mon, 16 Dec 2024 10:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734374714; x=1734979514; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hho81fUxS1svxnIpTTMvF+QFJQ1gclraQmirxeDP/2A=;
        b=Q8EJBl44rRCAcWsPG4iN27KhByZt5124YnCIEapPwOzn5ae9lwIYDS2g5VPoAijMtC
         g3DUjhnNFVWxg12HRmZeTzquo3QGvMI2WlIx0shKOf/ea5Uzg/LUgrlGEROxOr/woHi6
         j/FZsf4Z3q3f6kiRKUybt7w2qXVJRmZXuOGnk9+LFwPSTFqKI3N5GLCGcoUHJ5mdo8CC
         ZcYXBn1883tcLqL/qeWrSAc57BJPJgVxaWVDxrw25dzLJcuOXLOvut80AZc3p9mwrokL
         GS9tzSHhnMSNJcx0SsbYr+8usCEoRIDohU7RH7B57WsgM2i9WMuq+lAuRTmQbwbTxogJ
         U23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734374714; x=1734979514;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hho81fUxS1svxnIpTTMvF+QFJQ1gclraQmirxeDP/2A=;
        b=R3EhFdBDOa7pJ8gYdC48WQJLYmFpE8VrPRAKT+KIjsLowQUbl1IyJsDkKkQph+7zIb
         k0CYdrYIvFBdU9b3ZlW61klUWAnibX71PS5TOp0wjZSBPxwraxXydCmcCZMYMNXh9Drp
         9vqvU2dRITJy89OJ4PuMSWHRKJYx3+dtEUtuLMFJl5dBmAlSgPuh7bEQcHQGLP0Ty3jA
         5ZVlIni9qE8VlH46xEFjrqGsXfgXFKoJiGOskP4IMgsKOnmGlJCW1zi226/b1w51OThr
         LRLrxiry97k/6mG2S8QohWmbw65qWSMdjsQvxCzwsQV7K4eqg8vKTBZ9n/s5iEr8E2eI
         VY4A==
X-Forwarded-Encrypted: i=1; AJvYcCX3kSvg11WyNBzpDQyOIoGugxJMcnTRu5uivKvxi9rFSOXU36NXL34rYMKbES8DPg4M8tpJVJMuLdHUdd4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiGc37eYr7qiyi31uz1FwYm6vlIf48HvK5NVIAt08rrPf/VwDj
	IWgy2VQZEneFsucwrQnswiih1LHzoQ0T90DA2l3qOpDeh3be+La3HGqAfGdIdZIl4pGi1jiQ674
	s2qqY+NyVf1KEEOD8z9s2AnOkoAFXC7XxP8NmCQ==
X-Gm-Gg: ASbGncvM/bszfwRlBMwdbQFylmw9hA6h88CKw4TyjEvusg5ljNEjob8QO4Hqs2h+x7J
	A0v4Le2kH5u9SBjgBd+kp7uGRgEXL3GpQzpFyZ68BHebFcUenxqLEUeCy3DqY8L+RFt+Uzw==
X-Google-Smtp-Source: AGHT+IEoWJcDKQv5iEmEVMq3EpzCtQ9Q1A7OeekLCcpaKrEW68EjTvVaw4TXtlFnG0gT2cPtGh8+n5e6AdoDQWuvyI4=
X-Received: by 2002:a05:690c:7449:b0:6ef:8dd0:fff9 with SMTP id
 00721157ae682-6f279ad163fmr123605197b3.8.1734374713861; Mon, 16 Dec 2024
 10:45:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+G9fYtpAwXa5mUQ5O7vDLK2xN4t-kJoxgUe1ZFRT=AGqmLSRA@mail.gmail.com>
 <20241216180231.GA1069997@ax162>
In-Reply-To: <20241216180231.GA1069997@ax162>
From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Date: Mon, 16 Dec 2024 19:45:03 +0100
Message-ID: <CACMJSevssgFn6omKpV0rAMQKXpH__mmmkpdjUSYB7s2U=dsAEw@mail.gmail.com>
Subject: Re: next-20241216: drivers/crypto/qce/sha.c:365:3: error: cannot jump
 from this goto statement to its label
To: Nathan Chancellor <nathan@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, open list <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>, clang-built-linux <llvm@lists.linux.dev>, 
	thara gopinath <thara.gopinath@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Dec 2024 at 19:02, Nathan Chancellor <nathan@kernel.org> wrote:
>
> Hi Naresh,
>
> Thanks for the report.
>
> + Bartosz as author of ce8fd0500b74
>
> On Mon, Dec 16, 2024 at 10:04:05PM +0530, Naresh Kamboju wrote:
> > The arm and arm64 builds failed on Linux next-20241216 due to following
> > build warnings / errors with clang-19 and clang-nightly toolchain.
> > Whereas the gcc-13 builds pass.
> >
> > arm, arm64:
> >   * build/clang-19-defconfig
> >   * build/clang-nightly-defconfig
> >
> > First seen on Linux next-20241216.
> >   Good: next-20241216
> >   Bad:  next-20241213
> >
> > Build log:
> > -----------
> <trimmed irrelevant warning>
> > drivers/crypto/qce/sha.c:365:3: error: cannot jump from this goto
> > statement to its label
> >   365 |                 goto err_free_ahash;
> >       |                 ^
> > drivers/crypto/qce/sha.c:373:6: note: jump bypasses initialization of
> > variable with __attribute__((cleanup))
> >   373 |         u8 *buf __free(kfree) = kzalloc(keylen + QCE_MAX_ALIGN_SIZE,
> >       |             ^
> > 1 error generated.
>
> It is a bug to jump over the initialization of a cleanup variable
> because the cleanup function will be called on an uninitialized pointer
> in those cases. GCC does not catch this at compile time like clang does
> (it would be nice if we could document this somewhere and really
> encourage people doing cleanup annotations to ensure their patches pass
> a clang build except in architecture code where clang does not support
> that target):
>
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91951
>
> It may be worth just reverting commit ce8fd0500b74 ("crypto: qce - use
> __free() for a buffer that's always freed") since it seems like little
> value in this case but if we want to forward fix it, I think we could
> just mirror what the rest of the kernel does and keep the declaration at
> the top of the function and initialize the pointer to NULL. The diff
> below resolves the issue for me, which I don't mind sending as a formal
> patch.
>
> Cheers,
> Nathan

I'm fine with dropping that commit from next.

Bartosz

>
> diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
> index c4ddc3b265ee..e251f0f9a4fd 100644
> --- a/drivers/crypto/qce/sha.c
> +++ b/drivers/crypto/qce/sha.c
> @@ -337,6 +337,7 @@ static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>         struct scatterlist sg;
>         unsigned int blocksize;
>         struct crypto_ahash *ahash_tfm;
> +       u8 *buf __free(kfree) = NULL;
>         int ret;
>         const char *alg_name;
>
> @@ -370,8 +371,7 @@ static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>                                    crypto_req_done, &wait);
>         crypto_ahash_clear_flags(ahash_tfm, ~0);
>
> -       u8 *buf __free(kfree) = kzalloc(keylen + QCE_MAX_ALIGN_SIZE,
> -                                       GFP_KERNEL);
> +       buf = kzalloc(keylen + QCE_MAX_ALIGN_SIZE, GFP_KERNEL);
>         if (!buf) {
>                 ret = -ENOMEM;
>                 goto err_free_req;
