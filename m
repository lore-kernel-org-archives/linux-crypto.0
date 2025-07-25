Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B8B2746A
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 11:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753444494; cv=none; b=Ksrjk2gF+1oQro/o/7ULbqjGqEMRuOvaXf64xQvntD97hwJkaaHMhYFnrFm27DeV48wZ0yvZU8WOMCD7duN4y5TFYRKJlE0UhpGJQ1ECInRXkKpSQ2voB+uelvyzAFPlNYlyWoFqLaRGmAjaeCTR88QxV1In/r00BqJp1ZhGwBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753444494; c=relaxed/simple;
	bh=7Lq+L8ybIKzJFE7aCP8K4OUgb0w5TEGi1D/8HV86VOI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WlN2ezeqton+J9cemrKtcIFLOkkCAKMu1ldNtUv47tJksKx9xQe71dFBDev85MxeWgerUjpVbip5qrm+Jw0R5fiRb+mhRcktKnFrD5qgD30jASk357Ru3q3CLT8jvHOFZR2/nDLTlU/lLSTyiJhIhI+V/yiOnNb5cu1f5w1Hujk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=bFRCgoFC; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bFRCgoFC"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7e33d36491dso278301785a.3
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 04:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753444492; x=1754049292; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5hJBa13s79OQWhYLxMwSe1UwJVG9FUdchi7fOARwLxY=;
        b=bFRCgoFC4O4aZ+/NtDzBeIL6oyKWGZWRsVbo1uvmKTJ+bHYUCdjW+9bilehtV8riRV
         sHVmKFgYM6sAlm4KztiYXMOuQS/xrUNrjRGo+Bt9hNqv3MVSLRXyMywrQ/RwIq3CBI68
         9yo/4rAsy6xhiBYg4N32bFwR/WZeOd5INu+aI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753444492; x=1754049292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5hJBa13s79OQWhYLxMwSe1UwJVG9FUdchi7fOARwLxY=;
        b=NuBXikGbwwrP5kJaDtpPxHky1q2ft+wGDN3fQeH1nJ8yEQbNVkIQOq6LO6ZFGHk0Xg
         E1V/5fBNBNlanbg7weJrLcV2Jy0lLdKhqAQTs98/7USDiMr/GabFca8ZJ/OFv4F+I3Dt
         iS8OfWwU1m4EWfJxGrLvL9ckdeNiJwczZHP6V/gLxXzjk+iYmHj2cptTosd7tCLd85+G
         wCOJqLb2GuKEV2L5eW2Atb/7HXLhGLlvKT5EV/CHi8nbjz456pWkIzp/FkImVQNCosP5
         VIYz1Jo75/qosHKj5dbUJNMHQHVnIrj1aPYEuJf92So+aQHn8EYrEaMsEOAxx1QY/vw7
         sF3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXG+vTwFymL1qhPkxAGr0x67kP9kjPQE3Gb6J6b4RJ6WG75ttMmBRVzn0/Fra51a4RYIqLa/W4j1C1SyFk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzR6rYXMYg3sVmaTkIglqX4+SYjn8rLSKAJmmGElIfWewVLHpP
	8CgHA+Exv76QHcxfVegyswnzQMEJZBUxe+pjgGRxs6/WwB9s69Qvs7nsmJ+IuJpxTDv3FJC9g0+
	nSzE=
X-Gm-Gg: ASbGnctQBHdtr9bk6AE61zinRZHApEq4gIURRRsxZS+w8+FZZ5wHrnwwh2goFvO4AZJ
	AFl639zdX05UVN5n5t2Qm01m8g7lk6D+g08KJuavlEO1wvQaarcWndqrHP7bvxvj/ykctSGFeH8
	b7sJ1jcfsTW43TFPG0Y0RO7zDqn03n8ocXTJpG3Q0TwkXX1TEJiecS7KmmKwXj9faHy9aU9Vbon
	bxkjdBgef027MO8+4VSogFp3GOr8yYhwMNT6Ypwy9Y6txnHb4a7cI8ekKDyODZWW+HXcR+1chSw
	ZRQeJ1xFMCMiwpgHBVeHBkUsgbVeHFDV5X+cO7SVWUsgapDuMSdflXQeb3R5A3syH5NEmVeQjTD
	dGUxa+eeS1ka4YSP95qIQd1qaQPFNmJ9z/ogaI+jobkaB1YKF+Ja2enaUkw==
X-Google-Smtp-Source: AGHT+IHcFKkgPCJkLXjoV53TufKZqP4m9bTqaSy0a/oe/zmR7il/JXvj4Ru0ptsH4PBvYvzElU8wfQ==
X-Received: by 2002:a05:620a:a81b:b0:7e6:31f3:eabc with SMTP id af79cd13be357-7e63bf53dbemr161186185a.5.1753444492262;
        Fri, 25 Jul 2025 04:54:52 -0700 (PDT)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com. [209.85.219.48])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e632e25e24sm241315885a.59.2025.07.25.04.54.52
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 04:54:52 -0700 (PDT)
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-7072628404dso2079746d6.2
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 04:54:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXkZLls7YpzBjLJ/YIqTKWG2j9IkFyWlrRLU2fOBpRS5LC++DnfpFarnv51iUDHWp90hIsb2LUVCE8w6z4=@vger.kernel.org
X-Received: by 2002:a05:6102:6891:b0:4dd:b82d:e0de with SMTP id
 ada2fe7eead31-4fa3ff44195mr316348137.17.1753440787376; Fri, 25 Jul 2025
 03:53:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-20-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-20-angelogioacchino.delregno@collabora.com>
From: Fei Shao <fshao@chromium.org>
Date: Fri, 25 Jul 2025 18:52:31 +0800
X-Gmail-Original-Message-ID: <CAC=S1nguRWyG3ubmSFE95_zgsCjjq4dxGWr5ErV9-Yu2+mTmpw@mail.gmail.com>
X-Gm-Features: Ac12FXzhNEGCOc6TL2wVpoG5kEXhC599YdNWu941VvXlO0dL7_W9Jc4if8EyMHA
Message-ID: <CAC=S1nguRWyG3ubmSFE95_zgsCjjq4dxGWr5ErV9-Yu2+mTmpw@mail.gmail.com>
Subject: Re: [PATCH 19/38] arm64: dts: mediatek: mt6795: Add mediatek,infracfg
 to iommu node
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
> The "M4U" IOMMU requires a handle to the infracfg to switch to
> the 4gb/pae addressing mode: add it.
>
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>

Reviewed-by: Fei Shao <fshao@chromium.org>

> ---
>  arch/arm64/boot/dts/mediatek/mt6795.dtsi | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/boot/dts/mediatek/mt6795.dtsi b/arch/arm64/boot/d=
ts/mediatek/mt6795.dtsi
> index e5e269a660b1..38f65aad2802 100644
> --- a/arch/arm64/boot/dts/mediatek/mt6795.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt6795.dtsi
> @@ -427,6 +427,7 @@ iommu: iommu@10205000 {
>                         clocks =3D <&infracfg CLK_INFRA_M4U>;
>                         clock-names =3D "bclk";
>                         interrupts =3D <GIC_SPI 146 IRQ_TYPE_LEVEL_LOW>;
> +                       mediatek,infracfg =3D <&infracfg>;
>                         mediatek,larbs =3D <&larb0 &larb1 &larb2 &larb3>;
>                         power-domains =3D <&spm MT6795_POWER_DOMAIN_MM>;
>                         #iommu-cells =3D <1>;
> --
> 2.50.1
>
>
