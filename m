Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BABB230D0E
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 11:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753443658; cv=none; b=imS+7ER0gDN+ic2N258Yz5NN+dpNtNI6ehxD+hKUP7dtup+zht4r/1SauoZQnA6GV/q+Awmf0LzUEN2AnNK+2Xnokk8zVj7bP+FlQaVjlkGrPXE69TMoIcLubNFWbbdV0mnCWBUpcM+ofD9p4iEaoFpUMTVP+GF0cSRlbsbZGEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753443658; c=relaxed/simple;
	bh=DZf8o481vjpJ7QSUoolpwJajFBT1Vwo8xHyfUgSq//c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eVs4RUHugceduedVS+b/bhaOmIjzMhg4cnTy9EhDlklIZUxIZfXgAqUGh9DqnZuziBfHdnhyCA+v1RHkk7cy5eM/papsUWoCbesBXdgi2sEG1yQaDR8na/a8qFYM4T0fZ9xtVKXKZFA8mFl5CKnnjGw8DwsHJGklhsTi+FbGrwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=K4HtK07+; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="K4HtK07+"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7e623a12701so304885885a.2
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 04:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753443656; x=1754048456; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PlkE41QL6s4x1GqYESsGC6jimQ+2xKl71+VqMJsnR/Q=;
        b=K4HtK07+eXTJIg66Uek6OEDoo0c9x66HX5l5SmvHtgYtF/Z5Y8JYD58tmqS+Kz/0S5
         BvLRMs9D5r/6Iaddcfpc/fRTCNE9kRkLusAnmwuvuMRF8nERAjwpypiuH1sEf/Dhldcq
         ffvouKx29G9M/18HXSXRUqrf58pCsqXtxFYHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753443656; x=1754048456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PlkE41QL6s4x1GqYESsGC6jimQ+2xKl71+VqMJsnR/Q=;
        b=lEZQFKfalytSbBg5+6+4zfNoZ943yqRP319RKO04M0pXQZtga+mBGSdGLPMY+TQKGX
         Jp3PRg2aTuX8fAlaXqMmwlxKEhXRlMkKw42kUdwyl+xdp7biBOp4mb1qVByi8XBkbbo1
         hMMi2gUaww/j0Zjhsekz99EedfHrkgPjrj+Jng9IlMMPmNPGVoVAP87loPMi3Jv8/7DR
         mqc84QekHLlXR7U/7qeeIv1JDCoDIPttcY1PttqR5h4V7RMdba9woTMYWhZ0u4/mCrmS
         QxlUID9CBzspqn4u5J1atkwiFBB1kQjDFDummsFr2NRelIhjXMxiJA1S4OsoY4BKjb4p
         BfjA==
X-Forwarded-Encrypted: i=1; AJvYcCUN4/cqP51KSUgd7OmiZMU84zL0HXrFlpaSAe5ZkgqX+jv6kaPAt/jIdzlUUiIN6AhFOuRV0k1bxG+cy6Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEAOoH4D7wq/hYkNSpcB2el6zCsmPWpXJvxr0JB8OWVcZZY4fb
	MlQfBStBMBM6V5ptbj9ITlKTPofO4P9ZDeuDJbjUvSytKljMzvfVP/6NRt3a84LQq15Y1XPI4WR
	7kY1aPEEU
X-Gm-Gg: ASbGnctmJTJLw1XCW7MBwwYScsGerrMy9skV4F1OlsZwwlOc6FrcHm0qXxyHGhaRylb
	WX8fiBYIkNv1oiYmvg4muWO781hBycVAJ25XdfHrMhKutXcTom/BjnbJwigRuujn+rkh0E9qqmz
	uNiE1E4002vSV1gYmWPzwb9UFO1m728cvztEDrxmGSAf+z2LkQ6cHVrmPWyUn/pGLA8YjpL8Zb0
	xk0HS9N2eafle5ciuYl5G0eQKlCLuIevWwd4za6thTsu+mpuoxKKM8hli/Nz3wiWn2q+6hyCp+s
	hKYC9lr7ApAcX6e4b7gk7ZDE0Fc6+hEcJbrMjsTzXvWi1Nr6sU7DOcTogxXld1YwLlQAkuHcEmq
	y+d4LDpZz/fGkG18bMqlq9yTnJHIouT11SdfLQy0vT+kYJyM6GXVj0i285w==
X-Google-Smtp-Source: AGHT+IE6uc35nvs96hNAT82KBiiI2oD+Zdrrh3/4VuLkBuI6V0v+z1FGSWB/0IBm7dN8pWb6MucGJw==
X-Received: by 2002:a05:620a:6cc3:b0:7e3:43db:d5ca with SMTP id af79cd13be357-7e63bf75f0dmr192801785a.27.1753443655700;
        Fri, 25 Jul 2025 04:40:55 -0700 (PDT)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com. [209.85.219.47])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e632e3881csm241200485a.75.2025.07.25.04.40.55
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 04:40:55 -0700 (PDT)
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-7072628404dso1867516d6.2
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 04:40:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXwvMrvoHOJcf+fgSNMFag3TdXxjJ8MFQ6QNg/IyZkPTT+UuWLphqgEEUDHIuejv+mLcqEMgo59HCzfW0I=@vger.kernel.org
X-Received: by 2002:a05:6102:4a8f:b0:4e9:a2bd:b456 with SMTP id
 ada2fe7eead31-4fa3feb1976mr334393137.12.1753439957846; Fri, 25 Jul 2025
 03:39:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-39-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-39-angelogioacchino.delregno@collabora.com>
From: Fei Shao <fshao@chromium.org>
Date: Fri, 25 Jul 2025 18:38:40 +0800
X-Gmail-Original-Message-ID: <CAC=S1njc7_+EhDA_HrVsPfhYsrFEmeb5TQ55X+YOKE=NrpoCaA@mail.gmail.com>
X-Gm-Features: Ac12FXzORC58mPF_B982fHDjnhtiL_-5O2nAq5PI4bkUJDNwvq8vw0VlaVEnRW8
Message-ID: <CAC=S1njc7_+EhDA_HrVsPfhYsrFEmeb5TQ55X+YOKE=NrpoCaA@mail.gmail.com>
Subject: Re: [PATCH 38/38] arm64: dts: mediatek: mt8516-pumpkin: Fix machine compatible
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

On Thu, Jul 24, 2025 at 5:51=E2=80=AFPM AngeloGioacchino Del Regno
<angelogioacchino.delregno@collabora.com> wrote:
>
> This devicetree contained only the SoC compatible but lacked the
> machine specific one: add a "mediatek,mt8516-pumpkin" compatible
> to the list to fix dtbs_check warnings.
>
> Fixes: 9983822c8cf9 ("arm64: dts: mediatek: add pumpkin board dts")
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>

Reviewed-by: Fei Shao <fshao@chromium.org>

> ---
>  arch/arm64/boot/dts/mediatek/mt8516-pumpkin.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/boot/dts/mediatek/mt8516-pumpkin.dts b/arch/arm64=
/boot/dts/mediatek/mt8516-pumpkin.dts
> index cce642c53812..3d3db33a64dc 100644
> --- a/arch/arm64/boot/dts/mediatek/mt8516-pumpkin.dts
> +++ b/arch/arm64/boot/dts/mediatek/mt8516-pumpkin.dts
> @@ -11,7 +11,7 @@
>
>  / {
>         model =3D "Pumpkin MT8516";
> -       compatible =3D "mediatek,mt8516";
> +       compatible =3D "mediatek,mt8516-pumpkin", "mediatek,mt8516";
>
>         memory@40000000 {
>                 device_type =3D "memory";
> --
> 2.50.1
>
>
