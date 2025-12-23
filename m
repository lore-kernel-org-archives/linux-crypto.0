Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F9434F24D
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 15:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766503779; cv=none; b=Ip4LiUMDIW88fqAbp/8ZRIoffLLb1lWcgKvE6kOkAAMuQSl9PxlytB1VQWrZP2506REKnfgkU3wnoaRzT6dBoKbGX67K+XaNoJIIG05ACUb8q7nwItDL8BvKcWnwG9H35fKwRbO1jxUHsYjIBVWnGVzwNkDSXqAoMdZE9UDK9iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766503779; c=relaxed/simple;
	bh=UJ4a8K9wry/JPIeGH5DwpGba6bA4R4gax6qub7x2SY4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uuhjHWMaxXcoCXHavqtD1NFBQETl5MnY75XU7fkeoOYBlv1J8/Anhfun9twYNW1NoSgLZ5pgxxsq61HWPMHWKZNZWmic3S6d0mDSahX189VrIV7gSurNT1PiDTV4Hfr7dWJNM0dskDyCBMkqEBSgIfTZGGULnBq1UwlmZM/dBxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=lDOkL1Fy; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="lDOkL1Fy"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b7ffa421f1bso1055613466b.0
        for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 07:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1766503774; x=1767108574; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cLjISIOInag6cJNCp9GAXmtvydDuwUZOD3O+6EuGMpA=;
        b=lDOkL1FyHZFJ/9/OvPdkMyYxnkNuTkuKFAJlUBUCP6HN0MqcClWvGh955PsXfCG+TE
         XTJ9K//mvDtqzzy+8UpL1y6RStVl9cIPSZrvePcdWuCn+ocgGrIKDtG9+54W1w2//ou8
         OA5XU6YHOGYGLPwmx49l4TBtdurcyXq+U5KGyoNvmaVZMCeozr9d58t7zZ1j+zZEQDsh
         Kf3pekwyW72hmnLuSoSmitxCpGyWf6IWLHLSubohN8Q1uFEJ0jlLdVAnxp2afKolq/Di
         Hpo3XANTXWdDsDg7UaN6dPqi5wLfeRPeuisBuru1875FAqqqDaYDIxgxJJ2SJLG7SJGQ
         +dlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766503774; x=1767108574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cLjISIOInag6cJNCp9GAXmtvydDuwUZOD3O+6EuGMpA=;
        b=AjK6k/jk+npJPsPvL5Dr/DjcNxbroFJerWEGSlKfRSa/5+RvUpYd5+BalY6Jxi+/40
         zHrEEQ1btM7FR8JVFhgQw0yiad8w5CE4rZCf/2N6GDi5EXLgtrdudK5tPcrBrw0un+xa
         +KhqZU3V4s2OO8xkbVLJIzw3UY/fnjt2u5FOcN9dcSngo0Z3BNFqTtemw8L7x1KiO1g2
         PupTy0hBwEAmgBtlV27UKReOALM3zK1ZV8ZO5Ux9/BN96kXNPj3TVd6kCZZSe+NQiobw
         7rCDvRY8YuWvCDBxUZNS+u/I8DJ90ep8d3iTLyDGcFQSYiqeT/ciAjhFSI/ID6/9AG6s
         aTAg==
X-Forwarded-Encrypted: i=1; AJvYcCVCuyzRMaLRi7ZnleFgi7uweRM+m0RwffJQFE/thpr4q1CrTR22K7uZAGg37ewfJ5oJl7DlvzXCXWvnsxI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX5zvM7b4aHpya8jxR2w5ZptnWUCcLdgzvfNoAd6RsjNIeuG13
	1Fr9qaPhcSfAIe+EptBR+lKZdIlWqCtzer9ZP7DaCKNP9Kt7fTNWhQyZohEhouaotph0gMO4enX
	2YbBEA6SarWLAHJ+Ic9gUJx+gQwZKcemEq38nRcHAcw==
X-Gm-Gg: AY/fxX5Sbhv8njqBE4NvrKtY6NozD9c4z6ZeF4VByyuV/JBfdV42VEda6G0YXNre2tQ
	JM947uyDVn2QId0AUb+fcjAxIkR9XySECfaya6DXXRuvyAKHauKbvLO34a6oagHGO6oeTcXwPh4
	LQ9dGS/MIR7O5CIc7C7gS3aScNfCfkOyJPsqxYFDsHWfdFL21jNpTX0ay8pX9Gs1ysm8YCpNmbv
	0HEIe4UJQ89ryR7xYDMEUL94zClicmQxWVuyZpHEAnT/8CVwmd11yZ1hO0cIlcDN3gnxIOxvJF/
	O9FYK5lo1liQNrb3oW7FTaC9cKl0sCQJYInp1op6aAJxeFcS2g==
X-Google-Smtp-Source: AGHT+IE+xxKz9WunQGu5xp3nWvZrKUFIZLNano4iauMvK7wBVyl981tNBySUR5mcD+g4BmTew6KluXuH/rQplznm+8E=
X-Received: by 2002:a17:906:30d4:b0:b7c:cc8d:14f4 with SMTP id
 a640c23a62f3a-b8020400995mr1538956066b.4.1766503773539; Tue, 23 Dec 2025
 07:29:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215163820.1584926-1-robert.marko@sartura.hr>
 <20251215163820.1584926-18-robert.marko@sartura.hr> <20251216-endorse-password-ae692dda5a9c@spud>
 <CA+HBbNF-=W7A3Joftsqn+A6s170sqOZ77jpS105s5HPqkskQzA@mail.gmail.com> <20251223-chrome-simile-8cf1e9afe155@spud>
In-Reply-To: <20251223-chrome-simile-8cf1e9afe155@spud>
From: Robert Marko <robert.marko@sartura.hr>
Date: Tue, 23 Dec 2025 16:29:22 +0100
X-Gm-Features: AQt7F2rjEyMDZrOpK1oplok3NPPf4ZxKJg97_UNzU27UIMOHDSKt5OOOHzhM_mA
Message-ID: <CA+HBbNFhVVoaiVJtH-fB3Wmeh6O3C_H=bwz2vBDR2MO4o0qy_w@mail.gmail.com>
Subject: Re: [PATCH v2 18/19] dt-bindings: arm: microchip: document EV23X71A board
To: Conor Dooley <conor@kernel.org>
Cc: robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, 
	claudiu.beznea@tuxon.dev, Steen.Hegelund@microchip.com, 
	daniel.machon@microchip.com, UNGLinuxDriver@microchip.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, vkoul@kernel.org, 
	linux@roeck-us.net, andi.shyti@kernel.org, lee@kernel.org, 
	andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, linusw@kernel.org, olivia@selenic.com, 
	radu_nicolae.pirea@upb.ro, richard.genoud@bootlin.com, 
	gregkh@linuxfoundation.org, jirislaby@kernel.org, mturquette@baylibre.com, 
	sboyd@kernel.org, richardcochran@gmail.com, wsa+renesas@sang-engineering.com, 
	romain.sioen@microchip.com, Ryan.Wanner@microchip.com, 
	lars.povlsen@microchip.com, tudor.ambarus@linaro.org, 
	kavyasree.kotagiri@microchip.com, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org, 
	linux-hwmon@vger.kernel.org, linux-i2c@vger.kernel.org, 
	netdev@vger.kernel.org, linux-gpio@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-clk@vger.kernel.org, mwalle@kernel.org, luka.perkov@sartura.hr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2025 at 3:43=E2=80=AFPM Conor Dooley <conor@kernel.org> wro=
te:
>
> On Tue, Dec 23, 2025 at 11:34:55AM +0100, Robert Marko wrote:
> > On Tue, Dec 16, 2025 at 6:32=E2=80=AFPM Conor Dooley <conor@kernel.org>=
 wrote:
> > >
> > > On Mon, Dec 15, 2025 at 05:35:35PM +0100, Robert Marko wrote:
> > > > Microchip EV23X71A board is an LAN9696 based evaluation board.
> > > >
> > > > Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> > > > ---
> > > >  Documentation/devicetree/bindings/arm/microchip.yaml | 8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/arm/microchip.yaml b=
/Documentation/devicetree/bindings/arm/microchip.yaml
> > > > index 910ecc11d5d7..b20441edaac7 100644
> > > > --- a/Documentation/devicetree/bindings/arm/microchip.yaml
> > > > +++ b/Documentation/devicetree/bindings/arm/microchip.yaml
> > > > @@ -239,6 +239,14 @@ properties:
> > > >            - const: microchip,lan9668
> > > >            - const: microchip,lan966
> > > >
> > > > +      - description: The LAN969x EVB (EV23X71A) is a 24x 1G + 4x 1=
0G
> > > > +          Ethernet development system board.
> > > > +      - items:
> > > > +          - enum:
> > > > +              - microchip,ev23x71a
> > > > +              - microchip,lan9696
> > >
> > > This looks wrong, unless "microchip,lan9696" is a board (which I susp=
ect
> > > it isn't).
> >
> > Hi,
> > No, LAN9696 is the exact SoC SKU used on the board.
> > I will drop it in v3.
>
> Instead of dropping it, this should become an items list with 3 consts I
> think.

Ok, that lines up with what other boards in the binding do, will do that in=
 v3.

Regards,
Robert



--=20
Robert Marko
Staff Embedded Linux Engineer
Sartura d.d.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr
