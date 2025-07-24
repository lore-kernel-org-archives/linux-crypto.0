Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2D6238150
	for <linux-crypto@vger.kernel.org>; Thu, 24 Jul 2025 09:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753348596; cv=none; b=LJfOg7KFM93GX21ybAWmHeDCBlbkIu9th5KVaXHcCcByXj3xXveC4k0j4H29ZefvbsFclNsKE1a3sWuESibORB5AyXgAbHRgtQ8hteDzPTauCruQOJFvEz+JUWc2pd27l+FemARGG+FDNcVyIxVOdKWo2BZfMk4F0C29jdcyWEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753348596; c=relaxed/simple;
	bh=+Z5k7cYpy/tb3WBWJYgYNu2N1HaIlkdbbuwQhmQGG2A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nYV1P7zbCfeysplCYa9eoXewt9t0wf6K/vgbvCP8AlNAkzty4vi+PZ6W3u8dkp44pHSv5YgS66sL4by1iT5a5NYQaB1X/H3HPOdJUckMdB3hl89h3il3nYHih6To0JUs19kqpUrGRVfWWiuT6LOFPosgXkadn58dWZBuQC+iOC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=NSfngbi+; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NSfngbi+"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55628eaec6cso720956e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jul 2025 02:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753348593; x=1753953393; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1EGUBO7UhvbornJQ/pvHFRfx3IzKAnj1mgdzrBixYxY=;
        b=NSfngbi+EdP+b2lqHxlZKJqnzPS4zhclgoqqq+ra7+Hv99LcP+FSVIsZaJcs2FhecI
         nR9kLmfIuVJHiOS0S3vMmxv/gXOZWj5EG2VMZihq7UxEuaMt0s945yQ6sOKOTC7FRKfj
         e4/NLsRu8RpKVatV8x3jxfwUFT8MDZaybw1lw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753348593; x=1753953393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1EGUBO7UhvbornJQ/pvHFRfx3IzKAnj1mgdzrBixYxY=;
        b=tiJ8EzdyOGnxl9ZXYngyfQMJ2uRpGxxstdQE376mhIq8XuHgqlngJy0+NL3q2PV1gc
         m//1dEqXim5QpsYIqV7mH/aSj/XfVx6B781hKNmEaP/MCOqiPw6tLAhKBrO147/5xWjx
         fUkiKhGB8l77oqrpiGwmV1Tsz03fgwLFb4WDnS9ImH2zDscInh+3v/3tI2jqcP4WlShu
         fhe6lCprpd4rfUDiEA+J/fuiqAN6tqaQBpLuaW5HJRTum49x7jgamAApzXFFWiNFHeio
         DprhuVE7tsHJUkQ4efd1/brr52hEd7BNtU0GGhoW253p9vlDCJBCCM8HzuLiVANXbD6G
         ln1g==
X-Forwarded-Encrypted: i=1; AJvYcCVYpSXssei/oMqs5hKOxYwhQD6LMuDQ6IyKzSmVgucJCDyZURCmv+keNWzQzfB1xEhftJ3MSx2CsMyUBl4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNrBLdy5ohUwYuXumzh+h36YNkZ8VzXvpsUFyaEtxeuyn9OejZ
	HQXjTY7e7FLR4D9Hj5UL8rRoHL62MjF0gTVGXtzjqHNgBkoCi70HwLt8n69MYL1pLXEO+BRijL0
	rznh4+2q2kSSOo4RmfadJDOtn53tjstwjVtCWZ5dj
X-Gm-Gg: ASbGnctcx8mT0e0jT3ZuYFqIZbPgkEG0UA9YbPUsShKII82d1ei7rbssmZaaMDNxAHL
	X3/W3wLbN3Yw3Ru4EXZ15vBuFgsoUodX9oMZLILQbfXk1OLuvoTLwpr2epqD7tRE0q4OFwXY1zr
	BXldOIVR1pqUfCUP0RUw7bf3fgc2TSzwMIq0+1UP79kSxEcKXmfTl9qV+FmsytkL+g0FFKHzI2D
	U2tuWZ5zdB6w8qqzcDNNlr6F+BIhaHYCEI=
X-Google-Smtp-Source: AGHT+IFazo0IJsf/W4w5gkkS9NANKkfwPsnIOoIE7mqPwq0TufYlLOotKobMGK5+6Hu6w3hpGvP3VOsw43jDOtB0xs8=
X-Received: by 2002:a05:6512:3ba6:b0:553:6583:8e6 with SMTP id
 2adb3069b0e04-55a5136bd25mr1849929e87.15.1753348592903; Thu, 24 Jul 2025
 02:16:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-2-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-2-angelogioacchino.delregno@collabora.com>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Thu, 24 Jul 2025 17:16:21 +0800
X-Gm-Features: Ac12FXzsHRsmJR2EJuPhkIesX-COS28ovNftNstiUszbMRhNBb7-HPz6xQpMdw4
Message-ID: <CAGXv+5HTdK8aiUYdtNVhWAvsSNfMPgK6iCqe-Jsb-OBqQBWsBg@mail.gmail.com>
Subject: Re: [PATCH 01/38] dt-bindings: display: mediatek: dpi: Allow
 specifying resets
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-mediatek@lists.infradead.org, robh@kernel.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, krzk+dt@kernel.org, 
	conor+dt@kernel.org, chunkuang.hu@kernel.org, p.zabel@pengutronix.de, 
	airlied@gmail.com, simona@ffwll.ch, maarten.lankhorst@linux.intel.com, 
	mripard@kernel.org, tzimmermann@suse.de, jassisinghbrar@gmail.com, 
	mchehab@kernel.org, matthias.bgg@gmail.com, chunfeng.yun@mediatek.com, 
	vkoul@kernel.org, kishon@kernel.org, sean.wang@kernel.org, 
	linus.walleij@linaro.org, lgirdwood@gmail.com, broonie@kernel.org, 
	andersson@kernel.org, mathieu.poirier@linaro.org, daniel.lezcano@linaro.org, 
	tglx@linutronix.de, atenart@kernel.org, jitao.shi@mediatek.com, 
	ck.hu@mediatek.com, houlong.wei@mediatek.com, 
	kyrie.wu@mediatek.corp-partner.google.com, andy.teng@mediatek.com, 
	tinghan.shen@mediatek.com, jiaxin.yu@mediatek.com, shane.chien@mediatek.com, 
	olivia.wen@mediatek.com, granquet@baylibre.com, eugen.hristev@linaro.org, 
	arnd@arndb.de, sam.shih@mediatek.com, jieyy.yang@mediatek.com, 
	frank-w@public-files.de, mwalle@kernel.org, fparent@baylibre.com, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-phy@lists.infradead.org, linux-gpio@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, linux-sound@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2025 at 4:39=E2=80=AFPM AngeloGioacchino Del Regno
<angelogioacchino.delregno@collabora.com> wrote:
>
> Even though the DPI IP has a reset bit on all MediaTek SoCs, it
> is optional, and has always been unused until MT8195; specifically:
> on older SoCs, like MT8173, the reset bit is located in MMSYS, and
> on newer SoCs, like MT8195, it is located in VDOSYS.
>
> For this reason, allow specifying the resets and reset-names on
> all MediaTek SoCs.
>
> Those properties are optional because there are multiple ways to
> reset this IP and the reset lines in MM/VDO are used only if the
> IP cannot perform warm-reset.
>
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>
> ---
>  .../devicetree/bindings/display/mediatek/mediatek,dpi.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/display/mediatek/mediatek,=
dpi.yaml b/Documentation/devicetree/bindings/display/mediatek/mediatek,dpi.=
yaml
> index b659d79393a8..eb4f276e8dc4 100644
> --- a/Documentation/devicetree/bindings/display/mediatek/mediatek,dpi.yam=
l
> +++ b/Documentation/devicetree/bindings/display/mediatek/mediatek,dpi.yam=
l
> @@ -102,6 +102,13 @@ properties:
>        - port@0
>        - port@1
>
> +  resets:
> +    maxItems: 1
> +
> +  reset-names:
> +    items:
> +      - const: dpi
> +

Do we really need the name if there is only one though?

>  required:
>    - compatible
>    - reg
> --
> 2.50.1
>
