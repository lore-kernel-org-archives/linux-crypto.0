Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F1630E0F8
	for <linux-crypto@vger.kernel.org>; Sat, 25 Jul 2026 09:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784970636; cv=none; b=cC2gbAgmbnks3hxCdxBsHvzg3OUoxGzP7TO7McBcA70Ttymq4qALmSM6+hodnpmS5kfUbJ4LSwUdfLCkR6sUisuHCeAaRClDbWL33Kv8YGv/FGFIZysvLr/fDJ+2LTRAPYxYEL8GbXK/wpoHP2Xau7Wdv0XdWpa9EYNMOnRcwVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784970636; c=relaxed/simple;
	bh=AhCPhNc9a/U5wLKgysHB0Kn2KnDD7w6pjrLvtRC4YoE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MnPPb/6Rb87FnazEFHo9SNuOx2Y71whg1C56D34lUETyzEUAIfnrolxzPVGSru28m9kEwsSb7Vkff0vPfwP+zbSxv6NU2xNGkqRVMANCyGm+Wcv1kZXJFsc8hxtH4XI8tseWsH8Q3MN9UVDLPik7MuvqWmaXYsEKBdn9A91P48U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O448WL0T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O448WL0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733801F00A3A
	for <linux-crypto@vger.kernel.org>; Sat, 25 Jul 2026 09:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784970634;
	bh=AhCPhNc9a/U5wLKgysHB0Kn2KnDD7w6pjrLvtRC4YoE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=O448WL0T5x1Zh0OMQi9iRlZwPh0fZiFxzhjRWWu0EW57dDBI9RV4q27LHGrs5BL+6
	 H4GKRULAAaYMpIJejW/rGtFEl5mo6XXITHZ+asMxRsT02OBBedoicBciWZaAJbo1HN
	 UvT4cMd8aX8qGOU9zFZXTWVYqzbabCA6tugKr1n2op26vf7O3ZOkp1/X2l6dJqT0OH
	 hI6Qod10W3XtE+UxUhd1RZfRtpaWw7TYSLmsSJw9CuHDKsd5EwItmbZ4mZEZwtX6NA
	 08vyeguxIywjiFYLqL+6haWSRSguNLRuQ5yyCj9ftCFBGZ1ojqabazhd66+FXf7IGz
	 uCq68P+VZILJg==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b28c91fba5so1389286e87.1
        for <linux-crypto@vger.kernel.org>; Sat, 25 Jul 2026 02:10:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoMs8yF/HWa5+C10QBnsRAlvJd2QT8A9xPiebT9VLu0KV1iMLum0jbn0TyYHN57ZLBXU7bdqCOVtegp8Z8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7CN53Q7iynMRc9eL7yI7nuhUfJa1aJpmODPN/bXEGjlYZyNf1
	0YIauFM43DHwg1wIhv3Y5dgy+ismr4MHCrOyCbs2gNHJrgTT5mUZj8quDvq+H/TIT3PmIquNgFl
	W+jtH7H6fhdqKpSIEFJz0vgNfj4//m0I=
X-Received: by 2002:a05:6512:3d07:b0:5ae:b6cf:c745 with SMTP id
 2adb3069b0e04-5b2c1a3c746mr282806e87.17.1784970633111; Sat, 25 Jul 2026
 02:10:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260718032937.420561-1-pengcan@kylinos.cn>
In-Reply-To: <20260718032937.420561-1-pengcan@kylinos.cn>
From: Linus Walleij <linusw@kernel.org>
Date: Sat, 25 Jul 2026 11:10:20 +0200
X-Gmail-Original-Message-ID: <CAD++jLke1q2DX1EQTHysPKrvy8mtnFtbnLwfQ-wEvRE2MNsECA@mail.gmail.com>
X-Gm-Features: AUfX_mwx6iFHSQ9ss2kJ9CSpvbTA4MTcHZwsUdEhUsOwa3V2e4PZJUoBdtU7nvw
Message-ID: <CAD++jLke1q2DX1EQTHysPKrvy8mtnFtbnLwfQ-wEvRE2MNsECA@mail.gmail.com>
Subject: Re: [PATCH] hwrng: stm32 - Fix runtime PM cleanup on registration failure
To: Can Peng <pengcan@kylinos.cn>
Cc: olivia@selenic.com, herbert@gondor.apana.org.au, mcoquelin.stm32@gmail.com, 
	alexandre.torgue@foss.st.com, danielt@kernel.org, 
	linux-crypto@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Can,

thanks for your patch!

On Sat, Jul 18, 2026 at 5:30=E2=80=AFAM Can Peng <pengcan@kylinos.cn> wrote=
:

> stm32_rng_probe() enables autosuspend and runtime PM before registering t=
he
> hwrng. If devm_hwrng_register() fails, probe returns with runtime PM left
> enabled and autosuspend still selected.
>
> The remove callback also only disables runtime PM and does not undo
> pm_runtime_use_autosuspend().
>
> Use devm_pm_runtime_enable() so runtime PM is unwound automatically on
> probe failure and driver detach. Since the managed cleanup also disables
> runtime PM,drop the remove callback.
>
> Fixes: c6a97c42e399 ("hwrng: stm32 - add support for STM32 HW RNG")
> Cc: stable@vger.kernel.org

Ah come on, it's not that serious.

> Signed-off-by: Can Peng <pengcan@kylinos.cn>

Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij
