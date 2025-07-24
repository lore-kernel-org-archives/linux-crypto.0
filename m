Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22D3255F4C
	for <linux-crypto@vger.kernel.org>; Thu, 24 Jul 2025 09:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753350602; cv=none; b=lvmyOMi9G6UN86FsrEMvw3iXp6z713P9sHswPEgzr2ZM/I2hgDnDRrALrLvTYSj0CPAybxrMkgOX8Z6brsVSxCf6Ud+Z+VH//fpC+OYH3sppIiI+UZgKPqbxjLfAbCH+aK2FTDLCAIbLJ5xzmiqh9ZnGvV0p49fKBXzHFhh3i9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753350602; c=relaxed/simple;
	bh=+1yeaes/5WO9C98Ce+RQRl+sqAXx+8dUlJLLdWKreso=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z2N48rOkeSDm/9xznmEk6FmLhEwfrYBQGnCb5etjVmRPW+aDZ3NG0BjskFNJKEnlYwCHyhiOjfgYKiohj3jScEVrmB/VKq53iuBZKvtu8buWMoldP16iED5BVq+tcIvZflvholNR1hH3cHQJaMTzSHWGE6lWUge8BqTiXP/GoGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Sx/xulJh; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Sx/xulJh"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5551a770828so822622e87.1
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jul 2025 02:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753350598; x=1753955398; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+1yeaes/5WO9C98Ce+RQRl+sqAXx+8dUlJLLdWKreso=;
        b=Sx/xulJhXt296mnd751zlozvO9hmHj6VxjVSAz8m6yTaPTLv9QBPC0UptAjx0eFuVc
         XmD/9IGcm1tSFFDgNReWTVEZf+hA+8drt6emVomXJ7FjbsSwi83t3hHFemM7lEdWVSOt
         sB/lZmGDjPF0DhLo9GZr1YyTbyTdsnurUXtf4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753350598; x=1753955398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+1yeaes/5WO9C98Ce+RQRl+sqAXx+8dUlJLLdWKreso=;
        b=PupgSah4fY+KigTcgmuM2Z4QCL00xBUb5loZUNrVDIbEOSGbv3a3586sils+Y6KT2e
         SSOP981evntkdodwsNbtyD0araZFPNjo2zs1Bi8PXFzm295uLNZsGpBy/WBXe5HQcKvO
         drg4cLjBUOzCsytOOC4JqRYdFmhKgHlmkeVHSUa903Dfp91cLe/2Zfd6dORQih/pon+p
         6yI0eG9i2Zcn/wlZEoIm74C/EmbM7gIgxjWQv9c/QJUhaqPIWJOBDg9q/mhYwOJRVUhA
         XHV7Y4NZkjLoVovLr2hSQ1T45EwKOzhDnZjqFBuHnoVXaqc704rhRyncY/280lKoRaB6
         Su9A==
X-Forwarded-Encrypted: i=1; AJvYcCUigsEEqKIqGEqZDMSNs4Vw7UHhyQDjGsS1jNJDyHFIphZKkPnj4MCsLM1koZGshPfvwGXZFAn09V7MmEE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLHg9OP77CuzhRKxNcFC5orCJPmZZ1FkRWKEOYuhjpSqHs/Jxy
	wHvqbBJGn2LM9wmVSZhJm1ueFARHmp4Fz994uqqv8+hpWWQJvzE87swOfqgnhdIopAVNISplOZd
	fVv0vgOeq6yRlmERImibEyVGwNTOFe9jRzZOPoY0B
X-Gm-Gg: ASbGncuDPA1ZgOQZX2rGiHhMfVCD1vpMjGCUqCyZDb1FhchjbBLVk8OEUocc+ayqd5T
	gqTypqMHZx4JJ2cZXkfhbfq8knZmSLnfQQcoPrt/VbwTyope7bLYBa4d0GI9xLSVltYS3suo2Jm
	LO6zOPf3kiZKqNSq7hNpuNeVNjZOZEy08ic7e1iQP0zGXfBVbjbyadREwGivTsb0fUPOjctIzr/
	XwSefgdcyGtQkpGaqkEVzpvULRFg5DRK7A=
X-Google-Smtp-Source: AGHT+IGItj9eON5joXD9a2IIIdgBC35OTh38AkPzmXEBTTEZMPnEPcqJK3Z5OhBEkyMLKp8WCCWs6kzvOlePUXbqfGg=
X-Received: by 2002:a05:6512:239d:b0:553:2dce:3ab2 with SMTP id
 2adb3069b0e04-55a51354ddbmr1925545e87.6.1753350598082; Thu, 24 Jul 2025
 02:49:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-4-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-4-angelogioacchino.delregno@collabora.com>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Thu, 24 Jul 2025 17:49:46 +0800
X-Gm-Features: Ac12FXyptxSYdnZvhVmVzcLhUSOXFaRzx8la2O9AgbSx3nJkJt7JLwM6IxluTrU
Message-ID: <CAGXv+5FWV+RtWUJW=e5pJKiSpeK57fHpTrst38bN=1OSgf6P9Q@mail.gmail.com>
Subject: Re: [PATCH 03/38] dt-bindings: mailbox: mediatek, gce-mailbox: Make
 clock-names optional
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
> The GCE Mailbox needs only one clock and the clock-names can be
> used only by the driver (which, for instance, does not use it),
> and this is true for all of the currently supported MediaTek SoCs.
>
> Stop requiring to specify clock-names on all non-MT8195 GCEs.
>
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>

BTW, I see that the cmdq driver has support for sub-nodes which was never
actually used, possibly originally intended for the MT8188.
