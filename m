Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87193230D0E
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 11:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753443673; cv=none; b=u2FChIhM2e40VSCPDK5uplhH+u/kTgx73KRln+86eKYzuzoCNcxCmYe1Iz/rrJ+ddK5Dj235vEKUoMX7HwFHb7v5y2OUTfYGRGjZtaPoJD0V07MNBK2LoWgIUxj+IECwdB7aiTCRQne0qAJfY6ghzy9OXiyBP+CLAJM1xNVsJCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753443673; c=relaxed/simple;
	bh=70cZJ5+MOSuyvoTc0hRAELy7cfRbFrHaFdQesC+yVH8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NaVTNcOk8NDrvkosVerIBYbuaKDAlVcK0oSeod1C3HMBqYcnzFo785iJks6xFb2Hu74isxuaTqw2Yb31sz7YYajLKFJHGw1NZLJd3kmDJrX2LzhVdbj5BN/7uaOTFtu29+U2GoiyxE/iokMbM3xmJfb0SkPgCfQBF0SxcfGTumc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=fHLoWL5Q; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fHLoWL5Q"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2ff9b45aec2so992096fac.2
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 04:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753443670; x=1754048470; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lj71s94DBO5ChtWnhYstkEV7QIcBC/2WSymKueRnDS4=;
        b=fHLoWL5QWmPDIRAfkGjBgHJl9knmFJ5iVCCvmmlB2RqlSl3Fn+IZgE78ganxesRYoV
         kUZVXsVhLYu60uyDA/vGs4+0bpSVYB6ewaiH4HMBmSXKrHqn6syAUK3uHzhYKRVwTxcf
         2cdC4CAk2DMopvV2Ez6Bwj1Eq6lJUEr7PsJJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753443670; x=1754048470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lj71s94DBO5ChtWnhYstkEV7QIcBC/2WSymKueRnDS4=;
        b=FhU2ISBUj6LyX/UeUKjnFRZASU8GQZQ0R8Yhd07dADsdgp4trXtjyXcjqM14gn7dOC
         3Hr8JrGxmpCHZ3ascPl0rWMhRz4CSifelxBYqQOWmPNaV9A7DIuigkzJCatDyaSaaZvO
         R2uOJ8z4I7tPH+OAU9IOjzUyWJH9cWgY6PRou0DWGrWI4kUIeNqjultV5DTUZPN19H4k
         0sG83mhwAvnzz6WKFIkGEzbQYiLXTVpaUnOz27tA574V6pXE56rKu5pTyu34U8g1/Vs5
         5kIuSMsMH/itL1kL8LuQooEM4/JnL923RcBxqWrl3/ypjogFXnxo+ltq7kRmNAP/Jnu+
         Fuvg==
X-Forwarded-Encrypted: i=1; AJvYcCUBIvEA6h/6R5ZeQSdp75AEdC6uJwx8YMfK0chqzGQ/OK7hy/mYSV5NP7hmMlfWKrmbq/hru6pWqkni+YQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YydWqrIhT+wyl4pb3JgHSgNwBjLHlrBlzT7g3rXpXTkc9A/NZ5u
	64UZdV2bgUAh1zNVCG3jj3WaHk7hnGCLPYvpaMwb3ag9jxOYnB15hgrv5pEcpOYYT9+o5EAoM+2
	qm8LVSA==
X-Gm-Gg: ASbGncvflsXFLSlSc/NbwYG9aPmuudh0WuUJuD0A9afC40QKvHp8oqEMwsD9RYW6ZsC
	teXP7CrAeuUYTZ187Nd3kDy7Zd1FU8c8uHfJrKZGTz3pGDgWEHuIdSMRqSzUyfCrcfRuHzqkDaP
	5kqmChfP6vXHv72AgBDdM4JaPYclDnQUcgfq7T3/l2ZFUbxta474Z9ArHaCuDKWbnPq+ix9ofs5
	8PTgPFjHLnZCN0+FGTFlur/ueISzse4xvrq0EO8q3EEu3ICoLi2QKLkkBNcfpG29znJ2p6wMzDv
	f82/WEZmDYDyezyz/F5VMeHuavdZ1Fg3Li9k63BBcWpcrNQTGOUJ9YiSHWt4kJplOzVi9DQcvax
	Bnbgs+nR2Pp+gYhOhFTBndxWWIVlzXc/2AZyUEtGwI8CGPgleHP19SioxMw==
X-Google-Smtp-Source: AGHT+IGcjnkEkwVPj6M6AibU/fK+I1IZMTgHsc6R7r3+CSsrPdeg3p/vQwV4jQO3nohmR5UzFEnEmA==
X-Received: by 2002:a05:6871:7292:b0:2e8:797b:bf23 with SMTP id 586e51a60fabf-30701f6c5c3mr857543fac.21.1753443670278;
        Fri, 25 Jul 2025 04:41:10 -0700 (PDT)
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com. [209.85.161.52])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-306e1c960e3sm1013609fac.16.2025.07.25.04.41.09
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 04:41:10 -0700 (PDT)
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-60bd30dd387so1136118eaf.3
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 04:41:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVJl5n02zZlYJHlXmct6Fv+5VuHWLFYDl0xkV99ty/5FYr5PIpu4LbCoy/goWZu4pofRoikjWQXTKIlp0I=@vger.kernel.org
X-Received: by 2002:a05:6102:358d:b0:4eb:f003:a636 with SMTP id
 ada2fe7eead31-4fa3f8f1683mr313640137.0.1753440679035; Fri, 25 Jul 2025
 03:51:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-25-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-25-angelogioacchino.delregno@collabora.com>
From: Fei Shao <fshao@chromium.org>
Date: Fri, 25 Jul 2025 18:50:41 +0800
X-Gmail-Original-Message-ID: <CAC=S1nhS8yY6iWNDfv4Lwz8zUJEy0nMxC5MVZGb983hDsg7bhA@mail.gmail.com>
X-Gm-Features: Ac12FXxJVbrVgIPSlm6u4--DKBHxaHRjM_36IT45XEIgpl9bR5PM8dE-s5Wt-28
Message-ID: <CAC=S1nhS8yY6iWNDfv4Lwz8zUJEy0nMxC5MVZGb983hDsg7bhA@mail.gmail.com>
Subject: Re: [PATCH 24/38] arm64: dts: mediatek: mt7986a-bpi-r3: Fix SFP I2C
 node names
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-mediatek@lists.infradead.org, robh@kernel.org, 
	daniel.lezcano@linaro.org, mwalle@kernel.org, devicetree@vger.kernel.org, 
	linus.walleij@linaro.org, linux-remoteproc@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	olivia.wen@mediatek.com, shane.chien@mediatek.com, linux-gpio@vger.kernel.org, 
	linux-phy@lists.infradead.org, airlied@gmail.com, simona@ffwll.ch, 
	herbert@gondor.apana.org.au, jassisinghbrar@gmail.com, jiaxin.yu@mediatek.com, 
	andy.teng@mediatek.com, chunfeng.yun@mediatek.com, jieyy.yang@mediatek.com, 
	chunkuang.hu@kernel.org, conor+dt@kernel.org, jitao.shi@mediatek.com, 
	p.zabel@pengutronix.de, arnd@arndb.de, kishon@kernel.org, 
	kyrie.wu@mediatek.corp-partner.google.com, maarten.lankhorst@linux.intel.com, 
	tinghan.shen@mediatek.com, mripard@kernel.org, ck.hu@mediatek.com, 
	broonie@kernel.org, eugen.hristev@linaro.org, houlong.wei@mediatek.com, 
	matthias.bgg@gmail.com, tglx@linutronix.de, mchehab@kernel.org, 
	linux-arm-kernel@lists.infradead.org, granquet@baylibre.com, 
	sam.shih@mediatek.com, mathieu.poirier@linaro.org, fparent@baylibre.com, 
	andersson@kernel.org, sean.wang@kernel.org, linux-sound@vger.kernel.org, 
	lgirdwood@gmail.com, vkoul@kernel.org, linux-crypto@vger.kernel.org, 
	tzimmermann@suse.de, atenart@kernel.org, krzk+dt@kernel.org, 
	linux-media@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2025 at 5:49=E2=80=AFPM AngeloGioacchino Del Regno
<angelogioacchino.delregno@collabora.com> wrote:
>
> The binding wants the node to be named "i2c-number", alternatively
> "i2c@address", but those are named "i2c-gpio-number" instead.
>
> Rename those to i2c-0, i2c-1 to adhere to the binding and suppress
> dtbs_check warnings.
>
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>

It'd be nice to mention in v2 (if needed) that this patch also drops
redundant #address-cells and #size-cells, but it's minor.

Reviewed-by: Fei Shao <fshao@chromium.org>

> ---
>  arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts b/a=
rch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts
> index ed79ad1ae871..6d2762866a1a 100644
> --- a/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts
> +++ b/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts
> @@ -64,23 +64,19 @@ wps-key {
>         };
>
>         /* i2c of the left SFP cage (wan) */
> -       i2c_sfp1: i2c-gpio-0 {
> +       i2c_sfp1: i2c-0 {
>                 compatible =3D "i2c-gpio";
>                 sda-gpios =3D <&pio 16 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAI=
N)>;
>                 scl-gpios =3D <&pio 17 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAI=
N)>;
>                 i2c-gpio,delay-us =3D <2>;
> -               #address-cells =3D <1>;
> -               #size-cells =3D <0>;
>         };
>
>         /* i2c of the right SFP cage (lan) */
> -       i2c_sfp2: i2c-gpio-1 {
> +       i2c_sfp2: i2c-1 {
>                 compatible =3D "i2c-gpio";
>                 sda-gpios =3D <&pio 18 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAI=
N)>;
>                 scl-gpios =3D <&pio 19 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAI=
N)>;
>                 i2c-gpio,delay-us =3D <2>;
> -               #address-cells =3D <1>;
> -               #size-cells =3D <0>;
>         };
>
>         leds {
> --
> 2.50.1
>
>
