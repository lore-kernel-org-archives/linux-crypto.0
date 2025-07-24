Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D3725A631
	for <linux-crypto@vger.kernel.org>; Thu, 24 Jul 2025 09:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753351141; cv=none; b=hQt7aapBZrojCrbsfvX/b/Beln8ZGGhjo6WUWCIkvTRYgrfwnJibA4V3atGmuQKJkP4sayiC9Y8mfuaRlTEpveQvRoMZhpfNGmXaBqof1pCCQmSQlXuXvh8ptd0TIM6rFlpHQV+vXoKL27mBuLk1RHDD2n4NCD3lLQ7/mh2YxRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753351141; c=relaxed/simple;
	bh=3lDH5ARB26e8DbHF4MxQq93Rk0WGstJeVZQEGstfRkg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eNab8yJfpYICvXVNMJfeChn7dE1Tn+G+k7fHHKH61e6mqN5R+QgXlAXhUFVwmSkImg0DKXCsFE8OP6lxuij8qzC2PGQpBfrQdx7T+QP2ONjQxaM/DM0fNnQOUgNgVem94oN5/2Kp24f1tdpUAky0ahoUjUiCxh672VmKmZQvcIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=MJDwGuzd; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MJDwGuzd"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-553dceb342fso636961e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jul 2025 02:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753351137; x=1753955937; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3lDH5ARB26e8DbHF4MxQq93Rk0WGstJeVZQEGstfRkg=;
        b=MJDwGuzdBt8lJEfC5oMMVj5dgKxNuAi/xNdia9i31OCMslYNVG2vNAeRuO0iAUKzgL
         b3J0gGVCbd+ivE/0w+/xSCJxTUi4kkSbE8IACHtpmhVNDZha5m/d5G9FgrsP2qlowuyk
         yYWXslIJQsZ71G6vkM06Te+OZ+/L6ZQjzl508=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753351137; x=1753955937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3lDH5ARB26e8DbHF4MxQq93Rk0WGstJeVZQEGstfRkg=;
        b=pwAVB28CO+yoAmjAwJe6wyOyOLxsLFzUrNWdJ1vsiC42yEjsLAC9kVxWYnA+uP0KBy
         gvjH1NXCMjiaG/KEl3mO116PMnL1JTt1Ih85seyfCgagUtrKOzorsATuoN0lVqBC1XMl
         cVRcdG6ILQharrBYyZSACHkviSn+vVgP0CEi+eSvBHF1zp1rF68fTtIT1djdzpZ002gH
         RdUwHNtpIRPvHuFtHVZEZgX4acBUGFeIdZBTIEYttUxNUegr6LGo0TTgGiBKDMInlb86
         hb7UAYfBLVohzRkCY0oPtmPeiNJAZ06NI/1CnsjAoiurGnpUXokbKbj8ie4PsNZ+t0/A
         YukQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZ+Gg4aVE6BPx8lqV1XtO4u1P+QAsHpp9nrh7BNraYZ+RZE7i/JsOU90WkUzwp2GlbWh82MNMN3jKLW4c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8+TGlABePJJy9NovfkXEzGMttyXBxpccV1Vj09ca6x1yIoc/E
	CqI8D/Cn04a+DxpjJF/l6tJxRDWgRNCvltCXQQcLGMiH0AU1CcWFSHLFeXN/MDV287LY3Y7s25e
	v2pE7LSk1Ln4zcE3G+VrcAy/ea7V9ld0HMHs1Z2Fi
X-Gm-Gg: ASbGncv2pFMluJAfe6lSH+hqqprG8YsWteo8dWdCUDUx2lqL1+md+9SGzV8kjke+oCi
	T+AVwFPqq3mInrC168ig/srHJMP6zodly3YGZowKl85VFz8PKSL47IRTuJHy729elKiX90SqsC1
	E/100byarfepT/FeLLCUoKI+03hu9SAycVyYnuPpdOavJ/PiXsYkFKBZ2NotBnIdJRx41QJjtWe
	33TDFr3uoeBlAxiHEu9gDtwm0hSR2DWlHE=
X-Google-Smtp-Source: AGHT+IFbWpnNaQRMkmMGCWJwKWLSFPCgKrpUVJhkWhmCg8wuzEAglTGmiTQG4cugbeqoeX5uFAZWT86WnfNSaUywLGk=
X-Received: by 2002:a05:6512:60d:20b0:554:f7ec:3b23 with SMTP id
 2adb3069b0e04-55a51359f3dmr1559012e87.15.1753351136563; Thu, 24 Jul 2025
 02:58:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-37-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-37-angelogioacchino.delregno@collabora.com>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Thu, 24 Jul 2025 17:58:45 +0800
X-Gm-Features: Ac12FXwhroXh9igzrCvp17h0_fa0JxIrUDzrCtprSHzHickYMU-wGcIvqxYBtBo
Message-ID: <CAGXv+5G3kbSzs99mogy57mh+LUdi_87zBmFH8GQFWvROhLFbDg@mail.gmail.com>
Subject: Re: [PATCH 36/38] arm64: dts: mediatek: mt8195-cherry: Add missing
 regulators to rt5682
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

On Thu, Jul 24, 2025 at 4:41=E2=80=AFPM AngeloGioacchino Del Regno
<angelogioacchino.delregno@collabora.com> wrote:
>
> Add the missing DBVDD and LDO1-IN power supplies to the codec
> node as both RT5682i and RT5682s require those.
>
> This commit only fixes a dtbs_check warning but doesn't produce
> any functional changes because the VIO18 LDO is already powered
> on because it's assigned as AVDD supply anyway.
>
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>

Confirmed this matches the schematic.

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
