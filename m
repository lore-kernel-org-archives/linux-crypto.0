Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CF63F86E7
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 06:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430730; cv=none; b=PkHDn3W590MAzvcCdB7i4zTyrWyAfYiqpqjt/K7N9oFXqZojidBjl3JRhAo5ka0v0YqcqViBYcZJZ6BBwz0LI/7UufH4iuKLb8YVJ0Gu54ejTOEeMtH0eMKN0F+qJsRUzfYOyoAVTSnoTYK/PkXP97bsk1/drFhbMGD8CyTrSRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430730; c=relaxed/simple;
	bh=pJVq6yxlsV8MaxLkBwVZT68ibQgfi6cVZyQw3M7Tcko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jdctTaD07XQHan3lthw52ZaDs0NkTEOZMG/88vJ5F5D1z9XGUGJmu8sPWFbozlCUjaq0KDN6bBMtBzpUznmf8RxQMQAMY9eWYvOTZEX3l0hnX6PywEEkWzzTzLLJCEHMp9fONAz52HsI+8oYgQI8Y+hTzcrsuogqmET5N078Mxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FHJ1wm7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FHJ1wm7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2711F00A3F
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 06:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786430704;
	bh=pJVq6yxlsV8MaxLkBwVZT68ibQgfi6cVZyQw3M7Tcko=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FHJ1wm7i0gGI3Mr+5UuSVe8oUCrros9IwIJdlNXcgkGoF/jEcQUEETKZaik39m02l
	 T2GTzlY6rca4G8Ax1U9Q4Noub8ax6boj59apelhi9TV4L3oO8oHRX/65xGS/A4nlJ7
	 aKeK3LbCG56EOzdBvW/2/Up4WRDUX8xOgEAIxuZyFjDQ8iL9aC+aIoIqN1+HV9RV1W
	 9easoduZaheLxfxQcEkLfTMi7O+jzYK5+hRGFnjwn1BjqVr8jsvMSlahcj5G7IUrrG
	 90ZpGqmt+j3uWjx5wtUjytSCUiwmq+hRHva1FHJkgIOOfDc6aKdt9r/3o3XfPQgyqJ
	 vJvoWgoN+vD1g==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-39ca300db70so20335321fa.2
        for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 23:45:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrwLebqqwO66X6Cibyjyq0iG732fWzQiWcQ1LnUTcT1MlpsYDhjHSjSc3tueIttGPyWALJpOQAizUFYU4w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwM51V2Zd6dWyN7Cfg7PBjNDt64N0SpBAa8U1oCZyhsnDV1krp1
	4wiW8pIl3ER0sQeDoWNZ5TvfD37NFf6MRgkIwEBBg/ronNsQ/mhoHKGNyIi55u9JmTSBElUUuAJ
	2zgwcFbYxTZrBDhzgbN12bMZMWcADTfg=
X-Received: by 2002:a2e:bc1c:0:b0:38e:8760:2922 with SMTP id
 38308e7fff4ca-3a0f8d49e4emr1498901fa.18.1786430703006; Mon, 10 Aug 2026
 23:45:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260811063442.3058074-1-lgs201920130244@gmail.com>
In-Reply-To: <20260811063442.3058074-1-lgs201920130244@gmail.com>
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 11 Aug 2026 08:44:50 +0200
X-Gmail-Original-Message-ID: <CAD++jLnc6BEi7nJMikKMFRF6p-gR1rWra2nStmV=Sa3H5hAgKA@mail.gmail.com>
X-Gm-Features: AUfX_mzWP3gAczH3XCsezdbF1fHtDPhGDpWpZ-nSiIVZIDaNKcMiQT0E7mjbdcI
Message-ID: <CAD++jLnc6BEi7nJMikKMFRF6p-gR1rWra2nStmV=Sa3H5hAgKA@mail.gmail.com>
Subject: Re: [PATCH v2] hwrng: stm32: fix usage_count leak when
 autosuspend_delay is negative
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Daniel Thompson <danielt@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 11, 2026 at 8:35=E2=80=AFAM Guangshuo Li <lgs201920130244@gmail=
.com> wrote:

> stm32_rng_probe() calls pm_runtime_use_autosuspend(), but runtime PM is
> enabled with pm_runtime_enable() and the matching
> pm_runtime_dont_use_autosuspend() is not called on driver teardown.
>
> If the autosuspend delay is set to a negative value while autosuspend
> is enabled, the runtime PM core increments usage_count to prevent
> runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
> during teardown, this reference is not dropped and usage_count remains
> unbalanced.
>
> Use devm_pm_runtime_enable() so that pm_runtime_dont_use_autosuspend()
> and pm_runtime_disable() are automatically called on probe failure and
> driver teardown. With runtime PM cleanup handled by devres,
> stm32_rng_remove() is no longer needed.
>
> This issue was found by manual code inspection.
>
> Fixes: c6a97c42e399 ("hwrng: stm32 - add support for STM32 HW RNG")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>

Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij
