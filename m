Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631782E2EF7
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 11:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753443883; cv=none; b=SWcrM6t3OsS35unqkmf1xJCxpbRx5tu650GQu4xHRtssDx4UzKhvnNw2DpukLXZi/wZ9GdWOFNFAK/yn345p/If0oXCBQ3fXeTzsnmGDc/W+JDpR9VJLK+1k0Hij6H8CbSvMX6uWbAtbCcDNLzl0rEry/hxEhkTymQl7Y18Buwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753443883; c=relaxed/simple;
	bh=AyRroNoAAfZMLYMuOWzL5KFUvjXMr31GJOyZqB2g5AQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q8VfHD8hR14kdQLwzmhVON1DUbYMd/gh6VnUmSyHDbQOe8Wzuyu6tDPTvzZJ3IMARuUFqhLIHN5t1/ZP4p1PGBsoKZQw0JTa8NdUONJTCGRGInUk8U2SWOgRg+iSqta0Dquu0+eL/4s/dQCQRoXr+MFBRkbbdvcdzFzJFjMw8ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=BGwHZzHt; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BGwHZzHt"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b31c84b8052so2318428a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 04:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753443881; x=1754048681; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t63BOHgVickClQUeVRs7VclE4TnB0fFJ8koSEGsWT2s=;
        b=BGwHZzHtcTWJNwXXWqEC5KXsY5m0AK8jyz4LWC4R2dIXexG1coaY/vFN8d4jIOVwbc
         0Xkmy5fMf9rBzBrFehoj+nuJU/yIJcgg33MaBmXihWrvSV0rY3tr6+Lopsa2hmwBlWUY
         d8yGDX3ukWKmkYlZx07fSv46yRZxCRyX4Wnj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753443881; x=1754048681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t63BOHgVickClQUeVRs7VclE4TnB0fFJ8koSEGsWT2s=;
        b=kiahHqmwMdr+x7AaBhNYPPnYaGZddmX9aF3OpzSYQOO5aHylW/4JT5j5Ny2FWkaetR
         dXgMVJAFx9p1DG2OEt7ROQE1EFkNX4VuDqd83fbxDmFJIj4iuou7t02zPzrF4QE6+7CK
         Wh7UN3byHjmmIbWSy6vwf8Q8gdYFlizEuPz+BuAFP8Gyt9FTrgRUKGxFg7yD0PFw8MWi
         QiIZF/qa5TZhP03x9ia3wCm/Ysbv/ytctFAuk4AevKj2zt6C5/gYLbAU4M97QAAf6nrS
         2kqTU3NH2CJGr9SuyrQCpRyHjFMUyYZL9FrNbOP72+ibP8ZZzW4KBZ1gqWCT1itFi4jx
         BwRQ==
X-Forwarded-Encrypted: i=1; AJvYcCULa4eihfzJS4xooTx8n8q9gsPLbRpXkFwL/WTGMo3MDvMvDLBjQdN8M4jlEY45ZwWQe8CNLRK9o0zxLPw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl2uWY9iM7gQqSE9wDjH0dOdiIbtqXi8oXiVLEpHKClUDto2eW
	iy3El22QG/Vf/PxA5MVf0IYfNveWICYTOiwuLfKT/kv2FalVenlEtoPT7qwNIkL1+hKJLGB5iz3
	FOWw4Joao
X-Gm-Gg: ASbGnctwC0VdTLRctHyYnU5kZfwyDleOS493r/nPz/97X4ZL3QQMYoz/dzIjMx399C1
	gaeYccq0MN838OvXP5Vg+KleYkpxGmbYD4jRq8fdVlpMiLnrhCPfdxJ/sWbwGY5xGd8uSmWAzBV
	r4+moxoum7zJsVtzB6MEs5FmFubdGusxV9F8wuM7PjB02wjs4a/p+yS8K56LQBgJ1dTUriyLbGX
	AQWLuYzNO/27T+n4PqOpwYyHSRTKNTb4U6zCba8f3NEUtjaECEdJDpnthGdp69HpduspzLlihYh
	SoK5gXOwFVO5SrnAAS9DhIur8prpAQlMgS/qS2gg/CW9QtxxAT18UOQ6hpAsRmCxqRH/aAuf4Gz
	0sI2I0UbZHhrzijkxAYy8i0OvcfyxtFDIv6hKELzWF+EF8lar1yYlxpa/KrGK2w==
X-Google-Smtp-Source: AGHT+IE6c3oxBlqWSlt3qlb20MJ2Le5aBa9avcYoHX3dsUfmhFPgdnBW3f/1I1NSxM7bBPCgqAnQ+w==
X-Received: by 2002:a05:6a21:9997:b0:232:a885:e84e with SMTP id adf61e73a8af0-23d70171b30mr2544858637.25.1753443881485;
        Fri, 25 Jul 2025 04:44:41 -0700 (PDT)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com. [209.85.214.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-761b061a53bsm3707040b3a.116.2025.07.25.04.44.41
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 04:44:41 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-23f8bcce78dso23290705ad.3
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 04:44:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWgCVuDSebIL/beCAK+Fql6M74ZeP41NqgPDENqTJ9B8Fpf67b8axoOuXzDceco9kvu4TDXzj66s0lKnug=@vger.kernel.org
X-Received: by 2002:a05:6102:3053:b0:4e6:67f6:e9af with SMTP id
 ada2fe7eead31-4fa3fa71860mr256656137.9.1753440125688; Fri, 25 Jul 2025
 03:42:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-27-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-27-angelogioacchino.delregno@collabora.com>
From: Fei Shao <fshao@chromium.org>
Date: Fri, 25 Jul 2025 18:41:29 +0800
X-Gmail-Original-Message-ID: <CAC=S1ni_6YRK0RWheKZJDgCknaZzPsde0J4dFdmkNhY7HMMD+w@mail.gmail.com>
X-Gm-Features: Ac12FXwspafB6XO0s33DaaDCIfXTapXC0TbPbPDsXvwxpmO6Wfy_iIb8kWhO-Rk
Message-ID: <CAC=S1ni_6YRK0RWheKZJDgCknaZzPsde0J4dFdmkNhY7HMMD+w@mail.gmail.com>
Subject: Re: [PATCH 26/38] arm64: dts: mediatek: acelink-ew-7886cax: Remove
 unnecessary cells in spi-nand
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

On Thu, Jul 24, 2025 at 5:50=E2=80=AFPM AngeloGioacchino Del Regno
<angelogioacchino.delregno@collabora.com> wrote:
>
> There is no need to specify #address-cells and #size-cells in a
> node that has only one non-addressable subnode, and this is the
> case of the flash@0 node in this devicetree, as it has only one
> "partitions" subnode.
>
> Remove those to suppress an avoid_unnecessary_addr_size warning.
>
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>

Reviewed-by: Fei Shao <fshao@chromium.org>

> ---
>  arch/arm64/boot/dts/mediatek/mt7986a-acelink-ew-7886cax.dts | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/mediatek/mt7986a-acelink-ew-7886cax.dts =
b/arch/arm64/boot/dts/mediatek/mt7986a-acelink-ew-7886cax.dts
> index 08b3b0827436..30805a610262 100644
> --- a/arch/arm64/boot/dts/mediatek/mt7986a-acelink-ew-7886cax.dts
> +++ b/arch/arm64/boot/dts/mediatek/mt7986a-acelink-ew-7886cax.dts
> @@ -98,8 +98,6 @@ &spi0 {
>         flash@0 {
>                 compatible =3D "spi-nand";
>                 reg =3D <0>;
> -               #address-cells =3D <1>;
> -               #size-cells =3D <1>;
>                 spi-max-frequency =3D <52000000>;
>                 spi-rx-bus-width =3D <4>;
>                 spi-tx-bus-width =3D <4>;
> --
> 2.50.1
>
>
