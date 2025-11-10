Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C6C220F21
	for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 08:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762762528; cv=none; b=VyzfQTMKTZMWG3s4N9WqmGGqi9YZ/tcOPpDW6LVvZJsy6+4AkRQdUgAapCdgzTq61KJL8MWfX3ZCVDxAt0PkHYldKZ9e/9fgy9FRDQ4dS+R3cFW7+o2XBGrivXKlS7BwWn+qlTXE5xCAvOwLg1WDqCqmSIgQXeLhRSSIZtXfk5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762762528; c=relaxed/simple;
	bh=0IoT4ilGrJkMrpqNcFCGUzEh7/+yoZb8/QXVGlKBPVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bI7cImXxeVSMD3zxQh1CMQVa2PWWfBiP2Aye7spxhELKJI5W6wXUqPaSAEGXi7vjzCFXVFYeZcIzjkSMvaRePJSkb9dwvbL72RAhiulEOkLUH0k8Xf/zpN14msGOPf89WhhhGwAPGN5eOP/PVkksgEvFGddhCIHxS8ZClBaijjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-9372164d768so1221075241.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 00:15:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762762525; x=1763367325;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oLRDHES8x7hy2Cq6bFhMakeR+ZtfEVkHELo4BsFny2w=;
        b=w3n8YNDpJVvva425cVOgl5WiT2oovDDOSjL+GZTaJ1pG9s0EX6GSNJ/57HismFtO7r
         dZRjCOAVCVUSUR6zNg66rCJgmlK7N+OJgj1pUw4LewOhFL92tfOTKbU09HVthLct8ktv
         w/3lbqDDNZGCATAJ7kdym9UFYrl5owBRjfXYZQ3/bZphHsYGTkJCdUpFXijuS7bKQnGe
         BwCrshigB3TMBeHDhu9dV9gWo2YoQ//D/U7kjxOi9VKgueyComY1xs8WgC0AJ7aJIhRD
         51xLfph2nF2M57z7uF5sq/EyctjS9ILQ5acOu5apG9icE3zoGxm/W44FAUvmD8JL/KO4
         TvcA==
X-Forwarded-Encrypted: i=1; AJvYcCV58WagEBy5TFly33plvDx/oCMMD/piwchodGjOoAPL1YKJa06WAH8Q2MczP4uq7s2Zh0Y5FgNOvFkK0rs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJZpfjVbWYMpF96Hlrg8Uz6eLAnTATfPk/19QyUGDpk1nluJ8x
	FRokNMeP8e+pfgZbvuIqyJXP4i7QDrunfXBERUzXAs429gYWAGFX7toRbzWptrPG
X-Gm-Gg: ASbGncv/mg5SGwtCDxZEc7bj4K6ygFNP4sU8yfQEPKdnfQ6nRU8kg4bhlnko/+5s1of
	RjfOJNnUnSDH4D/YNDf3mkbGgTPjENtUPHb5HszDhBIq0jQ4+K+beN0H9z41opfRhEFEgKnDZhE
	bPu7ZllfL/hom1L9JPKFKVq86B6KmGs8RMO8XXSOrDdza2IHGy7Bfm49gMRX+NkyT2Rr7QjkucK
	yKUjiuPYtW1qEumCpylaCph4gxxUoRCB2IF9L4NyUWOcQ2vSGDARemCWWsK133yaQpfO7zcKZGA
	oHWiln6wBwCBNgyrThmy5yvwcVbguj0K/FkMt28rkIxpT3hGJlbTTJ1Lyj94j5PLnRny9UVpKDJ
	Ijez3X2JmhzJs7zSoa7ehdUulr0iTgBJxabe9QPHW+z7uaDKhVpd6ZRO3vcGSlA9B2dcf+7E/+q
	HDxttQSABeeG2P5A/4tFtsPMATMVdAHiVb+WOqqOEJCQWBrCNw/Vjm
X-Google-Smtp-Source: AGHT+IEVXlHwQx+9YhXgomEVDmeDEFzyiRhdZK3A9vtWirGXNyEmueK46nlqJYKtKSzZMZ5Qin05Fw==
X-Received: by 2002:a05:6102:290c:b0:5d6:85a:229f with SMTP id ada2fe7eead31-5ddb9dd43fdmr3515607137.15.1762762525070;
        Mon, 10 Nov 2025 00:15:25 -0800 (PST)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com. [209.85.222.47])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9371f1db21fsm3530899241.15.2025.11.10.00.15.22
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 00:15:23 -0800 (PST)
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-93539c5e2b5so1591130241.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 00:15:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXsHngH+MSXRA+hkLZVbX+nsBqXis93DmDGch1c+1Erd0cIOYKUsPxXKL1zH4dGHWc7E2aDlCRnI3FlpCE=@vger.kernel.org
X-Received: by 2002:a05:6102:c8e:b0:5db:e179:1c2f with SMTP id
 ada2fe7eead31-5ddb9e00ddbmr3016566137.18.1762762522544; Mon, 10 Nov 2025
 00:15:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251107-b4-m5441x-add-rng-support-v2-0-f91d685832b9@yoseli.org> <20251107-b4-m5441x-add-rng-support-v2-2-f91d685832b9@yoseli.org>
In-Reply-To: <20251107-b4-m5441x-add-rng-support-v2-2-f91d685832b9@yoseli.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 10 Nov 2025 09:15:11 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWL76hY-Pv30ooSM1J6XkVWbRXSLTDCjfpPOvhFN4tKyA@mail.gmail.com>
X-Gm-Features: AWmQ_bkP3DEy9lbUQUJXmebZYXL_ADR8ol219vUzw9saT-bIiR6N27eoovxyIr8
Message-ID: <CAMuHMdWL76hY-Pv30ooSM1J6XkVWbRXSLTDCjfpPOvhFN4tKyA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] m68k: coldfire: Add RNG support for MCF54418
To: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Shawn Guo <shawnguo@kernel.org>, 
	Sascha Hauer <s.hauer@pengutronix.de>, Pengutronix Kernel Team <kernel@pengutronix.de>, 
	Fabio Estevam <festevam@gmail.com>, linux-m68k@lists.linux-m68k.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Hi Jean-Michel,

On Fri, 7 Nov 2025 at 11:29, Jean-Michel Hautbois
<jeanmichel.hautbois@yoseli.org> wrote:
> Add platform device support for the MCF54418 RNGB hardware with clock
> enabled at platform initialization.
>
> The imx-rngc driver now uses devm_clk_get_optional() to support both
> Coldfire (always-on clock) and i.MX platforms (managed clock).
>
> Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>

Thanks for your patch!

> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -270,12 +270,13 @@ config HW_RANDOM_MXC_RNGA
>  config HW_RANDOM_IMX_RNGC
>         tristate "Freescale i.MX RNGC Random Number Generator"
>         depends on HAS_IOMEM
> -       depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL || COMPILE_TEST
> +       depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL || M5441x || COMPILE_TEST

Is the same RNG present in other Coldfire SoCs?

>         default HW_RANDOM
>         help
>           This driver provides kernel-side support for the Random Number
>           Generator Version C hardware found on some Freescale i.MX
>           processors. Version B is also supported by this driver.
> +         Also supports RNGB on Freescale MCF54418 (Coldfire V4e).
>
>           To compile this driver as a module, choose M here: the
>           module will be called imx-rngc.
> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index 241664a9b5d9ac7244f15cbe5d5302ca3787ebea..44f20a05de0a425cb6ff7b2a347b111750ac3702 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -353,12 +353,19 @@ static const struct of_device_id imx_rngc_dt_ids[] = {
>  };
>  MODULE_DEVICE_TABLE(of, imx_rngc_dt_ids);
>
> +static const struct platform_device_id imx_rngc_devtype[] = {
> +       { .name = "imx-rngc" },

I believe this is identical to KBUILD_MODNAME, so the .name below
should be sufficient for binding?

> +       { /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(platform, imx_rngc_devtype);

Or do you need this mainly for the addition of MODULE_DEVICE_TABLE(),
i.e. the module is not auto-loaded based on just KBUILD_MODNAME?

> +
>  static struct platform_driver imx_rngc_driver = {
>         .driver = {
>                 .name = KBUILD_MODNAME,
                  ^^^^^^^^^^^^^^^^^^^^^^^

>                 .pm = pm_ptr(&imx_rngc_pm_ops),
>                 .of_match_table = imx_rngc_dt_ids,
>         },
> +       .id_table = imx_rngc_devtype,
>  };
>
>  module_platform_driver_probe(imx_rngc_driver, imx_rngc_probe);

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
