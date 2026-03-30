Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287A23D5221
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 13:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774877626; cv=none; b=CXR0yvfPJ0XOpHMoDyIhjjeusAA10N0vAc7/7ymzMJzT3DiJCP6emv8m0Wng2MrCHvpyob3yJAnhpT4lNxs1ehIUCFyw3AKqB5rI+sTzA55z++hEmnk8PTxXA9FY84SwYF7TgU8W0o+ODqlXiEH5kz6Rp4twds7yjB92zBsHcMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774877626; c=relaxed/simple;
	bh=/kxWTA52BAt2g4WnQqRpqhpA4ac3KQhFlNL2rViCQp8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rl28x8jFz1mMf8SFjCAsRyoLVzQ7wXHKA+/ySAc/yTGqJZHBNYyTF6E0Zh4WelK2QYYeJq6m3V/j62EM7ljDWzQYZYS0yhL1kUfl9azfvjP4p7OU81o9HXR6y9jZM33XQqxlwsMCjC8sWA+u7HZByhT7+gvGd0o3OFqZbi4pWvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-94e2ad66abcso1329735241.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 06:33:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774877624; x=1775482424;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JCelPAg5TqeEG1G1zPAvcyqOUxcgqEhU8AXcqqEt3aI=;
        b=q8q2g9KiDeVitKASOchr06J/KloUL7C0o7INN4H5j6ja+KMUZsZKsJlpdsCgX0NTCt
         KbeR5V/WIIimD3NyfJJDlRAMg6i/TTtIjmvJc+JxvS87sjHvzpdZpZgvH0NoLg0KnqVH
         PcIznBVo2X9ExcRBErBaNwWVgebH/rGa6ORkio7seqRNVGKCxFXnEK6DVGng9oh81m9o
         p8wjqgud6+afQ9F1aObtufvH0DurHNgPGMW+X9sySQER3IzviXVnKv4Eorc05P0gIU/N
         dqWHjDqR4BaUTNZuWD4HVXJIdZpFphwWebm0Ng+yPjToOK1dWhH9eVQwlTbxbWAPrRt4
         NwFw==
X-Forwarded-Encrypted: i=1; AJvYcCXtDOf+RgNZlQ+ERcb5kYwuof3hkFr+xcD20HJv6nQAJG3Tt9a1P2zl2VnSUbLuEmZlXnqJketbr+m4lF0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr1pqsE3S+4V+J+tYypv9cofwtkD0DnagxhsV+aGGYiib2eCwt
	ILROae/FOpx+eNDf6aSTfASDszpR6afzTVde5qC9Amp3w4gc4MmYO8PUBopLAzml
X-Gm-Gg: ATEYQzx6CbQzseLqMih+N0RKTS9WB48U8PCXQ/Ru64MGQ3esQn5r283dyf/bAut6PhK
	UGgHAbHUE/OXxxFK1mZYvsD87cgqWqt4O55ss1tVRX+T/70UiemQOCPNHHWI1aycO2ic2Wl3arW
	XRC26iZa/D/9AMLOkIkBcHsLeasOlzeIq894+kbmiTpSigroR4G/HSd5g5btGyFbKW+s+bFSq6b
	4F3OZ9DFN68N6fF14MjwsmBzwh5OUzYBJdBah5IOpUK7U1kQiLmSIJQhlR7IhUCNgzU4gy6+T4A
	Zs9P9mRl8G3KYI0K7Hv4sX7WAK53/xH+L6fUj5K4ZNTp+i7Sg0JvBOAUhdNdPIOkktkdC5LCdtp
	IHZf/BtPcWQPNl6CrBQ96XB8E23vVOr9EaATBDNf5PL7nA4U1o84viV/wp6zz5ovBga5LAXLv0M
	ea9GuVn+Lmwh7kki/gpZ1uW3zx+PpC0yItSaLp9M5rpBJcj0/6caPU85RrFQKqIlE4MjwCljY=
X-Received: by 2002:a05:6102:38d1:b0:5f7:240f:bbee with SMTP id ada2fe7eead31-604f904c9cfmr4014932137.1.1774877623997;
        Mon, 30 Mar 2026 06:33:43 -0700 (PDT)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com. [209.85.217.44])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-60512a4eb23sm8110026137.5.2026.03.30.06.33.42
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 06:33:42 -0700 (PDT)
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-602903ad849so1542403137.3
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 06:33:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWH7NgtBHLgySMfaqecwYDnvI08WQS1JeVaKzaJSWcEa3nEwumlBE0iHJmNEkXEiytA5P0iPx3PFnIgFMY=@vger.kernel.org
X-Received: by 2002:a05:6102:2b85:b0:605:26eb:cc1a with SMTP id
 ada2fe7eead31-60526ebcfa6mr1670554137.29.1774877621873; Mon, 30 Mar 2026
 06:33:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
In-Reply-To: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 30 Mar 2026 15:33:30 +0200
X-Gmail-Original-Message-ID: <CAMuHMdX23LQYFFzs9STykFVECb4uv1u3DmEMCh453GBK=4XbYQ@mail.gmail.com>
X-Gm-Features: AQROBzDj9P2QcJJ03rVKxKEo5zx-Wow-J_zNYCm0-1wsBhaAiKvmNzwG6-mGiTE
Message-ID: <CAMuHMdX23LQYFFzs9STykFVECb4uv1u3DmEMCh453GBK=4XbYQ@mail.gmail.com>
Subject: Re: [PATCH 00/16] Add support for Inside-Secure EIP-150 crypto block
To: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Jayesh Choudhary <j-choudhary@ti.com>, 
	"David S. Miller" <davem@davemloft.net>, Christian Marangi <ansuelsmth@gmail.com>, 
	Antoine Tenart <atenart@kernel.org>, Geert Uytterhoeven <geert+renesas@glider.be>, 
	Magnus Damm <magnus.damm@gmail.com>, Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
	Pascal EBERHARD <pascal.eberhard@se.com>, Wolfram Sang <wsa+renesas@sang-engineering.com>, 
	linux-clk@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>
Content-Type: text/plain; charset="UTF-8"

Hi Miquel,

On Fri, 27 Mar 2026 at 21:10, Miquel Raynal (Schneider Electric)
<miquel.raynal@bootlin.com> wrote:
> This is a series adding support for the EIP-150, which is a crypto block
> containing:
> - a public key accelerator
> - a random number generator
> - an interrupt controller

Thanks for your series!

>       irqchip/eip201-aic: Add support for Safexcel EIP-201 AIC
[...]
>       crypto: eip28: Add support for SafeXcel EIP-28 Public Key Accelerator

My OCD tells me to ask for using "SafeXcel" consistently,  ;-)

drivers/crypto/inside-secure/eip28.c: .name = "Safexcel EIP28 PKA",
drivers/irqchip/Kconfig:        tristate "Safexcel EIP201 AIC"
drivers/irqchip/Kconfig:   inside Safexcel EIP150 IPs, gathering
Public Key Accelerator

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
