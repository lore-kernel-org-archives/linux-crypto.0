Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510AA3A1C6
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jan 2024 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705920760; cv=none; b=mVF8TjWu0NZ/eJ5+Pe/P6A/gaj6cP5rk/+J3pFWRsMQgee8R5/67FHO7o9ve9J9bO4FDVf//GIO4VnmKZiQt2X0H58LvBsmaegshGEKAimb9E+BLjBLvpB3SodAkOejsQJSf1+4/Z2kf7bQ4ckSoe92n6NaAgZF3Ivjc6GSnyR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705920760; c=relaxed/simple;
	bh=UAjtVoXEWcfRrrQ06RAiNYTqvqQJFkRoY7W8E45hZwc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZAZX2iTndPSrl6J7XBUou+zwYPJJFjUCCtu2QUNi1Y85SRlg9jfx75M3xkaKor2EyjsuvPQRRAd/ql7MbVokU5/PXZ3AXPsKpaiZCjGGH5yIjiDpHdhbvMgyn+YVuD30svnzrAdWI6TFK3+7NiI8vmwEQoeLt3ZbmUreqWbffwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aa2RJ4Sx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aa2RJ4Sx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE07C433F1
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jan 2024 10:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705920759;
	bh=UAjtVoXEWcfRrrQ06RAiNYTqvqQJFkRoY7W8E45hZwc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aa2RJ4Sx9y6ss6OWr9rUVA1d4nfHvOXNejggfTIR+w7ezEN5+YBm81+3TZRj6zLG9
	 Ejb7C9HZ9gNnN3a/YUnDCpQpE8TS8GVWC/M1BxD0zPNZAZL9QB9vW8USCJhVXLSXPb
	 AjDDS4cPV1TjqT8m2J1BLSi35xaGcfkhybbpW+78oC1Hp8q4wj3GyiqX/U/wel3Jj1
	 Tx1EOeLfB0y/v2x4j2uvRwYGYAOL2dcQJEU6WLsMgq/qZUQA0S79mvgNiz9Kt4JWXD
	 EEaJaMqMR4YKr04VcUxKHR7fPnZUiLy98fu/3Xa2LTFRmSKlqub30EKbT7ao3+m3ta
	 0VDOrRWkqKwbw==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-50e78f1f41fso2813317e87.2
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jan 2024 02:52:39 -0800 (PST)
X-Gm-Message-State: AOJu0Yz+2WI8IU9k4JscAjBu/JTNIC7r2NusilJ1k1rvOTVeU9QxrdpW
	zjDA/QQQL1RDVH3QjQTseR76za3u22WTLlFNLNdlrGSp84D3ttHaNZZr/geEtHzci+sw0TytBsL
	LifBe/dMMMHFB5tXuDVrEcWmBjPo=
X-Google-Smtp-Source: AGHT+IENHS3bwDjTgIMjVQVnKd0L/5sJ0EFQJbGCfQPRII1sw2cqWEkXW/quT4IszIgzguhQOvh+4S6WEfEWjS0SOUI=
X-Received: by 2002:a19:4f4c:0:b0:50e:9c17:24c8 with SMTP id
 a12-20020a194f4c000000b0050e9c1724c8mr1521087lfk.7.1705920758023; Mon, 22 Jan
 2024 02:52:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121194526.344007-1-git@jvdsn.com>
In-Reply-To: <20240121194526.344007-1-git@jvdsn.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 22 Jan 2024 11:52:26 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEgb2X2HcM9YJD8q0XKkiFZWgPofP+VfTpf3U5ZW0f+7w@mail.gmail.com>
Message-ID: <CAMj1kXEgb2X2HcM9YJD8q0XKkiFZWgPofP+VfTpf3U5ZW0f+7w@mail.gmail.com>
Subject: Re: [PATCH] crypto: remove unused xts4096 and xts512 algorithms from testmgr.c
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"

On Sun, 21 Jan 2024 at 20:55, Joachim Vandersmissen <git@jvdsn.com> wrote:
>
> Commit a93492cae30a ("crypto: ccree - remove data unit size support")
> removed support for the xts512 and xts4096 algorithms, but left them
> defined in testmgr.c. This patch removes those definitions.
>
> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  crypto/testmgr.c | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index c26aeda85787..3dddd288ca02 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -5720,14 +5720,6 @@ static const struct alg_test_desc alg_test_descs[] = {
>                 }
>         }, {
>  #endif
> -               .alg = "xts4096(paes)",
> -               .test = alg_test_null,
> -               .fips_allowed = 1,
> -       }, {
> -               .alg = "xts512(paes)",
> -               .test = alg_test_null,
> -               .fips_allowed = 1,
> -       }, {
>                 .alg = "xxhash64",
>                 .test = alg_test_hash,
>                 .fips_allowed = 1,
> --
> 2.43.0
>
>
