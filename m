Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2F72E5B05
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 10:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753440671; cv=none; b=MQdNHCsAkcCi7kqGICKCSVf/GPlqHMe84G5G+GxyIx6kB/xDvN711PbNJP9oMPoX2QFx73E0GnLlbW3MCH4GupmD12pQaSQPrxPyVi4eMIn26QgBojb6gAgSu5l98iI1rDfV8Yzbj0vOv8bvTxk4DvCGSqESsPrPPEg9Oe8cevw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753440671; c=relaxed/simple;
	bh=KqH01V/ZQOGZhBJpHb3zgphhQB1Sh25Ttt4gkVmURXc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gBWswHOkaHmJ3hlmny0QiE0bTJilqwvAW1yrYxBurpdBn9S2hab21KJsrWt3XleXha2GXq6Ls2TObec48PMOXNFXtye8XMTwQHWLXhjzh9zjekZNMLiwwVElkiBFkER8FrpnnsWDxFHHC0buGfCGlN1UXtX2Z8ukUhXNIicmaF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=hYz7Xu9K; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hYz7Xu9K"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-73e82d2ec21so983718a34.2
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 03:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753440669; x=1754045469; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YfE909p8Iq119G3J/2SxiBSXlMMdz4SFa3hpgANK2k8=;
        b=hYz7Xu9KEyKp6L2CJr4COvW4eQv87T9bO8vnO7d4laxO769bDyrvQKXadbIF66Gmry
         3jaQtWRNw4vmVfhFjOTJK7x9RRjCiMOrnAKmmQtBvUSDLng/mCxDbozv+TiF2V6q+Wg4
         ZNhK6G4EHiC2ThMDzKyUd/pRaw91nb4T86+Y8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753440669; x=1754045469;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YfE909p8Iq119G3J/2SxiBSXlMMdz4SFa3hpgANK2k8=;
        b=muDMoAg5KSFOqV6rlRNcrtkQCNzH2gLatBfbq7pGb1lnZARWWS9hrUSvgjBaBRrz0f
         KlO2I3MgCTF+9Fa/aSmMVl17S3/zRmk8mt656+3RPqhm+v8AnthqP+Y5SqtnMiif94lu
         a+BVHAsLyUF4VXlUHv6TjIvAVFfzrQVsSOR+SMz20FqiOZ+nLTjC7QUh9c3ndOQua6Hr
         8a6fTQYMGk1XvqdkN3cUBFKBxoie2OslMA5sYBtrhO1JlDub7zvHKd+1tpOT5hh+wqdi
         suMNsoYUkAMFcDsn7ob93urZhG9hWoeXVdkkrKe3TDIJhtoFD5qG8fFMkBqtozDR+znr
         N8yA==
X-Forwarded-Encrypted: i=1; AJvYcCX3ytWjIij6/3mTJCUQBd2Mi1pJv2xp+wIApTZyFUI//mX3HNt/5aU6WF5sfiaZfTxSp64h22Bh1cvlRRA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzyKTHCw6oP/jkqIoDkdscueoJ7G7R2M5mSlHCQ7nD1aNu9poP
	iq3ZZOZcWCIxeSkN3+PPfoCHG0l7lZkFpLWDXlzrDTmkC2S4db0QYSYsiXsaRmoiPmOO93VVvaC
	GUr/sdA==
X-Gm-Gg: ASbGncul49UYDbLcm8SwwU5uLbByRAZfcHMSxymFkcMujQ855ojjYgQAQBVLZ3jmihA
	vLueiZevsqRJI+/CWDuq40g9M/LBmn7KQq6nPzb8FjCtcSxvK7Y38AG+5tmnpewazqkprw+sopO
	GXGOsVM5BbgzXoF1tpK/+UhmvDhS1InsNC5sSRT84hoWe/rqQX9ovsjzWOFtuxpi8LMlgVW2Eho
	e6TIN3YvRsRlhixwT/SLn5fFMeKrG1VBOKI+Sf4HF803S0h3XZ9lw7v+S7wgLKxFHTFbJ0+UNPz
	sS0poAde3R+K0OkDepJjeEvDPRXoWgmO2C7tjRHybjFuKPridOegoSzK67GbF63NEKG6imrVXNV
	9Xyet4T5PwGYDvQNR5OIl007o84ijF/gykKfVIb9lkTeUZN/gsf+8Gm/RMSvP3rZm5ImQ
X-Google-Smtp-Source: AGHT+IHPyJ9ALVUIhM3XS7NN5PS95eRVed6+aypjhYo1s8N097qorF5KEQ2XeJDjNrF83hDaearkSA==
X-Received: by 2002:a05:6830:4d8d:10b0:73c:fb75:d571 with SMTP id 46e09a7af769-7413dd42ab0mr463230a34.22.1753440669051;
        Fri, 25 Jul 2025 03:51:09 -0700 (PDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com. [209.85.210.51])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7412d2e5d83sm625127a34.40.2025.07.25.03.51.08
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 03:51:08 -0700 (PDT)
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-73e810dc245so1074858a34.1
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 03:51:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXAP2Xsr61LMI9yu3jByPus5QOdylE1yPRTN14fMDTUa4G48OOqMLnm15bcI9ZwkTmPTPJcXoOxoIHVz9w=@vger.kernel.org
X-Received: by 2002:a05:6102:3713:b0:4e9:b7e3:bdcd with SMTP id
 ada2fe7eead31-4fa3fad468amr285963137.12.1753440273293; Fri, 25 Jul 2025
 03:44:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-24-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-24-angelogioacchino.delregno@collabora.com>
From: Fei Shao <fshao@chromium.org>
Date: Fri, 25 Jul 2025 18:43:57 +0800
X-Gmail-Original-Message-ID: <CAC=S1njhu11nHpyMULbK6PE-BLrBMq+d397pDU6gBzgo7xivXg@mail.gmail.com>
X-Gm-Features: Ac12FXyc7RkTIKa4HnSlf_SM-GYdwIREUn6AcAkOBKhNuekdCdvFzy29o7Ufs68
Message-ID: <CAC=S1njhu11nHpyMULbK6PE-BLrBMq+d397pDU6gBzgo7xivXg@mail.gmail.com>
Subject: Re: [PATCH 23/38] arm64: dts: mediatek: mt7986a: Fix PCI-Express
 T-PHY node address
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
> The PCIe TPHY is under the soc bus, which provides MMIO, and all
> nodes under that must use the bus, otherwise those would clearly
> be out of place.
>
> Add ranges to the PCIe tphy and assign the address to the main
> node to silence a dtbs_check warning, and fix the children to
> use the MMIO range of t-phy.
>
> Fixes: 963c3b0c47ec ("arm64: dts: mediatek: fix t-phy unit name")
> Fixes: 918aed7abd2d ("arm64: dts: mt7986: add pcie related device nodes")
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>

Reviewed-by: Fei Shao <fshao@chromium.org>

> ---
>  arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/=
dts/mediatek/mt7986a.dtsi
> index 559990dcd1d1..3211905b6f86 100644
> --- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> @@ -428,16 +428,16 @@ pcie_intc: interrupt-controller {
>                         };
>                 };
>
> -               pcie_phy: t-phy {
> +               pcie_phy: t-phy@11c00000 {
>                         compatible =3D "mediatek,mt7986-tphy",
>                                      "mediatek,generic-tphy-v2";
> -                       ranges;
> -                       #address-cells =3D <2>;
> -                       #size-cells =3D <2>;
> +                       ranges =3D <0 0 0x11c00000 0x20000>;
> +                       #address-cells =3D <1>;
> +                       #size-cells =3D <1>;
>                         status =3D "disabled";
>
> -                       pcie_port: pcie-phy@11c00000 {
> -                               reg =3D <0 0x11c00000 0 0x20000>;
> +                       pcie_port: pcie-phy@0 {
> +                               reg =3D <0 0x20000>;
>                                 clocks =3D <&clk40m>;
>                                 clock-names =3D "ref";
>                                 #phy-cells =3D <1>;
> --
> 2.50.1
>
>
