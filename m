Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFF121767F
	for <linux-crypto@vger.kernel.org>; Thu, 19 Dec 2024 08:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734595410; cv=none; b=XihBM/smP09sL8yrHtpw1JmXVyXQvxfkYaZ1xqU/trrWvjmEHSD/uzWxMhf2eh4lBAKY+5KLrOmN0Mg3EoStjVo1pA7rUPXlJIMOYX2a4NdnJL1CQyEwuGITeIC4mZjL9KlSXlOuM0Klh2Wd/fn+DKyjU8+Y6/v+W9a987zWiqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734595410; c=relaxed/simple;
	bh=RgfHuGBXae1glgZFL17pBAgm97fYyxc7BJ/AXvBFTbQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=twgko4oqfMCUe4pDNUZlqTpBzehMNzR0lXPZRDW7X2GMjLL6M6PSaVy1NohWKPeO8sTN1jyMnz2dOpwICtX2QrQCSWCqC4MynASPUJXenlAahC6bVLc3Hke8m1WQu0g6AgzZt586pQvltW21vx0muAijeFUXruDanInlQqjNMsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=rewZj2S2; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="rewZj2S2"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5401d3ea5a1so457476e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 19 Dec 2024 00:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1734595407; x=1735200207; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ugXH4+JF66LMJJim+wfATXqMioH1c19K+Z5j5LyswP8=;
        b=rewZj2S23Phbx3yQbySaophrcoFibtPIkoIGaxH9Zss0wWMUbXgWPYNh+8e4t9Ob5M
         cvvEp3KkR22ssL660ugwOGEuEO11WNcbAQKBaGKFEtdWMwTxgRT3DmJyGOxOiAXksffn
         C5cTjSBLnwWewgjstpyiJMJ7/F6+ToG8aUt+Jo/bNlzI4wylvi+0S6XOy+tELV/Gzz3P
         uhihXyo3T96T0/kzmUr4obyKAUcLvJKrZvVm4UEbhAYLAkup8lsj4EgWSoSAo0onDMCh
         N+wY+SBhuCj8wk3/dx8MINyeR4qyh6+jZ4zbTrfjJ3ufp3cDRGYwnqQYkbyrMz2x+wBf
         MZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734595407; x=1735200207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ugXH4+JF66LMJJim+wfATXqMioH1c19K+Z5j5LyswP8=;
        b=T+yp53vbebGFPDi8bDKPHU2lUsWxLAbr/BQ/b68Iz3/dzR0KG2YJptdw4O10t+xxow
         Koo04OuNEn9xZmfWYLgze2gINyJDGHUQp2Fw3TM668buNRoAp/8a1a7RD20M1EGmVTIM
         yNSlH7KDLRBrbERNrevAb73LOdYv7H0KK76qEzjM7C/ngaoubXR2zYT2TeyCAmV4nolh
         raNoFfHaKayS7Xb1ihT754swy+I4lzFR+DP6yKUnvXFtrMYoK43ionCIQLu/SodiUCO8
         lM/ecITUKtVVA2ExbHvOocGUadhubYNdVrpDiixx0lVa8Pp//VBPL1iUu4VAP+tZZuQ5
         DPng==
X-Forwarded-Encrypted: i=1; AJvYcCWRsZT6M8AwBqno3k2U+enj0GfNIkmjRM5d5ui8ZRO779MxzgV91/FL/n1WtMXHZXZEaeXy21Bm43i0Zsw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyokG08VqIVmivyY6qKeFGiEPkmITTuubHb8CCUvemM5lADLLVN
	IxC5r+20fwzwaKkqYnMmISLbpHFJ4TfAuvXoDr+OqZy6jnIpHJfe9/5JrMdBUOrejRXkFoCNuCs
	VtQEL2ky7ZeAq4EYFyZ0eeAgShXExlz++FWWApA==
X-Gm-Gg: ASbGncstcdz92K8kdbLbk3ol4wQrmGjcV4S8/OyilOr3qudzxxshCDpXglyTsJ8LlVQ
	Ws1KF7Nh0udjN0rPOrO16ZyscqElQPX/v181ZrjVavT8ov3YlsFK6QfC6sAYCh2IX+5hvRw==
X-Google-Smtp-Source: AGHT+IFRKO+emIlNQZoyNcMhoAfze1VoczKB32ps+HArJ9oMB44xWoJtMbeHURhGT7AmeGiL5tKkxwjtS5FU/ZOAuic=
X-Received: by 2002:a05:6512:33cf:b0:540:20f5:be77 with SMTP id
 2adb3069b0e04-54220fd29f2mr699782e87.3.1734595406555; Thu, 19 Dec 2024
 00:03:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241218-crypto-qce-sha-fix-clang-cleanup-error-v1-1-7e6c6dcca345@kernel.org>
In-Reply-To: <20241218-crypto-qce-sha-fix-clang-cleanup-error-v1-1-7e6c6dcca345@kernel.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 19 Dec 2024 09:03:15 +0100
Message-ID: <CAMRc=Md19mjs3J+RKTGg--bC+G6yFk5J00wCMohqtt2_O0k=9Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - revert "use __free() for a buffer that's
 always freed"
To: Nathan Chancellor <nathan@kernel.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Neil Armstrong <neil.armstrong@linaro.org>, 
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	Linux Kernel Functional Testing <lkft@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2024 at 9:13=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Commit ce8fd0500b74 ("crypto: qce - use __free() for a buffer that's
> always freed") introduced a buggy use of __free(), which clang
> rightfully points out:
>
>   drivers/crypto/qce/sha.c:365:3: error: cannot jump from this goto state=
ment to its label
>     365 |                 goto err_free_ahash;
>         |                 ^
>   drivers/crypto/qce/sha.c:373:6: note: jump bypasses initialization of v=
ariable with __attribute__((cleanup))
>     373 |         u8 *buf __free(kfree) =3D kzalloc(keylen + QCE_MAX_ALIG=
N_SIZE,
>         |             ^
>
> Jumping over a variable declared with the cleanup attribute does not
> prevent the cleanup function from running; instead, the cleanup function
> is called with an uninitialized value.
>
> Moving the declaration back to the top function with __free() and a NULL
> initialization would resolve the bug but that is really not much
> different from the original code. Since the function is so simple and
> there is no functional reason to use __free() here, just revert the
> original change to resolve the issue.
>
> Fixes: ce8fd0500b74 ("crypto: qce - use __free() for a buffer that's alwa=
ys freed")
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Closes: https://lore.kernel.org/CA+G9fYtpAwXa5mUQ5O7vDLK2xN4t-kJoxgUe1ZFR=
T=3DAGqmLSRA@mail.gmail.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Yeah, that was probably overkill but I thought it makes sense if I'm
reworking the driver anyway.

Feel free to kill it.

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
