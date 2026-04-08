Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B9E36D50D
	for <linux-crypto@vger.kernel.org>; Wed,  8 Apr 2026 08:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775636015; cv=none; b=G3YpQe6d3LfSgYCuEJH09qnGGvxFSs1UkHPew+ulQNb6S2heF4H5f+mJu+T52AjHFv7UUJqTclWztAm2onvqAlnYAm/Ebr4iUbAupqhZl66iaIgdaEiSkwc2ipoV+yZTXsMZDsANQW+DpHeSvHD4jrtDGxK9pAaGHS1EQfu7LJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775636015; c=relaxed/simple;
	bh=OO8/V/ieRVIAY7OerP7B4Q+EVWmrnJ0uFfqR67sUp4A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fbzMe8Tnu9KfPNt8U6tN6H+xgWuauUhYsfZUUbSRrWsQLHWciUKxlYVF0hzFuq7BNNrf0G4a5dChDDFMghrfAJ9uQdvos4aT1ir3tSvEhiVL+uOMp3zh/D1GRU6Y/C4nrzxcIUDl4fle5xnCVi42mXt5RY7kA/SgUSpZhi0Cmi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50d87c138e1so36113371cf.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Apr 2026 01:13:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775636012; x=1776240812;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9UVrHD1kGj3aaIesoTisHRRJzYnLIrQ82+sB6XN35Xo=;
        b=aNhXi9gOYfS0b4VZOSCft+VKjsBWeisk8F9yfDozhu3OsDyW0BEJ0IHaLfvM9glF0T
         IoW35PGPUeyNraagvoroEvdQKE/5kgsHvcqf5xxrCoAx3/xTj0aLXmFwYIxA+oev6+U4
         oY7QJ62Qxz/eC2rdzEdYKhzNW2YusuY0CbG0RN+4lxfoUd6EV8PDjZOFkej83M2VTUJL
         gsBFNMFSl9GAeuM6czrPrmZutRRFzM9irZH1dagRrOZLFViWGm0ZB7EYtpiFI0iMKUlN
         raVhrN6pyNRQf4a3LGyYz3oVubTd0SDarwvWQSpw0gG1QGh1EtOs/m+X2CZ3SaiCDZtr
         nHag==
X-Forwarded-Encrypted: i=1; AJvYcCVeI+Geb2Hma/bYgCDMNWTI4JvRuVWZoOAuY/v46S8Z9GNn5iYmP6kos01GYScjGbISQgNMS8ODo92kSxw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu0WN4Zev0v7LnP14+ShyF/muC/8rChM3Ims75yZdLKXntkBeC
	lC+ihNKFxCEjnDpRo7bDU1FASf8315CoCLt79Bb1F99PoivH7TbduXT7GWC1Vilj
X-Gm-Gg: AeBDievyars6zSmuJJO37GWGLC1x+kVa/ChZq1ZcuDBTMnfg9+ougnpm6mke1I7yjS2
	uGTYAAcvD2QAAomTwbuH6wy9Ri+OaTDZH6EUrLCpQFglX8lV5tM2huq2VPwOl4f4rZjGN1TjNUn
	B6Tl/plKZsIKV/P4l5nypgmglowR+KIdinY1hKGHG1uM5HxipojB/j/CTCNbpAGY/5UHZxSci2j
	FsD5yF3T7g/NhMZO5FPIEjwTRwnMhjrn9EJXfeOHstsR2vY+goPoxI/tpwKiEn7M58gZaCbWws/
	d3r3wNs+ntOV+cmtJGylV7HveuZVKlqir3WaB3748idKcg6Tr6JLPObVr3cmNt16ZXbw8MLBnys
	c+XP9cgi4p0YRfCvhXXlxASQduir734Bp/gknO/4ayvVNgQswrZHxUUxAZ4rZeqAr8/yqInRLv4
	agcs1yK0wYf4VhIBkfC7rIHUuhcOaVJ5g6yx8EdRxuNbXPYCoD0jo/G0UnhFzzibaq
X-Received: by 2002:a05:622a:2511:b0:50d:8960:d68a with SMTP id d75a77b69052e-50d8960deefmr183390481cf.43.1775636011970;
        Wed, 08 Apr 2026 01:13:31 -0700 (PDT)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com. [209.85.160.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50dac753208sm23028821cf.20.2026.04.08.01.13.31
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 01:13:31 -0700 (PDT)
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50d87c138e1so36113231cf.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Apr 2026 01:13:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVsRpXkJnpUY5+1cKeo/bavx4WvzH3RcfVSjDolYJ3ZmMmKgi/S5NebXD76DbNSXsAtxW5QQSK1ZZNTzTo=@vger.kernel.org
X-Received: by 2002:a05:6102:5486:b0:602:ac40:969d with SMTP id
 ada2fe7eead31-605a5125dbemr8047885137.30.1775635529642; Wed, 08 Apr 2026
 01:05:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com> <20260327-schneider-v7-0-rc1-crypto-v1-12-5e6ff7853994@bootlin.com>
In-Reply-To: <20260327-schneider-v7-0-rc1-crypto-v1-12-5e6ff7853994@bootlin.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 8 Apr 2026 10:05:18 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWr5OT0iAbZMgDAizO9KnhmyUN3hsqFnp+JYRao4aKu_A@mail.gmail.com>
X-Gm-Features: AQROBzB7FKSpqL9vAEkvQ3NeO0nTGrKiA5rUbk_QvEvIe1vD5_FZ5lwMa_3wMnk
Message-ID: <CAMuHMdWr5OT0iAbZMgDAizO9KnhmyUN3hsqFnp+JYRao4aKu_A@mail.gmail.com>
Subject: Re: [PATCH 12/16] irqchip/eip201-aic: Add support for Safexcel
 EIP-201 AIC
To: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Jayesh Choudhary <j-choudhary@ti.com>, 
	"David S. Miller" <davem@davemloft.net>, Christian Marangi <ansuelsmth@gmail.com>, 
	Antoine Tenart <atenart@kernel.org>, Magnus Damm <magnus.damm@gmail.com>, 
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>, Pascal EBERHARD <pascal.eberhard@se.com>, 
	Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-clk@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Miquel,

On Fri, 27 Mar 2026 at 21:11, Miquel Raynal (Schneider Electric)
<miquel.raynal@bootlin.com> wrote:
> Describe the EIP-201 Advanced Interrupt Controller from Inside Secure,
> typically found in a bigger block named EIP-150. This controller is
> rather simple and is driven using the generic irqchip model. Its
> own interrupt domain is limited to just a few interrupts connected to
> other inner blocks, such as a Random Number Generator and a Public Key
> Accelerator.
>
> The one I used receives only rising edge interrupts and uses its own
> logic to track them. It is theoretically possible to wire devices with
> level interrupts, but not in the context of the EIP-150.
>
> Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>

Thanks for your patch!

> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -826,4 +826,12 @@ config SUNPLUS_SP7021_INTC
>           chained controller, routing all interrupt source in P-Chip to
>           the primary controller on C-Chip.
>
> +config SAFEXCEL_EIP201_AIC
> +        tristate "Safexcel EIP201 AIC"

Is there any platform dependency that could be added here?

> +       select IRQ_DOMAIN
> +       help
> +         Support for the Advanced Interrupt Controller (AIC) typically
> +         inside Safexcel EIP150 IPs, gathering Public Key Accelerator
> +         and True Random Number Generator interrupts.
> +
>  endmenu

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
