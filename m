Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688CF1BD4F7
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 12:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753445173; cv=none; b=u63/vgZsEQNlo9gIzN+vLsCwMHOTxoLlQBm+n3vd9ZHzITFenPlUsEK5CMb+4yjwVW8o7yXMuK94HP+6L05OMMbjUd/CDQEjbg6jHNXHnA6OZLJDdmoGmIB+Fholy5sHQWnHxW0dAtov5PAgGr2vyiH7vevBy8m8uP5tIJXOxyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753445173; c=relaxed/simple;
	bh=V8hirrUVOWBBWHrhJ7nvVXSHaacevucbhSLPMWQvrV0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IhyWuw4AOkijahlA/p9jr74ZpwNnrjmaM5MQ/aYB7sczIA3glzR5YlXF3D130U4jfSxY7+i5lLWimGgVyMzo6+G0/5SwBk2826nND4V5/CvRxEy9ySXI63XbgvPTK0LopDL7t1Hd4NYQ2DPhqlMDiHDlG/ZZ/cnxz3VN5phOoXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=QTYJFWDJ; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QTYJFWDJ"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7dfd667e539so214470785a.2
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 05:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753445171; x=1754049971; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOvBSwwtmNG8Z+SjWPY5aek+Y4mrxHqGqroX/bR/8SM=;
        b=QTYJFWDJ3tGd2PAAbgETtPbeQp+PcYN1md4ep+9RD7ydcd0b5T6i3yxyyRc5s/uUeJ
         ZdMvdx8DcsdOnEMhhc51Fq60XAHYVbP9GGTYywaWEb9ZSaOqVYKWxLiHAlK6/QbmaM88
         dJaZrXgEvczBvf1CTATD0RrogjwhREEiaX2uE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753445171; x=1754049971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nOvBSwwtmNG8Z+SjWPY5aek+Y4mrxHqGqroX/bR/8SM=;
        b=n7swe/UHyWgzhXxzbcLMPa59gZq3ob+ClAjT3x3D+Csy5KoRxXzXHnzHpEXjAJc9ts
         cqGIcpDJbJyqqHMZke5N7OR9OUNINXmUkU/hEN/lKtY0vda7qbZ+gzvnHC0wEPBs8qGO
         K7AtYIREsmHoDt/8zNaaB8GLM2h/zgglHUF5vl/nF05Fk016xMgCdktSHHkngz9ocgyr
         y6llUgohF/ffulV4Rl+h5v3N7xB2OCCifqqcBRbOmHMfAe6nkTGpOI7uZseiCbhdkpvk
         Lx9HRj+A1x9+uFgF8ek8pwCg3Wk/FXtKilCu7PWL6jDRbImyO8a5XjOnObWL/G+gxKLH
         fMKQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2gH38ZcusuTar2ONimLBpK/JJEg7gKE1kggpY5HJQ7cN6COGhTs80JWAuFZuB+pOmdOiEmab0ah6f3KA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI8LYUiNabYTDYBEQxu3v1i05aemO8Wfk/Ar/4ps65uJNNh30C
	s+jHXinIC4F2ACAzoL+hp3ITmTHE4bwJOB/+BrcRr8l+QOra3rlhIz+Xwdm5ihcxGpil2X0E+J1
	QYgw=
X-Gm-Gg: ASbGncuMyPXEbfc06ebCkOeS7omQbAbcS2m7wmoOUceowzOesyEWYtagAsGsjswSa5V
	N3s5Dt52aSspzft7Lis278rloRYHFMz6fQIAlrViPRQqb7skn3NA2MwNt1eOdFUcm8oqxRJWHfj
	9T7QU1LLmtayvg/xPK2SMWj+lReXZYJV0No+jxixmbSA60g5oZxUUPOxDLLN4nV2hVPur0h0J8X
	z2emdsrwvIqBt6fEQ6vbyF+kdx7VUTL/cl924nlJzMYMRIPi83luXZCyCxZushfmf9UpWDkXP5B
	yd7IyCMfHAyZZYUhzzpZrQIJcewdePQYvwbIoM93qf4zUQ0ztgP3+37enGtfC+dxIE4a9tcenu5
	DNtrtnGqut2Qv/noVdkCBo9kR9M1+BQm90fao+vISqUD8kfdQECjD5sg+QQ==
X-Google-Smtp-Source: AGHT+IHKxhnh/6nhpzI4v7r56IuGpwzZywIdAT6uLMad5e6QkxVSU2EefUmDsCbrdGUtIfNh1Uop7Q==
X-Received: by 2002:a05:6214:f04:b0:6fd:4cd1:c79a with SMTP id 6a1803df08f44-7072056af92mr22102366d6.21.1753445170788;
        Fri, 25 Jul 2025 05:06:10 -0700 (PDT)
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com. [209.85.219.43])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7070fcd1824sm25869476d6.95.2025.07.25.05.06.10
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 05:06:10 -0700 (PDT)
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6facf4d8e9eso12847816d6.1
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 05:06:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVMNtmSMfQC+wZBj+UvLtz52saRx9H2cq8xgvXJyWxEnEYIECfUpEq2q1bgfwlhpXcBoIjM6NIeCGSVrBQ=@vger.kernel.org
X-Received: by 2002:a05:6102:358c:b0:4e4:5df7:a10a with SMTP id
 ada2fe7eead31-4fa3fc6be93mr374132137.16.1753440996607; Fri, 25 Jul 2025
 03:56:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-17-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-17-angelogioacchino.delregno@collabora.com>
From: Fei Shao <fshao@chromium.org>
Date: Fri, 25 Jul 2025 18:55:59 +0800
X-Gmail-Original-Message-ID: <CAC=S1nhwrq60q-=jMZQ2u8TwwG9HHnQFWrFRx58VF2K6Xi16XA@mail.gmail.com>
X-Gm-Features: Ac12FXy6b-EYxcfTGxWYM-OfSnpWrsOFjS6YFWPk3kTV_ZIdvcSVvNebJ1JSwHk
Message-ID: <CAC=S1nhwrq60q-=jMZQ2u8TwwG9HHnQFWrFRx58VF2K6Xi16XA@mail.gmail.com>
Subject: Re: [PATCH 16/38] arm64: dts: mediatek: mt6331: Fix pmic, regulators,
 rtc, keys node names
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

On Thu, Jul 24, 2025 at 5:48=E2=80=AFPM AngeloGioacchino Del Regno
<angelogioacchino.delregno@collabora.com> wrote:
>
> The node names for "pmic", "regulators", "rtc", and "keys" are
> dictated by the PMIC MFD binding: change those to adhere to it.
>
> Fixes: aef783f3e0ca ("arm64: dts: mediatek: Add MT6331 PMIC devicetree")
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>

Reviewed-by: Fei Shao <fshao@chromium.org>

> ---
>  arch/arm64/boot/dts/mediatek/mt6331.dtsi | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/mediatek/mt6331.dtsi b/arch/arm64/boot/d=
ts/mediatek/mt6331.dtsi
> index d89858c73ab1..243afbffa21f 100644
> --- a/arch/arm64/boot/dts/mediatek/mt6331.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt6331.dtsi
> @@ -6,12 +6,12 @@
>  #include <dt-bindings/input/input.h>
>
>  &pwrap {
> -       pmic: mt6331 {
> +       pmic: pmic {
>                 compatible =3D "mediatek,mt6331";
>                 interrupt-controller;
>                 #interrupt-cells =3D <2>;
>
> -               mt6331regulator: mt6331regulator {
> +               mt6331regulator: regulators {
>                         compatible =3D "mediatek,mt6331-regulator";
>
>                         mt6331_vdvfs11_reg: buck-vdvfs11 {
> @@ -258,7 +258,7 @@ mt6331_vrtc_reg: ldo-vrtc {
>                         };
>
>                         mt6331_vdig18_reg: ldo-vdig18 {
> -                               regulator-name =3D "dvdd18_dig";
> +                               regulator-name =3D "vdig18";
>                                 regulator-min-microvolt =3D <1800000>;
>                                 regulator-max-microvolt =3D <1800000>;
>                                 regulator-ramp-delay =3D <0>;
> @@ -266,11 +266,11 @@ mt6331_vdig18_reg: ldo-vdig18 {
>                         };
>                 };
>
> -               mt6331rtc: mt6331rtc {
> +               mt6331rtc: rtc {
>                         compatible =3D "mediatek,mt6331-rtc";
>                 };
>
> -               mt6331keys: mt6331keys {
> +               mt6331keys: keys {
>                         compatible =3D "mediatek,mt6331-keys";
>                         power {
>                                 linux,keycodes =3D <KEY_POWER>;
> --
> 2.50.1
>
>
