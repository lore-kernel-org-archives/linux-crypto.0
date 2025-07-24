Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903C9259CAB
	for <linux-crypto@vger.kernel.org>; Thu, 24 Jul 2025 09:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753348626; cv=none; b=KaQKak6db1jy/M2K7C+FwZja7VGpSFyLXXXP2OTuHhj3EWJSNYp0myDzCfbDW062jFW95bzfZkKfgScxBICbAjH+5UAWCNfNryoRIJnvpOnfyMeq79OWuNeKhNBnt95HYqR8KuTlYT/lQuKYjaF8xip5ZRoptjk8fnNN9556iT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753348626; c=relaxed/simple;
	bh=PzAImXvw7ltOkAeF9aE1vYSBycD64FXcVdqDkDZASUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VjZ0Cs9FKFD3eBulNlMV9zO3XgxYny5Vql9kCCNjrToZQasj8vYjBOfjhHt6iel03c8JKDgR0GiOfLS6L9kIUpXU2yaYkva8TqW5k5mMFDjkaoQyh831654g4xLO7HaS5WWdTe3ivmEUI0hArxWMcYl5WVEGx6iSax9m6F+zE6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=CfDQOpDG; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CfDQOpDG"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-558fa0b2c99so605315e87.2
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jul 2025 02:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753348623; x=1753953423; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PzAImXvw7ltOkAeF9aE1vYSBycD64FXcVdqDkDZASUk=;
        b=CfDQOpDG7+H+rT4gcjxVG7nzL72tk82jIG1UHBBO6Be6KGFhDBbZJ8nSvH5RpDu+4W
         PhPhs0uFjfTJfcg3Dd/GGYRXi+YHgjZedHEcOGMbkyqaB14T4bCyZ+c26Ve1RhBXkzNJ
         Shk5METhMqgYWQyIaU1Eg7XI8HUByzQshRM18=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753348623; x=1753953423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PzAImXvw7ltOkAeF9aE1vYSBycD64FXcVdqDkDZASUk=;
        b=SU9BC3x/MxkLN9F1c2z58U1ZpMQKrkkm/ioVsn45+921OzXhCQkZE5ip9zu8EXcrEZ
         zFP+HTpp02QwdS2SJhuBNnvkjg8+qk0PIXHrkD4bqJ7m5fEutGiWm7IhljL/+8Eym3CK
         Pn3kgj/yjEMwY7bzWIFxlXBLiVihHKgFbLKd0iVOE59xAj+R+dJ4KPtTrBKI+96503mG
         caGmWVL1wMvV7nlQRN+85ih+xLIG3QZe5RaT3d3yR2q+Z03f/WhVWrRFni2+xjOMjnC6
         tUr6LlPRbwQvfTiQtlq8jJ4u25fFJgOmhZBmE79qV1phDog0ODmT46KT176RsIP+3/cQ
         fX1g==
X-Forwarded-Encrypted: i=1; AJvYcCUBCk5iiLfeIB+536ybfa1LcdoIrjH7KwwDdhudhic9RwpjAmHQKOvOcZMhyukP8Ne0QG4MSl8m8fFiTa4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3Bg+xbCzNKoHmeBHdpl4NatLwlOAo/XErow4LD2SSZKmKjIwB
	z/AvtyGg4lz7yQOeFQDZ5MVRyTT6fpYVWHpItBr9tYhfFZDBX62UwHDA/npBNyQNDsDxr5f60Sm
	J/2TB5WbdEdVS+JsN2xrgBHex98g2ewPFPrrgh/LN
X-Gm-Gg: ASbGncuD9t+ny2HxtuUw/na1eWgtQrEn+TyNWZH/Fki+S9sVNz1dSRbuGnc94H82pgX
	JDgpgbBDeDH3P+f67jT1iWBlSBgvvHjp28hnPRf12OLxqLEBnlzgEZ24bX8QgOKGfIUj0ol0b5N
	lJgO3Pz6jzt3+irSqykXZcGpBxQJZluum4kA0TtMdEVUlBDsO5ES6cK8WOzR25hbD7duz2plysz
	42Avze6ZZIkjJiAZzwAZ8pt7I8zLFHaxcNWB6Wh/XFleA==
X-Google-Smtp-Source: AGHT+IGEMdfa/7pI/vtQhZpE9t+GCiAKzWTtoHMGXUrvfqlTr4xGM3G4p6O55TyjazqugJ0Dpoksr/xy8ncvPcXnu9I=
X-Received: by 2002:a05:6512:3a84:b0:55b:57e8:16a5 with SMTP id
 2adb3069b0e04-55b57e81981mr94240e87.32.1753348622453; Thu, 24 Jul 2025
 02:17:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-3-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-3-angelogioacchino.delregno@collabora.com>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Thu, 24 Jul 2025 17:16:51 +0800
X-Gm-Features: Ac12FXxEOfXERpbm54RTrpt_sFAe6oyRhPRCsENRyO12HQ_K_abqIUXAGxmi264
Message-ID: <CAGXv+5Exb0X-6V=bdJefaz+m=eXSrrw6_SgWY6vDF3rF1RmVBg@mail.gmail.com>
Subject: Re: [PATCH 02/38] dt-bindings: display: mediatek, dp: Allow
 DisplayPort AUX bus
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
> Like others, the MediaTek DisplayPort controller provides an
> auxiliary bus: import the common dp-aux-bus.yaml in this binding
> to allow specifying an aux-bus subnode.
>
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
