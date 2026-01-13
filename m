Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C843921D6
	for <linux-crypto@vger.kernel.org>; Tue, 13 Jan 2026 13:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768312659; cv=none; b=tqL7Z1/uSouHsoKNr4yS2A/6OjJhYECxhHyoPCYeJGDZGA2h6IGFA3jy11movbm9bfFudwCkWYcxt8HEzPDF4+8mKp+VwPprJEZRePe1gwHgmtDQU18FFPd7Q+axrCbqR4Li7UFQfVQ5mV7Loc+FLh9MhhjdQOfsJ/oayJmduOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768312659; c=relaxed/simple;
	bh=yHQXt2lohILulwRHWO2PwdKgbtksvgC0OIilYDvkikI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U8Vkrrwc2gUZoE3OgN+Ce8Ay7RHdZ0trf9M+lMRBH4Qu/ODj/9pAGFfq+AxOo+/rvk6pklQrb3wgHlDzDnBCMQy734iJhMV8wyIioZelmfN6Sb2yQvnsN2+pDiarIuKkvQ/j1Wn8gGwTtI0TpejjlIG9MqdkNVxj2xogOnOwDE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=zvfoV53a; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="zvfoV53a"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64b4b35c812so12395882a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 13 Jan 2026 05:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1768312655; x=1768917455; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZYgsGgBKZshEd3LQPmk39JcNw7m/fhIkjkE+xKR+bec=;
        b=zvfoV53a8KKlvQ3d1JQNoqsn1R64meaL/N0gvJBVsP07IpubGxx2QfE84x4Z2+kbFb
         0hLYvrdv4SXvbje0qJL0Ne6nG9Fm0EboVzJAYkZUYQ9YLVSaQzuc2aaTV6Xaw3fXr4u5
         epRUQ8Rr1fmQuXUGhAgjyFhKoeU5fsg5c9fXZgvqcAaQm3999ZjhMx1Bh0O7IukctDtr
         cxNCZsPNksEYEPV48GWIxa6MuU7QzPugngj62cv1/mZlpNlETWTREwFO8KHkhEamhwC4
         prCUxmFrHMkgeYCQCIr0xyrmQWG7B2ZuuAVRPrT+1i5F97N3cJr9JI7d5M8HP9SZcOFn
         Uf9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768312655; x=1768917455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZYgsGgBKZshEd3LQPmk39JcNw7m/fhIkjkE+xKR+bec=;
        b=GOn5nN4kXlAHe4T9iN5AvbpHuWz4u5qNoA8lyxyGwU8iJ3+yq9IABFJ367Zi+tscSp
         lya+7kdiTDiDx2Qi8Aryy9C2ggxJM3Jcq2Vqd1dMYTRPCVpFPA1zSEOjTlTR0GfDYhB/
         5MR6nLGpnNf0NfkZW1CR7Xt1rBkeTzzOc172B4Wz33w+s5NnoXP7UxGDnRQ+yrzIlfCD
         xO9E42NJ7pOKIu3dAMWDeZN3Oka/lRJvUXJZxHnEWVM5PeLqq498V8MVQuHmHoZXfaU3
         xXPE660KAzTU4bDzOO26IDkAvMEEF1cSpBB1KUqSVHzPTOBYHiJk84QDNId4ligl0/QV
         CKyg==
X-Forwarded-Encrypted: i=1; AJvYcCXZ/kg8823nXp5RsmqQVqlQxdhtbhBlCHKeG66ssw1Ms5JcUgLE4KHiDYbSQ4LxrT9pxQvF90k0a1TYj7U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTtmzeObd0Xy/Mp8vyUPxonWjS+pzwx/Fz0koR9MysGIbPEjU6
	qMXdfGhmqcOR9wVyH5B0tdnIO9Q8EUM7aPt7MSO3M9jE01WoHeyx6Zv5lCFWKUyjZFU4RoElox+
	84tG1/XyDntgPTGJtppcTgErLNE0Tc5mnq4BqEeUC0w==
X-Gm-Gg: AY/fxX6vrpd6X5rmxeMbQn1XKg+iNR3sKghtRxkfuqipqDcuPn++8QhnCUD/yAdBhGz
	xvfcyoZQ5YXbkcRBgvu+to7PAIBZJH4+GjMyRkBgcbmu66+H8N7igvOHPpcLdFzHTJNPtf4EooL
	2JDxcNn8sybeyRmzwZkedsoyHH+JB/6egkheANRR8b2qL9e0ATgs/Udq5xe/L3RASnB2KHvcW+f
	cdWZt7JH7wruXRcAZyrDTB9nUMoCbBf00yicmSh+oh+JC1FBht5s8Pg3DrxJzwdkR0To565xXAV
	TJp1bhz9F0+2dGsl2Fe2T+Zm7M2OWlAu4fh+oFHG7GsxxzP1FQ==
X-Google-Smtp-Source: AGHT+IHC69qajNN2R0Oc5VosMApQk8dB2K8/wIPuNuXO4ULHt0+4HajErsuy6Dkjt1+pDa9ixvBw3NRLu/Pa+AU8sC0=
X-Received: by 2002:a05:6402:1e8c:b0:640:e75a:f95d with SMTP id
 4fb4d7f45d1cf-65097dfbd5bmr20646641a12.15.1768312655296; Tue, 13 Jan 2026
 05:57:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251229184004.571837-1-robert.marko@sartura.hr>
 <20251229184004.571837-13-robert.marko@sartura.hr> <2cdac084-4924-4ca2-85d6-2e6d9bf284aa@tuxon.dev>
In-Reply-To: <2cdac084-4924-4ca2-85d6-2e6d9bf284aa@tuxon.dev>
From: Robert Marko <robert.marko@sartura.hr>
Date: Tue, 13 Jan 2026 14:57:24 +0100
X-Gm-Features: AZwV_Qh0sAc6Pa2O_93Ow3lA3FmFDgK6_SoYiCOhp74HuwfyLgAjJuCjbp6xbBo
Message-ID: <CA+HBbNH4q8o-4Jb=hu7JgE4emxFxktFSLHdfY4J6gCDbYTpWUA@mail.gmail.com>
Subject: Re: [PATCH v4 12/15] arm64: dts: microchip: add LAN969x clock header file
To: claudiu beznea <claudiu.beznea@tuxon.dev>
Cc: robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, vkoul@kernel.org, 
	andi.shyti@kernel.org, lee@kernel.org, andrew+netdev@lunn.ch, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, linusw@kernel.org, 
	Steen.Hegelund@microchip.com, daniel.machon@microchip.com, 
	UNGLinuxDriver@microchip.com, olivia@selenic.com, radu_nicolae.pirea@upb.ro, 
	richard.genoud@bootlin.com, gregkh@linuxfoundation.org, jirislaby@kernel.org, 
	broonie@kernel.org, lars.povlsen@microchip.com, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org, 
	linux-i2c@vger.kernel.org, netdev@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-spi@vger.kernel.org, linux-serial@vger.kernel.org, 
	linux-usb@vger.kernel.org, luka.perkov@sartura.hr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 11, 2026 at 3:42=E2=80=AFPM claudiu beznea <claudiu.beznea@tuxo=
n.dev> wrote:
>
>
>
> On 12/29/25 20:37, Robert Marko wrote:
> > LAN969x uses hardware clock indexes, so document theses in a header to =
make
> > them humanly readable.
> >
> > Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> > ---
> > Changes in v4:
> > * Move clock indexes from dt-bindings to a DTS header
> >
> > Changes in v2:
> > * Rename file to microchip,lan9691.h
> >
> >   arch/arm64/boot/dts/microchip/clk-lan9691.h | 24 ++++++++++++++++++++=
+
> >   1 file changed, 24 insertions(+)
> >   create mode 100644 arch/arm64/boot/dts/microchip/clk-lan9691.h
> >
> > diff --git a/arch/arm64/boot/dts/microchip/clk-lan9691.h b/arch/arm64/b=
oot/dts/microchip/clk-lan9691.h
> > new file mode 100644
> > index 000000000000..f0006a603747
> > --- /dev/null
> > +++ b/arch/arm64/boot/dts/microchip/clk-lan9691.h
> > @@ -0,0 +1,24 @@
> > +/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
>
> Shouldn't this use the same license as the dtsi including it?

Yes, its a mistake on my side, will fix it in v5.

Regards,
Robert
>
> > +
> > +#ifndef _DTS_CLK_LAN9691_H
> > +#define _DTS_CLK_LAN9691_H
> > +
> > +#define GCK_ID_QSPI0         0
> > +#define GCK_ID_QSPI2         1
> > +#define GCK_ID_SDMMC0                2
> > +#define GCK_ID_SDMMC1                3
> > +#define GCK_ID_MCAN0         4
> > +#define GCK_ID_MCAN1         5
> > +#define GCK_ID_FLEXCOM0              6
> > +#define GCK_ID_FLEXCOM1              7
> > +#define GCK_ID_FLEXCOM2              8
> > +#define GCK_ID_FLEXCOM3              9
> > +#define GCK_ID_TIMER         10
> > +#define GCK_ID_USB_REFCLK    11
> > +
> > +/* Gate clocks */
> > +#define GCK_GATE_USB_DRD     12
> > +#define GCK_GATE_MCRAMC              13
> > +#define GCK_GATE_HMATRIX     14
> > +
> > +#endif
>


--=20
Robert Marko
Staff Embedded Linux Engineer
Sartura d.d.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr
